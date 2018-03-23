var/datum/antagonist/hunter/hunters

/datum/antagonist/hunter
	id = MODE_HUNTER
	role_text = "Hunter"
	role_text_plural = "Hunters"
	flags = ANTAG_HAS_LEADER | ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE | ANTAG_CLEAR_EQUIPMENT
	leader_welcome_text = "You are the Huntmaster, a gyne female of the Kharmaan Ascent, and you command a band of alate Hunters - \
	your sons. Your task is to rid this sector of the crawling mammalian primitives that infect it. Guide and command your children, \
	and bring glory to your nest-lineage."
	welcome_text = "You are a Hunter, an alate male of the Kharmaan Ascent, tasked with ridding this sector of the crawling mammalian \
	primitives that infect it. Glory to the Ascent."
	leader_welcome_text
	antaghud_indicator = "hudhunter"
	antag_indicator = "hudhunter"
	hard_cap = 5
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	var/gyne_count = 0
	var/alate_count = 0

/datum/antagonist/hunter/New(var/no_reference)
	..()
	if(!no_reference)
		hunters = src

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
	if(ishuman(player.current))
		var/mob/living/carbon/human/H = player.current
		if(!leader)
			leader = player
			if(H.species.get_bodytype() != "Mantid Gyne")
				H.set_species("Mantid Gyne")
				H.real_name = H.species.get_random_name()
				H.name = H.real_name
			gyne_count++
			welcome_text = "You are an alate male, a Hunter of the Kharmaan Ascent, and you are tasked with ridding \
			this sector of the primitives that infect it. Serve your mother-gyne, [H.real_name], and bring glory to your nest-lineage."
		else
			if(H.species.get_bodytype() != "Mantid Alate")
				H.set_species("Mantid Alate")
				H.real_name = H.species.get_random_name()
				H.name = H.real_name
			alate_count++
		H.add_language(LANGUAGE_MANTID_VOCAL)
		H.add_language(LANGUAGE_MANTID_BROADCAST)

/datum/antagonist/hunter/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		var/obj/item/weapon/rig/rig
		if(player.species.get_bodytype(player) == SPECIES_MANTID_ALATE)
			rig = new /obj/item/weapon/rig/mantid/equipped(get_turf(player))
		else
			rig = new /obj/item/weapon/rig/mantid/gyne/equipped(get_turf(player))

		rig.seal_delay = 0
		player.put_in_hands(rig)
		player.equip_to_slot_or_del(rig,slot_back)
		if(rig)
			rig.toggle_seals(player,1)
			rig.seal_delay = initial(rig.seal_delay)

		if(player.back == rig && rig.air_supply)
			player.internal = rig.air_supply
			spawn(10)
				if(player.internal)
					player.internals.icon_state = "internal1"

		player.put_in_hands(new /obj/item/weapon/gun/energy/particle)