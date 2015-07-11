//
//  Event.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSArray *choices;
@property BOOL isUnique;
@property BOOL hasOccurred;
@property BOOL isCombatEvent;
@property NSMutableArray *results;

//- (void)createResultEventWithString:(NSString *)evenDescription;

@end
