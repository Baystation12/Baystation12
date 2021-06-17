/obj/item/pinpointer
	name = "pinpointer"
	icon = 'icons/obj/pinpointer.dmi'
	icon_state = "pinoff"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	matter = list(MATERIAL_STEEL = 500)
	var/weakref/target
	var/active = 0
	var/beeping = 2

/obj/item/pinpointer/Destroy()
	STOP_PROCESSING(SSobj,src)
	target = null
	. = ..()

/obj/item/pinpointer/attack_self(mob/user)
	toggle(user)

/obj/item/pinpointer/proc/toggle(mob/user)
	active = !active
	to_chat(user, "You [active ? "" : "de"]activate [src].")
	if(!active)
		STOP_PROCESSING(SSobj,src)
	else
		if(!target)
			target = acquire_target()
		START_PROCESSING(SSobj,src)
	update_icon()

/obj/item/pinpointer/advpinpointer/verb/toggle_sound()
	set category = "Object"
	set name = "Toggle Pinpointer Beeping"
	set src in view(1)

	if(beeping >= 0)
		beeping = -1
		to_chat(usr, "You mute [src].")
	else
		beeping = 0
		to_chat(usr, "You enable the sound indication on [src].")

/obj/item/pinpointer/proc/acquire_target()
	var/obj/item/disk/nuclear/the_disk = locate()
	return weakref(the_disk)

/obj/item/pinpointer/Process()
	update_icon()
	if(!target)
		return
	if(!target.resolve())
		target = null
		return

	if(beeping < 0)
		return
	if(beeping == 0)
		var/turf/here = get_turf(src)
		var/turf/there = get_turf(target.resolve())
		if(!istype(there))
			return
		var/distance = max(1,get_dist(here, there))
		var/freq_mod = 1
		if(distance < world.view)
			freq_mod = min(world.view/distance, 2)
		else if (distance > 3*world.view)
			freq_mod = max(3*world.view/distance, 0.6)
		playsound(loc, 'sound/machines/buttonbeep.ogg', 1, frequency = freq_mod)
		if(distance > world.view || here.z != there.z)
			beeping = initial(beeping)
	else
		beeping--

/obj/item/pinpointer/on_update_icon()
	overlays.Cut()
	if(!active)
		return
	if(!target || !target.resolve())
		overlays += image(icon,"pin_invalid")
		return

	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target.resolve())
	if(!istype(there))
		overlays += image(icon,"pin_invalid")
		return

	if(here == there)
		overlays += image(icon,"pin_here")
		return

	if(!(there.z in GetConnectedZlevels(here.z)))
		overlays += image(icon,"pin_invalid")
		return
	if(here.z > there.z)
		overlays += image(icon,"pin_down")
		return
	if(here.z < there.z)
		overlays += image(icon,"pin_up")
		return

	dir = get_dir(here,there)
	var/image/pointer = image(icon,"pin_point")
	var/distance = get_dist(here,there)
	if(distance < world.view)
		pointer.color = COLOR_LIME
	else if(distance > 4*world.view)
		pointer.color = COLOR_RED
	else
		pointer.color = COLOR_YELLOW
	overlays += pointer

//Nuke ops locator
/obj/item/pinpointer/nukeop
	var/locate_shuttle = 0

/obj/item/pinpointer/nukeop/Process()
	var/new_mode
	if(!locate_shuttle && bomb_set)
		locate_shuttle = 1
		new_mode = "Shuttle Locator"
	else if (locate_shuttle && !bomb_set)
		locate_shuttle = 0
		new_mode = "Authentication Disk Locator"
	if(new_mode)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("<span class='notice'>[new_mode] active.</span>")
		target = acquire_target()
	..()

/obj/item/pinpointer/nukeop/acquire_target()
	if(locate_shuttle)
		var/obj/machinery/computer/shuttle_control/multi/syndicate/home = locate()
		return weakref(home)
	else
		return ..()

//Deathsquad locator

/obj/item/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	var/selection = input(usr, "Please select the type of target to locate.", "Mode" , "") as null|anything in list("Location", "Disk Recovery", "DNA", "Other Signature")
	switch(selection)
		if("Disk Recovery")
			var/obj/item/disk/nuclear/the_disk = locate()
			target = weakref(the_disk)

		if("Location")
			var/locationx = input(usr, "Please input the x coordinate to search for.", "Location?" , "") as num
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = input(usr, "Please input the y coordinate to search for.", "Location?" , "") as num
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)
			var/turf/location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")

			target = weakref(location)

		if("Other Signature")
			var/datum/objective/steal/itemlist
			itemlist = itemlist // To supress a 'variable defined but not used' error.
			var/targetitem = input("Select item to search for.", "Item Mode Select","") as null|anything in itemlist.possible_items
			if(!targetitem)
				return
			var/obj/item = locate(itemlist.possible_items[targetitem])
			if(!item)
				to_chat(usr, "Failed to locate [targetitem]!")
				return
			to_chat(usr, "You set the pinpointer to locate [targetitem]")
			target = weakref(item)

		if("DNA")
			var/DNAstring = input("Input DNA string to search for." , "Please Enter String." , "")
			if(!DNAstring)
				return
			for(var/mob/living/carbon/M in SSmobs.mob_list)
				if(!M.dna)
					continue
				if(M.dna.unique_enzymes == DNAstring)
					target = weakref(M)
					break