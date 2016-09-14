/obj/machinery/power/fission_reactor
	name = "Fission Reactor"
	desc = "A small-scale sun lives in here. There's a warning on it, \"DO NOT TOUCH!\""
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "fission_reactor"
	anchored = 1
	density = 1
	var/power_generation_rate = 5000 //5kw
	var/powernet_connection_failed = 0

/obj/machinery/power/fission_reactor/process()
	if(!powernet && !powernet_connection_failed)
		if(!connect_to_network())
			powernet_connection_failed = 1
			spawn(150) // Error! Check again in 15 seconds.
				powernet_connection_failed = 0
	add_avail(power_generation_rate)

/obj/machinery/power/fission_reactor/ex_act(var/severity = 0)
	if(severity <= 2.0)
		explosion(src, 4, 8, 12, 4) //BOOM.
		spawn(0)
			qdel(src)
	return 1