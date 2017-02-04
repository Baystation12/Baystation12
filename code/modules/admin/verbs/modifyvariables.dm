
/client/proc/cmd_modify_ticker_variables()
	set category = "Debug"
	set name = "Edit Ticker Variables"

	if (ticker == null)
		to_chat(src, "Game hasn't started yet.")
	else
		src.modify_variables(ticker)
		feedback_add_details("admin_verb","ETV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/mod_list_add_ass()
	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","color","list","edit referenced object","restore to default")
	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum ([marked_datum.type])"

	class = input("What kind of variable?","Variable Type") as null|anything in class_input
	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum ([marked_datum.type])")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = input("Enter new number:","Num") as null|num

		if("type")
			var_value = input("Enter type:","Type") as null|anything in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in world

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("marked datum")
			var_value = holder.marked_datum()

		if("color")
			var_value = input("Select new color:","Color") as null|color

	if(!var_value) return

	return var_value


/client/proc/mod_list_add(var/list/L, atom/O, original_name, objectvar)

	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","color","edit referenced object","restore to default")
	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum ([marked_datum.type])"

	class = input("What kind of variable?","Variable Type") as null|anything in class_input
	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum ([marked_datum.type])")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as text

		if("num")
			var_value = input("Enter new number:","Num") as num

		if("type")
			var_value = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

		if("reference")
			var_value = input("Select reference:","Reference") as mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as mob in world

		if("file")
			var_value = input("Pick file:","File") as file

		if("icon")
			var_value = input("Pick icon:","Icon") as icon

		if("marked datum")
			var_value = holder.marked_datum()

	if(!var_value) return

	switch(alert("Would you like to associate a var with the list entry?",,"Yes","No"))
		if("Yes")
			L += var_value
			L[var_value] = mod_list_add_ass() //haha
		if("No")
			L += var_value
	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: ADDED=[var_value]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")
	message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: ADDED=[var_value]")

/client/proc/mod_list(var/list/L, atom/O, original_name, objectvar)
	if(!check_rights(R_VAREDIT))	return
	if(!istype(L,/list)) to_chat(src, "Not a List.")
	if(L.len > 1000)
		var/confirm = alert(src, "The list you're trying to edit is very long, continuing may crash the server.", "Warning", "Continue", "Abort")
		if(confirm != "Continue")
			return

	var/assoc = 0
	if(L.len > 0)
		var/a = L[1]
		try
			if(!isnum(a) && L[a] != null)
				assoc = 1 //This is pretty weak test but I can't think of anything else
				to_chat(usr, "List appears to be associative.")
		catch {} // Builtin non-assoc lists (contents, etc.) will runtime if you try to get an assoc value of them

	var/list/names = null
	if(!assoc)
		names = sortList(L)

	var/variable
	var/assoc_key
	if(assoc)
		variable = input("Which var?","Var") as null|anything in L + "(ADD VAR)"
	else
		variable = input("Which var?","Var") as null|anything in names + "(ADD VAR)"

	if(variable == "(ADD VAR)")
		mod_list_add(L, O, original_name, objectvar)
		return

	if(assoc)
		assoc_key = variable
		variable = L[assoc_key]

	if(!assoc && !variable || assoc && !assoc_key)
		return

	var/default

	var/dir

	if(variable in O.VVlocked())
		if(!check_rights(R_DEBUG))	return
	if(variable in O.VVckey_edit())
		if(!check_rights(R_SPAWN|R_DEBUG)) return
	if(variable in O.VVicon_edit_lock())
		if(!check_rights(R_FUN|R_DEBUG)) return

	if(isnull(variable))
		to_chat(usr, "Unable to determine variable type.")
	else if(isnum(variable))
		to_chat(usr, "Variable appears to be <b>NUM</b>.")
		default = "num"
		dir = 1

	else if(istext(variable))
		to_chat(usr, "Variable appears to be <b>TEXT</b>.")
		default = "text"

	else if(isloc(variable))
		to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
		default = "reference"

	else if(isicon(variable))
		to_chat(usr, "Variable appears to be <b>ICON</b>.")
		variable = "\icon[variable]"
		default = "icon"

	else if(istype(variable,/atom) || istype(variable,/datum))
		to_chat(usr, "Variable appears to be <b>TYPE</b>.")
		default = "type"

	else if(istype(variable,/list))
		to_chat(usr, "Variable appears to be <b>LIST</b>.")
		default = "list"

	else if(istype(variable,/client))
		to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
		default = "cancel"

	else
		to_chat(usr, "Variable appears to be <b>FILE</b>.")
		default = "file"

	to_chat(usr, "Variable contains: [variable]")
	if(dir)
		switch(variable)
			if(1)
				dir = "NORTH"
			if(2)
				dir = "SOUTH"
			if(4)
				dir = "EAST"
			if(8)
				dir = "WEST"
			if(5)
				dir = "NORTHEAST"
			if(6)
				dir = "SOUTHEAST"
			if(9)
				dir = "NORTHWEST"
			if(10)
				dir = "SOUTHWEST"
			else
				dir = null

		if(dir)
			to_chat(usr, "If a direction, direction is: [dir]")
	var/class = "text"
	var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(src.holder)
		var/datum/marked_datum = holder.marked_datum()
		if(marked_datum)
			class_input += "marked datum ([marked_datum.type])"

	class_input += "DELETE FROM LIST"
	class = input("What kind of variable?","Variable Type",default) as null|anything in class_input

	if(!class)
		return

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum ([marked_datum.type])")
		class = "marked datum"

	var/original_var
	if(assoc)
		original_var = L[assoc_key]
	else
		original_var = L[L.Find(variable)]

	var/new_var
	switch(class) //Spits a runtime error if you try to modify an entry in the contents list. Dunno how to fix it, yet.

		if("list")
			mod_list(variable, O, original_name, objectvar)

		if("restore to default")
			new_var = initial(variable)
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("edit referenced object")
			modify_variables(variable)

		if("DELETE FROM LIST")
			world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: REMOVED=[html_encode("[variable]")]"
			log_admin("[key_name(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			message_admins("[key_name_admin(src)] modified [original_name]'s [objectvar]: REMOVED=[variable]")
			L -= variable
			return

		if("text")
			new_var = input("Enter new text:","Text") as text
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("num")
			new_var = input("Enter new number:","Num") as num
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("type")
			new_var = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("reference")
			new_var = input("Select reference:","Reference") as mob|obj|turf|area in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("mob reference")
			new_var = input("Select reference:","Reference") as mob in world
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("file")
			new_var = input("Pick file:","File") as file
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("icon")
			new_var = input("Pick icon:","Icon") as icon
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

		if("marked datum")
			new_var = holder.marked_datum()
			if(!new_var)
				return
			if(assoc)
				L[assoc_key] = new_var
			else
				L[L.Find(variable)] = new_var

	world.log << "### ListVarEdit by [src]: [O.type] [objectvar]: [original_var]=[new_var]"
	log_admin("[key_name(src)] modified [original_name]'s [objectvar]: [original_var]=[new_var]")
	message_admins("[key_name_admin(src)] modified [original_name]'s varlist [objectvar]: [original_var]=[new_var]")

/client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)
	if(!check_rights(R_VAREDIT))	return

	for(var/p in forbidden_varedit_object_types())
		if( istype(O,p) )
			to_chat(usr, "<span class='danger'>It is forbidden to edit this object's variables.</span>")
			return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!(param_var_name in O.get_variables()))
			to_chat(src, "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])")
			return

		if(param_var_name in O.VVlocked())
			if(!check_rights(R_DEBUG))	return
		if(param_var_name in O.VVckey_edit())
			if(!check_rights(R_SPAWN|R_DEBUG)) return
		if(param_var_name in O.VVicon_edit_lock())
			if(!check_rights(R_FUN|R_DEBUG)) return

		variable = param_var_name

		var_value = O.get_variable_value(variable)

		if(autodetect_class)
			if(isnull(var_value))
				to_chat(usr, "Unable to determine variable type.")
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				to_chat(usr, "Variable appears to be <b>NUM</b>.")
				class = "num"
				dir = 1

			else if(istext(var_value))
				to_chat(usr, "Variable appears to be <b>TEXT</b>.")
				class = "text"

			else if(isloc(var_value))
				to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
				class = "reference"

			else if(isicon(var_value))
				to_chat(usr, "Variable appears to be <b>ICON</b>.")
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				to_chat(usr, "Variable appears to be <b>TYPE</b>.")
				class = "type"

			else if(istype(var_value,/list))
				to_chat(usr, "Variable appears to be <b>LIST</b>.")
				class = "list"

			else if(istype(var_value,/client))
				to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
				class = "cancel"

			else
				to_chat(usr, "Variable appears to be <b>FILE</b>.")
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)	return
		var_value = O.get_variable_value(variable)

		if(variable in O.VVlocked())
			if(!check_rights(R_DEBUG)) return
		if(variable in O.VVckey_edit())
			if(!check_rights(R_SPAWN|R_DEBUG)) return
		if(variable in O.VVicon_edit_lock())
			if(!check_rights(R_FUN|R_DEBUG)) return

	if(!autodetect_class)

		var/dir
		var/default
		if(isnull(var_value))
			to_chat(usr, "Unable to determine variable type.")
		else if(isnum(var_value))
			to_chat(usr, "Variable appears to be <b>NUM</b>.")
			default = "num"
			dir = 1

		else if(istext(var_value))
			to_chat(usr, "Variable appears to be <b>TEXT</b>.")
			default = "text"

		else if(isloc(var_value))
			to_chat(usr, "Variable appears to be <b>REFERENCE</b>.")
			default = "reference"

		else if(isicon(var_value))
			to_chat(usr, "Variable appears to be <b>ICON</b>.")
			var_value = "\icon[var_value]"
			default = "icon"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			to_chat(usr, "Variable appears to be <b>TYPE</b>.")
			default = "type"

		else if(istype(var_value,/list))
			to_chat(usr, "Variable appears to be <b>LIST</b>.")
			default = "list"

		else if(istype(var_value,/client))
			to_chat(usr, "Variable appears to be <b>CLIENT</b>.")
			default = "cancel"

		else
			to_chat(usr, "Variable appears to be <b>FILE</b>.")
			default = "file"

		to_chat(usr, "Variable contains: [var_value]")
		if(dir)
			switch(var_value)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				to_chat(usr, "If a direction, direction is: [dir]")
		var/list/class_input = list("text","num","type","reference","mob reference", "icon","file","list","json","color","edit referenced object","restore to default")
		if(src.holder)
			var/datum/marked_datum = holder.marked_datum()
			if(marked_datum)
				class_input += "marked datum ([marked_datum.type])"
		class = input("What kind of variable?","Variable Type",default) as null|anything in class_input

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	var/datum/marked_datum = holder.marked_datum()
	if(marked_datum && class == "marked datum ([marked_datum.type])")
		class = "marked datum"

	switch(class)

		if("list")
			mod_list(O.get_variable_value(variable), O, original_name, variable)
			return

		if("restore to default")
			var_value = O.get_initial_variable_value(variable)

		if("edit referenced object")
			return .(O.get_variable_value(variable))

		if("text")
			var/var_new = input("Enter new text:","Text",O.get_variable_value(variable)) as null|text
			if(var_new==null) return
			var_value = var_new

		if("num")
			if(variable=="light_range")
				var/var_new = input("Enter new number:","Num",O.get_variable_value(variable)) as null|num
				if(var_new == null) return
				O.set_light(var_new)
			else if(variable=="stat")
				var/var_new = input("Enter new number:","Num",O.get_variable_value(variable)) as null|num
				if(var_new == null) return
				if((O.get_variable_value(variable) == 2) && (var_new < 2))//Bringing the dead back to life
					var/mob/M = O
					M.switch_from_dead_to_living_mob_list()
				if((O.get_variable_value(variable) < 2) && (var_new == 2))//Kill he
					var/mob/M = O
					M.switch_from_living_to_dead_mob_list()
				var_value = var_new
			else
				var/var_new =  input("Enter new number:","Num",O.get_variable_value(variable)) as null|num
				if(var_new==null) return
				var_value = var_new

		if("type")
			var/var_new = input("Enter type:","Type",O.get_variable_value(variable)) as null|anything in typesof(/obj,/mob,/area,/turf)
			if(var_new==null) return
			var_value = var_new

		if("reference")
			var/var_new = input("Select reference:","Reference",O.get_variable_value(variable)) as null|mob|obj|turf|area in world
			if(var_new==null) return
			var_value = var_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.get_variable_value(variable)) as null|mob in world
			if(var_new==null) return
			var_value = var_new

		if("file")
			var/var_new = input("Pick file:","File",O.get_variable_value(variable)) as null|file
			if(var_new==null) return
			var_value = var_new

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.get_variable_value(variable)) as null|icon
			if(var_new==null) return
			var_value = var_new

		if("color")
			var_value = input("Select new color:","Color") as null|color

		if("json")
			var/json_str = input("JSON string", "JSON", json_encode(O.get_variable_value(variable))) as null | message
			try
				var_value = json_decode(json_str)
			catch
				return

		if("marked datum")
			var_value = holder.marked_datum()

	var/old_value = O.get_variable_value(variable)
	if(!special_set_vv_var(O, variable, var_value, src))
		O.set_variable_value(variable, var_value)

	var/new_value = O.get_variable_value(variable)
	if(old_value == new_value)
		return

	world.log << "### VarEdit by [src]: [O.type] [variable]=[html_encode("[new_value]")]"
	log_and_message_admins("modified [original_name]'s [variable] from '[old_value]' to '[new_value]'")

