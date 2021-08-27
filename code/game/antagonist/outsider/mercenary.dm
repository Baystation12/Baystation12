GLOBAL_DATUM_INIT(mercs, /datum/antagonist/mercenary, new)

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_text = "Mercenary"
	antag_indicator = "hudsyndicate"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudoperative"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 3
	initial_spawn_target = 5
	min_player_age = 14

	faction = "mercenary"

	base_to_load = /datum/map_template/ruin/antag_spawn/mercenary

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return 0
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return 1

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0

	var/decl/hierarchy/outfit/mercenary = outfit_by_type(/decl/hierarchy/outfit/mercenary)
	mercenary.equip(player)

	var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	player.put_in_hands(U)

	return 1

/datum/antagonist/mercenary/equip_vox(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	vox.equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_casual(vox), slot_w_uniform)
	vox.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(vox), slot_shoes)
	vox.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(vox), slot_gloves)
	vox.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat/vox(vox), slot_wear_mask)
	vox.equip_to_slot_or_del(new /obj/item/tank/nitrogen(vox), slot_back)
	vox.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(vox), slot_glasses)
	vox.equip_to_slot_or_del(new /obj/item/card/id/syndicate(vox), slot_wear_id)
	vox.put_in_hands(locate(/obj/item/device/radio/uplink) in old.contents)
	vox.set_internals(locate(/obj/item/tank) in vox.contents)


/obj/item/vox_changer/merc
	allowed_role = "Mercenary"

/obj/item/vox_changer/merc/OnCreated(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.mercs.equip_vox(vox, old)

/obj/item/vox_changer/merc/OnReady(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.mercs.update_access(vox)
