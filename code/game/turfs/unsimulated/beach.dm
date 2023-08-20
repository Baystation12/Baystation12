/turf/unsimulated/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "band"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "water"
	icon_state = "water"
	turf_flags = TURF_DISALLOW_BLOB | TURF_IS_WET

/turf/unsimulated/beach/water/New()
	..()
	AddOverlays(image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))
