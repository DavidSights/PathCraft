//
//  ViewController.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ViewController.h"
#import "Environment.h"
#import "Event.h"
#import "ForrestEnviroment.h"
#import "Choice.h"
#import "Player.h"
#import "GameOverViewController.h"
#import "Announcer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
//@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *currentAvailableChoices;
@property NSMutableArray *eventHistory;
@property Player *player;
@property Environment *environment;
@property NSInteger stepCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetGame];
}

-(void)viewWillAppear:(BOOL)animated {
    // Rounded Corners for Butons
    self.choiceButton.clipsToBounds = YES;
    self.actionButton.clipsToBounds = YES;
    self.choiceButton.layer.cornerRadius = self.choiceButton.frame.size.height/6;
    self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height/6;

    [self resetGame];
}

- (void)resetGame {
    
    self.stepCount = 0;
    
    ForrestEnviroment *forrest = [ForrestEnviroment new];
    self.environment = forrest;
    
    self.player = [Player new];
    
    Event *initialEvent = [self getInitialEvent];
    
    self.currentEvent = initialEvent;
    [self populateEventDisplay: self.currentEvent];
    
    self.eventHistory = [NSMutableArray new];
    [self.eventHistory addObject: self.currentEvent];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.descriptionTextField.accessibilityLabel);
}

- (void) updateAccessibilityLabels {
    NSString *buttonTitle = self.currentAvailableChoices[self.currentChoiceIndex];
    [self.choiceButton setTitle: buttonTitle forState:UIControlStateNormal];
    NSString *accessibilityLabel = [@"Change action. Current action is " stringByAppendingString:buttonTitle];
    [self.choiceButton setAccessibilityLabel:accessibilityLabel];
}

- (Event *)getInitialEvent {
    
    Event *initialEvent = [Event new];

    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    NSMutableArray *initialChoices = [NSMutableArray arrayWithObjects: moveForward, nil];
    
    if ([self.environment.environmentDescription isEqualToString:@"Forest"]) {
        Choice *gatherWood = [[Choice alloc] initWithChoiceDescription:@"Gather Wood"];
        [initialChoices addObject: gatherWood];
        
    } else if ([self.environment.environmentDescription isEqualToString:@"Mountain"]) {
        
        if ([ViewController rollDieWithSides:6] >= 5) {
            Choice *gatherMetal = [[Choice alloc] initWithChoiceDescription:@"Gather Metal"];
            [initialChoices addObject: gatherMetal];
        }
    }
    
    // This logic can be changed to allow for variety in initial events
    Event *eventModel = self.environment.events[0];
    
    initialEvent.eventDescription = eventModel.eventDescription;
    initialEvent.choices = initialChoices;
    
    return initialEvent;
}
#pragma mark - Buttons

- (IBAction)choiceButtonPressed:(id)sender {
    [self updateChoice];
}

- (IBAction)actionButtonPressed:(id)sender {
    self.stepCount += 1;
    if ([self.choiceButton.titleLabel.text isEqualToString:@"Move Forward"]) {
        [self advance];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Move Backwards"]) {
        [self moveBack];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Fight"]) {
        [self fight];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Flee"]) {
        [self flee];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Wood"]) {
        [self.player gatherMaterial: @"Wood"];
        [self refreshEvent];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Metal"]) {
        [self.player gatherMaterial: @"Metal"];
        [self refreshEvent];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"Gather Meat"]) {
        [self.player gatherMaterial: @"Meat"];
        [self refreshEvent];
    } else if ([self.choiceButton.titleLabel.text isEqualToString: @"End Game"]) {
        [self performSegueWithIdentifier:@"gameOver" sender:self];
    } else {
        // Feed enemy handles itself, but we must take away the player's meat.
        if ([self.choiceButton.titleLabel.text isEqualToString: @"Feed Enemy"]) {
            [self.player.inventory setObject:@NO forKey:@"Meat"];
        }  else if ([self.choiceButton.titleLabel.text isEqualToString:@"Upgrade Weapon"]) {
            [self.player craftWeapon];
        }
        [self handleUniqueEvent: self.currentEvent withChoiceIndex: self.currentChoiceIndex];
    }
    //UIAccessibilityAnnouncementNotification(UIAccessibilityAnnouncementNotification,self.descriptionTextField.accessibilityLabel);
    Announcer *announcer = [Announcer new];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:announcer selector:@selector(receiveNotification:) name:UIAccessibilityAnnouncementDidFinishNotification object:nil];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.descriptionTextField.accessibilityLabel);
}

#pragma mark - Update Views

- (NSArray *) currentAvailableChoicesForEvent: (Event *)event {

    NSMutableArray *currentAvailableChoices = [NSMutableArray new];
    NSArray *allChoices = [event choices];

    for (int i = 0; i < allChoices.count; i += 1) {
        Choice *currentChoice = [allChoices objectAtIndex: i];
        BOOL addChoice = YES;
        NSString *description = [currentChoice choiceDescription];

        if (([description isEqualToString: @"Gather Wood"] && [self.player hasWood]) ||
            ([description isEqualToString: @"Gather Metal"] && [self.player hasMetal]) ||
            ([description isEqualToString: @"Gather Meat"] && [self.player hasMeat]) ||
            ([description isEqualToString: @"Feed Enemy"] && ![self.player hasMeat]) ||
            ([description isEqualToString: @"Upgrade Weapon"] && !([self.player hasMetal] && [self.player hasWood]))) {
            addChoice = NO;
        }

        if (addChoice) {
            [currentAvailableChoices addObject:description];
        }
    }
    return currentAvailableChoices;
}

