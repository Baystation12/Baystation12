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
	var/acid_strength = ACID_WEAK
	var/melt_time = 10 SECONDS
	var/last_melt = 0

/obj/effect/acid/New(loc, supplied_target)
	..(loc)
	target = supplied_target
	melt_time = melt_time / acid_strength
	START_PROCESSING(SSprocessing, src)

/obj/effect/acid/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	target = null
	. = ..()

/obj/effect/acid/Process()
	if(QDELETED(target))
		qdel(src)
	else if(world.time > last_melt + melt_time)
		var/done_melt = target.acid_melt()
		last_melt = world.time
		if(done_melt)
			qdel(src)

/atom/var/acid_melted = 0

/atom/proc/acid_melt()
	. = FALSE
	switch(acid_melted)
		if(0)
			visible_message("<span class='alium'>Acid hits \the [src] with a sizzle!</span>")
		if(1 to 3)
			visible_message("<span class='alium'>The acid melts \the [src]!</span>")
		if(4)
			visible_message("<span class='alium'>The acid melts \the [src] away into nothing!</span>")
			. = TRUE
			qdel(src)
	acid_melted++
