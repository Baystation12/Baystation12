/datum/extension/scan/closet
	expected_type = /obj/structure/closet

/datum/extension/scan/closet/GetContent()
	var/obj/structure/closet/C = atom_holder
	
	if (!C.opened)
		return ..()
	return list()