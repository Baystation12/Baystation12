#define OVERMAP_ZLEVEL 1
//===================================================================================
//Metaobject for storing information about sector this zlevel is representing.
//Should be placed only once on every zlevel.
//===================================================================================
/obj/effect/mapinfo/
	name = "map info metaobject"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101
	var/obj_type		//type of overmap object it spawns
	var/zlevel
	var/mapx			//coordinates on the
	var/mapy			//overmap zlevel

/obj/effect/mapinfo/New()
	tag = "sector[z]"
	zlevel = z
	loc = null

/obj/effect/mapinfo/sector
	name = "generic sector"
	desc = "Space sector with some stuff in it."
	obj_type = /obj/effect/map/sector

/obj/effect/mapinfo/ship
	name = "generic ship"
	desc = "Space faring vessel."
	obj_type = /obj/effect/map/ship

/obj/effect/mapinfo/ship/relaymove(var/mob/user, direction)
	step(src,direction)
//===================================================================================
//Overmap object representing zlevel
//===================================================================================
/obj/effect/map
	name = "map object"
	var/map_z = 0

/obj/effect/map/New(var/obj/effect/mapinfo/data)
	name = data.name
	desc = data.desc
	map_z = data.zlevel
	icon = data.icon
	icon_state = data.icon_state
	var/new_x = data.mapx
	if (!new_x)
		new_x = rand(1,world.maxx)
	var/new_y = data.mapy
	if (!new_y)
		new_y = rand(1,world.maxy)
	loc = locate(new_x, new_y, OVERMAP_ZLEVEL)

/obj/effect/map/CanPass(atom/movable/A)
	testing("[A] attempts to enter sector\"[name]\"")
	if(prob(50))
		testing("[A] was denied access to sector\"[name]\"")
		return 0
	return 1

/obj/effect/map/Crossed(atom/movable/A)
	testing("[A] has entered sector\"[name]\"")

/obj/effect/map/Uncrossed(atom/movable/A)
	testing("[A] has left sector\"[name]\"")

/obj/effect/map/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	anchored = 1

/obj/effect/map/ship
	name = "generic ship"
	desc = "Space faring vessel."
	density = 1

/obj/effect/map/ship/relaymove(mob/user, direction)
	step(src, direction)

//===================================================================================
//Hook for building overmap
//===================================================================================
var/global/list/map_sectors = list()

/hook/startup/proc/build_map()
	testing("Building overmap...")
	var/obj/effect/mapinfo/data
	for(var/level in 1 to world.maxz)
		data = locate("sector[level]")
		if (data)
			testing("Located sector \"[data.name]\" at [data.mapx],[data.mapy] corresponding to zlevel [level]")
			map_sectors["[level]"] = new data.obj_type(data)
	return 1
