/decl/environment_data/mantid
	important_gasses = list(
		"oxygen" =         TRUE,
		"methyl_bromide" = TRUE,
		"carbon_dioxide" = TRUE,
		"methane" =        TRUE
	)
	dangerous_gasses = list(
		"carbon_dioxide" = TRUE,
		"methane" =        TRUE
	)

MANTIDIFY(/obj/machinery/alarm, "mantid thermostat", "atmospherics")

/obj/machinery/alarm/ascent
	req_access = list(access_ascent)
	construct_state = null
	environment_type = /decl/environment_data/mantid

/obj/machinery/alarm/ascent/Initialize()
	. = ..()
	TLV["methyl_bromide"] = list(16, 19, 135, 140)
	TLV["methane"] = list(-1.0, -1.0, 5, 10)