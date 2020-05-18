/obj/item/weapon/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = 2
	var/material/material
	var/datum/geosample/geologic_data

/obj/item/weapon/ore/get_material()
	return material

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/weapon/ore/New(var/newloc, var/_mat)
	if(_mat)
		matter = list()
		matter[_mat] = SHEET_MATERIAL_AMOUNT
	..(newloc)

/obj/item/weapon/ore/Initialize()
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
/obj/item/weapon/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/weapon/ore/uranium/New(var/newloc)
	..(newloc, MATERIAL_PITCHBLENDE)
/obj/item/weapon/ore/iron/New(var/newloc)
	..(newloc, MATERIAL_HEMATITE)
/obj/item/weapon/ore/coal/New(var/newloc)
	..(newloc, MATERIAL_GRAPHITE)
/obj/item/weapon/ore/glass/New(var/newloc)
	..(newloc, MATERIAL_SAND)
/obj/item/weapon/ore/silver/New(var/newloc)
	..(newloc, MATERIAL_SILVER)
/obj/item/weapon/ore/gold/New(var/newloc)
	..(newloc, MATERIAL_GOLD)
/obj/item/weapon/ore/diamond/New(var/newloc)
	..(newloc, MATERIAL_DIAMOND)
/obj/item/weapon/ore/osmium/New(var/newloc)
	..(newloc, MATERIAL_PLATINUM)
/obj/item/weapon/ore/hydrogen/New(var/newloc)
	..(newloc, MATERIAL_HYDROGEN)
/obj/item/weapon/ore/slag/New(var/newloc)
	..(newloc, MATERIAL_WASTE)
/obj/item/weapon/ore/phoron/New(var/newloc)
	..(newloc, MATERIAL_PHORON)
/obj/item/weapon/ore/aluminium/New(var/newloc)
	..(newloc, MATERIAL_BAUXITE)
/obj/item/weapon/ore/rutile/New(var/newloc)
	..(newloc, MATERIAL_RUTILE)
