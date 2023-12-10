// var/global/list/hash_to_gear = list()

// /hook/startup/populate_gear_list()
// 	//create a list of gear datums to sort
// 	for(var/geartype in typesof(/datum/gear)-/datum/gear)
// 		var/datum/gear/G = geartype
// 		if(!initial(G.display_name))
// 			continue
// 		if(GLOB.using_map.loadout_blacklist && (geartype in GLOB.using_map.loadout_blacklist))
// 			continue

// 		var/use_name = initial(G.display_name)
// 		var/use_category = initial(G.sort_category)

// 		if(!loadout_categories[use_category])
// 			loadout_categories[use_category] = new /datum/loadout_category(use_category)
// 		var/datum/loadout_category/LC = loadout_categories[use_category]
// 		G = new geartype()
// 		gear_datums[use_name] = G
// 		hash_to_gear[G.gear_hash] = G
// 		LC.gear[use_name] = gear_datums[use_name]

// 	loadout_categories = sortAssoc(loadout_categories)
// 	for(var/loadout_category in loadout_categories)
// 		var/datum/loadout_category/LC = loadout_categories[loadout_category]
// 		LC.gear = sortAssoc(LC.gear)
// 	return TRUE


/datum/category_item/player_setup_item/loadout
	var/datum/gear/selected_gear
	var/list/selected_tweaks = new
	var/hide_donate_gear = FALSE

/datum/category_item/player_setup_item/loadout/sanitize_character()
	. = ..()
	for(var/index = 1 to config.loadout_slots)
		var/list/gears = pref.gear_list[index]
		if(istype(gears))
			for(var/gear_name in gears)
				var/datum/gear/G = gears[gear_name]
				if(!pref.client.donator_info.donation_tier_available(G.donation_tier))
					gears -= gear_name

