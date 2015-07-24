//
//  Environment.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject
@property NSString *environmentDescription;
@property NSArray *events;

- (NSString *) getFightVictoryEventString;
- (NSString *) getFightDefeatEventString;
- (NSString *) getFleeSuccessEventString;
- (NSString *) getFleeFailEventString;
- (NSString *) getFeedResultEventString;
- (NSString *) getCraftResultEventString;

@end
