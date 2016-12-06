/obj/item/weapon/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"
	layer = 4

	var/material/material
	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = "composite"
	var/const/initial_amount = 300

/obj/item/weapon/fuel_assembly/New(var/newloc, var/_material)
	material = get_material_by_name(_material)
	if(!material)
		qdel(src)
	..(newloc)

/obj/item/weapon/fuel_assembly/initialize()
	. = ..()
	name = "[material.use_name] fuel rod assembly"
	desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
	if(material.radioactivity)
		desc += " It is warm to the touch."
	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = material.icon_colour
	overlays += list(I, image(icon, "fuel_assembly_bracket"))
	fuel_type = material.use_name
	rod_quantities[fuel_type] = initial_amount
	if(material.luminescence)
		set_light(material.luminescence, material.luminescence, material.icon_colour)
	if(material.radioactivity)
		processing_objects += src

/obj/item/weapon/fuel_assembly/process()
	if(!material.radioactivity)
		processing_objects -= src
		return
	if(istype(loc, /turf))
		for(var/mob/living/L in range(1,loc))
			L.apply_effect(max(1,ceil(material.radioactivity/30)),IRRADIATE, blocked = L.getarmor(null, "rad"))

/obj/item/weapon/fuel_assembly/Destroy()
	material = null
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
