
/turf/simulated/floor/covenant
	name = "Nanolaminate Flooring"
	desc = ""
	icon = 'code/modules/halo/turfs/covenant/floors.dmi'
	icon_state = "Nanolaminate Flooring"

	base_name = "Nanolaminate Framework"
	base_desc = ""
	base_icon = 'code/modules/halo/turfs/covenant/floors.dmi'
	base_icon_state = "Nanolaminate Flooring"

	mineral = DEFAULT_WALL_MATERIAL

	heat_capacity = 17000

/turf/simulated/floor/covenant/unggoy_den
    initial_gas = list("methane" = (101.325*2500/(293.15*8.31)))

/turf/simulated/floor/drone_biomass
	name = "biomass"
	desc = "It is covered in a hardened alien biomass."
	icon_state = "diona"
	icon = 'icons/turf/floors.dmi'
	initial_flooring = /decl/flooring/diona
