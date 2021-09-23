/obj/item/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = 2
	var/material/material
	var/datum/geosample/geologic_data

/obj/item/ore/get_material()
	return material

/obj/item/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/ore/New(var/newloc, var/_mat)
	if(_mat)
		matter = list()
		matter[_mat] = SHEET_MATERIAL_AMOUNT
	..(newloc)

/obj/item/ore/Initialize()
	for(var/stuff in matter)
		var/material/M = SSmaterials.get_material_by_name(stuff)
		if(M)
			name = M.ore_name
			desc = M.ore_desc ? M.ore_desc : "A lump of ore."
			material = M
			color = M.icon_colour
			icon_state = M.ore_icon_overlay
			if(M.ore_desc)
				desc = M.ore_desc
			if(icon_state == "dust")
				slot_flags = SLOT_HOLSTER
			break
	. = ..()

// POCKET SAND!
/obj/item/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			to_chat(H, SPAN_WARNING("Some of \the [src] gets in your eyes!"))
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/ore/uranium/New(var/newloc)
	..(newloc, MATERIAL_PITCHBLENDE)
/obj/item/ore/iron/New(var/newloc)
	..(newloc, MATERIAL_HEMATITE)
/obj/item/ore/coal/New(var/newloc)
	..(newloc, MATERIAL_GRAPHITE)
/obj/item/ore/glass/New(var/newloc)
	..(newloc, MATERIAL_SAND)
/obj/item/ore/silver/New(var/newloc)
	..(newloc, MATERIAL_SILVER)
/obj/item/ore/gold/New(var/newloc)
	..(newloc, MATERIAL_GOLD)
/obj/item/ore/diamond/New(var/newloc)
	..(newloc, MATERIAL_DIAMOND)
/obj/item/ore/osmium/New(var/newloc)
	..(newloc, MATERIAL_PLATINUM)
/obj/item/ore/hydrogen/New(var/newloc)
	..(newloc, MATERIAL_HYDROGEN)
/obj/item/ore/slag/New(var/newloc)
	..(newloc, MATERIAL_WASTE)
/obj/item/ore/phoron/New(var/newloc)
	..(newloc, MATERIAL_PHORON)
/obj/item/ore/aluminium/New(var/newloc)
	..(newloc, MATERIAL_BAUXITE)
/obj/item/ore/rutile/New(var/newloc)
	..(newloc, MATERIAL_RUTILE)
