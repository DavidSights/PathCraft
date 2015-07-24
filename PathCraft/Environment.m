//
//  Environment.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Environment.h"
#import "Event.h"

@implementation Environment


- (NSString *) getFightVictoryEventString {
    return nil;
}
- (NSString *) getFightDefeatEventString {
    return nil;
}
- (NSString *) getFleeSuccessEventString {
    return nil;
}
- (NSString *) getFleeFailEventString {
    return nil;
}

- (NSString *) getFeedResultEventString {
    return nil;
}

- (NSString *) getCraftResultEventString {
    return @"You successfully crafted a new weapon!";
}

- (Event *) generateCombatEventWithEventDescription:(NSString *) eventDescription withChoices:(NSArray *)choices {

    Event *combatEvent = [Event new];
    combatEvent.eventDescription = eventDescription;
    combatEvent.choices = choices;
    combatEvent.isCombatEvent = YES;
    return combatEvent;
}

- (Event *) generateUniqueEventWithEventDescription:(NSString *) eventDescription withChoices:(NSArray *)choices {
    
    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = eventDescription;
    uniqueEvent1.choices = choices;
    uniqueEvent1.isUnique = YES;
    return uniqueEvent1;
}

@end