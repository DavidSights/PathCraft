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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *currentAvailableChoices;
@property NSArray *events;
@property NSMutableArray *eventHistory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForrestEnviroment *forrest = [ForrestEnviroment new];
    
    self.events = forrest.events;
    
    Event *initialEvent = [self getInitialEvent];
    
    self.currentEvent = initialEvent;
    [self populateEventDisplay: self.currentEvent];
    
    self.eventHistory = [NSMutableArray new];
    [self.eventHistory addObject: self.currentEvent];
}

- (Event *)getInitialEvent {
    
    Event *eventModel;
    Event *initialEvent = [Event new];
    
    // This logic can be changed to allow for variety in initial events
    eventModel = self.events[0];
    
    initialEvent.eventDescription = eventModel.eventDescription;
    initialEvent.choices = [NSArray arrayWithObjects: @"Move Forward", nil];
    
    return initialEvent;
}
#pragma mark - Buttons

- (IBAction)choiceButtonPressed:(id)sender {
    [self updateChoice];
}

- (IBAction)actionButtonPressed:(id)sender {
    if ([self.choiceButton.titleLabel.text isEqualToString:@"Move Backwards"]) {
        [self moveBack];
    } else if ([self.choiceButton.titleLabel.text isEqualToString:@"Fight"]) {
        [self fight];
        [self advance];
    } else {
        [self advance];
    }
}

#pragma mark - Update Views

- (NSArray *) currentAvailableChoicesForEvent : (Event *) event {
    return [event.choices copy];
}

- (void) updateChoice {
    int numberOfChoices = (int)self.currentAvailableChoices.count;

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }
    [self.choiceButton setTitle:self.currentAvailableChoices[self.currentChoiceIndex] forState:UIControlStateNormal];
}

- (void) populateEventDisplay:(Event *)event {
    NSLog(@"popEventDisplay");
    [self logEvent:event];
    self.descriptionTextField.text = event.eventDescription;
    self.currentAvailableChoices = [self currentAvailableChoicesForEvent: event];
    [self.choiceButton setTitle: self.currentAvailableChoices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
}

#pragma mark - Handle Events

- (void) logEvent:(Event *)event {
    NSLog(@"%@", event.eventDescription);
}

- (BOOL) eventIsEligible: (Event *) event {
    // Check whether event is eligible to be the next event
    NSLog(@"event.eventDescription:%@",event.eventDescription);
    if ([event isEqual:self.currentEvent]) {
        return NO;
    } else if (event.isUnique && event.hasOccurred) {
        return NO;
    }
    return YES;
}

- (void) advance {
    Event *newEvent;
    do {
        NSUInteger index = (NSUInteger) arc4random() % [self.events count];
        newEvent = [self.events objectAtIndex:index];
    } while (![self eventIsEligible:newEvent]);
    self.currentEvent = newEvent;
    self.currentEvent.hasOccurred = YES;
    [self populateEventDisplay: self.currentEvent];
    [self.eventHistory addObject: self.currentEvent];
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
    // Fifty percent chance of dying ...
    BOOL victory = [ViewController isRollSuccessfulWithNumberOfDice:1 sides:2 bonus:0 againstTarget:2];
    if (victory) {
        NSLog(@"VICTORY");
        Event *victoryEvent = [[self.currentEvent results] objectAtIndex:0];
        self.currentEvent = victoryEvent;
        self.currentEvent.hasOccurred = YES;
        [self populateEventDisplay: self.currentEvent];
        [self.eventHistory addObject:self.currentEvent];
    } else {
        Event *defeatEvent = [[self.currentEvent results] objectAtIndex:0];
        self.currentEvent = defeatEvent;
        self.currentEvent.hasOccurred = YES;
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
