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

/obj/item/weapon/ore/Initialize(mapload, var/_mat)
	. = ..(mapload)

	if(_mat)
		matter = list()
		matter[_mat] = SHEET_MATERIAL_AMOUNT

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
/obj/item/weapon/ore/uranium/Initialize(mapload)
	. = ..(mapload,  MATERIAL_PITCHBLENDE)
/obj/item/weapon/ore/iron/Initialize(mapload)
	. = ..(mapload,  MATERIAL_HEMATITE)
/obj/item/weapon/ore/coal/Initialize(mapload)
	. = ..(mapload,  MATERIAL_GRAPHITE)
/obj/item/weapon/ore/glass/Initialize(mapload)
	. = ..(mapload,  MATERIAL_SAND)
/obj/item/weapon/ore/silver/Initialize(mapload)
	. = ..(mapload,  MATERIAL_SILVER)
/obj/item/weapon/ore/gold/Initialize(mapload)
	. = ..(mapload,  MATERIAL_GOLD)
/obj/item/weapon/ore/diamond/Initialize(mapload)
	. = ..(mapload,  MATERIAL_DIAMOND)
/obj/item/weapon/ore/osmium/Initialize(mapload)
	. = ..(mapload,  MATERIAL_PLATINUM)
/obj/item/weapon/ore/hydrogen/Initialize(mapload)
	. = ..(mapload,  MATERIAL_HYDROGEN)
/obj/item/weapon/ore/slag/Initialize(mapload)
	. = ..(mapload,  MATERIAL_WASTE)
/obj/item/weapon/ore/phoron/Initialize(mapload)
	. = ..(mapload,  MATERIAL_PHORON)
/obj/item/weapon/ore/aluminium/Initialize(mapload)
	. = ..(mapload,  MATERIAL_BAUXITE)
/obj/item/weapon/ore/rutile/Initialize(mapload)
	. = ..(mapload,  MATERIAL_RUTILE)
