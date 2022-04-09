/datum/job/ai
	title = "AI"
	department_flag = MSC

	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#3f823f"
	supervisors = "your laws"
	req_admin_notify = 1
	minimal_player_age = 14
	account_allowed = 0
	economic_power = 0
	outfit_type = /decl/hierarchy/outfit/job/silicon/ai
	loadout_allowed = FALSE
	hud_icon = "hudblank"
	skill_points = 0
	no_skill_buffs = TRUE
	min_skill = list(
		SKILL_BUREAUCRACY   = SKILL_EXPERT,
		SKILL_FINANCE       = SKILL_EXPERT,
		SKILL_EVA           = SKILL_EXPERT,
		SKILL_MECH          = SKILL_EXPERT,
		SKILL_PILOT         = SKILL_EXPERT,
		SKILL_HAULING       = SKILL_NONE,
		SKILL_COMPUTER      = SKILL_PROF,
		SKILL_BOTANY        = SKILL_EXPERT,
		SKILL_COOKING       = SKILL_EXPERT,
		SKILL_COMBAT        = SKILL_EXPERT,
		SKILL_WEAPONS       = SKILL_EXPERT,
		SKILL_FORENSICS     = SKILL_EXPERT,
		SKILL_CONSTRUCTION  = SKILL_EXPERT,
		SKILL_ELECTRICAL    = SKILL_EXPERT,
		SKILL_ATMOS         = SKILL_EXPERT,
		SKILL_ENGINES       = SKILL_EXPERT,
		SKILL_DEVICES       = SKILL_EXPERT,
		SKILL_SCIENCE       = SKILL_EXPERT,
		SKILL_MEDICAL       = SKILL_EXPERT,
		SKILL_ANATOMY       = SKILL_EXPERT,
		SKILL_CHEMISTRY     = SKILL_EXPERT
	)

/datum/job/ai/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/ai/handle_variant_join(var/mob/living/carbon/human/H, var/alt_title)
	return H

/datum/job/cyborg
	title = "Robot"
	department_flag = MSC
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"
	selection_color = "#254c25"
	minimal_player_age = 7
	account_allowed = 0
	economic_power = 0
	loadout_allowed = FALSE
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg
	hud_icon = "hudblank"
	skill_points = 0
	no_skill_buffs = TRUE

/datum/job/cyborg/handle_variant_join(var/mob/living/carbon/human/H, var/alt_title)
	return H && H.Robotize(SSrobots.get_mob_type_by_title(alt_title || title))

/datum/job/cyborg/equip(var/mob/living/carbon/human/H)
	return !!H

/datum/job/cyborg/New()
	..()
	alt_titles = SSrobots.robot_alt_titles.Copy()
	alt_titles -= title // So the unit test doesn't flip out if a mob or mmi type is declared for our main title.
