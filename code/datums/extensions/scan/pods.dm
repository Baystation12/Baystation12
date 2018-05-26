/datum/extension/scan/pod
	expected_type = /obj/machinery/cryopod

/datum/extension/scan/pod/GetContent(var/target_type)
	var/obj/machinery/cryopod/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()

/datum/extension/scan/pod/bodyscanner
	expected_type = /obj/machinery/bodyscanner

/datum/extension/scan/pod/bodyscanner/GetContent(var/target_type)
	var/obj/machinery/bodyscanner/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()

/datum/extension/scan/pod/sleeper
	expected_type = /obj/machinery/sleeper

/datum/extension/scan/pod/sleeper/GetContent(var/target_type)
	var/obj/machinery/sleeper/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()

/datum/extension/scan/pod/resleever
	expected_type = /obj/machinery/resleever

/datum/extension/scan/pod/resleever/GetContent(var/target_type)
	var/obj/machinery/resleever/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()

/datum/extension/scan/pod/cryocell
	expected_type = /obj/machinery/atmospherics/unary/cryo_cell

/datum/extension/scan/pod/cryocell/GetContent(var/target_type)
	var/obj/machinery/atmospherics/unary/cryo_cell/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()
