var/datum/antagonist/deathsquad/deathsquad

/datum/antagonist/deathsquad
	id = MODE_DEATHSQUAD
	role_text = "Death Commando"
	role_text_plural = "Death Commandos"
	welcome_text = "You work in the service of Central Command Asset Protection, answering directly to the Board of Directors."
	landmark_id = "Commando"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE
	max_antags = 4
	max_antags_round = 6

	var/deployed = 0

/datum/antagonist/deathsquad/proc/create_id(var/assignment, var/mob/living/carbon/human/player)

	var/obj/item/weapon/card/id/W = new(player)
	W.name = "[player.real_name]'s ID Card"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	W.assignment = "[assignment]"
	W.registered_name = player.real_name
	player.equip_to_slot_or_del(W, slot_wear_id)

/datum/antagonist/deathsquad/New(var/no_reference)
	..()
	if(!no_reference)
		deathsquad = src

/datum/antagonist/deathsquad/attempt_spawn()
	if(..())
		deployed = 1

/datum/antagonist/deathsquad/equip(var/mob/living/carbon/human/player)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(player), slot_w_uniform)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(player), slot_w_uniform)
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(player)
	R.set_frequency(DTH_FREQ)
	player.equip_to_slot_or_del(R, slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), slot_wear_mask)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(player), slot_l_store)
		player.equip_to_slot_or_del(new /obj/item/weapon/disk/nuclear(player), slot_r_store)
	else
		player.equip_to_slot_or_del(new /obj/item/weapon/plastique(player), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/mateba(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(player), slot_r_hand)
	player.equip_to_slot_or_del(new /obj/item/weapon/rig/combat(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_s_store)
	player.implant_loyalty(player)
	create_id("Asset Protection", player)
	return

/datum/antagonist/deathsquad/apply(var/datum/mind/player)

	..()

	//var/syndicate_commando_leader_rank = pick("Lieutenant", "Captain", "Major")
	var/syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	var/syndicate_commando_name = pick(last_names)

	var/datum/preferences/A = new()//Randomize appearance for the commando.
	A.randomize_appearance_for(player.current)

	player.name = "[syndicate_commando_rank] [syndicate_commando_name]"
	player.current.name = player.name
	player.current.real_name = player.current.name

	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.gender = pick(MALE, FEMALE)
		H.age = rand(25,45)
		H.dna.ready_dna(H)

	return