//
//  Game.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Game.h"
#import "Environment.h"
#import "ForrestEnviroment.h"
#import "Mountain.h"
#import "Player.h"
#import "Dice.h"

@implementation Game {
    NSArray *environments;
    Environment *currentEnvironment;
    NSString *currentEventDescription;
    Player *player;
    NSMutableArray *fullEventHistory; // always has at least one event (starting with getInitialEvent). all events get added.
    NSMutableArray *eventHistory;     // must always have at least one event (starting with getInitialEvent)...
    Dice *dice;                       //                                            combat and unique events do not get added!
    NSInteger score;
    NSDictionary *selectorsForChoiceDescription;
}

#pragma MARK init

- (id) init {
    self = [super init];
    if (self) {
        Environment *forest = [ForrestEnviroment new];
        Environment *mountain = [Mountain new];
        environments = [NSArray arrayWithObjects: forest, mountain, nil];
        
        currentEnvironment = forest;
        // currentEventDescription is initialized in 'getInitialEvent'
        
        player = [Player new];
        
        eventHistory = [NSMutableArray new];
        fullEventHistory = [NSMutableArray new];
        
        dice = [Dice new];
        score = 0;
        
        [self initializeSelectorsForChoiceDescription];
    }
    return self;
}

#pragma MARK public methods

- (Event *) getInitialEvent {
    
    Event *initialEvent = [Event new];
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    NSMutableArray *initialChoices = [NSMutableArray arrayWithObjects:moveForward, nil];
    if ([currentEnvironment isKindOfClass: [ForrestEnviroment class]]) {
        Choice *gatherWood = [[Choice alloc] initWithChoiceDescription: @"Gather Wood"];
        [initialChoices addObject: gatherWood];
    } else if ([currentEnvironment isKindOfClass: [Mountain class]]) {
        if ([dice isRollSuccessfulWithNumberOfDice:1 sides:6 bonus:0 againstTarget:4]) {
            Choice *gatherMetal = [[Choice alloc] initWithChoiceDescription:@"Gather Metal"];
            [initialChoices addObject:gatherMetal];
        }
    }
    Event *eventModel = currentEnvironment.events[0];
    initialEvent.eventDescription = eventModel.eventDescription;
    initialEvent.choices = initialChoices;
    
    currentEventDescription = [initialEvent description];
    [self manageAdditionToHistories: initialEvent];
    
    return initialEvent;
}

// this method is the heard and soul of this class.
// it makes use of the selectorsForChoiceDescription dictionary which is
// initialized in the method 'initializeSelectorsForChoiceDescription.
// the selectorsForChoiceDescription dictionary matches choice descriptions to methods
- (Event *) getEventFromChoice: (Choice *)choice {
    
    // will be populated (or not!) by some method
    Event *nextEventModel = nil;
    
    // we will eventually return nextEvent
    Event *nextEvent = nil;
    
    if (choice && [choice isKindOfClass:[Choice class]]) {
        // the choice description will determine what method to use to handle the event
        NSString *choiceDescription = choice.choiceDescription;
        
        // check to see if we have a designated handler for that choice description
        NSValue *selectorValue = [selectorsForChoiceDescription objectForKey: choiceDescription];
        
        if (selectorValue != nil) {
            // if we do have a designated selector for that choice description
            // get the selector out of the NSValue wrapper
            SEL selector = [selectorValue pointerValue];
            
            // make sure the selector is real just to be safe
            if ([self respondsToSelector: selector]) {
                
                // and perform that selector!
                // suppressing warning for potential leak.
                // i am checking to make sure we respond to the selector.
                // this would be dangerous if we didn't have 100% control over the selectors available
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                nextEventModel = [self performSelector: selector];
                #pragma clang diagnostic pop
            }
            
        } else {
            // if the event description does not match a selector we recognize, it must be a unique choice
            nextEventModel = [self handleUniqueChoice: choice];
        }
        
        if (nextEventModel) {
            // mark the model as having had occured (only matters for uniques)
            nextEventModel.hasOccurred = YES;
            
            // create the nextEvent based upon the one returned by the selector
            // it may have different choices from the nextEventModel (illegal choices will be filtered out)
            nextEvent = [Event new];
            nextEvent.eventDescription = [nextEventModel eventDescription];
            nextEvent.choices = [self getLegalChoicesForEvent: nextEventModel];
        }
    }
    
    // finally, handle history and let the currentEventDescription reflect the nextEvent
    if (nextEvent) {
        [self manageAdditionToHistories: nextEvent];
        
        //  currentEventDescription must be set AFTER history is handled.
        currentEventDescription = [nextEvent description];
    } else {
        currentEventDescription = nil;
    }
    
    return nextEvent;
}

