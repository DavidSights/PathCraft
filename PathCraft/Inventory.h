//
//  Inventory.h
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inventory : NSObject

@property (nonatomic, strong)NSDictionary *materials;

- (BOOL)hasWood;
- (BOOL)hasMetal;
- (BOOL)hasMeat;

@end
