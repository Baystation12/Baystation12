//Material earrings
/obj/item/clothing/ears/earring
	name = "earring"
	desc = "An earring of some kind."

/obj/item/clothing/ears/earring/stud
	name = "pearl stud earrings"
	desc = "A pair of small pearl stud earrings."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "ear_stud"
	color = "#EAE0C8"
	gender = PLURAL
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/ears/earring/stud/material
	var/material/material

/obj/item/clothing/ears/earring/stud/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] stud earrings"
	desc = "A pair of small stud earrings made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ears/earring/stud/material/get_material()
	return material

/obj/item/clothing/ears/earring/stud/material/glass/New(var/newloc)
	..(newloc, "glass")

/obj/item/clothing/ears/earring/stud/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/ears/earring/stud/material/iron/New(var/newloc)
	..(newloc, "iron")

/obj/item/clothing/ears/earring/stud/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/ears/earring/stud/material/plasteel/New(var/newloc)
	..(newloc, "plasteel")

/obj/item/clothing/ears/earring/stud/material/titanium/New(var/newloc)
	..(newloc, "titanium")

/obj/item/clothing/ears/earring/stud/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/ears/earring/stud/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/ears/earring/stud/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/ears/earring/stud/material/diamond/New(var/newloc)
	..(newloc, "diamond")

/obj/item/clothing/ears/earring/dangle/material
	name = "dangle earrings"
	desc = "Some sort of earring."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "ear_dangle"
	gender = PLURAL
	species_restricted = list(SPECIES_HUMAN)
	var/material/material

/obj/item/clothing/ears/earring/dangle/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] dangle earrings"
	desc = "A pair of dangle earrings made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ears/earring/dangle/material/get_material()
	return material

/obj/item/clothing/ears/earring/dangle/material/glass/New(var/newloc)
	..(newloc, "glass")

/obj/item/clothing/ears/earring/dangle/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/ears/earring/dangle/material/iron/New(var/newloc)
	..(newloc, "iron")

/obj/item/clothing/ears/earring/dangle/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/ears/earring/dangle/material/plasteel/New(var/newloc)
	..(newloc, "plasteel")

/obj/item/clothing/ears/earring/dangle/material/titanium/New(var/newloc)
	..(newloc, "titanium")

/obj/item/clothing/ears/earring/dangle/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/ears/earring/dangle/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/ears/earring/dangle/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/ears/earring/dangle/material/diamond/New(var/newloc)
	..(newloc, "diamond")
