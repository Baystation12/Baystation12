/obj/structure/bed/chair/rounded
	name = "rounded chair"
	desc = "It's a rounded chair. It looks comfy."
	icon = 'mods/fancy_sofas/icons/furniture.dmi'
	icon_state = "roundedchair_preview"
	base_icon = "roundedchair"

/obj/structure/bed/chair/rounded/hard/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, padding_material)

/obj/structure/bed/chair/rounded/brown/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_LEATHER_GENERIC)

/obj/structure/bed/chair/rounded/red/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_CARPET)

/obj/structure/bed/chair/rounded/teal/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "teal")

/obj/structure/bed/chair/rounded/black/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "black")

/obj/structure/bed/chair/rounded/green/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "green")

/obj/structure/bed/chair/rounded/purple/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "purple")

/obj/structure/bed/chair/rounded/blue/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "blue")

/obj/structure/bed/chair/rounded/beige/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "beige")

/obj/structure/bed/chair/rounded/lime/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "lime")

/obj/structure/bed/chair/rounded/yellow/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "yellow")

/obj/structure/bed/chair/rounded/light/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_CLOTH)

//SOFA RECIPE
/datum/stack_recipe/furniture/chair/rounded
	title = "rounded chair"
	result_type = /obj/structure/bed/chair/rounded
	time = 10

/datum/stack_recipe/furniture/chair/rounded/display_name()
	return modifiers ? jointext(modifiers + ..(), " ") : ..()

/datum/stack_recipe/furniture/chair/rounded
	title = "rounded chair"
	req_amount = 3

#define ROUNDEDCHAIR(color) /datum/stack_recipe/furniture/chair/rounded/##color{\
	result_type = /obj/structure/bed/chair/rounded/##color;\
	modifiers = list(#color)\
	}
ROUNDEDCHAIR(beige)
ROUNDEDCHAIR(black)
ROUNDEDCHAIR(brown)
ROUNDEDCHAIR(blue)
ROUNDEDCHAIR(lime)
ROUNDEDCHAIR(teal)
ROUNDEDCHAIR(red)
ROUNDEDCHAIR(purple)
ROUNDEDCHAIR(green)
ROUNDEDCHAIR(yellow)
ROUNDEDCHAIR(light)
#undef ROUNDEDCHAIR
