//Shouldn't be a lot in here, only torch versions of existing machines that need a different access req or something along those lines.

/obj/machinery/vending/medical/torch
	req_access = list()

/obj/machinery/drone_fabricator/torch
	fabricator_tag = "SEV Torch Maintenance"

/obj/machinery/drone_fabricator/torch/adv
	name = "advanced drone fabricator"
	fabricator_tag = "SFV Arrow Maintenance"
	drone_type = /mob/living/silicon/robot/drone/construction