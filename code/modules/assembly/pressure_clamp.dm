/obj/item/device/assembly/pressure_clamp
	name = "door jack"
	desc = "A self-pressurising pressue clamp lock."
	icon_state = "pressure_clamp"
	matter = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 50, "waste" = 25)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_ACTIVATE
	wire_num = 6

	var/trigger_action = "Open Door"
	var/list/trigger_actions = list("Open Door", "Close Door", "Lock Door", "Activate on door open")

	var/obj/machinery/door/airlock/target

	door_opened()
		if(trigger_action == "Activate on door open")
			return misc_activate()
		return 0

	misc_activate()
		if(active_wires & WIRE_MISC_ACTIVATE)
			send_pulse_to_connected()
			return 1

	attached_to(var/obj/machinery/door/airlock/D)
		if(D && istype(D))
			target = D
		return 1

	detatched_from(var/obj/machinery/door/airlock/D)
		if(D == target)
			target = null
		return 1

	get_data()
		var/list/data = list()
		data.Add("Function", trigger_action)
		return data

	activate()
		if(target)
			switch(trigger_action)
				if("Open Door")
					target.open(0)
				if("Close Door")
					target.close(0)
				if("Lock Door")
					target.lock(0)

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Trigger Action")
					var/index = trigger_actions.Find(trigger_action)
					if(!index || index == trigger_actions.len) index = 1
					else index += 1
					trigger_action = trigger_actions[index]
					usr << "<span class='notice'>You set \the [src]'s trigger action to \"[trigger_action]\"</span>"
		..()

