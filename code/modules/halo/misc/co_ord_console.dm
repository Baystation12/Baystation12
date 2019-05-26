
/obj/structure/co_ord_console
	name = "Sector Scanning Console"
	desc = "A console linked to scanning equipment."
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"
	anchored = 1
	density = 1

	var/list/known_locations = list() //Typepaths = name

/obj/structure/co_ord_console/attack_hand(var/mob/user)
	visible_message("[user] starts accessing [src]'s databanks...")
	if(!do_after(user,5 SECONDS,src))
		return
	var/data = ""
	for(var/typepath in known_locations)
		var/obj/instance = locate(typepath)
		if(instance)
			data += "[known_locations[typepath]] : [instance.x],[instance.y]\n"

	visible_message("[user] accesses [src]'s databanks.")
	to_chat(user,"<span class = 'notice'>Data Retrieved:\n[data]</span>")

/obj/structure/co_ord_console/ex_act()
	return

/obj/structure/co_ord_console/bullet_act()
	return

/obj/structure/co_ord_console/attackby()
	return