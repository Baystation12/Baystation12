#define MIN_SURFACE_COUNT 1000
#define MAX_SURFACE_COUNT 5000
#define MIN_RARE_COUNT 1000
#define MAX_RARE_COUNT 5000
#define MIN_DEEP_COUNT 100
#define MAX_DEEP_COUNT 300

#define RESOURCE_HIGH_MAX 4
#define RESOURCE_HIGH_MIN 2
#define RESOURCE_MID_MAX 3
#define RESOURCE_MID_MIN 1
#define RESOURCE_LOW_MAX 1
#define RESOURCE_LOW_MIN 0

/*
Surface minerals:
	silicates
	iron
	gold
	silver
Rare minerals:
	uranium
	diamond
Deep minerals:
	phoron
	osmium (platinum)
	tritium (hydrogen)
*/

/datum/random_map/ore

	descriptor = "resource distribution map"
	real_size = 65   // Must be (power of 2)+1 for diamond-square.
	cell_range = 255 // These values are used to seed ore values rather than to determine a turf type.
	iterations = 0   // We'll handle that on our end.

	var/chunk_size = 4              // Size each cell represents on map
	var/random_variance_chance = 25 // % chance of applying random_element.
	var/random_element = 0.5        // Determines the variance when smoothing out cell values.
	var/deep_val = 50
	var/rare_val = 100

/datum/random_map/ore/New()
	deep_val = cell_range*0.60
	rare_val = cell_range*0.40
	..()

/datum/random_map/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			var/current_cell = get_map_cell(x,y)
			if(!within_bounds(current_cell))
				continue
			switch(map[current_cell])
				if(0 to rare_val)
					surface_count++
				if(rare_val to deep_val)
					rare_count++
				if(deep_val to INFINITY)
					deep_count++

	if((surface_count < MIN_SURFACE_COUNT) || (surface_count > MAX_SURFACE_COUNT))
		world << "<span class='danger'>Insufficient surface minerals. Rerolling...</span>"
		return 0
	else if((rare_count < MIN_RARE_COUNT) || (rare_count > MAX_RARE_COUNT))
		world << "<span class='danger'>Insufficient rare minerals. Rerolling...</span>"
		return 0
	else if((deep_count < MIN_DEEP_COUNT) || (deep_count > MAX_DEEP_COUNT))
		world << "<span class='danger'>Insufficient deep minerals. Rerolling...</span>"
		return 0
	else
		return 1

//Halfassed diamond-square algorithm with some fuckery since it's a single dimension array.
/datum/random_map/ore/seed_map()

	// Instantiate the grid.
	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			map[get_map_cell(x,y)] = -1

	// Now dump in the actual random data.
	size = real_size-1
	map[get_map_cell(1,1)]                 = (cell_range/3)+rand(cell_range/5)
	map[get_map_cell(1,real_size)]         = (cell_range/3)+rand(cell_range/5)
	map[get_map_cell(real_size,real_size)] = (cell_range/3)+rand(cell_range/5)
	map[get_map_cell(real_size,1)]         = (cell_range/3)+rand(cell_range/5)
	iterate(1,1,1,size) // Handle iteration here since we use different args to parent.

/datum/random_map/ore/display_map(atom/user)

	if(!user)
		user = world

	for(var/x = 1, x <= real_size, x++)
		var/line = ""
		for(var/y = 1, y <= real_size, y++)
			var/current_cell = get_map_cell(x,y)
			if(within_bounds(current_cell) && map[current_cell])
				switch(map[current_cell])
					if(0 to rare_val)
						line += "S"
					if(rare_val to deep_val)
						line += "R"
					if(deep_val to INFINITY)
						line += "D"
					else
						line += "?"
			else
				line += "X"
		user << line

/datum/random_map/ore/iterate(var/iteration,var/x,var/y,var/input_size)

	// Infinite loop check!
	if(iteration>=iterate_before_fail)
		world << "<span class='danger'>Iteration count exceeded, aborting.</span>"
		return

	// Make sure we're using the right size for our subdivisions.
	size = input_size
	var/hsize = round(size/2)

	/*
	(x,y+size)-----(x+hsize,y+size)-----(x+size,y+size)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y+hsize)----(x+hsize,y+hsize)----(x+size,y)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y)----------(x+hsize,y)----------(x+size,y)
	*/
	// Central edge values become average of corners.
	map[get_map_cell(x+hsize,y+size)] = round((map[get_map_cell(x,y+size)] + map[get_map_cell(x+size,y+size)])/2)
	map[get_map_cell(x+hsize,y)] =      round((map[get_map_cell(x,y)]+map[get_map_cell(x+size,y)])/2)
	map[get_map_cell(x,y+hsize)] =      round((map[get_map_cell(x,y+size)]+map[get_map_cell(x,y)])/2)
	map[get_map_cell(x+size,y)] =       round((map[get_map_cell(x+size,y+size)]+map[get_map_cell(x+size,y)])/2)

	// Centre value becomes the average of all other values + possible random variance.
	var/current_cell = get_map_cell(x+hsize,y+hsize)
	map[current_cell] =	round((map[get_map_cell(x+hsize,y+size)]+map[get_map_cell(x+hsize,y)]+map[get_map_cell(x,y+hsize)]+map[get_map_cell(x+size,y)])/4)
	if(prob(random_variance_chance))
		map[current_cell] *= (rand(1) ? (1.0-random_element) : (1.0+random_element))
		map[current_cell] = max(0,min(cell_range,map[current_cell]))

	// Recurse until size is too small to subdivide.
	if(size>3)
		iteration++
		iterate(iteration, x,       y,       hsize)
		iterate(iteration, x+hsize, y,       hsize)
		iterate(iteration, x,       y+hsize, hsize)
		iterate(iteration, x+hsize, y+hsize, hsize)

/datum/random_map/ore/apply_to_turf(var/x,var/y,var/turf/T)

	var/tx = (x-1)*chunk_size
	var/ty = (y-1)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		if(ty+i>limit_y)
			continue
		for(var/j=0,j<chunk_size,j++)
			if(tx+j>limit_x)
				continue

			T = locate(tx+j, ty+i, origin_z)
			if(!T || !T.has_resources)
				continue

			T.resources = list()
			T.resources["silicates"] = rand(3,5)
			T.resources["carbonaceous rock"] = rand(3,5)

			switch(map[get_map_cell(x,y)])
				if(0 to 100)
					T.resources["iron"] =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
					T.resources["gold"] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
					T.resources["silver"] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
					T.resources["uranium"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
					T.resources["diamond"] =  0
					T.resources["phoron"] =   0
					T.resources["osmium"] =   0
					T.resources["hydrogen"] = 0
				if(100 to 124)
					T.resources["gold"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["silver"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["uranium"] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["phoron"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["osmium"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["hydrogen"] = 0
					T.resources["diamond"] =  0
					T.resources["iron"] =     0
				if(125 to 255)
					T.resources["uranium"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
					T.resources["diamond"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
					T.resources["phoron"] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
					T.resources["osmium"] =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
					T.resources["hydrogen"] = rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
					T.resources["iron"] =     0
					T.resources["gold"] =     0
					T.resources["silver"] =   0
	return

/datum/random_map/ore/cleanup()
	return 1