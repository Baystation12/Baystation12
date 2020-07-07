
/obj/item/modular_computer/console/preset/research
	name = "Research Computer"

/obj/item/modular_computer/console/preset/research/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/experimental_analyzer())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("exp_analyzer")


/obj/item/modular_computer/console/preset/research/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/modular_computer/console/preset/research/LateInitialize()
	. = ..()

	//a new research database with default starting techs
	hard_drive.store_file(new/datum/computer_file/research_db(TRUE))
