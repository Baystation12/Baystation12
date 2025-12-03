/// Generic periodic SSobj processing implant
/obj/item/implant/processing
	abstract_type = /obj/item/implant/processing

/obj/item/implant/processing/Process()
	..()
	if (!implanted)
		return PROCESS_KILL

/obj/item/implant/processing/disable()
	. = ..()
	if (.)
		STOP_PROCESSING(SSobj, src)

/obj/item/implant/processing/restore()
	. = ..()
	if (.)
		START_PROCESSING(SSobj, src)

/obj/item/implant/processing/meltdown()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/implant/processing/implanted(mob/source)
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/implant/processing/removed()
	..()
	STOP_PROCESSING(SSobj, src)
