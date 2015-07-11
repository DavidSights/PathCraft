//
//  Game.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Environment.h"

@interface Game : NSObject
@property (strong, nonatomic) Environment *currentEnvironment;
//@property (strong, nonatomic) Player *player;
@end
