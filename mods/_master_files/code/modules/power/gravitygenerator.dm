/obj/machinery/gravity_generator
	use_power = 0
	unacidable = TRUE
	light_color = "#7de1e1"

/obj/machinery/gravity_generator/ex_act(severity)
	return

/obj/machinery/gravity_generator/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/machinery/gravity_generator/bullet_act(obj/item/projectile/P, def_zone)
	return
