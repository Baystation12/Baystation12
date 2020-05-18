/datum/unit_test/icon_test
	name = "ICON STATE template"
	template = /datum/unit_test/icon_test

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state
	name = "ICON STATE - Robot shall have eyes for each icon state"
	var/list/excepted_icon_states_ = list(
		"droid-combat-roll",
		"droid-combat-shield"
	)

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state/start_test()
	var/missing_states = 0
	var/list/valid_states = icon_states('icons/mob/robots.dmi') + icon_states('icons/mob/robots_drones.dmi') + icon_states('icons/mob/robots_flying.dmi')

	var/list/original_valid_states = valid_states.Copy()
	for(var/icon_state in valid_states)
		if(icon_state in excepted_icon_states_)
			continue
		if(starts_with(icon_state, "eyes-"))
			continue
		if(findtext(icon_state, "openpanel"))
			continue
		var/eye_icon_state = "eyes-[icon_state]"
		if(!(eye_icon_state in valid_states))
			log_unit_test("Eye icon state [eye_icon_state] is missing.")
			missing_states++

	if(missing_states)
		fail("[missing_states] eye icon state\s [missing_states == 1 ? "is" : "are"] missing.")
		var/list/difference = uniquemergelist(original_valid_states, valid_states)
		if(difference.len)
			log_unit_test("[ascii_yellow]---  DEBUG  --- ICON STATES AT START: " + jointext(original_valid_states, ",") + "[ascii_reset]")
			log_unit_test("[ascii_yellow]---  DEBUG  --- ICON STATES AT END: "   + jointext(valid_states, ",") + "[ascii_reset]")
			log_unit_test("[ascii_yellow]---  DEBUG  --- UNIQUE TO EACH LIST: " + jointext(difference, ",") + "[ascii_reset]")
	else
		pass("All related eye icon states exists.")
	return 1

/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states
	name = "ICON STATE - Sprite accessories shall have existing icon states"

/datum/unit_test/icon_test/sprite_accessories_shall_have_existing_icon_states/start_test()
	var/sprite_accessory_subtypes = list(
		/datum/sprite_accessory/hair,
		/datum/sprite_accessory/facial_hair
	)

	var/list/failed_sprite_accessories = list()
	var/icon_state_cache = list()
	var/duplicates_found = FALSE

	for(var/sprite_accessory_main_type in sprite_accessory_subtypes)
		var/sprite_accessories_by_name = list()
		for(var/sprite_accessory_type in subtypesof(sprite_accessory_main_type))
			var/failed = FALSE
			var/datum/sprite_accessory/sat = sprite_accessory_type

			var/sat_name = initial(sat.name)
			if(sat_name)
				group_by(sprite_accessories_by_name, sat_name, sat)
			else
				failed = TRUE
				log_bad("[sat] - Did not have a name set.")

			var/sat_icon = initial(sat.icon)
			if(sat_icon)
				var/sat_icon_states = icon_state_cache[sat_icon]
				if(!sat_icon_states)
					sat_icon_states = icon_states(sat_icon)
					icon_state_cache[sat_icon] = sat_icon_states

				var/sat_icon_state = initial(sat.icon_state)
				if(sat_icon_state)
					sat_icon_state = "[sat_icon_state]_s"
					if(!(sat_icon_state in sat_icon_states))
						failed = TRUE
						log_bad("[sat] - \"[sat_icon_state]\" did not exist in '[sat_icon]'.")
				else
					failed = TRUE
					log_bad("[sat] - Did not have an icon state set.")
			else
				failed = TRUE
				log_bad("[sat] - Did not have an icon set.")

			if(failed)
				failed_sprite_accessories += sat

		if(number_of_issues(sprite_accessories_by_name, "Sprite Accessory Names"))
			duplicates_found = TRUE

	if(failed_sprite_accessories.len || duplicates_found)
		fail("One or more sprite accessory issues detected.")
	else
		pass("All sprite accessories were valid.")

	return 1

/datum/unit_test/icon_test/posters_shall_have_icon_states
	name = "ICON STATE - Posters Shall Have Icon States"

/datum/unit_test/icon_test/posters_shall_have_icon_states/start_test()
	var/contraband_icons = icon_states('icons/obj/contraband.dmi')
	var/list/invalid_posters = list()

	for(var/poster_type in subtypesof(/decl/poster))
		var/decl/poster/P = decls_repository.get_decl(poster_type)
		if(!(P.icon_state in contraband_icons))
			invalid_posters += poster_type

	if(invalid_posters.len)
		fail("/decl/poster with missing icon states: [english_list(invalid_posters)]")
	else
		pass("All /decl/poster subtypes have valid icon states.")
	return 1

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states
	name = "ICON STATE - Item Modifiers Shall Have Icon Sates"
	var/list/icon_states_by_type

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states/start_test()
	var/list/bad_modifiers = list()
	var/item_modifiers = list_values(decls_repository.get_decls(/decl/item_modifier))

	for(var/im in item_modifiers)
		var/decl/item_modifier/item_modifier = im
		for(var/type_setup_type in item_modifier.type_setups)
			var/list/type_setup = item_modifier.type_setups[type_setup_type]
			var/list/icon_states = icon_states_by_type[type_setup_type]

			if(!icon_states)
				var/obj/item/I = type_setup_type
				icon_states = icon_states(initial(I.icon))
				LAZYSET(icon_states_by_type, type_setup_type, icon_states)

			if(!(type_setup["icon_state"] in icon_states))
				bad_modifiers += type_setup_type

	if(bad_modifiers.len)
		fail("Item modifiers with missing icon states: [english_list(bad_modifiers)]")
	else
		pass("All item modifiers have valid icon states.")
	return 1

/datum/unit_test/icon_test/random_spawners_shall_have_icon_states
	name = "ICON STATE - Random Spawners Shall Have Icon States"

/datum/unit_test/icon_test/random_spawners_shall_have_icon_states/start_test()
	var/states_per_icon = list()
	var/list/invalid_spawners = list()
	for(var/random_type in typesof(/obj/random))
		var/obj/random/R = random_type
		var/icon = initial(R.icon)
		var/icon_state = initial(R.icon_state) || ""

		var/icon_states = states_per_icon[icon]
		if(!icon_states)
			icon_states = icon_states(icon)
			states_per_icon[icon] = icon_states

		if(!(icon_state in icon_states))
			invalid_spawners += random_type

	if(invalid_spawners.len)
		fail("[invalid_spawners.len] /obj/random type\s with missing icon states: [json_encode(invalid_spawners)]")
	else
		pass("All /obj/random types have valid icon states.")
	return 1
