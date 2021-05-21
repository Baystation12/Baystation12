
#include "../base_assault/base_assault_gm.dm"

#define SCORE_DISPLAY_DELAY 2 MINUTES

/datum/objective/colony_capture/unsc
	short_text = "Capture and Hold the city"
	explanation_text = "Take and hold the following parts of the city: Morgue(NE), Salon (NW), City Hall (Mid), Police Station (Mid), AI Core(SE), Church (SW)"
	radio_name = "UNSC Overwatch"

/datum/objective/colony_capture/cov
	short_text = "Capture and Hold the city"
	explanation_text = "Take and hold the following parts of the city: AI Core(SE), Church (SW), City Hall (Mid), Police Station (Mid), Morgue(NE), Salon (NW)"
	radio_name = "Covenant Overwatch"
	radio_language = LANGUAGE_SANGHEILI

/datum/game_mode/base_assault/neutral //A seperate gamemode with a similar theme. Attack and hold a central base, then advance on the enemy.
	name = "Base Assault (Capture And Hold)"
	config_tag = "base_assault_capture_and_hold"
	round_description = "Assault and hold a neutral city from the enemy forces."
	extended_round_description = "Assault and hold a neutral city from enemy forces, then once the base is captured."
	probability = 1
	ship_lockdown_duration = 10 MINUTES
	faction_balance = list(/datum/faction/covenant,/datum/faction/unsc)
	defenders = "The UNSC"
	attackers = " The Covenant"
	winning_side = "error"
	flank_tags = list()
	var/gm_max_cap_score = 2400
	var/next_score_display = 0

/datum/game_mode/base_assault/neutral/check_finished()
	if(world.time >= stalemate_at)
		winning_side = "Nobody. Stalemate!"
		return 1
	if(get_defender_loss_status())
		winning_side = attackers
		return 1
	if(get_attacker_loss_status())
		winning_side = defenders
		return 1
	return 0

/datum/game_mode/base_assault/neutral/pre_setup()
	. = ..()
	GLOB.UNSC.setup_faction_objectives(list(/datum/objective/colony_capture/unsc))
	GLOB.COVENANT.setup_faction_objectives(list(/datum/objective/colony_capture/cov))
	next_score_display = world.time + ship_lockdown_duration + SCORE_DISPLAY_DELAY

/datum/game_mode/base_assault/neutral/proc/do_display(var/list/display_to,var/sender_name,var/percentile,var/enemy_percentile,var/points_ours,var/points_enemy)
	for(var/datum/mind/mind in display_to)
		if(mind.current)
			to_chat(mind.current,"<span class='radio'>\
			<span class='name'>[sender_name]</span> \
			<b>\[SYSTEM ALERTS\]</b> \
			<span class='message'>Capture progress is [percentile]% done. Enemy presence is [enemy_percentile]% done. We hold the following points:[points_ours]. The enemy holds the following points:[points_enemy].</span>\
			</span>")


/datum/game_mode/base_assault/neutral/proc/display_scores()
	if(world.time > next_score_display)
		next_score_display = world.time + SCORE_DISPLAY_DELAY
		var/datum/objective/colony_capture/cap = locate(/datum/objective/colony_capture/unsc) in GLOB.UNSC.all_objectives
		var/datum/objective/colony_capture/cap_enemy = locate(/datum/objective/colony_capture/cov) in GLOB.COVENANT.all_objectives
		var/perc = round(cap.capture_score / gm_max_cap_score,0.1) * 100
		var/perc_enemy = round(cap_enemy.capture_score/gm_max_cap_score,0.1) * 100
		var/points_ours = ""
		for(var/obj/point in cap.controlled_nodes)
			var/area/a = get_area(point)
			if(a)
				points_ours += "[a.name],"
		var/points_enemy = ""
		for(var/obj/point in cap_enemy.controlled_nodes)
			var/area/a = get_area(point)
			if(a)
				points_enemy += "[a.name],"
		do_display(GLOB.UNSC.living_minds,"HIGHCOMM",perc,perc_enemy,points_ours,points_enemy)
		do_display(GLOB.COVENANT.living_minds,"Local Command",perc_enemy,perc,points_enemy,points_ours)

/datum/game_mode/base_assault/neutral/process()
	. = ..()
	display_scores()

/datum/game_mode/base_assault/neutral/get_defender_loss_status()
	var/datum/objective/colony_capture/cap = locate(/datum/objective/colony_capture/cov) in GLOB.COVENANT.all_objectives
	if(!cap)
		return 0
	return cap.capture_score > gm_max_cap_score

/datum/game_mode/base_assault/neutral/get_attacker_loss_status()
	var/datum/objective/colony_capture/cap = locate(/datum/objective/colony_capture/unsc) in GLOB.UNSC.all_objectives
	if(!cap)
		return 0
	return cap.capture_score > gm_max_cap_score
