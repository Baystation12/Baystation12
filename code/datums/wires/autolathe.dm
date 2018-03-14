/datum/wires/autolathe

	holder_type = /obj/machinery/autolathe
	wire_count = 6

var/const/AUTOLATHE_HACK_WIRE = 1
var/const/AUTOLATHE_SHOCK_WIRE = 2
var/const/AUTOLATHE_DISABLE_WIRE = 4

/datum/wires/autolathe/GetInteractWindow()
	var/obj/machinery/autolathe/A = holder
	. += ..()
	. += "<BR>The red light is [A.disabled ? "off" : "on"]."
	. += "<BR>The green light is [A.shocked ? "off" : "on"]."
	. += "<BR>The blue light is [A.hacked ? "off" : "on"].<BR>"

/datum/wires/autolathe/CanUse()
	var/obj/machinery/autolathe/A = holder
	if(A.panel_open)
		return 1
	return 0

/datum/wires/autolathe/Interact(var/mob/living/user)
	if(CanUse(user))
		var/obj/machinery/autolathe/V = holder
		V.attack_hand(user)

/datum/wires/autolathe/UpdateCut(index, mended)
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !mended
		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !mended
		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !mended

/datum/wires/autolathe/UpdatePulsed(index)
	if(IsIndexCut(index))
		return
	var/obj/machinery/autolathe/A = holder
	switch(index)
		if(AUTOLATHE_HACK_WIRE)
			A.hacked = !A.hacked
			addtimer(CALLBACK(src, .proc/handle_hack, index, usr), 5 SECONDS, TIMER_UNIQUE)

		if(AUTOLATHE_SHOCK_WIRE)
			A.shocked = !A.shocked
			addtimer(CALLBACK(src, .proc/handle_shock, index, usr), 5 SECONDS, TIMER_UNIQUE)

		if(AUTOLATHE_DISABLE_WIRE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(src, .proc/handle_disable, index, usr), 5 SECONDS, TIMER_UNIQUE)


/datum/wires/autolathe/proc/handle_hack(var/index, mob/user)
	var/obj/machinery/autolathe/A = holder
	if(A && !IsIndexCut(index))
		A.hacked = 0
		Interact(user)

/datum/wires/autolathe/proc/handle_shock(var/index, mob/user)
	var/obj/machinery/autolathe/A = holder
	if(A && !IsIndexCut(index))
		A.shocked = 0
		Interact(user)

/datum/wires/autolathe/proc/handle_disable(var/index, mob/user)
	var/obj/machinery/autolathe/A = holder
	if(A && !IsIndexCut(index))
		A.disabled = 0
		Interact(user)