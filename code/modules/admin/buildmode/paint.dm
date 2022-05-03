/datum/build_mode/paint
	name = "Painter"
	icon_state = "mode_paint"
	/// Hex code. The selected color to paint with.
	var/selected_color


/datum/build_mode/paint/Help()
	to_chat(user, SPAN_NOTICE({"\
		Paint mode allows you to easily set colors of atoms and turfs.<br />\
		- Left Mouse Button On Atom         = Paint selected atom with saved color<br />\
		- Left Click + Shift OR Right Click = Set selected atom to default color<br />\
		- Left Mouse Button On Atom + Ctrl  = Copy selected atom's current color<br />\
		To manually set a color, right click on the 'PAINT' build mode icon.
	"}))


/datum/build_mode/paint/Configurate()
	var/new_color = input(user, "Please select the color to use.", "Paint Mode Color") as color|null
	if (!new_color)
		return
	selected_color = new_color
	to_chat(user, SPAN_NOTICE("Color set to <span style='color:[selected_color]'>[selected_color]</span>."))


/datum/build_mode/paint/OnClick(atom/A, list/parameters)
	var/result
	if (parameters["left"])
		if (parameters["shift"])
			result = clear_color(A)

		else if (parameters["ctrl"])
			result = clone_color(A)
			if (!result)
				to_chat(user, SPAN_NOTICE("Selected paint mode color is now <span style='color:[selected_color]'>[selected_color]</span>."))
				return

		else
			result = set_color(A)

	else if (parameters["right"])
		result = clear_color(A)

	if (result)
		to_chat(user, SPAN_WARNING("Paint mode operation failed: [result]"))



/datum/build_mode/paint/proc/clear_color(atom/A)
	if (!A)
		return "Invalid atom."
	A.set_color()


/datum/build_mode/paint/proc/clone_color(atom/A)
	if (!A)
		return "Invalid atom."
	var/new_color = A.get_color()
	if (!new_color)
		return "\The [A] has no color to clone."
	selected_color = new_color


/datum/build_mode/paint/proc/set_color(atom/A)
	if (!A)
		return "Invalid atom."
	if (!selected_color)
		return "No selected color to paint with. If you wish to remove the color, use RIGHTCLICK or SHIFT+LEFTCLICK."
	A.set_color(selected_color)
