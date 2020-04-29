#define DATA_CHIP_REMOVE_DELAY 10 SECONDS

/obj/machinery/nav_computer
	name = "Nav Computer"
	desc = "A computer that contains a store of all of a ship's nav-data alongside the Friend Or Foe ID for the vessel."
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_computer"
	density = 1
	anchored = 1

	var/obj/item/nav_data_chip/data_chip = new /obj/item/nav_data_chip

	ai_access_level = 4

/obj/machinery/nav_computer/ex_act(var/severity)
	if(severity > 2)
		if(prob(50))
			var/obj/chip_to_remove = data_chip
			remove_nav_chip()
			qdel(chip_to_remove)

/obj/machinery/nav_computer/LateInitialize()
	. = ..()
	GLOB.processing_objects += src

/obj/machinery/nav_computer/process()
	var/obj/effect/overmap/ship/our_om = map_sectors["[z]"]
	if(istype(our_om))
		our_om.nav_comp = src
		GLOB.processing_objects -= src

/obj/machinery/nav_computer/examine(var/mob/examiner)
	. = ..()
	if(isnull(data_chip))
		to_chat(examiner,"<span class = 'notice'>\nIt has no data chip installed.</span>")
	else
		to_chat(examiner,"<span class = 'notice'>\nIt has a data chip installed:\n</span>")
		data_chip.examine(examiner)

/obj/machinery/nav_computer/update_icon()
	. = ..()
	if(data_chip)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_empty"

/obj/machinery/nav_computer/proc/update_overmap_obj()
	var/obj/effect/overmap/ship/om = map_sectors["[z]"]
	if(istype(om) && om.nav_control)
		om.nav_control.get_known_sectors()

/obj/machinery/nav_computer/proc/insert_nav_chip(var/obj/item/nav_data_chip/nav_chip,var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(data_chip)
		to_chat(user,"<span class = 'notice'>[src] already has a data-chip.</span>")
		return
	user.drop_from_inventory(nav_chip)
	contents += nav_chip
	data_chip = nav_chip
	user.visible_message("<span class = 'notice'>[user] inserts [nav_chip] into [src].</span>")
	update_overmap_obj()
	update_icon()
	return 1


/obj/machinery/nav_computer/proc/remove_nav_chip(var/mob/user)
	if(!data_chip)
		if(user)
			to_chat(user,"<span class = 'notice'>[src] doesn't have a data-chip installed.</span>")
		return
	var/obj/item/to_remove = data_chip
	data_chip = null
	contents -= to_remove
	to_remove.forceMove(loc)
	if(user)
		user.visible_message("<span class = 'notice'>[user] removes [to_remove] from [src].</span>")
	update_overmap_obj()
	update_icon()

/obj/machinery/nav_computer/attack_hand(var/mob/user)
	user.visible_message("<span class = 'notice'>[user] starts removing the data chip from [src]</span>")
	if(!do_after(user,DATA_CHIP_REMOVE_DELAY,src,1,1))
		return
	remove_nav_chip(user)

/obj/machinery/nav_computer/attackby(var/obj/item/I,var/mob/m)
	. = insert_nav_chip(I,m)
	if(.)
		. = ..()

/obj/machinery/nav_computer/proc/get_faction()
	if(data_chip)
		return data_chip.get_faction()
	return ""

/obj/machinery/nav_computer/proc/get_known_sectors()
	if(!data_chip)
		return list("error")
	var/list/known_sector_list = data_chip.get_known_sectors()
	//Ripped from Helm.dm get_known_sectors()
	var/list/known_sector_records = list()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/S in map)
		var/add_sector = 0
		if (known_sector_list.len > 0)
			if(S.name in known_sector_list)
				add_sector = 1
		if(S.known && known_sector_list.len == 0)
			add_sector = 1

		if(add_sector)
			var/datum/data/record/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sector_records[S.name] = R

	return known_sector_records

/obj/machinery/nav_computer/npc
	data_chip = new /obj/item/nav_data_chip/fragmented //All NPC ships should only contain a "fragmented" version of the original type.

/obj/machinery/nav_computer/npc/remove_nav_chip(var/mob/user)
	var/obj/item/nav_data_chip/fragmented/f = data_chip
	if(istype(f) && f.fragments_have == 999)
		f.fragment_chip()
	. = ..()

/obj/item/nav_data_chip
	name = "\improper Nav data-chip"
	desc = "A data-chip containing all the nav-data and Friend or Foe Id of a vessel."
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_data_chip"
	w_class = ITEM_SIZE_SMALL

	var/chip_faction = "unknown"
	var/list/known_sectors = list("KS7-535")//This should contain the exact names of the sectors.

/obj/item/nav_data_chip/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>It is registered as a [chip_faction] chip</span>")

