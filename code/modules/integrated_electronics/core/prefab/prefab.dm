/singleton/prefab/proc/create(atom/location)
	if (!location)
		CRASH("Invalid location supplied: [log_info_line(location)]")
	return TRUE

/singleton/prefab/ic_assembly
	var/assembly_name
	var/data
	var/power_cell_type

/singleton/prefab/ic_assembly/create(atom/location)
	if (..())
		var/result = SScircuit.validate_electronic_assembly(data)
		if (istext(result))
			CRASH("Invalid prefab [type]: [result]")
		else
			var/obj/item/device/electronic_assembly/assembly = SScircuit.load_electronic_assembly(location, result)
			assembly.opened = FALSE
			assembly.update_icon()
			if (power_cell_type)
				var/obj/item/cell/cell = new power_cell_type(assembly)
				assembly.battery = cell

			return assembly
	return null

/obj/prefab
	name = "prefab spawn"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	var/prefab_type

/obj/prefab/Initialize()
	..()
	var/singleton/prefab/prefab = GET_SINGLETON(prefab_type)
	prefab.create(loc)
	return INITIALIZE_HINT_QDEL
