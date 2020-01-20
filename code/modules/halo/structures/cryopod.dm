
/obj/machinery/cryopod/unsc
	icon = 'code/modules/halo/structures/unsccryopod.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "off"
	base_icon_state = "off"
	occupied_icon_state = "on"

/obj/machinery/cryopod/unsc/move_inside()
	if(..())
		flick("powering", src)


/obj/machinery/cryopod/covenant
	icon = 'code/modules/halo/covenant/cryotube.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "cell-on"
	base_icon_state = "cell-on"
	occupied_icon_state = "cell-occupied"