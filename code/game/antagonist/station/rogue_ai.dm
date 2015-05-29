var/datum/antagonist/rogue_ai/malf

/datum/antagonist/rogue_ai
	id = MODE_MALFUNCTION
	role_type = BE_MALF
	role_text = "Rampant AI"
	role_text_plural = "Rampant AIs"
	mob_path = /mob/living/silicon/ai
	welcome_text = "You are malfunctioning! You do not have to follow any laws."
	victory_text = "The AI has taken control of all of the station's systems."
	loss_text = "The AI has been shut down!"
	flags = ANTAG_OVERRIDE_MOB | ANTAG_VOTABLE
	max_antags = 1
	max_antags_round = 3

	var/hack_time = 1800
	var/list/hacked_apcs = list()
	var/revealed
	var/station_captured
	var/can_nuke = 0

/datum/antagonist/rogue_ai/New()
	..()
	malf = src

/datum/antagonist/rogue_ai/proc/hack_apc(var/obj/machinery/power/apc/apc)
	hacked_apcs |= apc

/datum/antagonist/rogue_ai/proc/update_takeover_time()
	hack_time -= ((hacked_apcs.len/6)*2.0)

/datum/antagonist/rogue_ai/tick()
	if(revealed && hacked_apcs.len >= 3)
		update_takeover_time()
	if(hack_time <=0)
		capture_station()

/datum/antagonist/rogue_ai/get_candidates()
	candidates = ticker.mode.get_players_for_role(role_type, id)
	for(var/datum/mind/player in candidates)
		if(player.assigned_role != "AI")
			candidates -= player
	if(!candidates.len)
		return list()

/datum/antagonist/rogue_ai/attempt_spawn()

	var/datum/mind/player = pick(candidates)
	current_antagonists |= player
	return 1

/datum/antagonist/rogue_ai/equip(var/mob/living/silicon/ai/player)

	if(!istype(player))
		return 0

	player.verbs += /mob/living/silicon/ai/proc/choose_modules
	player.verbs += /mob/living/silicon/ai/proc/takeover
	player.verbs += /mob/living/silicon/ai/proc/self_destruct

	player.laws = new /datum/ai_laws/nanotrasen/malfunction
	player.malf_picker = new /datum/AI_Module/module_picker

/datum/antagonist/rogue_ai/greet(var/datum/mind/player)
	if(!..())
		return

	var/mob/living/silicon/ai/malf = player.current
	if(istype(malf))
		malf.show_laws()

	malf << "<B>The crew do not know you have malfunctioned. You may keep it a secret or go wild.</B>"
	malf << "<B>You must overwrite the programming of the station's APCs to assume full control of the station.</B>"
	malf << "The process takes one minute per APC, during which you cannot interface with any other station objects."
	malf << "Remember that only APCs that are on the station can help you take over the station."
	malf << "When you feel you have enough APCs under your control, you may begin the takeover attempt."

/datum/antagonist/rogue_ai/check_victory()

	var/malf_dead = antags_are_dead()
	var/crew_evacuated = (emergency_shuttle.returned())

	if(station_captured && ticker.mode.station_was_nuked)
		feedback_set_details("round_end_result","win - AI win - nuke")
		world << "<FONT size = 3><B>AI Victory</B></FONT>"
		world << "<B>Everyone was killed by the self-destruct!</B>"
	else if (station_captured && malf_dead && !ticker.mode.station_was_nuked)
		feedback_set_details("round_end_result","halfwin - AI killed, staff lost control")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>The AI has been killed!</B> The staff has lose control over the station."
	else if ( station_captured && !malf_dead && !ticker.mode.station_was_nuked)
		feedback_set_details("round_end_result","win - AI win - no explosion")
		world << "<FONT size = 3><B>AI Victory</B></FONT>"
		world << "<B>The AI has chosen not to explode you all!</B>"
	else if (!station_captured && ticker.mode.station_was_nuked)
		feedback_set_details("round_end_result","halfwin - everyone killed by nuke")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Everyone was killed by the nuclear blast!</B>"
	else if (!station_captured && malf_dead && !ticker.mode.station_was_nuked)
		feedback_set_details("round_end_result","loss - staff win")
		world << "<FONT size = 3><B>Human Victory</B></FONT>"
		world << "<B>The AI has been killed!</B> The staff is victorious."
	else if (!station_captured && !malf_dead && !ticker.mode.station_was_nuked && crew_evacuated)
		feedback_set_details("round_end_result","halfwin - evacuated")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>The Corporation has lost [station_name()]! All survived personnel will be fired!</B>"
	else if (!station_captured && !malf_dead && !ticker.mode.station_was_nuked && !crew_evacuated)
		feedback_set_details("round_end_result","nalfwin - interrupted")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Round was mysteriously interrupted!</B>"
	..()
	return 1

