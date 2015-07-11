//
//  Event.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)init {
    self = [super init];
    if (self) {
        _isUnique = NO;
        _hasOccurred = NO;
        _isCombatEvent = NO;
    }
    return self;
}

- (void)createResultEventWithString:(NSString *)eventDescription {
    Event *event = [Event new];
    event.eventDescription = eventDescription;
    NSString *moveForward = @"Move forward";
    NSString *moveBackward = @"Move backward";
    NSArray *choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event.choices = choices;
    if (self.results == nil) {
        self.results = [NSMutableArray new];
    }
    [self.results addObject:event];
}

@end
