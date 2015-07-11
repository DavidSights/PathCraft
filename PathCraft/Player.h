//
//  Player.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Weapon.h"

@interface Player : NSObject

@property (nonatomic, strong) NSMutableDictionary *inventory;
@property NSInteger *weapon;

- (BOOL)hasWood;
- (BOOL)hasMetal;
- (BOOL)hasMeat;

- (void)craftWeapon;
- (void) gatherMaterial:(NSString *)material;

@end
