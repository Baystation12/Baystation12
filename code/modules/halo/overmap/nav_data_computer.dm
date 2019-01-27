/obj/machinery/nav_computer
	name = "Nav Computer"
	desc = "A computer that contains a store of all of a ship's nav-data alongside the Friend Or Foe ID for the vessel."

	var/obj/item/nav_data_chip/data_chip

/obj/machinery/nav_computer/New()
	. = ..()
	var/obj/effect/overmap/ship/our_om = map_sectors["[z]"]
	if(istype(our_om))
		our_om.nav_comp = src

/obj/machinery/nav_computer/examine(var/mob/examiner)
	. = ..()
	if(isnull(data_chip))
		to_chat(examiner,"<span class = 'notice'>\nIt has no data chip installed.</span>")
	else
		to_chat(examiner,"<span class = 'notice'>\nIt has a data chip installed:\n</span>")
		data_chip.examine(examiner)

/obj/machinery/nav_computer/proc/update_overmap_obj()
	var/obj/effect/overmap/ship/om = map_sectors["[z]"]
	if(istype(om) && om.nav_control)
		om.nav_control.get_known_sectors()

/obj/machinery/nav_computer/proc/insert_nav_chip(var/obj/item/nav_data_chip/nav_chip,var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	user.drop_from_inventory(nav_chip)
	contents += nav_chip
	data_chip = nav_chip
	user.visible_message("<span class = 'notice'>[user] inserts [nav_chip] into [src].</span>")
	update_overmap_obj()


/obj/machinery/nav_computer/proc/remove_nav_chip(var/mob/user)
	var/obj/item/to_remove = data_chip
	data_chip = null
	contents -= to_remove
	to_remove.forceMove(loc)
	user.visible_message("<span class = 'notice'>[user] removes [to_remove] from [src].</span>")
	update_overmap_obj()

/obj/machinery/nav_computer/attack_hand(var/mob/user)
	remove_nav_chip(user)


/obj/machinery/nav_computer/proc/get_faction()
	return data_chip.chip_faction

/obj/machinery/nav_computer/proc/get_known_sectors()
	var/list/known_sector_list = data_chip.known_sectors
	//Ripped from Helm.dm get_known_sectors()
	var/list/known_sector_records = list()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/sector/S in map)
		if (S.name in known_sector_list)
			var/datum/data/record/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sector_records[S.name] = R
	return known_sector_records

/obj/item/nav_data_chip
	name = "\improper Nav data-chip"
	desc = "A data-chip containing all the nav-data and Friend or Foe Id of a vessel."

	var/chip_faction = "civillian"
	var/list/known_sectors = list()//This should contain the exact names of the sectors.

/obj/item/nav_data_chip/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>It is registered as a [chip_faction] chip</span>")
