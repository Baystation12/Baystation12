//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/telecomms
	icon_keyboard = "tech_key"

/obj/machinery/computer/telecomms/server
	name = "Telecommunications Server Monitor"
	icon_screen = "comm_logs"

	var/screen = 0				// the screen number:
	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer

	var/network = "NULL"		// the network to probe
	var/temp = ""				// temporary feedback messages

	var/universal_translate = 0 // set to 1 if it can translate nonhuman speech

	req_access = list(access_tcomsat)

	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/dat = "<TITLE>Telecommunication Server Monitor</TITLE><center><b>Telecommunications Server Monitor</b></center>"

		switch(screen)


		  // --- Main Menu ---

			if(0)
				dat += "<br>[temp]<br>"
				dat += "<br>Current Network: <a href='?src=\ref[src];network=1'>[network]</a><br>"
				if(servers.len)
					dat += "<br>Detected Telecommunication Servers:<ul>"
					for(var/obj/machinery/telecomms/T in servers)
						dat += "<li><a href='?src=\ref[src];viewserver=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"
					dat += "</ul>"
					dat += "<br><a href='?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"

				else
					dat += "<br>No servers detected. Scan for servers: <a href='?src=\ref[src];operation=scan'>\[Scan\]</a>"


		  // --- Viewing Server ---

			if(1)
				dat += "<br>[temp]<br>"
				dat += "<center><a href='?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a>     <a href='?src=\ref[src];operation=refresh'>\[Refresh\]</a></center>"
				dat += "<br>Current Network: [network]"
				dat += "<br>Selected Server: [SelectedServer.id]"

				if(SelectedServer.totaltraffic >= 1024)
					dat += "<br>Total recorded traffic: [round(SelectedServer.totaltraffic / 1024)] Terrabytes<br><br>"
				else
					dat += "<br>Total recorded traffic: [SelectedServer.totaltraffic] Gigabytes<br><br>"

				dat += "Stored Logs: <ol>"

				var/i = 0
				for(var/datum/comm_log_entry/C in SelectedServer.log_entries)
					i++


					// If the log is a speech file
					if(C.input_type == "Speech File")

						dat += "<li><font color = #008F00>[C.name]</font>  <font color = #FF0000><a href='?src=\ref[src];delete=[i]'>\[X\]</a></font><br>"

						// -- Determine race of orator --

						var/race = C.parameters["race"]			   // The actual race of the mob
						var/language = C.parameters["language"] // The language spoken, or null/""

						// -- If the orator is a human, or universal translate is active, OR mob has universal speech on --

						if(universal_translate || C.parameters["uspeech"] || C.parameters["intelligible"])
							dat += "<u><font color = #18743E>Data type</font></u>: [C.input_type]<br>"
							dat += "<u><font color = #18743E>Source</font></u>: [C.parameters["name"]] (Job: [C.parameters["job"]])<br>"
							dat += "<u><font color = #18743E>Class</font></u>: [race]<br>"
							dat += "<u><font color = #18743E>Contents</font></u>: \"[C.parameters["message"]]\"<br>"
							if(language)
								dat += "<u><font color = #18743E>Language</font></u>: [language]<br/>"

						// -- Orator is not human and universal translate not active --

						else
							dat += "<u><font color = #18743E>Data type</font></u>: Audio File<br>"
							dat += "<u><font color = #18743E>Source</font></u>: <i>Unidentifiable</i><br>"
							dat += "<u><font color = #18743E>Class</font></u>: [race]<br>"
							dat += "<u><font color = #18743E>Contents</font></u>: <i>Unintelligble</i><br>"

						dat += "</li><br>"

					else if(C.input_type == "Execution Error")

						dat += "<li><font color = #990000>[C.name]</font>  <font color = #FF0000><a href='?src=\ref[src];delete=[i]'>\[X\]</a></font><br>"
						dat += "<u><font color = #787700>Output</font></u>: \"[C.parameters["message"]]\"<br>"
						dat += "</li><br>"


				dat += "</ol>"



		user << browse(dat, "window=comm_monitor;size=575x400")
		onclose(user, "server_control")

		temp = ""
		return


	Topic(href, href_list)
		if(..())
			return


		add_fingerprint(usr)
		usr.set_machine(src)

		if(href_list["viewserver"])
			screen = 1
			for(var/obj/machinery/telecomms/T in servers)
				if(T.id == href_list["viewserver"])
					SelectedServer = T
					break

		if(href_list["operation"])
			switch(href_list["operation"])

				if("release")
					servers = list()
					screen = 0

				if("mainmenu")
					screen = 0

				if("scan")
					if(servers.len > 0)
						temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font>"

					else
						for(var/obj/machinery/telecomms/server/T in range(25, src))
							if(T.network == network)
								servers.Add(T)

						if(!servers.len)
							temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\] -</font>"
						else
							temp = "<font color = #336699>- [servers.len] SERVERS PROBED & BUFFERED -</font>"

						screen = 0

		if(href_list["delete"])

			if(!src.allowed(usr) && !emagged)
				to_chat(usr, "<span class='warning'>ACCESS DENIED.</span>")
				return

			if(SelectedServer)

				var/datum/comm_log_entry/D = SelectedServer.log_entries[text2num(href_list["delete"])]

				temp = "<font color = #336699>- DELETED ENTRY: [D.name] -</font>"

				SelectedServer.log_entries.Remove(D)
				qdel(D)

			else
				temp = "<font color = #D70B00>- FAILED: NO SELECTED MACHINE -</font>"

		if(href_list["network"])

			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text

			if(newnet && ((usr in range(1, src) || issilicon(usr))))
				if(length(newnet) > 15)
					temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font>"

				else

					network = newnet
					screen = 0
					servers = list()
					temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font>"

		updateUsrDialog()
		return

	attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
		if(istype(D, /obj/item/weapon/screwdriver))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			if(do_after(user, 20, src))
				if (src.stat & BROKEN)
					to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
					var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
					new /obj/item/weapon/material/shard( src.loc )
					var/obj/item/weapon/circuitboard/comm_server/M = new /obj/item/weapon/circuitboard/comm_server( A )
					for (var/obj/C in src)
						C.loc = src.loc
					A.circuit = M
					A.state = 3
					A.icon_state = "3"
					A.anchored = 1
					qdel(src)
				else
					to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
					var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
					var/obj/item/weapon/circuitboard/comm_server/M = new /obj/item/weapon/circuitboard/comm_server( A )
					for (var/obj/C in src)
						C.loc = src.loc
					A.circuit = M
					A.state = 4
					A.icon_state = "4"
					A.anchored = 1
					qdel(src)
		src.updateUsrDialog()
		return

/obj/machinery/computer/telecomms/server/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols</span>")
		src.updateUsrDialog()
		return 1
