/obj/item/device/assembly/paper_printer
	name = "paper printer"
	desc = "A device for printing paper."
	icon_state = "printer"
	item_state = "assembly"
	throwforce = 6
	w_class = 3
	throw_speed = 2
	throw_range = 10
	weight = 2
	var/copies = 1
	var/print = 1
	var/obj/item/weapon/paper/stored

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

/obj/item/device/assembly/paper_printer/receive_data(var/list/data)
	if(data.len)
		if(!stored)
			stored = new(src)
		for(var/T in data)
			if(istext(T))
				stored.info += T
		if(print)
			process_activation()
		return 1
	return 0

/obj/item/device/assembly/paper_printer/get_data()
	var/list/data = list()
	data.Add("Copies to print", copies, "Print on receiving data", (print ? "TRUE" : "FALSE"))
	return data

/obj/item/device/assembly/paper_printer/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Copies to print")
				var/N = max(min(10, text2num(input(usr, "How many copies would you like to print?", "Copies"))), 0)
				if(N) copies = N
			if("Print on receiving data")
				print = !print
	..()

/obj/item/device/assembly/paper_printer/activate()
	if(stored && stored.info)
		var/turf/T = get_turf(src)
		if(T)
			stored.forceMove(T)
			T.visible_message("<span class='notice'>\The [holder ? "[holder]" : "[src]"] rattles and spits out a piece of paper!</span>")
			return 1
	return 0



