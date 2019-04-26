/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon_state = "unloader"
	input_turf =  WEST
	output_turf = EAST

/obj/machinery/mineral/unloading_machine/New()
	..()
	component_parts = list(
		new /obj/item/weapon/stock_parts/manipulator(src),
		new /obj/item/weapon/stock_parts/manipulator(src),
		new /obj/item/weapon/circuitboard/mining_unloader(src)
		)
	set_extension(src, /datum/extension/conveyor, /datum/extension/conveyor/ore_unloader)