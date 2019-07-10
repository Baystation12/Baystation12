/datum/craft_recipe/wall_girders
	name = "wall girders"
	result = /obj/structure/girder
	time = WORKTIME_NORMAL
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 5)
	)
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF



/datum/craft_recipe/kitchen_spike
	name = "Meat spike"
	result = /obj/structure/kitchenspike
	time = WORKTIME_NORMAL
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 3),
		list(CRAFT_TOOL, QUALITY_WELDING, 10, "time" = 120)
	)
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF

/datum/craft_recipe/metal_rod
	name = "metal rod"
	result = /obj/item/stack/rods
	time = 0
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL)
	)

/datum/craft_recipe/box
	name = "box"
	result = /obj/item/weapon/storage/box
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_CARDBOARD)
	)


/datum/craft_recipe/plastic_bag
	name = "plastic bag"
	result = /obj/item/weapon/storage/bag/plasticbag
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC)
	)



/datum/craft_recipe/ashtray
	name = "ashtray"
	result = /obj/item/weapon/material/ashtray
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL)
	)

/datum/craft_recipe/beehive_assembly
	name = "beehive assembly"
	result = /obj/item/beehive_assembly
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 10)
	)

/datum/craft_recipe/beehive_frame
	name = "beehive frame"
	result = /obj/item/honey_frame
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 4)
	)

/datum/craft_recipe/canister
	name = "canister"
	result = /obj/machinery/portable_atmospherics/canister/empty
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10)
	)

/datum/craft_recipe/cannon_frame
	name = "cannon frame"
	result = /obj/item/weapon/cannonframe
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10)
	)



/datum/craft_recipe/folder
	name = "grey folder"
	result = /obj/item/weapon/folder
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_CARDBOARD)
	)

/datum/craft_recipe/folder/blue
	name = "blue folder"
	result = /obj/item/weapon/folder/blue

/datum/craft_recipe/folder/red
	name = "red folder"
	result = /obj/item/weapon/folder/red

/datum/craft_recipe/folder/white
	name = "white folder"
	result = /obj/item/weapon/folder/white

/datum/craft_recipe/folder/yellow
	name = "yellow folder"
	result = /obj/item/weapon/folder/yellow



/datum/craft_recipe/bandage
	name = "bandages"
	result = /obj/item/stack/medical/bruise_pack/handmade
	steps = list(
		list(CRAFT_OBJECT, /obj/item/clothing, time = 100)
	)


/datum/craft_recipe/tray
	name = "dinner tray"
	result = /obj/item/weapon/tray
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL),
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, "time" = 120)
	)


//You build a frame from rods, add metal shelves, plastic wheels and handles
/datum/craft_recipe/janicart
	name = "janitorial cart"
	result = /obj/structure/janitorialcart
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 10),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 60),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10, "time" = 40),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 60),
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 10, "time" = 40),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 60)
	)


//Cut variously sized bits of plastic down to size, tape them together, and then use a welder to melt gaps
//It just works!
/datum/craft_recipe/mopbucket
	name = "mop bucket"
	result = /obj/structure/mopbucket
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 15, "time" = 40),
		list(CRAFT_TOOL, QUALITY_SEALING, 10, 60),
		list(CRAFT_TOOL, QUALITY_WELDING, 10, 60)
	)


//You get some article of clothing and shred it with a blade to make a mophead. Add in some metal rods for a handle
/datum/craft_recipe/mop
	name = "mop"
	result = /obj/item/weapon/mop
	steps = list(
		list(CRAFT_OBJECT, /obj/item/clothing),
		list(CRAFT_TOOL, QUALITY_CUTTING, 10, 120),
		list(CRAFT_STACK, /obj/item/stack/rods, 2),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 60)
	)

