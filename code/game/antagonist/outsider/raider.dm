var/datum/antagonist/raider/raiders

/datum/antagonist/raider
	id = MODE_RAIDER
	role_type = BE_RAIDER
	role_text = "Raider"
	role_text_plural = "Raiders"
	bantype = "raider"
	landmark_id = "voxstart"
	welcome_text = "Use :0 to speak Galcom, :H to talk on your encrypted channel, and don't forget to turn on your nitrogen internals!"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE
	spawn_lower = 4
	spawn_upper = 6
	max_antags = 6
	max_antags_round = 10

	// Heist overrides check_victory() and doesn't need victory or loss strings/tags.
	var/spawn_tick = 1

/datum/antagonist/raider/New()
	..()
	raiders = src

/datum/antagonist/raider/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.age = rand(12,70)
	player.set_species("Vox")
	player.languages = list() // Removing language from chargen.
	player.flavor_text = ""
	player.add_language("Vox-pidgin")
	player.add_language("Galactic Common")
	player.add_language("Tradeband")

	var/datum/language/voxlang = all_languages["Vox-pidgin"]
	player.real_name = voxlang.get_random_name()
	player.name = player.real_name
	if(player.mind)
		player.mind.name = player.name
	player.h_style = "Short Vox Quills"
	player.f_style = "Shaved"

	for(var/datum/organ/external/limb in player.organs)
		limb.status &= ~(ORGAN_DESTROYED | ORGAN_ROBOT)

	player.regenerate_icons()

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(player)
	R.set_frequency(SYND_FREQ)
	player.equip_to_slot_or_del(R, slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_robes(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(player), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/vox(player), slot_gloves) // AS ABOVE.

	switch(spawn_tick)
		if(1) // Vox raider!
			player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/carapace(player), slot_wear_suit)
			player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/carapace(player), slot_head)
			player.equip_to_slot_or_del(new /obj/item/weapon/melee/baton/loaded(player), slot_belt)
			player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(player), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			player.equip_to_slot_or_del(new /obj/item/device/chameleon(player), slot_l_store)

			var/obj/item/weapon/gun/launcher/spikethrower/W = new(player)
			player.equip_to_slot_or_del(W, slot_r_hand)

		if(2) // Vox engineer!
			player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/pressure(player), slot_wear_suit)
			player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/pressure(player), slot_head)
			player.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(player), slot_belt)
			player.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(player), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/emps(player), slot_r_hand)
			player.equip_to_slot_or_del(new /obj/item/device/multitool(player), slot_l_hand)

		if(3) // Vox saboteur!
			player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/stealth(player), slot_wear_suit)
			player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/stealth(player), slot_head)
			player.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(player), slot_belt)
			player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(player), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			player.equip_to_slot_or_del(new /obj/item/weapon/card/emag(player), slot_l_store)
			player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/dartgun/vox/raider(player), slot_r_hand)
			player.equip_to_slot_or_del(new /obj/item/device/multitool(player), slot_l_hand)

		if(4) // Vox medic!
			player.equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/medic(player), slot_wear_suit)
			player.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/medic(player), slot_head)
			player.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(player), slot_belt) // Who needs actual surgical tools?
			player.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(player), slot_glasses) // REPLACE WITH CODED VOX ALTERNATIVE.
			player.equip_to_slot_or_del(new /obj/item/weapon/circular_saw(player), slot_l_store)
			player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/dartgun/vox/medical, slot_r_hand)

	player.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_r_store)

	var/obj/item/weapon/card/id/syndicate/C = new(player)
	C.name = "[player.real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(access_syndicate)
	C.assignment = "Trader"
	C.registered_name = player.real_name
	C.registered_user = player
	var/obj/item/weapon/storage/wallet/W = new(player)
	W.handle_item_insertion(C)
	spawn_money(rand(50,150)*10,W)
	player.equip_to_slot_or_del(W, slot_wear_id)
	spawn_tick++
	if (spawn_tick > 4) spawn_tick = 1

/datum/antagonist/raider/create_global_objectives()

	var/i = 1
	var/max_objectives = pick(2,2,2,2,3,3,3,4)
	global_objectives = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		global_objectives |= O

		i++

	//-All- vox raids have these two objectives. Failing them loses the game.
	global_objectives |= new /datum/objective/heist/inviolate_crew
	global_objectives |= new /datum/objective/heist/inviolate_death

/datum/antagonist/raider/check_victory()
	// Totally overrides the base proc.
	var/win_type = "Major"
	var/win_group = "Crew"
	var/win_msg = ""

	//No objectives, go straight to the feedback.
	if(config.objectives_disabled || !global_objectives.len)
		return

	var/success = global_objectives.len
	//Decrease success for failed objectives.
	for(var/datum/objective/O in global_objectives)
		if(!(O.check_completion())) success--
	//Set result by objectives.
	if(success == global_objectives.len)
		win_type = "Major"
		win_group = "Vox"
	else if(success > 2)
		win_type = "Minor"
		win_group = "Vox"
	else
		win_type = "Minor"
		win_group = "Crew"
	//Now we modify that result by the state of the vox crew.
	if(antags_are_dead())
		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have been wiped out!</B>"
	else if(is_raider_crew_safe())
		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have left someone behind!</B>"
	else
		if(win_group == "Vox")
			if(win_type == "Minor")
				win_type = "Major"
			win_msg += "<B>The Vox Raiders escaped the station!</B>"
		else
			win_msg += "<B>The Vox Raiders were repelled!</B>"

	world << "<span class='danger'><font size = 3>[win_type] [win_group] victory!</font>"
	world << "[win_msg]"
	feedback_set_details("round_end_result","heist - [win_type] [win_group]")

/datum/antagonist/raider/proc/is_raider_crew_safe()

	if(cortical_stacks.len == 0)
		return 0

	for(var/datum/organ/internal/stack/vox/stack in cortical_stacks)
		if(stack.organ_holder && get_area(stack.organ_holder) != locate(/area/shuttle/vox/station))
			return 0
	return 1