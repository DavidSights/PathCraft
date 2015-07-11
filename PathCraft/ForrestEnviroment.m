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

//    NSString *moveForward = @"Move Forward";
    Choice *moveForward = [[Choice alloc] initWithChoiceDescription: @"Move Forward"];

    Choice *moveBackward = [[Choice alloc] initWithChoiceDescription: @"Move Backwards"];

    NSString *moveBackward = @"Move Backwards";

    // Resources
    NSString *gatherWood = @"Gather Wood"; // What happens after you gather wood? - Voice over "gathered wood" and then move forward.
    NSString *gatherMetal = @"Gather Metal";
    NSString *gatherMeat = @"Gather Meat"; // Not for eating/healing, but for guarenteed fleeing - feed monster choice.

    // Combat
    Choice *fight = [[Choice alloc] initWithChoiceDescription:@"Fight"];
    [fight createResultWithString:@"You defeated the enemy."];
    [fight createResultWithString:@"The enemy killed you."];

    Choice *flee = [[Choice alloc] initWithChoiceDescription:@"Flee"];
    [flee createResultWithString:@"You got away."];
    [flee createResultWithString:@"You did not escape. You suffered a quick and painful death."];

    Choice *feedEnemy = [[Choice alloc] initWithChoiceDescription:@"Feed Enemy"];
    [feedEnemy createResultWithString:@"You fed the enemy and successfully escaped."];

    // Root
    NSString *root1 = @"Rip your foot loose."; // R: 1. You get free. 2. You injure yourself. Suddenly a bear chases you down and eats you alive."
    NSString *root2 = @"Carefully remove your foot from the root."; // R: 1. You get free. 2. Too focused to notice a hungry bear behind you, you are attacked and die."

    // Banging
    NSString *banging1 = @"Check it out"; // R: 1. As you move towards the sound, it suddenly stops and something runs away. 2. The bnaging stops, then you hear a banging on your head and you die.

    // Fruit tree
    NSString *tree1 = @"Eat a hanging fruit."; // R: 1. That was delicious. 2. You choke with no one around to help and die.
    NSString *tree2 = @"Eat a fallen fruit."; // R: 1. It tastes foul. When you finish eating the fruit, you feel a light buzz. 2. Your tummy aches so badly after eating noodles the fruit that you curl up and lay on the ground. Eventually you fall asleep and never wake up again.

    // Glowing eyes
    NSString *eyes1 = @"Check it out."; // R: 1. You reach into the bush and grab a tiny cat. It meows sharply at you and leaps away. 2. A black, amorphus figure leaps out at you and you die.


    // Passive Events

    Event *event1 = [Event new];
    event1.eventDescription = @"Trees surround you all around.";
    NSArray *choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event1.choices = choices;

    Event *event2 = [Event new];
    event2.eventDescription = @"Sun light peaks through leaves of a tree.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event2.choices = choices;

    Event *event3 = [Event new];
    event3.eventDescription = @"You think you hear something. You wait and nothing happens.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event3.choices = choices;

    Event *event4 = [Event new];
    event4.eventDescription = @"Your feet are kind of sore.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event4.choices = choices;

    Event *event5 = [Event new];
    event5.eventDescription = @"The smell of nature is thick here.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event5.choices = choices;

    Event *event6 = [Event new];
    event6.eventDescription = @"You notice you smell kind of bad. Oh well.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event6.choices = choices;

    Event *event7 = [Event new];
    event7.eventDescription = @"A bird flies past your face. A little too close for comfort.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event7.choices = choices;

    Event *event8 = [Event new];
    event8.eventDescription = @"You wonder what your family is doing now. You almost trip over a rock and are brought back to reality.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherWood, nil];
    event8.choices = choices;

    Event *event9 = [Event new];
    event9.eventDescription = @"Your foot gets caught in a root trap."; // Was unique event, but changed to regular event because it wouldn't be unusual for this to happen more than once.
    choices = [NSArray arrayWithObjects:root1, root2, nil];
    event9.choices = choices;

    Event *event10 = [Event new];
    event10.eventDescription = @"You notice an abandoned wagon. You can see some metal inside.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event10.choices = choices;

    Event *event11 = [Event new];
    event11.eventDescription = @"You walk over a gold vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event11.choices = choices;

    Event *event12 = [Event new];
    event12.eventDescription = @"You walk over a silver vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event12.choices = choices;

    Event *event13 = [Event new];
    event13.eventDescription = @"You walk over an iron vein.";
    choices = [NSArray arrayWithObjects:moveForward, moveBackward, gatherMetal, nil];
    event13.choices = choices;

    // Unique Events

    Event *uniqueEvent1 = [Event new];
    uniqueEvent1.eventDescription = @"You hear banging like sticks against a tree.";
    choices = [NSArray arrayWithObjects: banging1, moveForward, moveBackward, nil];
    uniqueEvent1.choices = choices;
    uniqueEvent1.isUnique = YES;
    [uniqueEvent1 createResultEventWithString:@"As you move towards the sound, it suddenly stops and something runs away."];
    [uniqueEvent1 createResultEventWithString:@"The banging stops, then you hear a banging on your head and you die."];

    Event *uniqueEvent2 = [Event new];
    uniqueEvent2.eventDescription = @"You find a fruit tree. Fallen fruits litter the ground.";
    choices = [NSArray arrayWithObjects: tree1, tree2, moveForward, moveBackward, nil];
    [uniqueEvent2 createResultEventWithString:@""];
    [uniqueEvent2 createResultEventWithString:@""];

    uniqueEvent2.choices = choices;
    uniqueEvent2.isUnique = YES;

    Event *uniqueEvent3 = [Event new];
    uniqueEvent3.eventDescription = @"You notice glowing eyes in a thick bush.";
    choices = [NSArray arrayWithObjects: eyes1, moveForward, moveBackward, nil];
    uniqueEvent3.choices = choices;
    uniqueEvent3.isUnique = YES;

    // Combat Events --- Stretch goal: Strength Levels!

    Event *combatEvent1 = [Event new];
    combatEvent1.eventDescription = @"You encounter a giant spider.";
    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];
    combatEvent1.choices = choices;
    combatEvent1.isCombatEvent = YES;

    Event *combatEvent2 = [Event new];
    combatEvent2.eventDescription = @"A wild and hungry snake appears.";
    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];
    combatEvent2.choices = choices;
    combatEvent2.isCombatEvent = YES;

    Event *combatEvent3 = [Event new];
    combatEvent3.eventDescription = @"A giant, rabid wolf appears.";
    choices = [NSArray arrayWithObjects: fight, flee, feedEnemy, nil];
    combatEvent3.choices = choices;
    combatEvent3.isCombatEvent = YES;

    // Result Events
    // To be created... Feel free to ask me for clarification. -David

    NSArray *events = [NSArray arrayWithObjects: event1, event2, event3, event4, event5, event6, event7, event8, event9,
                       uniqueEvent1, uniqueEvent2, uniqueEvent3,
                       combatEvent1, combatEvent2, combatEvent3, nil];
    return events;
}

@end
