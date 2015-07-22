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
    Event *currentEvent;
    Player *player;
    NSMutableArray *fullEventHistory;
    NSMutableArray *eligibleEventHistory; // must always have at least one event!
    Dice *dice;
    NSInteger score;
    NSDictionary *selectorsForChoiceDescription;
}

- (id) init {
    self = [super init];
    if (self) {
        currentEnvironment = [ForrestEnviroment new];
        currentEvent = nil;
        environments = [NSArray arrayWithObjects: currentEnvironment, [Mountain new], nil];
        player = [Player new];
        fullEventHistory = [NSMutableArray new];
        eligibleEventHistory = [NSMutableArray new];
        dice = [Dice new];
        score = 0;
        selectorsForChoiceDescription = [self getSelectorsForChoiceDescription];
    }
    return self;
}

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
    
    currentEvent = initialEvent;
    [fullEventHistory addObject: initialEvent];
    [eligibleEventHistory addObject: initialEvent];
    
    return initialEvent;
}

- (NSInteger) getScore {
    return score;
}

#pragma MARK - For handling actions

- (Event *) getResultFromChoice:(Choice *)choice {
    
    NSString *choiceDescription = choice.choiceDescription;
    
    NSValue *selectorValue = [selectorsForChoiceDescription objectForKey: choiceDescription];
    
    if (selectorValue != nil) {
        
        SEL selector = [selectorValue pointerValue];
        if ([self respondsToSelector: selector]) {
            
            // suppressing warning for potential leak.
            // i am checking to make sure we respond to the selector.
            // this would be dangerous if we didn't have 100% control over the selectors available
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector: selector];
            #pragma clang diagnostic pop
        }
        
    } else {
        
        [self handleUniqueChoice: choice];
    }
                        
    return nil;
}

- (NSDictionary *) getSelectorsForChoiceDescription {
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
    
    return [NSDictionary dictionaryWithObjects: selectors forKeys: choiceDescriptions];
}

- (Event *) moveForward {
    score += 1;
    Event *nextEvent;
    NSInteger index;
    do {
        index = [dice rollDieWithSides: [currentEnvironment.events count]] - 1;
        nextEvent = [currentEnvironment.events objectAtIndex: index];
    } while (![self eventIsEligible: nextEvent]);
    return nextEvent;
}

- (BOOL) eventIsEligible: (Event *)event {
    BOOL isEligible = YES;
    if ([event isEqual: currentEvent] || (event.isUnique && event.hasOccurred)) {
        isEligible = NO;
    }
    return isEligible;
}

//- (void) advance {
//    Event *newEvent;
//    NSUInteger index;
//    
//    do {
//        index = (NSUInteger) arc4random() % [self.environment.events count];
//        newEvent = [self.environment.events objectAtIndex: index];
//    } while (![self eventIsEligible: newEvent]);
//    
//    //    NSLog(@"event index: %lu", index);
//    
//    self.currentEvent = newEvent;
//    
//    self.currentEvent.hasOccurred = YES;
//    
//    [self populateEventDisplay: self.currentEvent];
//    
//    if (!(self.currentEvent.isCombatEvent || self.currentEvent.isUnique)) {
//        [self.eventHistory addObject: self.currentEvent];
//    }
//}

- (Event *) moveBackwards {
    score -= 1;
    return nil;
}

- (Event *) fight {
    score += 2;
    return nil;
}

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
