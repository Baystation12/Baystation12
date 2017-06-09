/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new/datum/stack_recipe("[display_name] baseball bat", /obj/item/weapon/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/weapon/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] spoon", /obj/item/weapon/material/kitchen/utensil/spoon/plastic, 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]")

	if(integrity>50)
		recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/weapon/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] bar stool", /obj/item/weapon/stool/bar, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]") //NOTE: the wood material has it's own special chair recipe
		recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] lock",/obj/item/weapon/material/lock_construct, 1, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] fork", /obj/item/weapon/material/kitchen/utensil/fork/plastic, 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] knife", /obj/item/weapon/material/kitchen/utensil/knife/plastic, 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/weapon/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("office chairs",list( \
		new/datum/stack_recipe("dark office chair", /obj/structure/bed/chair/office/dark, 5, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("light office chair", /obj/structure/bed/chair/office/light, 5, one_per_turf = 1, on_floor = 1) \
		))
	recipes += new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 2, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("key", /obj/item/weapon/key, 1, time = 10, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("cannon frame", /obj/item/weapon/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20)
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60)
	recipes += new/datum/stack_recipe("computer frame", /obj/structure/computerframe, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("machine frame", /obj/machinery/constructable_frame/machine_frame, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe_list("airlock assemblies", list( \
		new/datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("emergency shutter", /obj/structure/firedoor_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		))

	recipes += new/datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade)
	recipes += new/datum/stack_recipe("light fixture frame", /obj/item/frame/light, 2)
	recipes += new/datum/stack_recipe("small light fixture frame", /obj/item/frame/light/small, 1)
	recipes += new/datum/stack_recipe("apc frame", /obj/item/frame/apc, 2)
	recipes += new/datum/stack_recipe("air alarm frame", /obj/item/frame/air_alarm, 2)
	recipes += new/datum/stack_recipe("fire alarm frame", /obj/item/frame/fire_alarm, 2)

	recipes += new/datum/stack_recipe_list("modular computer frames", list( \
		new/datum/stack_recipe("modular console frame", /obj/item/modular_computer/console, 20),\
		new/datum/stack_recipe("modular telescreen frame", /obj/item/modular_computer/telescreen, 10),\
		new/datum/stack_recipe("modular laptop frame", /obj/item/modular_computer/laptop, 10),\
		new/datum/stack_recipe("modular tablet frame", /obj/item/modular_computer/tablet, 5),\
	))
/material/plasteel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("AI core", /obj/structure/AIcore, 4, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("knife grip", /obj/item/weapon/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor_dark, 1, 4, 20)

/material/stone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)

/material/plastic/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1)
	recipes += new/datum/stack_recipe("blood pack", /obj/item/weapon/reagent_containers/blood/empty, 4, on_floor = 0)
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/weapon/reagent_containers/chem_disp_cartridge,        5, on_floor=0) // 500u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/weapon/reagent_containers/chem_disp_cartridge/medium, 3, on_floor=0) // 250u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/weapon/reagent_containers/chem_disp_cartridge/small,  1, on_floor=0) // 100u
	recipes += new/datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor_white, 1, 4, 20)
	recipes += new/datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor_freezer, 1, 4, 20)

/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1)
	recipes += new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20)
	recipes += new/datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood, 3, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("fancy wooden chair", /obj/structure/bed/chair/wood/wings, 3, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("crossbow frame", /obj/item/weapon/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("beehive assembly", /obj/item/beehive_assembly, 4)
	recipes += new/datum/stack_recipe("beehive frame", /obj/item/honey_frame, 1)
	recipes += new/datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("zip gun frame", /obj/item/weapon/zipgunframe, 5)
	recipes += new/datum/stack_recipe("coilgun stock", /obj/item/weapon/coilgun_assembly, 5)

/material/cardboard/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("box", /obj/item/weapon/storage/box)
	recipes += new/datum/stack_recipe("large box", /obj/item/weapon/storage/box/large, 2)
	recipes += new/datum/stack_recipe("donut box", /obj/item/weapon/storage/box/donut/empty)
	recipes += new/datum/stack_recipe("egg box", /obj/item/weapon/storage/fancy/egg_box)
	recipes += new/datum/stack_recipe("light tubes box", /obj/item/weapon/storage/box/lights/tubes)
	recipes += new/datum/stack_recipe("light bulbs box", /obj/item/weapon/storage/box/lights/bulbs)
	recipes += new/datum/stack_recipe("mouse traps box", /obj/item/weapon/storage/box/mousetraps)
	recipes += new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3)
	recipes += new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg)
	recipes += new/datum/stack_recipe("pizza box", /obj/item/pizzabox)
	recipes += new/datum/stack_recipe_list("folders",list( \
		new/datum/stack_recipe("blue folder", /obj/item/weapon/folder/blue), \
		new/datum/stack_recipe("grey folder", /obj/item/weapon/folder), \
		new/datum/stack_recipe("red folder", /obj/item/weapon/folder/red), \
		new/datum/stack_recipe("white folder", /obj/item/weapon/folder/white), \
		new/datum/stack_recipe("yellow folder", /obj/item/weapon/folder/yellow), \
		))
