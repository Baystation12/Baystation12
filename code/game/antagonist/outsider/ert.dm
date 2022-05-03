GLOBAL_DATUM_INIT(ert, /datum/antagonist/ert, new)

/datum/antagonist/ert
	id = MODE_ERT
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	antag_text = "You are an <b>anti</b>-antagonist! Within the rules, try to save the ship and its crew from the ongoing crisis. \
				 Try to make sure the other players have <i>fun</i>, and if you are confused or at a loss, always adminhelp. \
				 You should also contact the staff before taking any extreme actions. \
				 <b>Remember that all rules outside of those with explicit exceptions apply to the ERT!</b>"
	welcome_text = "You shouldn't see this"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "Response Team"
	id_type = /obj/item/card/id/centcom/ERT

	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives

	base_to_load = /datum/map_template/ruin/antag_spawn/ert

	var/reason = ""

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/ert/Initialize()
	..()
	leader_welcome_text = SPAN_BOLD("You are the leader of the Emergency Response Team. ") + "As the leader, you answer only to [GLOB.using_map.company_name] officials. You have authorization to override the Commanding Officer where it is necessary to achieve your goals. However, it is recommended that you work with them to achieve your goals if possible."
	welcome_text =        SPAN_BOLD("You are a member of the Emergency Response Team.") + "As a member of the Emergency Response Team, you answer only to your leader and [GLOB.using_map.company_name] officials."

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "You are part of a Fifth Fleet Quick Reaction Force. There is a severe emergency on \the [GLOB.using_map.station_name] and you are tasked to fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, so don't move out before you're all ready. You might receive further instruction from a superior in person or through holocomms soon.")

	if(reason)
		to_chat(player.current, SPAN_BOLD(FONT_LARGE("You have been summoned to \the [GLOB.using_map.station_name] for the following reason: " + SPAN_NOTICE(reason))))

//Equip proc has been moved to the map specific folders.
