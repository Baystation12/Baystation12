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
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/ring/material, 1, on_floor = 1, supplied_material = "[name]")

	if(integrity>50)
		recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]") //NOTE: the wood material has it's own special chair recipe
		recipes += new/datum/stack_recipe_list("padded [display_name] chairs", list( \
		new/datum/stack_recipe("beige padded [display_name] chair", /obj/structure/bed/chair/padded/beige, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black padded [display_name] chair", /obj/structure/bed/chair/padded/black, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown padded [display_name] chair", /obj/structure/bed/chair/padded/brown, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime padded [display_name] chair", /obj/structure/bed/chair/padded/lime, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal padded [display_name] chair", /obj/structure/bed/chair/padded/teal, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red padded [display_name] chair", /obj/structure/bed/chair/padded/red, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue padded [display_name] chair", /obj/structure/bed/chair/padded/blue, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple padded [display_name] chair", /obj/structure/bed/chair/padded/purp, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green padded [display_name] chair", /obj/structure/bed/chair/padded/green, 2, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow padded [display_name] chair", /obj/structure/bed/chair/padded/green, 2, one_per_turf = 1, on_floor = 1), \
		))
	if(integrity>=50)
		recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/weapon/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] bar stool", /obj/item/weapon/stool/bar, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] lock",/obj/item/weapon/material/lock_construct, 1, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] railing",/obj/structure/railing, 3, time = 40, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

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
	recipes += new/datum/stack_recipe_list("comfy office chairs",list( \
		new/datum/stack_recipe("beige comfy office chair", /obj/structure/bed/chair/office/comfy/beige, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black comfy office chair", /obj/structure/bed/chair/office/comfy/black, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown comfy office chair", /obj/structure/bed/chair/office/comfy/brown, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime comfy office chair", /obj/structure/bed/chair/office/comfy/lime, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal comfy office chair", /obj/structure/bed/chair/office/comfy/teal, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red comfy office chair", /obj/structure/bed/chair/office/comfy/red, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue comfy office chair", /obj/structure/bed/chair/office/comfy/blue, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple comfy office chair", /obj/structure/bed/chair/office/comfy/purp, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green comfy office chair", /obj/structure/bed/chair/office/comfy/green, 7, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow comfy office chair", /obj/structure/bed/chair/office/comfy/yellow, 7, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 3, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 3, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe_list("armchairs", list( \
		new/datum/stack_recipe("beige armchair", /obj/structure/bed/chair/armchair/beige, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black armchair", /obj/structure/bed/chair/armchair/black, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown armchair", /obj/structure/bed/chair/armchair/brown, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime armchair", /obj/structure/bed/chair/armchair/lime, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal armchair", /obj/structure/bed/chair/armchair/teal, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red armchair", /obj/structure/bed/chair/armchair/red, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue armchair", /obj/structure/bed/chair/armchair/blue, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple armchair", /obj/structure/bed/chair/armchair/purp, 4, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green armchair", /obj/structure/bed/chair/armchair/green, 4, one_per_turf = 1, on_floor = 1), \
		))
	recipes += new/datum/stack_recipe("key", /obj/item/weapon/key, 1, time = 10, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("cannon frame", /obj/item/weapon/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20)
	recipes += new/datum/stack_recipe("mono floor tile", /obj/item/stack/tile/mono, 1, 4, 20)
	recipes += new/datum/stack_recipe("dark mono floor tile", /obj/item/stack/tile/mono/dark, 1, 4, 20)
	recipes += new/datum/stack_recipe("grid floor tile", /obj/item/stack/tile/grid, 1, 4, 20)
	recipes += new/datum/stack_recipe("ridged floor tile", /obj/item/stack/tile/ridge, 1, 4, 20)
	recipes += new/datum/stack_recipe("grey techfloor tile", /obj/item/stack/tile/techgrey, 1, 4, 20)
	recipes += new/datum/stack_recipe("grid techfloor tile", /obj/item/stack/tile/techgrid, 1, 4, 20)
	recipes += new/datum/stack_recipe("dark techfloor tile", /obj/item/stack/tile/techmaint, 1, 4, 20)
	recipes += new/datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor_dark, 1, 4, 20)
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60)
	recipes += new/datum/stack_recipe("computer frame", /obj/structure/computerframe, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("low wall frame", /obj/structure/wall_frame, 2, time = 50, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("machine frame", /obj/machinery/constructable_frame/machine_frame, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe_list("airlock assemblies", list( \
		new/datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1), \
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

/material/stone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)

/material/plastic/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1)
	recipes += new/datum/stack_recipe("blood pack", /obj/item/weapon/reagent_containers/ivbag, 4, on_floor = 0)
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/weapon/reagent_containers/chem_disp_cartridge,        5, on_floor=0) // 500u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/weapon/reagent_containers/chem_disp_cartridge/medium, 3, on_floor=0) // 250u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/weapon/reagent_containers/chem_disp_cartridge/small,  1, on_floor=0) // 100u
	recipes += new/datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor_white, 1, 4, 20)
	recipes += new/datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor_freezer, 1, 4, 20)
	recipes += new/datum/stack_recipe("hazard cone", /obj/item/weapon/caution/cone, 1, on_floor = 1)


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
	recipes += new/datum/stack_recipe("stick", /obj/item/weapon/material/stick, 1)

/material/cardboard/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("box", /obj/item/weapon/storage/box)
	recipes += new/datum/stack_recipe("large box", /obj/item/weapon/storage/box/large, 2)
	recipes += new/datum/stack_recipe("donut box", /obj/item/weapon/storage/box/donut/empty)
	recipes += new/datum/stack_recipe("egg box", /obj/item/weapon/storage/fancy/egg_box/empty)
	recipes += new/datum/stack_recipe("light tubes box", /obj/item/weapon/storage/box/lights/tubes/empty)
	recipes += new/datum/stack_recipe("light bulbs box", /obj/item/weapon/storage/box/lights/bulbs/empty)
	recipes += new/datum/stack_recipe("mouse traps box", /obj/item/weapon/storage/box/mousetraps/empty)
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
