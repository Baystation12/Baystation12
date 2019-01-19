
// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	map_datas["[src.z]"] = src
	. = ..()

/obj/effect/landmark/map_data/Initialize()
	. = ..()
	if(name == "Map Data")
		//oh no! we have a default name. just check nearby
		//this wont be able to handle multiz ships/planets, but it will work for 1z ships (eg NPCs)
		overmap_object = locate() in range(src, 7)
	else
		overmap_object = locate(name)

	if(overmap_object)
		name = overmap_object.tag
		overmap_object.link_zlevel(src)

/proc/HasAbove(var/z)
	var/obj/effect/landmark/map_data/curz = map_datas["[z]"]
	if(curz)
		return curz.above ? 1 : 0
	return 0

/proc/HasBelow(var/z)
	var/obj/effect/landmark/map_data/curz = map_datas["[z]"]
	if(curz)
		return curz.below ? 1 : 0

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null

	var/obj/effect/landmark/map_data/curz = map_datas["[atom.z]"]
	if(curz && curz.above)
		return locate(atom.x, atom.y, curz.above.z)

	return null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null

	var/obj/effect/landmark/map_data/curz = map_datas["[atom.z]"]
	if(curz && curz.below)
		return locate(atom.x, atom.y, curz.below.z)

	return null

//This proc is using the list OR, so we don't need to modify it. -Bloxgate, June 2018
/proc/GetConnectedZlevels(z)
	var/obj/effect/overmap/overmap_object = map_sectors["[z]"]
	if(overmap_object)
		return overmap_object.map_z

	return list(z)

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || map_sectors["[zA]"] == map_sectors["[zB]"]


/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)
