/obj/machinery/camera/autoname/invis
	name = "Invis Cam"
	desc = "This camera is used to simulate sensor-scans and other methods of viewing an area."
	invisibility =  60

/obj/machinery/camera/autoname/invis/ex_act() //No way to repair if damaged.
	return

/obj/machinery/camera/autoname/invis/isEmpProof() //No way to fix it if it gets EMPs.
	return 1

/obj/machinery/camera/autoname/invis/setPowerUsage() //Takes no power, is invis.
	return 0

/obj/machinery/camera/autoname/invis/debug_cov
	network = "cov debug"

/obj/machinery/camera/autoname/invis/debug_unsc
	network = "unsc debug"

/obj/machinery/camera/autoname/invis/debug_innie
	network = "innie debug"