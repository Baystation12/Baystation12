#define SAVE_RESET -1
#define EQUIP_PREVIEW_LOADOUT 1
#define EQUIP_PREVIEW_JOB 2
#define EQUIP_PREVIEW_ALL (EQUIP_PREVIEW_LOADOUT|EQUIP_PREVIEW_JOB)

var/global/list/uplink_locations = list("PDA", "Headset", "None")
var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

var/list/preferences_datums = list()

datum/preferences

	// Savefile Variables

	var/path
	var/default_slot = 1							// Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0
	var/char_lock = 0
	var/savefile/loaded_preferences
	var/savefile/loaded_character


	// ------------------

	// Non-Preference Data
	var/user
	var/clientfps = 0
	var/preferences_enabled = null
	var/preferences_disabled = null

	var/client/client = null
	var/client_ckey = null

	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	var/datum/paiCandidate/candidate

	var/datum/browser/panel

	var/selected_menu = 1
	var/has_cortical_stack = TRUE
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	// -------------------

	// Game-Preferences

	var/lastchangelog = ""							// Saved changlog filesize to detect if there was a change

	var/ooccolor = "#010000"						// Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

	var/list/never_be_special_role = list()
	var/list/sometimes_be_special_role = list()
	var/list/be_special_role = list()				// Special role selection

	var/list/language_prefixes = list() 			// Language prefix keys
	var/list/ignored_players = list()

	// ----------------

	// Character Preferences

	var/real_name									// Character's name
	var/species = SPECIES_HUMAN              		// Character's species
	var/gender = MALE								// Character's gender
	var/age = 30									// Character's age

	var/b_type = "A+"								// Character's blood type (Randomly generated on lock)

	var/h_style = "Bald"							// Character's hair type
	var/r_hair = 0									// Character's hair color (Red)
	var/g_hair = 0									// Character's hair color (Green)
	var/b_hair = 0									// Character's hair color (Blue)

	var/f_style = "Shaved"							// Character's face hair type
	var/r_facial = 0								// Character's face hair color (Red)
	var/g_facial = 0								// Character's face hair color (Green)
	var/b_facial = 0								// Character's face hair color (Blue)

	var/s_tone = 0									// Character's skin tone (Used when not using RGB, 0-255)
	var/r_skin = 0									// Character's skin color (Red)
	var/g_skin = 0									// Character's skin color (Green)
	var/b_skin = 0									// Character's skin color (Blue)

	var/r_eyes = 0									// Character's eye color (Red)
	var/g_eyes = 0									// Character's eye color (Green)
	var/b_eyes = 0									// Character's eye color (Blue)

	var/list/dna = list()							// Character's DNA (List of UI, generated on Lock and used to create real DNA)

	var/list/all_underwear
	var/list/all_underwear_metadata
	var/backbag = 2									// Character's backpack type
	var/list/gear
	var/list/gear_list								// Character's custom/fluff item loadout.
	var/gear_slot = 1
	var/spawnpoint = "Default" 						// Character's spawn point (0-2)
	var/list/alternate_languages = list() 			// Character's secondary language(s)

	var/home_system = "Unset"          				// Character's system of birth.
	var/citizenship = "None"            			// Character's current home system.
	var/faction = "None"                			// Character's associated faction.
	var/religion = "None"              				// Character's religious association.
	var/memory = ""

	var/job_high = null								// Most preferable job (Not a list since there can only be one 'most')
	var/list/job_medium = list() 					// Preferable jobs (List of all things selected for medium weight)
	var/list/job_low    = list() 					// Acceptable jobs (List of all the things selected for low weight)

	var/alternate_option = 2 						// Desired action for not getting any wanted jobs (0 - Random, 1 - Assitant, 2 - Lobby)
	var/list/player_alt_titles = new()				// Desired alternate titles for jobs

	var/used_skillpoints = 0						// Depreciated
	var/list/skills = list() 						// Deperciated

	var/list/organ_data = list()					// Character's cybernetic or assisted organ data
	var/list/rlimb_data = list()					// Character's cybernetic or amputated limb data
	var/disabilities = 0							// Character's disabilities (Ex. blindness, deafness)


	var/list/flavor_texts = list()					// Character's flavor text
	var/list/flavour_texts_robot = list()			// Character's flavor text when they are a robot

	var/list/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/nanotrasen_relation = "Neutral"

	var/uplinklocation = "PDA"

	var/list/relations
	var/list/relations_info

	var/metadata = ""

	//--------------------

	// Mob Preview Data

	//character preferences
	var/char_rank = ""					// Bay Compatibility.
	var/char_branch = ""				// Bay Compatibility.
	var/char_department = "Service"		// Character Department.
	var/department_playtime = 0
	var/department_rank = 0
	var/dept_experience = 0

	var/bank_balance = 0
	var/pension_balance = 0

	var/icon/preview_icon = null
	var/species_preview

	// ----------------
	var/permadeath = 0
	var/neurallaces = 0
	var/promoted = 0 // 1 for Regular > Senior, 2 for department job > head
	var/list/recommendations = list()


