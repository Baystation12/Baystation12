/datum/computer_file/program/ship/sensors/vox
	nanomodule_path = /datum/nano_module/program/ship/sensors/vox
	available_on_ntnet = FALSE

/datum/nano_module/program/ship/sensors/vox
	print_language = LANGUAGE_VOX
	modify_access_req = null

/obj/machinery/computer/modular/preset/sensors/vox
	default_software = list(
		/datum/computer_file/program/ship/sensors/vox
	)
	autorun_program = /datum/computer_file/program/ship/sensors/vox