/datum/category_item/player_setup_item/loadout/content(mob/user)
	. = list()
	if(!pref.preview_icon)
		pref.update_preview_icon()
	send_rsc(user, pref.preview_icon, "previewicon.png")

	if(!user.client)
		return

	var/total_cost = 0
	var/list/gears = pref.gear_list[pref.gear_slot]
	for(var/i = 1; i <= length(gears); i++)
		var/datum/gear/G = gear_datums[gears[i]]
		if(G)
			total_cost += G.cost

	var/fcolor =  "#3366cc"

	if(total_cost < config.max_gear_cost)
		fcolor = "#e67300"

	. += "<table style='width: 100%;'><tr>"

	. += "<td>"
	. += "<b>Loadout Set: <a href='?src=\ref[src];prev_slot=1'>&lt;&lt;</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font></b><a href='?src=\ref[src];next_slot=1'>&gt;&gt;</a></b><br>"

	. += "<table style='white-space: nowrap;'><tr>"
	. += "<td><div class='statusDisplay' style='text-align:center'><img src=previewicon.png width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></div></td>"

	. += "<td style=\"vertical-align: top;\">"
	if(config.max_gear_cost < INFINITY)
		. += "<font color = '[fcolor]'>[total_cost]/[config.max_gear_cost]</font> loadout points spent.<br>"
	. += "<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a><br>"
	. += "<a href='?src=\ref[src];random_loadout=1'>Random Loadout</a><br>"
	. += "<a href='?src=\ref[src];toggle_hiding=1'>[hide_unavailable_gear ? "Show unavailable" : "Hide unavailable"]</a><br>"
	. += "<a href='?src=\ref[src];toggle_donate=1'>[hide_donate_gear ? "Show donate gears" : "Hide donate gears"]</a><br>"
	. += "</td>"

	. += "</tr></table>"
	. += "</td>"

	. += "<td style='width: 90%; text-align: right; vertical-align: top;'>"

	var/donation_tier = user.client.donator_info.get_full_donation_tier()
	. += "<br><br><b>Donation tier:</b> [donation_tier || "None"]<br>"
	. += "<a class='gold' href='?src=\ref[src];donate=1'>Support us!</a><br>"
	. += "</td>"

	. += "</tr></table>"

	. += "<table style='height: 100%;'>"

	. += "<tr>"
	. += "<td><b>Categories:</b></td>"
	. += "<td><b>Gears:</b></td>"
	if(selected_gear)
		. += "<td><b>Selected Item:</b></td>"
	. += "</tr>"

	. += "<tr style='vertical-align: top;'>"

	// Categories

	. += "<td style='white-space: nowrap; width: 40px;' class='block'><b>"
	for(var/category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear_list[pref.gear_slot])
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		var/category_class = category_cost ? "linkOn" : ""
		if(category == current_tab)
			category_class += " selected"

		. += "<a class='[category_class]' href='?src=\ref[src];select_category=[category]'>[category] - [category_cost || 0]</a>"
		. += "<br>"

	. += "</b></td>"

	// Gears

	. += "<td style='white-space: nowrap; width: 40px;' class='block'>"
	. += "<table>"
	var/datum/loadout_category/LC = loadout_categories[current_tab]
	var/list/selected_jobs = new
	for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
		var/datum/job/J = SSjobs.get_by_title(job_title)
		if(J)
			dd_insertObjectList(selected_jobs, J)

	var/purchased_gears = ""
	var/paid_gears = ""
	var/not_paid_gears = ""

	for(var/gear_name in LC.gear)
		if(!(gear_name in valid_gear_choices()))
			continue
		var/datum/gear/G = LC.gear[gear_name]
		if(!G.path)
			continue
		if(hide_donate_gear && G.donation_tier)
			continue
		var/ticked = (G.display_name in pref.gear_list[pref.gear_slot])

		// When your donation tier is lowered,
		// you shouldn't be able to wear this
		if(ticked && !gear_allowed_to_equip(G, user))
			pref.gear_list[pref.gear_slot] -= G.display_name
			ticked = FALSE

		var/display_class = ""
		var/allowed_to_see = gear_allowed_to_see(G)
		if(ticked)
			display_class = "linkOn"
		else if(!gear_allowed_to_equip(G, user) && G.donation_tier)
			display_class = "gold"
		else if(!allowed_to_see)
			display_class = "gray"

		if(G == selected_gear)
			display_class += " selected"

		var/entry = ""
		entry += "<tr>"
		entry += "<td width=25%><a [display_class ? "class='[display_class]' " : ""]href='?src=\ref[src];select_gear=\ref[G]'>[G.display_name]</a></td>"
		entry += "</td></tr>"

		if(!hide_unavailable_gear || allowed_to_see || ticked)
			if(G.donation_tier && user.client.donator_info.donation_tier_available(G.donation_tier))
				purchased_gears += entry
			else if(G.donation_tier)
				paid_gears += entry
			else
				not_paid_gears += entry

	. += purchased_gears
	. += paid_gears
	. += not_paid_gears

	. += "</table>"
	. += "</td>"

	// Selected gear

	if(selected_gear)
		var/ticked = (selected_gear.display_name in pref.gear_list[pref.gear_slot])

		var/datum/gear_data/gd = new(selected_gear.path)
		for(var/datum/gear_tweak/gt in selected_gear.gear_tweaks)
			gt.tweak_gear_data(selected_tweaks["[gt]"], gd)
		var/atom/movable/gear_virtual_item = new gd.path
		for(var/datum/gear_tweak/gt in selected_gear.gear_tweaks)
			gt.tweak_item(user, gear_virtual_item, selected_tweaks["[gt]"])
		var/icon/I = icon(gear_virtual_item.icon, gear_virtual_item.icon_state)
		if(gear_virtual_item.color)
			if(islist(gear_virtual_item.color))
				I.MapColors(arglist(gear_virtual_item.color))
			else
				I.Blend(gear_virtual_item.color, ICON_MULTIPLY)

		I.Scale(I.Width() * 2, I.Height() * 2)

		QDEL_NULL(gear_virtual_item)

		. += "<td style='width: 80%;' class='block'>"

		. += "<table><tr>"

		. += "<td>[icon2html(I, user)]</td>"

		. += "<td style='vertical-align: top;'>"
		. += "<b>[selected_gear.display_name]</b>"

		var/desc = selected_gear.get_description(selected_tweaks)
		if(desc)
			. += "<br>"
			. += desc

		. += "</td>"
		. += "</tr></table>"


		if(selected_gear.slot)
			. += "<b>Slot:</b> [slot_to_description(selected_gear.slot)]<br>"
		. += "<b>Loadout Points:</b> [selected_gear.cost]<br>"

		if(length(selected_gear.allowed_roles))
			. += "<b>Has jobs restrictions:</b>"
			. += "<br>"
			. += "<i>"
			var/ind = 0
			for(var/allowed_type in selected_gear.allowed_roles)
				if(!ispath(allowed_type, /datum/job))
					log_warning("There is an object called '[allowed_type]' in the list of whitelisted jobs for a gear '[selected_gear.display_name]'. It's not /datum/job.")
					continue
				var/datum/job/J = SSjobs.get_by_path(allowed_type) || new allowed_type
				++ind
				if(ind > 1)
					. += ", "
				if(selected_jobs && length(selected_jobs) && (J in selected_jobs))
					. += SPAN_COLOR("#55cc55", J.title)
				else
					. += SPAN_COLOR("#808080", J.title)
			. += "</i>"
			. += "<br>"

		if(length(selected_gear.allowed_branches))
			. += "<b>Has jobs restrictions:</b>"
			. += "<br>"
			. += "<i>"
			var/list/branches = list()
			for(var/datum/job/J in selected_jobs)
				if(pref.branches[J.title])
					branches |= pref.branches[J.title]

			var/ind = 0
			for(var/branch in branches)
				++ind
				if(ind > 1)
					. += ", "
				var/datum/mil_branch/player_branch = GLOB.mil_branches.get_branch(branch)
				if(player_branch.type in selected_gear.allowed_branches)
					. += SPAN_COLOR("#55cc55", player_branch.name)
				else
					. += SPAN_COLOR("#808080", player_branch.name)

			. += "</i>"
			. += "<br>"

		if(length(selected_gear.allowed_skills))
			. += "<b>Has skills restrictions:</b>"
			. += "<br>"
			. += "<i>"
			var/list/skills_required = list()//make it into instances? instead of path
			for(var/skill in selected_gear.allowed_skills)
				var/singleton/hierarchy/skill/instance = GET_SINGLETON(skill)
				skills_required[instance] = selected_gear.allowed_skills[skill]

			var/allowed = skill_check(selected_jobs, skills_required)//Checks if a single job has all the skills required
			var/ind = 0
			for(var/skill in skills_required)
				var/singleton/hierarchy/skill/S = skill
				++ind
				if(ind > 1)
					. += ", "
				if(allowed)
					. += SPAN_COLOR("#55cc55", "[S.levels[skills_required[skill]]] [skill]")
				else
					. += SPAN_COLOR("#808080", "[S.levels[skills_required[skill]]] [skill]")
			. += "</i>"
			. += "<br>"

		if(selected_gear.whitelisted)
			. += "<b>Has species restrictions:</b>"
			. += "<br>"
			. += "<i>"

			if(!istype(selected_gear.whitelisted, /list))
				selected_gear.whitelisted = list(selected_gear.whitelisted)

			var/ind = 0
			for(var/allowed_species in selected_gear.whitelisted)
				++ind
				if(ind > 1)
					. += ", "
				if(pref.species && pref.species == allowed_species)
					. += "<font color='#55cc55'>[allowed_species]</font>"
				else
					. += "<font color='#808080'>[allowed_species]</font>"
			. += "</i>"
			. += "<br>"

		if(selected_gear.donation_tier)
			. += "<br>"
			. += "<b>Donation tier required: [donation_tier_decorated(selected_gear.donation_tier)]</b>"
			. += "<br>"

		// Tweaks
		if(length(selected_gear.gear_tweaks))
			. += "<br><b>Options:</b><br>"
			for(var/datum/gear_tweak/tweak in selected_gear.gear_tweaks)
				var/tweak_contents = tweak.get_contents(selected_tweaks["[tweak]"])
				if(tweak_contents)
					. += " <a href='?src=\ref[src];tweak=\ref[tweak]'>[tweak_contents]</a>"
					. += "<br>"

		. += "<br>"

		. += "<br><b>Actions:</b><br>"
		var/not_available_message = SPAN_NOTICE("This item will never spawn with you, using your current preferences.")
		if(gear_allowed_to_equip(selected_gear, user))
			. += "<a [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=\ref[selected_gear]'>[ticked ? "Drop" : "Take"]</a>"
		else
			var/trying_on = (pref.trying_on_gear == selected_gear.display_name)
			if(selected_gear.donation_tier)
				. += "<a [trying_on ? "class='linkOn' " : ""]href='?src=\ref[src];try_on=1'>Try On</a>"
			else
				. += not_available_message

		if(!gear_allowed_to_see(selected_gear))
			. += "<br>"
			. += not_available_message

		. += "</td>"

	. += "</tr></table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/loadout/OnTopic(href, list/href_list, mob/user)
	ASSERT(istype(user))

	/*
		INSERTIONS
	*/

	if(href_list["next_slot"] || href_list["prev_slot"] || href_list["select_category"] || href_list["clear_loadout"])

		selected_gear = null
		selected_tweaks.Cut()

		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()

		// We just append to each of them some cleaning code
		..()

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["toggle_gear"])
		var/datum/gear/TG = locate(href_list["toggle_gear"])
		toggle_gear(TG, user)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	/*
		ADDITIONS
	*/

	if(href_list["select_gear"])
		var/datum/gear/TG = locate(href_list["select_gear"])
		if (!istype(TG) || gear_datums[TG.display_name] != TG)
			return TOPIC_NOACTION
		selected_gear = TG
		selected_tweaks = pref.gear_list[pref.gear_slot][selected_gear.display_name]
		if(!selected_tweaks)
			selected_tweaks = new
			for(var/datum/gear_tweak/tweak in selected_gear.gear_tweaks)
				selected_tweaks["[tweak]"] = tweak.get_default()
		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["tweak"])
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(selected_gear) || !(tweak in selected_gear.gear_tweaks) || gear_datums[selected_gear.display_name] != selected_gear)
			return TOPIC_NOACTION

		var/metadata = tweak.get_metadata(user, get_tweak_metadata(selected_gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION

		selected_tweaks["[tweak]"] = metadata

		var/ticked = (selected_gear.display_name in pref.gear_list[pref.gear_slot])
		if(ticked)
			set_tweak_metadata(selected_gear, tweak, metadata)

		var/trying_on = (selected_gear.display_name == pref.trying_on_gear)
		if(trying_on)
			pref.trying_on_tweaks["[tweak]"] = metadata

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["try_on"])
		if(!istype(selected_gear)) return TOPIC_NOACTION

		if(selected_gear.display_name == pref.trying_on_gear)
			pref.trying_on_gear = null
			pref.trying_on_tweaks.Cut()
		else
			pref.trying_on_gear = selected_gear.display_name
			pref.trying_on_tweaks = selected_tweaks.Copy()

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["random_loadout"])
		randomize(user)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["toggle_donate"])
		hide_donate_gear = !hide_donate_gear
		return TOPIC_REFRESH

	if(href_list["donate"])
		var/singleton/modpack/don_loadout/donations = GET_SINGLETON(/singleton/modpack/don_loadout)
		donations.show_donations_info(user)
		return TOPIC_NOACTION

	return ..()

