/obj/visual_effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	simulated = 0
	mouse_opacity = 0
	var/life_ticks			// How many ticks this effect will live before it stops processing.
							// Will be set to a random number between life_ticks_min and life_ticks_max if unspecified.

	var/life_ticks_max		// The high limit for the random tick picker.
	var/life_ticks_min		// The low limit for the random tick picker.

/obj/visual_effect/New(var/life_min = 3 SECONDS, var/life_max = 5 SECONDS)
	..()
	life_ticks_min = life_min
	life_ticks_max = life_max
	if (!life_ticks)
		life_ticks = rand(life_ticks_min, life_ticks_max)

// Called when the visual_effect is manifested.
/obj/visual_effect/proc/start()

// Called every effects processor tick. Return value determines what the process does to this object.
/obj/visual_effect/proc/tick()
	if (!life_ticks)	
		return EFFECT_DESTROY

	life_ticks--
	return EFFECT_CONTINUE

/obj/visual_effect/Destroy()
	STOP_VISUAL(src)
	return ..()
