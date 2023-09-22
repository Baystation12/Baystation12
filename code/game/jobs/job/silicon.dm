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
	outfit_type = /singleton/hierarchy/outfit/job/silicon/ai
	loadout_allowed = FALSE
	hud_icon = "hudblank"
	skill_points = 0
	min_skill = list(
		SKILL_BUREAUCRACY   = SKILL_EXPERIENCED,
		SKILL_FINANCE       = SKILL_EXPERIENCED,
		SKILL_EVA           = SKILL_EXPERIENCED,
		SKILL_MECH          = SKILL_EXPERIENCED,
		SKILL_PILOT         = SKILL_EXPERIENCED,
		SKILL_HAULING       = SKILL_UNSKILLED,
		SKILL_COMPUTER      = SKILL_MASTER,
		SKILL_BOTANY        = SKILL_EXPERIENCED,
		SKILL_COOKING       = SKILL_EXPERIENCED,
		SKILL_COMBAT        = SKILL_EXPERIENCED,
		SKILL_WEAPONS       = SKILL_EXPERIENCED,
		SKILL_FORENSICS     = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION  = SKILL_EXPERIENCED,
		SKILL_ELECTRICAL    = SKILL_EXPERIENCED,
		SKILL_ATMOS         = SKILL_EXPERIENCED,
		SKILL_ENGINES       = SKILL_EXPERIENCED,
		SKILL_DEVICES       = SKILL_EXPERIENCED,
		SKILL_SCIENCE       = SKILL_EXPERIENCED,
		SKILL_MEDICAL       = SKILL_EXPERIENCED,
		SKILL_ANATOMY       = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY     = SKILL_EXPERIENCED
	)

/datum/job/ai/equip(mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/ai/is_position_available()
	return (length(empty_playable_ai_cores) != 0)

/datum/job/ai/handle_variant_join(mob/living/carbon/human/H, alt_title)
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
	outfit_type = /singleton/hierarchy/outfit/job/silicon/cyborg
	hud_icon = "hudblank"
	skill_points = 0

/datum/job/cyborg/handle_variant_join(mob/living/carbon/human/H, alt_title)
	return H && H.Robotize(SSrobots.get_mob_type_by_title(alt_title || title))

/datum/job/cyborg/equip(mob/living/carbon/human/H)
	return !!H

/datum/job/cyborg/New()
	..()
	alt_titles = SSrobots.robot_alt_titles.Copy()
	alt_titles -= title // So the unit test doesn't flip out if a mob or mmi type is declared for our main title.
