/datum/craft_recipe/weapon
	category = "Weapon"
	time = 60

	icon_state = "gun"

/datum/craft_recipe/weapon/baseballbat
	name = "baseball bat"
	result = /obj/item/weapon/material/twohanded/baseballbat
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 6)
	)

/datum/craft_recipe/weapon/grenade_casing
	name = "grenade casing"
	result = /obj/item/weapon/grenade/chem_grenade
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/fork
	name = "fork"
	result = /obj/item/weapon/material/kitchen/utensil/fork
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/knife
	name = "steel knife"
	result = /obj/item/weapon/material/knife
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1)
	)

/datum/craft_recipe/weapon/spoon
	name = "spoon"
	result = /obj/item/weapon/material/kitchen/utensil/spoon
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1)
	)


/datum/craft_recipe/weapon/knife_blade
	name = "knife blade"
	result = /obj/item/weapon/material/butterflyblade
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 6)
	)

/datum/craft_recipe/weapon/knife_grip
	name = "knife grip"
	result = /obj/item/weapon/material/butterflyhandle
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 4)
	)

/datum/craft_recipe/weapon/crossbow_frame
	name = "crossbow frame"
	result = /obj/item/weapon/crossbowframe
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 5)
	)



/datum/craft_recipe/weapon/handmade_shield
	name = "handmade shield"
	result = /obj/item/weapon/shield/buckler
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 12),
		list(CRAFT_STACK, /obj/item/stack/rods, 4),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/tray_shield
	name = "handmade tray shield"
	result = /obj/item/weapon/shield/tray
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/tray),
		list(CRAFT_OBJECT, /obj/item/weapon/storage/belt),
		list(CRAFT_OBJECT, /obj/item/weapon/storage/belt)
	)


/datum/craft_recipe/weapon/flamethrower
	name = "flamethrower"
	result = /obj/item/weapon/flamethrower
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/tool/weldingtool, "time" = 60),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70),
		list(CRAFT_OBJECT, /obj/item/device/assembly/igniter,),
	)


/datum/craft_recipe/weapon/mechanical_trap
	name = "makeshift mechanical trap"
	result = /obj/item/weapon/beartrap/makeshift
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/tool/saw, "time" = 120),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 20),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 70),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 2, "time" = 10)
	)


/datum/craft_recipe/weapon/ripper
	name = "RC-DS Remote Control Disc Ripper"
	result = /obj/item/weapon/gun/projectile/ripper
	passive_steps = list(CRAFT_PASSIVE, QUALITY_WORKBENCH, 1, 0)
	time = 100
	steps = list(
	list(CRAFT_OBJECT, /obj/item/weapon/tool/wrench),
	list(CRAFT_OBJECT, /obj/item/weapon/stock_parts/matter_bin),
	list(CRAFT_STACK, /obj/item/stack/cable_coil, 5),
	list(CRAFT_STACK, /obj/item/stack/power_node, 1)
	)