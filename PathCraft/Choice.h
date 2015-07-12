//
//  Choice.h
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Environment.h"
#import "Event.h"

@interface Choice : Environment

@property NSString *choiceDescription;
@property NSMutableArray *resultEvents;

- (instancetype) initWithChoiceDescription: (NSString *)choiceDescription;
- (void) createBasicResultEventWithString: (NSString *)resultDescription;
- (void) createEndGameResultEventWithString:(NSString *)resultDescription;
- (void) initializeResultEventsWithEvent: (Event *)event;

@end
