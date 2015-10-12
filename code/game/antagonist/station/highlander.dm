var/datum/antagonist/highlander/highlanders

/datum/antagonist/highlander
	role_text = "Highlander"
	role_text_plural = "Highlanders"
	welcome_text = "There can be only one."
	id = MODE_HIGHLANDER
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE //| ANTAG_RANDSPAWN | ANTAG_VOTABLE // Someday...

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 3
	initial_spawn_target = 5

/datum/antagonist/highlander/New()
	..()
	highlanders = src

/datum/antagonist/highlander/create_objectives(var/datum/mind/player)

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = player
	steal_objective.set_target("nuclear authentication disk")
	player.objectives |= steal_objective

	var/datum/objective/hijack/hijack_objective = new
	hijack_objective.owner = player
	player.objectives |= hijack_objective

/datum/antagonist/highlander/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/weapon/implant))
			continue
		qdel(I)

	player.equip_to_slot_or_del(new /obj/item/clothing/under/kilt(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(player), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/head/beret(player), slot_head)
	player.equip_to_slot_or_del(new /obj/item/weapon/material/sword(player), slot_l_hand)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(get_turf(player)), slot_l_store)

	var/obj/item/weapon/card/id/W = new(player)
	W.name = "[player.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.assignment = "Highlander"
	W.registered_name = player.real_name
	player.equip_to_slot_or_del(W, slot_wear_id)

/proc/only_one()

	if(!ticker)
		alert("The game hasn't started yet!")
		return

	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		highlanders.add_antagonist(H.mind)

	message_admins("\blue [key_name_admin(usr)] used THERE CAN BE ONLY ONE!", 1)
	log_admin("[key_name(usr)] used there can be only one.")