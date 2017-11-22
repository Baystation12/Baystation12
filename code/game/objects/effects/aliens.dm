/*
 * Acid
 */
 #define ACID_STRONG     2
 #define ACID_MODERATE   1.5
 #define ACID_WEAK       1
/obj/effect/acid
	name = "acid"
	desc = "Burbling corrosive stuff. Probably a bad idea to roll around in it."
	icon_state = "acid"
	icon = 'icons/mob/alien.dmi'

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/ticks = 0
	var/acid_strength = ACID_WEAK
	var/melt_time = 10 SECONDS

/obj/effect/acid/New(loc, supplied_target)
	..(loc)
	target = supplied_target
	melt_time = melt_time / acid_strength

	melt_stuff()

/obj/effect/acid/proc/melt_stuff()
	spawn(1)
		var/melted = target.acid_melt(melt_time)
		sleep(melt_time)
		if(melted)
			qdel(src)
		else
			melt_stuff()

/atom/proc/acid_melt(var/melt_time)
	visible_message("<span class='alium'>Acid hits \the [src] with a sizzle!</span>")
	for(var/i = 0, i < 4, i++)
		sleep(melt_time)
		visible_message("<span class='alium'>The acid melts \the [src]!</span>")
	visible_message("<span class='alium'>The acid melts \the [src] away into nothing!</span>")
	qdel(src)
	return TRUE
