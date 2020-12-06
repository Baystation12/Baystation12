/obj/machinery/Value()
	. = ..()
	if(stat & BROKEN)
		. *= 0.5
	. = round(.)