var/list/forbidden_varedit_object_types = list(
										/obj/admins,						//Admins editing their own admin-power object? Yup, sounds like a good idea.
										/obj/machinery/blackbox_recorder,	//Prevents people messing with feedback gathering
										/datum/feedback_variable			//Prevents people messing with feedback gathering
									)

/client/proc/cmd_modify_object_variables(obj/O as obj|mob|turf|area in world)
	set category = "Debug"
	set name = "Edit Variables"
	set desc="(target) Edit a target item's variables"
	src.modify_variables(O)
	//feedback_add_details("admin_verb","EDITV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_modify_ref_variables(var/target as text)
	set category = "Debug"
	set name = "Edit Variables (Reference)"
	set desc="(target) Edit a target item's variables"
	var/obj/I = locate(target)
	if(!I)
		usr << "ERROR: Object could not be located!"
		return
	src.modify_variables(I)
	//feedback_add_details("admin_verb","EDITV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_modify_ticker_variables()
	set category = "Debug"
	set name = "Edit Ticker Variables"

	if (ticker == null)
		src << "Game hasn't started yet."
	else
		src.modify_variables(ticker)
	//	feedback_add_details("admin_verb","ETV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/mod_list_add_ass() //haha

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
	else
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
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
			switch(alert("Would you like to enter a specific object, or search for it from the world?","Choose!","Specifc UID (Hexadecimal number)", "Search"))
				if("Specifc UID (Hexadecimal number)")
					var/UID = input("Type in UID, without the leading 0x","Type in UID") as text|null
					if(!UID) return
					if(length(UID) != 7)
						usr << "ERROR.  UID must be 7 digits"
					var/temp_variable = locate("\[0x[UID]\]")
					if(!temp_variable)
						usr << "ERROR.  Could not locate referenced object."
						return
					switch(alert("You have chosen [temp_variable], in [get_area(temp_variable)].  Are you sure?","You sure?","Yes","NONOCANCEL!"))
						if("Yes")
							var_value = temp_variable
						if("NONOCANCEL!")
							return
				if("Search")
					var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in get_sorted_mobs()

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("marked datum")
			var_value = holder.marked_datum

	if(!var_value) return

	return var_value


/client/proc/mod_list_add(var/list/L)

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
	else
		class = input("What kind of variable?","Variable Type") as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	var/var_value = null

	switch(class)

		if("text")
			var_value = input("Enter new text:","Text") as null|text

		if("num")
			var_value = input("Enter new number:","Num") as null|num

		if("type")
			var_value = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

		if("reference")
			switch(alert("Would you like to enter a specific object, or search for it from the world?","Choose!","Specifc UID (Hexadecimal number)", "Search"))
				if("Specifc UID (Hexadecimal number)")
					var/UID = input("Type in UID, without the leading 0x","Type in UID") as text|null
					if(!UID) return
					if(length(UID) != 7)
						usr << "ERROR.  UID must be 7 digits"
					var/temp_variable = locate("\[0x[UID]\]")
					if(!temp_variable)
						usr << "ERROR.  Could not locate referenced object."
						return
					switch(alert("You have chosen [temp_variable], in [get_area(temp_variable)].  Are you sure?","You sure?","Yes","NONOCANCEL!"))
						if("Yes")
							var_value = temp_variable
						if("NONOCANCEL!")
							return
				if("Search")
					var_value = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			var_value = input("Select reference:","Reference") as null|mob in get_sorted_mobs()

		if("file")
			var_value = input("Pick file:","File") as null|file

		if("icon")
			var_value = input("Pick icon:","Icon") as null|icon

		if("marked datum")
			var_value = holder.marked_datum

	if(!var_value) return

	switch(alert("Would you like to associate a var with the list entry?",,"Yes","No"))
		if("Yes")
			L += var_value
			L[var_value] = mod_list_add_ass() //haha
		if("No")
			L += var_value

