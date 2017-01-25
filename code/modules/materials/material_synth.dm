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
	icon_state = "sheet-plastic"
	default_type = "plastic"

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet-metal"
	default_type = "steel"

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-plasteel"
	default_type = "plasteel"

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	default_type = "wood"

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet-glass"
	default_type = "glass"

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-rglass"
	default_type = "rglass"
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/boroglass
	icon_state = "sheet-phoronglass"
	default_type = "phglass"
	charge_costs = list(1000)

/obj/item/stack/material/cyborg/boroglass/reinforced
	icon_state = "sheet-phoronrglass"
	default_type = "rphglass"
	charge_costs = list(500, 1000)