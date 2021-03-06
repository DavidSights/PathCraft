//
//  ForrestEnviroment.m
//  PathCraft
//
//  Created by David Seitz Jr on 7/11/15.
//  Copyright (c) 2015 DavidSights. All rights reserved.
//

#import "ForrestEnviroment.h"
#import "Event.h"
#import "Choice.h"

@implementation ForrestEnviroment

- (instancetype)init {
    self = [super init];
    if (self) {
        self.environmentDescription = @"Forest";
        self.events = [self generateEvents];
    }
    return self;
}

- (NSArray *) generateEvents {

    // Choices

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
    victoryEvent.eventDescription = @"You defeated the enemy!";
    victoryEvent.choices = [NSArray arrayWithObjects: moveForward, gatherMeat, moveBackward, nil];
    
    [fight initializeResultEventsWithEvent: victoryEvent];
    [fight createEndGameResultEventWithString: @"The enemy killed you."];

    Choice *flee = [[Choice alloc] initWithChoiceDescription:@"Flee"];
    [flee createBasicResultEventWithString: @"You successfully escaped."];
    [flee createEndGameResultEventWithString: @"You try to escape. You slip on leaves and get caught. You suffered a quick and painful death."];

    Choice *feedEnemy = [[Choice alloc] initWithChoiceDescription:@"Feed Enemy"];
    [feedEnemy createBasicResultEventWithString:@"You fed the enemy, and successfully escaped."];

    // Passive Events

    NSArray *choices;
    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around. Here, there and everywhere. You are in a forest of trees.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward,  nil];
    event1.choices = [NSArray arrayWithArray: choices];

    Event *event2 = [Event new];
    event2.eventDescription = @"Sun light peeks through leaves of a tree.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event2.choices = [NSArray arrayWithArray: choices];

    Event *event3 = [Event new];
    event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event3.choices = [NSArray arrayWithArray: choices];

    Event *event4 = [Event new];
    event4.eventDescription = @"Your feet are kind of sore.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event4.choices = [NSArray arrayWithArray: choices];

    Event *event5 = [Event new];
    event5.eventDescription = @"The smell of nature is thick here. Hm.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event5.choices = [NSArray arrayWithArray: choices];

    Event *event6 = [Event new];
    event6.eventDescription = @"You notice that you smell kind of bad. Oh well.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event6.choices = [NSArray arrayWithArray: choices];

    Event *event7 = [Event new];
    event7.eventDescription = @"A bird flies past your face. That was a little too close for comfort.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event7.choices = [NSArray arrayWithArray: choices];

    Event *event8 = [Event new];
    event8.eventDescription = @"You wonder what your family is doing now. You almost trip over a rock and are brought back to reality.";
    choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    event8.choices = [NSArray arrayWithArray: choices];

    Event *event10 = [Event new];
    event10.eventDescription = @"You notice an abandoned wagon. You can see some metal inside.";
    choices = [NSArray arrayWithObjects: moveForward, gatherMetal, moveBackward, nil];
    event10.choices = [NSArray arrayWithArray: choices];

    Event *event11 = [Event new];
    event11.eventDescription = @"You walk over a gold vein.";
    choices = [NSArray arrayWithObjects: moveForward, gatherMetal, moveBackward, nil];
    event11.choices = [NSArray arrayWithArray: choices];

    Event *event12 = [Event new];
    event12.eventDescription = @"You walk over a silver vein.";
    choices = [NSArray arrayWithObjects: moveForward, gatherMetal, moveBackward, nil];
    event12.choices = [NSArray arrayWithArray: choices];

    Event *event13 = [Event new];
    event13.eventDescription = @"You walk over an iron vein.";
    choices = [NSArray arrayWithObjects: moveForward, gatherMetal, moveBackward, nil];
    event13.choices = [NSArray arrayWithArray: choices];

    // Unique Events
    
    // Unique Event 1

    // Initialize the special choice for the event
    Choice *bangingChoice1 = [[Choice alloc] initWithChoiceDescription: @"Check it out"];

    // Initialize the choice's result events
    Event *bangingChoice1Result1 = [Event new];
    bangingChoice1Result1.eventDescription = @"As you move towards the sound, it suddenly stops and something runs away.";
    bangingChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *bangingChoice1Result2 = [Event new];
    bangingChoice1Result2.eventDescription = @"The banging stops, then you hear a banging on your head and you die.";
    bangingChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    NSMutableArray *bangingChoice1Results = [NSMutableArray arrayWithObjects: bangingChoice1Result1, bangingChoice1Result2, nil];
    bangingChoice1.resultEvents = bangingChoice1Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: moveForward, bangingChoice1, moveBackward, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = @"You hear banging like sticks against a tree";
    uniqueEvent1.choices = [NSArray arrayWithArray: choices];
    uniqueEvent1.isUnique = YES;

    // Unique Event 2

    // Initialize a special choice for the event
    Choice *treeChoice1 = [[Choice alloc] initWithChoiceDescription: @"Eat a hanging fruit."];

    // Initialize the special choice's result events
    Event *treeChoice1Result1 = [Event new];
    treeChoice1Result1.eventDescription = @"That was delicious. Nature's candy.";
    treeChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *treeChoice1Result2 = [Event new];
    treeChoice1Result2.eventDescription = @"You choke with no one around to help and die.";
    treeChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *treeChoice1Results = [NSMutableArray arrayWithObjects: treeChoice1Result1, treeChoice1Result2, nil];
    treeChoice1.resultEvents = treeChoice1Results;

    // Initialize another special choice for the event
    Choice *treeChoice2 = [[Choice alloc] initWithChoiceDescription: @"Eat a fallen fruit."];

    // Initialize the special choice's result events
    Event *treeChoice2Result1 = [Event new];
    treeChoice2Result1.eventDescription = @"It tastes foul. When you finish eating the fruit, you feel a light buzz. Nice.";
    treeChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *treeChoice2Result2 = [Event new];
    treeChoice2Result2.eventDescription = @"Your tummy aches so badly after eating the fruit that you curl up and lay on the ground. Eventually you fall asleep and never wake up again.";
    treeChoice2Result2.choices = [NSArray arrayWithObjects: endGame, nil];

    NSMutableArray *treeChoice2Results = [NSMutableArray arrayWithObjects: treeChoice2Result1, treeChoice2Result2, nil];
    treeChoice2.resultEvents = treeChoice2Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: moveForward, treeChoice1, treeChoice2, moveBackward, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You find a fruit tree. Fallen fruits litter the ground.";
    uniqueEvent2.choices = [NSArray arrayWithArray: choices];
    uniqueEvent2.isUnique = YES;
    
    // Unique Event 3
    
    // Initialize a special choice for the event
    Choice *rootChoice1 = [[Choice alloc] initWithChoiceDescription: @"Rip your foot loose."];
    
    // Initialize the special choice's result event
    Event *rootChoice1Result1 = [Event new];
    rootChoice1Result1.eventDescription = @"The roots are snagged off of your foot. You are free.";
    rootChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    
    // Initialize the special choice's result event
    Event *rootChoice1Result2 = [Event new];
    rootChoice1Result2.eventDescription = @"You injure yourself. Suddenly a bear chases you down and eats you alive.";
    rootChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    
    NSMutableArray *rootChoice1Results = [NSMutableArray arrayWithObjects: rootChoice1Result1, rootChoice1Result2, nil];
    rootChoice1.resultEvents = rootChoice1Results;
    
    // Initialize another special choice for the event
    Choice *rootChoice2 = [[Choice alloc] initWithChoiceDescription: @"Carefully remove your foot from the root."];
    
    // Initialize the special choice's result event
    Event *rootChoice2Result1 = [Event new];
    rootChoice2Result1.eventDescription = @"With a bit of careful effort, the roots fall away from your foot.";
    rootChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, gatherWood, moveBackward, nil];
    
    // Initialize the special choice's result event
    Event *rootChoice2Result2 = [Event new];
    rootChoice2Result2.eventDescription = @"You're too focused to notice a hungry bear behind you, you are attacked and you die.";
    rootChoice2Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    
    NSMutableArray *rootChoice2Results = [NSMutableArray arrayWithObjects: rootChoice2Result1, rootChoice2Result2, nil];
    rootChoice2.resultEvents = rootChoice2Results;
    
    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: rootChoice1, rootChoice2, nil];
    
    // Initialize the unique event finally with its choices
    Event *uniqueEvent3 = [Event new];
    uniqueEvent3.eventDescription = @"Your foot gets caught in a root trap.";
    uniqueEvent3.choices = [NSArray arrayWithArray: choices];
    uniqueEvent3.isUnique = YES;
    
    // Unique Event 4
    
    // Initialize a special choice for the event
    Choice *glowingChoice1 = [[Choice alloc] initWithChoiceDescription: @"Check it out."];
    
    // Initialize the special choice's result event
    Event *glowingChoice1Result1 = [Event new];
    glowingChoice1Result1.eventDescription = @"You reach into the bush and grab a tiny cat. It meows sharply at you, and leaps away.";
    glowingChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];
    
    // Initialize the special choice's result event
    Event *glowingChoice1Result2 = [Event new];
    glowingChoice1Result2.eventDescription = @"A black, amorphus figure leaps out at you. Your life flashes before your eyes. You die.";
    glowingChoice1Result2.choices = [NSArray arrayWithObjects: endGame, nil];
    
    NSMutableArray *glowingChoice1Results = [NSMutableArray arrayWithObjects: glowingChoice1Result1, glowingChoice1Result2, nil];
    glowingChoice1.resultEvents = glowingChoice1Results;
    
    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: moveForward, glowingChoice1, moveBackward, nil];
    
    // Initialize the unique event finally with its choices
    Event *uniqueEvent4 = [Event new];
    uniqueEvent4.eventDescription = @"You notice glowing eyes in a thick bush.";
    uniqueEvent4.choices = [NSArray arrayWithArray: choices];
    uniqueEvent4.isUnique = YES;

    // Combat Choices
    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];

    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"A giant, hairy spider leaps out from a hole you didn't notice.";
    combatEvent1.choices = [NSArray arrayWithArray: choices];
    combatEvent1.isCombatEvent = YES;

    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"A giant snake appears. It looks fast. And hungry.";
    combatEvent2.choices = [NSArray arrayWithArray: choices];
    combatEvent2.isCombatEvent = YES;

    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"A crazed wolf appears. It growls at you. What big teeth it has.";
    combatEvent3.choices = [NSArray arrayWithArray: choices];
    combatEvent3.isCombatEvent = YES;
    
    // Craft events
    Choice *craftWeapon = [[Choice alloc] initWithChoiceDescription: @"Upgrade Weapon"];
    [craftWeapon createBasicResultEventWithString:@"You successfully upgraded your weapon!"];
    choices = [NSArray arrayWithObjects: moveForward, craftWeapon, moveBackward, nil];
    
    Event *craftEvent1 = [Event new];
    craftEvent1.eventDescription = @"You see an abandoned home. There are tools inside. Use wood and metal to craft or upgrade a weapon.";
    craftEvent1.choices = [NSArray arrayWithArray: choices];
    
    Event *craftEvent2 = [Event new];
    craftEvent2.eventDescription = @"You find an anvil and a hammer. Use wood and metal to craft or upgrade a weapon.";
    craftEvent2.choices = [NSArray arrayWithArray: choices];
    
//    Event *craftEvent3 = [Event new];
//    craftEvent3.eventDescription = @"You find a gray hut with tools";
//    craftEvent3.choices = [NSArray arrayWithArray: choices];

    // add craftEvent3 later
    NSArray *events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8,
                       event10, event11, event12, event13,
                       uniqueEvent1, uniqueEvent2, uniqueEvent3, uniqueEvent4,
                       combatEvent1, combatEvent2, combatEvent3,
                       craftEvent1, craftEvent2,
                       nil];
    return events;
}


@end
