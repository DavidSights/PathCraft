//
//  Choice.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Choice.h"
#import "Event.h"

@implementation Choice

- (instancetype) initWithChoiceDescription:(NSString *)choiceDescription {
    self = [super init];
    if (self) {
        self.choiceDescription = choiceDescription;
    }
    return self;
}

- (void) initializeResultEventsWithEvent: (Event *)event {
    if (!self.resultEvents) {
        self.resultEvents = [NSMutableArray arrayWithObjects: event, nil];
    } else {
        [self.resultEvents addObject: event];
    }
}

- (void) createBasicResultEventWithString:(NSString *)resultDescription {

    // A possible event for a unique result.
    Event *event = [Event new];
    event.specialResult = YES;
    event.eventDescription = resultDescription;

    // Unique result events only allow moving forward or backwards.
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];

    NSArray *choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event.choices = choices;

    // Add the created result event to list of possible results.
    if (self.resultEvents) {
        [self.resultEvents addObject: event];
    } else {
        self.resultEvents = [NSMutableArray arrayWithObjects:event, nil];
    }
}

- (void) createEndGameResultEventWithString:(NSString *)resultDescription {
    Event *event = [Event new];
    event.eventDescription = resultDescription;
    
    Choice *endGame = [[Choice alloc] initWithChoiceDescription: @"End Game"];
    NSArray *choices = [NSArray arrayWithObjects: endGame, nil];
    event.choices = choices;
    
    if (self.resultEvents) {
        [self.resultEvents addObject: event];
    } else {
        self.resultEvents = [NSMutableArray arrayWithObjects:event, nil];
    }
}

@end
