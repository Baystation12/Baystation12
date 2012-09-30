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




physics_node
	var/x = 0
	var/y = 0
	var/side_length = 0
	var/list/contents = list()
	var/list/frames_with_considerable_mass

	var/depth = 0
	var/max_children = 1

	var/physics_node/root
	var/list/nodes

	var/list/center_of_mass = list(0,0,0)
	var/center_of_mass_updated = 0
	var/last_merge_attempt = 0


	New(_root, _depth, _max_children, _x, _y, _side_length)
		ASSERT(_side_length > 0)
		. = ..()
		root = _root
		depth = _depth
		max_children = _max_children
		x = _x
		y = _y
		side_length = _side_length


	//Function to add a frame to a node.  Handles everything from subdividing the node to properly setting variables.
	proc/Insert(var/frame/frame)

		if(src in frame.nodes)
			return

	//If we are already subdivided, we must find the corect node in which to insert the frame.
	//We do this with come quick arithmatical checks to see which node it should be in, and create the ndoe if it does not exist yet.
		if(nodes)
			if( istype(frame) )
				if( frame.y > (y + side_length/2) ) //Preform checks to find the correct node, and make one if needed.
					if( frame.x > (x + side_length/2))
						InsertNE(frame) //Added to the NE quadrant, lets check for overlap.

						if( frame.x - frame.radius < (x + side_length/2) )
							if( frame.y - frame.radius < (y + side_length/2) ) //In all four leaves.
								InsertNW(frame)
								InsertSE(frame)
								if( frame.y - frame.radius/SQRT_OF_TWO < (y + side_length/2) && frame.x - frame.radius/SQRT_OF_TWO < (x + side_length/2) )
									InsertSW(frame)
							else					//In the west as well.
								InsertNW(frame)
						else if( frame.y - frame.radius < (x + side_length/2) ) //Only to the south.
							InsertSE(frame)

					else
						InsertNW(frame) //Added to the NW quadrant, lets check for overlap.

						if( frame.x + frame.radius >= (x + side_length/2) )
							if( frame.y - frame.radius < (y + side_length/2) ) //In all four leaves.
								InsertNE(frame)
								InsertSW(frame)
								if( frame.y - frame.radius/SQRT_OF_TWO < (y + side_length/2) && frame.x + frame.radius/SQRT_OF_TWO >= (x + side_length/2) )
									InsertSE(frame)
							else					//In the east as well.
								InsertNE(frame)
						else if( frame.y - frame.radius < (x + side_length/2) ) //Only to the south.
							InsertSW(frame)

				else
					if( frame.x > (x + side_length/2))
						InsertSE(frame) //Added to the SE quadrant, lets check for overlap.

						if( frame.x - frame.radius < (x + side_length/2) )
							if( frame.y + frame.radius >= (y + side_length/2) ) //In all four leaves.
								InsertNE(frame)
								InsertSW(frame)
								if( frame.y + frame.radius/SQRT_OF_TWO >= (y + side_length/2) && frame.x - frame.radius/SQRT_OF_TWO < (x + side_length/2) )
									InsertNW(frame)
							else					//In the west as well.
								InsertSW(frame)
						else if( frame.y + frame.radius >= (y + side_length/2) ) //Only to the north.
							InsertNE(frame)

					else
						InsertSW(frame) //Added to the SW quadrant, lets check for overlap.

						if( frame.x + frame.radius >= (x + side_length/2) )
							if( frame.y + frame.radius >= (y + side_length/2) ) //In all four leaves.
								InsertNW(frame)
								InsertSE(frame)
								if( frame.y + frame.radius/SQRT_OF_TWO >= (y + side_length/2) && frame.x + frame.radius/SQRT_OF_TWO >= (x + side_length/2) )
									InsertNE(frame)
							else					//In the east as well.
								InsertSE(frame)
						else if( frame.y + frame.radius >= (y + side_length/2) ) //Only to the north.
							InsertNW(frame)

			else if( istype(frame, /solar_system) )
				var/solar_system/solar_frame = frame
				if(solar_frame.y >= (y + side_length/2))
					if(solar_frame.x >= (x + side_length/2))

						InsertNE(solar_frame) //Added to the NE quadrant, lets check for overlap.

						if( solar_frame.x - solar_frame.size_of_quadtree/2 < (x + side_length/2) )
							if( solar_frame.y - solar_frame.size_of_quadtree/2 < (y + side_length/2) ) //In all four leaves.
								InsertNW(frame)
								InsertSE(frame)
								InsertSW(frame)
							else					//In the west as well.
								InsertNW(frame)
						else if( solar_frame.y - solar_frame.size_of_quadtree/2 < (y + side_length/2) ) //Only to the south.
							InsertSE(frame)

					else

						InsertNW(solar_frame) //Added to the NW quadrant, lets check for overlap.

						if( solar_frame.x + solar_frame.size_of_quadtree/2 >= (x + side_length/2) )
							if( solar_frame.y - solar_frame.size_of_quadtree/2 < (y + side_length/2) ) //In all four leaves.
								InsertNE(frame)
								InsertSE(frame)
								InsertSW(frame)
							else					//In the east as well.
								InsertNE(frame)
						else if( solar_frame.y - solar_frame.size_of_quadtree/2 < (y + side_length/2) ) //Only to the south.
							InsertSW(frame)

				else
					if(solar_frame.x >= x)

						InsertSE(solar_frame) //Added to the SE quadrant, lets check for overlap.

						if( solar_frame.x - solar_frame.size_of_quadtree/2 < (x + side_length/2) )
							if( solar_frame.y + solar_frame.size_of_quadtree/2 >= (y + side_length/2) ) //In all four leaves.
								InsertNE(frame)
								InsertNW(frame)
								InsertSW(frame)
							else					//In the west as well.
								InsertSW(frame)
						else if( solar_frame.y + solar_frame.size_of_quadtree/2 >= (y + side_length/2) ) //Only to the north.
							InsertNE(frame)

					else

						InsertSW(solar_frame) //Added to the NW quadrant, lets check for overlap.

						if( solar_frame.x + solar_frame.size_of_quadtree/2 >= (x + side_length/2) )
							if( solar_frame.y + solar_frame.size_of_quadtree/2 >= (y + side_length/2) ) //In all four leaves.
								InsertNE(frame)
								InsertSE(frame)
								InsertNW(frame)
							else					//In the east as well.
								InsertSE(frame)
						else if( solar_frame.y + solar_frame.size_of_quadtree/2 >= (y + side_length/2) ) //Only to the north.
							InsertNW(frame)
			return

	//If we are already at the maximum number of children, we need to split.
	//We do this by making the "nodes" variable a list, instead of null, and then call insert on each frame again.
		if(depth && contents.len >= max_children)
			nodes = new/list(4)
			for(var/existing_frame in contents)
				existing_frame:nodes.Remove(src)
				Insert(existing_frame)
			Insert(frame)
			contents = null
			return

	//Finally, if we are a node that contains frames and has NOT reached the maximum number of children, we need to add the frame to the node.
		contents.Add(frame)
		if(!frame.nodes)
			frame.nodes = list()
		frame.nodes |= src
		if(istype(frame) && frame.mass > MINIMUM_MASS_TO_CONSIDER_ATTRACTION)
			if(!frames_with_considerable_mass)
				frames_with_considerable_mass = list()
			frames_with_considerable_mass.Add(frame)


	proc/InsertNE(var/frame/frame)
		var/physics_node/node = nodes[NE]
		if(!node)
			node = new /physics_node( src, depth - 1, max_children, x + side_length/2, y + side_length/2, side_length/2 )
			nodes[NE] = node
		node.Insert(frame)


	proc/InsertSE(var/frame/frame)
		var/physics_node/node = nodes[SE]
		if(!node)
			node = new /physics_node( src, depth - 1, max_children, x + side_length/2, y, side_length/2 )
			nodes[SE] = node
		node.Insert(frame)


	proc/InsertNW(var/frame/frame)
		var/physics_node/node = nodes[NW]
		if(!node)
			node = new /physics_node( src, depth - 1, max_children, x, y + side_length/2, side_length/2 )
			nodes[NW] = node
		node.Insert(frame)


	proc/InsertSW(var/frame/frame)
		var/physics_node/node = nodes[SW]
		if(!node)
			node = new /physics_node( src, depth - 1, max_children, x, y, side_length/2 )
			nodes[SW] = node
		node.Insert(frame)


	//Function to remove a frame from a node.  Handles removal, as well as deletion of a node if it is now empty, and merging of child nodes into the parent node if the child nodes are now empty enough.
	proc/Remove(var/frame/frame)

	//First, we check if the frame is in the node.  We are using an ASSERT since LOL, LEMME MAKE MY CODE DIRECTLY MODIFY THE FRAME'S ASSOCIATED NODE.
		ASSERT(frame in contents)

	//Secondly, handle removal fo the actual frame.
		contents.Remove(frame)
		if(frames_with_considerable_mass)
			frames_with_considerable_mass.Remove(frame)
			if(!frames_with_considerable_mass.len)
				frames_with_considerable_mass = null
		if(frame.nodes.len > 1)
			var/position = frame.nodes.Find(src)
			if(position)
				frame.nodes.Cut(position, position + 1)
		else
			frame.nodes = null

	//Thirdly, handle if the frame is moving out of the root node, and possibly merge all child nodes into the root.
		spawn(1)
			if(istype(root))
				root.ConsiderMerge()

	//Finally, handle removal of the node, since nothing is in it anymore.  For speed, we will use the garbage collector.
		if( !(contents && contents.len) && !(nodes && nodes.len) )
			var/position = root.nodes.Find(src)
			if(!position) //Something went horribly wrong.
				#ifdef PHYSICS_DEBUG
				physics_sim.debugging_file << "QUADTREE: Root node lacks reference to child.  Nulling out child's root variable."
				#endif
				root = null
				return
			root.nodes[position] = null
			root = null


	//Function to handle merging of children back into the parent node.
	proc/ConsiderMerge()
		if(last_merge_attempt == physics_sim.real_time)
			return
		last_merge_attempt = physics_sim.real_time

	//First, takes the total.  If it is below the max_children value, merge.
		if(TotalContents() <= max_children)

	//Great, it is at or below the limit.  Lets gather all the frames, and put them aside.
			var/list/new_contents = ReturnContents()
			if(new_contents.len > max_children)
				return

	//Now, lets remove all the child nodes, since we already set aside the frames within.
			for(var/physics_node/node in nodes)
				node.SoftDelete()
			nodes = null
			contents = list()

	//Now readd the contained frames.
			var/frame/frame
			for(var/i = 1 to new_contents.len)
				frame = new_contents[i]
				Insert(frame)


	//Function to handle gathering the total number of frames contained within a child.  Returns an interger.
	proc/TotalContents()

	//Totals up the contents of each child and returns it.
		if(contents)
			return contents.len

		var/total = 0
		for(var/physics_node/node in nodes)
			total += node.TotalContents()
		return total


	//Function to gather then return the contents of the node and any children.  Returns a list of frames.
	proc/ReturnContents()
		if(contents)
			return contents

		var/list/total = list()
		for(var/physics_node/node in nodes)
			total.Add(node.ReturnContents())
		return total


	//Function to compute the center of mass.  Returns a list in for format of list(mass, x, y)
	proc/ReturnCenterOfMass()
		if(center_of_mass_updated == physics_sim.real_time)
			return center_of_mass

		center_of_mass = list(0,0,0)
		center_of_mass_updated = physics_sim.real_time
		if(contents)
			if(frames_with_considerable_mass && frames_with_considerable_mass.len)
				for(var/frame/frame in frames_with_considerable_mass)
					if(!center_of_mass[1])
						center_of_mass[2] = frame.x
						center_of_mass[3] = frame.y
						center_of_mass[1] = frame.mass
						continue
					center_of_mass[2] += frame.x*frame.mass/center_of_mass[1]
					center_of_mass[3] += frame.y*frame.mass/center_of_mass[1]
					center_of_mass[1] += frame.mass
			return center_of_mass

		for(var/physics_node/node in nodes)
			var/list/center_of_mass_subnode = node.ReturnCenterOfMass()
			if(!center_of_mass[1] && center_of_mass_subnode[1])
				center_of_mass = center_of_mass_subnode.Copy()
			else if(center_of_mass_subnode[1])
				center_of_mass[2] += center_of_mass_subnode[2]*center_of_mass_subnode[1]/center_of_mass[1]
				center_of_mass[3] += center_of_mass_subnode[3]*center_of_mass_subnode[1]/center_of_mass[1]
				center_of_mass[1] += center_of_mass_subnode[1]
		return center_of_mass


	//Function to delete the node via garbage collector.
	proc/SoftDelete()
		for(var/frame in contents)
			Remove(frame)
		contents = null
		for(var/physics_node/node in nodes)
			node.SoftDelete()
		nodes = null
		var/position = root.nodes.Find(src)
		if(!position) //Something went horribly wrong.
			#ifdef PHYSICS_DEBUG
			physics_sim.debugging_file << "QUADTREE: Root node lacks reference to child.  Nulling out child's root variable."
			#endif
			root = null
			return
		root.nodes[position] = null
		root = null
		return




#undef NE
#undef NW
#undef SE
#undef SW





