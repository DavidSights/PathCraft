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
        self.environmentDescription = @"A mountain";
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
    NSString *cliff2 = @"Take a leap of faith."; // R: 1) You fall to your death. 2) A mysterious wind catches you and places you safely on solid ground.

    // Peak
    NSString *peak1 = @"You scurry to the highest point."; // R: 1) You scream at the top of your lungs. This is the most free you've ever felt. 2) You are left speechless. What can be said about such a sensation.
//    NSString *
    
    
    /* Regular */
    
    // Air is crisp
    
    // Dignified boulder
    
    // Shrine
    
    // Swooping condor
    
    // Sublime feeling of awe
    
    // The trail is difficult (watch your footing).
    
    // A false summit.
    
    /* Unique */
    
    // Cave
    
    // Procession
    
    // Cliff
    
    // Peak
    
    // Demi-god presents itself
    
    /* Combat */
    
    // Lion
    
    // Bandits
    
    // Angry bird
    
    // Demi-god presents itself
    
    /* Craftables */
    
    // Shiny stone
    
    // Pure copper
    
    // Heavy rock
    
    // Demi-god presents magical material to you
    
    Event *event1 = [Event new];
    
    NSArray *events = [NSArray arrayWithObjects: event1, nil];
    
    return events;
}

//// Choices
//
//NSString *moveForward = @"Move Forward";
//NSString *moveBackward = @"Move Backwards";
//
//// Combat
//NSString *fight = @"Fight";
//NSString *flee = @"Flee"; // R: 1. You got away. 2. You did not escape. You suffered a quick and painful death.
//
//// Root
//NSString *root1 = @"Rip your foot loose."; // R: 1. You get free. 2. You injure yourself. Suddenly a bear chases you down and eats you alive."
//NSString *root2 = @"Carefully remove your foot from the root."; // R: 1. You get free. 2. Too focused to notice a hungry bear behind you, you are attacked and die."
//
//// Banging
//NSString *banging1 = @"Check it out"; // R: 1. As you move towards the sound, it suddenly stops and something runs away. 2. The bnaging stops, then you hear a banging on your head and you die.
//
//// Fruit tree
//NSString *tree1 = @"Eat a hanging fruit.";
//NSString *tree2 = @"Eat a fallen fruit.";
//
//// Glowing eyes
//NSString *eyes1 = @"Check it out."; // R: 1. You reach into the bush and grab a tiny cat. It meows sharply at you and leaps away. 2. A black, amorphus figure leaps out at you and you die.
//
//
//// Passive Events
//
//Event *event1 = [Event new];
//event1.eventDescription = @"Trees surround you all around.";
//NSArray *choices = [NSArray arrayWithObjects:moveForward, nil];
//event1.choices = choices;
//
//Event *event2 = [Event new];
//event2.eventDescription = @"Sun light peaks through leaves of a tree.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event2.choices = choices;
//
//Event *event3 = [Event new];
//event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event3.choices = choices;
//
//Event *event4 = [Event new];
//event4.eventDescription = @"Your feet are kind of sore.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event4.choices = choices;
//
//Event *event5 = [Event new];
//event5.eventDescription = @"The smell of nature is thick here.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event5.choices = choices;
//
//Event *event6 = [Event new];
//event6.eventDescription = @"You notice you smell kind of bad. Oh well.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event6.choices = choices;
//
//Event *event7 = [Event new];
//event7.eventDescription = @"A bird flies past your face. A little too close for comfort.";
//choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
//event7.choices = choices;
//
//// Unique Events
//
//Event *uniqueEvent1 = [Event new];
//uniqueEvent1.eventDescription = @"Your foot gets caught in a root trap.";
//choices = [NSArray arrayWithObjects:root1, root2, nil];
//uniqueEvent1.choices = choices;
//uniqueEvent1.isUnique = YES;
//
//Event *uniqueEvent2 = [Event new];
//uniqueEvent2.eventDescription = @"You hear banging like sticks against a tree.";
//choices = [NSArray arrayWithObjects: banging1, moveForward, moveBackward, nil];
//uniqueEvent2.choices = choices;
//uniqueEvent2.isUnique = YES;
//
//Event *uniqueEvent3 = [Event new];
//uniqueEvent3.eventDescription = @"You find a fruit tree. Fallen fruits litter the ground.";
//choices = [NSArray arrayWithObjects: tree1, tree2, moveForward, moveBackward, nil];
//uniqueEvent3.choices = choices;
//uniqueEvent3.isUnique = YES;
//
//Event *uniqueEvent4 = [Event new];
//uniqueEvent4.eventDescription = @"You notice glowing eyes in a thick bush.";
//choices = [NSArray arrayWithObjects: eyes1, moveForward, moveBackward, nil];
//uniqueEvent4.choices = choices;
//uniqueEvent4.isUnique = YES;
//
//// Combat Events --- Stretch goal: Strength Levels!
//
//Event *combatEvent1 = [Event new];
//combatEvent1.eventDescription = @"You encounter a giant spider.";
//choices = [NSArray arrayWithObjects: fight, flee, nil];
//combatEvent1.choices = choices;
//
//Event *combatEvent2 = [Event new];
//combatEvent2.eventDescription = @"A wild and hungry snake appears.";
//choices = [NSArray arrayWithObjects: fight, flee, nil];
//combatEvent2.choices = choices;
//
//Event *combatEvent3 = [Event new];
//combatEvent3.eventDescription = @"A giant, rabid wolf appears.";
//choices = [NSArray arrayWithObjects: fight, flee, nil];
//combatEvent3.choices = choices;
//
//// Result Event
//
//
///*
// Event *event<#number#> = [Event new];
// event1.eventDescription = @"<#Description#>";
// choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
// event<#number#>.choices = choices;
// */
//
//self.events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7,
//               uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4,
//               combatEvent1, combatEvent2, combatEvent3, nil];

@end