- (NSInteger) getScore {
    return score;
}

- (NSInteger) getTotalSteps {
    return [fullEventHistory count];
}

- (NSInteger) getSteps {
    return [eventHistory count];
}

#pragma MARK private methods
// this dictionary is at the heart of this class.
// instead of relying on an obscene if/else chain or less
// than ideal switch statement, we can have O(1) complexity of steps
// (instead of 0(n) in the case of the switch). i mean, it's not the biggest
// deal in the world, but I think it's fun to do it this way.
// The way this dictionary works is:
// When we want to add a special function for a choiceDescription, we add the method
// to this class, and pair it with the choiceDescription in this dictionary.
// The way we store the method is by isolating its selector (SEL) in an NSValue pointer.
// We can store that NSValue in the dictionary. Later, in getEventFromChoice we
// unwrap the selector (with some safety checks) and perform it.
- (void) initializeSelectorsForChoiceDescription {
    NSArray *choiceDescriptions = [NSArray arrayWithObjects: @"Move Forward",
                                                             @"Move Backwards",
                                                             @"Fight",
                                                             @"Flee",
                                                             @"Gather Wood",
                                                             @"Gather Metal",
                                                             @"Gather Meat",
                                                             @"End Game",
                                                             @"Feed Enemy",
                                                             @"Craft Weapon", nil];
    
    NSArray *selectors = [NSArray arrayWithObjects: [NSValue valueWithPointer: @selector(moveForward)],
                                                    [NSValue valueWithPointer: @selector(moveBackwards)],
                                                    [NSValue valueWithPointer: @selector(fight)],
                                                    [NSValue valueWithPointer: @selector(flee)],
                                                    [NSValue valueWithPointer: @selector(gatherWood)],
                                                    [NSValue valueWithPointer: @selector(gatherMetal)],
                                                    [NSValue valueWithPointer: @selector(gatherMeat)],
                                                    [NSValue valueWithPointer: @selector(endGame)],
                                                    [NSValue valueWithPointer: @selector(feedEnemy)],
                                                    [NSValue valueWithPointer: @selector(craftWeapon)], nil];
    
    selectorsForChoiceDescription = [NSDictionary dictionaryWithObjects: selectors forKeys: choiceDescriptions];
}

// history

- (void) manageAdditionToHistories: (Event *)event {
    if (event) {
        [fullEventHistory addObject: event];
        if ([self isEligibleForHistory: event]) {
            [eventHistory addObject: event];
        }
    }
}

- (BOOL) isEligibleForHistory: (Event *)event {
    BOOL isCombat = event.isCombatEvent;
    BOOL isUnique = event.isUnique;
    BOOL same = [[event eventDescription] isEqualToString: currentEventDescription];
    
    return (!isCombat && !isUnique && !same);
}

// filter choices -> returns an NSMutableArray of choices (should really be an immutable type)
- (NSMutableArray *) getLegalChoicesForEvent:(Event *)event {
    
    NSMutableArray *availableChoices = [NSMutableArray new];
    
    for (int i = 0; i < [event.choices count]; i += 1) {
        
        Choice *possibleChoice = [event.choices objectAtIndex:i];
        
        NSString *choiceDescription = [possibleChoice choiceDescription];
        
        BOOL choiceAvailable = YES;
        
        BOOL woodFull = ([choiceDescription isEqualToString: @"Gather Wood"] && [player hasWood]);
        BOOL metalFull = ([choiceDescription isEqualToString: @"Gather Metal"] && [player hasMetal]);
        BOOL meatFull = ([choiceDescription isEqualToString: @"Gather Meat"] && [player hasMeat]);
        BOOL cantFeed = ([choiceDescription isEqualToString: @"Feed Enemy"] && ![player hasMeat]);
        BOOL cantCraft = ([choiceDescription isEqualToString: @"Craft Weapon"] && !([player hasWood] && [player hasMetal]));
        
        if (woodFull || metalFull || meatFull || cantFeed || cantCraft) {
            choiceAvailable = NO;
        }
        
        if (choiceAvailable) {
            [availableChoices addObject: possibleChoice];
        }
    }
    return availableChoices;
}

