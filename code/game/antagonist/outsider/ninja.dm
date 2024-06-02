GLOBAL_DATUM_INIT(ninjas, /datum/antagonist/ninja, new)


/datum/antagonist/ninja
	id = MODE_NINJA
	role_text = "Operative"
	role_text_plural = "Operatives"
	landmark_id = "ninjastart"
	welcome_text = "<span class='info'>You are an elite operative of some interest group. You have a variety of abilities at your disposal, thanks to your advanced hardsuit.</span>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_RANDSPAWN | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudninja"
	initial_spawn_req = 1
	initial_spawn_target = 2
	hard_cap = 2
	hard_cap_round = 3
	min_player_age = 18
	id_type = /obj/item/card/id/syndicate
	faction = "ninja"
	no_prior_faction = TRUE
	base_to_load = /singleton/map_template/ruin/antag_spawn/ninja


/datum/antagonist/ninja/create_objectives(datum/mind/ninja)
	if (!..())
		return
	var/objective_list = list(1, 2, 3, 4, 5)
	for (var/i = rand(2, 4) to 1 step -1)
		switch (pick(objective_list))
			if (1) //Kill
				var/datum/objective/assassinate/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if (ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
				objective_list -= 1
			if (2) //Steal
				var/datum/objective/steal/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				ninja.objectives += ninja_objective
			if (3) //Protect
				var/datum/objective/protect/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if (ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 3
			if (4) //Download
				var/datum/objective/download/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.gen_amount_goal()
				ninja.objectives += ninja_objective
				objective_list -= 4
			if (5) //Harm
				var/datum/objective/harm/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if (ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 5
	var/datum/objective/survive/ninja_objective = new
	ninja_objective.owner = ninja
	ninja.objectives += ninja_objective


/datum/antagonist/ninja/greet(datum/mind/player)
	if (!..())
		return 0
	var/directive = generate_ninja_directive("heel")
	player.StoreMemory("<B>Directive:</B> [SPAN_DANGER("[directive]")]<br>", /singleton/memory_options/system)
	to_chat(player, "<b>Remember your directive:</b> [directive].")


/datum/antagonist/ninja/equip(mob/living/carbon/human/player)
	. = ..()
	if (!.)
		return
	var/obj/item/device/radio/radio = new /obj/item/device/radio/headset/syndicate(player)
	player.equip_to_slot_or_del(radio, slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(player), slot_w_uniform)
	create_id("Operative", player)
	var/obj/item/modular_computer/pda/syndicate/pda = new
	player.put_in_hands(pda)
	var/singleton/uplink_source/uplink_source = GET_SINGLETON(/singleton/uplink_source/pda)
	uplink_source.setup_uplink_source(player, 0)
	var/obj/item/selection/ninja/selection = new
	player.put_in_hands(selection)


/datum/antagonist/ninja/equip_vox(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	vox.equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_casual(vox), slot_w_uniform)
	vox.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(vox), slot_shoes)
	vox.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(vox), slot_gloves)
	vox.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vox(vox), slot_wear_mask)
	vox.equip_to_slot_or_del(new /obj/item/tank/nitrogen(vox), slot_back)
	vox.put_in_hands(locate(/obj/item/modular_computer/pda/syndicate) in old.contents)
	vox.set_internals(locate(/obj/item/tank) in vox.contents)


/datum/antagonist/ninja/proc/generate_ninja_directive(side)
	var/directive = "[side=="face"?"[GLOB.using_map.company_name]":"A criminal syndicate"] is your employer. "
	switch (rand(1, 19))
		if (1)
			directive += "Your interest group must not be linked to this operation. Remain hidden and covert when possible."
		if (2)
			directive += "[GLOB.using_map.station_name] is financed by an enemy of your interest group. Cause as much structural damage as desired."
		if (3)
			directive += "A wealthy animal rights activist has made a request we cannot refuse. Prioritize saving animal lives whenever possible."
		if (4)
			directive += "Your interest group absolutely cannot be linked to this operation. Eliminate witnesses at your discretion."
		if (5)
			directive += "We are currently negotiating with [GLOB.using_map.company_name] [GLOB.using_map.boss_name]. Prioritize saving human lives over ending them."
		if (6)
			directive += "We are engaged in a legal dispute over [GLOB.using_map.station_name]. If a laywer is present on board, force their cooperation in the matter."
		if (7)
			directive += "A financial backer has made an offer we cannot refuse. Implicate criminal involvement in the operation."
		if (8)
			directive += "Let no one question the mercy of your interest group. Ensure the safety of all non-essential personnel you encounter."
		if (9)
			directive += "A free agent has proposed a lucrative business deal. Implicate [GLOB.using_map.company_name] involvement in the operation."
		if (10)
			directive += "Our reputation is on the line. Harm as few civilians and innocents as possible."
		if (11)
			directive += "Our honor is on the line. Utilize only honorable tactics when dealing with opponents."
		if (12)
			directive += "We are currently negotiating with a mercenary leader. Disguise assassinations as suicide or other natural causes."
		if (13)
			directive += "Some disgruntled [GLOB.using_map.company_name] employees have been supportive of our operations. Be wary of any mistreatment by command staff."
		if (14)
			var/xenorace = pick(SPECIES_UNATHI, SPECIES_SKRELL)
			directive += "A group of [xenorace] radicals have been loyal supporters of your interest group. Favor [xenorace] crew whenever possible."
		if (15)
			directive += "Your interest group has recently been accused of religious insensitivity. Attempt to speak with the Chaplain and prove these accusations false."
		if (16)
			directive += "Your interest group has been bargaining with a competing prosthetics manufacturer. Try to shine [GLOB.using_map.company_name] prosthetics in a bad light."
		if (17)
			directive += "Your interest group has recently begun recruiting outsiders. Consider suitable candidates and assess their behavior amongst the crew."
		if (18)
			directive += "A cyborg liberation group has expressed interest in our serves. Prove your interest group is merciful towards law-bound synthetics."
		else
			directive += "There are no special supplemental instructions at this time."
	return directive


/obj/item/selection/ninja
	name = "loadout selection kit"
	desc = "A secure box containing standard operation kit for special forces operatives."
	selection_options = list(
		"Solar Special Operations" = /obj/structure/closet/crate/ninja/sol,
		"Gilgameshi Commando" = /obj/structure/closet/crate/ninja/gcc,
		"Syndicate Mercenary" = /obj/structure/closet/crate/ninja/merc,
		"Corporate Operative" = /obj/structure/closet/crate/ninja/corpo,
		"Spider-Clan Ninja" = /obj/structure/closet/crate/ninja
	)
