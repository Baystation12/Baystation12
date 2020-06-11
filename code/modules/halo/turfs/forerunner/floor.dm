
/turf/simulated/floor/forerunner_alloy
	name = "Forerunner Alloy Flooring"
	desc = "Floor made of an advanced alien alloy."
	icon = 'code/modules/halo/turfs/forerunner/floors.dmi'
	icon_state = "floortile"

	initial_flooring = /decl/flooring/forerunner

	heat_capacity = 17000

/decl/flooring/forerunner
	name = "Forerunner Alloy flooring"
	desc = "Floor made of an advanced alien alloy."
	icon = 'code/modules/halo/turfs/forerunner/floors.dmi'
	icon_base = "floortile"
	flags = TURF_ACID_IMMUNE
	build_type = null
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000