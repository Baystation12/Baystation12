/proc/togglebuildmode(mob/M as mob in player_list)
	set name = "Toggle Build Mode"
	set category = "Special Verbs"
	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(usr)] has left build mode.")
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			for(var/obj/effect/bmode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			log_admin("[key_name(usr)] has entered build mode.")
			M.client.buildmode = 1
			M.client.show_popup_menus = 0

			var/obj/effect/bmode/buildholder/H = new/obj/effect/bmode/buildholder()
			var/obj/effect/bmode/builddir/A = new/obj/effect/bmode/builddir(H)
			A.master = H
			var/obj/effect/bmode/buildhelp/B = new/obj/effect/bmode/buildhelp(H)
			B.master = H
			var/obj/effect/bmode/buildmode/C = new/obj/effect/bmode/buildmode(H)
			C.master = H
			var/obj/effect/bmode/buildquit/D = new/obj/effect/bmode/buildquit(H)
			D.master = H

			H.builddir = A
			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D
			M.client.screen += A
			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			H.cl = M.client

/obj/effect/bmode//Cleaning up the tree a bit
	density = 1
	anchored = 1
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/bmode/buildholder/master = null

/obj/effect/bmode/Destroy()
	if(master && master.cl)
		master.cl.screen -= src
	master = null
	return ..()

/obj/effect/bmode/builddir
	icon_state = "build"
	screen_loc = "NORTH,WEST"
	Click()
		switch(dir)
			if(NORTH)
				set_dir(EAST)
			if(EAST)
				set_dir(SOUTH)
			if(SOUTH)
				set_dir(WEST)
			if(WEST)
				set_dir(NORTHWEST)
			if(NORTHWEST)
				set_dir(NORTH)
		return 1

/obj/effect/bmode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"
	Click()
		switch(master.cl.buildmode)
			if(1) // Basic Build
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button        = Construct / Upgrade</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button       = Deconstruct / Delete / Downgrade</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button + ctrl = R-Window</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button + alt  = Airlock</span>")
				to_chat(usr, "")
				to_chat(usr, "<span class='notice'>Use the button in the upper left corner to</span>")
				to_chat(usr, "<span class='notice'>change the direction of built objects.</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(2) // Adv. Build
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Set object type</span>")
				to_chat(usr, "<span class='notice'>Middle Mouse Button on buildmode button= On/Off object type saying</span>")
				to_chat(usr, "<span class='notice'>Middle Mouse Button on turf/obj        = Capture object type</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj          = Place objects</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button                     = Delete objects</span>")
				to_chat(usr, "<span class='notice'>Mouse Button + ctrl                    = Copy object type</span>")
				to_chat(usr, "")
				to_chat(usr, "<span class='notice'>Use the button in the upper left corner to</span>")
				to_chat(usr, "<span class='notice'>change the direction of built objects.</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(3) // Edit
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Select var(type) & value</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Set var(type) & value</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Reset var's value</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(4) // Throw
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Select</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Throw</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(5) // Room Build
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf              = Select as point A</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf             = Select as point B</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Change floor/wall type</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(6) // Make Ladders
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf              = Set as upper ladder loc</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf             = Set as lower ladder loc</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(7) // Move Into Contents
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Select</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Move into selection</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
			if(8) // Make Lights
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
				to_chat(usr, "<span class='notice'>Left Mouse Button on turf/obj/mob      = Make it glow</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on turf/obj/mob     = Reset glowing</span>")
				to_chat(usr, "<span class='notice'>Right Mouse Button on buildmode button = Change glow properties</span>")
				to_chat(usr, "<span class='notice'>***********************************************************</span>")
		return 1

/obj/effect/bmode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

	Click()
		togglebuildmode(master.cl.mob)
		return 1

/obj/effect/bmode/buildholder
	density = 0
	anchored = 1
	var/client/cl = null
	var/obj/effect/bmode/builddir/builddir = null
	var/obj/effect/bmode/buildhelp/buildhelp = null
	var/obj/effect/bmode/buildmode/buildmode = null
	var/obj/effect/bmode/buildquit/buildquit = null
	var/atom/movable/throw_atom = null

/obj/effect/bmode/buildholder/Destroy()
	qdel(builddir)
	builddir = null
	qdel(buildhelp)
	buildhelp = null
	qdel(buildmode)
	buildmode = null
	qdel(buildquit)
	buildquit = null
	throw_atom = null
	cl = null
	return ..()

/obj/effect/bmode/buildmode
	icon_state = "buildmode1"
	screen_loc = "NORTH,WEST+2"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = /obj/structure/closet
	var/objsay = 1

	var/wall_holder = /turf/simulated/wall
	var/floor_holder = /turf/simulated/floor/plating
	var/turf/coordA = null
	var/turf/coordB = null

	var/new_light_color = "#FFFFFF"
	var/new_light_range = 3
	var/new_light_intensity = 3

/obj/effect/bmode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("middle"))
		switch(master.cl.buildmode)
			if(2)
				objsay=!objsay


	if(pa.Find("left"))
		switch(master.cl.buildmode)
			if(1)
				master.cl.buildmode = 2
				src.icon_state = "buildmode2"
			if(2)
				master.cl.buildmode = 3
				src.icon_state = "buildmode3"
			if(3)
				master.cl.buildmode = 4
				src.icon_state = "buildmode4"
			if(4)
				master.cl.buildmode = 5
				src.icon_state = "buildmode5"
			if(5)
				master.cl.buildmode = 6
				src.icon_state = "buildmode6"
			if(6)
				master.cl.buildmode = 7
				src.icon_state = "buildmode7"
			if(7)
				master.cl.buildmode = 8
				src.icon_state = "buildmode8"
			if(8)
				master.cl.buildmode = 1
				src.icon_state = "buildmode1"

	else if(pa.Find("right"))
		switch(master.cl.buildmode)
			if(1) // Basic Build
				return 1
			if(2) // Adv. Build
				objholder = get_path_from_partial_text(/obj/structure/closet)

			if(3) // Edit
				var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine")

				master.buildmode.varholder = input(usr,"Enter variable name:" ,"Name", "name")
				if(master.buildmode.varholder in locked && !check_rights(R_DEBUG,0))
					return 1
				var/thetype = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference")
				if(!thetype) return 1
				switch(thetype)
					if("text")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", "value") as text
					if("number")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", 123) as num
					if("mob-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as mob in mob_list
					if("obj-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as obj in world
					if("turf-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as turf in world
			if(5) // Room build
				var/choice = alert("Would you like to change the floor or wall holders?","Room Builder", "Floor", "Wall")
				switch(choice)
					if("Floor")
						floor_holder = get_path_from_partial_text(/turf/simulated/floor/plating)
					if("Wall")
						wall_holder = get_path_from_partial_text(/turf/simulated/wall)
			if(8) // Lights
				var/choice = alert("Change the new light range, power, or color?", "Light Maker", "Range", "Power", "Color")
				switch(choice)
					if("Range")
						var/input = input("New light range.","Light Maker",3) as null|num
						if(input)
							new_light_range = input
					if("Power")
						var/input = input("New light power.","Light Maker",3) as null|num
						if(input)
							new_light_intensity = input
					if("Color")
						var/input = input("New light color.","Light Maker",3) as null|color
						if(input)
							new_light_color = input
	return 1

/proc/build_click(var/mob/user, buildmode, params, var/obj/object)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(buildmode)
		if(1) // Basic Build
			if(istype(object,/turf) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				if(istype(object,/turf/space))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall/r_wall)
					return
			else if(pa.Find("right"))
				if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/space)
					return
				else if(istype(object,/turf/simulated/wall/r_wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					return
				else if(istype(object,/obj))
					qdel(object)
					return
			else if(istype(object,/turf) && pa.Find("alt") && pa.Find("left"))
				new/obj/machinery/door/airlock(get_turf(object))
			else if(istype(object,/turf) && pa.Find("ctrl") && pa.Find("left"))
				switch(holder.builddir.dir)
					if(NORTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTH)
					if(SOUTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(SOUTH)
					if(EAST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(EAST)
					if(WEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(WEST)
					if(NORTHWEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.set_dir(NORTHWEST)
		if(2) // Adv. Build
			if(pa.Find("left") && !pa.Find("ctrl"))
				if(ispath(holder.buildmode.objholder,/turf))
					var/turf/T = get_turf(object)
					T.ChangeTurf(holder.buildmode.objholder)
				else if(holder.buildmode.objholder)
					var/obj/A = new holder.buildmode.objholder (get_turf(object))
					A.set_dir(holder.builddir.dir)
				else
					to_chat(user, "<span>Select a type to construct.</span>")
			else if(pa.Find("right"))
				if(isobj(object))
					qdel(object)
			else if(pa.Find("ctrl"))
				holder.buildmode.objholder = object.type
				to_chat(user, "<span class='notice'>[object]([object.type]) copied to buildmode.</span>")
			if(pa.Find("middle"))
				holder.buildmode.objholder = text2path("[object.type]")
				if(holder.buildmode.objsay)	to_chat(usr, "[object.type]")

		if(3) // Edit
			if(pa.Find("left")) //I cant believe this shit actually compiles.
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = holder.buildmode.valueholder
				else
					to_chat(user, "<span class='danger'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>")
			if(pa.Find("right"))
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = initial(object.vars[holder.buildmode.varholder])
				else
					to_chat(user, "<span class='danger'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>")
		if(4) // Throw
			if(pa.Find("left"))
				if(istype(object, /atom/movable))
					holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom)
					holder.throw_atom.throw_at(object, 10, 1)
					log_admin("[key_name(usr)] threw [holder.throw_atom] at [object]")
		if(5) // Room build
			if(pa.Find("left"))
				holder.buildmode.coordA = get_turf(object)
				to_chat(user, "<span class='notice'>Defined [object] ([object.type]) as point A.</span>")
			if(pa.Find("right"))
				holder.buildmode.coordB = get_turf(object)
				to_chat(user, "<span class='notice'>Defined [object] ([object.type]) as point B.</span>")
			if(holder.buildmode.coordA && holder.buildmode.coordB)
				to_chat(user, "<span class='notice'>A and B set, creating rectangle.</span>")
				holder.buildmode.make_rectangle(
					holder.buildmode.coordA,
					holder.buildmode.coordB,
					holder.buildmode.wall_holder,
					holder.buildmode.floor_holder
					)
				holder.buildmode.coordA = null
				holder.buildmode.coordB = null
		if(6) // Ladders
			if(pa.Find("left"))
				holder.buildmode.coordA = get_turf(object)
				to_chat(user, "<span class='notice'>Defined [object] ([object.type]) as upper ladder location.</span>")
			if(pa.Find("right"))
				holder.buildmode.coordB = get_turf(object)
				to_chat(user, "<span class='notice'>Defined [object] ([object.type]) as lower ladder location.</span>")
			if(holder.buildmode.coordA && holder.buildmode.coordB)
				to_chat(user, "<span class='notice'>Ladder locations set, building ladders.</span>")
				var/obj/structure/ladder/A = new /obj/structure/ladder(holder.buildmode.coordA)
				var/obj/structure/ladder/B = new /obj/structure/ladder(holder.buildmode.coordB)
				A.target_down = B
				B.target_up = A
				B.icon_state = "ladderup"
				holder.buildmode.coordA = null
				holder.buildmode.coordB = null
		if(7) // Move into contents
			if(pa.Find("left"))
				if(istype(object, /atom))
					holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom && istype(object, /atom/movable))
					object.forceMove(holder.throw_atom)
					log_admin("[key_name(usr)] moved [object] into [holder.throw_atom].")
		if(8) // Lights
			if(pa.Find("left"))
				if(object)
					object.set_light(holder.buildmode.new_light_range, holder.buildmode.new_light_intensity, holder.buildmode.new_light_color)
			if(pa.Find("right"))
				if(object)
					object.set_light(0, 0, "#FFFFFF")

/obj/effect/bmode/buildmode/proc/get_path_from_partial_text(default_path)
	var/desired_path = input("Enter full or partial typepath.","Typepath","[default_path]")

	var/list/types = typesof(/atom)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", desired_path))
			matches += path

	if(matches.len==0)
		alert("No results found.  Sorry.")
		return

	var/result = null

	if(matches.len==1)
		result = matches[1]
	else
		result = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!objholder)
			result = default_path
	return result

/obj/effect/bmode/buildmode/proc/make_rectangle(var/turf/A, var/turf/B, var/turf/wall_type, var/turf/floor_type)
	if(!A || !B) // No coords
		return
	if(A.z != B.z) // Not same z-level
		return

	var/height = A.y - B.y
	var/width = A.x - B.x
	var/z_level = A.z

	var/turf/lower_left_corner = null
	// First, try to find the lowest part
	var/desired_y = 0
	if(A.y <= B.y)
		desired_y = A.y
	else
		desired_y = B.y

	//Now for the left-most part.
	var/desired_x = 0
	if(A.x <= B.x)
		desired_x = A.x
	else
		desired_x = B.x

	lower_left_corner = locate(desired_x, desired_y, z_level)

	// Now we can begin building the actual room.  This defines the boundries for the room.
	var/low_bound_x = lower_left_corner.x
	var/low_bound_y = lower_left_corner.y

	var/high_bound_x = lower_left_corner.x + abs(width)
	var/high_bound_y = lower_left_corner.y + abs(height)

	for(var/i = low_bound_x, i <= high_bound_x, i++)
		for(var/j = low_bound_y, j <= high_bound_y, j++)
			var/turf/T = locate(i, j, z_level)
			if(i == low_bound_x || i == high_bound_x || j == low_bound_y || j == high_bound_y)
				if(isturf(wall_type))
					T.ChangeTurf(wall_type)
				else
					new wall_type(T)
			else
				if(isturf(floor_type))
					T.ChangeTurf(floor_type)
				else
					new floor_type(T)