/decl/hierarchy/outfit/job/torch/passenger/research
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger/research
	l_ear = /obj/item/device/radio/headset/science

/decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot //pending better uniform
	name = OUTFIT_JOB_NAME("Corporate Pilot")
	uniform = /obj/item/clothing/under/rank/ntpilot
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_pilot
	id_types = list(/obj/item/card/id/torch/passenger/research/nt_pilot)

/decl/hierarchy/outfit/job/torch/passenger/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_types = list(/obj/item/card/id/torch/passenger/research/scientist)

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/torch/passenger/research/assist
	name = OUTFIT_JOB_NAME("Research Assistant - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_types = list(/obj/item/card/id/torch/passenger/research)

/decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject
	name = OUTFIT_JOB_NAME("Testing Assistant")
	uniform = /obj/item/clothing/under/rank/ntwork


/decl/hierarchy/outfit/job/torch/crew/command/synth
	name = OUTFIT_JOB_NAME("EXO Synthetic")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchexec/synth
	shoes = /obj/item/clothing/shoes/dutyboots
	head = /obj/item/clothing/head/beret/solgov/expedition/branch
	id_types = list(/obj/item/card/id/torch/gold/synth)
	pda_type = /obj/item/modular_computer/pda/heads
	r_pocket = /obj/item/modular_computer/tablet/lease/preset/command
