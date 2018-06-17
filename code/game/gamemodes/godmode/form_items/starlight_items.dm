/obj/item/weapon/material/sword/blazing
	name = "blazing blade"
	damtype = BURN
	var/last_near_structure = 0
	var/mob/living/deity/linked

/obj/item/weapon/material/sword/blazing/New(var/newloc, var/material, var/deity)
	..()
	START_PROCESSING(SSobj,src)
	linked = deity

/obj/item/weapon/material/sword/blazing/Process()
	if(!linked || last_near_structure + 10 SECONDS > world.time)
		return

	if(linked.near_structure(src,1))
		if(last_near_structure < world.time - 30 SECONDS)
			to_chat(loc, "<span class='notice'>\The [src] surges with power anew!</span>")
		last_near_structure = world.time
	else
		if(last_near_structure < world.time - 30 SECONDS) //If it has been at least 30 seconds.
			if(prob(5))
				to_chat(loc, "<span class='warning'>\The [src] begins to fade, its power dimming this far away from a shrine.</span>")
		else if(last_near_structure + 1800 < world.time)
			if(istype(loc, /mob/living))
				var/mob/living/L = loc
				L.drop_from_inventory(src)
			visible_message("<span class='warning'>\The [src] disintegrates into a pile of ash!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(src))
			qdel(src)