/obj/item/stock_parts/circuitboard/shuttle_console
	name = T_BOARD("basic shuttle console")
	build_path = /obj/machinery/computer/shuttle_control
	origin_tech = list(TECH_DATA = 3)
	var/shuttle_tag

/obj/item/stock_parts/circuitboard/shuttle_console/construct(obj/machinery/computer/shuttle_control/M)
	M.shuttle_tag = shuttle_tag

/obj/item/stock_parts/circuitboard/shuttle_console/deconstruct(obj/machinery/computer/shuttle_control/M)
	shuttle_tag = M.shuttle_tag

/obj/item/stock_parts/circuitboard/shuttle_console/Initialize()
	set_extension(src, /datum/extension/interactive/multitool/circuitboards/shuttle_console)
	. = ..()

/obj/item/stock_parts/circuitboard/shuttle_console/proc/is_valid_shuttle(datum/shuttle/shuttle)
	return TRUE

/obj/item/stock_parts/circuitboard/shuttle_console/explore
	name = T_BOARD("long range shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/explore

/obj/item/stock_parts/circuitboard/shuttle_console/explore/is_valid_shuttle(datum/shuttle/shuttle)
	return istype(shuttle, /datum/shuttle/autodock/overmap)