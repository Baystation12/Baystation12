#define MIN_SURFACE_COUNT 500
#define MIN_RARE_COUNT 200
#define MIN_DEEP_COUNT 100
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
	real_size = 65         // Must be (power of 2)+1 for diamond-square.
	cell_range = 255       // These values are used to seed ore values rather than to determine a turf type.
	iterations = 0        // We'll handle iterating on our end (recursive, with args).

	var/chunk_size = 4              // Size each cell represents on map
	var/random_variance_chance = 25 // % chance of applying random_element.
	var/random_element = 0.5        // Determines the variance when smoothing out cell values.
	var/deep_val = 0.8              // Threshold for deep metals, set in new as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare metal, set in new as percentage of cell_range.
	var/cell_base          // Set in New()
	var/initial_cell_range // Set in New()

/datum/random_map/ore/New()
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val

	initial_cell_range = cell_range/5
	cell_base = cell_range/2
	..()

/datum/random_map/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < MIN_SURFACE_COUNT)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < MIN_RARE_COUNT)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < MIN_DEEP_COUNT)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

//Halfassed diamond-square algorithm with some fuckery since it's a single dimension array.
/datum/random_map/ore/seed_map()

	// Instantiate the grid.
	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			map[get_map_cell(x,y)] = 0

	// Now dump in the actual random data.
	map[get_map_cell(1,1)]                 = cell_base+rand(initial_cell_range)
	map[get_map_cell(1,real_size)]         = cell_base+rand(initial_cell_range)
	map[get_map_cell(real_size,real_size)] = cell_base+rand(initial_cell_range)
	map[get_map_cell(real_size,1)]         = cell_base+rand(initial_cell_range)
	iterate(1,1,1,(real_size-1)) // Start the recursion here.

/datum/random_map/ore/display_map(atom/user)

	if(!user)
		user = world

	for(var/x = 1, x <= real_size, x++)
		var/line = ""
		for(var/y = 1, y <= real_size, y++)
			var/current_cell = get_map_cell(x,y)
			if(within_bounds(current_cell) && map[current_cell])
				if(map[current_cell] < rare_val)
					line += "S"
				else if(map[current_cell] < deep_val)
					line += "R"
				else
					line += "D"
			else
				line += "X"
		user << line

/datum/random_map/ore/iterate(var/iteration,var/x,var/y,var/input_size)

	// Infinite loop check!
	if(iteration>=iterate_before_fail)
		admin_notice("<span class='danger'>Iteration count exceeded, aborting.</span>", R_DEBUG)
		return

	var/isize = input_size
	var/hsize = round(input_size/2)

	/*
	(x,y+isize)----(x+hsize,y+isize)----(x+size,y+isize)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y+hsize)----(x+hsize,y+hsize)----(x+isize,y)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y)----------(x+hsize,y)----------(x+isize,y)
	*/
	// Central edge values become average of corners.
	map[get_map_cell(x+hsize,y+isize)] = round((\
		map[get_map_cell(x,y+isize)] +          \
		map[get_map_cell(x+isize,y+isize)] \
		)/2)

	map[get_map_cell(x+hsize,y)] = round((  \
		map[get_map_cell(x,y)] +            \
		map[get_map_cell(x+isize,y)]   \
		)/2)

	map[get_map_cell(x,y+hsize)] = round((  \
		map[get_map_cell(x,y+isize)] + \
		map[get_map_cell(x,y)]              \
		)/2)

	map[get_map_cell(x+isize,y+hsize)] = round((  \
		map[get_map_cell(x+isize,y+isize)] + \
		map[get_map_cell(x+isize,y)]        \
		)/2)

	// Centre value becomes the average of all other values + possible random variance.
	var/current_cell = get_map_cell(x+hsize,y+hsize)
	map[current_cell] =	round((map[get_map_cell(x+hsize,y+isize)]+map[get_map_cell(x+hsize,y)]+map[get_map_cell(x,y+hsize)]+map[get_map_cell(x+isize,y)])/4)

	if(prob(random_variance_chance))
		map[current_cell] *= (rand(1,2)==1 ? (1.0-random_element) : (1.0+random_element))
		map[current_cell] = max(0,min(cell_range,map[current_cell]))

 	// Recurse until size is too small to subdivide.
	if(isize>3)
		sleep(-1)
		iteration++
		iterate(iteration, x,       y,       hsize)
		iterate(iteration, x+hsize, y,       hsize)
		iterate(iteration, x,       y+hsize, hsize)
		iterate(iteration, x+hsize, y+hsize, hsize)

/datum/random_map/ore/apply_to_map()
	for(var/x = 0, x < real_size, x++)
		if((origin_x + x) > limit_x) continue
		for(var/y = 0, y < real_size, y++)
			if((origin_y + y) > limit_y) continue
			sleep(-1)
			apply_to_turf(x,y)

/datum/random_map/ore/apply_to_turf(var/x,var/y)

	var/tx = origin_x+((x-1)*chunk_size)
	var/ty = origin_y+((y-1)*chunk_size)

	for(var/i=0,i<chunk_size,i++)
		if(ty+i>limit_y)
			continue
		for(var/j=0,j<chunk_size,j++)
			if(tx+j>limit_x)
				continue

			var/turf/T = locate(tx+j, ty+i, origin_z)
			if(!T || !T.has_resources)
				continue

			sleep(-1)

			T.resources = list()
			T.resources["silicates"] = rand(3,5)
			T.resources["carbonaceous rock"] = rand(3,5)

			var/current_cell = map[get_map_cell(x,y)]
			if(current_cell < rare_val)      // Surface metals.
				T.resources["iron"] =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources["gold"] =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["silver"] =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["uranium"] =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources["diamond"] =  0
				T.resources["phoron"] =   0
				T.resources["osmium"] =   0
				T.resources["hydrogen"] = 0
			else if(current_cell < deep_val) // Rare metals.
				T.resources["gold"] =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["silver"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["uranium"] =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["phoron"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["osmium"] =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources["hydrogen"] = 0
				T.resources["diamond"] =  0
				T.resources["iron"] =     0
			else                             // Deep metals.
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

#undef MIN_SURFACE_COUNT
#undef MIN_RARE_COUNT
#undef MIN_DEEP_COUNT
#undef RESOURCE_HIGH_MAX
#undef RESOURCE_HIGH_MIN
#undef RESOURCE_MID_MAX
#undef RESOURCE_MID_MIN
#undef RESOURCE_LOW_MAX
#undef RESOURCE_LOW_MIN