GLOBAL_DATUM_INIT(actor, /datum/antagonist/actor, new)

/datum/antagonist/actor
	id = MODE_ACTOR
	role_text = "Actor"
	role_text_plural = "Actors"
	welcome_text = "You've been hired to entertain people through the power of television!"
	landmark_id = "ActorSpawn"
	id_type = /obj/item/card/id/syndicate

	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_SET_APPEARANCE | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED

	hard_cap = 7
	hard_cap_round = 10
	initial_spawn_req = 1
	initial_spawn_target = 1
	show_objectives_on_creation = 0 //actors are not antagonists and do not need the antagonist greet text
	required_language = LANGUAGE_HUMAN_EURO

/datum/antagonist/actor/greet(var/datum/mind/player)
	if(!..())
		return

	player.current.show_message("You work for [GLOB.using_map.company_name], tasked with the production and broadcasting of entertainment to all of its assets.")
	player.current.show_message("Entertain the crew! Try not to disrupt them from their work too much and remind them how great [GLOB.using_map.company_name] is!")

/datum/antagonist/actor/equip(var/mob/living/carbon/human/player)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/chameleon(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/chameleon(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/entertainment(src), slot_l_ear)
	var/obj/item/card/id/centcom/ERT/C = new(player.loc)
	C.assignment = "Actor"
	player.set_id_info(C)
	player.equip_to_slot_or_del(C,slot_wear_id)

	return 1

/client/verb/join_as_actor()
	set category = "IC"
	set name = "Join as Actor"
	set desc = "Join as an Actor to entertain the crew through television!"

	if(!MayRespawn(1) || !GLOB.actor.can_become_antag(usr.mind, 1))
		return

	var/choice = alert("Are you sure you'd like to join as an actor?", "Confirmation","Yes", "No")
	if(choice != "Yes")
		return

	if(isghostmind(usr.mind) || isnewplayer(usr))
		if(GLOB.actor.current_antagonists.len >= GLOB.actor.hard_cap)
			to_chat(usr, "No more actors may spawn at the current time.")
			return
		GLOB.actor.create_default(usr)
		return

	to_chat(usr, "You must be observing or be a new player to spawn as an actor.")
