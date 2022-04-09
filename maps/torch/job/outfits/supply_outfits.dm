/decl/hierarchy/outfit/job/torch/crew/supply
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/supply

/decl/hierarchy/outfit/job/torch/crew/supply/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer
	name = OUTFIT_JOB_NAME("Deck Chief")
	l_ear = /obj/item/device/radio/headset/headset_deckofficer
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/supply/deckofficer)
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet
	name = OUTFIT_JOB_NAME("Deck Chief - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/tech
	name = OUTFIT_JOB_NAME("Deck Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/supply)
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet
	name = OUTFIT_JOB_NAME("Deck Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/contractor
	name = OUTFIT_JOB_NAME("Supply Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	id_types = list(/obj/item/card/id/torch/contractor/supply)
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/torch/passenger/research/prospector
	name = OUTFIT_JOB_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/ntwork
	shoes = /obj/item/clothing/shoes/workboots
	id_types = list(/obj/item/card/id/torch/passenger/research/mining)
	pda_type = /obj/item/modular_computer/pda/mining
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL
	l_ear = /obj/item/device/radio/headset/headset_mining

/decl/hierarchy/outfit/job/torch/passenger/research/prospector/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING
