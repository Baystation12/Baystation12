/datum/random_map/droppod/supply
	descriptor = "supply drop"
	limit_x = 5
	limit_y = 5

	placement_explosion_light = 7
	placement_explosion_flash = 5

// UNLIKE THE DROP POD, this map deals ENTIRELY with strings and types.
// Drop type is a string representing a mode rather than an atom or path.
// supplied_drop_types is a list of types to spawn in the pod.
/datum/random_map/droppod/supply/get_spawned_drop(var/turf/T)

	if(!drop_type) drop_type = pick(supply_drop_random_loot_types())

	if(drop_type == "custom")
		if(supplied_drop_types.len)
			var/obj/structure/largecrate/C = locate() in T
			for(var/drop_type in supplied_drop_types)
				var/atom/movable/A = new drop_type(T)
				if(!istype(A, /mob))
					if(!C) C = new(T)
					C.contents |= A
			return
		else
			drop_type = pick(supply_drop_random_loot_types())

	if(istype(drop_type, /datum/supply_drop_loot))
		var/datum/supply_drop_loot/SDL = drop_type
		SDL.drop(T)
	else
		error("Unhandled drop type: [drop_type]")


/datum/admins/proc/call_supply_drop()
	set category = "Fun"
	set desc = "Call an immediate supply drop on your location."
	set name = "Call Supply Drop"

	if(!check_rights(R_FUN)) return

	var/chosen_loot_type
	var/list/chosen_loot_types
	var/choice = alert("Do you wish to supply a custom loot list?",,"No","Yes")
	if(choice == "Yes")
		chosen_loot_types = list()

		choice = alert("Do you wish to add mobs?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/mob/living)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add structures or machines?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj) - typesof(/obj/item)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add any non-weapon items?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj/item) - typesof(/obj/item/weapon)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type

		choice = alert("Do you wish to add weapons?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj/item/weapon)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add ABSOLUTELY ANYTHING ELSE? (you really shouldn't need to)",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/atom/movable)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
	else
		choice = alert("Do you wish to specify a loot type?",,"No","Yes")
		if(choice == "Yes")
			chosen_loot_type = input("Select a loot type.", "Loot Selection", null) as null|anything in supply_drop_random_loot_types()

	choice = alert("Are you SURE you wish to deploy this supply drop? It will cause a sizable explosion and gib anyone underneath it.",,"No","Yes")
	if(choice == "No")
		return
	log_admin("[key_name(usr)] dropped supplies at ([usr.x],[usr.y],[usr.z])")
	new /datum/random_map/droppod/supply(null, usr.x-2, usr.y-2, usr.z, supplied_drops = chosen_loot_types, supplied_drop = chosen_loot_type)