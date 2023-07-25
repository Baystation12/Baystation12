var/global/list/hash_to_gear = list()

/hook/startup/populate_gear_list()
	//create a list of gear datums to sort
	for(var/geartype in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = geartype
		if(!initial(G.display_name))
			continue
		if(GLOB.using_map.loadout_blacklist && (geartype in GLOB.using_map.loadout_blacklist))
			continue

		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		G = new geartype()
		gear_datums[use_name] = G
		hash_to_gear[G.gear_hash] = G
		LC.gear[use_name] = gear_datums[use_name]

	loadout_categories = sortAssoc(loadout_categories)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		LC.gear = sortAssoc(LC.gear)
	return TRUE


/datum/category_item/player_setup_item/new_loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"
	var/datum/gear/selected_gear
	var/list/selected_tweaks = new
	var/hide_unavailable_gear = FALSE
	var/hide_donate_gear = FALSE
	var/max_loadout_points

/datum/category_item/player_setup_item/new_loadout/load_character(datum/pref_record_reader/R)
	pref.gear_list = R.read("gear_list")
	pref.gear_slot = R.read("gear_slot")

/datum/category_item/player_setup_item/new_loadout/save_character(datum/pref_record_writer/W)
	W.write("gear_list", pref.gear_list)
	W.write("gear_slot", pref.gear_slot)

/datum/category_item/player_setup_item/new_loadout/proc/valid_gear_choices(max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		var/okay = TRUE
		if(G.whitelisted && preference_mob)
			okay = FALSE
			for(var/species in G.whitelisted)
				if(is_species_whitelisted(preference_mob, species))
					okay = TRUE
					break
		if(!okay)
			continue
		if(max_cost && G.cost > max_cost)
			continue
		. += gear_name

/datum/category_item/player_setup_item/new_loadout/proc/skill_check(list/jobs, list/skills_required)
	for(var/datum/job/J in jobs)
		. = TRUE
		for(var/R in skills_required)
			if(pref.get_total_skill_value(J, R) < skills_required[R])
				. = FALSE
				break
		if(.)
			return

/datum/category_item/player_setup_item/new_loadout/sanitize_character()
	pref.gear_slot = sanitize_integer(pref.gear_slot, 1, config.loadout_slots, initial(pref.gear_slot))
	if(!islist(pref.gear_list)) pref.gear_list = list()

	if(length(pref.gear_list) < config.loadout_slots)
		LIST_RESIZE(pref.gear_list, config.loadout_slots)

	max_loadout_points = config.max_gear_cost

	var/donation_tier = pref.client.donator_info.get_full_donation_tier()
	var/singleton/modpack/don_loadout/donations = GET_SINGLETON(/singleton/modpack/don_loadout)

	if(!isnull(donation_tier) && donation_tier != DONATION_TIER_NONE)
		max_loadout_points += donations.extra_loadout_points

	for(var/index = 1 to config.loadout_slots)
		var/list/gears = pref.gear_list[index]

		if(istype(gears))
			for(var/gear_name in gears)
				if(!(gear_name in gear_datums))
					gears -= gear_name

			var/total_cost = 0
			for(var/gear_name in gears)
				if(!gear_datums[gear_name])
					gears -= gear_name
				else if(!(gear_name in valid_gear_choices()))
					gears -= gear_name
				else
					var/datum/gear/G = gear_datums[gear_name]
					if(total_cost + G.cost > max_loadout_points)
						gears -= gear_name
					else
						total_cost += G.cost
		else
			pref.gear_list[index] = list()

/datum/category_item/player_setup_item/new_loadout/content(mob/user)
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

	if(total_cost < max_loadout_points)
		fcolor = "#e67300"

	. += "<table style='width: 100%;'><tr>"

	. += "<td>"
	. += "<b>Набор: <a href='?src=\ref[src];prev_slot=1'>&lt;&lt;</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font></b><a href='?src=\ref[src];next_slot=1'>&gt;&gt;</a></b><br>"

	. += "<table style='white-space: nowrap;'><tr>"
	. += "<td><div class='statusDisplay' style='text-align:center'><img src=previewicon.png width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></div></td>"

	. += "<td style=\"vertical-align: top;\">"
	if(max_loadout_points < INFINITY)
		. += "<font color = '[fcolor]'>[total_cost]/[max_loadout_points]</font> поинтов потрачено.<br>"
	. += "<a href='?src=\ref[src];clear_loadout=1'>Очистить лодаут</a><br>"
	. += "<a href='?src=\ref[src];random_loadout=1'>Случайный лодаут</a><br>"
	. += "<a href='?src=\ref[src];toggle_hiding=1'>[hide_unavailable_gear ? "Показать недоступные" : "Скрыть недоступные"]</a><br>"
	. += "<a href='?src=\ref[src];toggle_donate=1'>[hide_donate_gear ? "Показать донатные" : "Скрыть донатные"]</a><br>"
	. += "</td>"

	. += "</tr></table>"
	. += "</td>"

	. += "<td style='width: 90%; text-align: right; vertical-align: top;'>"

	var/donation_tier = user.client.donator_info.get_full_donation_tier()
	. += "<br><br><b>Донат:</b> [donation_tier || "Отсутствует"]<br>"
	. += "<a class='gold' href='?src=\ref[src];donate=1'>Поддержать проект</a><br>"
	. += "</td>"

	. += "</tr></table>"

	. += "<table style='height: 100%;'>"

	. += "<tr>"
	. += "<td><b>Категории:</b></td>"
	. += "<td><b>Предметы:</b></td>"
	if(selected_gear)
		. += "<td><b>Выбранный предмет:</b></td>"
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
		if(!G.is_allowed_to_display(user))
			continue
		var/ticked = (G.display_name in pref.gear_list[pref.gear_slot])
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
		entry += "<td width=25%><a [display_class ? "class='[display_class]' " : ""]href='?src=\ref[src];select_gear=[html_encode(G.gear_hash)]'>[G.display_name]</a></td>"
		entry += "</td></tr>"

		if(!hide_unavailable_gear || allowed_to_see || ticked)
			if(user.client.donator_info.has_item(G.type) || (G.donation_tier && user.client.donator_info.donation_tier_available(G.donation_tier)))
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
			gt.tweak_item(gear_virtual_item, selected_tweaks["[gt]"])
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
			. += "<b>Слот:</b> [slot_to_description(selected_gear.slot)]<br>"
		. += "<b>Поинты:</b> [selected_gear.cost]<br>"

		if(length(selected_gear.allowed_roles))
			. += "<b>Имеет ограничения по профессии:</b>"
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
			. += "<b>Имеет ограничения по ветви:</b>"
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
			. += "<b>Требуются навыки:</b>"
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
			. += "<b>Имеет расовые ограничения:</b>"
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
			. += "<b>Требуется донат: [donation_tier_decorated(selected_gear.donation_tier)]</b>"
			. += "<br>"

		// Tweaks
		if(length(selected_gear.gear_tweaks))
			. += "<br><b>Настройки:</b><br>"
			for(var/datum/gear_tweak/tweak in selected_gear.gear_tweaks)
				var/tweak_contents = tweak.get_contents(selected_tweaks["[tweak]"])
				if(tweak_contents)
					. += " <a href='?src=\ref[src];tweak=\ref[tweak]'>[tweak_contents]</a>"
					. += "<br>"

		. += "<br>"

		. += "<br><b>Опции:</b><br>"
		var/not_available_message = SPAN_NOTICE("Текущие настройки персонажа не позволяют выдать Вам этот предмет.")
		if(gear_allowed_to_equip(selected_gear, user))
			. += "<a [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(selected_gear.gear_hash)]'>[ticked ? "Снять" : "Надеть"]</a>"
		else
			var/trying_on = (pref.trying_on_gear == selected_gear.display_name)
			if(selected_gear.donation_tier)
				. += "<a [trying_on ? "class='linkOn' " : ""]href='?src=\ref[src];try_on=1'>Примерить</a>"
			else
				. += not_available_message

		if(!gear_allowed_to_see(selected_gear))
			. += "<br>"
			. += not_available_message

		. += "</td>"

	. += "</tr></table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/new_loadout/proc/get_gear_metadata(datum/gear/G)
	var/list/gear = pref.gear_list[pref.gear_slot]
	. = gear[G.display_name]
	if(!.)
		. = list()

/datum/category_item/player_setup_item/new_loadout/proc/get_tweak_metadata(datum/gear/G, datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/new_loadout/proc/set_tweak_metadata(datum/gear/G, datum/gear_tweak/tweak, new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/new_loadout/OnTopic(href, href_list, mob/user)
	ASSERT(istype(user))
	if(pref.loadout_is_busy) return TOPIC_NOACTION

	if(href_list["select_gear"])
		pref.loadout_is_busy = TRUE
		selected_gear = hash_to_gear[href_list["select_gear"]]
		selected_tweaks = pref.gear_list[pref.gear_slot][selected_gear.display_name]
		if(!selected_tweaks)
			selected_tweaks = new
			for(var/datum/gear_tweak/tweak in selected_gear.gear_tweaks)
				selected_tweaks["[tweak]"] = tweak.get_default()
		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()
		pref.loadout_is_busy = FALSE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["toggle_gear"])
		pref.loadout_is_busy = TRUE
		var/datum/gear/TG = hash_to_gear[href_list["toggle_gear"]]
		toggle_gear(TG, user)
		pref.loadout_is_busy = FALSE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["tweak"])
		pref.loadout_is_busy = TRUE
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])

		if(!tweak || !istype(selected_gear) || !(tweak in selected_gear.gear_tweaks))
			pref.loadout_is_busy = FALSE
			return TOPIC_NOACTION

		var/metadata = tweak.get_metadata(user, get_tweak_metadata(selected_gear, tweak))
		if(!metadata || !CanUseTopic(user))
			pref.loadout_is_busy = FALSE
			return TOPIC_NOACTION
		selected_tweaks["[tweak]"] = metadata

		var/ticked = (selected_gear.display_name in pref.gear_list[pref.gear_slot])
		if(ticked)
			set_tweak_metadata(selected_gear, tweak, metadata)

		var/trying_on = (selected_gear.display_name == pref.trying_on_gear)
		if(trying_on)
			pref.trying_on_tweaks["[tweak]"] = metadata
		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["try_on"])
		if(!istype(selected_gear)) return TOPIC_NOACTION

		pref.loadout_is_busy = TRUE
		if(selected_gear.display_name == pref.trying_on_gear)
			pref.trying_on_gear = null
			pref.trying_on_tweaks.Cut()
		else
			pref.trying_on_gear = selected_gear.display_name
			pref.trying_on_tweaks = selected_tweaks.Copy()
		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["next_slot"])
		pref.loadout_is_busy = TRUE

		pref.gear_slot = pref.gear_slot+1
		if(pref.gear_slot > config.loadout_slots)
			pref.gear_slot = 1

		selected_gear = null
		selected_tweaks.Cut()

		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()

		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["prev_slot"])
		pref.loadout_is_busy = TRUE

		pref.gear_slot = pref.gear_slot-1
		if(pref.gear_slot < 1)
			pref.gear_slot = config.loadout_slots

		selected_gear = null
		selected_tweaks.Cut()

		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()

		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["select_category"])
		pref.loadout_is_busy = TRUE

		current_tab = href_list["select_category"]
		selected_gear = null
		selected_tweaks.Cut()

		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()

		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["clear_loadout"])
		pref.loadout_is_busy = TRUE

		var/list/gear = pref.gear_list[pref.gear_slot]
		gear.Cut()

		selected_gear = null
		selected_tweaks.Cut()

		pref.trying_on_gear = null
		pref.trying_on_tweaks.Cut()

		pref.loadout_is_busy = FALSE

		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["random_loadout"])
		pref.loadout_is_busy = TRUE
		randomize(user)
		pref.loadout_is_busy = FALSE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["toggle_hiding"])
		pref.loadout_is_busy = TRUE
		hide_unavailable_gear = !hide_unavailable_gear
		pref.loadout_is_busy = FALSE
		return TOPIC_REFRESH

	if(href_list["toggle_donate"])
		pref.loadout_is_busy = TRUE
		hide_donate_gear = !hide_donate_gear
		pref.loadout_is_busy = FALSE
		return TOPIC_REFRESH

	var/singleton/modpack/don_loadout/donations = GET_SINGLETON(/singleton/modpack/don_loadout)
	if(href_list["donate"])
		donations.show_donations_info(user)
		return TOPIC_NOACTION

	return ..()

