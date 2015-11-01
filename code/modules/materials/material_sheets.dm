// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	max_amount = 50

	var/default_type = DEFAULT_WALL_MATERIAL
	var/material/material
	var/perunit
	var/apply_colour //temp pending icon rewrite

/obj/item/stack/material/New()
	..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

	if(!default_type)
		default_type = DEFAULT_WALL_MATERIAL
	material = get_material_by_name("[default_type]")
	if(!material)
		qdel(src)
		return 0

	recipes = material.get_recipes()
	stacktype = material.stack_type
	origin_tech = material.stack_origin_tech
	perunit = material.stack_per_sheet

	if(apply_colour)
		color = material.icon_colour

	if(material.conductive)
		flags |= CONDUCT

	matter = material.get_matter()
	update_strings()
	return 1

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A stack of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	default_type = "iron"
	apply_colour = 1

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type = "sandstone"

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type = "marble"

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type = "diamond"

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = "uranium"

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = "phoron"

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	default_type = "plastic"

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_type = "gold"

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	default_type = "silver"

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_type = "platinum"

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = "mhydrogen"

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_type = "tritium"
	apply_colour = 1

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type = "osmium"
	apply_colour = 1

/obj/item/stack/material/steel
	name = DEFAULT_WALL_MATERIAL
	icon_state = "sheet-metal"
	default_type = DEFAULT_WALL_MATERIAL

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type = "plasteel"

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = "wood"

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	default_type = "cloth"

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type = "cardboard"

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	default_type = "leather"

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = "glass"

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type = "rglass"

/obj/item/stack/material/glass/phoronglass
	name = "phoron glass"
	singular_name = "phoron glass sheet"
	icon_state = "sheet-phoronglass"
	default_type = "phglass"

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced phoron glass"
	icon_state = "sheet-phoronrglass"
	default_type = "rphglass"
