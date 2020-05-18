GLOBAL_DATUM_INIT(hunters, /datum/antagonist/hunter, new)

/datum/antagonist/hunter
	id = MODE_HUNTER
	role_text = "Hunter"
	role_text_plural = "Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You are a gyne of the Ascent, and command a brood of alates. Your task is to \
	take control of this sector so that you may found a new fortress-nest. Identify and capture local resources, \
	and remove anything that might threaten your progeny."
	welcome_text = "You are an alate of the Ascent, tasked with ridding this sector of whatever your matriarch directs you to, \
	preparing it for the foundation of a new fortress-nest. Obey your gyne and bring prosperity to your nest-lineage."
	leader_welcome_text
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 10
	hard_cap_round = 10
	initial_spawn_req = 4
	initial_spawn_target = 6

/datum/antagonist/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..()
	if(ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		if(!leader && is_species_whitelisted(player.current, SPECIES_MANTID_GYNE))
			leader = player
			if(H.species.get_bodytype() != SPECIES_MANTID_GYNE)
				H.set_species(SPECIES_MANTID_GYNE)
			H.gender = FEMALE
		else
			if(H.species.get_bodytype() != SPECIES_MANTID_ALATE)
				H.set_species(SPECIES_MANTID_ALATE)
			H.gender = MALE
		var/decl/cultural_info/culture/ascent/ascent_culture = SSculture.get_culture(CULTURE_ASCENT)
		H.real_name = ascent_culture.get_random_name(H.gender)
		H.name = H.real_name

/datum/antagonist/hunter/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		if(player.species.get_bodytype(player) == SPECIES_MANTID_GYNE)
			equip_rig(/obj/item/weapon/rig/mantid/gyne, player)
		else
			equip_rig(/obj/item/weapon/rig/mantid, player)
			player.put_in_hands(new /obj/item/weapon/gun/energy/particle)

/datum/antagonist/hunter/equip_rig(rig_type, mob/living/carbon/human/player)
	var/obj/item/weapon/rig/mantid/rig = ..()
	if(rig)
		rig.visible_name = player.real_name
		return rig
