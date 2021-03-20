//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

var/list/default_material_composition = list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_PLASTIC = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_PHORON = 0, MATERIAL_URANIUM = 0, MATERIAL_DIAMOND = 0)
/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	uncreated_component_parts = null
	stat_immune = 0
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()

/obj/machinery/r_n_d/dismantle()
	for(var/obj/I in src)
		if(istype(I, /obj/item/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] >= SHEET_MATERIAL_AMOUNT)
			new /obj/item/stack/material(loc, round(materials[f] / SHEET_MATERIAL_AMOUNT), f)
	return ..()


/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/material/mat = SSmaterials.get_material_by_name(material)
	var/eject = Clamp(round(materials[material] / mat.units_per_sheet), 0, amount)
	if(eject > 0)
		mat.place_sheet(loc, eject)
		materials[material] -= eject * mat.units_per_sheet

/obj/machinery/r_n_d/proc/TotalMaterials()
	for(var/f in materials)
		. += materials[f]

/obj/machinery/r_n_d/proc/getLackingMaterials(var/datum/design/D)
	var/list/ret = list()
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			ret += C
	return english_list(ret)
