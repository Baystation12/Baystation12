/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Phoron Glass Sheets
 *		Reinforced Phoron Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	matter = list("glass" = 3750)
	origin_tech = "materials=1"
	var/created_window = /obj/structure/window/basic
	var/is_reinforced = 0
	var/list/construction_options = list("One Direction", "Full Window")

/obj/item/stack/sheet/glass/cyborg
	name = "glass synthesizer"
	desc = "A device that makes glass."
	gender = MALE
	singular_name = "glass"
	matter = null
	uses_charge = 1
	charge_cost = 1000
	stacktype = /obj/item/stack/sheet/glass

/obj/item/stack/sheet/glass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	..()
	if(!is_reinforced)
		if(istype(W,/obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/CC = W
			if (get_amount() < 1 || CC.get_amount() < 5)
				user << "<span class='warning>You need five lengths of coil and one sheet of glass to make wired glass.</span>"
				return

			CC.use(5)
			use(1)
			user << "<span class='notice'>You attach wire to the [name].</span>"
			new /obj/item/stack/light_w(user.loc)
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/V  = W
			if (V.get_amount() < 1 || get_amount() < 1)
				user << "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass.</span>"
				return

			var/obj/item/stack/sheet/glass/reinforced/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			var/obj/item/stack/sheet/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)

/obj/item/stack/sheet/glass/proc/construct_window(mob/user as mob)
	if(!user || !src)	return 0
	if(!istype(user.loc,/turf)) return 0
	if(!user.IsAdvancedToolUser())
		return 0
	var/title = "Sheet-[name]"
	title += " ([src.get_amount()] sheet\s left)"
	switch(input(title, "What would you like to construct?") as null|anything in construction_options)
		if("One Direction")
			if(!src)	return 1
			if(src.loc != user)	return 1

			var/list/directions = new/list(cardinal)
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					user << "\red There are too many windows in this location."
					return 1
				directions-=win.dir
				if(!(win.dir in cardinal))
					user << "\red Can't let you do that."
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			new created_window( user.loc, dir_to_set, 1 )
			src.use(1)
		if("Full Window")
			if(!src)	return 1
			if(src.loc != user)	return 1
			if(src.get_amount() < 4)
				user << "\red You need more glass to do that."
				return 1
			if(locate(/obj/structure/window) in user.loc)
				user << "\red There is a window in the way."
				return 1
			new created_window( user.loc, SOUTHWEST, 1 )
			src.use(4)
		if("Windoor")
			if(!is_reinforced) return 1


			if(!src || src.loc != user) return 1

			if(isturf(user.loc) && locate(/obj/structure/windoor_assembly/, user.loc))
				user << "\red There is already a windoor assembly in that location."
				return 1

			if(isturf(user.loc) && locate(/obj/machinery/door/window/, user.loc))
				user << "\red There is already a windoor in that location."
				return 1

			if(src.get_amount() < 5)
				user << "\red You need more glass to do that."
				return 1

			new /obj/structure/windoor_assembly(user.loc, user.dir, 1)
			src.use(5)

	return 0


/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/glass/reinforced
	name = "reinforced glass"
	desc = "Glass which has been reinforced with metal rods."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"

	matter = list("metal" = 1875,"glass" = 3750)
	origin_tech = "materials=2"

	created_window = /obj/structure/window/reinforced
	is_reinforced = 1
	construction_options = list("One Direction", "Full Window", "Windoor")

/obj/item/stack/sheet/glass/reinforced/cyborg
	name = "reinforced glass synthesizer"
	desc = "A device that makes reinforced glass."
	gender = MALE
	matter = null
	uses_charge = 1
	charge_cost = 1000
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	var/datum/matter_synth/metal_synth
	var/datum/matter_synth/glass_synth
	var/metal_charge = 500
	var/glass_charge = 1000

/obj/item/stack/sheet/glass/reinforced/cyborg/get_amount()
	return min(round(metal_synth.energy / metal_charge), round(glass_synth.energy / glass_charge))

/obj/item/stack/sheet/glass/reinforced/cyborg/use(var/amount) // Requires special checks, because it uses two storages
	if(get_amount() < amount)
		return 0
	metal_synth.use_charge(amount * metal_charge)
	glass_synth.use_charge(amount * glass_charge)
	return 1

/obj/item/stack/sheet/glass/reinforced/cyborg/add(var/amount)
	metal_synth.add_charge(amount * metal_charge)
	glass_synth.add_charge(amount * glass_charge)
	return

/*
 * Phoron Glass sheets
 */
/obj/item/stack/sheet/glass/phoronglass
	name = "phoron glass"
	desc = "A very strong and very resistant sheet of a phoron-glass alloy."
	singular_name = "phoron glass sheet"
	icon_state = "sheet-phoronglass"
	matter = list("glass" = 7500)
	origin_tech = "materials=3;phorontech=2"
	created_window = /obj/structure/window/phoronbasic

/obj/item/stack/sheet/glass/phoronglass/attackby(obj/item/W, mob/user)
	..()
	if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/sheet/glass/phoronrglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced phoron glass sheets
 */
/obj/item/stack/sheet/glass/phoronrglass
	name = "reinforced phoron glass"
	desc = "Phoron glass which has been reinforced with metal rods."
	singular_name = "reinforced phoron glass sheet"
	icon_state = "sheet-phoronrglass"
	matter = list("glass" = 7500,"metal" = 1875)

	origin_tech = "materials=4;phorontech=2"
	created_window = /obj/structure/window/phoronreinforced
	is_reinforced = 1
