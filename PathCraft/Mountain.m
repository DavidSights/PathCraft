//
//  Mountain.m
//  PathCraft
//
//  Created by pablq on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "Mountain.h"
#import "Event.h"
#import "Choice.h"

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
    
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];
    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];

    // Resources
    Choice *gatherWood = [[Choice alloc] initWithChoiceDescription: @"Gather Wood"];
    Choice *gatherMetal = [[Choice alloc] initWithChoiceDescription: @"Gather Metal"];
    Choice *gatherMeat = [[Choice alloc] initWithChoiceDescription: @"Gather Meat"];

    // end game does not have a results array
    Choice *endGame = [[Choice alloc] initWithChoiceDescription: @"End Game"];

    // Combat
    Choice *fight = [[Choice alloc] initWithChoiceDescription:@"Fight"];

    Event *victoryEvent = [Event new];
    victoryEvent.eventDescription = @"You killed the enemy!";
    victoryEvent.choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMeat, nil];

    [fight initializeResultEventsWithEvent:victoryEvent];
    [fight createEndGameResultEventWithString: @"You have been slain."];

    Choice *flee = [[Choice alloc] initWithChoiceDescription:@"Flee"];
    [flee createBasicResultEventWithString: @"You got away."];
    [flee createEndGameResultEventWithString: @"You fell to your death as you attempted to escape."];

    Choice *feedEnemy = [[Choice alloc] initWithChoiceDescription:@"Feed Enemy"];
    [feedEnemy createBasicResultEventWithString:@"You fed the enemy and successfully escaped."];

    /* Regular */
    
    NSArray *choices;
    Event *event1 = [Event new];
    event1.eventDescription = @"The air is crisp here.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event1.choices = [NSArray arrayWithArray: choices];

    Event *event2 = [Event new];
    event2.eventDescription = @"You come upon a dignified boulder.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event2.choices = [NSArray arrayWithArray: choices];
    
    Event *event3 = [Event new];
    event3.eventDescription = @"You notice a small shrine.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event3.choices = [NSArray arrayWithArray: choices];

    Event *event4 = [Event new];
    event4.eventDescription = @"A condor flys in the distance.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event4.choices = [NSArray arrayWithArray: choices];

    Event *event5 = [Event new];
    event5.eventDescription = @"You are overcome with awe in the sublime environment.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward,  gatherMetal, nil];
    event5.choices = [NSArray arrayWithArray: choices];
    
    Event *event6 = [Event new];
    event6.eventDescription = @"The trail is dangerous. Watch your footing.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event6.choices = [NSArray arrayWithArray: choices];
    
    Event *event7 = [Event new];
    event7.eventDescription = @"It's a false summit.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event7.choices = [NSArray arrayWithArray: choices];
    
    Event *event8 = [Event new];
    event7.eventDescription = @"The sun is so bright and warm.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event7.choices = [NSArray arrayWithArray: choices];
    
    /* Special Choices */
    
    // Peak
    NSString *peak1 = @"Scurry to the top."; // R: 1) You scream at the top of your lungs. This is the most free you've ever felt. 2) You are left speechless. What can be said about such a sensation.
    NSString *peak2 = @"Carefully ascend to the highest point."; // R: 1) You trip and nearly fall. You barely notice the view as you scramble away. 2) What a view and sensation!
    
    // Demi-god presents itself
    NSString *demiGod1 = @"Approach with caution."; // R: 1) The god rewards you. 2) The god is offended and kills you.
    NSString *demiGod2 = @"Run away!"; // R: 1) The god ignores you. 2) The god is offended and kills you.
    NSString *demiGod3 = @"Bow in deference."; // R: 1) The god rewards you. 3) The god acknowledges you and moves on.
    
    /* Unique */
    
    // Unique Event 1

    // Initialize the special choice for the event
    Choice *caveChoice1 = [[Choice alloc] initWithChoiceDescription: @"Explore the cave."];

    // Initialize the choice's result events
    Event *caveChoice1Result1 = [Event new];
    caveChoice1Result1.eventDescription = @"It's an empty meditation chamber. You sit down and feel centered.";
    caveChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *caveChoice1Result2 = [Event new];
    caveChoice1Result2.eventDescription = @"It's a lion's den. You are killed by a mother lion.";
    caveChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *caveChoice1Results = [NSMutableArray arrayWithObjects: caveChoice1Result1, caveChoice1Result2, nil];
    caveChoice1.resultEvents = caveChoice1Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: moveForward, caveChoice1, moveBackward, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = @"You encounter a cave. It looks inviting.";
    uniqueEvent1.choices = [NSArray arrayWithArray: choices];
    uniqueEvent1.isUnique = YES;
    
    // Unique Event 2

    // Initialize a special choice for the event
    Choice *processionChoice1 = [[Choice alloc] initWithChoiceDescription: @"Call to the people and ask what they're doing."];

    // Initialize the special choice's result events
    Event *processionChoice1Result = [Event new];
    processionChoice1Result.eventDescription = @"They ignore you.";
    processionChoice1Result.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *processionChoice1Results = [NSMutableArray arrayWithObjects: processionChoice1Result, nil];
    processionChoice1.resultEvents = processionChoice1Results;

    // Initialize another special choice for the event
    Choice *processionChoice2 = [[Choice alloc] initWithChoiceDescription: @"Join the procession."];

    // Initialize the special choice's result events
    Event *processionChoice2Result1 = [Event new];
    processionChoice2Result1.eventDescription = @"You are ignored.";
    processionChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *processionChoice2Result2 = [Event new];
    processionChoice2Result2.eventDescription = @"You are met with hostile gestures. You'd better stay away.";
    processionChoice2Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *processionChoice2Results = [NSMutableArray arrayWithObjects: processionChoice2Result1, processionChoice2Result2, nil];
    processionChoice2.resultEvents = processionChoice2Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: moveForward, processionChoice1, processionChoice2, moveBackward, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You come across a procession of locals in bright hats.";
    uniqueEvent2.choices = [NSArray arrayWithArray: choices];
    uniqueEvent2.isUnique = YES;

    // Unique Event 3
    
    // Cliff
    NSString *cliff1 = @"Move forward for a closer look."; // R: 1) You slip and fall to your death. 2) You are rewarded with an incredible breeze and view. You can see (other environment) from here. 3) You are overcome with fear... You force yourself to crawl for a peak.
    NSString *cliff2 = @"Take a leap of faith over the edge."; // R: 1) You fall to your death. 2) A mysterious wind catches you and places you safely on solid ground.

    // Initialize a special choice for the event
    Choice *cliffChoice1 = [[Choice alloc] initWithChoiceDescription: @"Move forward for a closer look."];

    // Initialize the special choice's result event
    Event *cliffChoice1Result1 = [Event new];
    cliffChoice1Result1.eventDescription = @"You are rewarded with an incredible breeze and view. You can see the forest from here.";
    cliffChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, gatherMetal, moveBackward, nil];

    // Initialize the special choice's result event
    Event *cliffChoice1Result2 = [Event new];
    cliffChoice1Result2.eventDescription = @"You slip and fall to your death.";
    cliffChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *cliffChoice1Results = [NSMutableArray arrayWithObjects: cliffChoice1Result1, cliffChoice1Result2, nil];
    cliffChoice1.resultEvents = cliffChoice1Results;

    // Initialize another special choice for the event
    Choice *cliffChoice2 = [[Choice alloc] initWithChoiceDescription: @"Take a leap of faith over the edge."];

    // Initialize the special choice's result event
    Event *cliffChoice2Result1 = [Event new];
    cliffChoice2Result1.eventDescription = @"A mysterious wind catches you and places you safely on solid ground.";
    cliffChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];

    // Initialize the special choice's result event
    Event *cliffChoice2Result2 = [Event new];
    cliffChoice2Result2.eventDescription = @"You fall to your death.";
    cliffChoice2Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *cliffChoice2Results = [NSMutableArray arrayWithObjects: cliffChoice2Result1, cliffChoice2Result2, nil];
    cliffChoice2.resultEvents = cliffChoice2Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: cliffChoice1, cliffChoice2, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent3 = [Event new];
    uniqueEvent3.eventDescription = @"Suddenly you find yourself at a cliff. You cannot see what's beyond it.";
    uniqueEvent3.choices = [NSArray arrayWithArray: choices];
    uniqueEvent3.isUnique = YES;
    
    
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
//    
//    NSArray *events = [NSArray arrayWithObjects: event1, event2, event4, event4, event5, event6, event7, uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4, uniqueEvent5, uniqueEvent6, combatEvent1, combatEvent2, combatEvent3, combatEvent4, nil];
//    
//    return events;
//
//    // Passive Events
//    

