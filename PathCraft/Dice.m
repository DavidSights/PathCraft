//
//  Dice.m
//  PathCraft
//
//  Created by pablq on 7/21/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Dice.h"

@implementation Dice

- (BOOL)isRollSuccessfulWithNumberOfDice: (NSInteger)numberOfDice
                                   sides: (NSInteger)sides
                                   bonus: (NSInteger)bonus
                           againstTarget: (NSInteger)target {
    
    NSInteger value = [self rollValueWithNumberOfDice: numberOfDice sides:sides bonus:bonus];
    if(value >= target) {
        return YES;
    }
    return NO;
}

- (NSInteger)rollValueWithNumberOfDice: (NSInteger)numberOfDice sides:(NSInteger)sides bonus:(NSInteger)bonus {
    NSInteger total = 0;
    for (int i=0; i<numberOfDice; i++) {
        NSInteger roll = [self rollDieWithSides:sides];
        total+=roll;
    }
    return total+bonus;
}

- (NSInteger)rollDieWithSides:(NSInteger)sides {
    // I'm adding this assertion here because I am assuming our dice have a small number of sides so that
    // casting from a 64-bit NSUInteger to a 32 bit unsigned int for the arc4random_uniform roll
    // isn't a problem. If our dice more have more than 10000 sides at any point, we should revisit this assumption.
    NSAssert(sides<10000, @"Die has too many sides.");
    
    NSInteger roll = arc4random_uniform((u_int32_t)sides)+1;
    
    return roll;
}

@end
