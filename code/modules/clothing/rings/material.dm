/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/obj_hands_ring.dmi'
	icon_state = "material"
	var/material/material

/obj/item/clothing/ring/material/New(newloc, new_material)
	..(newloc)
	if(!new_material)
		new_material = MATERIAL_STEEL
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ring/material/use_tool(obj/item/S, mob/living/user, list/click_params)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)

		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return TRUE
			desc = "A ring made from [material.display_name]."
			to_chat(user, SPAN_WARNING("You carve \"[inscription]\" into \the [src]."))
			desc += "<br>Written on \the [src] is the inscription \"[inscription]\""
			return TRUE
	return ..()

/obj/item/clothing/ring/material/OnTopic(mob/user, list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/carbon/human/H = get_holder_of_type(src, /mob/living/carbon/human)
			if(H.Adjacent(user))
				examinate(user, src)
				return TOPIC_HANDLED

/obj/item/clothing/ring/material/get_examine_line()
	. = ..()
	. += " <a href='?src=\ref[src];examine=1'>\[View\]</a>"

/obj/item/clothing/ring/material/get_material()
	return material

/obj/item/clothing/ring/material/wood/New(newloc)
	..(newloc, MATERIAL_WALNUT)

/obj/item/clothing/ring/material/plastic/New(newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/item/clothing/ring/material/steel/New(newloc)
	..(newloc, MATERIAL_STEEL)

/obj/item/clothing/ring/material/plasteel/New(newloc)
	..(newloc, MATERIAL_PLASTEEL)

/obj/item/clothing/ring/material/silver/New(newloc)
	..(newloc, MATERIAL_SILVER)

/obj/item/clothing/ring/material/gold/New(newloc)
	..(newloc, MATERIAL_GOLD)

/obj/item/clothing/ring/material/platinum/New(newloc)
	..(newloc, MATERIAL_PLATINUM)

/obj/item/clothing/ring/material/bronze/New(newloc)
	..(newloc, MATERIAL_BRONZE)

/obj/item/clothing/ring/material/glass/New(newloc)
	..(newloc, MATERIAL_GLASS)
