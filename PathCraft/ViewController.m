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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property Event *currentEvent;
@property int currentChoiceIndex;
@property NSArray *events;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Environment *forrest = [Environment new];
    forrest.environmentDescription = @"Forest";

    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around.";
    NSString *choice1 = @"Move Forward";
    NSString *choice2 = @"Move Backwards";
    NSArray *choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event1.choices = choices;

    Event *event2 = [Event new];
    event1.eventDescription = @"Sun light peaks through leaves of a tree.";
    choice1 = @"Move Forward";
    choice2 = @"Move Backwards";
    choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event2.choices = choices;

    Event *event3 = [Event new];
    event1.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choice1 = @"Move Forward";
    choice2 = @"Move Backwards";
    choices = [NSArray arrayWithObjects:choice1, choice2, nil];
    event3.choices = choices;

    self.events = [NSArray arrayWithObjects:event1, event2, event3, nil];

    self.currentEvent = event1;

    self.descriptionTextField.text = event1.eventDescription;
    [self.choiceButton setTitle:event1.choices[0] forState:UIControlStateNormal];
    self.currentChoiceIndex = 0;
}



- (IBAction)choiceButtonPressed:(id)sender {
    [self updateChoice];
}

- (void) updateChoice {
    int numberOfChoices = (int)self.currentEvent.choices.count;

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }

    [self.choiceButton setTitle:self.currentEvent.choices[self.currentChoiceIndex] forState:UIControlStateNormal];
}

- (IBAction)actionButtonPressed:(id)sender {
    if (![self.descriptionTextField.text  isEqual: @"Action pressed!"]) {
        self.descriptionTextField.text = @"Action pressed!";
    } else {
        self.descriptionTextField.text = @"Action pressed again!";
    }

}

@end
