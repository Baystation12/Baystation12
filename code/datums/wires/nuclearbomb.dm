/datum/wires/nuclearbomb
	holder_type = /obj/machinery/nuclearbomb
	random = 1
	wire_count = 7
	descriptions = list(
		new /datum/wire_description(NUCLEARBOMB_WIRE_LIGHT, "This wire seems to connect to the small light on the device.", SKILL_EXPERT),
		new /datum/wire_description(NUCLEARBOMB_WIRE_TIMING, "This wire connects to the time display."),
		new /datum/wire_description(NUCLEARBOMB_WIRE_SAFETY, "This wire connects to a safety override.")
	)

var/global/const/NUCLEARBOMB_WIRE_LIGHT		= 1
var/global/const/NUCLEARBOMB_WIRE_TIMING		= 2
var/global/const/NUCLEARBOMB_WIRE_SAFETY		= 4

/datum/wires/nuclearbomb/CanUse(var/mob/living/L)
	var/obj/machinery/nuclearbomb/N = holder
	return N.panel_open && N.extended

/datum/wires/nuclearbomb/GetInteractWindow(mob/user)
	var/obj/machinery/nuclearbomb/N = holder
	. += ..()
	. += "<BR>The device is [N.timing ? "shaking!" : "still."]<BR>"
	. += "The device is is [N.safety ? "quiet" : "whirring"].<BR>"
	. += "The lights are [N.lighthack ? "static" : "functional"].<BR>"

/datum/wires/nuclearbomb/UpdatePulsed(var/index)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !N.lighthack
			N.update_icon()
			spawn(100)
				N.lighthack = !N.lighthack
				N.update_icon()
		if(NUCLEARBOMB_WIRE_TIMING)
			if(N.timing)
				spawn
					log_and_message_admins("pulsed a nuclear bomb's detonation wire, causing it to explode.")
					N.explode()
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety = !N.safety
			spawn(100)
				N.safety = !N.safety
				if(N.safety == 1)
					N.visible_message("<span class='notice'>\The [N] quiets down.</span>")
					N.secure_device()
				else
					N.visible_message("<span class='notice'>\The [N] emits a quiet whirling noise!</span>")

/datum/wires/nuclearbomb/UpdateCut(var/index, var/mended)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety = mended
			if(N.timing)
				spawn
					log_and_message_admins("cut a nuclear bomb's timing wire, causing it to explode.")
					N.explode()
		if(NUCLEARBOMB_WIRE_TIMING)
			N.secure_device()
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !mended
			N.update_icon()