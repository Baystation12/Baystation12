/obj/item/device/assembly/screen
	name = "screen"
	desc = "You can see a distorted image of something dumb..Then you realise it's you."
	icon_state = "screen"
	matter = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 900, "waste" = 90)
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_CONNECTION
	wire_num = 4

	var/message = "NULL"
	var/pmessage = "This isn't going to appear, I hope."
	var/on = 0
	var/flash = 0

	receive_data(var/list/data, var/obj/item/device/assembly/sender)
		if(!data.len || !on)
			add_debug_log("Unable to obtain data \[[src]\]")
			return 0
		if(istext(data[1]))
			pmessage = message
			message = data[1]
			examined_additions.Cut()
			examined_additions.Add(message)
			add_debug_log("Message set to: [message] \[[src]\]")
			if(holder)
				holder.visible_message("<span class='notice'><IMG CLASS=icon SRC=\ref[icon] ICONSTATE='[icon_state]'>[holder] flashes: \"[message]\"!")

		return 1

	activate()
		on = !on
		if(holder)
			if(on)
				examined_additions.Add(message)
				holder.visible_message("<span class='notice'><IMG CLASS=icon SRC=\ref[icon] ICONSTATE='[icon_state]'>[holder] flashes: \"[message]\"!")
		return 1

	examine(var/mob/user)
		..()
		if(message)
			user << message

	emp_act(var/severity = 1)
		receive_data(pick("E-ER&%O-", "HONK!", "A fatal error has occured. Please cons^$- CapTin&Krun-nch!"))

	get_data(var/mob/user, var/ui_key)
		var/list/data = list()
		data.Add("Message", message, "On", on, "Flash Message", flash)
		return data

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Message")
					var/new_message = input(usr, "What message would you like to display?", "Message")
					if(new_message)
						pmessage = message
						message = new_message
						examined_additions.Add(message)
				if("On")
					process_activation()
					usr << "You turn \the [src] [on ? "on" : "off"]"
				if("Flash Message")
					flash = !flash
		..()

