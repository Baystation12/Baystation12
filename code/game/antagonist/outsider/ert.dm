var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id = MODE_ERT
	bantype = "Emergency Response Team"
	role_type = BE_OPERATIVE
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and company officials."
	leader_welcome_text = "As leader of the Emergency Response Team, you answer only to the Company, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
	landmark_id = "Response Team"
	id_type = /obj/item/weapon/card/id/centcom/ERT

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/ert/New()
	..()
	ert = src

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	player.current << "The Emergency Response Team works for Asset Protection; your job is to protect [company_name]'s ass-ets. There is a code red alert on [station_name()], you are tasked to go and fix the problem."
	player.current << "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	//Special radio setup
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/ert(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
	
	create_id(role_text, player)
	return 1
