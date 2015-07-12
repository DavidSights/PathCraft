//
//  Announcer.m
//  PathCraft
//
//  Created by Michael Johnson on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Announcer.h"
#import <UIKit/UIKit.h>

@implementation Announcer
-(void)receiveNotification:(NSNotification *)notification {
    NSLog(@"Got it");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Just work");
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"This is a test.");
}
@end
