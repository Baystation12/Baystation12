
//Sleepers & Body Scanners

/obj/machinery/sleeper/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'

/obj/machinery/bodyscanner/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'

/obj/machinery/body_scanconsole/covenant
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1


/obj/machinery/body_scanconsole/covenant/New()
	. = ..()
	spawn( 5 )
		src.connected = locate(/obj/machinery/bodyscanner/covenant, get_step(src, WEST))
		return
	return
