/datum/build_mode/edit
	name = "Edit"
	icon_state = "buildmode3"
	var/static/help_text = {"\
	***********Edit Mode***********
	Right Click on Mode Button = Select var & value
	Left Click on Atom = Set the var on the atom
	Right Click on Atom = Reset (initial) the var on the atom
	*******************************
	"}
	var/var_to_edit = "name"
	var/value_to_set = "derp"


/datum/build_mode/edit/Destroy()
	ClearValue()
	. = ..()


/datum/build_mode/edit/Help()
	to_chat(user, help_text)


/datum/build_mode/edit/Configurate()
	var/var_name = input("Enter variable name:", "Name", var_to_edit) as null | text
	if (!var_name)
		return
	var/var_type = input("Select variable type:", "Type") as null | anything in list("text", "number", "mob-reference", "obj-reference", "turf-reference")
	if (isnull(var_type))
		return
	var/new_value
	switch (var_type)
		if ("text")
			new_value = input(usr, "Enter variable value:", "Value", value_to_set) as null | text
		if ("number")
			new_value = input(usr, "Enter variable value:", "Value", value_to_set) as null | num
		if ("mob-reference")
			new_value = input(usr, "Enter variable value:", "Value", value_to_set) as null | mob in SSmobs.mob_list
		if ("obj-reference")
			new_value = input(usr, "Enter variable value:", "Value", value_to_set) as null | obj in world
		if ("turf-reference")
			new_value = input(usr, "Enter variable value:", "Value", value_to_set) as null | turf in world
	if (var_name && new_value)
		var_to_edit = var_name
		SetValue(new_value)


/datum/build_mode/edit/OnClick(atom/A, list/parameters)
	if (!A.may_edit_var(usr, var_to_edit))
		return
	var/old_value = A.vars[var_to_edit]
	var/new_value
	if (parameters["left"])
		new_value = value_to_set
	if (parameters["right"])
		new_value = initial(A.vars[var_to_edit])
	if (old_value == new_value)
		return
	A.vars[var_to_edit] = new_value
	to_chat(user, "<span class='notice'>Changed the value of [var_to_edit] from '[old_value]' to '[new_value]'.</span>")
	Log("[log_info_line(A)] - [var_to_edit] - [old_value] -> [new_value]")


/datum/build_mode/edit/proc/SetValue(new_value)
	if (value_to_set == new_value)
		return
	ClearValue()
	value_to_set = new_value
	GLOB.destroyed_event.register(value_to_set, src, /datum/build_mode/edit/proc/ClearValue)


/datum/build_mode/edit/proc/ClearValue(feedback)
	if (!istype(value_to_set, /datum))
		return
	GLOB.destroyed_event.unregister(value_to_set, src, /datum/build_mode/edit/proc/ClearValue)
	value_to_set = initial(value_to_set)
	if (feedback)
		Warn("The selected reference value was deleted. Default value restored.")
