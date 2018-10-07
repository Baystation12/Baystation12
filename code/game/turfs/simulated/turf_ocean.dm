/turf/simulated/ocean
	name = "sea floor"
	desc = "Silty."
	icon = 'icons/turf/seafloor.dmi'
	icon_state = "seafloor"
	density = FALSE
	opacity = FALSE
	flooded = TRUE
	var/detail_decal

/turf/simulated/ocean/abyss
	name = "abyssal silt"
	desc = "Unfathomably silty."
	icon_state = "mud_light"

/turf/simulated/ocean/open
	name = "open ocean"
	icon_state = "still"

/turf/simulated/ocean/open/add_decal()
	return 0

/turf/simulated/ocean/is_plating()
	return 1

/turf/simulated/ocean/proc/add_decal()
	return prob(20)

/turf/simulated/ocean/Initialize()
	. = ..()
	if(isnull(detail_decal) && add_decal())
		detail_decal = "asteroid[rand(0,9)]"
		update_icon()

/turf/simulated/ocean/on_update_icon(update_neighbors)
	..(update_neighbors)
	if(detail_decal)
		overlays += image(icon = 'icons/turf/mining_decals.dmi', icon_state = detail_decal)
