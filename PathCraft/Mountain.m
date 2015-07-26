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

    [fight initializeResultEventsWithEvent: victoryEvent];
    [fight createEndGameResultEventWithString: @"You have been slain."];

    Choice *flee = [[Choice alloc] initWithChoiceDescription:@"Flee"];
    [flee createBasicResultEventWithString: @"You got away."];
    [flee createEndGameResultEventWithString: @"You fell to your death as you attempted to escape."];

    Choice *feedEnemy = [[Choice alloc] initWithChoiceDescription:@"Feed Enemy"];
    [feedEnemy createBasicResultEventWithString:@"You fed the enemy and successfully escaped."];
    
    NSArray *choices;
    
    // Craft events
    Choice *craftWeapon = [[Choice alloc] initWithChoiceDescription: @"Craft Weapon"];
    [craftWeapon createBasicResultEventWithString:@"You successfully upgraded your weapon."];
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    /* Regular */
    
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
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
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
    event8.eventDescription = @"The sun is so bright and warm.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherMetal, nil];
    event8.choices = [NSArray arrayWithArray: choices];
    
    Event *event9 = [Event new];
    event9.eventDescription = @"You slip and fall to your death.";
    choices = [NSArray arrayWithObjects: endGame, nil];
    event9.choices = [NSArray arrayWithArray: choices];
    
    /* Unique */
    
    // Unique Event 1

    // Initialize the special choice for the event
    Choice *caveChoice1 = [[Choice alloc] initWithChoiceDescription: @"Explore the cave."];

    // Initialize the choice's result events
    Event *caveChoice1Result1 = [Event new];
    caveChoice1Result1.specialResult = YES;
    caveChoice1Result1.eventDescription = @"It's an empty meditation chamber. You sit down and feel centered.";
    caveChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *caveChoice1Result2 = [Event new];
    caveChoice1Result2.specialResult = YES;
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
    processionChoice1Result.specialResult = YES;
    processionChoice1Result.eventDescription = @"They ignore you.";
    processionChoice1Result.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *processionChoice1Results = [NSMutableArray arrayWithObjects: processionChoice1Result, nil];
    processionChoice1.resultEvents = processionChoice1Results;

    // Initialize another special choice for the event
    Choice *processionChoice2 = [[Choice alloc] initWithChoiceDescription: @"Join the procession."];

    // Initialize the special choice's result events
    Event *processionChoice2Result1 = [Event new];
    processionChoice2Result1.specialResult = YES;
    processionChoice2Result1.eventDescription = @"You are ignored.";
    processionChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *processionChoice2Result2 = [Event new];
    processionChoice2Result2.specialResult = YES;
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

    // Initialize a special choice for the event
    Choice *cliffChoice1 = [[Choice alloc] initWithChoiceDescription: @"Move forward for a closer look."];

    // Initialize the special choice's result event
    Event *cliffChoice1Result1 = [Event new];
    cliffChoice1Result1.specialResult = YES;
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
    cliffChoice2Result1.specialResult = YES;
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
    
    // Unique Event 4

    // Initialize a special choice for the event
    Choice *summitChoice1 = [[Choice alloc] initWithChoiceDescription: @"Scurry to the top."];

    // Initialize the special choice's result event
    Event *summitChoice1Result1 = [Event new];
    summitChoice1Result1.specialResult = YES;
    summitChoice1Result1.eventDescription = @"You scream at the top of your lungs. This is the most free you've ever felt!";
    summitChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    // Initialize the special choice's result event
    Event *summitChoice1Result2 = [Event new];
    summitChoice1Result2.specialResult = YES;
    summitChoice1Result2.eventDescription = @"You are left speechless. What can be said about such a sensation.";
    summitChoice1Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *summitChoice1Results = [NSMutableArray arrayWithObjects: summitChoice1Result1, summitChoice1Result2, nil];
    summitChoice1.resultEvents = summitChoice1Results;

    // Initialize another special choice for the event
    Choice *summitChoice2 = [[Choice alloc] initWithChoiceDescription: @"Carefully ascend to the highest point."];

    // Initialize the special choice's result event
    Event *summitChoice2Result1 = [Event new];
    summitChoice2Result1.specialResult = YES;
    summitChoice2Result1.eventDescription = @"You trip and nearly fall. You barely notice the view as you scramble away.";
    summitChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    // Initialize the special choice's result event
    Event *summitChoice2Result2 = [Event new];
    summitChoice2Result2.specialResult = YES;
    summitChoice2Result2.eventDescription = @"What a view and sensation!";
    summitChoice2Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *summitChoice2Results = [NSMutableArray arrayWithObjects: summitChoice2Result1, summitChoice2Result2, nil];
    summitChoice2.resultEvents = summitChoice2Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: summitChoice1, summitChoice2, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent4 = [Event new];
    uniqueEvent4.eventDescription = @"You've arrived at the summit!";
    uniqueEvent4.choices = [NSArray arrayWithArray: choices];
    uniqueEvent4.isUnique = YES;
    
    // Unique Event 5

    // Initialize a special choice for the event
    Choice *mysticalChoice1 = [[Choice alloc] initWithChoiceDescription: @"Approach with caution."];

    // Initialize the special choice's result event
    Event *mysticalChoice1Result1 = [Event new];
    mysticalChoice1Result1.specialResult = YES;
    mysticalChoice1Result1.eventDescription = @"The god rewards you with goods";
    mysticalChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, gatherMetal, gatherWood, craftWeapon, moveBackward, nil];

    // Initialize the special choice's result event
    Event *mysticalChoice1Result2 = [Event new];
    mysticalChoice1Result2.specialResult = YES;
    mysticalChoice1Result2.eventDescription = @"The god is offended and kills you.";
    mysticalChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *mysticalChoice1Results = [NSMutableArray arrayWithObjects: mysticalChoice1Result1, mysticalChoice1Result2, nil];
    mysticalChoice1.resultEvents = mysticalChoice1Results;
    
    // Initialize a special choice for the event
    Choice *mysticalChoice2 = [[Choice alloc] initWithChoiceDescription: @"Run away!"];
    
    // Initialize the special choice's result event
    Event *mysticalChoice2Result1 = [Event new];
    mysticalChoice2Result1.specialResult = YES;
    mysticalChoice2Result1.eventDescription = @"The god ignores you.";
    mysticalChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
    
    // Initialize the special choice's result event
    Event *mysticalChoice2Result2 = [Event new];
    mysticalChoice2Result2.specialResult = YES;
    mysticalChoice2Result2.eventDescription = @"The god is offended and kills you.";
    mysticalChoice2Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    
    NSMutableArray *mysticalChoice2Results = [NSMutableArray arrayWithObjects: mysticalChoice2Result1, mysticalChoice2Result2, nil];
    mysticalChoice2.resultEvents = mysticalChoice2Results;
    
    // Initialize a special choice for the event
    Choice *mysticalChoice3 = [[Choice alloc] initWithChoiceDescription: @"Bow in deference."];
    
    // Initialize the special choice's result event
    Event *mysticalChoice3Result1 = [Event new];
    mysticalChoice3Result1.specialResult = YES;
    mysticalChoice3Result1.eventDescription = @"The god is pleased. It rewards you.";
    mysticalChoice3Result1.choices = [NSArray arrayWithObjects: moveForward, gatherMetal, gatherWood, craftWeapon, moveBackward, nil];
    
    // Initialize the special choice's result event
    Event *mysticalChoice3Result2 = [Event new];
    mysticalChoice3Result2.specialResult = YES;
    mysticalChoice3Result2.eventDescription = @"The god acknowledges you and moves on.";
    mysticalChoice3Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    
    NSMutableArray *mysticalChoice3Results = [NSMutableArray arrayWithObjects: mysticalChoice3Result1, mysticalChoice3Result2, nil];
    mysticalChoice3.resultEvents = mysticalChoice3Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: mysticalChoice1, mysticalChoice2, mysticalChoice3, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent5 = [Event new];
    uniqueEvent5.eventDescription = @"A mystical being appears before you.";
    uniqueEvent5.choices = [NSArray arrayWithArray: choices];
    uniqueEvent5.isUnique = YES;

    /* Combat */
    
    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];
    
    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"You encounter a mountain lion.";
    combatEvent1.choices = [NSArray arrayWithArray: choices];
    combatEvent1.isCombatEvent = YES;
    
    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"Suddenly a pack of wolves surrounds you!";
    combatEvent2.choices = [NSArray arrayWithArray: choices];
    combatEvent2.isCombatEvent = YES;
    
    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"You are attacked by a bear!";
    combatEvent3.choices = [NSArray arrayWithArray: choices];
    combatEvent3.isCombatEvent = YES;
    
    choices = [NSArray arrayWithObjects: fight, flee, nil];
    
    Event *combatEvent4 = [Event new];
    combatEvent4.eventDescription = @"You encounter a group of bandits.";
    combatEvent4.choices = [NSArray arrayWithArray: choices];
    combatEvent4.isCombatEvent = YES;
    
    /* Craftables */
    
    choices = [NSArray arrayWithObjects: moveForward, craftWeapon, moveBackward, nil];
    
    Event *craftEvent1 = [Event new];
    craftEvent1.eventDescription = @"You find a cabin with tools inside. Maybe you should upgrade your weapon.";
    craftEvent1.choices = [NSArray arrayWithArray: choices];
    
    Event *craftEvent2 = [Event new];
    craftEvent2.eventDescription = @"You find a magical stone. Use it to upgrade your weapon.";
    craftEvent2.choices = [NSArray arrayWithArray: choices];

    NSArray *events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8, event9,
                       uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4, uniqueEvent5,
                       combatEvent1, combatEvent2, combatEvent3, combatEvent4,
                       craftEvent1, craftEvent2,
                       nil];
    return events;
}

@end
