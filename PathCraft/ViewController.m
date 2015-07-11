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
#import "Inventory.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *currentAvailableChoices;
@property NSArray *events;
@property NSMutableArray *eventHistory;
@property Inventory *inventory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForrestEnviroment *forrest = [ForrestEnviroment new];
    self.events = forrest.events;
    
    self.inventory = [Inventory new];
    
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
//        [self fight];
        [self advance];
    } else if ([self.choiceButton.titleLabel.text isEqualToString:@"Gather Wood"]) {
        [self gatherWood];
    } else if ([self.choiceButton.titleLabel.text isEqualToString:@"Gather Metal"]) {
        [self gatherMetal];
    } else if ([self.choiceButton.titleLabel.text isEqualToString:@"Gather Meat"]) {
        [self gatherMeat];
    } else {
        [self advance];
    }
}

#pragma mark - Update Views

- (NSArray *) currentAvailableChoicesForEvent : (Event *) event {
    NSMutableArray *currentAvailableChoices = [NSMutableArray new];
    NSArray *allChoices = event.choices;
    for (int i = 0; i < allChoices.count; i += 1) {
        BOOL addChoice = YES;
        NSString *choice = allChoices[i];
        if (([choice isEqualToString:@"Collect Wood"] && [self.inventory hasWood]) ||
            ([choice isEqualToString:@"Collect Metal"] && [self.inventory hasMetal]) ||
            ([choice isEqualToString:@"Collect Meat"] && [self.inventory hasMeat])) {
            addChoice = NO;
        }
        if (addChoice) {
            [currentAvailableChoices addObject:choice];
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

- (void) gatherWood {
    [self.inventory.materials setValue:@YES forKey:@"Wood"];
}

- (void) gatherMetal {
    [self.inventory.materials setValue:@YES forKey:@"Metal"];
}

- (void) gatherMeat {
    [self.inventory.materials setValue:@YES forKey:@"Meat"];
}

@end
