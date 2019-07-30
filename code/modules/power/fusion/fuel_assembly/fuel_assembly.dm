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
	var/initial_amount

/obj/item/weapon/fuel_assembly/New(var/newloc, var/_material, var/_colour)
	fuel_type = _material
	fuel_colour = _colour
	..(newloc)

/obj/item/weapon/fuel_assembly/Initialize()
	. = ..()

	if(ispath(fuel_type, /datum/reagent))
		var/datum/reagent/R = fuel_type
		fuel_type = lowertext(initial(R.name))
		fuel_colour = initial(R.color)
		initial_amount = 50000

	var/material/material = SSmaterials.get_material_by_name(fuel_type)
	if(istype(material))
		initial_amount = material.units_per_sheet * 5 // Fuel compressor eats 5 sheets.
		SetName("[material.use_name] fuel rod assembly")
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.use_name
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			START_PROCESSING(SSobj, src)
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		SetName("[fuel_type] fuel rod assembly")
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = fuel_colour
	overlays += list(I, image(icon, "fuel_assembly_bracket"))
	rod_quantities[fuel_type] = initial_amount

/obj/item/weapon/fuel_assembly/Process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		SSradiation.radiate(src, max(1,ceil(radioactivity/15)))

/obj/item/weapon/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Mapper shorthand.
/obj/item/weapon/fuel_assembly/deuterium/New(var/newloc)
	..(newloc, MATERIAL_DEUTERIUM)

/obj/item/weapon/fuel_assembly/tritium/New(var/newloc)
	..(newloc, MATERIAL_TRITIUM)

/obj/item/weapon/fuel_assembly/phoron/New(var/newloc)
	..(newloc, MATERIAL_PHORON)

/obj/item/weapon/fuel_assembly/supermatter/New(var/newloc)
	..(newloc, MATERIAL_SUPERMATTER)

/obj/item/weapon/fuel_assembly/hydrogen/New(var/newloc)
	..(newloc, MATERIAL_HYDROGEN)