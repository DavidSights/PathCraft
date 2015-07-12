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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *currentAvailableChoices;
@property NSMutableArray *eventHistory;
@property Player *player;
@property Environment *environment;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForrestEnviroment *forrest = [ForrestEnviroment new];
    self.environment = forrest;
    
    self.player = [Player new];
    
    Event *initialEvent = [self getInitialEvent];
    
    self.currentEvent = initialEvent;
    [self populateEventDisplay: self.currentEvent];
    
    self.eventHistory = [NSMutableArray new];
    [self.eventHistory addObject: self.currentEvent];
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
    } else {
        //handle unique events here.
    }
}

#pragma mark - Update Views

- (NSArray *) currentAvailableChoicesForEventOrChoice: (id)candidate {

    NSMutableArray *currentAvailableChoices = [NSMutableArray new];
    
    NSLog(@"%@", [candidate description]);

    NSArray *allChoices;
    if ([candidate class] == [Event class]) {
        allChoices = [candidate choices];
    } else {
        allChoices = [candidate resultEvents];
    }

    for (int i = 0; i < allChoices.count; i += 1) {
        BOOL addChoice = YES;
        NSString *description;
        id choice = allChoices[i];
        NSLog(@"%@", [choice class]);
        if ([choice class] == [Choice class]) {
            description = [choice choiceDescription];
        } else {
            description = [choice eventDescription];
        }

        if (([description isEqualToString:@"Gather Wood"] && [self.player hasWood]) ||
            ([description isEqualToString:@"Gather Metal"] && [self.player hasMetal]) ||
            ([description isEqualToString:@"Gather Meat"] && [self.player hasMeat])) {
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
    [self.choiceButton setTitle: self.currentAvailableChoices[self.currentChoiceIndex] forState:UIControlStateNormal];
}

- (void) populateEventDisplay:(id)event {

    NSString *textFieldText;
    if ([event class] == [Event class]) {
        textFieldText = [event eventDescription];
    } else {
        textFieldText = [event choiceDescription];
    }
    self.descriptionTextField.text = textFieldText;

    self.currentAvailableChoices = [self currentAvailableChoicesForEventOrChoice: event];

    [self.choiceButton setTitle: self.currentAvailableChoices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
    
}

#pragma mark - Handle Events

- (BOOL) eventIsEligible: (Event *) event {
    // Check whether event is eligible to be the next event
    if ([event isEqual:self.currentEvent]) {
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
    do {
        NSUInteger index = (NSUInteger) arc4random() % [self.environment.events count];
        newEvent = [self.environment.events objectAtIndex:index];
    } while (![self eventIsEligible:newEvent]);
    
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

    NSLog(@"current event (fight or flight): %@", self.currentEvent.eventDescription);
    // Fifty percent chance of dying ...
    Event *fightResultEvent;
    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:2 bonus:0 againstTarget:2];
    Choice *fightChoice = [[self.currentEvent choices] objectAtIndex: 0];
    NSLog(@"chosen action from (fight or flight) event: %@", fightChoice.description);
    
    if (victory) {
        NSLog(@"VICTORY");
        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 0];
    } else {
        NSLog(@"DEFEAT");
        fightResultEvent = [[fightChoice resultEvents] objectAtIndex: 1];
    }
    NSLog(@"result event from chosen action of fight or flight event: %@", fightResultEvent.description);
    
    self.currentEvent = fightResultEvent;
    
    [self populateEventDisplay: self.currentEvent];
    [self.eventHistory addObject: self.currentEvent];
}

- (void) flee {
    NSLog(@"%@", self.currentEvent.description);
    // Flee is the same as fight for the moment... change this. :) --MJ
    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:2 bonus:0 againstTarget:2];
    self.currentEvent.hasOccurred = YES;
    if (victory) {
        NSLog(@"VICTORY");
        Event *victoryEvent = [[self.currentEvent choices] objectAtIndex:0];
        self.currentEvent = victoryEvent;
        self.currentEvent.hasOccurred = YES;
        [self populateEventDisplay: self.currentEvent];
        [self.eventHistory addObject:self.currentEvent];
    } else {
        NSLog(@"DEFEAT");
        Event *defeatEvent = [[self.currentEvent choices] objectAtIndex:0];
        self.currentEvent = defeatEvent;
//        self.currentEvent.hasOccurred = YES;
        [self populateEventDisplay: self.currentEvent];
        [self.eventHistory addObject:self.currentEvent];
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
    return arc4random_uniform((u_int32_t)sides)+1;
}

@end
