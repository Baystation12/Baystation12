obj/effect/decal/cleanable/scorchmark
	//this is used as an additional visual result of fire and as a reagent holder for fuel created by burning of turfs and items.
	icon = 'icons/effects/scorchmark.dmi'
	name = "Soot"
	icon_state = "1"
	layer = TURF_LAYER+0.1
	anchored = 1
	var/amount = 0 //starts always empty and is filled by procs called by fire

	New(newLoc,start_amount=0)
		..()

		icon_state = pick("1","2","3","4","5","6","7","8","9")
		dir = pick(cardinal)
		amount = start_amount