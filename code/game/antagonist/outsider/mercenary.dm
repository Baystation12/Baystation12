var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_type = BE_OPERATIVE
	role_text = "Mercenary"
	bantype = "operative"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	max_antags = 4
	max_antags_round = 6
	id_type = /obj/item/weapon/card/id/syndicate

/datum/antagonist/mercenary/New()
	..()
	mercs = src

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return 0
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear
	return 1

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	if(player.backbag == 2) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(player), slot_back)
	if(player.backbag == 3) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(player), slot_back)
	if(player.backbag == 4) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/cyanide(player), slot_in_backpack)
	player.update_icons()

	create_id("Mercenary", player)
	create_radio(SYND_FREQ, player)
	return 1

/datum/antagonist/mercenary/place_all_mobs()
	var/spawnpos = 1
	for(var/datum/mind/player in current_antagonists)
		player.current.loc = starting_locations[spawnpos]
		spawnpos++
		if(spawnpos > starting_locations.len)
			spawnpos = 1

/datum/antagonist/mercenary/create_nuke()
	..()
	// Create the radio.
	var/obj/effect/landmark/uplinkdevice = locate("landmark*Syndicate-Uplink")
	if(uplinkdevice)
		var/obj/item/device/radio/uplink/U = new(uplinkdevice.loc)
		U.hidden_uplink.uses = 40