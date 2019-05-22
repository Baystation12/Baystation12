#define CHORUS_PHASE_OBSERVE 1
#define CHORUS_PHASE_EGG 2
#define CHORUS_PHASE_ADULT 3


/mob/verb/debug()
	set category = "Godhood"
	var/mob/living/chorus/C = new /mob/living/chorus(get_turf(src))
	C.ckey = src.ckey