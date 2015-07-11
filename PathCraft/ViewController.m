//
//  ViewController.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)choiceButtonPressed:(id)sender {

}

- (IBAction)actionButtonPressed:(id)sender {
    if (![self.descriptionTextField.text  isEqual: @"Action pressed!"]) {
        self.descriptionTextField.text = @"Action pressed!";
    } else {
        self.descriptionTextField.text = @"Action pressed again!";
    }

}

@end