/client
	var/static/vv_set_handlers

/client/proc/special_set_vv_var(var/datum/O, variable, var_value, client)
	if(!vv_set_handlers)
		vv_set_handlers = init_subtypes(/decl/vv_set_handler)
	for(var/vv_handler in vv_set_handlers)
		var/decl/vv_set_handler/sh = vv_handler
		if(sh.can_handle_set_var(O, variable, var_value, client))
			sh.handle_set_var(O, variable, var_value, client)
			return TRUE
	return FALSE

/decl/vv_set_handler
	var/handled_type
	var/predicates
	var/list/handled_vars

/decl/vv_set_handler/proc/can_handle_set_var(var/datum/O, variable, var_value, client)
	if(!istype(O, handled_type))
		return FALSE
	if(!(variable in handled_vars))
		return FALSE
	if(istype(O) && !(variable in O.vars))
		log_error("Did not find the variable '[variable]' for the instance [log_info_line(O)].")
		return FALSE
	if(predicates)
		for(var/predicate in predicates)
			if(!call(predicate)(var_value, client))
				return FALSE
	return TRUE

/decl/vv_set_handler/proc/handle_set_var(var/datum/O, variable, var_value, client)
	var/proc_to_call = handled_vars[variable]
	if(proc_to_call)
		call(O, proc_to_call)(var_value)
	else
		O.vars[variable] = var_value

