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
    Dice *dice;
    NSArray *environments;
    Environment *currentEnvironment;
    Player *player;
    NSMutableArray *fullEventHistory;
    NSMutableArray *eventHistory;
    NSInteger score;
    NSDictionary *selectorsForChoiceDescription;
}

#pragma MARK init

- (id) init {
    self = [super init];
    if (self) {
        
        dice = [Dice new];
        
        Environment *forest = [ForrestEnviroment new];
        Environment *mountain = [Mountain new];
        environments = [NSArray arrayWithObjects: forest, mountain, nil];
        
        if ([dice rollDieWithSides:6] >= 5) {
            currentEnvironment = mountain;
        } else {
            currentEnvironment = forest;
        }
        
        player = [Player new];

        eventHistory = [NSMutableArray new];
        fullEventHistory = [NSMutableArray new];
        
        score = 0;
        
        [self initializeSelectorsForChoiceDescription];
    }
    return self;
}

#pragma MARK public methods

- (Event *) getInitialEvent {
    Choice *initialChoice = [[Choice alloc] initWithChoiceDescription: @"Get Initial"];
    return [self getEventFromChoice: initialChoice];
}

// this method is the heard and soul of this class.
// it returns an event based upon the choice passed to it.
// it makes use of the selectorsForChoiceDescription dictionary which is
// initialized in the method 'initializeSelectorsForChoiceDescription.
// the selectorsForChoiceDescription dictionary matches choice descriptions to methods.
// each of the action selectors returns a model of an event. those models are then
// filtered in this method to only contain the choices appropriate for the game situation
// the filtered event is returned to the VC
- (Event *) getEventFromChoice: (Choice *)choice {
    
    // will be populated (or not!) by some method
    Event *nextEventModel = nil;
    
    // we will eventually return nextEvent
    Event *nextEvent = nil;
    
    if (choice && [choice isKindOfClass: [Choice class]]) {
        // the choice description will determine what method to use to handle the event
        NSString *choiceDescription = [choice choiceDescription];
        
        // check to see if we have a designated handler for that choice description
        NSValue *selectorValue = [selectorsForChoiceDescription objectForKey: choiceDescription];
        
        if (selectorValue != nil) {
            // if we do have a designated selector for that choice description
            // get the selector out of the NSValue wrapper
            SEL selector = [selectorValue pointerValue];
            
            // make sure the selector is real just to be safe
            if ([self respondsToSelector: selector]) {
                
                // perform that selector!
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
            // it may have different choices from the nextEventModel (illegal choices will be filtered out)
            nextEvent = [Event new];
            nextEvent.eventDescription = [nextEventModel eventDescription];
            nextEvent.isUnique = [nextEventModel isUnique];
            nextEvent.isCombatEvent = [nextEventModel isCombatEvent];
            nextEvent.choices = [self getLegalChoicesForEvent: nextEventModel];
            
            // mark the model as having had occured (only matters for uniques)
            nextEventModel.hasOccurred = YES;
        }
    }
    
    // finally, handle history
    if (nextEvent && nextEventModel) {
        [self manageHistory: nextEventModel];
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

/* ACTION SELECTORS START */

- (Event *) initialEvent {
    
    Event *model = [currentEnvironment events][0];
    
    NSMutableArray *availableChoices = [NSMutableArray arrayWithArray: model.choices];
    NSInteger indexOfMoveBackwards = -1;
    for (int i = 0; i < [availableChoices count]; i += 1) {
        NSString *choiceDescription = [[availableChoices objectAtIndex: i] choiceDescription];
        if ([choiceDescription isEqualToString: @"Move Backwards"]) {
            indexOfMoveBackwards = i;
        }
    }
    if (indexOfMoveBackwards > -1) {
        [availableChoices removeObjectAtIndex: indexOfMoveBackwards];
    }
    
    Event *initialEvent = [Event new];
    initialEvent.eventDescription = [model eventDescription];
    initialEvent.choices = availableChoices;
    
    return initialEvent;
}

- (Event *) moveForward {
    score += 1;
    
    Event *next;
    do {
        NSInteger index = [dice rollDieWithSides: [currentEnvironment.events count]] - 1;
        next = [currentEnvironment.events objectAtIndex: index];
    } while (![self isEligibleForRandomSelection: next]);
    return next;
}

// helper for moveForward
- (BOOL) isEligibleForRandomSelection: (Event *)event {
    Event *lastEvent = [fullEventHistory lastObject];
    BOOL same = [[event eventDescription] isEqualToString: [lastEvent eventDescription]];
    BOOL usedUp = (event.isUnique && event.hasOccurred);
    return (!same && !usedUp);
}

- (Event *) moveBackwards {
    score -= 1;
    if ([eventHistory count] > 1) {
        [eventHistory removeLastObject];
    }
    return [eventHistory lastObject];
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

- (Event *) gatherWood {
    return [self gatherMaterial: @"Wood"];
}

- (Event *) gatherMetal {
   return [self gatherMaterial: @"Metal"];
}

- (Event *) gatherMeat {
    return [self gatherMaterial: @"Meat"];
}

// helper for gatherWood, gatherMetal, gatherMeat
- (Event *) gatherMaterial: (NSString *) material {
    score += 1;
    
    [player gatherMaterial: material];
    [self.delegate playerDidGatherMaterial: material];
    
    return [fullEventHistory lastObject];
}

- (Event *) endGame {
    return nil;
}

- (Event *) feedEnemy {
    score += 1;
    [player.inventory setObject:@NO forKey: @"Meat"];
    
    Event *feedResult = [Event new];
    feedResult.specialResult = YES;
    
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];
    
    feedResult.eventDescription = [currentEnvironment getFeedResultEventString];
    feedResult.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
    
    return feedResult;
}

- (Event *) craftWeapon {
    score += 2;
    [player craftWeapon];
    
    Event *craftResult = [Event new];
    craftResult.specialResult = YES;
    
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

/* ACTION SELECTORS END */

/* HELPER METHODS START */

// instead of relying on an obscene if/else chain or a less
// than ideal switch statement, we can have O(1) complexity of steps for the main action in the game
// (instead of 0(n) in the case of the switch). i mean, it's not the biggest
// deal in the world, but I think it's fun to do it this way, and it is more efficient.
// The way this dictionary works is:
// When we want to add a special function for a choiceDescription, we add the method
// to this class, and pair it with the choiceDescription in this dictionary.
// The way we store the method is by isolating its selector (SEL) in an NSValue pointer.
// We can store that NSValue in the dictionary. Later, in getEventFromChoice we
// unwrap the selector (with some safety checks) and perform it.
- (void) initializeSelectorsForChoiceDescription {
    NSArray *choiceDescriptions = [NSArray arrayWithObjects: @"Get Initial",
                                   @"Move Forward",
                                   @"Move Backwards",
                                   @"Fight",
                                   @"Flee",
                                   @"Gather Wood",
                                   @"Gather Metal",
                                   @"Gather Meat",
                                   @"End Game",
                                   @"Feed Enemy",
                                   @"Craft Weapon", nil];
    
    NSArray *selectors = [NSArray arrayWithObjects: [NSValue valueWithPointer: @selector(initialEvent)],
                          [NSValue valueWithPointer: @selector(moveForward)],
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

// history arrays consist of the full events (without filtered choices array)
- (void) manageHistory: (Event *)event {
    [fullEventHistory addObject: event];
    if ([self shouldAddEventToHistory: event]) {
        [eventHistory addObject: event];
    }
}

// helper for manageHistory
- (BOOL) shouldAddEventToHistory: (Event *) event {
    BOOL isCombat = [event isCombatEvent];
    BOOL isUnique = [event isUnique];
    BOOL isSpecialResult = [event specialResult];
    BOOL isSame = NO;
    Event *lastEvent = [eventHistory lastObject];
    if (lastEvent) {
        isSame = [[event eventDescription] isEqualToString: [lastEvent eventDescription]];
    }
    return (!isCombat && !isUnique && !isSpecialResult && !isSame);
}

// returns array of legal choices for an event given the current state of the game
- (NSMutableArray *) getLegalChoicesForEvent:(Event *)event {
    
    NSMutableArray *availableChoices = [NSMutableArray new];
    
    for (int i = 0; i < [event.choices count]; i += 1) {
        
        Choice *possibleChoice = [event.choices objectAtIndex:i];
        
        NSString *choiceDescription = [possibleChoice choiceDescription];
        
        BOOL choiceAvailable = YES;
        
        BOOL cantBackUp = ([choiceDescription isEqualToString: @"Move Backwards"] && ([eventHistory count] < 1));
        BOOL woodFull = ([choiceDescription isEqualToString: @"Gather Wood"] && [player hasWood]);
        BOOL metalFull = ([choiceDescription isEqualToString: @"Gather Metal"] && [player hasMetal]);
        BOOL meatFull = ([choiceDescription isEqualToString: @"Gather Meat"] && [player hasMeat]);
        BOOL cantFeed = ([choiceDescription isEqualToString: @"Feed Enemy"] && ![player hasMeat]);
        BOOL cantCraft = ([choiceDescription isEqualToString: @"Craft Weapon"] && !([player hasWood] && [player hasMetal]));
        
        if (cantBackUp || woodFull || metalFull || meatFull || cantFeed || cantCraft) {
            choiceAvailable = NO;
        }
        
        if (choiceAvailable) {
            [availableChoices addObject: possibleChoice];
        }
    }
    return availableChoices;
}

/* HELPER METHODS END */

@end
