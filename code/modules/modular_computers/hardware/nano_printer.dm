datum/computer_hardware/nano_printer
	name = "Nano Printer"
	desc = "Small integrated printer with scanner and paper recycling module."
	power_usage = 50
	var/stored_paper = 0
	var/max_paper = 10
	var/obj/item/weapon/paper/P = null	// Currently stored paper for scanning.

datum/computer_hardware/nano_printer/proc/load_paper(var/obj/item/weapon/paper/paper)
	if(!paper || !istype(paper))
		return

	// We already have paper loaded, recycle it.
	if(P && try_recycle_paper())
		P = paper
		P.loc = holder ? holder : holder2

/datum/computer_hardware/nano_printer/proc/try_recycle_paper()
	if(!P)
		return 0

	if(stored_paper >= max_paper)
		return 0

		qdel(P)
		P = null

/datum/computer_hardware/nano_printer/Destroy()
	if(holder && (holder.nano_printer == src))
		holder.nano_printer = null
	if(holder2 && (holder2.nano_printer == src))
		holder2.nano_printer = null
	if(P)
		qdel(P)
		P = null
	..()