/decl/vv_set_handler/location_hander
	handled_type = /atom/movable
	handled_vars = list("loc","x","y","z")

/decl/vv_set_handler/location_hander/handle_set_var(var/atom/movable/AM, variable, var_value, client)
	if(variable == "loc")
		if(istype(var_value, /atom) || isnull(var_value) || var_value == "")	// Proper null or empty string is fine, 0 is not
			AM.forceMove(var_value)
		else
			to_chat(client, "<span class='warning'>May only assign null or /atom types to loc.</span>")
	else if(variable == "x" || variable == "y" || variable == "z")
		if(istext(var_value))
			var_value = text2num(var_value)
		if(!is_num_predicate(var_value, client))
			return
		var/x = AM.x
		var/y = AM.y
		var/z = AM.z
		switch(variable)
			if("x")
				x = var_value
			if("y")
				y = var_value
			if("z")
				z = var_value

		var/turf/T = locate(x,y,z)
		if(T)
			AM.forceMove(T)
		else
			to_chat(client, "<span class='warning'>Unable to locate a turf at [x]-[y]-[z].</span>")

/decl/vv_set_handler/opacity_hander
	handled_type = /atom
	handled_vars = list("opacity" = /atom/proc/set_opacity)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/dir_hander
	handled_type = /atom
	handled_vars = list("dir" = /atom/proc/set_dir)
	predicates = list(/proc/is_dir_predicate)

/decl/vv_set_handler/ghost_appearance_handler
	handled_type = /mob/observer/ghost
	handled_vars = list("appearance" = /mob/observer/ghost/proc/set_appearance)
	predicates = list(/proc/is_atom_predicate)

/decl/vv_set_handler/virtual_ability_handler
	handled_type = /mob/observer/virtual
	handled_vars = list("abilities")
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/virtual_ability_handler/handle_set_var(var/mob/observer/virtual/virtual, variable, var_value, client)
	..()
	virtual.updateicon()

/decl/vv_set_handler/mob_see_invisible_handler
	handled_type = /mob
	handled_vars = list("see_invisible" = /mob/proc/set_see_invisible)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_sight_handler
	handled_type = /mob
	handled_vars = list("sight" = /mob/proc/set_sight)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_see_in_dark_handler
	handled_type = /mob
	handled_vars = list("see_in_dark" = /mob/proc/set_see_in_dark)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_stat_handler
	handled_type = /mob
	handled_vars = list("set_stat" = /mob/proc/set_stat)
	predicates = list(/proc/is_num_predicate)