/client/proc/mod_list(var/list/L)
	if(!istype(L,/list)) src << "Not a List."

	var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine", "poo", "icon", "icon_state")

	var/list/names = sortList(L)

	var/variable = input("Which var?","Var") as null|anything in names + "(ADD VAR)"

	if(variable == "(ADD VAR)")
		mod_list_add(L)
		return

	if(!variable)
		return

	var/associative
	if(istext(variable) && !isnull(L[variable]))
		associative = variable
		variable = L[variable]

	var/default

	var/dir

	if (locked.Find(variable) && !(src.holder.rank in list("Game Master", "Game Admin")))
		return

	if(isnull(variable))
		usr << "Unable to determine variable type."

	else if(isnum(variable))
		usr << "Variable appears to be <b>NUM</b>."
		default = "num"
		dir = 1

	else if(istext(variable))
		usr << "Variable appears to be <b>TEXT</b>."
		default = "text"

	else if(isloc(variable))
		usr << "Variable appears to be <b>REFERENCE</b>."
		default = "reference"

	else if(isicon(variable))
		usr << "Variable appears to be <b>ICON</b>."
		variable = "\icon[variable]"
		default = "icon"

	else if(istype(variable,/atom) || istype(variable,/datum))
		usr << "Variable appears to be <b>TYPE</b>."
		default = "type"

	else if(istype(variable,/list))
		usr << "Variable appears to be <b>LIST</b>."
		default = "list"

	else if(istype(variable,/client))
		usr << "Variable appears to be <b>CLIENT</b>."
		default = "cancel"

	else
		usr << "Variable appears to be <b>FILE</b>."
		default = "file"

	usr << "Variable contains: [variable]"
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
			usr << "If a direction, direction is: [dir]"

	var/class = "text"
	if(src.holder && src.holder.marked_datum)
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
	else
		class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
			"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

	if(!class)
		return

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	switch(class)

		if("list")
			mod_list(variable)

		if("restore to default")
			if(associative)
				L[associative] = initial(L[associative])
			else
				variable = initial(variable)

		if("edit referenced object")
			modify_variables(variable)

		if("(DELETE FROM LIST)")
			if(associative)
				L.Remove(associative)
				return
			L.Remove(variable)
			return

		if("text")
			variable = input("Enter new text:","Text",\
				variable) as null|text

		if("num")
			variable = input("Enter new number:","Num",\
				variable) as null|num

		if("type")
			variable = input("Enter type:","Type",variable) \
				in typesof(/obj,/mob,/area,/turf)

		if("reference")
			switch(alert("Would you like to enter a specific object, or search for it from the world?","Choose!","Specifc UID (Hexadecimal number)", "Search"))
				if("Specifc UID (Hexadecimal number)")
					var/UID = input("Type in UID, without the leading 0x","Type in UID") as null|text
					if(!UID) return
					if(length(UID) != 7)
						usr << "ERROR.  UID must be 7 digits"
					var/temp_variable = locate("\[0x[UID]\]")
					if(!temp_variable)
						usr << "ERROR.  Could not locate referenced object."
						return
					switch(alert("You have chosen [temp_variable], in [get_area(temp_variable)].  Are you sure?","You sure?","Yes","NONOCANCEL!"))
						if("Yes")
							variable = temp_variable
						if("NONOCANCEL!")
							return
				if("Search")
					variable = input("Select reference:","Reference") as null|mob|obj|turf|area in world

		if("mob reference")
			variable = input("Select reference:","Reference",\
				variable) as null|mob in get_sorted_mobs()

		if("file")
			variable = input("Pick file:","File",variable) \
				as null|file

		if("icon")
			variable = input("Pick icon:","Icon",variable) \
				as null|icon

		if("marked datum")
			variable = holder.marked_datum

	if(associative)
		L[associative] = variable

