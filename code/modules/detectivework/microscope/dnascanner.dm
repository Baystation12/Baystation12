//DNA machine
/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/machines/forensics/dna_scanner.dmi'
	icon_state = "dna"
	anchored = TRUE
	density = TRUE

	var/obj/item/forensics/swab/bloodsamp = null
	var/closed = 0
	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 2.50
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(!istype(W, /obj/item/forensics/swab))
		return .. ()

	var/obj/item/forensics/swab/swab = W
	if(bloodsamp)
		to_chat(user, SPAN_WARNING("There is already a sample in the machine."))
		return TRUE

	if(closed)
		to_chat(user, SPAN_WARNING("Open the cover before inserting the sample."))
		return TRUE

	if(istype(swab) && swab.is_used())
		if(!user.unEquip(W, src))
			return TRUE
		bloodsamp = swab
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] only accepts used swabs."))
		return TRUE

/obj/machinery/dnaforensics/ui_interact(mob/user, ui_key = "main",datum/nanoui/ui = null)
	if(!is_powered()) return
	if(user.stat || user.restrained()) return
	var/list/data = list()
	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	data["bloodsamp"] = (bloodsamp ? bloodsamp.name : "")
	data["bloodsamp_desc"] = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : "")
	data["lidstate"] = closed

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "dnaforensics.tmpl", "QuikScan DNA Analyzer", 540, 326)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/dnaforensics/Topic(href, href_list)

	if(..()) return 1

	if(!is_powered())
		return 0 // don't update UIs attached to this object

	if(href_list["scanItem"])
		if(scanning)
			scanning = 0
		else
			if(bloodsamp)
				if(closed == 1)
					scanner_progress = 0
					scanning = 1
					to_chat(usr, SPAN_NOTICE("Scan initiated."))
					update_icon()
				else
					to_chat(usr, SPAN_NOTICE("Please close sample lid before initiating scan."))
			else
				to_chat(usr, SPAN_WARNING("Insert an item to scan."))

	if(href_list["ejectItem"])
		if(bloodsamp)
			bloodsamp.forceMove(src.loc)
			bloodsamp = null

	if(href_list["toggleLid"])
		toggle_lid()

	return 1

/obj/machinery/dnaforensics/Process()
	if(scanning)
		if(!bloodsamp || bloodsamp.loc != src)
			bloodsamp = null
			scanning = 0
		else if(scanner_progress >= 100)
			complete_scan()
			return
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1
			scanner_progress = min(100, scanner_progress + scanner_rate * deltaT)
	last_process_worldtime = world.time

/obj/machinery/dnaforensics/proc/complete_scan()
	src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] makes an insistent chime."), 2)
	update_icon()
	if(bloodsamp)
		var/obj/item/paper/P = new(src)
		P.SetName("[src] report #[++report_num]: [bloodsamp.name]")
		P.SetOverlays("paper_stamped")
		var/data = "No scan information available."
		if(bloodsamp.dna != null || bloodsamp.trace_dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				data += "[SPAN_NOTICE("Blood type: [bloodsamp.dna[blood]]<br>DNA: [blood]")]<br><br>"
			for(var/trace in bloodsamp.trace_dna)
				data += "[SPAN_NOTICE("Trace DNA: [trace]")]<br><br>"
		else
			data += "No DNA found.<br>"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b><br>[bloodsamp.name]<br>[bloodsamp.desc]<br><br>" + data
		P.forceMove(src.loc)
		P.update_icon()
		scanning = 0
		update_icon()
	return

/obj/machinery/dnaforensics/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/dnaforensics/verb/toggle_lid()
	set category = "Object"
	set name = "Toggle Lid"
	set src in oview(1)

	if(usr.stat || !isliving(usr))
		return

	if(scanning)
		to_chat(usr, SPAN_WARNING("You can't do that while [src] is scanning!"))
		return

	closed = !closed
	src.update_icon()

/obj/machinery/dnaforensics/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_screen"))
		AddOverlays("[icon_state]_screen")
	else if(is_powered() && scanning)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_screen_working"))
		AddOverlays("[icon_state]_screen_working")
	else if(closed)
		AddOverlays("[icon_state]_closed")
