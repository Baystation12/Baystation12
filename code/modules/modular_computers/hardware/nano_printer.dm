/obj/item/weapon/stock_parts/computer/nano_printer
	name = "nano printer"
	desc = "Small integrated printer with paper recycling module."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	critical = 0
	icon_state = "printer"
	hardware_size = 1
	var/stored_paper = 50
	var/max_paper = 50
	var/last_print

/obj/item/weapon/stock_parts/computer/nano_printer/diagnostics()
	. = ..()
	. += "Paper buffer level: [stored_paper]/[max_paper]"

/obj/item/weapon/stock_parts/computer/nano_printer/proc/print_text(var/text_to_print, var/paper_title = null, var/paper_type = /obj/item/weapon/paper, var/list/md = null)
	if(printer_ready())
		last_print = world.time
		// Damaged printer causes the resulting paper to be somewhat harder to read.
		if(damage > damage_malfunction)
			text_to_print = stars(text_to_print, 100-malfunction_probability)
		var/turf/T = get_turf(src)
		new paper_type(T,text_to_print, paper_title, md)
		stored_paper--
		playsound(T, "sound/machines/dotprinter.ogg", 30)
		T.visible_message("<span class='notice'>\The [src] prints out a paper.</span>")
		return 1

/obj/item/weapon/stock_parts/computer/nano_printer/proc/printer_ready()
	if(!stored_paper)
		return 0
	if(!enabled)
		return 0
	if(!check_functionality())
		return 0
	if(world.time < last_print + 1 SECOND)
		return 0
	return 1

/obj/item/weapon/stock_parts/computer/nano_printer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/paper))
		if(stored_paper >= max_paper)
			to_chat(user, "You try to add \the [W] into \the [src], but its paper bin is full.")
			return

		to_chat(user, "You insert \the [W] into [src].")
		qdel(W)
		stored_paper++
	else if(istype(W, /obj/item/weapon/paper_bundle))
		var/obj/item/weapon/paper_bundle/B = W
		var/num_of_pages_added = 0
		if(stored_paper >= max_paper)
			to_chat(user, "You try to add \the [W] into \the [src], but its paper bin is full.")
			return
		for(var/obj/item/weapon/bundleitem in B) //loop through items in bundle
			if(istype(bundleitem, /obj/item/weapon/paper)) //if item is paper (and not photo), add into the bin
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
