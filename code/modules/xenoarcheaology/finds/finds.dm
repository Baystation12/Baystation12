/datum/find
	var/find_type = 0				//random according to the digsite type
	var/excavation_required = 0		//random 10 - 190
	var/view_range = 40				//how close excavation has to come to show an overlay on the turf
	var/clearance_range = 3			//how close excavation has to come to extract the item
									//if excavation hits var/excavation_required exactly, it's contained find is extracted cleanly without the ore
	var/prob_delicate = 90			//probability it requires an active suspension field to not insta-crumble
	var/dissonance_spread = 1		//proportion of the tile that is affected by this find
									//used in conjunction with analysis machines to determine correct suspension field type

/datum/find/New(var/digsite, var/exc_req)
	excavation_required = exc_req
	find_type = get_random_find_type(digsite)
	clearance_range = rand(4, 12)
	dissonance_spread = rand(1500, 2500) / 100

/obj/item/ore/strangerock
	name = "strange rock"
	desc = "Seems to have some unusal strata evident throughout it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "strange"
	origin_tech = list(TECH_MATERIAL = 5)

/obj/item/ore/strangerock/New(loc, var/inside_item_type = 0)
	..(loc)

	if(inside_item_type)
		var/T = get_archeological_find_by_findtype(inside_item_type)
		new T(src)

/obj/item/ore/strangerock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/pickaxe/xeno/brush))
		var/obj/item/inside = locate() in src
		if(inside)
			inside.dropInto(loc)
			visible_message("<span class='info'>\The [src] is brushed away, revealing \the [inside].</span>")
		else
			visible_message("<span class='info'>\The [src] is brushed away into nothing.</span>")
		qdel(src)
		return

	if(isWelder(I))
		var/obj/item/weldingtool/W = I
		if(W.isOn())
			if(W.get_fuel() >= 2)
				var/obj/item/inside = locate() in src
				if(inside)
					inside.dropInto(loc)
					visible_message("<span class='info'>\The [src] burns away revealing \the [inside].</span>")
				else
					visible_message("<span class='info'>\The [src] burns away into nothing.</span>")
				qdel(src)
				W.remove_fuel(2)
			else
				visible_message("<span class='info'>A few sparks fly off \the [src], but nothing else happens.</span>")
				W.remove_fuel(1)
			return

	else if(istype(I, /obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/S = I
		S.sample_item(src, user)
		return

	..()

	if(prob(33))
		src.visible_message("<span class='warning'>[src] crumbles away, leaving some dust and gravel behind.</span>")
		qdel(src)
