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
    Choice *gatherWood = [[Choice alloc] initWithChoiceDescription:@"Gather Wood"];
    Choice *gatherMetal = [[Choice alloc] initWithChoiceDescription:@"Gather Metal"];
    Choice *gatherMeat = [[Choice alloc] initWithChoiceDescription:@"Gather Meat"];

    // Combat
    Choice *fight = [[Choice alloc] initWithChoiceDescription:@"Fight"];
    [fight createBasicResultWithString: @"You defeated the enemy."];
    [fight createBasicResultWithString: @"The enemy killed you."];

    Choice *flee = [[Choice alloc] initWithChoiceDescription:@"Flee"];
    [flee createBasicResultWithString:@"You got away."];
    [flee createBasicResultWithString:@"You did not escape. You suffered a quick and painful death."];

    Choice *feedEnemy = [[Choice alloc] initWithChoiceDescription:@"Feed Enemy"];
    [feedEnemy createBasicResultWithString:@"You fed the enemy and successfully escaped."];

    // Root
    Choice *root1 = [[Choice alloc] initWithChoiceDescription: @"Rip your foot loose."]; // R: 1. You get free. 2. You injure yourself. Suddenly a bear chases you down and eats you alive."
    Choice *root2 = [[Choice alloc] initWithChoiceDescription: @"Carefully remove your foot from the root."]; // R: 1. You get free. 2. Too focused to notice a hungry bear behind you, you are attacked and die."

    // Glowing eyes
    // NSString *eyes1 = @"Check it out."; // R: 1. You reach into the bush and grab a tiny cat. It meows sharply at you and leaps away. 2. A black, amorphus figure leaps out at you and you die.


    // Passive Events

    NSArray *choices;
    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around.";
    choices = [NSArray arrayWithObjects: moveForward, moveBackward, gatherWood, nil];
    event1.choices = [NSArray arrayWithArray: choices];

    Event *event2 = [Event new];
    event2.eventDescription = @"Sun light peaks through leaves of a tree.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event2.choices = [NSArray arrayWithArray: choices];

    Event *event3 = [Event new];
    event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event3.choices = [NSArray arrayWithArray: choices];

    Event *event4 = [Event new];
    event4.eventDescription = @"Your feet are kind of sore.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event4.choices = [NSArray arrayWithArray: choices];

    Event *event5 = [Event new];
    event5.eventDescription = @"The smell of nature is thick here.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event5.choices = [NSArray arrayWithArray: choices];

    Event *event6 = [Event new];
    event6.eventDescription = @"You notice you smell kind of bad. Oh well.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event6.choices = [NSArray arrayWithArray: choices];

    Event *event7 = [Event new];
    event7.eventDescription = @"A bird flies past your face. A little too close for comfort.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event7.choices = [NSArray arrayWithArray: choices];

    Event *event8 = [Event new];
    event8.eventDescription = @"You wonder what your family is doing now. You almost trip over a rock and are brought back to reality.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event8.choices = [NSArray arrayWithArray: choices];

    Event *event9 = [Event new];
    event9.eventDescription = @"Your foot gets caught in a root trap."; // Was unique event, but changed to regular event because it wouldn't be unusual for this to happen more than once.
    choices = [NSArray arrayWithObjects: root1, root2, nil];
    event9.choices = [NSArray arrayWithArray: choices];

    Event *event10 = [Event new];
    event10.eventDescription = @"You notice an abandoned wagon. You can see some metal inside.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event10.choices = [NSArray arrayWithArray: choices];

    Event *event11 = [Event new];
    event11.eventDescription = @"You walk over a gold vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event11.choices = [NSArray arrayWithArray: choices];

    Event *event12 = [Event new];
    event12.eventDescription = @"You walk over a silver vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event12.choices = [NSArray arrayWithArray: choices];

    Event *event13 = [Event new];
    event13.eventDescription = @"You walk over an iron vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
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
    bangingChoice1Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *bangingChoice1Results = [NSMutableArray arrayWithObjects: bangingChoice1Result1, bangingChoice1Result2, nil];
    bangingChoice1.resultEvents = bangingChoice1Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: bangingChoice1, moveForward, moveBackward, nil];

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
    treeChoice1Result1.eventDescription = @"That was delicious.";
    treeChoice1Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *treeChoice1Result2 = [Event new];
    treeChoice1Result2.eventDescription = @"You choke with no one around to help and die.";
    treeChoice1Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *treeChoice1Results = [NSMutableArray arrayWithObjects: treeChoice1Result1, treeChoice1Result2, nil];
    treeChoice1.resultEvents = treeChoice1Results;

    // Initialize another special choice for the event
    Choice *treeChoice2 = [[Choice alloc] initWithChoiceDescription: @"Eat a fallen fruit."];

    // Initialize the special choice's result events
    Event *treeChoice2Result1 = [Event new];
    treeChoice2Result1.eventDescription = @"It tastes foul. When you finish eating the fruit, you feel a light buzz.";
    treeChoice2Result1.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    Event *treeChoice2Result2 = [Event new];
    treeChoice2Result2.eventDescription = @"Your tummy aches so badly after eating noodles the fruit that you curl up and lay on the ground. Eventually you fall asleep and never wake up again.";
    treeChoice2Result2.choices = [NSArray arrayWithObjects: moveForward, moveBackward, nil];

    NSMutableArray *treeChoice2Results = [NSMutableArray arrayWithObjects: treeChoice2Result1, treeChoice2Result2, nil];
    treeChoice2.resultEvents = treeChoice2Results;

    // Repopulate choices for the unique event. They include the unique choice and the defaults
    choices = [NSArray arrayWithObjects: treeChoice1, treeChoice2, moveForward, moveBackward, nil];

    // Initialize the unique event finally with its choices
    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You find a fruit tree. Fallen fruits litter the ground.";
    uniqueEvent2.choices = choices;
    uniqueEvent2.isUnique = YES;

//    Event *uniqueEvent3 = [Event new];
//    uniqueEvent3.eventDescription = @"You notice glowing eyes in a thick bush.";
//    choices = [NSArray arrayWithObjects: eyes1, moveForward, moveBackward, nil];
//    uniqueEvent3.choices = choices;
//    uniqueEvent3.isUnique = YES;

    // Combat Events --- Stretch goal: Strength Levels!

    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];

    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"You encounter a giant spider.";
    combatEvent1.choices = choices;
    combatEvent1.isCombatEvent = YES;

    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"A wild and hungry snake appears.";
    combatEvent2.choices = choices;
    combatEvent2.isCombatEvent = YES;

    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"A giant, rabid wolf appears";
    combatEvent3.choices = choices;
    combatEvent3.isCombatEvent = YES;

    // add uniqueEvent3 later
    NSArray *events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8, event9,
                       uniqueEvent1, uniqueEvent2,
                       combatEvent1, combatEvent2, combatEvent3, nil];
    return events;
}


@end
