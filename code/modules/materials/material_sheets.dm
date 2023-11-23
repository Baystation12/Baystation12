// Stacked resources. They use a material datum for a lot of inherited values.
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEM_SIZE_LARGE
	throw_speed = 3
	throw_range = 3
	max_amount = 60
	randpixel = 3
	icon = 'icons/obj/materials/materials.dmi'
	icon_state = "sheet-mult"

	var/reinf_state
	var/plural_reinf_state
	var/max_reinf_state
	var/default_type = MATERIAL_STEEL
	var/material/material
	var/default_reinf_type
	var/material/reinf_material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/material_flags = USE_MATERIAL_COLOR | USE_MATERIAL_SINGULAR_NAME | USE_MATERIAL_PLURAL_NAME | USE_MATERIAL_ICON
	var/matter_multiplier = 1


/obj/item/stack/material/get_stack_name()
	. = material.display_name
	if (reinf_material)
		. = "[reinf_material.display_name]-reinforced [.]"


/obj/item/stack/material/Initialize(mapload, amount, _material, _reinf_material)
	. = ..()
	if(_material)
		default_type = _material
	if(_reinf_material)
		default_reinf_type = _reinf_material
	material = SSmaterials.get_material_by_name(default_type)
	if(!material)
		return INITIALIZE_HINT_QDEL
	if(default_reinf_type)
		reinf_material = SSmaterials.get_material_by_name(default_reinf_type)

	update_materials()


