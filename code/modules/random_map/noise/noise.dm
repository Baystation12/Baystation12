// NOTE: Maps generated with this datum as the base are not DIRECTLY compatible with maps generated from
// the automata, building or maze datums, as the noise generator uses 0-255 instead of WALL_CHAR/FLOOR_CHAR.
// TODO: Consider writing a conversion proc for noise-to-regular maps.
/datum/random_map/noise
	descriptor = "distribution map"
	var/cell_range = 255            // These values are used to seed ore values rather than to determine a turf type.
	var/cell_smooth_amt = 5
	var/random_variance_chance = 25 // % chance of applying random_element.
	var/random_element = 0.5        // Determines the variance when smoothing out cell values.
	var/cell_base                   // Set in New()
	var/initial_cell_range          // Set in New()
	var/smoothing_iterations = 0

/datum/random_map/noise/New()
	initial_cell_range = cell_range/5
	cell_base = cell_range/2
	..()

/datum/random_map/noise/set_map_size()
	// Make sure the grid is a square with limits that are
	// (n^2)+1, otherwise diamond-square won't work.
	if(!IsPowerOfTwo((limit_x-1)))
		limit_x = RoundUpToPowerOfTwo(limit_x) + 1
	if(!IsPowerOfTwo((limit_y-1)))
		limit_y = RoundUpToPowerOfTwo(limit_y) + 1
	// Sides must be identical lengths.
	if(limit_x > limit_y)
		limit_y = limit_x
	else if(limit_y > limit_x)
		limit_x = limit_y
	..()

// Diamond-square algorithm.
/datum/random_map/noise/seed_map()
	// Instantiate the grid.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			map[TRANSLATE_COORD(x,y)] = 0

	// Now dump in the actual random data.
	map[TRANSLATE_COORD(1,1)]             = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(1,limit_y)]       = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(limit_x,limit_y)] = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(limit_x,1)]       = cell_base+rand(initial_cell_range)

/datum/random_map/noise/generate_map()
	// Begin recursion.
	subdivide(1,1,1,(limit_y-1))

/datum/random_map/noise/get_map_char(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	return "[val]"

/datum/random_map/noise/proc/subdivide(var/iteration,var/x,var/y,var/input_size)

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
	map[TRANSLATE_COORD(x+hsize,y+isize)] = round((\
		map[TRANSLATE_COORD(x,y+isize)] +          \
		map[TRANSLATE_COORD(x+isize,y+isize)] \
		)/2)

	map[TRANSLATE_COORD(x+hsize,y)] = round((  \
		map[TRANSLATE_COORD(x,y)] +            \
		map[TRANSLATE_COORD(x+isize,y)]   \
		)/2)

	map[get_map_cell(x,y+hsize)] = round((  \
		map[TRANSLATE_COORD(x,y+isize)] + \
		map[TRANSLATE_COORD(x,y)]              \
		)/2)

	map[TRANSLATE_COORD(x+isize,y+hsize)] = round((  \
		map[TRANSLATE_COORD(x+isize,y+isize)] + \
		map[TRANSLATE_COORD(x+isize,y)]        \
		)/2)

	// Centre value becomes the average of all other values + possible random variance.
	var/current_cell = TRANSLATE_COORD(x+hsize,y+hsize)
	map[current_cell] = round(( \
		map[TRANSLATE_COORD(x+hsize,y+isize)] + \
		map[TRANSLATE_COORD(x+hsize,y)] + \
		map[TRANSLATE_COORD(x,y+hsize)] + \
		map[TRANSLATE_COORD(x+isize,y)] \
		)/4)

	if(prob(random_variance_chance))
		map[current_cell] *= (rand(1,2)==1 ? (1.0-random_element) : (1.0+random_element))
		map[current_cell] = max(0,min(cell_range,map[current_cell]))

 	// Recurse until size is too small to subdivide.
	if(isize>3)
		if(!priority_process) 
			CHECK_TICK
		iteration++
		subdivide(iteration, x,       y,       hsize)
		subdivide(iteration, x+hsize, y,       hsize)
		subdivide(iteration, x,       y+hsize, hsize)
		subdivide(iteration, x+hsize, y+hsize, hsize)

/datum/random_map/noise/cleanup()
	var/is_not_border_left
	var/is_not_border_right
	for(var/i = 1 to smoothing_iterations)
		var/list/next_map[limit_x*limit_y]
		for(var/x = 1 to limit_x)
			for(var/y = 1 to limit_y)
				var/current_cell = TRANSLATE_COORD(x,y)
				next_map[current_cell] = map[current_cell]
				var/val_count = 1
				var/total = map[current_cell]

				is_not_border_left = (x != 1)
				is_not_border_right = (x != limit_x)

				// Center row. Center value's already been done above.
				if (is_not_border_left)
					total += map[TRANSLATE_COORD(x - 1, y)]
					++val_count
				if (is_not_border_right)
					total += map[TRANSLATE_COORD(x + 1, y)]
					++val_count

				if (y != 1) // top row
					total += map[TRANSLATE_COORD(x, y - 1)]
					++val_count
					if (is_not_border_left)
						total += map[TRANSLATE_COORD(x - 1, y - 1)]
						++val_count
					if (is_not_border_right)
						total += map[TRANSLATE_COORD(x + 1, y - 1)]
						++val_count

				if (y != limit_y) // bottom row
					total += map[TRANSLATE_COORD(x, y + 1)]
					++val_count
					if (is_not_border_left)
						total += map[TRANSLATE_COORD(x - 1, y + 1)]
						++val_count
					if (is_not_border_right)
						total += map[TRANSLATE_COORD(x + 1, y + 1)]
						++val_count

				total = round(total/val_count)

				if(abs(map[current_cell]-total) <= cell_smooth_amt)
					map[current_cell] = total
				else if(map[current_cell] < total)
					map[current_cell]+=cell_smooth_amt
				else if(map[current_cell] < total)
					map[current_cell]-=cell_smooth_amt
				map[current_cell] = max(0,min(cell_range,map[current_cell]))
		map = next_map