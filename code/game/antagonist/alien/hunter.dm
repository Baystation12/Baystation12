GLOBAL_DATUM_INIT(hunters, /datum/antagonist/hunter, new)

/datum/antagonist/hunter
	id = MODE_HUNTER
	role_text = "Hunter"
	role_text_plural = "Hunters"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE | ANTAG_CLEAR_EQUIPMENT
	welcome_text = "You are a Hunter, an alate male of the Kharmaan Ascent, tasked with ridding this sector of the crawling mammalian \
	primitives that infect it. Glory to the Ascent."
	leader_welcome_text
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 5
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6
	valid_species = list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_NABBER_MONARCH)

	var/list/soldier_species = list(SPECIES_MANTID_ALATE, SPECIES_NABBER_MONARCH)
	var/soldier_count = 0

	var/list/queen_species = list(SPECIES_MANTID_GYNE, SPECIES_NABBER_MONARCH)
	var/queen_count = 0

/datum/antagonist/hunter/New(var/no_reference)
	..()
	if(!no_reference)
		GLOB.hunters = src

/datum/antagonist/hunter/create_global_objectives(var/override=0)
	. = ..()
	if(.)
		global_objectives += new /datum/objective/hunter_flood
		global_objectives += new /datum/objective/hunter_depower
		global_objectives += new /datum/objective/hunter_purge
		global_objectives += new /datum/objective/hunter_preserve_gyne
		global_objectives += new /datum/objective/hunter_preserve_alates

/datum/antagonist/hunter/update_antag_mob(var/datum/mind/player, var/preserve_appearance)
	. = ..()
	var/mob/living/carbon/human/H = player.current
	if(istype(player.current))
		H.set_species(pick(soldier_species))
		H.real_name = H.species.get_random_name()
		H.name = H.real_name
		switch(H.species.name)
			if(SPECIES_MANTID_ALATE)
				welcome_text = "You are a Kharmaani alate, a Hunter working for the Ascent, and you are tasked with serving and obeying your queen-commander. Bring glory to your nest-lineage."
			if(SPECIES_NABBER_MONARCH)
				welcome_text = "You are a Monarch Serpentid warrior, a Hunter working for the Ascent, and you are tasked with serving and obeying your queen-commander to the best of your ability."
		soldier_count++

/datum/antagonist/hunter/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(. && istype(player))
		var/obj/item/weapon/rig/rig
		switch(player.species.name)
			if(SPECIES_NABBER_MONARCH) rig = new /obj/item/weapon/rig/mantid/nabber/equipped(get_turf(player))
			if(SPECIES_MANTID_ALATE)      rig = new /obj/item/weapon/rig/mantid/equipped(get_turf(player))
			if(SPECIES_MANTID_GYNE)       rig = new /obj/item/weapon/rig/mantid/gyne/equipped(get_turf(player))
		if(rig)
			rig.seal_delay = 0
			player.put_in_hands(rig)
			player.equip_to_slot_or_del(rig,slot_back)
			if(rig)
				rig.toggle_seals(player,1)
				rig.seal_delay = initial(rig.seal_delay)
			player.set_internals_in(1 SECOND)
			player.put_in_hands(new /obj/item/weapon/gun/energy/particle)

/datum/antagonist/hunter/proc/handle_crew_change_request(var/mob/living/carbon/human/player, var/obj/console)
	player.forceMove(console)
	console.visible_message("<span class='notice'>\The [player.real_name] climbs into \the [console].</span>")
	var/choice = input("Select a soldier type to become.", "Hunter") as null|anything in list(soldier_species)
	if(!choice || player.loc != console) return
	player.set_species(choice)
	player.real_name = player.species.get_random_name()
	player.name = player.real_name
	switch(player.species.name)
		if(SPECIES_MANTID_ALATE)
			to_chat(player, "You are a Kharmaani alate, a Hunter working for the Ascent, and you are tasked with serving and obeying your queen-commander. Bring glory to your nest-lineage.")
		if(SPECIES_NABBER_MONARCH)
			to_chat(player, "You are a Monarch Serpentid warrior, a Hunter working for the Ascent, and you are tasked with serving and obeying your queen-commander to the best of your ability.")
	console.visible_message("<span class='notice'>\The [player.real_name] emerges from \the [console].</span>")
	player.forceMove(get_turf(console))

/datum/antagonist/hunter/proc/handle_leader_request(var/mob/living/carbon/human/player)
	if(leader)
		to_chat(player, "<span class='warning'>This mission already has a leader.</span>")
		return
	var/choice = input("Select a leader type to become.", "Huntmaster") as null|anything in list(queen_species)+"Master Control System"
	if(!choice || !player.mind) return
	if(leader)
		to_chat(player, "<span class='warning'>This mission already has a leader.</span>")
		return
	leader = player.mind

	var/leader_message
	if(choice == "Master Control System")
		var/mob/holder = player
		var/mob/living/silicon/robot/master_controller = new(get_turf(player))
		player.mind.current = master_controller
		player.mind.transfer_to(master_controller)
		if(holder) qdel(holder)
		master_controller.mind.original = master_controller
		to_chat(master_controller, "You are the Master Controller of an Ascent warship, tasked with transporting and coordinating a band of Hunters as they complete their mission. Guide and advise them as best you can, as it will be quite difficult to get home without a crew.")
		leader_message = "<span class='alium'>Your leader is the <b>Master Control System, [master_controller]</b>. Serve and obey it to the best of your ability.</span>"
	else
		player.set_species(choice)
		player.real_name = player.species.get_random_name()
		player.name = player.real_name
		player.gender = FEMALE
		player.update_body()

		switch(player.species.name)
			if(SPECIES_MANTID_GYNE)
				to_chat(player, "You are the Huntmaster, a Kharmaani gyne of the Ascent, and you command a band of Hunters - your progeny and that of your allies. Guide and command your brood, and bring prestige and power to your nest-lineage.")
				leader_message = "<span class='alium'>Your leader is the <b>Kharmaani Gyne, [player.real_name]</b>. Serve and obey her to the best of your ability.</span>"
			if(SPECIES_NABBER_MONARCH)
				to_chat(player, "You are the Huntmaster, a Monarch Serpentid queen of the Ascent, and you command a band of Hunters - your cousins and the progeny of your allies. Guide and command your minions, and bring prestige and power to your family and your allies.")
				leader_message = "<span class='alium'>Your leader is the <b>Monarch Serpentid Queen, [player.real_name]</b>. Serve and obey her to the best of your ability.</span>"

	if(player.species.name == SPECIES_MANTID_GYNE)
		for(var/datum/mind/minion in current_antagonists)
			var/mob/living/carbon/human/H = minion.current
			if(istype(H) && H.species == SPECIES_MANTID_ALATE)
				H.real_name = H.species.get_random_name()
				H.name = H.real_name
				to_chat(H, "<span class='alium'>As you are an alate, your name has been updated to reflect your mother-gyne. You are now identified as <b>[H.real_name]</b>.</span>")

	for(var/datum/mind/minion in current_antagonists)
		to_chat(minion, leader_message)
