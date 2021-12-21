#define SPLISH_SOUNDS_BASE list('code/modules/halo/sounds/water_sfx/splash1.ogg','code/modules/halo/sounds/water_sfx/splash2.ogg')

/turf/unsimulated/beach/water
	var/list/splish_sounds = SPLISH_SOUNDS_BASE

/turf/unsimulated/beach/water/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M, /mob/living))
		playsound(usr.loc, pick(splish_sounds), 50, 1)

/turf/unsimulated/water
	var/list/splish_sounds = SPLISH_SOUNDS_BASE

/turf/unsimulated/water/Entered(atom/movable/M as mob|obj)
	. = ..()
	if(. == 0 && istype(M, /mob/living))
		playsound(usr.loc, pick(splish_sounds), 50, 1)

#undef SPLISH_SOUNDS_BASE