/obj/item/nav_data_chip/proc/get_faction()
	return chip_faction

/obj/item/nav_data_chip/proc/get_known_sectors()
	return known_sectors

/obj/item/nav_data_chip/covenant
	icon_state = "nav_data_chip_cov"

/obj/item/nav_data_chip/fragmented
	name = "Fragmented Nav Data Chip"

	chip_faction = "unknown"
	known_sectors = list()
	//The above two will not function unless the chip has the amount of required fragments.

	var/fragments_have = 1
	var/fragments_required = 3

/obj/item/nav_data_chip/fragmented/New()
	. = ..()
	fragments_have = 999

/obj/item/nav_data_chip/fragmented/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>This chip has embedded automatic corruption mechanisms, triggered by removal from the nav computer it resides in. Scan other fragmented chips on this one to reconstruct the full chip.</span>")

/obj/item/nav_data_chip/fragmented/get_faction()
	if(is_fragmented())
		return ""
	return ..()

/obj/item/nav_data_chip/fragmented/get_known_sectors()
	if(is_fragmented())
		return list("error")
	return ..()

/obj/item/nav_data_chip/fragmented/proc/is_fragmented()
	if(fragments_have >= fragments_required)
		return 0
	return 1

/obj/item/nav_data_chip/fragmented/proc/fragment_chip()
	fragments_have = initial(fragments_have)

/obj/item/nav_data_chip/fragmented/attackby(var/obj/item/I,var/mob/living/carbon/human/user)
	if(!istype(user) || !is_fragmented())
		. = ..()
	var/obj/item/nav_data_chip/fragmented/f = I
	if(istype(f) && f.type == type)
		to_chat(user,"<span class = 'notice'>You scan [I] on [src], transferring the nav data and discarding [I] afterwards.</span>")
		user.visible_message("<span class = 'notice'>[user] scans [I] on [src], transferring the FoF ID data.\n[user] discards the now-useless [I]</span>")
		fragments_have += f.fragments_have
		user.drop_from_inventory(f)
		qdel(f)

/obj/item/nav_data_chip/unsc
	chip_faction = "UNSC"
	known_sectors = list("Deviance Station","VT9-042","Northwind","KS7-535","Geminus Colony")

/obj/item/nav_data_chip/covenant
	icon_state = "nav_data_chip_cov"
	chip_faction = "Covenant"
	known_sectors = list("Vanguard's Mantle","VT9-042","Northwind","Geminus Colony")

/obj/item/nav_data_chip/innie
	chip_faction = "Insurrection"
	known_sectors = list("Camp New Hope","Asteroid","KS7-535","Geminus Colony")

/obj/item/nav_data_chip/civilian
	chip_faction = "civilian"
	known_sectors = list("Geminus Colony")

/obj/item/nav_data_chip/fragmented/unsc
	name = "Fragmented Nav Data Chip"
	chip_faction = "UNSC"
	known_sectors = list("Deviance Station","VT9-042","Northwind","KS7-535","Geminus Colony")

/obj/item/nav_data_chip/fragmented/covenant
	name = "Fragmented Nav Data Chip"
	icon_state = "nav_data_chip_cov"
	chip_faction = "Covenant"
	known_sectors = list("Vanguard's Mantle","VT9-042","Northwind")

/obj/item/nav_data_chip/fragmented/covenant/kig_yar
	known_sectors = list("Vanguard's Mantle","Asteroid","KS7-535","Geminus Colony")

/obj/item/nav_data_chip/fragmented/innie
	name = "Fragmented Nav Data Chip"
	chip_faction = "Insurrection"
	known_sectors = list("Camp New Hope","Asteroid","KS7-535","Geminus Colony")

/obj/machinery/nav_computer/npc/unsc
	data_chip = new /obj/item/nav_data_chip/fragmented/unsc

/obj/machinery/nav_computer/npc/covenant
	icon_state = "cov_nav"
	data_chip = new /obj/item/nav_data_chip/fragmented/covenant

/obj/machinery/nav_computer/npc/covenant/kig_yar
	icon_state = "cov_nav"
	data_chip = new /obj/item/nav_data_chip/fragmented/covenant/kig_yar

/obj/machinery/nav_computer/npc/innie
	data_chip = new /obj/item/nav_data_chip/fragmented/innie

/obj/machinery/nav_computer/unsc
	data_chip = new /obj/item/nav_data_chip/unsc

/obj/machinery/nav_computer/covenant
	icon_state = "cov_nav"
	data_chip = new /obj/item/nav_data_chip/covenant

/obj/machinery/nav_computer/innie
	data_chip = new /obj/item/nav_data_chip/innie

/obj/machinery/nav_computer/civilian
	data_chip = new /obj/item/nav_data_chip/civilian