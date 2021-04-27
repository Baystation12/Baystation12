#define CHECK_LATHE \
	if(!linked_lathe){\
		screen = 1;\
		return};\
	if(!linked_lathe.reagents){\
		crash_with("An rdconsole's linked lathe's reagents holder was deleted.");\
		screen = 1;\
		return}
#define CHECK_IMPRINTER \
	if(!linked_imprinter){\
		screen = 1;\
		return}
#define CHECK_DESTROY \
	if(!linked_destroy){\
		screen = 1;\
		return}
/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second method is with Technology Disks and Design Disks. Each of these disks can hold a single technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This method is a lot more secure (since it
won't update every console in existence) but it's more of a hassle to do. Also, the disks can be stolen.
*/

/obj/machinery/computer/rdconsole
	name = "fabrication control console"
	desc = "Console controlling the various fabrication devices. Uses self-learning matrix to hold and optimize blueprints. Prone to corrupting said matrix, so back up often."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	base_type = /obj/machinery/computer/rdconsole/core
	machine_name = "\improper R&D control console"
	machine_desc = "Used to operate an R&D setup, including protolathes, circuit imprinters, and destructive analyzers. Can be configured with a screwdriver."
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/screen = 1.0	//Which screen is currently showing.
	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console
	var/can_analyze = TRUE //If the console is allowed to use destructive analyzers

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

/obj/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if(MATERIAL_STEEL)
			return_name = "Steel"
		if(MATERIAL_ALUMINIUM)
			return_name = "Aluminium"
		if(MATERIAL_GLASS)
			return_name = "Glass"
		if(MATERIAL_PLASTIC)
			return_name = "Plastic"
		if(MATERIAL_GOLD)
			return_name = "Gold"
		if(MATERIAL_SILVER)
			return_name = "Silver"
		if(MATERIAL_PHORON)
			return_name = "Solid Phoron"
		if(MATERIAL_URANIUM)
			return_name = "Uranium"
		if(MATERIAL_DIAMOND)
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/reagent_type)
	var/datum/reagent/R = reagent_type
	return ispath(reagent_type, /datum/reagent) ? initial(R.name) : "Unknown"

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(4, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer) && can_analyze == TRUE) // Only science R&D consoles can do research
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/New()
	..()
	files = new /datum/research(src) //Setup the research data holder.
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in SSmachines.machinery)
			S.update_connections()
			break

/obj/machinery/computer/rdconsole/Initialize()
	SyncRDevices()
	. = ..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/D as obj, var/mob/user as mob)
	//Loading a disk into it.
	if(istype(D, /obj/item/disk))
		if(t_disk || d_disk)
			to_chat(user, "A disk is already loaded into the machine.")
			return
		if(!user.canUnEquip(D))
			return
		if(istype(D, /obj/item/disk/tech_disk))
			t_disk = D
		else if (istype(D, /obj/item/disk/design_disk))
			d_disk = D
		else
			to_chat(user, "<span class='notice'>Machine cannot accept disks in that format.</span>")
			return
		user.drop_from_inventory(D, src)
		to_chat(user, "<span class='notice'>You add \the [D] to the machine.</span>")
	else
		//The construction/deconstruction of the console code.
		..()

	src.updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = TRUE
		req_access.Cut()
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

/obj/machinery/computer/rdconsole/CanUseTopic(var/mob/user, var/datum/topic_state/state, var/href_list)
	if(href_list && href_list["menu"])
		var/temp_screen = text2num(href_list["menu"])
		if(!((temp_screen <= 1.1) || (3 <= temp_screen && 4.9 >= temp_screen) || allowed(user)))
			to_chat(user, "Unauthorized Access.")
			return STATUS_CLOSE
	return ..()

