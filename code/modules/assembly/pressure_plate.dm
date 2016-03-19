/obj/item/device/assembly/mousetrap/pressure_plate
	name = "modified mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents. This one has wires poking out of it."
	icon_state = "mousetrap"
	matter = list(DEFAULT_WALL_MATERIAL = 100, "waste" = 10)
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND
	wire_num = 5

	update_icon()
		return 1

	activate()
		armed = !armed
		return 1

/obj/item/device/assembly/mousetrap/pressure_plate/triggered(mob/target as mob, var/type = "feet")
	..()
	if(prob(95))
		armed = 1 // Stays armed when triggered.
	else
		for(var/mob/M in view(2))
			M.show_message("<small>You hear small metal parts banging together</small>")
	send_pulse_to_connected()

/obj/item/device/assembly/mousetrap/pressure_plate/attack_hand(mob/living/user as mob)
	if(holder)
		return holder.attack_hand(user)
	..()

/obj/item/device/assembly/mousetrap/pressure_plate/get_data(var/mob/user, var/ui_key)
	var/list/data = list()
	data.Add("Armed", armed)
	return data

/obj/item/device/assembly/mousetrap/pressure_plate/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Armed")
				armed = !armed
	..()
