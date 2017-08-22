
/obj/machinery/cryopod/unsc
	icon = 'code/modules/halo/misc/unsccryopod.dmi'
	bound_width = 64
	bound_height = 64
	icon_state = "off"
	base_icon_state = "off"
	occupied_icon_state = "on"

/obj/machinery/cryopod/unsc/move_inside()
	if(..())
		flick("powering", src)