/datum/category_item/player_setup_item/loadout/proc/randomize(mob/user)
	ASSERT(user)

	var/list/gear = pref.gear_list[pref.gear_slot]
	gear.Cut()

	pref.trying_on_gear = null
	pref.trying_on_tweaks.Cut()

	var/list/pool = new
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(gear_allowed_to_see(G) && gear_allowed_to_equip(G, user) && G.cost <= config.max_gear_cost)
			pool += G

	var/points_left = config.max_gear_cost
	while (points_left > 0 && length(pool))
		var/datum/gear/chosen = pick(pool)
		var/list/chosen_tweaks = new
		for(var/datum/gear_tweak/tweak in chosen.gear_tweaks)
			chosen_tweaks["[tweak]"] = tweak.get_random()

		gear[chosen.display_name] = chosen_tweaks.Copy()
		points_left -= chosen.cost

		for(var/datum/gear/G in pool)
			if(G.cost > points_left || (G.slot && G.slot == chosen.slot))
				pool -= G

/datum/category_item/player_setup_item/loadout/proc/gear_allowed_to_see(datum/gear/G)
	ASSERT(G)
	if(!G.path)
		return FALSE

	if(length(G.allowed_roles) || length(G.allowed_skills) || length(G.allowed_branches))
		// Branches are dependent on jobs so here it is
		ASSERT(SSjobs.initialized)
		var/list/jobs = new
		for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
			if(SSjobs.get_by_title(job_title))
				jobs += SSjobs.get_by_title(job_title)

		// No jobs = Fail
		// No jobs = No skills = No branches = Fail
		if(!jobs || !length(jobs))
			return FALSE

		if (length(G.allowed_roles))
			var/job_ok = FALSE
			for(var/datum/job/J in jobs)
				if(J.type in G.allowed_roles)
					job_ok = TRUE
					break
			if(!job_ok)
				return FALSE

		if (length(G.allowed_skills))
			var/list/skills_required = list()
			for(var/skill in G.allowed_skills)
				var/singleton/hierarchy/skill/instance = GET_SINGLETON(skill)
				skills_required[instance] = G.allowed_skills[skill]
			if (!skill_check(jobs, skills_required))
				return FALSE

		// It is nesting hell, but it should work fine
		if (length(G.allowed_branches))
			var/list/branches = list()
			for(var/datum/job/J in jobs)
				if(pref.branches[J.title])
					branches |= pref.branches[J.title]
			if (!branches || !length(branches))
				return FALSE
			var/branch_ok = FALSE
			for(var/branch in branches)
				var/datum/mil_branch/player_branch = GLOB.mil_branches.get_branch(branch)
				if(player_branch.type in G.allowed_branches)
					branch_ok = TRUE
					break

			if (!branch_ok)
				return FALSE

	if(G.whitelisted && !(pref.species in G.whitelisted))
		return FALSE

	return TRUE

/datum/category_item/player_setup_item/loadout/proc/gear_allowed_to_equip(datum/gear/G, mob/user)
	ASSERT(G)
	return G.is_allowed_to_equip(user)

/datum/category_item/player_setup_item/loadout/proc/toggle_gear(datum/gear/TG, mob/user)
	// check if someone trying to tricking us. However, it's may be just a bug
	ASSERT(!TG.donation_tier || user.client.donator_info.donation_tier_available(TG.donation_tier))

	if(TG.display_name in pref.gear_list[pref.gear_slot])
		pref.gear_list[pref.gear_slot] -= TG.display_name
	else
		var/total_cost = 0
		for(var/gear_name in pref.gear_list[pref.gear_slot])
			var/datum/gear/G = gear_datums[gear_name]
			if(istype(G)) total_cost += G.cost
		if((total_cost+TG.cost) <= config.max_gear_cost)
			pref.gear_list[pref.gear_slot][TG.display_name] = selected_tweaks.Copy()

/datum/category_item/player_setup_item/loadout/get_gear_metadata(datum/gear/G)
	var/list/gear_items = pref.gear_list[pref.gear_slot]
	. = gear_items[G.display_name]
	if(!.)
		. = list()
