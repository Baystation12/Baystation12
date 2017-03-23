var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id = MODE_ERT
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and company officials."
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "Response Team"
	id_type = /obj/item/weapon/card/id/centcom/ERT

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/ert/New()
	..()
	leader_welcome_text = "As leader of the Emergency Response Team, you answer only to [using_map.boss_name], and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
	ert = src

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Emergency Response Team works for Asset Protection; your job is to protect [using_map.company_name]'s ass-ets. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	//Special radio setup
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/ert(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

	create_id(role_text, player)
	return 1
