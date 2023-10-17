//Synthesizer and minimoog. They work the same

/datum/sound_player/synthesizer
	volume = 40
	range = 10
	falloff = 1

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is not good for your hearing."
	icon_state = "synthesizer"
	anchored = TRUE
	density = TRUE
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.real_instrument.player.song.autorepeat)


//in-hand version
/obj/item/device/synthesized_instrument/synthesizer
	name = "Synthesizer Mini"
	desc = "The power of an entire orchestra in a handy midi keyboard format."
	icon_state = "h_synthesizer"
	item_state = "h_synthesizer"
	slot_flags = SLOT_BACK
	path = /datum/instrument
	sound_player = /datum/sound_player/synthesizer

/obj/structure/synthesized_instrument/synthesizer/minimoog
	name = "space minimoog"
	desc = "This is a minimoog, like a space piano, but more spacey!"
	icon_state = "minimoog"
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_ANCHORABLE
