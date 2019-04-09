/decl/hierarchy/outfit/job/science
	hierarchy_type = /decl/hierarchy/outfit/job/science
	l_ear = /obj/item/device/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science

/decl/hierarchy/outfit/job/science/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/science/rd
	name = OUTFIT_JOB_NAME("Chief Science Officer")
	l_ear = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/weapon/material/clipboard
	id_type = /obj/item/weapon/card/id/science/head
	pda_type = /obj/item/modular_computer/pda/heads/rd

/decl/hierarchy/outfit/job/science/scientist
	name = OUTFIT_JOB_NAME("Scientist")
	uniform = /obj/item/clothing/under/rank/scientist
	id_type = /obj/item/weapon/card/id/science
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science

/decl/hierarchy/outfit/job/science/xenobiologist
	name = OUTFIT_JOB_NAME("Xenobiologist")
	uniform = /obj/item/clothing/under/rank/scientist
	id_type = /obj/item/weapon/card/id/science/xenobiologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science

/decl/hierarchy/outfit/job/science/roboticist
	name = OUTFIT_JOB_NAME("Roboticist")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/weapon/storage/belt/utility/full
	id_type = /obj/item/weapon/card/id/science/roboticist
	pda_slot = slot_r_store
	pda_type = /obj/item/modular_computer/pda/roboticist

/decl/hierarchy/outfit/job/science/roboticist/New()
	..()
	backpack_overrides.Cut()
