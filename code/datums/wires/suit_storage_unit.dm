/datum/wires/suit_storage_unit
	holder_type = /obj/machinery/suit_cycler
	wire_count = 3

var/const/SUIT_STORAGE_WIRE_ELECTRIFY	= 1
var/const/SUIT_STORAGE_WIRE_SAFETY		= 2
var/const/SUIT_STORAGE_WIRE_LOCKED		= 4

/datum/wires/suit_storage_unit/CanUse(var/mob/living/L)
	var/obj/machinery/suit_cycler/S = holder
	if(!istype(L, /mob/living/silicon))
		if(S.electrified)
			if(S.shock(L, 100))
				return 0
	if(S.panel_open)
		return 1
	return 0

/datum/wires/suit_storage_unit/GetInteractWindow()
	var/obj/machinery/suit_cycler/S = holder
	. += ..()
	. += "<BR>The orange light is [S.electrified ? "off" : "on"].<BR>"
	. += "The red light is [S.safeties ? "off" : "blinking"].<BR>"
	. += "The yellow light is [S.locked ? "on" : "off"].<BR>"

/datum/wires/suit_storage_unit/UpdatePulsed(var/index)
	var/obj/machinery/suit_cycler/S = holder
	switch(index)
		if(SUIT_STORAGE_WIRE_SAFETY)
			S.safeties = !S.safeties
		if(SUIT_STORAGE_WIRE_ELECTRIFY)
			S.electrified = 30
		if(SUIT_STORAGE_WIRE_LOCKED)
			S.locked = !S.locked

/datum/wires/suit_storage_unit/UpdateCut(var/index, var/mended)
	var/obj/machinery/suit_cycler/S = holder
	switch(index)
		if(SUIT_STORAGE_WIRE_SAFETY)
			S.safeties = mended
		if(SUIT_STORAGE_WIRE_LOCKED)
			S.locked = mended
		if(SUIT_STORAGE_WIRE_ELECTRIFY)
			if(mended)
				S.electrified = 0
			else
				S.electrified = -1
