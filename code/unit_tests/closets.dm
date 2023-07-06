/datum/unit_test/closet_decal_test
	name = "CLOSETS: All Closet Appearances Shall Have Sane Values"
	var/list/check_base_states = list("base", "lock", "light", "open", "interior", "welded", "sparks")
	var/list/except_appearances = list()

/datum/unit_test/closet_decal_test/start_test()

	var/list/bad_singleton
	var/list/bad_icon
	var/list/bad_colour
	var/list/bad_base_icon
	var/list/bad_base_state
	var/list/bad_decal_icon
	var/list/bad_decal_colour
	var/list/bad_decal_state

	for(var/check_appearance in typesof(/singleton/closet_appearance)-except_appearances)
		var/singleton/closet_appearance/closet = GET_SINGLETON(check_appearance)
		if(!closet)
			LAZYADD(bad_singleton, "[check_appearance]")
			continue

		if(!closet.icon)
			LAZYADD(bad_icon, "[closet.type]")
		if(!closet.color)
			LAZYADD(bad_colour, "[closet.type]")
		if(!closet.base_icon)
			LAZYADD(bad_base_icon, "[closet.type]")
		else
			var/list/base_states = icon_states(closet.base_icon)
			for(var/thing in check_base_states)
				if(!(thing in base_states))
					LAZYADD(bad_base_state, "[closet.type] - [thing] - [closet.base_icon]")
		if(length(closet.decals) && !closet.decal_icon)
			LAZYADD(bad_decal_icon, "[closet.type]")
		else
			var/list/decal_states = icon_states(closet.decal_icon)
			for(var/thing in closet.decals)
				if(isnull(closet.decals[thing]))
					LAZYADD(bad_decal_colour, "[check_appearance] - [thing]")
				if(!(thing in decal_states))
					LAZYADD(bad_decal_state, "[check_appearance] - [thing] - [closet.decal_icon]")

	if( \
		 length(bad_singleton)         || \
		 length(bad_icon)         || \
		 length(bad_colour)       || \
		 length(bad_base_icon)    || \
		 length(bad_base_state)   || \
		 length(bad_decal_icon)   || \
		 length(bad_decal_colour) || \
		 length(bad_decal_state)     \
		)
		var/fail_msg = "Insane closet appearances found: "
		if(length(bad_singleton))
			fail_msg += "\nSingleton did not add itself to appropriate global list:\n[jointext("\t[bad_icon]", "\n")]."
		if(length(bad_icon))
			fail_msg += "\nNull final icon values:\n[jointext("\t[bad_icon]", "\n")]."
		if(length(bad_colour))
			fail_msg += "\nNull color values:\n[jointext("\t[bad_colour]", "\n")]."
		if(length(bad_base_icon))
			fail_msg += "\nNull base icon value:\n[jointext("\t[bad_base_icon]", "\n")]."
		if(length(bad_base_state))
			fail_msg += "\nMissing state from base icon:\n[jointext("\t[bad_base_state]", "\n")]."
		if(length(bad_decal_icon))
			fail_msg += "\nDecal icon not set but decal lists populated:\n[jointext("\t[bad_decal_icon]", "\n")]."
		if(length(bad_decal_colour))
			fail_msg += "\nNull color in final decal entry:\n[jointext("\t[bad_decal_colour]", "\n")]."
		if(length(bad_decal_state))
			fail_msg += "\nNon-existent decal icon state:\n[jointext("\t[bad_decal_state]", "\n")]."

		fail(fail_msg)
	else
		pass("All closet appearances are sane.")
	return 1
