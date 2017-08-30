//DNA machine
/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnaopen"
	anchored = 1
	density = 1

	var/obj/item/weapon/forensics/swab/bloodsamp = null
	var/closed = 0
	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 2.50
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/attackby(var/obj/item/W, mob/user as mob)

	if(bloodsamp)
		to_chat(user, "<span class='warning'>There is already a sample in the machine.</span>")
		return

	if(closed)
		to_chat(user, "<span class='warning'>Open the cover before inserting the sample.</span>")
		return

	var/obj/item/weapon/forensics/swab/swab = W
	if(istype(swab) && swab.is_used())
		user.unEquip(W)
		src.bloodsamp = swab
		swab.loc = src
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] only accepts used swabs.</span>")
		return

/obj/machinery/dnaforensics/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	if(stat & (NOPOWER)) return
	if(user.stat || user.restrained()) return
	var/list/data = list()
	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	data["bloodsamp"] = (bloodsamp ? bloodsamp.name : "")
	data["bloodsamp_desc"] = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : "")
	data["lidstate"] = closed

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "dnaforensics.tmpl", "QuikScan DNA Analyzer", 540, 326)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/dnaforensics/Topic(href, href_list)

	if(..()) return 1

	if(stat & (NOPOWER))
		return 0 // don't update UIs attached to this object

	if(href_list["scanItem"])
		if(scanning)
			scanning = 0
		else
			if(bloodsamp)
				if(closed == 1)
					scanner_progress = 0
					scanning = 1
					to_chat(usr, "<span class='notice'>Scan initiated.</span>")
					update_icon()
				else
					to_chat(usr, "<span class='notice'>Please close sample lid before initiating scan.</span>")
			else
				to_chat(usr, "<span class='warning'>Insert an item to scan.</span>")

	if(href_list["ejectItem"])
		if(bloodsamp)
			bloodsamp.forceMove(src.loc)
			bloodsamp = null

	if(href_list["toggleLid"])
		toggle_lid()

	return 1

/obj/machinery/dnaforensics/process()
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
	src.visible_message("<span class='notice'>[icon2html(src, world)] makes an insistent chime.</span>", 2)
	update_icon()
	if(bloodsamp)
		var/obj/item/weapon/paper/P = new(src)
		P.name = "[src] report #[++report_num]: [bloodsamp.name]"
		P.stamped = list(/obj/item/weapon/stamp)
		P.overlays = list("paper_stamped")
		//dna data itself
		var/data = "No scan information available."
		if(bloodsamp.dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of [bloodsamp.dna.len] strings of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				data += "<span class='notice'>Blood type: [bloodsamp.dna[blood]]<br>\nDNA: [blood]</span><br><br>"
		else
			data += "No DNA found.<br>"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b><br>[bloodsamp.name]<br>[bloodsamp.desc]<br><br>" + data
		P.forceMove(src.loc)
		P.update_icon()
		scanning = 0
		update_icon()
	return

/obj/machinery/dnaforensics/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/dnaforensics/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/dnaforensics/verb/toggle_lid()
	set category = "Object"
	set name = "Toggle Lid"
	set src in oview(1)

	if(usr.stat || !isliving(usr))
		return

	if(scanning)
		to_chat(usr, "<span class='warning'>You can't do that while [src] is scanning!</span>")
		return

	closed = !closed
	src.update_icon()

/obj/machinery/dnaforensics/update_icon()
	..()
	if(!(stat & NOPOWER) && scanning)
		icon_state = "dnaworking"
	else if(closed)
		icon_state = "dnaclosed"
	else
		icon_state = "dnaopen"