//    
//
//

//    

//    

//    

    //    Event *event8 = [Event new];
    //    event8.eventDescription = @"You wonder what your family is doing now. You almost trip over a rock and are brought back to reality.";
    //    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherWood, nil];
    //    event8.choices = [NSArray arrayWithArray: choices];
//    

//    
//    Event *event10 = [Event new];
//    event10.eventDescription = @"You notice an abandoned wagon. You can see some metal inside.";
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
//    event10.choices = [NSArray arrayWithArray: choices];
//    
//    Event *event11 = [Event new];
//    event11.eventDescription = @"You walk over a gold vein.";
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal,nil];
//    event11.choices = [NSArray arrayWithArray: choices];
//    
//    Event *event12 = [Event new];
//    event12.eventDescription = @"You walk over a silver vein.";
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
//    event12.choices = [NSArray arrayWithArray: choices];
//    
//    Event *event13 = [Event new];
//    event13.eventDescription = @"You walk over an iron vein.";
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal,nil];
//    event13.choices = [NSArray arrayWithArray: choices];
//    
//    // Unique Events
//    


//    
//    // Unique Event 3
//    
//    // Initialize a special choice for the event
//    Choice *rootChoice1 = [[Choice alloc] initWithChoiceDescription: @"Rip your foot loose."];
//    
//    // Initialize the special choice's result event
//    Event *rootChoice1Result1 = [Event new];
//    rootChoice1Result1.eventDescription = @"You get free.";
//    rootChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherWood, nil];
//    
//    // Initialize the special choice's result event
//    Event *rootChoice1Result2 = [Event new];
//    rootChoice1Result2.eventDescription = @"You injure yourself. Suddenly a bear chases you down and eats you alive.";
//    rootChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];
//    
//    NSMutableArray *rootChoice1Results = [NSMutableArray arrayWithObjects: rootChoice1Result1, rootChoice1Result2, nil];
//    rootChoice1.resultEvents = rootChoice1Results;
//    
//    // Initialize another special choice for the event
//    Choice *rootChoice2 = [[Choice alloc] initWithChoiceDescription: @"Carefully remove your foot from the root."];
//    
//    // Initialize the special choice's result event
//    Event *rootChoice2Result1 = [Event new];
//    rootChoice2Result1.eventDescription = @"You get free.";
//    rootChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherWood, nil];
//    
//    // Initialize the special choice's result event
//    Event *rootChoice2Result2 = [Event new];
//    rootChoice2Result2.eventDescription = @"You're too focused to notice a hungry bear behind you, you are attacked and die.";
//    rootChoice2Result2.choices = [NSArray arrayWithObjects: endGame, nil];
//    
//    NSMutableArray *rootChoice2Results = [NSMutableArray arrayWithObjects: rootChoice2Result1, rootChoice2Result2, nil];
//    rootChoice2.resultEvents = rootChoice2Results;
//    
//    // Repopulate choices for the unique event. They include the unique choice and the defaults
//    choices = [NSArray arrayWithObjects: rootChoice1, rootChoice2, nil];
//    
//    // Initialize the unique event finally with its choices
//    Event *uniqueEvent3 = [Event new];
//    uniqueEvent3.eventDescription = @"Your foot gets caught in a root trap.";
//    uniqueEvent3.choices = [NSArray arrayWithArray: choices];
//    uniqueEvent3.isUnique = YES;
//    
//    // Unique Event 4
//    
//    // Initialize a special choice for the event
//    Choice *glowingChoice1 = [[Choice alloc] initWithChoiceDescription: @"Check it out."];
//    
//    // Initialize the special choice's result event
//    Event *glowingChoice1Result1 = [Event new];
//    glowingChoice1Result1.eventDescription = @"You reach into the bush and grab a tiny cat. It meows sharply at you and leaps away.";
//    glowingChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
//    
//    // Initialize the special choice's result event
//    Event *glowingChoice1Result2 = [Event new];
//    glowingChoice1Result2.eventDescription = @"A black, amorphus figure leaps out at you and you die.";
//    glowingChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];
//    
//    NSMutableArray *glowingChoice1Results = [NSMutableArray arrayWithObjects: glowingChoice1Result1, glowingChoice1Result2, nil];
//    glowingChoice1.resultEvents = glowingChoice1Results;
//    
//    // Repopulate choices for the unique event. They include the unique choice and the defaults
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, glowingChoice1, nil];
//    
//    // Initialize the unique event finally with its choices
//    Event *uniqueEvent4 = [Event new];
//    uniqueEvent4.eventDescription = @"You notice glowing eyes in a thick bush.";
//    uniqueEvent4.choices = [NSArray arrayWithArray: choices];
//    uniqueEvent4.isUnique = YES;
//    
//    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];
//    
//    Event *combatEvent1 = [Event new];
//    combatEvent1.eventDescription = @"You encounter a giant spider.";
//    combatEvent1.choices = [NSArray arrayWithArray: choices];
//    combatEvent1.isCombatEvent = YES;
//    
//    Event *combatEvent2 = [Event new];
//    combatEvent2.eventDescription = @"A wild and hungry snake appears.";
//    combatEvent2.choices = [NSArray arrayWithArray: choices];
//    combatEvent2.isCombatEvent = YES;
//    
//    Event *combatEvent3 = [Event new];
//    combatEvent3.eventDescription = @"A giant, rabid wolf appears";
//    combatEvent3.choices = [NSArray arrayWithArray: choices];
//    combatEvent3.isCombatEvent = YES;
//    
//    // Craft events
//    Choice *craftWeapon = [[Choice alloc] initWithChoiceDescription: @"Upgrade Weapon"];
//    [craftWeapon createBasicResultEventWithString:@"You successfully upgraded your weapon"];
//    choices = [NSArray arrayWithObjects: moveForward, moveBackward, craftWeapon, nil];
//    
//    Event *craftEvent1 = [Event new];
//    craftEvent1.eventDescription = @"You find an abandoned home. There are tools inside. Maybe you shoud craft or a weapon.";
//    craftEvent1.choices = [NSArray arrayWithArray: choices];
//    
//    Event *craftEvent2 = [Event new];
//    craftEvent2.eventDescription = @"You find an anvil and hammer.";
//    craftEvent2.choices = [NSArray arrayWithArray: choices];
//    
//    //    Event *craftEvent3 = [Event new];
//    //    craftEvent3.eventDescription = @"You find a gray hut with tools";
//    //    craftEvent3.choices = [NSArray arrayWithArray: choices];
//    
//    // add craftEvent3 later
//    NSArray *events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8,
//                       event10, event11, event12, event13,
//                       uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4,
//                       combatEvent1, combatEvent2, combatEvent3,
//                       craftEvent1, craftEvent2,
//                       nil];
//    return events;
    return nil;
}

@end
