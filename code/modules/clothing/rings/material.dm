/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/obj_hands_ring.dmi'
	icon_state = "material"
	var/material/material

/obj/item/clothing/ring/material/Initialize(mapload, var/new_material)
	. = ..(mapload)
	if(!new_material)
		new_material = MATERIAL_STEEL
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)

		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			desc = "A ring made from [material.display_name]."
			to_chat(user, "<span class='warning'>You carve \"[inscription]\" into \the [src].</span>")
			desc += "<br>Written on \the [src] is the inscription \"[inscription]\""

/obj/item/clothing/ring/material/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/carbon/human/H = get_holder_of_type(src, /mob/living/carbon/human)
			if(H.Adjacent(user))
				user.examinate(src)
				return TOPIC_HANDLED

/obj/item/clothing/ring/material/get_examine_line()
	. = ..()
	. += " <a href='?src=\ref[src];examine=1'>\[View\]</a>"

/obj/item/clothing/ring/material/get_material()
	return material

/obj/item/clothing/ring/material/wood/Initialize(mapload)
	. = ..(mapload,  MATERIAL_WALNUT)

/obj/item/clothing/ring/material/plastic/Initialize(mapload)
	. = ..(mapload,  MATERIAL_PLASTIC)

/obj/item/clothing/ring/material/steel/Initialize(mapload)
	. = ..(mapload,  MATERIAL_STEEL)

/obj/item/clothing/ring/material/silver/Initialize(mapload)
	. = ..(mapload,  MATERIAL_SILVER)

/obj/item/clothing/ring/material/gold/Initialize(mapload)
	. = ..(mapload,  MATERIAL_GOLD)

/obj/item/clothing/ring/material/platinum/Initialize(mapload)
	. = ..(mapload,  MATERIAL_PLATINUM)

/obj/item/clothing/ring/material/bronze/Initialize(mapload)
	. = ..(mapload,  MATERIAL_BRONZE)

/obj/item/clothing/ring/material/glass/Initialize(mapload)
	. = ..(mapload,  MATERIAL_GLASS)
