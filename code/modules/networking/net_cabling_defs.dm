//There was a bunch of shitty cabling code here before.  Now there's some lovely modular stuff.  Yay.

//Longrange networking cable.  Connects network machinery to network machinery.
/obj/structure/uninet_link/cable/longrange_networking
	icon = 'icons/obj/power_cond_blue.dmi' //[TODO] new sprites

	name = "Longrange Networking Cable"

	connectable_types = list( /obj/machinery/networking )
	network_controller_type = /datum/controller/uninet_controller/LongrangeNetworkingController
	cable_piece_type = /obj/item/cable_coil/longrange_networking
	equivalent_cable_type = /obj/structure/uninet_link/cable/longrange_networking

/obj/structure/uninet_link/cable/longrange_networking/red
	icon = 'icons/obj/power_cond_red.dmi'

/obj/item/cable_coil/longrange_networking
	icon_state = "net1coil3"
	coil_colour = "net1"
	base_name  = "Longrange Networking"
	short_desc = "A piece of longrange networking cable"
	long_desc  = "A long piece of longrange networking cable"
	coil_desc  = "A Spool of longrange networking cable"
	cable_type = /obj/structure/uninet_link/cable/longrange_networking

/obj/item/cable_coil/longrange_networking/red
	icon_state = "redcoil3"
	coil_colour = "red"
	cable_type = /obj/structure/uninet_link/cable/longrange_networking/red

//Local networking cable.  Connects normal machinery to ANCs.
/obj/structure/uninet_link/cable/local_networking
	icon = 'icons/obj/power_cond_cyan.dmi' //[TODO] new sprites

	name = "Local Networking Cable"

	connectable_types = list( /obj/machinery/networking/anc, /obj/machinery )
	network_controller_type = /datum/controller/uninet_controller/LocalNetworkingController
	cable_piece_type = /obj/item/cable_coil/local_networking
	equivalent_cable_type = /obj/structure/uninet_link/cable/local_networking

/obj/item/cable_coil/local_networking
	icon_state = "net2coil3"
	coil_colour = "net2"
	base_name  = "Local Networking"
	short_desc = "A piece of local networking cable"
	long_desc  = "A long piece of local networking cable"
	coil_desc  = "A Spool of local networking cable"
	cable_type = /obj/structure/uninet_link/cable/local_networking