/datum/preferences/New(client/C)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)
	b_type = RANDOM_BLOOD_TYPE

	gear = list()

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()
/*	set_department()

<<<<<<< Updated upstream
/datum/preferences/proc/ShowChoices(mob/userT)
	if(!userT || !userT.client)	return
=======
/datum/preferences/proc/set_department()
	for(var/datum/job/job in job_master.occupations)
		if(char_branch == job.department)
			char_jobs += job
		else
			if(!char_branch || (job.department == "Service") || (job.department == "Civilian") || (job.department == "Support"))
				char_jobs += job
*/
/*
/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		var/multiplier = 1
		switch(skills[S.ID])
			if(SKILL_NONE)
				used_skillpoints += 0 * multiplier
			if(SKILL_BASIC)
				used_skillpoints += 1 * multiplier
			if(SKILL_ADEPT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 1 * multiplier
				else
					used_skillpoints += 3 * multiplier
			if(SKILL_EXPERT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 3 * multiplier
				else
					used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

*/
/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	var/dat = ""

	switch(selected_menu)
		if(1) dat += contentGeneral()
		if(2) dat += contentOccupation()
		if(3) dat += contentLoadout()
		if(4) dat += contentLocalPreference()
		if(5) dat += contentMedical()
		if(6) dat += contentEmployment()
		if(7) dat += contentSecurity()
		if(8) dat += contentGlobalPreference()
		if(9) dat += contentGenericRecord()

	usr << browse_rsc('html/images/uiBackground.png', "uiBackground.png")

	var/datum/browser/popup = new(user, "Character Setup", 0, 800, 800, src)
	popup.set_content(dat)
	popup.add_stylesheet("common", 'html/browser/menu.css')
	popup.open()

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(isliving(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	character.set_species(species)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.fully_replace_character_name(real_name)


	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.h_style = h_style
	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.f_style = f_style
	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone

	character.h_style = h_style
	character.f_style = f_style

	// Replace any missing limbs.
	for(var/name in BP_ALL_LIMBS)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && organ_data[name] != "amputated")
			var/list/organ_data = character.species.has_limbs[name]
			if(!islist(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs. The order is important for preserving low-level choices for robolimb sprites being overridden.
	for(var/name in BP_BY_DEPTH)
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.robotic = 0
		O.model = null
		if(status == "amputated")
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
		else if(status == "cyborg")
			if(rlimb_data[name])
				O.robotize(rlimb_data[name])
			else
				O.robotize()
		else //normal organ
			O.force_icon = null
			O.name = initial(O.name)
			O.desc = initial(O.desc)

	if(!is_preview_copy)
		for(var/name in list(BP_HEART,BP_EYES,BP_BRAIN))
			var/status = organ_data[name]
			if(!status)
				continue
			var/obj/item/organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.robotize()

	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()
	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = all_underwear_metadata[underwear_category_name]
		else
			all_underwear -= underwear_category_name
	if(backbag > 6 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

	character.char_branch = mil_branches.get_branch(char_branch)
	character.char_rank = mil_branches.get_rank(char_branch, char_rank)

	if(is_preview_copy)
		return

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts["head"] = flavor_texts["head"]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts["eyes"] = flavor_texts["eyes"]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	character.home_system = home_system
	character.citizenship = citizenship
	character.personal_faction = faction
	character.religion = religion

	character.skills = skills
	character.used_skillpoints = used_skillpoints

	if(!character.isSynthetic())
		character.nutrition = rand(140,360)

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = GLOB.using_map.character_load_path(S, i)
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")
	panel.close()
