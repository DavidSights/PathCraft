//
//  GameDelegateProtocol.h
//  PathCraft
//
//  Created by pablq on 7/25/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

@protocol GameDelegate <NSObject>

- (void) playerDidGatherMaterial: (NSString *)material;

@end