/client/proc/modify_variables(var/atom/O, var/param_var_name = null, var/autodetect_class = 0)
	var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "cuffed", "ka", "last_eaten", "urine", "poo", "icon", "icon_state")

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	for(var/p in forbidden_varedit_object_types)
		if( istype(O,p) )
			usr << "\red It is forbidden to edit this object's variables."
			return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!param_var_name in O.vars)
			src << "A variable with this name ([param_var_name]) doesn't exist in this atom ([O])"
			return

		if (param_var_name == "holder" && holder.rank != "Game Master")
			src << "No. Stop being stupid."
			return

		if (locked.Find(param_var_name) && !(src.holder.rank in list("Game Master", "Game Admin")))
			src << "Editing this variable requires you to be a game master or game admin."
			return

		variable = param_var_name

		var_value = O.vars[variable]

		if(autodetect_class)
			if(isnull(var_value))
				usr << "Unable to determine variable type."
				class = null
				autodetect_class = null
			else if(isnum(var_value))
				usr << "Variable appears to be <b>NUM</b>."
				class = "num"
				dir = 1

			else if(istext(var_value))
				usr << "Variable appears to be <b>TEXT</b>."
				class = "text"

			else if(isloc(var_value))
				usr << "Variable appears to be <b>REFERENCE</b>."
				class = "reference"

			else if(isicon(var_value))
				usr << "Variable appears to be <b>ICON</b>."
				var_value = "\icon[var_value]"
				class = "icon"

			else if(istype(var_value,/atom) || istype(var_value,/datum))
				usr << "Variable appears to be <b>TYPE</b>."
				class = "type"

			else if(istype(var_value,/list))
				usr << "Variable appears to be <b>LIST</b>."
				class = "list"

			else if(istype(var_value,/client))
				usr << "Variable appears to be <b>CLIENT</b>."
				class = "cancel"

			else
				usr << "Variable appears to be <b>FILE</b>."
				class = "file"

	else

		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)
			return
		var_value = O.vars[variable]

		if (locked.Find(variable) && !(src.holder.rank in list("Game Master", "Game Admin")))
			return

		if (variable == "holder" && holder.rank != "Game Master") //Hotfix, a bit ugly but that exploit has been there for ages and now somebody just had to go and tell everyone of it bluh bluh - U
			return

	if(!autodetect_class)

		var/dir
		var/default
		if(isnull(var_value))
			usr << "Unable to determine variable type."

		else if(isnum(var_value))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			dir = 1

		else if(istext(var_value))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"

		else if(isloc(var_value))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"

		else if(isicon(var_value))
			usr << "Variable appears to be <b>ICON</b>."
			var_value = "\icon[var_value]"
			default = "icon"

		else if(istype(var_value,/atom) || istype(var_value,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"

		else if(istype(var_value,/list))
			usr << "Variable appears to be <b>LIST</b>."
			default = "list"

		else if(istype(var_value,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			default = "cancel"

		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"

		usr << "Variable contains: [var_value]"
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
				usr << "If a direction, direction is: [dir]"

		if(src.holder && src.holder.marked_datum)
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default","marked datum ([holder.marked_datum.type])")
		else
			class = input("What kind of variable?","Variable Type",default) as null|anything in list("text",
				"num","type","reference","mob reference", "icon","file","list","edit referenced object","restore to default")

		if(!class)
			return

	var/original_name

	if (!istype(O, /atom))
		original_name = "\ref[O] ([O])"
	else
		original_name = O:name

	if(holder.marked_datum && class == "marked datum ([holder.marked_datum.type])")
		class = "marked datum"

	switch(class)

		if("list")
			mod_list(O.vars[variable])
			return

		if("restore to default")
			O.vars[variable] = initial(O.vars[variable])

		if("edit referenced object")
			return .(O.vars[variable])

		if("text")
			var/var_new = input("Enter new text:","Text",O.vars[variable]) as null|text
			if(var_new==null) return
			O.vars[variable] = var_new

		if("num")
			if(variable=="luminosity")
				var/var_new = input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new == null) return
				O.sd_SetLuminosity(var_new)
			else
				var/var_new =  input("Enter new number:","Num",O.vars[variable]) as null|num
				if(var_new==null) return
				O.vars[variable] = var_new

		if("type")
			var/var_new = input("Enter type:","Type",O.vars[variable]) as null|anything in typesof(/obj,/mob,/area,/turf)
			if(var_new==null) return
			O.vars[variable] = var_new

		if("reference")
			var/var_new
			switch(alert("Would you like to enter a specific object, or search for it from the world?","Choose!","Specifc UID (Hexadecimal number)", "Search"))
				if("Specifc UID (Hexadecimal number)")
					var/UID = input("Type in UID, without the leading 0x","Type in UID") as text|null
					if(!UID) return
					if(length(UID) != 7)
						usr << "ERROR.  UID must be 7 digits"
					var/temp_variable = locate("\[0x[UID]\]")
					if(!temp_variable)
						usr << "ERROR.  Could not locate referenced object."
						return
					switch(alert("You have chosen [temp_variable], in [get_area(temp_variable)].  Are you sure?","You sure?","Yes","NONOCANCEL!"))
						if("Yes")
							var_new = temp_variable
						if("NONOCANCEL!")
							return
				if("Search")
					var_new = input("Select reference:","Reference") as null|mob|obj|turf|area in world
			if(var_new==null) return
			O.vars[variable] = var_new

		if("mob reference")
			var/var_new = input("Select reference:","Reference",O.vars[variable]) as null|mob in get_sorted_mobs()
			if(var_new==null) return
			O.vars[variable] = var_new

		if("file")
			var/var_new = input("Pick file:","File",O.vars[variable]) as null|file
			if(var_new==null) return
			O.vars[variable] = var_new

		if("icon")
			var/var_new = input("Pick icon:","Icon",O.vars[variable]) as null|icon
			if(var_new==null) return
			O.vars[variable] = var_new

		if("marked datum")
			O.vars[variable] = holder.marked_datum

	log_admin("[key_name(src)] modified [original_name]'s [variable] to [O.vars[variable]]")
	message_admins("[key_name_admin(src)] modified [original_name]'s [variable] to [O.vars[variable]]", 1)

