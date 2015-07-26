//
//  ViewController.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ViewController.h"
#import "GameOverViewController.h"

#import "Announcer.h"

#import "Game.h"
#import "Choice.h"
#import "Event.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController()

@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *gatheredMaterialLabel;

@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) Event *currentEvent;
@property NSInteger currentChoiceIndex;

@property (strong, nonatomic) Announcer* announcer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionTextField.adjustsFontSizeToFitWidth = YES;
    self.gatheredMaterialLabel.alpha = 0;
    [self.actionButton setAccessibilityTraits:UIAccessibilityTraitStartsMediaSession];
}

-(void)viewWillAppear:(BOOL)animated {
    // Rounded Corners for Butons
    self.choiceButton.clipsToBounds = YES;
    self.actionButton.clipsToBounds = YES;
    self.choiceButton.layer.cornerRadius = self.choiceButton.frame.size.height/6;
    self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height/6;
    self.gatheredMaterialLabel.clipsToBounds = YES;
    self.gatheredMaterialLabel.layer.cornerRadius = self.gatheredMaterialLabel.frame.size.height/2;

    [self resetGame];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)resetGame {
    
    self.game = [[Game alloc] init];
    
    self.currentEvent = [self.game getInitialEvent];

    [self populateEventDisplay];
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.descriptionTextField.accessibilityLabel);
}

- (void) updateAccessibilityLabels {
    NSString *buttonTitle = [self.currentEvent.choices[self.currentChoiceIndex] choiceDescription];
    [self.choiceButton setTitle: buttonTitle forState:UIControlStateNormal];
    NSString *accessibilityLabel = [@"Change action. Current action is " stringByAppendingString:buttonTitle];
    [self.choiceButton setAccessibilityLabel:accessibilityLabel];
    NSString *performActionAccessibilityLabel = [@"Perform action. Current action is " stringByAppendingString:buttonTitle];
    [self.actionButton setAccessibilityLabel:performActionAccessibilityLabel];
}

#pragma mark - Buttons

- (IBAction)choiceButtonPressed:(id)sender {
    
    [self updateChoice];
}

- (void) gatherAndShowNoticeFor: (NSString *)material {
    self.gatheredMaterialLabel.text = [NSString stringWithFormat:@"Gathered %@!", material];
    self.gatheredMaterialLabel.alpha = 1;
    [UIView animateWithDuration:2.0 animations:^{
        self.gatheredMaterialLabel.alpha = 0;
    }];
}

- (IBAction)actionButtonPressed:(id)sender {
    
    Choice *chosenAction = [self.currentEvent.choices objectAtIndex: self.currentChoiceIndex];
    
    self.currentEvent = [self.game getEventFromChoice:chosenAction];
    
    if (!self.currentEvent) {
        // game is over
        [self performSegueWithIdentifier:@"gameOver" sender:self];
    } else {
        [self populateEventDisplay];
        [self speakString: self.descriptionTextField.text];
    }
}

#pragma mark - Update Views

- (void) updateChoice {
    
    NSInteger numberOfChoices = [[self.currentEvent choices] count];

    if (self.currentChoiceIndex >= numberOfChoices - 1) {
        self.currentChoiceIndex = 0;
    } else {
        self.currentChoiceIndex++;
    }
    
    [self updateAccessibilityLabels];
}

- (void) populateEventDisplay {
    
    self.descriptionTextField.text = [self.currentEvent eventDescription];

    [self.choiceButton setTitle: self.currentEvent.choices[0] forState:UIControlStateNormal];
    
    self.currentChoiceIndex = 0;
    
    [self updateAccessibilityLabels];
    
}

#pragma mark game delegate protocol method

- (void) playerDidGatherMaterial: (NSString *) material {
    
}

#pragma mark segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameOverViewController *dVC = segue.destinationViewController;
    dVC.gameOverText = [NSString stringWithFormat:@"Game Over.\nYou survived\n%li steps.", [self.game getSteps]];
}

#pragma mark speak

- (void) speakString: (NSString *) theString {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:theString];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.voice = voice;
    AVSpeechSynthesizer *synthesizer = [AVSpeechSynthesizer new];
    [synthesizer speakUtterance:utterance];
}

@end
