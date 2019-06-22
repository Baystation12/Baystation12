/obj/effect/pixelmarker
	icon = 'icons/debug/pixelmarkers.dmi'
	var/lifetime = 0.3

/obj/effect/pixelmarker/Initialize()
	..()
	spawn(lifetime)
		qdel(src)

//Sets the pixelmarker to be on the target pixel exactly
/obj/effect/pixelmarker/proc/set_world_pixel_coords(var/vector2/coords)
	var/vector2/tilecoords = new /vector2(round(coords.x / world.icon_size), round(coords.y / world.icon_size))
	forceMove(locate(tilecoords.x, tilecoords.y, z))
	pixel_x = (coords.x % tilecoords.x)
	pixel_y = (coords.y % tilecoords.y)