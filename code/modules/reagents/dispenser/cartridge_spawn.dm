/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"), reagent in chemical_reagents_list)
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C
	switch(size)
		if("small") C = new /obj/item/weapon/reagent_containers/chem_disp_cartridge/small(usr.loc)
		if("medium") C = new /obj/item/weapon/reagent_containers/chem_disp_cartridge/medium(usr.loc)
		if("large") C = new /obj/item/weapon/reagent_containers/chem_disp_cartridge(usr.loc)
	C.reagents.add_reagent(reagent, C.volume)
	var/datum/reagent/R = chemical_reagents_list[reagent]
	C.setLabel(R.name)
	log_admin("[key_name(usr)] spawned a [size] reagent container containing [reagent] at ([usr.x],[usr.y],[usr.z])")
