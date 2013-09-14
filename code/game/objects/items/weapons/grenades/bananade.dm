var/turf/T

/obj/item/weapon/grenade/bananade
	name = "bananade"
	desc = "A yellow grenade."
	w_class = 2.0
	icon = 'icons/obj/grenade.dmi'
	icon_state = "banana"
	item_state = "flashbang"
	var/deliveryamt = 8
	var/spawner_type = /obj/item/weapon/bananapeel

/obj/item/weapon/grenade/bananade/prime()
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(T, null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash) // flash dose faggots
		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type
			x.loc = T
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))

			// Spawn some hostile syndicate critters

	del(src)
	return