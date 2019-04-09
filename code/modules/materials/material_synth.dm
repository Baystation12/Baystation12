// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER
	matter = null // Don't shove it in the autholathe.

/obj/item/stack/material/cyborg/New()
	if(..())
		name = "[material.display_name] synthesiser"
		desc = "A device that synthesises [material.display_name]."
		matter = null

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet"
	default_type = MATERIAL_PLASTIC

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet"
	default_type = MATERIAL_STEEL

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-reinf"
	default_type = MATERIAL_PLASTEEL

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet"
	default_type = MATERIAL_GLASS
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-reinf"
	default_type = MATERIAL_GLASS
	default_reinf_type = MATERIAL_STEEL
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/aluminium
	icon_state = "sheet"
	default_type = MATERIAL_ALUMINIUM
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
