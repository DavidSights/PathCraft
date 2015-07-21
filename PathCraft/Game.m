//
//  Game.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Game.h"
#import "Environment.h"
#import "Player.h"

@implementation Game {
    NSArray *environments;
    Environment *currentEnvironment;
    Player *player;
    
    NSArray *fullEventHistory;
    NSArray *eligibleEventHistory; // must always have at least one event!
    NSInteger score;
}

- (id) init {
    self = [super init];
    if (self) {
        // set up variables
    }
    return self;
}

- (Event *) getInitialEvent {
    return nil;
}

- (Event *) getResultFromChoice:(Choice *)choice {
    return nil;
}

- (NSInteger) getScore {
    return 0;
}

@end
