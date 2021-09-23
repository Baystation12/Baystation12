#define ASSIGN_LIST_TO_COLORS(L, R, G, B) if(L) { R = L[1]; G = L[2]; B = L[3]; }

/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
		var/datum/species/current_species = all_species[species]
		if(!current_species) current_species = all_species[SPECIES_HUMAN]
		gender = pick(current_species.genders)

		h_style = random_hair_style(gender, species)
		f_style = random_facial_hair_style(gender, species)
		if(current_species)
			if(current_species.appearance_flags & HAS_A_SKIN_TONE)
				s_tone = current_species.get_random_skin_tone() || s_tone
			if(current_species.appearance_flags & HAS_EYE_COLOR)
				ASSIGN_LIST_TO_COLORS(current_species.get_random_eye_color(), r_eyes, g_eyes, b_eyes)
			if(current_species.appearance_flags & HAS_SKIN_COLOR)
				ASSIGN_LIST_TO_COLORS(current_species.get_random_skin_color(), r_skin, g_skin, b_skin)
			if(current_species.appearance_flags & HAS_HAIR_COLOR)
				var/hair_colors = current_species.get_random_hair_color()
				if(hair_colors)
					ASSIGN_LIST_TO_COLORS(hair_colors, r_hair, g_hair, b_hair)

					if(prob(75))
						r_facial = r_hair
						g_facial = g_hair
						b_facial = b_hair
					else
						ASSIGN_LIST_TO_COLORS(current_species.get_random_facial_hair_color(), r_facial, g_facial, b_facial)

		if(current_species.appearance_flags & HAS_UNDERWEAR)
			if(all_underwear)
				all_underwear.Cut()
			for(var/datum/category_group/underwear/WRC in GLOB.underwear.categories)
				var/datum/category_item/underwear/WRI = pick(WRC.items)
				all_underwear[WRC.name] = WRI.name

		backpack = decls_repository.get_decl(pick(subtypesof(/decl/backpack_outfit)))
		age = rand(current_species.min_age, current_species.max_age)
		b_type = RANDOM_BLOOD_TYPE
		if(H)
			copy_to(H)

#undef ASSIGN_LIST_TO_COLORS

/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin)
	var/update_icon = FALSE
	copy_to(mannequin, TRUE)

	var/datum/job/previewJob
	if(equip_preview_mob)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if(GLOB.using_map.default_assistant_title in job_low)
			previewJob = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
		else
			previewJob = SSjobs.get_by_title(job_high)
	else
		return

	if((equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
		mannequin.job = previewJob.title
		var/datum/mil_branch/branch = mil_branches.get_branch(branches[previewJob.title])
		var/datum/mil_rank/rank = mil_branches.get_rank(branches[previewJob.title], ranks[previewJob.title])
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title], branch, rank)
		update_icon = TRUE

	if(!(mannequin.species.appearance_flags && mannequin.species.appearance_flags & HAS_UNDERWEAR))
		if(all_underwear)
			all_underwear.Cut()

	if((equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (equip_preview_mob & EQUIP_PREVIEW_JOB) && (previewJob.type == /datum/job/ai || previewJob.type == /datum/job/cyborg)))
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

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	preview_icon = icon('icons/effects/128x48.dmi', bgstate)
	preview_icon.Scale(48+32, 16+32)

	if(LAZYLEN(mannequin.descriptors))
		for(var/entry in body_descriptors)
			mannequin.descriptors[entry] = body_descriptors[entry]
	var/list/scale = mannequin.get_scale()

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin, NORTH, always_use_defdir = 1)
	stamp.Scale(scale[1] * stamp.Width(), scale[2] * stamp.Height())
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin, WEST, always_use_defdir = 1)
	stamp.Scale(scale[1] * stamp.Width(), scale[2] * stamp.Height())
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin, SOUTH, always_use_defdir = 1)
	stamp.Scale(scale[1] * stamp.Width(), scale[2] * stamp.Height())
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
