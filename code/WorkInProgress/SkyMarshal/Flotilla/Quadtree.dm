#define NE 1
#define NW 2
#define SE 3
#define SW 4


physics_tree
	var/list/nodes[4]
	var/simulated_volume = 0
	var/x = 0
	var/y = 0
	var/toroidal = 0


	New(_x, _y, volume, _toroidal = 0)
		ASSERT(volume > 0) //cannot be 0 or negative
		. = ..()
		simulated_volume = volume
		x = _x
		y = _y
		toroidal = _toroidal


	Del()
		for(var/physics_node/node in nodes)
			node.SoftDelete()
		. = ..()


	proc/Insert(var/frame/frame)  //God what a horror of a function.  Determines all nodes an object should be inserted into and does just that.
		if(toroidal)
			if(istype(frame))
				if(frame.y >= y)
					if(frame.x >= x)
						InsertNE(frame) //Added to the NE quadrant, lets check for overlap.

						if( frame.x - frame.radius < x || frame.x + frame.radius >= simulated_volume/2 + x )
							if( frame.y - frame.radius < y || frame.y + frame.radius >= simulated_volume/2 + y ) //In all four leaves.
								InsertNW(frame)
								InsertSE(frame)
								if( ( frame.y - frame.radius/SQRT_OF_TWO < y || frame.y + frame.radius/SQRT_OF_TWO >= simulated_volume/2 + y ) \
								&& ( frame.x - frame.radius/SQRT_OF_TWO < x || frame.x + frame.radius/SQRT_OF_TWO >= simulated_volume/2 + x ) ) //Check if we are in the fourth quadrant.
									InsertSW(frame)
							else					//In the west as well.
								InsertNW(frame)
						else if( frame.y - frame.radius < y || frame.y + frame.radius >= simulated_volume/2 + y ) //Only to the south.
							InsertSE(frame)

					else
						InsertNW(frame) //Added to the NW quadrant, lets check for overlap.

						if( frame.x + frame.radius >= x || frame.x - frame.radius < -simulated_volume/2 + x )
							if( frame.y - frame.radius < y || frame.y + frame.radius >= simulated_volume/2 + y ) //In all four leaves.
								InsertNE(frame)
								InsertSW(frame)
								if( ( frame.y - frame.radius/SQRT_OF_TWO < y || frame.y + frame.radius/SQRT_OF_TWO >= simulated_volume/2 + y ) \
								&& ( frame.x + frame.radius/SQRT_OF_TWO >= x || frame.x - frame.radius/SQRT_OF_TWO < -simulated_volume/2 + x ) ) //Check if we are in the fourth quadrant.
									InsertSE(frame)
							else					//In the east as well.
								InsertNE(frame)
						else if( frame.y - frame.radius < y || frame.y + frame.radius >= simulated_volume/2 + y ) //Only to the south.
							InsertSW(frame)

				else
					if(frame.x >= x)
						InsertSE(frame) //Added to the SE quadrant, lets check for overlap.

						if( frame.x - frame.radius < x || frame.x + frame.radius >= simulated_volume/2 + x )
							if( frame.y + frame.radius >= y || frame.y - frame.radius < -simulated_volume/2 + y ) //In all four leaves.
								InsertNE(frame)
								InsertSW(frame)
								if( ( frame.y + frame.radius/SQRT_OF_TWO >= y || frame.y - frame.radius/SQRT_OF_TWO < -simulated_volume/2 + y ) \
								&& ( frame.x - frame.radius/SQRT_OF_TWO < x || frame.x + frame.radius/SQRT_OF_TWO >= simulated_volume/2 + x ) ) //Check if we are in the fourth quadrant.
									InsertNW(frame)
							else					//In the west as well.
								InsertSW(frame)
						else if( frame.y + frame.radius >= y || frame.y - frame.radius < -simulated_volume/2 + y ) //Only to the north.
							InsertNE(frame)

					else
						InsertSW(frame) //Added to the SW quadrant, lets check for overlap.

						if( frame.x + frame.radius >= x || frame.x - frame.radius < -simulated_volume/2 + x )
							if( frame.y + frame.radius >= y || frame.y - frame.radius < -simulated_volume/2 + y ) //In all four leaves.
								InsertSE(frame)
								InsertNW(frame)
								if( ( frame.y + frame.radius/SQRT_OF_TWO >= y || frame.y - frame.radius/SQRT_OF_TWO < -simulated_volume/2 + y ) \
								&& ( frame.x + frame.radius/SQRT_OF_TWO >= x || frame.x - frame.radius/SQRT_OF_TWO < -simulated_volume/2 + x ) ) //Check if we are in the fourth quadrant.
									InsertNE(frame)
							else					//In the east as well.
								InsertSE(frame)
						else if( frame.y + frame.radius >= y || frame.y - frame.radius < -simulated_volume/2 + y ) //Only to the north.
							InsertNW(frame)

			else if(istype(frame, /solar_system))
				var/solar_system/solar_frame = frame
				if(solar_frame.y >= y)
					if(solar_frame.x >= x)

						InsertNE(solar_frame) //Added to the NE quadrant, lets check for overlap.

						if( solar_frame.x - solar_frame.size_of_quadtree/2 < x || solar_frame.x + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + x )
							if( solar_frame.y - solar_frame.size_of_quadtree/2 < y || solar_frame.y + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + y ) //In all four leaves.
								InsertNW(frame)
								InsertSE(frame)
								InsertSW(frame)
							else					//In the west as well.
								InsertNW(frame)
						else if( solar_frame.y - solar_frame.size_of_quadtree/2 < y || solar_frame.y + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + y ) //Only to the south.
							InsertSE(frame)

					else

						InsertNW(solar_frame) //Added to the NW quadrant, lets check for overlap.

						if( solar_frame.x + solar_frame.size_of_quadtree/2 >= x || solar_frame.x - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + x )
							if( solar_frame.y - solar_frame.size_of_quadtree/2 < y || solar_frame.y + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + y ) //In all four leaves.
								InsertNE(frame)
								InsertSE(frame)
								InsertSW(frame)
							else					//In the east as well.
								InsertNE(frame)
						else if( solar_frame.y - solar_frame.size_of_quadtree/2 < y || solar_frame.y + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + y ) //Only to the south.
							InsertSW(frame)

				else
					if(solar_frame.x >= x)

						InsertSE(solar_frame) //Added to the SE quadrant, lets check for overlap.

						if( solar_frame.x - solar_frame.size_of_quadtree/2 < x || solar_frame.x + solar_frame.size_of_quadtree/2 >= simulated_volume/2 + x )
							if( solar_frame.y + solar_frame.size_of_quadtree/2 >= y || solar_frame.y - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + y ) //In all four leaves.
								InsertNE(frame)
								InsertNW(frame)
								InsertSW(frame)
							else					//In the west as well.
								InsertSW(frame)
						else if( solar_frame.y + solar_frame.size_of_quadtree/2 >= y || solar_frame.y - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + y ) //Only to the north.
							InsertNE(frame)

					else

						InsertSW(solar_frame) //Added to the NW quadrant, lets check for overlap.

						if( solar_frame.x + solar_frame.size_of_quadtree/2 >= x || solar_frame.x - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + x )
							if( solar_frame.y + solar_frame.size_of_quadtree/2 >= y || solar_frame.y - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + y ) //In all four leaves.
								InsertNE(frame)
								InsertSE(frame)
								InsertNW(frame)
							else					//In the east as well.
								InsertSE(frame)
						else if( solar_frame.y + solar_frame.size_of_quadtree/2 >= y || solar_frame.y - solar_frame.size_of_quadtree/2 < -simulated_volume/2 + y ) //Only to the north.
							InsertNW(frame)
		else if( istype(frame) )
			if( frame.y > y ) //Preform checks to find the correct node, and make one if needed.
				if( frame.x > x )
					InsertNE(frame) //Added to the NE quadrant, lets check for overlap.

					if( frame.x - frame.radius < x )
						if( frame.y - frame.radius < y ) //In all four leaves.
							InsertNW(frame)
							InsertSE(frame)
							if( frame.y - frame.radius/SQRT_OF_TWO < y && frame.x - frame.radius/SQRT_OF_TWO < x )
								InsertSW(frame)
						else					//In the west as well.
							InsertNW(frame)
					else if( frame.y - frame.radius < y ) //Only to the south.
						InsertSE(frame)

				else
					InsertNW(frame) //Added to the NW quadrant, lets check for overlap.

					if( frame.x + frame.radius >= x )
						if( frame.y - frame.radius < y ) //In all four leaves.
							InsertNE(frame)
							InsertSW(frame)
							if( frame.y - frame.radius/SQRT_OF_TWO < y && frame.x + frame.radius/SQRT_OF_TWO >= x )
								InsertSE(frame)
						else					//In the east as well.
							InsertNE(frame)
					else if( frame.y - frame.radius < y ) //Only to the south.
						InsertSW(frame)

			else
				if( frame.x > x )
					InsertSE(frame) //Added to the SE quadrant, lets check for overlap.

					if( frame.x - frame.radius < x )
						if( frame.y + frame.radius >= y ) //In all four leaves.
							InsertNE(frame)
							InsertSW(frame)
							if( frame.y + frame.radius/SQRT_OF_TWO >= y && frame.x - frame.radius/SQRT_OF_TWO < x )
								InsertNW(frame)
						else					//In the west as well.
							InsertSW(frame)
					else if( frame.y + frame.radius >= y ) //Only to the north.
						InsertNE(frame)

				else
					InsertSW(frame) //Added to the SW quadrant, lets check for overlap.

					if( frame.x + frame.radius >= x )
						if( frame.y + frame.radius >= y ) //In all four leaves.
							InsertNW(frame)
							InsertSE(frame)
							if( frame.y + frame.radius/SQRT_OF_TWO >= y && frame.x + frame.radius/SQRT_OF_TWO >= x )
								InsertNE(frame)
						else					//In the east as well.
							InsertSE(frame)
					else if( frame.y + frame.radius >= y ) //Only to the north.
						InsertNW(frame)


	proc/InsertNE(var/frame/frame)
		var/physics_node/node = nodes[NE]
		if(!node)
			node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x, y, simulated_volume/2)
			nodes[NE] = node
		node.Insert(frame)


	proc/InsertNW(var/frame/frame)
		var/physics_node/node = nodes[NW]
		if(!node)
			node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x - simulated_volume/2, y, simulated_volume/2)
			nodes[NW] = node
		node.Insert(frame)


	proc/InsertSE(var/frame/frame)
		var/physics_node/node = nodes[SE]
		if(!node)
			node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x, y - simulated_volume/2, simulated_volume/2)
			nodes[SE] = node
		node.Insert(frame)


	proc/InsertSW(var/frame/frame)
		var/physics_node/node = nodes[SW]
		if(!node)
			node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x - simulated_volume/2, y - simulated_volume/2, simulated_volume/2)
			nodes[SW] = node
		node.Insert(frame)

	proc/Find(target_x, target_y) //A function to find what leaf a position would fall in.
		var/physics_node/node
		if(target_y > y)
			if(target_x > x)
				if(nodes[NE])
					node = nodes[NE]
					return node.Find(target_x, target_y)
				else
					var/physics_node/node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x, y, simulated_volume/2)
					nodes[NE] = node
					return node
			else
				if(nodes[NW])
					node = nodes[NW]
					return node.Find(target_x, target_y)
				else
					var/physics_node/node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x - simulated_volume/2, y, simulated_volume/2)
					nodes[NW] = node
					return node
		else
			if(target_x > x)
				if(nodes[SE])
					node = nodes[SE]
					return node.Find(target_x, target_y)
				else
					var/physics_node/node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x, y - simulated_volume/2, simulated_volume/2)
					nodes[SE] = node
					return node
			else
				if(nodes[SW])
					node = nodes[SW]
					return node.Find(target_x, target_y)
				else
					var/physics_node/node = new /physics_node(src, QUADTREE_MAX_LIMIT, QUADTREE_MAX_CHILDREN, x - simulated_volume/2, y - simulated_volume/2, simulated_volume/2)
					nodes[SW] = node
					return node





