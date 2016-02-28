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

/turf/simulated/wall/iron
	icon_state = "iron"
	New(var/newloc)
		..(newloc,"iron")
/turf/simulated/wall/uranium
	icon_state = "uranium"
	New(var/newloc)
		..(newloc,"uranium")
/turf/simulated/wall/diamond
	icon_state = "diamond"
	New(var/newloc)
		..(newloc,"diamond")
/turf/simulated/wall/gold
	icon_state = "gold"
	New(var/newloc)
		..(newloc,"gold")
/turf/simulated/wall/silver
	icon_state = "silver"
	New(var/newloc)
		..(newloc,"silver")
/turf/simulated/wall/phoron
	icon_state = "phoron"
	New(var/newloc)
		..(newloc,"phoron")
/turf/simulated/wall/sandstone
	icon_state = "sandstone"
	New(var/newloc)
		..(newloc,"sandstone")
/turf/simulated/wall/ironphoron
	icon_state = "iron"
	New(var/newloc)
		..(newloc,"iron","phoron")
/turf/simulated/wall/golddiamond
	icon_state = "gold"
	New(var/newloc)
		..(newloc,"gold","diamond")
/turf/simulated/wall/silvergold
	icon_state = "silver"
	New(var/newloc)
		..(newloc,"silver","gold")
/turf/simulated/wall/sandstonediamond
	icon_state = "sandstone"
	New(var/newloc)
		..(newloc,"sandstone","diamond")

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/voxshuttle/New(var/newloc)
	..(newloc,"voxalloy")
/turf/simulated/wall/voxshuttle/attackby()
	return
/turf/simulated/wall/titanium/New(var/newloc)
	..(newloc,"titanium")
