/datum/category_item/player_setup_item/general/equipment
	name = "Equipment"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["underwear"]	>> pref.underwear
	S["undershirt"]	>> pref.undershirt
	S["backbag"]	>> pref.backbag
	S["gear"]		>> pref.gear

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["underwear"]	<< pref.underwear
	S["undershirt"]	<< pref.undershirt
	S["backbag"]	<< pref.backbag
	S["gear"]		<< pref.gear

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))

	if(!islist(pref.gear)) pref.gear = list()

	var/undies = get_undies()
	if(!get_key_by_value(undies, pref.underwear))
		pref.underwear = undies[1]
	if(!get_key_by_value(undershirt_t, pref.undershirt))
		pref.undershirt = undershirt_t[1]

	var/total_cost = 0
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			pref.gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				pref.gear -= gear_name
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/general/equipment/content()
	. += "<b>Equipment Loadout:</b><br>"
	. += "Underwear: <a href='?src=\ref[src];change_underwear=1'><b>[get_key_by_value(get_undies(),pref.underwear)]</b></a><br>"
	. += "Undershirt: <a href='?src=\ref[src];change_undershirt=1'><b>[get_key_by_value(undershirt_t,pref.undershirt)]</b></a><br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"

	. += "<br><b>Custom Loadout:</b><br>"
	var/total_cost = 0

	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost
				. += "[pref.gear[i]] ([G.cost] points) <a href='?src=\ref[src];remove_loadout=[i]'>Remove</a><br>"

		. += "<b>Used:</b> [total_cost] points."
	else
		. += "None."

	if(total_cost < MAX_GEAR_COST)
		. += " <a href='?src=\ref[src];add_loadout=1'>Add</a>"
	if(pref.gear && pref.gear.len)
		. += " <a href='?src=\ref[src];clear_loadout=1'>Clear</a>"
	. += "<br>"

/datum/category_item/player_setup_item/general/equipment/proc/get_undies()
	return pref.gender == MALE ? underwear_m : underwear_f

/datum/category_item/player_setup_item/general/equipment/proc/valid_gear_choices(var/max_cost)
	var/list/valid_gear_choices = list()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(G.whitelisted && !is_alien_whitelisted(preference_mob(), G.whitelisted))
			continue
		if(max_cost && G.cost > max_cost)
			continue
		valid_gear_choices += gear_name
	return valid_gear_choices

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_underwear"])
		var/underwear_options = get_undies()
		var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference", get_key_by_value(get_undies(),pref.underwear)) as null|anything in underwear_options
		if(!isnull(new_underwear) && CanUseTopic(user))
			pref.underwear = underwear_options[new_underwear]
			return TOPIC_REFRESH

	else if(href_list["change_undershirt"])
		var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference", get_key_by_value(undershirt_t,pref.undershirt)) as null|anything in undershirt_t
		if(!isnull(new_undershirt) && CanUseTopic(user))
			pref.undershirt = undershirt_t[new_undershirt]
			return TOPIC_REFRESH

	else if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH

	else if(href_list["add_loadout"])
		var/total_cost = 0
		for(var/gear_name in pref.gear)
			if(gear_datums[gear_name])
				var/datum/gear/G = gear_datums[gear_name]
				total_cost += G.cost

		var/choice = input(user, "Select gear to add:", "Character Preference") as null|anything in valid_gear_choices(MAX_GEAR_COST - total_cost)
		if(choice && gear_datums[choice] && CanUseTopic(user))
			var/datum/gear/C = gear_datums[choice]
			total_cost += C.cost
			if(C && total_cost <= MAX_GEAR_COST)
				pref.gear += choice
				user << "<span class='notice'>Added \the '[choice]' for [C.cost] points ([MAX_GEAR_COST - total_cost] points remaining).</span>"
			else
				user << "<span class='warning'>Adding \the '[choice]' will exceed the maximum loadout cost of [MAX_GEAR_COST] points.</span>"
			return TOPIC_REFRESH

	else if(href_list["remove_loadout"])
		var/i_remove = text2num(href_list["remove_loadout"])
		if(i_remove < 1 || i_remove > pref.gear.len) return TOPIC_NOACTION
		pref.gear.Cut(i_remove, i_remove + 1)
		return TOPIC_REFRESH

	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH

	return ..()