- (void) updateChoice {
    int numberOfChoices = (int)self.currentAvailableChoices.count;

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }
    [self updateAccessibilityLabels];
}

- (void) populateEventDisplay:(Event *)event {
    
    self.descriptionTextField.text = [event eventDescription];

    self.currentAvailableChoices = [self currentAvailableChoicesForEvent: event];

    [self.choiceButton setTitle: self.currentAvailableChoices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
    [self updateAccessibilityLabels];
}

#pragma mark - Handle Events

- (BOOL) eventIsEligible: (Event *) event {
    // Check whether event is eligible to be the next event
    if ([event isEqual: self.currentEvent]) {
        return NO;
    } else if (event.isUnique && event.hasOccurred) {
        return NO;
    }
    return YES;
}

- (void) refreshEvent {
    [self populateEventDisplay:self.currentEvent];
}

- (void) advance {
    Event *newEvent;
    NSUInteger index;
    do {
        index = (NSUInteger) arc4random() % [self.environment.events count];
        newEvent = [self.environment.events objectAtIndex: index];
    } while (![self eventIsEligible: newEvent]);
    
    self.currentEvent = newEvent;
    
    self.currentEvent.hasOccurred = YES;
    
    [self populateEventDisplay: self.currentEvent];
    
    if (!self.currentEvent.isCombatEvent) {
        [self.eventHistory addObject: self.currentEvent];
    }
}

- (void) moveBack {
    
    if (self.eventHistory.count > 1) {
        [self.eventHistory removeLastObject];
    }
    Event *lastEvent = [self.eventHistory lastObject];

    while (lastEvent.isCombatEvent) {
        NSAssert([self.eventHistory count] > 0, @"No non-combat events left in event history");
        [self.eventHistory removeLastObject];
        lastEvent = [self.eventHistory lastObject];
    }
    self.currentEvent = lastEvent;
    [self populateEventDisplay: self.currentEvent];
}

- (void) fight {
    
    // Base sixty percent chance of dying ...
    // Player weapon upgrades help by 10% each
    Event *fightResultEvent;
    NSInteger bonus = [self.player getWeaponStrength];
    NSInteger enemyStrength = (self.stepCount / 15) + 4;
    
    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:6 bonus: bonus againstTarget: enemyStrength];
    
    Choice *fightChoice = [[self.currentEvent choices] objectAtIndex: 0];
    
    if (victory) {
        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 0];
    } else {
        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 1];
    }
    
    self.currentEvent = fightResultEvent;
    
    [self populateEventDisplay: self.currentEvent];
    [self.eventHistory addObject: self.currentEvent];
}

- (void) flee {

    Event *fleeResultEvent;
    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:6 bonus:0 againstTarget:3];
    Choice *fleeChoice = [[self.currentEvent choices] objectAtIndex:1];
    if (victory) {
        fleeResultEvent = [[fleeChoice resultEvents] objectAtIndex:0];
    } else {
        fleeResultEvent = [[fleeChoice resultEvents] objectAtIndex:1];
    }
    
    self.currentEvent = fleeResultEvent;
    
    [self populateEventDisplay: self.currentEvent];
    [self.eventHistory addObject:self.currentEvent];
}

- (void) handleUniqueEvent: (Event *)event withChoiceIndex: (NSInteger)index {
    
    event.hasOccurred = YES;
    
    NSArray *choices = [event choices];
    Choice *chosenAction = [choices objectAtIndex: index];
    
    NSArray *possibleResults = [chosenAction resultEvents];
    
    NSInteger resultIndex;
    if ([possibleResults count] > 1) {
        resultIndex = [ViewController rollDieWithSides: [possibleResults count]] - 1;
    } else {
        resultIndex = 0;
    }
    Event *resultEvent = [possibleResults objectAtIndex: resultIndex];
    

    self.currentEvent = resultEvent;
    
    [self populateEventDisplay: self.currentEvent];
    
    // dont add craft events to history
    if (![[self.currentEvent eventDescription] isEqualToString: @"You successfully upgraded your weapon"]) {
        [self.eventHistory addObject: self.currentEvent];
    }
}

# pragma mark - Utilty

+(BOOL)isRollSuccessfulWithNumberOfDice:(NSUInteger)numberOfDice
                                  sides:(NSUInteger)sides
                                  bonus:(NSInteger)bonus
                          againstTarget:(NSInteger)target {
    NSInteger value = [self rollValueWithNumberOfDice:numberOfDice sides:sides bonus:bonus];
    if(value >= target) {
        return YES;
    }
    return NO;
}

+(NSInteger)rollValueWithNumberOfDice:(NSUInteger)numberOfDice sides:(NSUInteger)sides bonus:(NSInteger)bonus {
    NSInteger total = 0;
    for (int i=0; i<numberOfDice; i++) {
        NSUInteger roll = [self rollDieWithSides:sides];
        total+=roll;
    }
    return total+bonus;
}

+ (NSUInteger)rollDieWithSides:(NSUInteger)sides {
    // I'm adding this assertion here because I am assuming our dice have a small number of sides so that
    // casting from a 64-bit NSUInteger to a 32 bit unsigned int for the arc4random_uniform roll
    // isn't a problem. If our dice more have more than 10000 sides at any point, we should revisit this assumption.
    NSAssert(sides<10000, @"Die has too many sides.");
    
    NSUInteger roll = arc4random_uniform((u_int32_t)sides)+1;
    
    return roll;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameOverViewController *dVC = segue.destinationViewController;
    dVC.gameOverText = [NSString stringWithFormat:@"Game Over.\nYou performed %li actions.", (long)self.stepCount];
}

@end
