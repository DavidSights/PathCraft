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
    NSMutableArray *eventHistory; // must always have at least one event (starting with getInitialEvent). combat and unique events do not get added!
    Dice *dice;
    NSInteger score;
    NSDictionary *selectorsForChoiceDescription;
}

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
- (Event *) getEventFromChoice:(Choice *)choice {
    
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
            // create the nextEvent based upon the one returned by the selector
            // it may have different choices (illegal choices will be filtered out)
            nextEvent = [Event new];
            nextEvent.eventDescription = [nextEventModel eventDescription];
            nextEvent.choices = [self getLegalChoicesForEvent: nextEventModel];
        }
    }
    
    // finally, handle history and let the currentEventDescription reflect the nextEvent
    if (nextEvent) {
        [self manageAdditionToHistories: nextEvent];
        currentEventDescription = [nextEvent description];
    } else {
        currentEventDescription = nil;
    }
    
    return nextEvent;
}

- (NSInteger) getScore {
    return score;
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
    BOOL eligibleForHistory = YES;
    if (event.isCombatEvent || event.isUnique) {
        eligibleForHistory = NO;
    }
    return eligibleForHistory;
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
    BOOL isEligible = YES;
    if ([[event description] isEqualToString: currentEventDescription] || (event.isUnique && event.hasOccurred)) {
        isEligible = NO;
    }
    return isEligible;
}

- (Event *) moveForward {
    score += 1;
    Event *nextEvent;
    NSInteger index;
    do {
        index = [dice rollDieWithSides: [currentEnvironment.events count]] - 1;
        nextEvent = [currentEnvironment.events objectAtIndex: index];
    } while (![self isEligibleForRandomSelection: nextEvent]);
    return nextEvent;
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
    
    // Base sixty percent chance of dying ...
    // Player weapon upgrades help by 100/6 % each
    Event *fightResult;
    
    NSInteger bonus = [player getWeaponStrength];
    NSInteger enemyStrength = ([fullEventHistory count] / 15) + 4;
    
    BOOL victory = [dice isRollSuccessfulWithNumberOfDice:1 sides:6 bonus:bonus againstTarget:enemyStrength];
    
    
    return nil;
}
//- (void) fight {
//    
//    // Base sixty percent chance of dying ...
//    // Player weapon upgrades help by 10% each
//    Event *fightResultEvent;
//    NSInteger bonus = [self.player getWeaponStrength];
//    NSInteger enemyStrength = (self.stepCount / 15) + 4;
//    
//    NSLog(@"bonus: %lu", (long)bonus);
//    NSLog(@"enemy strength: %lu", (long)enemyStrength);
//    
//    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:6 bonus: bonus againstTarget: enemyStrength];
//    
//    Choice *fightChoice = [[self.currentEvent choices] objectAtIndex: 0];
//    
//    if (victory) {
//        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 0];
//    } else {
//        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 1];
//    }
//    
//    self.currentEvent = fightResultEvent;
//    
//    [self populateEventDisplay: self.currentEvent];
//    [self.eventHistory addObject: self.currentEvent];
//}
- (Event *) flee {
    score += 1;
    return nil;
}

- (Event *) gatherWood {
    return nil;
}

- (Event *) gatherMetal {
    return nil;
}

- (Event *) gatherMeat {
    return nil;
}

- (Event *) endGame {
    return nil;
}

- (Event *) feedEnemy {
    score += 1;
    return nil;
}

- (Event *) craftWeapon {
    score += 2;
    return nil;
}

- (Event *) handleUniqueChoice: (Choice *) choice {
    score += 1;
    return nil;
}

@end
