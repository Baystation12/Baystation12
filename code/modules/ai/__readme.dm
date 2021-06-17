/*
[Summary]

This module contains an AI implementation designed to be (at the base level) mobtype-agnostic,
by being held inside a datum instead of being written into the mob directly. More specialized
subtypes of the base AI may be designed with a specific mob type in mind, but the base system
should be compatible with most types of mobs which have the needed Interfaces in place to
support them.

When designing a new mob, all that is needed to give a mob an AI is to set
its 'ai_holder_type' variable to the path of the AI that is desired.


[Seperation]

In previous iterations of AI systems, the AI is generally written into the mob's code directly,
which has some advantages, but often makes the code rigid, and also tied the speed of the AI
to the mob's own ticker, meaning it could only decide every two seconds.

Instead, this version has the code for the AI held inside an /datum/ai_holder object,
which is carried by the mob it controls. This gives some advantages;
	All /mob/living mobs can potentially have an AI applied to them, and utilize the
	same base code while adding specialized code on top.

	Interfaces allow the base AI code to not need to know what particular mode it's controlling.

	The processing of the AI is independant of the mob's Life() cycle, which allows for a
	different clock rate.

	Seperating the AI from the mob simplies the mob's code greatly.

	It is more logical to think that a mob is the 'body', where as its ai_holder is
	the 'mind'.

	AIs can be applied or disabled on the fly by instantiating or deleting the
	ai_holder, if needed.


The current implementation also has some disadvantages, but they can perhaps be resolved
in the future.
	AI-driven mob movement and attack speed is tied to half-second delays due to the
	AI subsystem ticking at that rate. Porting the timer subsystem and integrating
	callbacks into basic AI actions (moving, attacking) can potentially resolve that.

	It can be difficult to modify AI variables at mob instantiation without an ugly
	delay, as the ai_holder might not exist yet.


[Flow of Processing]

Terrible visual representation here;
AI Subsystem	-> Every 0.5s -> /datum/ai_holder/handle_tactics()	-> switch(stance)...
				-> Every 2.0s -> /datum/ai_holder/handle_strategicals()	-> switch(stance)...

The AI datum is not processed by the mob itself, but instead it is directly processed
by a new AI subsystem. The AI subsystem contains a list of all active ai_holder
objects, which is iterated every tick to process each individual ai_holder
object attached to a mob.

Each ai_holder actually has two 'tracks' for processing, a 'fast' track
and a 'slow' track.

The fast track is named handle_tactics(), and is called every 0.5 seconds.

The slow track is named handle_strategicals(), and is called every 2 seconds.

When an ai_holder is iterated on inside the AI subsystem's list, it first
calls that ai_holder's handle_tactics(). It will then call that ai_holder's
handle_strategicals() every fourth tick, effectively doing so every two seconds.

Both functions do different things depending on which 'stance' the
ai_holder is in. See the Stances section for more information.

The fast track is for 'cheap' processing that needs to happen fast, such as
walking along a path, initiating an attack, or firing a gun. The rate that
it is called allows for the ai_holder to interact with the world through
its mob very often, giving a more convincing appearance of intelligence,
allowing for faster reaction times to certain events, and allowing for
variable attack speeds that would not be possible when bound to a
two second Life() cycle.

The slow track, on the other hand, is for 'expensive' processing that might
be too demanding on the CPU to do every half a second, such as
re/calculating an A* path (if the mob uses A*), or running a complicated
tension assessment to determine how brave the mob is feeling. This is the
same delay used for certain tasks in the old implementation, but it is less
noticable due to the mob appearing to do things inbetween those two seconds.

The purpose of having two tracks is to allow for 'fast' and 'slow' actions
to be more easily encapsulated, and ensures that all ai_holders are syncronized
with each other, as opposed to having individual tick counters inside all of
the ai_holder instances.  It should be noted that handle_tactics() is always
called first, before handle_strategicals() every two seconds.

[Process Skipping]

An ai_holder object can choose to enter a 'busy' state, or a 'sleep' state,
in order to avoid processing.

When busy, the AI subsystem will skip over the ai_holder until it is no
longer busy. The busy state is intended to be short-term, and is usually
toggled by the mob when doing something with a delay, so that the ai_holder
does not accidentally do something to inturrupt something important, like
a special attack.

The longer term alternative to the busy state is the sleep state. Unlike
being busy, an ai_holder set to sleep will remove itself from the
AI subsystem's list, meaning it will no longer process until something
else 'wakes' it. This is usually done when the mob dies or a client
logs into an AI-controlled mob (and the AI is not set to ignore that,
with the autopilot variable). If the mob is revived, the AI will be
awakened automatically.

The ai_holder functions, and mob functions that are called by the
ai_holder, should not be sleep()ed, as it will block the AI Subsystem
from processing the other ai_holders until the sleep() finishes.
Delays on the mob typically have set waitfor = FALSE, or spawn() is used.


[Stances]

The AI has a large number of states that it can be in, called stances.
The AI will act in a specific way depending on which stance it is in,
and only one stance can be active at a time. This effectively creates
a state pattern.

To change the stance, set_stance() is used, with the new stance as
the first argument. It should be noted that the change is not immediate,
and it will react to the change next tick instead of immediately switching
to the new stance and acting on that in the same tick. This is done to help
avoid infinite loops (I.E. Stance A switches to Stance B, which then
switches to Stance A, and so on...), and the delay is very short so
it should not be an issue.

See code/__defines/mob.dm for a list of stance defines, and descriptions
about their purpose. Generally, each stance has its own file in the AI
module folder and are mostly self contained, however some files instead
deal with general things that other stances may require, such as targeting
or movement.

[Interfaces]

Interfaces are a concept that is used to help bridge the gap between
the ai_holder, and its mob. Because the (base) ai_holder is explicitly
designed to not be specific to any type of mob, all that it knows is
that it is controlling a /mob/living mob. Some mobs work very differently,
between mob types such as /mob/living/simple_animal, /mob/living/silicon/robot,
/mob/living/carbon/human, and more.

The solution to the vast differences between mob types is to have the
mob itself deal with how to handle a specific task, such as attacking
something, talking, moving, etc. Interfaces exist to do this.

Interfaces are applied on the mob-side, and are generally specific to
that mob type. This lets the ai_holder not have to worry about specific
implementations and instead just tell the Interface that it wants to attack
something, or move into a tile. The AI does not need to know if the mob its
controlling has hands, instead that is the mob's responsibility.

Interface functions have an uppercase I at the start of the function name,
and then the function they are bridging between the AI and the mob
(if it exists), e.g. IMove(), IAttack(), ISay().

Interfaces are also used for the AI to ask its mob if it can do certain
things, without having to actually know what type of mob it is attached to.
For example, ICheckRangedAttack() tells the AI if it is possible to do a
ranged attack. For simple_mobs, they can if a ranged projectile type was set,
where as for a human mob, it could check if a gun is in a hand. For a borg,
it could check if a gun is inside their current module.

[Say List]

A /datum/say_list is a very light datum that holds a list of strings for the
AI to have their mob say based on certain conditions, such as when threatening
to kill another mob. Despite the name, a say_list also can contain emotes
and some sounds.

The reason that it is in a seperate datum is to allow for multiple mob types
to have the same text, even when inheritence cannot do that, such as
mercenaries and fake piloted mecha mobs.

The say_list datum is applied to the mob itself and not held inside the AI datum.

[Subtypes]

Some subtypes of ai_holder are more specialized, but remain compatible with
most mob types. There are many different subtypes that make the AI act different
by overriding a function, such as kiting their target, moving up close while
using ranged attacks, or running away if not cloaked.

Other subtypes are very specific about what kind of mob it controls, and trying
to apply them to a different type of mob will likely result in a lot of bugs
or ASSERT() failures. The xenobio slime AI is an example of the latter.

To use a specific subtype on a mob, all that is needed is setting the mob's
ai_holder_type to the subtype desired, and it will create that subtype when
the mob is initialize()d. Switching to a subtype 'live' will require additional
effort on the coder.


*/