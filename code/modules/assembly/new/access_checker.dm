/obj/item/device/assembly/access_checker
	name = "access checker"
	desc = "A modified card reader. This one only reads access."
	icon_state = "card_reader"
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 500, "waste" = 150)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE| WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 4

	var/list/access_levels_requireds = list("One", "Minority", "Half", "Majority", "All", "None")
	var/access_levels_required = "All"
	var/list/access_required = list()

	get_help_info()
		var/T = "\
		This is a modified card reader. It reads \
		numeral encryption codes of access contained \
		in ID cards and matches it to the set access \
		parameters. Once a certain percentage of matches \
		has been found, it will pulse connected devices. \
		\n Pulse Action: Pulses connected.\n Data Receival: \
		Checks numeral identification.\n Receiving Data Action: \
		Compares numeral identification of data to set access. \
		\n <b>Settings</b>\
		\n Match Count Required: Percentage of set access \
		requirement matches required before sending pulse. \
		Greater than or equal to."
		return T

	receive_data(var/list/data)
		add_debug_log("Data Process Begun \[[src]\]")
		var/match_count = 0
		for(var/N in data)
			world << "Data:[N]"
			var/access = text2num(N)
			if(access && access in get_all_accesses())
				if(access in access_required)
					match_count++
		switch(access_levels_required)
			if("One")
				if(match_count)
					process_activation()
			else if("Minority")
				if(match_count >= access_required.len / 4)
					process_activation()
			else if("Half")
				if(match_count >= access_required.len / 2)
					process_activation()
			else if("Majority")
				if(match_count >= access_required.len / 1.33)
					process_activation()
			else if("All")
				if(match_count >= access_required.len)
					process_activation()
			else if("None")
				if(!match_count)
					process_activation()
			else
				var/turf/T = get_turf(src)
				if(T)
					T.visible_message("<span class='warning'>\icon[src] Access denied!</span>")
				add_debug_log("Access denied. \[[src]\]")
				return 0
		add_debug_log("Access granted. \[[src]\]")
		return 1

	get_data()
		var/list/data = list()
		data.Add("Match Count Required", access_levels_required)
		return data

	get_nonset_data()
		var/list/data = list()
		if(access_required.len)
			data.Add("<b>Access Levels Required:</b>")
			for(var/access in access_required)
				data.Add(get_access_desc(access))

	get_buttons()
		var/list/data = list()
		data.Add("Set Access")
		return data

	//Got this from airlock_electronics..
	proc/access_window(var/mob/user as mob)
		var/t1 = ""
		var/list/accesses = get_all_accesses()
		for(var/acc in accesses)
			var/aname = get_access_desc(acc)
			if (!access_required || !access_required.len || !(acc in access_required))
				t1 += "<a href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
		t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)
		user << browse(t1, "window=airlock_electronics")
		onclose(user, "airlock")

	Topic(href, href_list)
		if(href_list["close"])
			usr << browse(null, "window=airlock")
			return
		if (href_list["access"])
			var/acc = href_list["access"]
			if (acc == "all")
				access_required = null
			else
				var/req = text2num(acc)

				if(access_required == null)
					access_required = list()

				if(!(req in access_required))
					access_required += req
				else
					access_required -= req
			access_window(usr)


		if(href_list["option"])
			switch(href_list["option"])
				if("Set Access")
					access_window(usr)
				if("Match Count Required")
					var/index = access_levels_requireds.Find(access_levels_required)
					if(!index || index == access_levels_requireds.len) index = 1
					else index += 1
					access_levels_required = access_levels_requireds[index]
					usr << "\blue You set \the [src]'s required match count to \"[access_levels_required]\""

		..()