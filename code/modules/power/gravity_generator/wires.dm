/datum/wires/gravity_generator
	random = 1
	holder_type = /obj/machinery/gravity_generator/main
	wire_count = 4

var/global/const/GRAVITY_GENERATOR_WIRE_BREAKER = 1
var/global/const/GRAVITY_GENERATOR_WIRE_EMERGENCY_BUTTON = 2
var/global/const/GRAVITY_GENERATOR_WIRE_POWER = 4
var/global/const/GRAVITY_GENERATOR_WIRE_ANNOUNCER = 8

/datum/wires/gravity_generator/CanUse(mob/living/L)
	var/obj/machinery/gravity_generator/main/GG = holder
	if(GG.panel_open)
		return TRUE
	return FALSE

/datum/wires/gravity_generator/GetInteractWindow()
	. = ..()
	var/obj/machinery/gravity_generator/main/GG = holder
	. += "<br>The breaker is [GG.breaker ? "on" : "off"]."
	. += "<br>The energy protection system is [GG.emergency_shutoff_button ? "disabled" : "enabled"]."
	. += "<br>The power supply indicator is [GG.power_supply && !(GG.stat & MACHINE_STAT_NOPOWER) ? "green" : "red"]."
	. += "<br>The alert system is [GG.announcer ? "on" : "off"]."

/datum/wires/gravity_generator/UpdateCut(index, mended)
	var/obj/machinery/gravity_generator/main/GG = holder

	switch(index)
		if(GRAVITY_GENERATOR_WIRE_BREAKER)
			GG.can_toggle_breaker = !GG.can_toggle_breaker

		if(GRAVITY_GENERATOR_WIRE_EMERGENCY_BUTTON)
			GG.emergency_shutoff_button = !GG.emergency_shutoff_button

		if(GRAVITY_GENERATOR_WIRE_POWER)
			GG.power_supply = !GG.power_supply
			GG.power_change()
			GG.shock(usr, 100)

/datum/wires/gravity_generator/UpdatePulsed(index)
	var/obj/machinery/gravity_generator/main/GG = holder
	if(IsIndexCut(index))
		return

	switch(index)
		if(GRAVITY_GENERATOR_WIRE_BREAKER)
			GG.set_state(GG.breaker ? FALSE : TRUE)

		if(GRAVITY_GENERATOR_WIRE_EMERGENCY_BUTTON)
			GG.shock(usr, 100)

		if(GRAVITY_GENERATOR_WIRE_POWER)
			GG.shock(usr, 100)

		if(GRAVITY_GENERATOR_WIRE_ANNOUNCER)
			GG.announcer = !GG.announcer
