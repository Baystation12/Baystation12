/datum/preferences
	var/character_slots_count = 0

	var/datum/gear/trying_on_gear
	var/list/trying_on_tweaks = new

	// All these gear tweaks be slow as anything.
	// Let's just force things to yield, sparing us from sanitizing and resanitizing stuff.
	var/loadout_is_busy = FALSE

/datum/preferences/dress_preview_mob(mob/living/carbon/human/mannequin)
	if(!mannequin)
		return

	var/update_icon = FALSE
	copy_to(mannequin, TRUE)
	mannequin.update_icon = TRUE

	var/datum/job/previewJob
	if (preview_job || preview_gear)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if(GLOB.using_map.default_assistant_title in job_low)
			previewJob = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
		else
			previewJob = SSjobs.get_by_title(job_high)
	else
		return

	if(!previewJob && mannequin.icon)
		update_icon = TRUE // So we don't end up stuck with a borg/AI icon after setting their priority to non-high
	else if(preview_job && previewJob)
		mannequin.job = previewJob.title
		var/datum/mil_branch/branch = GLOB.mil_branches.get_branch(branches[previewJob.title])
		var/datum/mil_rank/rank = GLOB.mil_branches.get_rank(branches[previewJob.title], ranks[previewJob.title])
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title], branch, rank)
		update_icon = TRUE

	if(!(mannequin.species.appearance_flags && mannequin.species.appearance_flags & SPECIES_APPEARANCE_HAS_UNDERWEAR))
		if(all_underwear)
			all_underwear.Cut()
	if(preview_gear && !(previewJob && preview_job && (previewJob.type == /datum/job/ai || previewJob.type == /datum/job/cyborg)))
		// Equip custom gear loadout, replacing any job items
		var/list/loadout_taken_slots = list()
		var/list/accessories = list()

		var/list/orig_gears = Gear()
		var/list/gears = orig_gears.Copy()
		if(trying_on_gear)
			gears[trying_on_gear] = trying_on_tweaks.Copy()

		for(var/thing in gears)
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_roles && length(G.allowed_roles))
					if(previewJob)
						for(var/job_type in G.allowed_roles)
							if(previewJob.type == job_type)
								permitted = 1
				else
					permitted = 1

				if(G.whitelisted && !(mannequin.species.name in G.whitelisted))
					permitted = 0

				if(!permitted)
					continue

				if(G.slot == slot_tie)
					accessories.Add(G)
					continue

				if(G.slot && G.slot != slot_tie && !(G.slot in loadout_taken_slots) && G.spawn_on_mob(mannequin, gear_list[gear_slot][G.display_name]))
					loadout_taken_slots.Add(G.slot)
					update_icon = TRUE

		// equip accessories after other slots so they don't attach to a suit which will be replaced
		for(var/datum/gear/G in accessories)
			G.spawn_as_accessory_on_mob(mannequin, gears[G.display_name])

		if(length(accessories))
			update_icon = TRUE

	if(update_icon)
		mannequin.update_icons()


/datum/preferences/get_content(mob/user)
	if(!SScharacter_setup.initialized)
		return
	if(!user || !user.client)
		return

	var/dat = "<center>"

	if(is_guest)
		dat += "Please create an account to save your preferences. If you have an account and are seeing this, please adminhelp for assistance."
	else if(load_failed)
		dat += "Ваш файл сохранения повреждён. Пожалуйста, обратитесь к администрации через adminhelp."
	else
		dat += "Слот - "
		dat += "<a href='?src=\ref[src];load=1'>Загрузить</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Сохранить</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Сбросить</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Перезагрузить</a>"

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	return dat


/datum/preferences/open_load_dialog(mob/user, details)
	var/dat  = list()
	dat += "<body>"
	dat += "<center>"

	dat += "<b>Выберите слот для загрузки</b><hr>"
	for(var/i=1, i<= 10, i++)
		var/name = (slot_names && slot_names[get_slot_key(i + character_slots_count)]) || "Персонаж [i + character_slots_count]"
		if((i + character_slots_count) == default_slot)
			name = "<b>[name]</b>"
		if(i + character_slots_count <= config.character_slots)
			dat += "<a href='?src=\ref[src];changeslot=[i + character_slots_count];[details?"details=1":""]'>[name]</a><br>"
	if(config.character_slots>10)
		dat += "<br><a href='?src=\ref[src];changeslot_prev=1'> <b>&lt;</b> </a>"
		dat += " <b>[character_slots_count + 1]</b> - <b>[character_slots_count + 10]</b> "
		dat += "<a href='?src=\ref[src];changeslot_next=1'> <b>&gt;</b> </a><br>"
	dat += "<hr>"
	dat += "</center>"
	panel = new(user, "character_slots", "Слоты персонажей", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["changeslot_next"])
		character_slots_count += 10
		if(character_slots_count >= config.character_slots)
			character_slots_count = 0
		open_load_dialog(usr, href_list["details"])
		return 1

	else if(href_list["changeslot_prev"])
		character_slots_count -= 10
		if(character_slots_count < 0)
			character_slots_count = config.character_slots - config.character_slots % 10
		open_load_dialog(usr, href_list["details"])
		return 1