/datum/category_item/player_setup_item/new_loadout/proc/randomize(mob/user)
	ASSERT(user)

	var/list/gear = pref.gear_list[pref.gear_slot]
	gear.Cut()

	pref.trying_on_gear = null
	pref.trying_on_tweaks.Cut()

	var/list/pool = new
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(gear_allowed_to_see(G) && gear_allowed_to_equip(G, user) && G.cost <= max_loadout_points)
			pool += G

	var/points_left = max_loadout_points
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

/datum/category_item/player_setup_item/new_loadout/proc/gear_allowed_to_see(datum/gear/G)
	ASSERT(G)
	if(!G.path)
		return FALSE

	if(length(G.allowed_roles))
		ASSERT(SSjobs.initialized)
		var/list/jobs = new
		for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
			if(SSjobs.get_by_title(job_title))
				jobs += SSjobs.get_by_title(job_title)

		if(!jobs || !length(jobs))
			return FALSE

		var/job_ok = FALSE
		for(var/datum/job/J in jobs)
			if(J.type in G.allowed_roles)
				job_ok = TRUE
				break

		if(!job_ok)
			return FALSE

	if(G.whitelisted && !(pref.species in G.whitelisted))
		return FALSE

	return TRUE

/datum/category_item/player_setup_item/new_loadout/proc/gear_allowed_to_equip(datum/gear/G, mob/user)
	ASSERT(G)
	return G.is_allowed_to_equip(user)

/datum/category_item/player_setup_item/new_loadout/proc/toggle_gear(datum/gear/TG, mob/user)
	// check if someone trying to tricking us. However, it's may be just a bug
	ASSERT(!TG.donation_tier || user.client.donator_info.donation_tier_available(TG.donation_tier))

	if(TG.display_name in pref.gear_list[pref.gear_slot])
		pref.gear_list[pref.gear_slot] -= TG.display_name
	else
		var/total_cost = 0
		for(var/gear_name in pref.gear_list[pref.gear_slot])
			var/datum/gear/G = gear_datums[gear_name]
			if(istype(G)) total_cost += G.cost
		if((total_cost+TG.cost) <= max_loadout_points)
			pref.gear_list[pref.gear_slot][TG.display_name] = selected_tweaks.Copy()
