/datum/preferences/var/list/background_states = list("000", "FFF", MATERIAL_STEEL, "white")

/datum/preferences/var/icon/bgstate = "000"

/datum/preferences/var/preview_job = TRUE

/datum/preferences/var/preview_gear = TRUE

/datum/preferences/var/icon/preview_icon


/datum/preferences/VV_static()
	return ..() + list(
		"background_states"
	)


/datum/preferences/proc/dress_preview_mob(mob/living/carbon/human/mannequin)
	var/update_icon = FALSE
	copy_to(mannequin, TRUE)
	var/datum/job/previewJob
	if (preview_job || preview_gear)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if(GLOB.using_map.default_assistant_title in job_low)
			previewJob = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
		else
			previewJob = SSjobs.get_by_title(job_high)
	else
		return
	if(preview_job && previewJob)
		mannequin.job = previewJob.title
		var/datum/mil_branch/branch = GLOB.mil_branches.get_branch(branches[previewJob.title])
		var/datum/mil_rank/rank = GLOB.mil_branches.get_rank(branches[previewJob.title], ranks[previewJob.title])
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title], branch, rank)
		update_icon = TRUE
	if(!(mannequin.species.appearance_flags && mannequin.species.appearance_flags & HAS_UNDERWEAR))
		if(all_underwear)
			all_underwear.Cut()
	if(preview_gear && !(previewJob && preview_job && (previewJob.type == /datum/job/ai || previewJob.type == /datum/job/cyborg)))
		// Equip custom gear loadout, replacing any job items
		var/list/loadout_taken_slots = list()
		for(var/thing in Gear())
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_roles && G.allowed_roles.len)
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
				if(G.slot && G.slot != slot_tie && !(G.slot in loadout_taken_slots) && G.spawn_on_mob(mannequin, gear_list[gear_slot][G.display_name]))
					loadout_taken_slots.Add(G.slot)
					update_icon = TRUE
	if(update_icon)
		mannequin.update_icons()


/datum/preferences/proc/update_preview_icon(resize_only)
	var/static/icon/last_built_icon
	if (!resize_only || !last_built_icon)
		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
		mannequin.delete_inventory(TRUE)
		dress_preview_mob(mannequin)
		last_built_icon = icon('icons/effects/128x48.dmi', bgstate)
		last_built_icon.Scale(48+32, 16+32)
		mannequin.dir = WEST
		last_built_icon.Blend(getFlatIcon(mannequin, WEST, always_use_defdir = TRUE), ICON_OVERLAY, 1, 9)
		mannequin.dir = NORTH
		last_built_icon.Blend(getFlatIcon(mannequin, NORTH, always_use_defdir = TRUE), ICON_OVERLAY, 25, 17)
		mannequin.dir = SOUTH
		last_built_icon.Blend(getFlatIcon(mannequin, SOUTH, always_use_defdir = TRUE), ICON_OVERLAY, 49, 1)
	preview_icon = new (last_built_icon)
	var/scale = client.get_preference_value(/datum/client_preference/preview_scale)
	switch (scale)
		if (GLOB.PREF_LARGE)
			scale = 4
		if (GLOB.PREF_MEDIUM)
			scale = 3
		else
			scale = 2
	preview_icon.Scale(preview_icon.Width() * scale, preview_icon.Height() * scale)


/datum/category_item/player_setup_item/physical/preview
	name = "Preview"
	sort_order = 5


/datum/category_item/player_setup_item/physical/preview/load_character(datum/pref_record_reader/R)
	pref.bgstate = R.read("bgstate")
	pref.preview_icon = null


/datum/category_item/player_setup_item/physical/preview/save_character(datum/pref_record_writer/W)
	W.write("bgstate", pref.bgstate)


/datum/category_item/player_setup_item/physical/preview/sanitize_character()
	if(!pref.bgstate || !(pref.bgstate in pref.background_states))
		pref.bgstate = pref.background_states[1]


/datum/category_item/player_setup_item/physical/preview/OnTopic(query_text, list/query, mob/user)
	if (!query)
		return
	else if (query["cyclebg"])
		var/index = list_find(pref.background_states, pref.bgstate)
		if (!index || index == length(pref.background_states))
			pref.bgstate = pref.background_states[1]
		else
			pref.bgstate = pref.background_states[index + 1]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if (query["resize"])
		pref.client?.cycle_preference(/datum/client_preference/preview_scale)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if (query["previewjob"])
		pref.preview_job = !pref.preview_job
		pref.preview_icon = null
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if (query["previewgear"])
		pref.preview_gear = !pref.preview_gear
		pref.preview_icon = null
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()


/datum/category_item/player_setup_item/physical/preview/content(mob/user)
	if(!pref.preview_icon)
		pref.update_preview_icon()
	send_rsc(user, pref.preview_icon, "previewicon.png")
	var/width = pref.preview_icon.Width()
	var/height = pref.preview_icon.Height()
	. = "<b>Preview:</b>"
	. += "<br />[BTN("cyclebg", "Cycle Background")]"
	. += " - [BTN("previewgear", "[pref.preview_gear ? "Hide" : "Show"] Loadout")]"
	. += " - [BTN("previewjob", "[pref.preview_job ? "Hide" : "Show"] Uniform")]"
	. += " - [BTN("resize", "Resize")]"
	. += {"<br /><div class="statusDisplay" style="text-align:center"><img src="previewicon.png" width="[width]" height="[height]"></div>"}
