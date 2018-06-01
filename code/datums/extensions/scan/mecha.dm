/datum/extension/scan/mecha
	expected_type = /obj/mecha

/datum/extension/scan/mecha/GetContent(var/target_type)
	var/obj/mecha/C = atom_holder
	if (C.occupant && istype(C.occupant, target_type))
		return list(C.occupant)
	return list()
