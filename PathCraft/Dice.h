//
//  Dice.h
//  PathCraft
//
//  Created by pablq on 7/21/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dice : NSObject

- (BOOL)isRollSuccessfulWithNumberOfDice: (NSInteger)numberOfDice
                                   sides: (NSInteger)sides
                                   bonus: (NSInteger)bonus
                           againstTarget: (NSInteger)target;

- (NSInteger)rollDieWithSides: (NSInteger)sides;

@end
