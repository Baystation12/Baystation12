/obj/item/weapon/computer_hardware/nano_printer
	name = "nano printer"
	desc = "Small integrated printer with scanner and paper recycling module."
	power_usage = 50
	icon_state = "printer"
	hardware_size = 1
	var/stored_paper = 5
	var/max_paper = 10
	var/obj/item/weapon/paper/P = null	// Currently stored paper for scanning.


/obj/item/weapon/computer_hardware/nano_printer/proc/print_text(var/text_to_print)
	if(!stored_paper)
		return 0

	// Recycle stored paper
	if(P)
		stored_paper++
		qdel(P)
		P = null

	P = new/obj/item/weapon/paper(get_turf(holder2))
	P.info = text_to_print
	P.update_icon()
	stored_paper--
	P = null
	return 1

/obj/item/weapon/computer_hardware/nano_printer/proc/load_paper(var/obj/item/weapon/paper/paper)
	if(!paper || !istype(paper))
		return 0

	// We already have paper loaded, recycle it.
	if(P && try_recycle_paper())
		P = paper
		P.forceMove(holder2)

/obj/item/weapon/computer_hardware/nano_printer/proc/try_recycle_paper()
	if(!P)
		return 0

	if(stored_paper >= max_paper)
		return 0

	qdel(P)
	P = null
	return 1

/obj/item/weapon/computer_hardware/nano_printer/Destroy()
	if(holder2 && (holder2.nano_printer == src))
		holder2.nano_printer = null
	if(P)
		if(holder2)
			P.forceMove(get_turf(holder2))
		else
			qdel(P)
		P = null
	holder2 = null
	..()