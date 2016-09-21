/obj/machinery/camera/autoname/battle
	has_circuit = 1

/obj/machinery/camera/autoname/battle/initialize()
	..()
	var/list/new_network = list()
	var/area/ship_battle/A = get_area(src)
	if(A && istype(A))
		switch(A.team)
			if(1)
				new_network.Add("Team One")
			if(2)
				new_network.Add("Team Two")
			if(3)
				new_network.Add("Team Three")
			if(4)
				new_network.Add("Team Four")
	var/obj/effect/overmap/linked = map_sectors["[z]"]
	if(linked)
		new_network.Add("[linked.name]")

/*	spawn(10)
		number = 1
		var/area/AB = get_area(src)
		if(AB)
			for(var/obj/machinery/camera/network/battle/C in world)
				if(C == src) continue
				var/area/CA = get_area(C)
				if(CA.type == AB.type)
					if(C.number)
						number = max(number, C.number+1)
			c_tag = "[AB.name] #[number]"
*/
	add_networks(new_network)
	invalidateCameraCache()

/obj/machinery/modular_computer/console/preset/security/battle/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor/battle())