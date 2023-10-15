GLOBAL_TYPED_NEW(ert, /datum/antagonist/ert)

/datum/antagonist/ert
	id = MODE_ERT
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	antag_text = "Think through your actions and make the roleplay immersive! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! <b>Please remember all \
		rules aside from those without explicit exceptions apply to you.</b>"
	landmark_id = "Response Team"
	id_type = /obj/item/card/id/centcom/station/ert

	valid_species = list(SPECIES_HUMAN,SPECIES_VATGROWN,SPECIES_SPACER,SPECIES_GRAVWORLDER,SPECIES_TRITONIAN,SPECIES_IPC) // https://baystation.xyz/index.php?title=Sol_Central_Government_Fleet#Recruitment
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hud_ert"

	hard_cap = 5
	hard_cap_round = 5
	initial_spawn_req = 5
	initial_spawn_target = 5
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives
	skill_setter = /datum/antag_skill_setter/generic/ert

	faction = "emergency"
	no_prior_faction = TRUE

	base_to_load = /singleton/map_template/ruin/antag_spawn/ert
	/// If set to `TRUE` will prevent shuttle announcements and identifiable overmap icons.
	var/is_secret = FALSE
	var/arrived = FALSE
	var/reason = ""

/datum/antagonist/ert/Initialize()
	. = ..()
	default_access |= get_all_station_access() + get_all_centcom_access() - access_cent_captain

/datum/antagonist/ert/greet(datum/mind/player)
	if(!..())
		return

	if(!reason)
		return
	to_chat(player.current, SPAN_BOLD(FONT_LARGE("You have been summoned to the [station_name()] for the following reason: " + SPAN_NOTICE(reason))))

//Equip proc has been moved to the map specific folders.
