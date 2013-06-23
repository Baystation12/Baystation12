dmm_suite

	var/debug_file = file("maploader_debug.txt")

	load_map(var/dmm_file as file, var/z_offset as num, var/y_offset as num, var/x_offset as num, var/load_speed = 0 as num)
		if(!z_offset)
			z_offset = world.maxz + 1

		//Ensure values are sane.
		else if(z_offset < 0)
			z_offset = abs(z_offset)
		else if(!isnum(z_offset))
			z_offset = 0

		if(x_offset < 0)
			x_offset = abs(x_offset)
		else if(!isnum(x_offset))
			x_offset = 0

		if(y_offset < 0)
			y_offset = abs(y_offset)
		else if(!isnum(y_offset))
			y_offset = 0

		debug_file << "Starting Map Load @ ([x_offset], [y_offset], [z_offset]), [load_speed] tiles per second."

		//Handle slowed loading.
		var/delay_chance = 0
		if(load_speed > 0)
			//Chance out of 100 every tenth of a second.
			delay_chance = 1000 / load_speed

		//String holding a quotation mark.
		var/quote = ascii2text(34)

		var/input_file = file2text(dmm_file)
		var/input_file_len = length(input_file)

		//Stores the contents of each tile model in the map
		var/list/grid_models = list()
		//Length of the tile model code.  e.g. "aaa" is 3 long.
		var/key_len = length(copytext(input_file, 2 ,findtext(input_file, quote, 2)))
		//The key of the default tile model.  (In SS13 this is: "/turf/space,/area")
		var/default_key

		debug_file << "	Building turf array."

		//Iterates through the mapfile to build the model tiles for the map.
		for(var/line_position = 1; line_position < input_file_len; line_position = findtext(input_file,"\n", line_position) + 1)
			var/next_line = copytext(input_file, line_position, findtext(input_file,"\n", line_position) - 1)

			//If the first character in the line is not a quote, the model tiles are all defined.
			if(copytext(next_line, 1, 2) != quote)
				break

			//Copy contents of the model into the grid_models list.
			var/model_key = copytext(next_line, 2, findtext(input_file, quote, 2))
			var/model_contents = copytext(next_line, findtext(next_line, "=" ) + 3)
			if(!default_key && model_contents == "[world.turf],[world.area]")
				default_key = model_key
			grid_models[model_key] = model_contents
			if(prob(delay_chance))
				sleep(1)

		//Co-ordinates of the tile being loaded.
		var/z_coordinate = -1
		var/y_coordinate = 0
		var/x_coordinate = 0

		//Store the
		var/y_depth = 0

		//Iterate through all z-levels to load the tiles.
		for(var/z_position = findtext(input_file, "\n(1,1,"); TRUE; z_position = findtext(input_file, "\n(1,1,", z_position + 1))
			//break when there are no more z-levels.
			if(z_position == 0)
				break

			//Increment the z_coordinate and update the world's borders
			z_coordinate++
			world.maxz = max(world.maxz, z_coordinate + z_offset)

			//Here we go!
			y_coordinate = 0
			y_depth = 0
			var/z_level = copytext(input_file, \
						findtext(input_file, quote + "\n", z_position) + 2,\
						findtext(input_file, "\n" + quote, z_position) + 1)

			//Iterate through each line, increasing the y_coordinate.
			for(var/grid_position = 1; grid_position != 0; grid_position = findtext(z_level, "\n", grid_position) + 1)
				//Grab this line of data.
				var/grid_line = copytext(z_level, grid_position, findtext(z_level, "\n", grid_position))

				//Compute the size of the z-levels y axis.
				if(!y_depth)
					y_depth = length(z_level) / (length(grid_line) + 1)
					y_depth += y_offset
					if(y_depth != round(y_depth, 1))
						debug_file << "	Warning: y_depth is not a round number"

					//And update the worlds variables.
					if(world.maxy < y_depth)
						world.maxy = y_depth
					//The top of the map is the highest "y" co-ordinate, so we start there and iterate downwards
					if(!y_coordinate)
						y_coordinate = y_depth + 1

				//Decrement and load this line of the map.
				y_coordinate--
				x_coordinate = x_offset

				//Iterate through the line loading the model tile data.
				for(var/model_position = 1; model_position <= length(grid_line); model_position += key_len)
					x_coordinate++

					//Find the model key and load that model.
					var/model_key = copytext(grid_line, model_position, model_position + key_len)
					//If the key is the default one, skip it and save the computation time.
					if(model_key == default_key)
						continue

					if(world.maxx < x_coordinate)
						world.maxx = x_coordinate
					parse_grid(grid_models[model_key], x_coordinate, y_coordinate, z_coordinate + z_offset)

					if(prob(delay_chance))
						sleep(1)

				//If we hit the last tile in this z-level, we should break out of the loop.
				if(grid_position + length(grid_line) + 1 > length(z_level))
					break

			//Break out of the loop when we hit the end of the file.
			if(findtext(input_file, quote + "}", z_position) + 2 >= input_file_len)
				break


	proc/parse_grid(var/model as text, var/x_coordinate as num, var/y_coordinate as num, var/z_coordinate as num)
		//Accepts a text string containing a comma separated list of type paths of the
		//  same construction as those contained in a .dmm file, and instantiates them.

		var/list/text_strings = list()
		for(var/index = 1; findtext(model, quote); index++)
			/*Loop: Stores quoted portions of text in text_strings, and replaces them with an
				index to that list.
				- Each iteration represents one quoted section of text.
				*/
			//Add the next section of quoted text to the list
			var/first_quote = findtext(model, quote)
			var/second_quote = findtext(model, quote, first_quote + 1)
			var/quoted_chunk = copytext(model, first_quote + 1, second_quote)
			text_strings += quoted_chunk
			//Then remove the quoted section.
			model = copytext(model, 1, first_quote) + "~[index]" + copytext(model, second_quote + 1)

		var/debug_output = 0
		//if(x_coordinate == 86 && y_coordinate == 88 && z_coordinate == 7)
		//	debug_output = 1

		if(debug_output)
			debug_file << "	Now debugging turf: [model] ([x_coordinate], [y_coordinate], [z_coordinate])"

		var/next_position = 1
		for(var/data_position = 1, next_position || data_position != 1, data_position = next_position + 1)
			next_position = findtext(model, ",/", data_position)

			var/full_def = copytext(model, data_position, next_position)

			if(debug_output)
				debug_file << "		Current Line: [full_def] -- ([data_position] - [next_position])"

			/*Loop: Identifies each object's data, instantiates it, and reconstitues it's fields.
				- Each iteration represents one object's data, including type path and field values.
				*/

			//Load the attribute data.
			var/attribute_position = findtext(full_def,"{")
			var/atom_def = text2path(copytext(full_def, 1, attribute_position))

			var/list/attributes = list()
			if(attribute_position)
				full_def = copytext(full_def, attribute_position + 1)
				if(debug_output)
					debug_file << "		Atom Def: [atom_def]"
					debug_file << "		Parameters: [full_def]"

				var/next_attribute = 1
				for(attribute_position = 1, next_attribute || attribute_position != 1, attribute_position = next_attribute + 1)
					next_attribute = findtext(full_def, ";", attribute_position)

					//Loop: Identifies each attribute/value pair, and stores it in attributes[].
					attributes +=  copytext(full_def, attribute_position, next_attribute)

			//Construct attributes associative list
			var/list/fields = list()
			for(var/attribute in attributes)
				var/trim_left = trim_text(copytext(attribute, 1, findtext(attribute, "=")))
				var/trim_right = trim_text(copytext(attribute, findtext(attribute, "=") + 1))

				if(findtext(trim_right, "list("))
					trim_right = get_list(trim_right, text_strings)

				else if(findtext(trim_right, "~"))//Check for strings
					while(findtext(trim_right,"~"))
						var/reference_index = copytext(trim_right, findtext(trim_right, "~") + 1)
						trim_right = text_strings[text2num(reference_index)]

				//Check for numbers
				else if(isnum(text2num(trim_right)))
					trim_right = text2num(trim_right)

				//Check for file
				else if(copytext(trim_right,1,2) == "'")
					trim_right = file(copytext(trim_right, 2, length(trim_right)))

				fields[trim_left] = trim_right
				sleep(-1)


			if(debug_output)
				var/return_data = "		Debug Fields:"
				for(var/item in fields)
					return_data += " [item] = [fields[item]];"
				debug_file << return_data

			//Begin Instanciation
			var/atom/instance

			if(ispath(atom_def,/area))
				instance = locate(atom_def)
				if(!istype(instance, atom_def))
					instance = new atom_def
				instance.contents.Add(locate(x_coordinate,y_coordinate,z_coordinate))

			else
				instance = new atom_def(locate(x_coordinate,y_coordinate,z_coordinate))
				if(instance)
					for(var/item in fields)
						instance.vars[item] = fields[item]
				else if(!(atom_def in borked_paths))
					borked_paths += atom_def
					var/return_data = "	Failure [atom_def] @ ([x_coordinate], [y_coordinate], [z_coordinate])  fields:"
					for(var/item in fields)
						return_data += " [item] = [fields[item]];"
					debug_file << return_data

			sleep(-1)
		return 1

	var/list/borked_paths = list()

	proc/trim_text(var/what as text)
		while(length(what) && findtext(what, " ", 1, 2))
			what = copytext(what, 2)

		while(length(what) && findtext(what, " ", length(what)))
			what = copytext(what, 1, length(what))

		return what

	proc/get_list(var/text, var/list/text_strings)
		//First, trim the data to just the list contents
		var/list_start = findtext(text, "(") + 1
		var/list_end = findtext(text, ")", list_start)
		var/list_contents = copytext(text, list_start, list_end)

		//Then, we seperate it into the individual entries

		var/list/entries = list()
		var/entry_end = 1

		for(var/entry_start = 1, entry_end || entry_start != 1, entry_start = entry_end + 1)
			entry_end = findtext(list_contents, ",", entry_start)
			entries += copytext(list_contents, entry_start, entry_end)

		//Finally, we assemble the completed list.
		var/list/final_list = list()
		for(var/entry in entries)
			var/equals_position = findtext(entry, "=")

			if(equals_position)
				var/trim_left = trim_text(copytext(entry, 1, equals_position))
				var/trim_right = trim_text(copytext(entry, equals_position + 1))

				if(findtext(trim_right, "list("))
					trim_right = get_list(trim_right, text_strings)

				else if(findtext(trim_right, "~"))//Check for strings
					while(findtext(trim_right,"~"))
						var/reference_index = copytext(trim_right, findtext(trim_right, "~") + 1)
						trim_right = text_strings[text2num(reference_index)]

				//Check for numbers
				else if(isnum(text2num(trim_right)))
					trim_right = text2num(trim_right)

				//Check for file
				else if(copytext(trim_right,1,2) == "'")
					trim_right = file(copytext(trim_right, 2, length(trim_right)))

				if(findtext(trim_left, "~"))//Check for strings
					while(findtext(trim_left,"~"))
						var/reference_index = copytext(trim_left, findtext(trim_left, "~") + 1)
						trim_left = text_strings[text2num(reference_index)]

				final_list[trim_left] = trim_right

			else
				if(findtext(entry, "~"))//Check for strings
					while(findtext(entry, "~"))
						var/reference_index = copytext(entry, findtext(entry, "~") + 1)
						entry = text_strings[text2num(reference_index)]

				//Check for numbers
				else if(isnum(text2num(entry)))
					entry = text2num(entry)

				//Check for file
				else if(copytext(entry, 1, 2) == "'")
					entry = file(copytext(entry, 2, length(entry)))

				final_list += entry

		return final_list