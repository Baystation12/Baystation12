
/datum/antagonist/insurrectionist
	id = MODE_INNIE
	//role_type = BE_INNIE
	role_text = "Insurrectionist"
	//bantype = "operative"
	antag_indicator = "innie"
	role_text_plural = "Insurrectionist"
	landmark_id = "Insurrectionist-Spawn"
	welcome_text = "You are a member of the Insurrectionist forces, down with the UNSC! Use :t to speak to the rest of your rebels."
	leader_welcome_text = "You are the leader of the Insurrectionist forces, down with the UNSC! Use :t to speak to your underlings."
	welcome_text = "To speak on your group's private channel use :t."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_LEADER
	id_type = /obj/item/weapon/card/id/insurrectionist
	//default_access = list(access_insurrectionist)
	antaghud_indicator = "hudinnie"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

/datum/antagonist/insurrectionist/create_global_objectives()
	if(!..())
		return 0

	global_objectives |= insurrection_objectives
	return 1

/datum/antagonist/insurrectionist/equip(var/mob/living/carbon/human/player)

	if(!..(player))
		return 0

	player.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(player), slot_gloves)
	if(player.backbag == 2) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(player), slot_back)
	if(player.backbag == 3) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(player), slot_back)
	if(player.backbag == 4) player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)
	player.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/pill/cyanide(player), slot_in_backpack)
	//player.equip_to_slot_or_del(new /obj/item/device/radio/headset/insurrection(player), slot_l_ear) - Re-Add when comms system is updated.


	/*if (player.mind == leader)
		var/obj/item/device/radio/uplink/U = new(player.loc, player.mind, 40)
		player.put_in_hands(U)*/

	player.update_icons()

	if(player.mind == leader)
		create_leader_id(player)
	else
		create_id("Insurrectionist", player)
	//create_radio(SYND_FREQ, player)
	return 1

/datum/antagonist/insurrectionist/proc/create_leader_id(var/mob/living/carbon/human/player)
	var/obj/item/weapon/card/id/W = create_id("Insurrectionist Leader", player, 1)
	W.access |= access_innie_boss
	return W

//spawn some sympathisers among the crew
/datum/antagonist/traitor/insurrectionist
	id = MODE_INNIE_TRAITOR
	welcome_text = "You are an Insurrection sympathiser! Work to undermine the crew, but don't reveal your true loyalties until the right moment."

	//not too many
	hard_cap = 2
	hard_cap_round = 3
	initial_spawn_req = 0
	initial_spawn_target = 1

/datum/antagonist/traitor/insurrectionist/create_global_objectives()
	if(!..())
		return 0

	global_objectives |= insurrection_objectives
	return 1
