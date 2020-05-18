//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*
	Telecomms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/


/obj/machinery/computer/telecomms/monitor
	name = "Telecommunications Monitor"
	icon_screen = "comm_monitor"

	var/screen = 0				// the screen number:
	var/list/machinelist = list()	// the machines located by the computer
	var/obj/machinery/telecomms/SelectedMachine

	var/network = "NULL"		// the network to probe

	var/temp = ""				// temporary feedback messages

	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return
		user.set_machine(src)
		var/list/dat = list()
		dat += "<TITLE>Telecommunications Monitor</TITLE><center><b>Telecommunications Monitor</b></center>"

		switch(screen)


		  // --- Main Menu ---

			if(0)
				dat += "<br>[temp]<br><br>"
				dat += "<br>Current Network: <a href='?src=\ref[src];network=1'>[network]</a><br>"
				if(machinelist.len)
					dat += "<br>Detected Network Entities:<ul>"
					for(var/obj/machinery/telecomms/T in machinelist)
						dat += "<li><a href='?src=\ref[src];viewmachine=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"
					dat += "</ul>"
					dat += "<br><a href='?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"
				else
					dat += "<a href='?src=\ref[src];operation=probe'>\[Probe Network\]</a>"


		  // --- Viewing Machine ---

			if(1)
				dat += "<br>[temp]<br>"
				dat += "<center><a href='?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a></center>"
				dat += "<br>Current Network: [network]<br>"
				dat += "Selected Network Entity: [SelectedMachine.name] ([SelectedMachine.id])<br>"
				dat += "Linked Entities: <ol>"
				for(var/obj/machinery/telecomms/T in SelectedMachine.links)
					if(!T.hide)
						dat += "<li><a href='?src=\ref[src];viewmachine=[T.id]'>\ref[T.id] [T.name]</a> ([T.id])</li>"
				dat += "</ol>"


		var/datum/browser/popup = new(user, "comm_monitor", "Autholathe", 575, 400)
		popup.set_content(JOINTEXT(dat))
		popup.open()

		temp = ""
		return


	Topic(href, href_list)
		if(..())
			return

		usr.set_machine(src)

		if(href_list["viewmachine"])
			screen = 1
			for(var/obj/machinery/telecomms/T in machinelist)
				if(T.id == href_list["viewmachine"])
					SelectedMachine = T
					break

		if(href_list["operation"])
			switch(href_list["operation"])

				if("release")
					machinelist = list()
					screen = 0

				if("mainmenu")
					screen = 0

				if("probe")
					if(machinelist.len > 0)
						temp = "<font color = #d70b00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font>"

					else
						for(var/obj/machinery/telecomms/T in range(25, src))
							if(T.network == network)
								machinelist.Add(T)

						if(!machinelist.len)
							temp = "<font color = #d70b00>- FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\] -</font>"
						else
							temp = "<font color = #336699>- [machinelist.len] ENTITIES LOCATED & BUFFERED -</font>"

						screen = 0


		if(href_list["network"])

			var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text
			if(newnet && ((usr in range(1, src) || issilicon(usr))))
				if(length(newnet) > 15)
					temp = "<font color = #d70b00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font>"

				else
					network = newnet
					screen = 0
					machinelist = list()
					temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font>"

		updateUsrDialog()
		return

/obj/machinery/computer/telecomms/monitor/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		req_access.Cut()
		to_chat(user, "<span class='notice'>You you disable the security protocols</span>")
		src.updateUsrDialog()
		return 1
