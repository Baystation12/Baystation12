// Quick and deliberate movements are not necessarily mutually exclusive
#define MOVE_INTENT_DELIBERATE FLAG(0)
#define MOVE_INTENT_EXERTIVE   FLAG(1)
#define MOVE_INTENT_QUICK      FLAG(2)

/decl/move_intent
	var/name
	var/flags = 0
	var/move_delay = 1
	var/hud_icon_state

/decl/move_intent/proc/can_be_used_by(var/mob/user)
	if(flags & MOVE_INTENT_QUICK)
		return user.can_sprint()
	return TRUE

/decl/move_intent/creep
	name = "Creep"
	flags = MOVE_INTENT_DELIBERATE
	hud_icon_state = "creeping"

/decl/move_intent/creep/Initialize()
	. = ..()
	move_delay = config.creep_delay

/decl/move_intent/walk
	name = "Walk"
	hud_icon_state = "walking"

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = config.walk_delay

/decl/move_intent/run
	name = "Run"
	flags = MOVE_INTENT_EXERTIVE | MOVE_INTENT_QUICK
	hud_icon_state = "running"

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = config.run_delay
