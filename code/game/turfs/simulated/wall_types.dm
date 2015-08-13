/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
/turf/simulated/wall/r_wall/New(var/newloc)
	..(newloc, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
/turf/simulated/wall/cult/New(var/newloc)
	..(newloc,"cult","cult2")
/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron/New(var/newloc)
	..(newloc,"iron")
/turf/simulated/wall/uranium/New(var/newloc)
	..(newloc,"uranium")
/turf/simulated/wall/diamond/New(var/newloc)
	..(newloc,"diamond")
/turf/simulated/wall/gold/New(var/newloc)
	..(newloc,"gold")
/turf/simulated/wall/silver/New(var/newloc)
	..(newloc,"silver")
/turf/simulated/wall/phoron/New(var/newloc)
	..(newloc,"phoron")
/turf/simulated/wall/sandstone/New(var/newloc)
	..(newloc,"sandstone")
/turf/simulated/wall/ironphoron/New(var/newloc)
	..(newloc,"iron","phoron")
/turf/simulated/wall/golddiamond/New(var/newloc)
	..(newloc,"gold","diamond")
/turf/simulated/wall/silvergold/New(var/newloc)
	..(newloc,"silver","gold")
/turf/simulated/wall/sandstonediamond/New(var/newloc)
	..(newloc,"sandstone","diamond")

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/voxshuttle/New(var/newloc)
	..(newloc,"voxalloy")
/turf/simulated/wall/voxshuttle/attackby()
	return
