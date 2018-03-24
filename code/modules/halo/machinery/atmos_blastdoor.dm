
/obj/machinery/door/blast/atmos_close
	name = "Atmospheric Seal"
	begins_closed = FALSE

/obj/machinery/door/blast/atmos_close/New()
	. = ..()
	GLOB.processing_objects += src

/obj/machinery/door/blast/atmos_close/Destroy()
	. = ..()
	GLOB.processing_objects -= src

/obj/machinery/door/blast/atmos_close/process()
	. = ..()
	if(icon_state == icon_state_closed)
		return
	var/turf/turf_underneath = loc
	if(!istype(turf_underneath,/turf/simulated))
		return
	var/datum/gas_mixture/turf_gas = turf_underneath.air
	if(isnull(turf_gas))
		return
	if((turf_gas.gas["oxygen"] < 16)||(turf_gas.return_pressure() < WARNING_LOW_PRESSURE))
		close()

/obj/machinery/door/blast/atmos_close/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600
	block_air_zones = 1
	desc = "A huge door used to seal off breached areas. If this is closed, keep it that way."