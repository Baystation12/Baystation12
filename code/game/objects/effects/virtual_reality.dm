// This file holds different objects used to facilitate the VR system.

// Used to mark spawn locations for VR. unlike landmarks, these aren't deleted, and are kept after template copy to designate valid spawn locations
/obj/effect/vr_spawn
	name = "vr spawn"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	//simulated = FALSE // keeping this for posterity - the area copy_contents_to proc doesn't copy unsimulated objects, so we need this as-is
	invisibility = 101
