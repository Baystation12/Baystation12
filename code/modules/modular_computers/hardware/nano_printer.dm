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
		if(is_malfunctioning())
			text_to_print = stars(text_to_print, 100-malfunction_probability)
		var/turf/T = get_turf(src)
		new paper_type(T, text_to_print, paper_title, md, print_language)
		stored_paper--
		playsound(T, "sound/machines/dotprinter.ogg", 30)
		T.visible_message(SPAN_NOTICE("\The [src] prints out a paper."))
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


/obj/item/stock_parts/computer/nano_printer/get_interactions_info()
	. = ..()
	.["Paper"] = "<p>Adds the paper to the printer's stored papers. This deletes anything that was written on the paper. The printer can hold up to [initial(max_paper)] sheet\s of paper.</p>"
	.["Paper Bundle"] = "<p>Adds papers from the bundle to the printer's stored papers.</p>"


/obj/item/stock_parts/computer/nano_printer/use_tool(obj/item/tool, mob/user, list/click_params)
	// Paper - Load paper
	if (istype(tool, /obj/item/paper))
		if (stored_paper >= max_paper)
			to_chat(user, SPAN_WARNING("\The [src]'s paper bin is full."))
			return TRUE
		if (!user.unEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		stored_paper++
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \a [tool] into \the [src]."),
			SPAN_NOTICE("You load \the [tool] into \the [src].")
		)
		qdel(tool)
		return TRUE

	// Paper Bundle - Load paper
	if (istype(tool, /obj/item/paper_bundle))
		if (stored_paper >= max_paper)
			to_chat(user, SPAN_WARNING("\The [src]'s paper bin is full."))
			return TRUE
		if (!user.unEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		var/obj/item/paper_bundle/bundle = tool
		var/pages_added = 0
		for (var/obj/item/paper/paper in bundle)
			bundle.pages -= paper
			qdel(paper)
			pages_added++
			stored_paper++
			if (stored_paper >= max_paper)
				break
		if (length(bundle.pages) == 0)
			qdel(bundle)
		else if (length(bundle.pages) == 1)
			user.drop_from_inventory(bundle)
			user.put_in_hands(bundle[1])
			bundle.pages.Cut()
			qdel(bundle)
		else
			bundle.update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] adds some sheets of paper from \the [tool] to \the [src]."),
			SPAN_NOTICE("You add [pages_added] sheet\s of paper from \the [tool] to \the [src].")
		)
		return TRUE

	return ..()
