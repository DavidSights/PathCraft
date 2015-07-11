//
//  ForrestEnviroment.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ForrestEnviroment.h"
#import "Event.h"

@implementation ForrestEnviroment

- (void) generateEvents {

    // Choices

    NSString *moveForward = @"Move Forward";
    NSString *moveBackward = @"Move Backwards";

    // Resources
    NSString *gatherWood = @"Gather Wood";
    NSString *gatherMetal = @"Gather Metal";
    NSString *gatherMeat = @"Gather Meat"; // Not for eating/healing, but for guarenteed fleeing - feed monster choice.

    // Combat
    NSString *fight = @"Fight";
    NSString *flee = @"Flee"; // R: 1. You got away. 2. You did not escape. You suffered a quick and painful death.

    // Root
    NSString *root1 = @"Rip your foot loose."; // R: 1. You get free. 2. You injure yourself. Suddenly a bear chases you down and eats you alive."
    NSString *root2 = @"Carefully remove your foot from the root."; // R: 1. You get free. 2. Too focused to notice a hungry bear behind you, you are attacked and die."

    // Banging
    NSString *banging1 = @"Check it out"; // R: 1. As you move towards the sound, it suddenly stops and something runs away. 2. The bnaging stops, then you hear a banging on your head and you die.

    // Fruit tree
    NSString *tree1 = @"Eat a hanging fruit.";
    NSString *tree2 = @"Eat a fallen fruit.";

    // Glowing eyes
    NSString *eyes1 = @"Check it out."; // R: 1. You reach into the bush and grab a tiny cat. It meows sharply at you and leaps away. 2. A black, amorphus figure leaps out at you and you die.


    // Passive Events

    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around.";
    NSArray *choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event1.choices = choices;

    Event *event2 = [Event new];
    event2.eventDescription = @"Sun light peaks through leaves of a tree.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event2.choices = choices;

    Event *event3 = [Event new];
    event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event3.choices = choices;

    Event *event4 = [Event new];
    event4.eventDescription = @"Your feet are kind of sore.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event4.choices = choices;

    Event *event5 = [Event new];
    event5.eventDescription = @"The smell of nature is thick here.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event5.choices = choices;

    Event *event6 = [Event new];
    event6.eventDescription = @"You notice you smell kind of bad. Oh well.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event6.choices = choices;

    Event *event7 = [Event new];
    event7.eventDescription = @"A bird flies past your face. A little too close for comfort.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event7.choices = choices;

    Event *event8 = [Event new];
    event8.eventDescription = @"You wonder what your family is doing now. You almost trip over a rock and are brought back to reality.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
    event8.choices = choices;

    // Unique Events

    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = @"Your foot gets caught in a root trap.";
    choices = [NSArray arrayWithObjects:root1, root2, nil];
    uniqueEvent1.choices = choices;
    uniqueEvent1.isUnique = YES;

    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You hear banging like sticks against a tree.";
    choices = [NSArray arrayWithObjects: banging1, moveForward, moveBackward, nil];
    uniqueEvent2.choices = choices;
    uniqueEvent2.isUnique = YES;

    Event *uniqueEvent3 = [Event new];
    uniqueEvent3.eventDescription = @"You find a fruit tree. Fallen fruits litter the ground.";
    choices = [NSArray arrayWithObjects: tree1, tree2, moveForward, moveBackward, nil];
    uniqueEvent3.choices = choices;
    uniqueEvent3.isUnique = YES;

    Event *uniqueEvent4 = [Event new];
    uniqueEvent4.eventDescription = @"You notice glowing eyes in a thick bush.";
    choices = [NSArray arrayWithObjects: eyes1, moveForward, moveBackward, nil];
    uniqueEvent4.choices = choices;
    uniqueEvent4.isUnique = YES;

    // Combat Events --- Stretch goal: Strength Levels!

    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"You encounter a giant spider.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent1.choices = choices;
    combatEvent1.isCombatEvent = YES;
    
    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"A wild and hungry snake appears.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent2.choices = choices;
    combatEvent2.isCombatEvent = YES;

    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"A giant, rabid wolf appears.";
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    combatEvent3.choices = choices;
    combatEvent3.isCombatEvent = YES;

    // Result Events


    /*
     Event *event<#number#> = [Event new];
     event1.eventDescription = @"<#Description#>";
     choices = [NSArray arrayWithObjects:moveForward, moveBackward, nil];
     event<#number#>.choices = choices;
     */

    self.events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8,
                   uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4,
                   combatEvent1, combatEvent2, combatEvent3, nil];
}

@end
