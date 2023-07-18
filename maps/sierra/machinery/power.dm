/obj/machinery/power/apc/charon
	req_access = list(list(access_expedition_shuttle_helm, access_engine)) //for pilot, EL and field/regular engineers

/obj/machinery/power/apc/merchant
	req_access = list(access_merchant)

/obj/machinery/power/apc/bsa
	cell_type = /obj/item/cell/high
	/*INF@SHRUG
	chargelevel = 0.1 //1% per second (10w)
	*/

//
// SMES units
//

// Substation SMES
/obj/machinery/power/smes/buildable/preset/sierra/substation
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE

// Substation SMES (charged and with full I/O setting)
/obj/machinery/power/smes/buildable/preset/sierra/substation_full
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Main Engine output SMES
/obj/machinery/power/smes/buildable/preset/sierra/engine_main
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/super_io = 2,
								/obj/item/stock_parts/smes_coil/super_capacity = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Shuttle SMES
/obj/machinery/power/smes/buildable/preset/sierra/shuttle
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/super_io = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Charon's smes - Coltrane97@inf-dev
/obj/machinery/power/smes/buildable/preset/sierra/shuttle/charon
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/super_io = 1,
									/obj/item/stock_parts/smes_coil/super_capacity = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Hangar SMES. Charges the shuttles so needs a pretty big throughput.
/obj/machinery/power/smes/buildable/preset/sierra/hangar
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/super_io = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE
