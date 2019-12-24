
/turf/simulated/wall/covenant
	name = "Nanolaminate Wall"
	desc = "An armor-plated wall which acts as both protection and separation"
	icon_state = "covie"

	floor_type = /turf/simulated/floor/covenant

/turf/simulated/wall/covenant/New(var/newloc)
	..(newloc,"nanolaminate")

/turf/simulated/wall/covenant/reinforced
	icon_state = "covie_reinf"

/turf/simulated/wall/covenant/reinforced/New(var/newloc)
	..(newloc,"nanolaminate","nanolaminate")

/turf/simulated/wall/drone_biomass
	name = "biomass covered wall"
	desc = "An armor-plated wall which acts as both protection and separation. It is covered in a hardened alien biomass"

	floor_type = /turf/simulated/floor/drone_biomass

/turf/simulated/wall/drone_biomass/New(var/newloc)
	..(newloc,"drone biomass")
