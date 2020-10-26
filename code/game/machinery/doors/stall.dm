/obj/machinery/door/unpowered/simple/stall
	icon_state = "stall"
	icon_base = "stall"
	dooropen_noise = 'sound/machines/windowdoor.ogg'
	health_multiplier = 2

/obj/machinery/door/unpowered/simple/stall/on_update_icon()
	. = ..()
	update_dir()

/obj/machinery/door/unpowered/simple/stall/c_airblock(turf/other)
	return FALSE

/obj/machinery/door/unpowered/simple/stall/wood/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_WOOD, complexity)

/obj/machinery/door/unpowered/simple/stall/mahogany/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_MAHOGANY, complexity)

/obj/machinery/door/unpowered/simple/stall/maple/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_MAPLE, complexity)

/obj/machinery/door/unpowered/simple/stall/ebony/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_EBONY, complexity)

/obj/machinery/door/unpowered/simple/stall/walnut/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_WALNUT, complexity)

/obj/machinery/door/unpowered/simple/stall/gold/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_GOLD, complexity)

/obj/machinery/door/unpowered/simple/stall/plastic/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_PLASTIC, complexity)

/obj/machinery/door/unpowered/simple/stall/glass/New(newloc, material_name, complexity)
	..(newloc, MATERIAL_GLASS, complexity)