/// Handles updating the stack to accomodate any changes to `material` or `reinf_material`. Also calls `update_strings()` and `update_icon()`.
/obj/item/stack/material/proc/update_materials(override_icon = FALSE)
	// Generate Icons
	if (!override_icon)
		if (HAS_FLAGS(material_flags, USE_MATERIAL_ICON))
			base_state = material.sheet_icon_base
		if (material.sheet_has_plural_icon)
			plural_icon_state = "[base_state]-mult"
			max_icon_state = "[base_state]-max"
		reinf_state = null
		if (reinf_material)
			if (HAS_FLAGS(material_flags, USE_MATERIAL_ICON))
				reinf_state = material.sheet_icon_reinf
			if (material.sheet_has_plural_icon)
				plural_reinf_state = "[reinf_state]-mult"
				max_reinf_state = "[reinf_state]-max"

	// Update Attributes
	stacktype = material.stack_type
	origin_tech.Cut()
	if (islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()
	if (material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)

	update_strings()
	update_icon()


/obj/item/stack/material/list_recipes(mob/user, recipes_sublist)
	if(!material)
		return
	recipes = material.get_recipes(reinf_material && reinf_material.name)
	..()

/obj/item/stack/material/get_codex_value()
	return (material && !material.hidden_from_codex) ? "[lowertext(material.display_name)] (material)" : ..()

/obj/item/stack/material/proc/set_amount(_amount)
	amount = max(1, min(_amount, max_amount))
	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	matter = material.get_matter()
	for(var/mat in matter)
		matter[mat] = round(matter[mat]*matter_multiplier*amount)
	if(reinf_material)
		var/list/rmatter = reinf_material.get_matter()
		for(var/mat in rmatter)
			rmatter[mat] = round(0.5*rmatter[mat]*matter_multiplier*amount)
			matter[mat] += rmatter[mat]

	if(material_flags & USE_MATERIAL_SINGULAR_NAME)
		singular_name = material.sheet_singular_name

	if(material_flags & USE_MATERIAL_PLURAL_NAME)
		plural_name = material.sheet_plural_name

	SetName(get_stack_name())
	if(amount>1)
		SetName("[name] [plural_name]")
		desc = "A stack of [get_vague_name()]."
		gender = PLURAL
	else
		SetName("[name] [singular_name]")
		desc = "[get_vague_name()]."
		gender = NEUTER
	if(reinf_material)
		desc += "\nIt is reinforced with the [reinf_material.use_name] lattice."

/obj/item/stack/material/use(used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/proc/is_same(obj/item/stack/material/M)
	if(!istype(M))
		return FALSE
	if(matter_multiplier != M.matter_multiplier)
		return FALSE
	if(material.name != M.material.name)
		return FALSE
	if((reinf_material && reinf_material.name) != (M.reinf_material && M.reinf_material.name))
		return FALSE
	return TRUE

/obj/item/stack/material/transfer_to(obj/item/stack/material/M, tamount=null, type_verified)
	if(!is_same(M))
		return 0
	var/transfer = ..(M,tamount,1)
	if(!QDELETED(src))
		update_strings()
	if(!QDELETED(M))
		M.update_strings()
	return transfer

/obj/item/stack/material/copy_from(obj/item/stack/material/other)
	..()
	if(istype(other))
		material = other.material
		reinf_material = other.reinf_material
		update_materials()

/obj/item/stack/material/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isCoil(W))
		material.build_wired_product(user, W, src)
		return TRUE

	if (istype(W, /obj/item/stack/material))
		if(is_same(W))
			return ..()
		else if(!reinf_material)
			material.reinforce(user, W, src)
			return TRUE

	if(reinf_material && reinf_material.stack_type && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(2, user) && use(2))
			to_chat(user,SPAN_NOTICE("You recover some [reinf_material.use_name] from \the [src]."))
			reinf_material.place_sheet(get_turf(user), 1)
		return TRUE

	return ..()

/obj/item/stack/material/on_update_icon()
	ClearOverlays()
	if(material_flags & USE_MATERIAL_COLOR)
		color = material.icon_colour
		alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	var/reinf_icon_state = reinf_state
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
		reinf_icon_state = max_reinf_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
		reinf_icon_state = plural_reinf_state
	else
		icon_state = base_state
	if (reinf_material && reinf_state)
		var/image/reinf_overlay = image(icon, reinf_icon_state)
		if (HAS_FLAGS(material_flags, USE_MATERIAL_COLOR))
			reinf_overlay.color = reinf_material.icon_colour
			reinf_overlay.alpha = min(100 + (reinf_material.opacity * 255), 255)
		AddOverlays(reinf_overlay)

/obj/item/stack/material/iron
	name = "iron"
	default_type = MATERIAL_IRON

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	default_type = MATERIAL_SANDSTONE

/obj/item/stack/material/marble
	name = "marble brick"
	default_type = MATERIAL_MARBLE

/obj/item/stack/material/marble/ten
	amount = 10

/obj/item/stack/material/marble/fifty
	amount = 50

/obj/item/stack/material/diamond
	name = "diamond"
	default_type = MATERIAL_DIAMOND

/obj/item/stack/material/diamond/ten
	amount = 10

/obj/item/stack/material/uranium
	name = "uranium"
	default_type = MATERIAL_URANIUM

/obj/item/stack/material/uranium/ten
	amount = 10


/obj/item/stack/material/uranium/fifty
	amount = 50

/obj/item/stack/material/phoron
	name = "solid phoron"
	material_flags = USE_MATERIAL_SINGULAR_NAME | USE_MATERIAL_PLURAL_NAME | USE_MATERIAL_ICON
	default_type = MATERIAL_PHORON

/obj/item/stack/material/phoron/ten
	amount = 10

/obj/item/stack/material/phoron/fifty
	amount = 50

/obj/item/stack/material/plastic
	name = "plastic"
	item_state = "sheet-plastic-mult"
	default_type = MATERIAL_PLASTIC

/obj/item/stack/material/plastic/ten
	amount = 10

/obj/item/stack/material/plastic/fifty
	amount = 50

/obj/item/stack/material/gold
	name = "gold"
	default_type = MATERIAL_GOLD

/obj/item/stack/material/gold/ten
	amount = 10

/obj/item/stack/material/silver
	name = "silver"
	default_type = MATERIAL_SILVER

/obj/item/stack/material/silver/ten
	amount = 10

/obj/item/stack/material/electrum
	name = "electrum"
	default_type = MATERIAL_ELECTRUM

/obj/item/stack/material/electrum/ten
	amount = 10

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	default_type = MATERIAL_PLATINUM

/obj/item/stack/material/platinum/ten
	amount = 10

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	default_type = MATERIAL_HYDROGEN
	material_flags = USE_MATERIAL_SINGULAR_NAME | USE_MATERIAL_PLURAL_NAME | USE_MATERIAL_ICON

/obj/item/stack/material/mhydrogen/ten
	amount = 10

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	default_type = MATERIAL_TRITIUM

/obj/item/stack/material/tritium/ten
	amount = 10

/obj/item/stack/material/tritium/fifty
	amount = 50

/obj/item/stack/material/osmium
	name = "osmium"
	default_type = MATERIAL_OSMIUM

/obj/item/stack/material/osmium/ten
	amount = 10

/obj/item/stack/material/ocp
	name = "osmium-carbide plasteel"
	item_state = "sheet-reinf-mult"
	default_type = MATERIAL_OSMIUM_CARBIDE_PLASTEEL

/obj/item/stack/material/ocp/ten
	amount = 10

/obj/item/stack/material/ocp/fifty
	amount = 50

// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	default_type = MATERIAL_DEUTERIUM

/obj/item/stack/material/deuterium/fifty
	amount = 50

/obj/item/stack/material/steel
	name = "steel"
	default_type = MATERIAL_STEEL

/obj/item/stack/material/steel/ten
	amount = 10

/obj/item/stack/material/steel/fifty
	amount = 50

/obj/item/stack/material/aluminium
	name = "aluminium"
	item_state = "sheet-sheen-mult"
	default_type = MATERIAL_ALUMINIUM

/obj/item/stack/material/aluminium/ten
	amount = 10

/obj/item/stack/material/aluminium/fifty
	amount = 50

/obj/item/stack/material/titanium
	name = "titanium"
	default_type = MATERIAL_TITANIUM

/obj/item/stack/material/titanium/ten
	amount = 10

/obj/item/stack/material/titanium/fifty
	amount = 50

/obj/item/stack/material/plasteel
	name = "plasteel"
	item_state = "sheet-reinf-mult"
	default_type = MATERIAL_PLASTEEL

/obj/item/stack/material/plasteel/ten
	amount = 10

/obj/item/stack/material/plasteel/fifty
	amount = 50

/obj/item/stack/material/wood
	name = "wooden plank"
	item_state = "sheet-wood-mult"
	default_type = MATERIAL_WOOD

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	default_type = MATERIAL_MAHOGANY

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	default_type = MATERIAL_MAPLE

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	default_type = MATERIAL_EBONY

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	default_type = MATERIAL_WALNUT

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	default_type = MATERIAL_BAMBOO

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

/obj/item/stack/material/wood/yew
	name = "yew plank"
	default_type = MATERIAL_YEW

/obj/item/stack/material/wood/yew/ten
	amount = 10

/obj/item/stack/material/wood/yew/twentyfive
	amount = 25

/obj/item/stack/material/wood/vox
	default_type = MATERIAL_VOXRES

/obj/item/stack/material/cloth
	name = "cloth"
	default_type = MATERIAL_CLOTH

/obj/item/stack/material/cardboard
	name = "cardboard"
	default_type = MATERIAL_CARDBOARD

/obj/item/stack/material/cardboard/ten
	amount = 10

/obj/item/stack/material/cardboard/fifty
	amount = 50

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	default_type = MATERIAL_LEATHER_GENERIC
	material_flags = USE_MATERIAL_SINGULAR_NAME | USE_MATERIAL_PLURAL_NAME | USE_MATERIAL_ICON

/obj/item/stack/material/glass
	name = "glass"
	item_state = "sheet-clear-mult"
	default_type = MATERIAL_GLASS

/obj/item/stack/material/glass/ten
	amount = 10

/obj/item/stack/material/glass/fifty
	amount = 50

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	default_type = MATERIAL_GLASS
	default_reinf_type = MATERIAL_STEEL

/obj/item/stack/material/glass/reinforced/ten
	amount = 10

/obj/item/stack/material/glass/reinforced/fifty
	amount = 50

/obj/item/stack/material/glass/boron
	name = "borosilicate glass"
	default_type = MATERIAL_BORON_GLASS

/obj/item/stack/material/glass/boron_reinforced
	name = "reinforced borosilicate glass"
	default_type = MATERIAL_BORON_GLASS
	default_reinf_type = MATERIAL_STEEL

/obj/item/stack/material/glass/boron_reinforced/ten
	amount = 10

/obj/item/stack/material/aliumium
	name = "alien alloy"
	default_type = MATERIAL_ALIENALLOY

/obj/item/stack/material/aliumium/ten
	amount = 10

/obj/item/stack/material/generic
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"

/obj/item/stack/material/generic/Initialize()
	. = ..()
	if(material) color = material.icon_colour

/obj/item/stack/material/generic/skin
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"

/obj/item/stack/material/generic/bone
	icon_state = "bone"
	plural_icon_state = "bone-mult"
	max_icon_state = "bone-max"

/obj/item/stack/material/generic/brick
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
