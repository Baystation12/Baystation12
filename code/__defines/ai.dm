// Defines for the ai_intelligence var.
// Controls if the mob will do 'advanced tactics' like running from grenades.
#define AI_DUMB			1 // Be dumber than usual.
#define AI_NORMAL		2 // Default level.
#define AI_SMART		3 // Will do more processing to be a little smarter, like not walking while confused if it could risk stepping randomly onto a bad tile.

#define ai_log(M,V)	if(debug_ai) ai_log_output(M,V)

// Logging level defines.
#define AI_LOG_OFF		0 // Don't show anything.
#define AI_LOG_ERROR	1 // Show logs of things likely causing the mob to not be functioning correctly.
#define AI_LOG_WARNING	2 // Show less serious but still helpful to know issues that might be causing things to work incorrectly.
#define AI_LOG_INFO		3 // Important regular events, like selecting a target or switching stances.
#define AI_LOG_DEBUG	4 // More detailed information about the flow of execution.
#define AI_LOG_TRACE	5 // Even more detailed than the last. Will absolutely flood your chatlog.

// Results of pre-movement checks.
// Todo: Move outside AI code?
#define MOVEMENT_ON_COOLDOWN	-1	// Recently moved and needs to try again soon.
#define MOVEMENT_FAILED			0	// Move() returned false for whatever reason and the mob didn't move.
#define MOVEMENT_SUCCESSFUL		1	// Move() returned true and the mob hopefully moved.

// Results of pre-attack checks.
#define ATTACK_ON_COOLDOWN		-1	// Recently attacked and needs to try again soon.
#define ATTACK_FAILED			0	// Something else went wrong! Maybe they moved away!
#define ATTACK_SUCCESSFUL		1	// We attacked (or tried to, misses count too)

// Reasons for targets to not be valid. Based on why, the AI responds differently.
#define AI_TARGET_VALID			0 // We can fight them.
#define AI_TARGET_INVIS			1 // They were in field of view but became invisible. Switch to STANCE_BLINDFIGHT if no other viable targets exist.
#define AI_TARGET_NOSIGHT		2 // No longer in field of view. Go STANCE_REPOSITION to their last known location if no other targets are seen.
#define AI_TARGET_ALLY			3 // They are an ally. Find a new target.
#define AI_TARGET_DEAD			4 // They're dead. Find a new target.
#define AI_TARGET_INVINCIBLE	5 // Target is currently unable to receive damage for whatever reason. Find a new target or wait.

// Stances to determine AI state.
#define STANCE_SLEEP        0	// Doing (almost) nothing, to save on CPU because nobody is around to notice or the mob died.
#define STANCE_IDLE         1	// The more or less default state. Wanders around, looks for baddies, and spouts one-liners.
#define STANCE_ALERT        2	// A baddie is visible but not too close, and essentially we tell them to go away or die.
#define STANCE_APPROACH     3	// Attempting to get into range to attack them.
#define STANCE_FIGHT	    4	// Actually fighting, with melee or ranged.
#define STANCE_BLINDFIGHT   5	// Fighting something that cannot be seen by the mob, from invisibility or out of sight.
#define STANCE_REPOSITION   6	// Relocating to a better position while in combat. Also used when moving away from a danger like grenades.
#define STANCE_MOVE         7	// Similar to above but for out of combat. If a baddie is seen, they'll cancel and fight them.
#define STANCE_FOLLOW       8	// Following somone, without trying to murder them.
#define STANCE_FLEE         9	// Run away from the target because they're too spooky/we're dying/some other reason.
#define STANCE_DISABLED     10	// Used when the holder is afflicted with certain status effects, such as stuns or confusion.

#define STANCE_ATTACK       11  // Backwards compatability
#define STANCE_ATTACKING    12  // Ditto

#define STANCES_COMBAT      list(STANCE_ALERT, STANCE_APPROACH, STANCE_FIGHT, STANCE_BLINDFIGHT, STANCE_REPOSITION)
