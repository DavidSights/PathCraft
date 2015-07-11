//
//  Event.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)init
{
    self = [super init];
    if (self) {
        _isUnique = NO;
        _hasOccurred = NO;
    }
    return self;
}

@end
