var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_type = BE_OPERATIVE
	role_text = "Mercenary"
	bantype = "operative"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE
	max_antags = 4
	max_antags_round = 6

/datum/antagonist/mercenary/New()
	..()
	mercs = src

/datum/antagonist/mercenary/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	global_objectives |= new /datum/objective/nuclear

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/synd_mob)

	if(!..())
		return 0

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(synd_mob)
	R.set_frequency(SYND_FREQ)
	R.freerange = 1
	synd_mob.equip_to_slot_or_del(R, slot_l_ear)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(synd_mob), slot_shoes)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(synd_mob), slot_gloves)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
	if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
	if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
	if(synd_mob.backbag == 4) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(synd_mob), slot_back)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/cyanide(synd_mob), slot_in_backpack)
	synd_mob.update_icons()
	return 1

/datum/antagonist/mercenary/place_all_mobs()
	var/spawnpos = 1
	for(var/datum/mind/player in current_antagonists)
		player.current.loc = starting_locations[spawnpos]
		spawnpos++
		if(spawnpos > starting_locations.len)
			spawnpos = 1

/datum/antagonist/mercenary/make_nuke()
	..()
	// Create the radio.
	var/obj/effect/landmark/uplinkdevice = locate("landmark*Syndicate-Uplink")
	if(uplinkdevice)
		var/obj/item/device/radio/uplink/U = new(uplinkdevice.loc)
		U.hidden_uplink.uses = 40