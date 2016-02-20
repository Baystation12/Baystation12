/obj/item/device/assembly/dice
	name = "modified dice"
	desc = "A couple of dice with wires poking out of them..Hm."
	icon_state = "dice"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

	var/list/to_pick = list()

	activate()
		send_data(list(pick(to_pick)))
		return 1

	signal_failure(var/sent = 0)
		if(sent && prob(50))
			send_data(list(pick("1", "59", "!%ùËr", "brumm", "Oesophagus", "why", "undergraduate tomato")))

	get_data()
		var/list/data = list()
		for(var/i=1,i<=to_pick.len,i++)
			data.Add("Random [i]", to_pick[i])
		return data

	get_buttons()
		var/list/data = list()
		if(to_pick.len < 5)
			data.Add("Add Random")
		return data

	Topic(href, href_list)
		if(href_list["option"])
			for(var/i=1,i<=to_pick.len,i++)
				if(href_list["option"] == "Random [i]")
					var/inp = input(usr, "What would you like to set the random to?", "Dice")
					if(inp)
						to_pick[i] = inp
					else
						to_pick.Cut(i,i+1)
			if(href_list["option"] == "Add Random")
				var/inp = input(usr, "What would you like to set the random to?", "Dice")
				if(inp)
					to_pick.Add(inp)
		..()