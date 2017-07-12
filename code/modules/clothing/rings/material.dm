/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"
	var/material/material

/obj/item/clothing/ring/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ring/material/get_material()
	return material

/obj/item/clothing/ring/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/ring/material/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/clothing/ring/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/ring/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/ring/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/ring/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/ring/material/bronze/New(var/newloc)
	..(newloc, "bronze")

/obj/item/clothing/ring/material/glass/New(var/newloc)
	..(newloc, "glass")
