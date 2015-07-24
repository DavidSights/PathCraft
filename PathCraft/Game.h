//
//  Game.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"
#import "Choice.h"

@interface Game : NSObject

- (Event *) getInitialEvent;

// returns nil if game is over
- (Event *) getEventFromChoice: (Choice *) choice;

- (NSInteger) getScore;

- (NSInteger) getTotalSteps;

- (NSInteger) getSteps;

@end
