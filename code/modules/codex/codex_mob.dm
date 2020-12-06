/mob/proc/can_use_codex()
	return FALSE

/mob/new_player/can_use_codex()
	return TRUE

/mob/living/silicon/can_use_codex()
	return TRUE

/mob/observer/can_use_codex()
	return TRUE

/mob/living/carbon/human/can_use_codex()
	return TRUE //has_implant(/obj/item/implant/codex, functioning = TRUE)
