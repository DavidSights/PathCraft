//
//  Inventory.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Inventory.h"

@implementation Inventory

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.materials = [self initializeMaterials];
    }
    return self;
}

- (NSDictionary *)initializeMaterials {
    NSDictionary *materials;
    
    materials = [NSDictionary dictionaryWithObjects:@[@NO, @NO, @NO] forKeys: @[@"Wood", @"Metal", @"Meat"]];
    
    return materials;
}

- (BOOL)hasWood {
    return [[self.materials objectForKey:@"Wood"] boolValue];
}

- (BOOL)hasMetal {
    return [[self.materials objectForKey:@"Metal"] boolValue];
}

- (BOOL)hasMeat {
    return [[self.materials objectForKey:@"Meat"] boolValue];
}

@end
