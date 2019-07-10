/datum/craft_recipe/machinery
	category = "Machinery"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 120

/datum/craft_recipe/machinery/machine_frame
	name = "machine frame"
	result = /obj/machinery/constructable_frame/machine_frame
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
	)


/datum/craft_recipe/machinery/computer_frame
	name = "computer frame"
	result = /obj/structure/computerframe
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
	)

/datum/craft_recipe/machinery/modularconsole
	name = "modular console frame"
	result = /obj/item/modular_computer/console
	time = 200
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 4),
	)

/datum/craft_recipe/machinery/modularlaptop
	name = "modular laptop frame"
	result = /obj/item/modular_computer/laptop
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 4),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 4),
	)

/datum/craft_recipe/machinery/modulartablet
	name = "modular tablet frame"
	result = /obj/item/modular_computer/tablet
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 5),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 2),
	)

/datum/craft_recipe/machinery/modularpda
	name = "modular pda frame"
	result = /obj/item/modular_computer/pda
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 3),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 1),
	)

/datum/craft_recipe/machinery/modulartelescreen
	name = "modular telescreen frame"
	result = /obj/item/modular_computer/telescreen
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 6),
	)

/datum/craft_recipe/machinery/turret_frame
	name = "turret frame"
	result = /obj/machinery/porta_turret_construct
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10)
	)



//wall or small you know them req only 2 list
/datum/craft_recipe/machinery/wall
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2),
	)
	flags = null

/datum/craft_recipe/machinery/wall/lightfixture
	name = "light fixture frame"
	result = /obj/item/frame/light

/datum/craft_recipe/machinery/wall/lightfixture/small
	name = "small light fixture frame"
	result = /obj/item/frame/light/small

/datum/craft_recipe/machinery/wall/apc
	name = "apc frame"
	result = /obj/item/frame/apc

/datum/craft_recipe/machinery/wall/air_alarm
	name = "air alarm frame"
	result = /obj/item/frame/air_alarm

/datum/craft_recipe/machinery/wall/fire_alarm
	name = "fire alarm frame"
	result = /obj/item/frame/fire_alarm

/datum/craft_recipe/machinery/AI_core
	name = "AI core"
	result = /obj/structure/AIcore
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),
	)