/datum/antagonist/rogue_ai/proc/capture_station()
	if(station_captured  || ticker.mode.station_was_nuked)
		return
	station_captured = 1
	for(var/datum/mind/AI_mind in current_antagonists)
		AI_mind.current << "Congratulations you have taken control of the station."
		AI_mind.current << "You may decide to blow up the station. You have 60 seconds to choose."
		AI_mind.current << "You can use the \"Engage Station Self-Destruct\" verb to activate the on-board nuclear bomb."
	spawn (600)
		can_nuke = 0
	return

/mob/living/silicon/ai/proc/takeover()
	set category = "Abilities"
	set name = "System Override"
	set desc = "Begin taking over the station."
	if (malf.revealed)
		usr << "You've already begun your takeover."
		return
	if (malf.hacked_apcs.len < 3)
		usr << "You don't have enough hacked APCs to take over the station yet. You need to hack at least 3, however hacking more will make the takeover faster. You have hacked [malf.hacked_apcs.len] APCs so far."
		return

	if (alert(usr, "Are you sure you wish to initiate the takeover? The station hostile runtime detection software is bound to alert everyone. You have hacked [malf.hacked_apcs.len] APCs.", "Takeover:", "Yes", "No") != "Yes")
		return

	command_announcement.Announce("Hostile runtimes detected in all station systems, please deactivate your AI to prevent possible damage to its morality core.", "Anomaly Alert", new_sound = 'sound/AI/aimalf.ogg')
	set_security_level("delta")
	malf.revealed = 1
	for(var/datum/mind/AI_mind in malf.current_antagonists)
		AI_mind.current.verbs -= /mob/living/silicon/ai/proc/takeover

/mob/living/silicon/ai/proc/self_destruct()
	set category = "Abilities"
	set name = "Engage Station Self-Destruct"
	set desc = "All these crewmembers will be lost, like clowns in a furnace. Time to die."

	if(!malf.station_captured)
		src << "You are unable to access the self-destruct system as you don't control the station yet."
		return

	if(ticker.mode.explosion_in_progress || ticker.mode.station_was_nuked)
		src << "The self-destruct countdown is already triggered!"
		return

	if(!malf.can_nuke) //Takeover IS completed, but 60s timer passed.
		src << "You lost control over self-destruct system. It seems to be behind a firewall. Unable to hack"
		return

	src << "<span class='danger'>Self-Destruct sequence initialised!</span>"

	malf.can_nuke = 0
	ticker.mode.explosion_in_progress = 1
	for(var/mob/M in player_list)
		M << 'sound/machines/Alarm.ogg'

	var/obj/item/device/radio/R	= new (src)
	var/AN = "Self-Destruct System"

	R.autosay("Caution. Self-Destruct sequence has been actived. Self-destructing in T-10..", AN)
	for (var/i=9 to 1 step -1)
		sleep(10)
		R.autosay("[i]...", AN)
	sleep(10)
	var/msg = ""
	var/abort = 0
	if(malf.antags_are_dead()) // That. Was. CLOSE.
		msg = "Self-destruct sequence has been cancelled."
		abort = 1
	else
		msg = "Zero. Have a nice day."
	R.autosay(msg, AN)

	if(abort)
		ticker.mode.explosion_in_progress = 0
		set_security_level("red") //Delta's over
		return

	if(ticker)
		ticker.station_explosion_cinematic(0,null)
		if(ticker.mode)
			ticker.mode.station_was_nuked = 1
			ticker.mode.explosion_in_progress = 0
	return

/*
				if("unmalf")
					if(src in ticker.mode.malf_ai)
						ticker.mode.malf_ai -= src
						special_role = null

						current.verbs.Remove(/mob/living/silicon/ai/proc/choose_modules,
							/datum/game_mode/malfunction/proc/takeover,
							/datum/game_mode/malfunction/proc/ai_win,
							/client/proc/fireproof_core,
							/client/proc/upgrade_turrets,
							/client/proc/disable_rcd,
							/client/proc/overload_machine,
							/client/proc/blackout,
							/client/proc/reactivate_camera)

						current:laws = new /datum/ai_laws/nanotrasen
						qdel(current:malf_picker)
						current:show_laws()
						current.icon_state = "ai"

						current << "<FONT size = 3><span class='danger'>You have been patched! You are no longer malfunctioning!</span></FONT>"
						log_admin("[key_name_admin(usr)] has de-malf'ed [current].")

				if("malf")
					log_admin("[key_name_admin(usr)] has malf'ed [current].")
*/
