/obj/item/weapon/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"
	layer = 4

	var/material_name

	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = "composite"
	var/fuel_colour
	var/radioactivity = 0
	var/const/initial_amount = 300

/obj/item/weapon/fuel_assembly/New(var/newloc, var/_material, var/_colour)
	fuel_type = _material
	fuel_colour = _colour
	..(newloc)

/obj/item/weapon/fuel_assembly/initialize()
	. = ..()
	var/material/material = get_material_by_name(fuel_type)
	if(istype(material))
		name = "[material.use_name] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.use_name
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			processing_objects += src
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		name = "[fuel_type] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = fuel_colour
	overlays += list(I, image(icon, "fuel_assembly_bracket"))
	rod_quantities[fuel_type] = initial_amount

/obj/item/weapon/fuel_assembly/process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		radiation_repository.radiate(src, max(1,ceil(radioactivity/30)))

/obj/item/weapon/fuel_assembly/Destroy()
	processing_objects -= src
	return ..()

// Mapper shorthand.
/obj/item/weapon/fuel_assembly/deuterium/New(var/newloc)
	..(newloc, "deuterium")

/obj/item/weapon/fuel_assembly/tritium/New(var/newloc)
	..(newloc, "tritium")

/obj/item/weapon/fuel_assembly/phoron/New(var/newloc)
	..(newloc, "phoron")

/obj/item/weapon/fuel_assembly/supermatter/New(var/newloc)
	..(newloc, "supermatter")
