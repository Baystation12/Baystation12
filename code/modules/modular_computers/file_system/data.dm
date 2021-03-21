// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data
	var/stored_data = "" 			// Stored data in string format.
	filetype = "DAT"
	var/block_size = 2000			// Turns out, text is small.
	var/do_not_edit = 0				// Whether the user will be reminded that the file probably shouldn't be edited.
	var/read_only = 0				// Protects files that should never be edited by the user due to special properties.

/datum/computer_file/data/clone()
	var/datum/computer_file/data/temp = ..()
	temp.stored_data = stored_data
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/proc/generate_file_data(var/mob/user)
	return digitalPencode2html(stored_data)

/datum/computer_file/data/logfile
	filetype = "LOG"

/datum/computer_file/data/text
	filetype = "TXT"

/datum/computer_file/data/bodyscan
	filetype = "BSC"
	read_only = 1
	papertype = /obj/item/paper/bodyscan

/datum/computer_file/data/bodyscan/generate_file_data(var/mob/user)
	return display_medical_data(metadata, user.get_skill_value(SKILL_MEDICAL), TRUE)

/// Mapping tool - creates a named modular computer file in a computer's storage on late initialize.
/// Use this to do things like automatic records and blackboxes. Alternative for paper records.
/// Values can be in the editor for each map or as a subtype.
/// This is an obj because raw atoms can't be placed in DM or third-party mapping tools.
/obj/effect/computer_file_creator
	name = "computer file creator"
	desc = "This is a mapping tool used for installing text files onto a modular device when it's mapped on top of them. If you see it, it's bugged."
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x3"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 101
	var/file_name = "helloworld" // The name that the file will have once it's created
	var/file_info = "Hello World!" // The contents of this file. Uses paper formatting.

/obj/effect/computer_file_creator/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/computer_file_creator/LateInitialize()
	var/turf/T = get_turf(src)
	for (var/obj/O in T)
		if (!istype(O, /obj/machinery/computer/modular) && !istype(O, /obj/item/modular_computer))
			continue
		var/datum/extension/interactive/ntos/os = get_extension(O, /datum/extension/interactive/ntos)
		if (os)
			os.save_file(file_name, file_info, /datum/computer_file/data/text)
	qdel(src)
