
/datum/job/colonist
	title = "Colonist"
	selection_color = "#94940A"
	whitelisted_species = list(/datum/species/human)
	spawn_faction = "Human Colony"
	supervisors = " the Colony Mayor"
	loadout_allowed = TRUE
	total_positions = -1
	spawn_positions = -1
	account_allowed = TRUE
	generate_email = TRUE
	latejoin_at_spawnpoints = FALSE
	outfit_type = /decl/hierarchy/outfit/job/colonist
	//access = list(access_janitor, access_maint_tunnels, access_research)
	alt_titles = list("Miner","Doctor","Nurse","Warehouse Worker","Construction Worker","Surgeon","Store Owner","Nightclub Owner","Secretary","Cargo Worker","Bartender","Cook","Chef","Farmer","Judge","Cargo Dock Worker","Lawyer","EMT","Paramedic","Bodyguard","Janitor")

/datum/job/colonist/get_email_domain()
	return "geminus.net"

/obj/effect/landmark/start/colonist
	name = "Colonist"

/datum/job/colonist/mayor
	title = "Mayor"
	total_positions = 1
	spawn_positions = 1
	supervisors = " your citizens"
	economic_modifier = 3
	outfit_type = /decl/hierarchy/outfit/job/mayor
	/*
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway)
			            */
	alt_titles = list("Governor")

/datum/job/colonist/police
	title = "GCPD Officer"
	economic_modifier = 1.5
	outfit_type = /decl/hierarchy/outfit/job/police
	/*access = list(access_security, access_brig, access_maint_tunnels,
						access_external_airlocks, access_emergency_storage,
			            access_eva, access_sec_doors)*/
	alt_titles = list("GCPD SWAT Officer","GCPD Cadet","GCPD Detective","GCPD Forensic Scientist")

/datum/job/colonist/police/chief
	title = "Chief of Police"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 2
	outfit_type = /decl/hierarchy/outfit/job/cop
	/*access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)*/

/datum/job/colony_ai
	title = "UEG Colonial AI"
	spawn_faction = "Human Colony"
	spawn_positions = 1
	is_whitelisted = 1
	outfit_type = /decl/hierarchy/outfit/job/colony_AI
	req_admin_notify = 1
	//job_guide = "Your responsibility is to aid the captain and ship's crew and you are given a vast amount of autonomy to that end. You are entirely loyal to the UNSC and your current mission however."
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		return 1

/datum/job/colony_ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/colony_ai/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/straight_jacket(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)

/decl/hierarchy/outfit/job/colony_AI
	name = "Artificial Intelligence"

	l_ear = null
	r_ear = null
	uniform = null
	suit = null
	shoes = null
	head = null
	belt = null
	l_pocket = null
	r_pocket = null

	id_type = null

	flags = 0

/obj/effect/landmark/start/colony_AI
	name = "UEG Colonial AI"
