
/turf/simulated/floor/covenant
	name = "Nanolaminate Flooring"
	desc = "Floor made of an advanced alien alloy."
	icon = 'code/modules/halo/covenant/turfs/floors.dmi'
	icon_state = "Nanolaminate Framework"

	/*
	base_name = "Nanolaminate Framework"
	base_desc = ""
	base_icon = 'code/modules/halo/turfs/covenant/floors.dmi'
	base_icon_state = "Nanolaminate Framework"
	*/
	initial_flooring = /decl/flooring/covenant

	heat_capacity = 17000

/turf/simulated/floor/covenant/unggoy_den
    initial_gas = list("methane" = (101.325*2500/(293.15*8.31)))

/decl/flooring/covenant
	name = "Nanolaminate Flooring"
	desc = "Floor made of an advanced alien alloy."
	icon = 'code/modules/halo/covenant/turfs/floors.dmi'
	icon_base = "cov_floor"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE | TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/covenant
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	burnt_icon_base = "burnt"
	broken_icon_base = "broken"
	has_burn_range = 3
	has_damage_range = 3

/obj/item/stack/tile/covenant
	name = "nanolaminate floor tile"
	singular_name = "nanolaminate floor tile"
	desc = "A flooring section made from advanced alien alloy."
	icon = 'code/modules/halo/covenant/turfs/floors.dmi'
	icon_state = "nl_tile"
	force = 6.0
	matter = list("nanolaminate" = 937.5)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT

/obj/item/stack/tile/covenant/fifty
	amount = 50

/turf/simulated/floor/drone_biomass
	name = "biomass"
	desc = "It is covered in a hardened alien biomass."
	icon_state = "diona"
	icon = 'code/modules/halo/covenant/turfs/biomass.dmi'
	initial_flooring = /decl/flooring/diona
