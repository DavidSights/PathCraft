//
//  Mountain.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Mountain.h"
#import "Event.h"

@implementation Mountain

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.environmentDescription = @"Mountain";
        self.events = [self generateEvents];
    }
    return self;
}

- (NSArray *)generateEvents {
    
    /* Standard choices */
    
    NSString *moveForward = @"Move Forward";
    NSString *moveBackward = @"Move Backwards";
    
    /* Combat Choices */
    NSString *fight = @"Fight";
    NSString *flee = @"Flee"; // R: 1. You got away. 2. You did not escape. You suffered a quick and painful death.
    
    /* Special Choices */
    
    // Cave
    NSString *cave1 = @"Explore the cave."; // R: 1) It's a lion's den. You are killed. 2) It's an empty meditation chamber. You sit down and feel centered.
    
    // Procession
    NSString *procession1 = @"Call to the people and ask what they're doing."; // R: 1) They ignore you.
    NSString *procession2 = @"Join the procession."; // R: 1) You are ignored. 2) You are met with hostile gestures. You'd better stay away.
    
    // Cliff
    NSString *cliff1 = @"Move forward for a closer look."; // R: 1) You slip and fall to your death. 2) You are rewarded with an incredible breeze and view. You can see (other environment) from here. 3) You are overcome with fear... You force yourself to crawl for a peak.
    NSString *cliff2 = @"Take a leap of faith over the edge."; // R: 1) You fall to your death. 2) A mysterious wind catches you and places you safely on solid ground.

    // Peak
    NSString *peak1 = @"Scurry to the top."; // R: 1) You scream at the top of your lungs. This is the most free you've ever felt. 2) You are left speechless. What can be said about such a sensation.
    NSString *peak2 = @"Carefully ascend to the highest point."; // R: 1) You trip and nearly fall. You barely notice the view as you scramble away. 2) What a view and sensation!
    
    // Demi-god presents itself
    NSString *demiGod1 = @"Approach with caution."; // R: 1) The god rewards you. 2) The god is offended and kills you.
    NSString *demiGod2 = @"Run away!"; // R: 1) The god ignores you. 2) The god is offended and kills you.
    NSString *demiGod3 = @"Bow in deference."; // R: 1) The god rewards you. 3) The god acknowledges you and moves on.
    
    
    /* Regular */
    
    Event *event1 = [Event new];
    event1.eventDescription = @"The air is crisp here.";
    NSArray *choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event1.choices = choices;
    
    Event *event2 = [Event new];
    event2.eventDescription = @"You come upon a dignified boulder.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event2.choices = choices;
    
    Event *event3 = [Event new];
    event3.eventDescription = @"You notice a small shrine.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event3.choices = choices;
    
    Event *event4 = [Event new];
    event4.eventDescription = @"A condor flys in the distance.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event4.choices = choices;
    
    Event *event5 = [Event new];
    event5.eventDescription = @"You are overcome with awe in the sublime environment.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event5.choices = choices;
    
    Event *event6 = [Event new];
    event6.eventDescription = @"The trail is dangerous. Watch your footing.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event6.choices = choices;
    
    Event *event7 = [Event new];
    event7.eventDescription = @"It's a false summit.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event7.choices = choices;
    
    /* Unique */
    
    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = @"You encounter a cave. It looks warm and inviting.";
    choices = [NSArray arrayWithObjects: cave1, moveForward, moveBackward, nil];
    uniqueEvent1.choices = choices;
    uniqueEvent1.isUnique = YES;
    
    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You come across a procession of locals in bright hats.";
    choices = [NSArray arrayWithObjects: procession1, procession2, moveForward, moveBackward, nil];
    uniqueEvent2.choices = choices;
    uniqueEvent2.isUnique = YES;
    
    Event *uniqueEvent3 = [Event new];
    uniqueEvent3.eventDescription = @"Suddenly you find yourself at a cliff. You cannot see what's beyond it.";
    choices = [NSArray arrayWithObjects: cliff1, cliff2, moveBackward, nil];
    uniqueEvent3.choices = choices;
    uniqueEvent3.isUnique = YES;
    
    Event *uniqueEvent4 = [Event new];
    uniqueEvent4.eventDescription = @"Suddenly you find yourself at a cliff. You cannot see what's beyond it.";
    choices = [NSArray arrayWithObjects: cliff1, cliff2, moveBackward, nil];
    uniqueEvent4.choices = choices;
    uniqueEvent4.isUnique = YES;
    
    Event *uniqueEvent5 = [Event new];
    uniqueEvent5.eventDescription = @"You've arrived at the summit!";
    choices = [NSArray arrayWithObjects: peak1, peak2, moveBackward, nil];
    uniqueEvent5.choices = choices;
    uniqueEvent5.isUnique = YES;
    
    Event *uniqueEvent6 = [Event new];
    uniqueEvent6.eventDescription = @"A mystical being appears nearby.";
    choices = [NSArray arrayWithObjects: demiGod1, demiGod2, demiGod3, moveForward, moveBackward, nil];
    uniqueEvent6.choices = choices;
    uniqueEvent6.isUnique = YES;
    
    /* Combat */
    
    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"You encounter a mountain lion.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent1.choices = choices;
    
    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"You encounter a group of bandits.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent2.choices = choices;
    
    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"An eagle swoops down and attacks you.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent3.choices = choices;
    
    Event *combatEvent4 = [Event new];
    combatEvent4.eventDescription = @"A mystical being comes towards you angrily.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent4.choices = choices;
    
    /* Craftables */
    
    // Shiny stone
    
    // Pure copper
    
    // Heavy rock
    
    // Demi-god presents magical material to you
    
    NSArray *events = [NSArray arrayWithObjects: event1, event2, event4, event4, event5, event6, event7, uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4, uniqueEvent5, uniqueEvent6, combatEvent1, combatEvent2, combatEvent3, combatEvent4, nil];
    
    return events;
}

@end