- (BOOL) isEligibleForRandomSelection: (Event *)event {
    BOOL same = [[event eventDescription] isEqualToString: currentEventDescription];
    BOOL usedUp = (event.isUnique && event.hasOccurred);
    return (!same && !usedUp);
}

- (Event *) moveForward {
    score += 1;
    
    Event *next;
    NSInteger index;
    do {
        index = [dice rollDieWithSides: [currentEnvironment.events count]] - 1;
        next = [currentEnvironment.events objectAtIndex: index];
    } while (![self isEligibleForRandomSelection: next]);
    return next;
}

- (Event *) moveBackwards {
    score -= 1;
    if ([eventHistory count] > 1) {
        [eventHistory removeLastObject];
    }
    Event *lastEvent = [eventHistory lastObject];
    return lastEvent;
}

- (Event *) fight {
    score += 2;
    
    Event *fightResult = [Event new];
    
    NSInteger bonus = [player getWeaponStrength];
    NSInteger enemyStrength = ([fullEventHistory count] / 15) + 4;
    
    BOOL victory = [dice isRollSuccessfulWithNumberOfDice:1 sides:6 bonus:bonus againstTarget:enemyStrength];
    if (victory) {
        score += 3;
        
        Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
        Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];
        Choice *gatherMeat = [[Choice alloc] initWithChoiceDescription: @"Gather Meat"];
        
        fightResult.eventDescription = [currentEnvironment getFightVictoryEventString];
        fightResult.choices = [NSArray arrayWithObjects: moveForward, gatherMeat, moveBackward, nil];
        
    } else {
        
        Choice *endGame = [[Choice alloc] initWithChoiceDescription: @"End Game"];
        
        fightResult.eventDescription = [currentEnvironment getFightDefeatEventString];
        fightResult.choices = [NSArray arrayWithObjects: endGame, nil];
    }
    return fightResult;
}

- (Event *) flee {
    score += 1;
    
    Event *fleeResult = [Event new];
    
    BOOL success = ([dice rollDieWithSides:6] > 3);
    if (success) {
        
        Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
        Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];
        
        fleeResult.eventDescription = [currentEnvironment getFleeSuccessEventString];
        fleeResult.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
        
    } else {
        
        Choice *endGame = [[Choice alloc] initWithChoiceDescription: @"End Game"];
        
        fleeResult.eventDescription = [currentEnvironment getFleeFailEventString];
        fleeResult.choices = [NSArray arrayWithObjects: endGame, nil];
    }
    return fleeResult;
}

// the following three methods return the very last event - even if it was unique
- (Event *) gatherWood {
    score += 1;
    [player gatherMaterial: @"Wood"];
    
    return [fullEventHistory lastObject];
}

- (Event *) gatherMetal {
    score += 1;
    [player gatherMaterial: @"Metal"];
    
    return [fullEventHistory lastObject];
}

- (Event *) gatherMeat {
    score += 1;
    [player gatherMaterial: @"Meat"];
    
    return [fullEventHistory lastObject];
}

- (Event *) endGame {
    return nil;
}

- (Event *) feedEnemy {
    score += 1;
    [player.inventory setObject:@NO forKey: @"Meat"];
    
    Event *feedResult = [Event new];
    
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];
    
    feedResult.eventDescription = [currentEnvironment getFeedResultEventString];
    feedResult.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
    
    return nil;
}

- (Event *) craftWeapon {
    score += 2;
    [player craftWeapon];
    
    Event *craftResult = [Event new];
    
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];
    
    craftResult.eventDescription = [currentEnvironment getCraftResultEventString];
    craftResult.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
    
    return craftResult;
}

- (Event *) handleUniqueChoice: (Choice *) choice {
    score += 3;
    
    NSArray *resultEvents = [choice resultEvents];
    NSInteger numResults = [resultEvents count];
    
    NSAssert(numResults > 0, @"No possible results from unique choice: %@", [choice choiceDescription]);
    
    NSInteger index;
    if (numResults > 1) {
        index = [dice rollDieWithSides: numResults] - 1;
    } else {
        index = 0;
    }
    return [resultEvents objectAtIndex:index];
}

@end
