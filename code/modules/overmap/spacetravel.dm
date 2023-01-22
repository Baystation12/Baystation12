//list used to cache empty zlevels to avoid needless map bloat
var/global/list/cached_space = list()

//Space stragglers go here

/obj/effect/overmap/visitable/sector/temporary
	name = "Deep Space"
	invisibility = 101
	known = FALSE

/obj/effect/overmap/visitable/sector/temporary/New(var/nx, var/ny, var/nz)
	map_z += nz
	testing("Temporary sector at zlevel [nz] was created.")
	register(nx, ny)

/obj/effect/overmap/visitable/sector/temporary/Destroy()
	unregister()
	testing("Temporary sector at [x],[y] was deleted. zlevel [map_z[1]] is no longer accessible.")
	return ..()

/obj/effect/overmap/visitable/sector/temporary/proc/register(var/nx, var/ny)
	forceMove(locate(nx, ny, GLOB.using_map.overmap_z))
	map_sectors["[map_z[1]]"] = src
	testing("Temporary sector at zlevel [map_z[1]] moved to coordinates [x],[y]")

/obj/effect/overmap/visitable/sector/temporary/proc/unregister()
	// Note that any structures left in the zlevel will remain there, and may later turn up at completely different
	// coordinates if this temporary sector is recycled. Perhaps everything remaining in the zlevel should be destroyed?
	testing("Caching temporary sector for future use, corresponding zlevel is [map_z[1]], previous coordinates were [x],[y]")
	map_sectors.Remove(src)
	src.forceMove(null)
	cached_space += src

/obj/effect/overmap/visitable/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at [map_z[1]] can die.")
	for(var/mob/M in GLOB.player_list)
		if(M != observer && (M.z in map_z))
			testing("There are people on it.")
			return 0
	return 1

/proc/get_deepspace(x,y)
	var/turf/map = locate(x,y,GLOB.using_map.overmap_z)
	var/obj/effect/overmap/visitable/sector/temporary/res
	for(var/obj/effect/overmap/visitable/sector/temporary/O in map)
		res = O
		break
	if(istype(res))
		return res
	else if(cached_space.len)
		res = cached_space[cached_space.len]
		cached_space -= res
		res.register(x, y)
		return res
	else
		return new /obj/effect/overmap/visitable/sector/temporary(x, y, ++world.maxz)

/atom/movable/proc/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	return TRUE

/mob/lost_in_space()
	return isnull(client)

/mob/living/carbon/human/lost_in_space()
	return isnull(client) && !last_ckey && stat == DEAD

/proc/overmap_spacetravel(var/turf/space/T, var/atom/movable/A)
	if (!T || !A)
		return

	var/obj/effect/overmap/visitable/M = map_sectors["[T.z]"]
	if (!M)
		return

	if(A.lost_in_space())
		if(!QDELETED(A))
			qdel(A)
		return

	var/nx = 1
	var/ny = 1
	var/nz = 1

	if(T.x <= TRANSITIONEDGE)
		nx = world.maxx - TRANSITIONEDGE - 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
		nx = TRANSITIONEDGE + 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (T.y <= TRANSITIONEDGE)
		ny = world.maxy - TRANSITIONEDGE -2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
		ny = TRANSITIONEDGE + 2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	testing("[A] spacemoving from [M] ([M.x], [M.y]).")

	var/turf/map = locate(M.x,M.y,GLOB.using_map.overmap_z)
	var/obj/effect/overmap/visitable/TM
	for(var/obj/effect/overmap/visitable/O in map)
		if(O != M && O.in_space && prob(50))
			TM = O
			break
	if(!TM)
		TM = get_deepspace(M.x,M.y)
	nz = pick(TM.map_z)

	var/turf/dest = locate(nx,ny,nz)
	if(dest)
		A.forceMove(dest)
		if(ismob(A))
			var/mob/D = A
			if(D.pulling)
				D.pulling.forceMove(dest)

	if(istype(M, /obj/effect/overmap/visitable/sector/temporary))
		var/obj/effect/overmap/visitable/sector/temporary/source = M
		if (source != TM && source.can_die())
			source.unregister()
