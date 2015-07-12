//
//  Player.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Player.h"
#import <AVFoundation/AVFoundation.h>

@implementation Player

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self initializeInventory];
        self.weapon = [NSNumber numberWithInteger: 0];
    }
    return self;
}

- (void) initializeInventory {
    self.inventory = [NSMutableDictionary dictionaryWithObjects: @[@NO, @NO, @NO]
                                                        forKeys: @[@"Wood", @"Metal", @"Meat"]];
}

- (BOOL) hasWood {
    return [[self.inventory objectForKey: @"Wood"] boolValue];
}

- (BOOL) hasMetal {
    return [[self.inventory objectForKey: @"Metal"] boolValue];
}

- (BOOL) hasMeat {
    return [[self.inventory objectForKey: @"Meat"] boolValue];
}

- (void) gatherMaterial:(NSString *)material {
    [self.inventory setValue:@YES forKey:material];
    [self speakString:@"You gathered the materials."];
}

- (void)craftWeapon {
    NSInteger upgrade = 0;
    NSInteger tempWeapon = [self.weapon integerValue];
    if ([self hasMetal] && [self hasWood]) {
        upgrade += 1;
        [self.inventory setObject:@NO forKey:@"Wood"];
        [self.inventory setObject:@NO forKey:@"Metal"];
    }
    tempWeapon += upgrade;
    self.weapon = [NSNumber numberWithInteger:tempWeapon];
}

- (NSInteger) getWeaponStrength {
    return [self.weapon integerValue];
}

- (void) speakString: (NSString *) theString {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:theString];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.voice = voice;
    AVSpeechSynthesizer *synthesizer = [AVSpeechSynthesizer new];
    [synthesizer speakUtterance:utterance];
}


@end
