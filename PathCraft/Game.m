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
        environments = [NSArray arrayWithObjects: currentEnvironment, [Mountain new], nil];
        player = [Player new];
        fullEventHistory = [NSMutableArray new];
        eligibleEventHistory = [NSMutableArray new];
        dice = [Dice new];
        score = 0;
        selectorsForChoiceDescription = [self initializeSelectorsForChoiceDescription];
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
    
    return initialEvent;
}

- (NSInteger) getScore {
    return 0;
}

#pragma MARK - For handling actions

- (Event *) getResultFromChoice:(Choice *)choice {
    
    NSString *choiceDescription = choice.choiceDescription;
    
    NSValue *selectorValue = [selectorsForChoiceDescription objectForKey: choiceDescription];
    
    if (selectorValue != nil) {
        
        SEL selector = [selectorValue pointerValue];
        if ([self respondsToSelector: selector]) {
            [self performSelector: selector];
        }
        
    } else {
        
    }
                        
    return nil;
}
//- (IBAction)actionButtonPressed:(id)sender {
//    self.stepCount += 1;
//    if ([self.choiceButton.titleLabel.text isEqualToString: @"Move Forward"]) {
//        [self advance];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Move Backwards"]) {
//        [self moveBack];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Fight"]) {
//        [self fight];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Flee"]) {
//        [self flee];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Wood"]) {
//        [self gatherAndShowNoticeFor:@"Wood"];
//        [self refreshEvent];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Metal"]) {
//        [self gatherAndShowNoticeFor:@"Metal"];
//        [self refreshEvent];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Meat"]) {
//        [self gatherAndShowNoticeFor:@"Meat"];
//        [self refreshEvent];
//    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"End Game"]) {
//        [self performSegueWithIdentifier:@"gameOver" sender:self];
//    } else {
//        // Feed enemy handles itself, but we must take away the player's meat.
//        if ([self.choiceButton.titleLabel.text isEqualToString: @"Feed Enemy"]) {
//            [self.player.inventory setObject:@NO forKey:@"Meat"];
//        }  else if ([self.choiceButton.titleLabel.text isEqualToString: @"Upgrade Weapon"]) {
//            [self.player craftWeapon];
//        }
//        [self handleUniqueEvent: self.currentEvent withChoiceIndex: self.currentChoiceIndex];
//    }
//    //UIA(UIAccessibilityAnnouncementNotification,self.descriptionTextField.accessibilityLabel);
//    //UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Something something something");
//    /*
//     Might need this -- MJ
//
//     self.announcer = [Announcer new];
//     NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//     [nc addObserver:self.announcer selector:@selector(receiveNotification:) name: UIAccessibilityAnnouncementDidFinishNotification object:nil];
//     */
//    [self speakString:self.descriptionTextField.text];
//}

- (NSDictionary *) initializeSelectorsForChoiceDescription {
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
    return nil;
}

- (Event *) moveBackwards {
    return nil;
}

- (Event *) fight {
    return nil;
}

- (Event *) flee {
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
    return nil;
}

- (Event *) craftWeapon {
    return nil;
}

@end