/obj/machinery/computer/rdconsole/OnTopic(user, href_list)
	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		screen = text2num(href_list["menu"])
		. = TOPIC_REFRESH

	else if(href_list["updt_tech"]) //Update the research holder with information from the technology disk.
		. = TOPIC_REFRESH
		if(!t_disk)
			screen = 1
			return
		screen = 0.0
		spawn(50)
			if(!t_disk)
				screen = 1
				return
			screen = 1.2
			files.AddTech2Known(t_disk.stored)
			updateUsrDialog()

	else if(href_list["clear_tech"]) //Erase data on the technology disk.
		. = TOPIC_REFRESH
		if(!t_disk)
			screen = 1
			return
		t_disk.stored = null

	else if(href_list["eject_tech"]) //Eject the technology disk.
		t_disk.dropInto(loc)
		t_disk = null
		screen = 1.0
		. = TOPIC_REFRESH

	else if(href_list["copy_tech"]) //Copys some technology data from the research holder to the disk.
		. = TOPIC_REFRESH
		if(!t_disk)
			screen = 1
			return
		for(var/datum/tech/T in files.known_tech)
			if(href_list["copy_tech_ID"] == T.id)
				t_disk.stored = T
				break
		screen = 1.2

	else if(href_list["updt_design"]) //Updates the research holder with design data from the design disk.
		. = TOPIC_REFRESH
		if(!d_disk)
			screen = 1
			return
		screen = 0.0
		spawn(50)
			if(!d_disk)
				screen = 1
				return
			screen = 1.4
			files.AddDesign2Known(d_disk.blueprint)
			updateUsrDialog()

	else if(href_list["clear_design"]) //Erases data on the design disk.
		. = TOPIC_REFRESH
		if(!d_disk)
			screen = 1
			return
		d_disk.blueprint = null

	else if(href_list["eject_design"]) //Eject the design disk.
		if(d_disk)
			d_disk.dropInto(loc)
		d_disk = null
		screen = 1.0
		. = TOPIC_REFRESH

	else if(href_list["copy_design"]) //Copy design data from the research holder to the design disk.
		. = TOPIC_REFRESH
		if(!d_disk)
			screen = 1
			return
		for(var/datum/design/D in files.known_designs)
			if(href_list["copy_design_ID"] == D.id)
				d_disk.blueprint = D
				break
		screen = 1.4

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		. = TOPIC_REFRESH
		CHECK_DESTROY
		if(linked_destroy.busy)
			to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")

		else if(linked_destroy.loaded_item)
			linked_destroy.loaded_item.dropInto(linked_destroy.loc)
			linked_destroy.loaded_item = null
			linked_destroy.icon_state = "d_analyzer"
			screen = 2.1

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		. = TOPIC_REFRESH
		CHECK_DESTROY
		if(linked_destroy.busy)
			to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")
			return TOPIC_HANDLED
		if(alert("Proceeding will destroy loaded item. Continue?", "Destructive analyzer confirmation", "Yes", "No") == "No")
			return TOPIC_HANDLED
		CHECK_DESTROY
		linked_destroy.busy = 1
		screen = 0.1
		flick("d_analyzer_process", linked_destroy)
		addtimer(CALLBACK(src, .proc/finish_deconstruct, weakref(user)), 24)

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr))
			screen = text2num(href_list["lock"])
		else
			to_chat(usr, "Unauthorized Access.")
		. = TOPIC_REFRESH

	else if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		screen = 0.0
		if(!sync)
			to_chat(usr, "<span class='notice'>You must connect to the network first.</span>")
		else
			. = TOPIC_HANDLED
			spawn(30)
				if(src)
					for(var/obj/machinery/r_n_d/server/S in SSmachines.machinery)
						var/server_processed = 0
						if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in files.known_tech)
								S.files.AddTech2Known(T)
							for(var/datum/design/D in files.known_designs)
								S.files.AddDesign2Known(D)
							S.files.RefreshResearch()
							server_processed = 1
						if((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in S.files.known_tech)
								files.AddTech2Known(T)
							for(var/datum/design/D in S.files.known_designs)
								files.AddDesign2Known(D)
							files.RefreshResearch()
							server_processed = 1
						if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
							S.produce_heat()
					screen = 1.6
					interact(user)

	else if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync
		. = TOPIC_REFRESH

	else if(href_list["build"]) //Causes the Protolathe to build something.
		. = TOPIC_REFRESH
		CHECK_LATHE
		var/datum/design/being_built = null
		for(var/datum/design/D in files.known_designs)
			if(D.id == href_list["build"])
				being_built = D
				break
		if(being_built)
			linked_lathe.addToQueue(being_built)
		screen = 3.1

	else if(href_list["imprint"]) //Causes the Circuit Imprinter to build something.
		. = TOPIC_REFRESH
		CHECK_IMPRINTER
		var/datum/design/being_built = null
		for(var/datum/design/D in files.known_designs)
			if(D.id == href_list["imprint"])
				being_built = D
				break
		if(being_built)
			linked_imprinter.addToQueue(being_built)
		screen = 4.1

	else if(href_list["disposeI"])  //Causes the circuit imprinter to dispose of a single reagent (all of it)
		. = TOPIC_REFRESH
		CHECK_IMPRINTER
		var/datum/reagent/R = locate(href_list["disposeI"]) in linked_imprinter.reagents.reagent_list
		if(R)
			linked_imprinter.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallI"]) //Causes the circuit imprinter to dispose of all it's reagents.
		. = TOPIC_REFRESH
		CHECK_IMPRINTER
		linked_imprinter.reagents.clear_reagents()

	else if(href_list["removeI"])
		. = TOPIC_REFRESH
		CHECK_LATHE
		linked_imprinter.removeFromQueue(text2num(href_list["removeI"]))

	else if(href_list["disposeP"])  //Causes the protolathe to dispose of a single reagent (all of it)
		. = TOPIC_REFRESH
		CHECK_LATHE
		var/datum/reagent/R = locate(href_list["disposeP"]) in linked_lathe.reagents.reagent_list
		if(R)
			linked_lathe.reagents.del_reagent(R.type)

	else if(href_list["disposeallP"]) //Causes the protolathe to dispose of all it's reagents.
		. = TOPIC_REFRESH
		CHECK_LATHE
		linked_lathe.reagents.clear_reagents()

	else if(href_list["removeP"])
		. = TOPIC_REFRESH
		CHECK_LATHE
		var/to_remove = text2num(href_list["removeP"])
		if(sanitize_integer(to_remove, 1, length(linked_lathe.queue), 1) == to_remove)
			linked_lathe.removeFromQueue(to_remove)

	else if(href_list["lathe_ejectsheet"]) //Causes the protolathe to eject a sheet of material
		. = TOPIC_REFRESH
		CHECK_LATHE
		linked_lathe.eject(href_list["lathe_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["imprinter_ejectsheet"]) //Causes the protolathe to eject a sheet of material
		. = TOPIC_REFRESH
		CHECK_IMPRINTER
		linked_imprinter.eject(href_list["imprinter_ejectsheet"], text2num(href_list["amount"]))

	else if(href_list["find_device"]) //The R&D console looks for devices nearby to link up with.
		screen = 0.0
		. = TOPIC_HANDLED
		spawn(10)
			SyncRDevices()
			screen = 1.7
			interact(user)

	else if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		. = TOPIC_REFRESH
		switch(href_list["disconnect"])
			if("destroy")
				CHECK_DESTROY
				linked_destroy.linked_console = null
				linked_destroy = null
			if("lathe")
				CHECK_LATHE
				linked_lathe.linked_console = null
				linked_lathe = null
			if("imprinter")
				CHECK_IMPRINTER
				linked_imprinter.linked_console = null
				linked_imprinter = null

	else if(href_list["reset"]) //Reset the R&D console's database.
		var/choice = alert("R&D Console Database Reset", "Are you sure you want to reset the R&D console's database? Data lost cannot be recovered.", "Continue", "Cancel")
		. = TOPIC_HANDLED
		if(choice == "Continue")
			screen = 0.0
			qdel(files)
			files = new /datum/research(src)
			spawn(20)
				screen = 1.6
				interact(user)

	else if (href_list["print"]) //Print research information
		screen = 0.5
		. = TOPIC_HANDLED
		spawn(20)
			var/obj/item/paper/PR = new/obj/item/paper
			PR.name = "fabricator report"
			PR.info = "<center><b>[station_name()] Fabricator Laboratory</b>"
			PR.info += "<h2>[ (text2num(href_list["print"]) == 2) ? "Detailed" : null ] Fabricator Status Report</h2>"
			PR.info += "<i>report prepared at [stationtime2text()] local time</i></center><br>"
			if(text2num(href_list["print"]) == 2)
				PR.info += GetResearchListInfo()
			else
				PR.info += GetResearchLevelsInfo()
			PR.info_links = PR.info
			PR.icon_state = "paper_words"
			PR.dropInto(loc)
			spawn(10)
				screen = ((text2num(href_list["print"]) == 2) ? 5.0 : 1.1)
				interact(user)

/obj/machinery/computer/rdconsole/proc/finish_deconstruct(weakref/W)
	CHECK_DESTROY
	var/mob/user = W.resolve()
	linked_destroy.busy = 0
	if(!linked_destroy.loaded_item)
		to_chat(user, "<span class='notice'>The destructive analyzer appears to be empty.</span>")
		screen = 1.0
		return
	for(var/T in linked_destroy.loaded_item.origin_tech)
		files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
	if(linked_lathe && linked_destroy.loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
		for(var/t in linked_destroy.loaded_item.matter)
			if(t in linked_lathe.materials)
				linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)

	linked_destroy.loaded_item = null
	for(var/obj/I in linked_destroy.contents)
		for(var/mob/M in I.contents)
			M.death()
			qdel(M)
		if(istype(I,/obj/item/stack/material))//Only deconsturcts one sheet at a time instead of the entire stack
			var/obj/item/stack/material/S = I
			if(S.use(1) && S.amount)
				linked_destroy.loaded_item = S
			else
				qdel(S)
				linked_destroy.icon_state = "d_analyzer"
		else
			if(!(I in linked_destroy.component_parts))
				qdel(I)
				linked_destroy.icon_state = "d_analyzer"

	use_power_oneoff(linked_destroy.active_power_usage)
	screen = 1.0
	if(CanInteract(user, DefaultTopicState()))
		interact(user)

/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/dat
	dat += "<UL>"
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "[T.name]"
		dat += "<UL>"
		dat +=  "<LI>Level: [T.level]"
		dat +=  "<LI>Summary: [T.desc]"
		dat += "</UL>"
	return dat

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/dat
	dat += "<UL>"
	for(var/datum/design/D in files.known_designs)
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat

/obj/machinery/computer/rdconsole/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/rdconsole/interact(mob/user)
	user.set_machine(src)
	var/dat = list()
	files.RefreshResearch()
	switch(screen) //A quick check to make sure you get the right screen when a device is disconnected.
		if(2 to 2.9)
			if(linked_destroy == null)
				screen = 2.0
			else if(linked_destroy.loaded_item == null)
				screen = 2.1
			else
				screen = 2.2
		if(3 to 3.9)
			if(linked_lathe == null)
				screen = 3.0
		if(4 to 4.9)
			if(linked_imprinter == null)
				screen = 4.0

	switch(screen)

		//////////////////////R&D CONSOLE SCREENS//////////////////
		if(0.0)
			dat += "Updating Database..."

		if(0.1)
			dat += "Processing and Updating Database..."

		if(0.2)
			dat += "SYSTEM LOCKED<BR><BR>"
			dat += "<A href='?src=\ref[src];lock=1.6'>Unlock</A>"

		if(0.3)
			dat += "Constructing Prototype. Please Wait..."

		if(0.4)
			dat += "Imprinting Circuit. Please Wait..."

		if(0.5)
			dat += "Printing. Please Wait..."

		if(1.0) //Main Menu
			dat += "Main Menu:<BR><BR>"
			dat += "Loaded disk: "
			dat += (t_disk || d_disk) ? (t_disk ? "technology storage disk" : "design storage disk") : "none"
			dat += "<HR><UL>"
			dat += "<LI><A href='?src=\ref[src];menu=1.1'>Current Fabricator Learning Matrix Status</A>"
			dat += "<LI><A href='?src=\ref[src];menu=5.0'>View Available Designs</A>"
			if(t_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.2'>Disk Operations</A>"
			else if(d_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.4'>Disk Operations</A>"
			else
				dat += "<LI>Disk Operations"
			if(linked_destroy)
				dat += "<LI><A href='?src=\ref[src];menu=2.2'>Destructive Analyzer Menu</A>"
			if(linked_lathe)
				dat += "<LI><A href='?src=\ref[src];menu=3.1'>Protolathe Construction Menu</A>"
			if(linked_imprinter)
				dat += "<LI><A href='?src=\ref[src];menu=4.1'>Circuit Construction Menu</A>"
			dat += "<LI><A href='?src=\ref[src];menu=1.6'>Settings</A>"
			dat += "</UL>"

		if(1.1) //Research viewer
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];print=1'>Print This Page</A><HR>"
			dat += "Fabricator Learning Matrix Proficiency Levels:<BR><BR>"
			dat += GetResearchLevelsInfo()
			dat += "</UL>"

		if(1.2) //Technology Disk Menu
			if(!t_disk)
				screen = 1
				return
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "Disk Contents: (Technology Data Disk)<BR><BR>"
			if(t_disk.stored == null)
				dat += "The disk has no data stored on it.<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];menu=1.3'>Load Tech to Disk</A> || "
			else
				dat += "Name: [t_disk.stored.name]<BR>"
				dat += "Level: [t_disk.stored.level]<BR>"
				dat += "Description: [t_disk.stored.desc]<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];updt_tech=1'>Upload to Database</A> || "
				dat += "<A href='?src=\ref[src];clear_tech=1'>Clear Disk</A> || "
			dat += "<A href='?src=\ref[src];eject_tech=1'>Eject Disk</A>"

		if(1.3) //Technology Disk submenu
			if(!t_disk)
				screen = 1
				return
			dat += "<BR><A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.2'>Return to Disk Operations</A><HR>"
			dat += "Load Technology to Disk:<BR><BR>"
			dat += "<UL>"
			for(var/datum/tech/T in files.known_tech)
				dat += "<LI>[T.name] "
				dat += "\[<A href='?src=\ref[src];copy_tech=1;copy_tech_ID=[T.id]'>copy to disk</A>\]"
			dat += "</UL>"

		if(1.4) //Design Disk menu.
			if(!d_disk)
				screen = 1
				return
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			if(d_disk.blueprint == null)
				dat += "The disk has no data stored on it.<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];menu=1.5'>Load Design to Disk</A> || "
			else
				dat += "Name: [d_disk.blueprint.name]<BR>"
				switch(d_disk.blueprint.build_type)
					if(IMPRINTER) dat += "Lathe Type: Circuit Imprinter<BR>"
					if(PROTOLATHE) dat += "Lathe Type: Proto-lathe<BR>"
				dat += "Required Materials:<BR>"
				for(var/M in d_disk.blueprint.materials)
					if(copytext(M, 1, 2) == "$") dat += "* [copytext(M, 2)] x [d_disk.blueprint.materials[M]]<BR>"
					else dat += "* [M] x [d_disk.blueprint.materials[M]]<BR>"
				dat += "<HR>Operations: "
				dat += "<A href='?src=\ref[src];updt_design=1'>Upload to Database</A> || "
				dat += "<A href='?src=\ref[src];clear_design=1'>Clear Disk</A> || "
			dat += "<A href='?src=\ref[src];eject_design=1'>Eject Disk</A>"

		if(1.5) //Design disk submenu
			if(!d_disk)
				screen = 1
				return
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.4'>Return to Disk Operations</A><HR>"
			dat += "Load Design to Disk:<BR><BR>"
			dat += "<UL>"
			for(var/datum/design/D in files.known_designs)
				if(D.build_path)
					dat += "<LI>[D.name] "
					dat += "<A href='?src=\ref[src];copy_design=1;copy_design_ID=[D.id]'>\[copy to disk\]</A>"
			dat += "</UL>"

		if(1.6) //R&D console settings
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "R&D Console Setting:<HR>"
			dat += "<UL>"
			if(sync)
				dat += "<LI><A href='?src=\ref[src];sync=1'>Sync Database with Network</A><BR>"
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Disconnect from Fabrication Network</A><BR>"
			else
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Connect to Fabrication Network</A><BR>"
			dat += "<LI><A href='?src=\ref[src];menu=1.7'>Device Linkage Menu</A><BR>"
			dat += "<LI><A href='?src=\ref[src];lock=0.2'>Lock Console</A><BR>"
			dat += "<LI><A href='?src=\ref[src];reset=1'>Reset R&D Database</A><BR>"
			dat += "<UL>"

		if(1.7) //R&D device linkage
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.6'>Settings Menu</A><HR>"
			dat += "R&D Console Device Linkage Menu:<BR><BR>"
			dat += "<A href='?src=\ref[src];find_device=1'>Re-sync with Nearby Devices</A><HR>"
			dat += "Linked Devices:"
			dat += "<UL>"
			if(linked_destroy)
				dat += "<LI>Destructive Analyzer <A href='?src=\ref[src];disconnect=destroy'>(Disconnect)</A>"
			else
				if (can_analyze == TRUE) 
					dat += "<LI>(No Destructive Analyzer Linked)"
			if(linked_lathe)
				dat += "<LI>Protolathe <A href='?src=\ref[src];disconnect=lathe'>(Disconnect)</A>"
			else
				dat += "<LI>(No Protolathe Linked)"
			if(linked_imprinter)
				dat += "<LI>Circuit Imprinter <A href='?src=\ref[src];disconnect=imprinter'>(Disconnect)</A>"
			else
				dat += "<LI>(No Circuit Imprinter Linked)"
			dat += "</UL>"

		////////////////////DESTRUCTIVE ANALYZER SCREENS////////////////////////////
		if(2.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO DESTRUCTIVE ANALYZER LINKED TO CONSOLE<BR><BR>"

		if(2.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "No Item Loaded. Standing-by...<BR><HR>"

		if(2.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "Deconstruction Menu<HR>"
			dat += "Name: [linked_destroy.loaded_item.name]<BR>"

			dat += "Origin Tech:"
			dat += "<UL>"
			for(var/T in linked_destroy.loaded_item.origin_tech)
				dat += "<LI>[CallTechName(T)] [linked_destroy.loaded_item.origin_tech[T]]"
				for(var/datum/tech/F in files.known_tech)
					if(F.name == CallTechName(T))
						dat += " (Current: [F.level])"
						break
			dat += "</UL>"
			dat += "<HR><A href='?src=\ref[src];deconstruct=1'>Deconstruct Item</A> || "
			dat += "<A href='?src=\ref[src];eject_item=1'>Eject Item</A> || "

		/////////////////////PROTOLATHE SCREENS/////////////////////////
		if(3.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO PROTOLATHE LINKED TO CONSOLE<BR><BR>"

		if(3.1)
			CHECK_LATHE
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.4'>View Queue</A> || "
			dat += "<A href='?src=\ref[src];menu=3.2'>Material Storage</A> || "
			dat += "<A href='?src=\ref[src];menu=3.3'>Chemical Storage</A><HR>"
			dat += "Protolathe Menu:<BR><BR>"
			dat += "<B>Material Amount:</B> [linked_lathe.TotalMaterials()] cm<sup>3</sup> (MAX: [linked_lathe.max_material_storage])<BR>"
			dat += "<B>Chemical Volume:</B> [linked_lathe.reagents.total_volume] (MAX: [linked_lathe.reagents.maximum_volume])<HR>"
			dat += "<UL>"
			for(var/datum/design/D in files.known_designs)
				if(!D.build_path || !(D.build_type & PROTOLATHE))
					continue
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*(linked_imprinter ? linked_imprinter.mat_efficiency : 1)] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext(temp_dat, 3)]\]"
				if(linked_lathe.canBuild(D))
					dat += "<LI><B><A href='?src=\ref[src];build=[D.id]'>[D.name]</A></B>[temp_dat]"
				else
					dat += "<LI><B>[D.name]</B>[temp_dat]"
			dat += "</UL>"

		if(3.2) //Protolathe Material Storage Sub-menu
			CHECK_LATHE
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "Material Storage<BR><HR>"
			dat += "<UL>"
			for(var/M in linked_lathe.materials)
				var/amount = linked_lathe.materials[M]
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Eject "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];lathe_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];lathe_ejectsheet=[M];amount=50'>max</A> sheets"
				dat += ""
			dat += "</UL>"

		if(3.3) //Protolathe Chemical Storage Submenu
			CHECK_LATHE
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "Chemical Storage<BR><HR>"
			for(var/datum/reagent/R in linked_lathe.reagents.reagent_list)
				dat += "Name: [R.name] | Units: [R.volume] "
				dat += "<A href='?src=\ref[src];disposeP=\ref[R]'>(Purge)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallP=1'><U>Disposal All Chemicals in Storage</U></A><BR>"

		if(3.4) // Protolathe queue
			CHECK_LATHE
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "Queue<BR><HR>"
			if(!linked_lathe.queue.len)
				dat += "Empty"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_lathe.queue)
					if(tmp == 1)
						if(linked_lathe.busy)
							dat += "<B>1: [D.name]</B><BR>"
						else
							dat += "<B>1: [D.name]</B> (Awaiting materials) <A href='?src=\ref[src];removeP=[tmp]'>(Remove)</A><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeP=[tmp]'>(Remove)</A><BR>"
					++tmp

		///////////////////CIRCUIT IMPRINTER SCREENS////////////////////
		if(4.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO CIRCUIT IMPRINTER LINKED TO CONSOLE<BR><BR>"

		if(4.1)
			CHECK_IMPRINTER
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.4'>View Queue</A> || "
			dat += "<A href='?src=\ref[src];menu=4.3'>Material Storage</A> || "
			dat += "<A href='?src=\ref[src];menu=4.2'>Chemical Storage</A><HR>"
			dat += "Circuit Imprinter Menu:<BR><BR>"
			dat += "Material Amount: [linked_imprinter.TotalMaterials()] cm<sup>3</sup><BR>"
			dat += "Chemical Volume: [linked_imprinter.reagents.total_volume]<HR>"
			dat += "<UL>"
			for(var/datum/design/D in files.known_designs)
				if(!D.build_path || !(D.build_type & IMPRINTER))
					continue
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]*linked_imprinter.mat_efficiency] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*linked_imprinter.mat_efficiency] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext(temp_dat,3)]\]"
				if(linked_imprinter.canBuild(D))
					dat += "<LI><B><A href='?src=\ref[src];imprint=[D.id]'>[D.name]</A></B>[temp_dat]"
				else
					dat += "<LI><B>[D.name]</B>[temp_dat]"
			dat += "</UL>"

		if(4.2)
			CHECK_IMPRINTER
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Imprinter Menu</A><HR>"
			dat += "Chemical Storage<BR><HR>"
			for(var/datum/reagent/R in linked_imprinter.reagents.reagent_list)
				dat += "Name: [R.name] | Units: [R.volume] "
				dat += "<A href='?src=\ref[src];disposeI=\ref[R]'>(Purge)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallI=1'><U>Disposal All Chemicals in Storage</U></A><BR>"

		if(4.3)
			CHECK_IMPRINTER
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Circuit Imprinter Menu</A><HR>"
			dat += "Material Storage<BR><HR>"
			dat += "<UL>"
			for(var/M in linked_imprinter.materials)
				var/amount = linked_imprinter.materials[M]
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Eject: "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=50'>max</A> sheets"
				dat += ""
			dat += "</UL>"

		if(4.4)
			CHECK_IMPRINTER
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Circuit Imprinter Menu</A><HR>"
			dat += "Queue<BR><HR>"
			if(linked_imprinter.queue.len == 0)
				dat += "Empty"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_imprinter.queue)
					if(tmp == 1)
						dat += "<B>1: [D.name]</B><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeI=[tmp]'>(Remove)</A><BR>"
					++tmp

		///////////////////Research Information Browser////////////////////
		if(5.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];print=2'>Print This Page</A><HR>"
			dat += "List of Available Designs:"
			dat += GetResearchListInfo()

	var/datum/browser/popup = new(user, "rdconsolenew", "Core Fabricator Console", 850, 600)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/machinery/computer/rdconsole/robotics
	name = "robotics fabrication console"
	id = 2
	req_access = list(access_robotics)
	can_analyze = FALSE

/obj/machinery/computer/rdconsole/core
	name = "core fabricator console"
	id = 1
	

#undef CHECK_LATHE
#undef CHECK_IMPRINTER
#undef CHECK_DESTROY