/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = 1 // -- TLE
	movement_handlers = list(/datum/movement_handler/no_move)

/mob/living/silicon/decoy/New()
	src.icon = 'icons/mob/AI.dmi'
	src.icon_state = "ai"
	src.anchored = 1

/mob/living/silicon/decoy/Initialize()
	atom_flags |= ATOM_FLAG_INITIALIZED
	return INITIALIZE_HINT_NORMAL
