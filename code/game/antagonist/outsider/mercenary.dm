var/datum/antagonist/mercenary/mercs

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_text = "Mercenary"
	antag_indicator = "synd"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
	welcome_text = "To speak on the strike team's private channel use :t."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	id_type = /obj/item/weapon/card/id/syndicate
	antaghud_indicator = "hudoperative"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6
	min_player_age = 14

	faction = "mercenary"

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
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(player), slot_gloves)
	if(player.backbag == 2) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(player), slot_back)
	if(player.backbag == 3) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(player), slot_back)
	if(player.backbag == 4) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/cyanide(player), slot_in_backpack)

	var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	player.put_in_hands(U)

	player.update_icons()

	create_id("Mercenary", player)
	create_radio(SYND_FREQ, player)
	return 1
