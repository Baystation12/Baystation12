/datum/wires/iff
	holder_type = /obj/machinery/iff_beacon
	wire_count = 1

#define IFF_WIRE_RESET		 1

/datum/wires/iff/GetInteractWindow()
	var/obj/machinery/iff_beacon/I = holder
	. += ..()
	. += text("<br>\n[(I.use_power ? "The beacon is transmitting." : "The beacon is not transmitting.")]")

/datum/wires/iff/CanUse(mob/living/L)
	var/obj/machinery/iff_beacon/I = holder
	return I.panel_open

/datum/wires/iff/UpdateCut(index, mended)
	var/obj/machinery/iff_beacon/I = holder

	switch(index)
		if(IFF_WIRE_RESET)
			if(!mended)
				I.shock(usr, 50)
				I.toggle()
				I.disable()
			else
				I.shock(usr, 50)
				I.enable()
				I.toggle()
