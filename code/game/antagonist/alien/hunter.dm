GLOBAL_DATUM_INIT(hunters, /datum/antagonist/hunter, new)

/datum/antagonist/hunter
	id = MODE_HUNTER
	role_text = "Hunter"
	role_text_plural = "Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You command a band of Hunters. Guide and command your children, and bring glory to your lineage."
	welcome_text = "You are a Hunter. Serve your queen. Glory to the Ascent."
	leader_welcome_text
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 5
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	var/queen_count = 0
	var/warrior_count = 0

	var/list/queen_species = list(
		SPECIES_MANTID_GYNE,
		SPECIES_MONARCH_QUEEN
	)
	var/list/warrior_species = list(
		SPECIES_MANTID_ALATE,
		SPECIES_MONARCH_WORKER
	)
	var/list/rig_types = list(
		SPECIES_MANTID_GYNE =    /obj/item/weapon/rig/mantid/gyne,
		SPECIES_MONARCH_QUEEN = /obj/item/weapon/rig/mantid/nabber,
		SPECIES_MONARCH_WORKER = /obj/item/weapon/rig/mantid/nabber,
		SPECIES_MANTID_ALATE =   /obj/item/weapon/rig/mantid
	)

/datum/antagonist/hunter/create_global_objectives(var/override=0)
	. = ..()
	if(.)
		global_objectives += new /datum/objective/hunter_preserve/queens
		global_objectives += new /datum/objective/hunter_preserve/warriors

/datum/antagonist/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..(player, TRUE)
	if(ishuman(player.current))

		var/leader_species =   SPECIES_MANTID_GYNE
		var/follower_species = SPECIES_MANTID_ALATE
		if(input(player.current, "Do you wish to be a mantid or a serpentid") as null|anything in list("Mantid", "Serpentid") == "Serpentid")
			leader_species =   SPECIES_MONARCH_QUEEN
			follower_species = SPECIES_MONARCH_WORKER

		var/mob/living/carbon/human/H = player.current
		if(!leader)
			leader = player
			if(H.species.name != leader_species)
				H.set_species(leader_species)
			queen_count++
		else
			if(H.species.get_bodytype() != follower_species)
				H.set_species(follower_species)
			warrior_count++

		var/decl/cultural_info/culture = H.cultural_info[TAG_CULTURE]
		H.real_name = culture.get_random_name(H.gender)
		H.name = H.real_name

		if(H.wearing_rig)
			H.wearing_rig.visible_name = H.real_name

		player.current.faction = faction

/datum/antagonist/hunter/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		var/rig_type = rig_types[player.species.name]
		if(rig_type)
			var/obj/item/weapon/rig/rig = new rig_type
			rig.seal_delay = 0
			player.put_in_hands(rig)
			player.equip_to_slot_or_del(rig,slot_back)
			if(rig)
				rig.toggle_seals(src,1)
				rig.seal_delay = initial(rig.seal_delay)
				if(rig.air_supply)
					player.internal = rig.air_supply
					if(player.internals)
						player.internals.icon_state = "internal1"
		player.put_in_hands(new /obj/item/weapon/gun/energy/particle)

/datum/objective/hunter_preserve
	var/list/preserve_species

/datum/objective/hunter_preserve/check_completion()
	var/survive_count = get_survival_target()
	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		if((H.species.name in preserve_species) && H.stat != DEAD)
			survive_count--
			if(survive_count <= 0)
				return TRUE
	return FALSE

/datum/objective/hunter_preserve/proc/get_survival_target()
	return 0

/datum/objective/hunter_preserve/queens
	explanation_text = "Preserve the lives of any queens present."

/datum/objective/hunter_preserve/queens/New()
	..()
	preserve_species = GLOB.hunters.queen_species

/datum/objective/hunter_preserve/queens/get_survival_target()
	return GLOB.hunters.queen_count

/datum/objective/hunter_preserve/warriors
	explanation_text = "Preserve the lives of at least half of the warriors present."

/datum/objective/hunter_preserve/warriors/New()
	..()
	preserve_species = GLOB.hunters.warrior_species

/datum/objective/hunter_preserve/warriors/get_survival_target()
	return (GLOB.hunters.warrior_count * 0.5)
