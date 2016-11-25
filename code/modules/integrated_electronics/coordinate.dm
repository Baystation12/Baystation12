//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	icon_state = "gps"
	complexity = 4
	inputs = list()
	outputs = list("X (abs)", "Y (abs)", "Z (abs)")
	activators = list("get coordinates")

/obj/item/integrated_circuit/gps/do_work()
	var/turf/T = get_turf(src)

	set_pin_data(IC_OUTPUT, 1, T && T.x)
	set_pin_data(IC_OUTPUT, 2, T && T.y)
	set_pin_data(IC_OUTPUT, 3, T && T.z)

/obj/item/integrated_circuit/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	inputs = list("X1 (abs)", "Y1 (abs)", "Z1 (abs)", "X2 (abs)", "Y2 (abs)", "Z2 (abs)")
	outputs = list("X (rel)", "Y (rel)", "Z (rel)")
	activators = list("compute rel coordinates")

/obj/item/integrated_circuit/abs_to_rel_coords/do_work()
	var/x1 = get_pin_data(IC_INPUT, 1)
	var/y1 = get_pin_data(IC_INPUT, 2)
	var/z1 = get_pin_data(IC_INPUT, 3)

	var/x2 = get_pin_data(IC_INPUT, 4)
	var/y2 = get_pin_data(IC_INPUT, 5)
	var/z2 = get_pin_data(IC_INPUT, 6)

	set_pin_data(IC_OUTPUT, 1, isnum(x1) && isnum(x2) && (x1 - x2))
	set_pin_data(IC_OUTPUT, 2, isnum(y1) && isnum(y2) && (y1 - y2))
	set_pin_data(IC_OUTPUT, 3, isnum(z1) && isnum(z2) && (z1 - z2))
