

/decl/hierarchy/outfit/job/unsc_achlys/CO
	name = "Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/SL
	name = "Squad Leader"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/marine
	name = "Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/coin/gear_req
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/marine/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Marine"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/unsc_achlys/pilot
	name = "Pilot"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_achlys/prisoner
	name = "Prisoner"

	l_ear = null
	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange
	pda_slot = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/unsc_anchlys/sangheili
	name = "Sangheili Prisoner"

	l_ear = null
	uniform = null
	suit = null
	back = null
	gloves = null
	head = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job
