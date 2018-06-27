// If you add a more comprehensive system, just untick this file.
// WARNING: Only works for up to 25 z-levels! (Update by Bloxgate, June 2018)
var/z_levels = 0 // Each bit represents a connection between adjacent levels.  So the first bit means levels 1 and 2 are connected.

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	ASSERT(height <= z)
	// Due to the offsets of how connections are stored v.s. how z-levels are indexed, some magic number silliness happened.
	for(var/i = (z - height) to (z - 2))
		//z_levels |= (1 << i)
		z_levels = zbitwiseOR(z_levels, zlsh(1,i))

/obj/effect/landmark/map_data/Initialize()
    ..()
    return INITIALIZE_HINT_QDEL

// The storage of connections between adjacent levels means some bitwise magic is needed.
/proc/HasAbove(var/z)
	if(z >= world.maxz || z > 24 || z < 1)
		return 0
	//return z_levels & (1 << (z - 1))
	return zbitwiseAND(z_levels, zlsh(1,(z-1)))

/proc/HasBelow(var/z)
	if(z > world.maxz || z > 25 || z < 2)
		return 0
	//return z_levels & (1 << (z - 2))
	return zbitwiseAND(z_levels, zlsh(1,(z-2)))

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

//This proc is using the list OR, so we don't need to modify it. -Bloxgate, June 2018
/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/proc/zlsh(x as num, y as num)
	return x * (2**y)

/proc/zbitwiseOR(x as num, y as num)
	if(x == 0) //log_2(0) is -infinity; we don't want to get an infinite loop
		return y
	else if (x == y)
		return x
	else
		var/sum = 0
		var/limit = max(x,y) //The limit of the summation should be the greater of the two
		for(var/n = 0; n <= Floor(log(2,limit)); n++)
			sum += (2 ** n) * (( (Floor(x/(2**n)) % 2) + (Floor(y/(2**n)) % 2) + \
				( (Floor(x/(2**n)) % 2) * (Floor(y/(2**n)) % 2) ) ) % 2)
		return sum

/proc/zbitwiseAND(x as num, y as num)
	if(x == 0)
		return 0
	else if (x == y)
		return x
	else
		var/sum = 0
		var/limit = max(x,y) //Limit should be the greater
		for(var/n = 0; n <= Floor(log(2,limit)); n++)
			sum += (2**n) * (Floor(x/(2**n)) % 2) * (Floor(y/(2**n)) % 2)
		return sum
