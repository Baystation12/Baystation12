/obj/item/stock_parts/computer/nano_printer
	name = "nano printer"
	desc = "Small integrated printer with paper recycling module."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	critical = FALSE
	icon_state = "printer"
	hardware_size = 1
	var/stored_paper = 50
	var/max_paper = 50
	var/last_print
	var/print_language = LANGUAGE_HUMAN_EURO

/obj/item/stock_parts/computer/nano_printer/diagnostics()
	. = ..()
	. += "Paper buffer level: [stored_paper]/[max_paper]"
	. += "Printer language: [print_language]"

/obj/item/stock_parts/computer/nano_printer/proc/print_text(text_to_print, paper_title = null, paper_type = /obj/item/paper, list/md = null)
	. = FALSE
	if(printer_ready())
		last_print = world.time
		// Damaged printer causes the resulting paper to be somewhat harder to read.
		if(damage > damage_malfunction)
			text_to_print = stars(text_to_print, 100-malfunction_probability)
		var/turf/T = get_turf(src)
		new paper_type(T, text_to_print, paper_title, md, print_language)
		stored_paper--
		playsound(T, "sound/machines/dotprinter.ogg", 30)
		T.visible_message("<span class='notice'>\The [src] prints out a paper.</span>")
		return TRUE

/obj/item/stock_parts/computer/nano_printer/proc/printer_ready()
	if(!stored_paper)
		return FALSE
	if(!enabled)
		return FALSE
	if(!check_functionality())
		return FALSE
	if(world.time < last_print + 1 SECOND)
		return FALSE
	return TRUE

/obj/item/stock_parts/computer/nano_printer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper))
		if(stored_paper >= max_paper)
			to_chat(user, "You try to add \the [W] into \the [src], but its paper bin is full.")
			return

		to_chat(user, "You insert \the [W] into [src].")
		qdel(W)
		stored_paper++
	else if(istype(W, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = W
		var/num_of_pages_added = 0
		if(stored_paper >= max_paper)
			to_chat(user, "You try to add \the [W] into \the [src], but its paper bin is full.")
			return
		for(var/obj/item/bundleitem in B) //loop through items in bundle
			if(istype(bundleitem, /obj/item/paper)) //if item is paper (and not photo), add into the bin
				B.pages.Remove(bundleitem)
				qdel(bundleitem)
				num_of_pages_added++
				stored_paper++
			if(stored_paper >= max_paper) //check if the printer is full yet
				to_chat(user, "The printer has been filled to full capacity.")
				break
		if(B.pages.len == 0) //if all its papers have been put into the printer, delete bundle
			qdel(W)
		else if(B.pages.len == 1) //if only one item left, extract item and delete the one-item bundle
			user.drop_from_inventory(B)
			user.put_in_hands(B[1])
			qdel(B)
		else //if at least two items remain, just update the bundle icon
			B.update_icon()
		to_chat(user, "You add [num_of_pages_added] papers from \the [W] into \the [src].")
	return
