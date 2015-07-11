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
@property NSArray *events;
@property NSMutableArray *eventHistory;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForrestEnviroment *forrest = [ForrestEnviroment new];
    forrest.environmentDescription = @"Forest";
    [forrest generateEvents];
    self.events = forrest.events;
    
    Event *initialEvent = self.events[0];
    
    self.currentEvent = initialEvent;
    [self populateEventDisplay: self.currentEvent];
    
    self.eventHistory = [NSMutableArray new];
    [self.eventHistory addObject: self.currentEvent];
}

#pragma mark - Buttons

- (IBAction)choiceButtonPressed:(id)sender {
    [self updateChoice];
}

- (IBAction)actionButtonPressed:(id)sender {
    // If the user chose "Move Forward", then generate a new event
    if ([self.choiceButton.titleLabel.text isEqualToString:@"Move Backwards"]) {
        [self moveBack];
    } else {
        [self advance];
    }

    // If the user chose "Move Backward", go back to the previous event
}

#pragma mark - Update Views

- (void) updateChoice {
    int numberOfChoices = (int)self.currentEvent.choices.count;

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }
    [self.choiceButton setTitle:self.currentEvent.choices[self.currentChoiceIndex] forState:UIControlStateNormal];
}

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
    // Add current event to the end of the history array
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
    
    if (lastEvent) {
        self.currentEvent = lastEvent;
        [self populateEventDisplay: self.currentEvent];
    }
}

- (void) populateEventDisplay:(Event *)event {
    NSLog(@"popEventDisplay");
    [self logEvent:event];
    self.descriptionTextField.text = event.eventDescription;
    [self.choiceButton setTitle: event.choices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
}

@end
