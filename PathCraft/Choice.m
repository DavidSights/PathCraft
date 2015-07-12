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

- (void) createBasicResultWithString:(NSString *)resultDescription {

    // A possible event for a unique result.
    Event *event = [Event new];
    event.eventDescription = resultDescription;

    // Unique result events only allow moving forward or backwards.
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];

    NSArray *choices = [NSArray arrayWithObjects:moveBackward, moveBackward, nil];
    event.choices = choices;

    // Add the created result event to list of possible results.
    if (self.resultEvents) {
        [self.resultEvents addObject: event];
    } else {
        self.resultEvents = [NSMutableArray arrayWithObjects:moveBackward, moveForward, nil];
    }
}

- (void) addMoveForwardAndBackwardsOptions {
    
}

@end
