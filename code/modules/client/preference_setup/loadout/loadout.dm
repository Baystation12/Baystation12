var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()

	//create a list of gear datums to sort
	for(var/geartype in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = geartype

		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!use_name)
			error("Loadout - Missing display name: [G]")
			continue
		if(!initial(G.cost))
			error("Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path))
			error("Loadout - Missing path definition: [G]")
			continue

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		gear_datums[use_name] = new geartype
		LC.gear[use_name] = gear_datums[use_name]

	loadout_categories = sortAssoc(loadout_categories)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		LC.gear = sortAssoc(LC.gear)
	return 1

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	S["gear"] >> pref.gear

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	S["gear"] << pref.gear

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	var/list/valid_gear_choices = list()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(G.whitelisted && !is_alien_whitelisted(preference_mob(), G.whitelisted))
			continue
		if(max_cost && G.cost > max_cost)
			continue
		valid_gear_choices += gear_name
	return valid_gear_choices

/datum/category_item/player_setup_item/loadout/sanitize_character()

	for(var/gear_name in pref.gear)
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name

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

/datum/category_item/player_setup_item/loadout/content()
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < MAX_GEAR_COST)
		fcolor = "#E67300"
	. += "<table align = 'center' width = 500px>"
	. += "<tr><td colspan=3><center><b><font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> loadout points spent.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"
		if(category == current_tab)
			. += " [category] "
		else
			var/datum/loadout_category/LC = loadout_categories[category]
			var/tcolor =  "#3366CC"
			for(var/thing in LC.gear)
				if(thing in pref.gear)
					tcolor = "#E67300"
					break
			. += " <a href='?src=\ref[src];select_category=[category]'><font color = '[tcolor]'>[category]</font></a> "
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	for(var/gear_name in LC.gear)
		var/datum/gear/G = LC.gear[gear_name]
		var/ticked = (G.display_name in pref.gear)
		var/obj/item/temp = G.path
		. += "<tr><td width=25%><a href='?src=\ref[src];toggle_gear=[G.display_name]'><font color='[ticked ? "#E67300" : "#3366CC"]'>[initial(temp.name)]</font></a></td>"
		. += "<td width = 10%>[G.cost]</td>"
		. += "<td><font size=2><i>[initial(temp.desc)]</i></font></td></tr>"
	. += "</table>"

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in pref.gear)
			pref.gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= MAX_GEAR_COST)
				pref.gear += TG.display_name
		return TOPIC_REFRESH
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH
	return ..()

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category = "General"


