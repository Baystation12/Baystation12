/obj/item/device/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 10)
	var/recorded = "NULL"	//the activation message
	var/on = 0
	var/send_type = "Pulse"

<<<<<<< HEAD
	wires = WIRE_MISC_SPECIAL | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_ASSEMBLY_PROCESS
	wire_num = 7
=======
/obj/item/device/assembly/voice/New()
	..()
	listening_objects += src

/obj/item/device/assembly/voice/Destroy()
	listening_objects -= src
	return ..()

/obj/item/device/assembly/voice/hear_talk(mob/living/M as mob, msg)
	if(listening)
		recorded = msg
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("\icon[src] beeps, \"Activation message is '[recorded]'.\"")
	else
		if(findtext(msg, recorded))
			pulse(0)

/obj/item/device/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("\icon[src] beeps, \"[listening ? "Now" : "No longer"] recording input.\"")
>>>>>>> ac332ef302030356ad51c2640b86541a24f9a16f

/obj/item/device/assembly/voice/holder_hear_talk(mob/living/M as mob, msg)
	if(!active_wires & WIRE_ASSEMBLY_PROCESS || !on) return
	else if(findtext(lowertext(msg), lowertext(recorded)))
		misc_special(M)

/obj/item/device/assembly/voice/misc_special(var/mob/M)
	if(active_wires & WIRE_MISC_SPECIAL)
		if(send_type == "Pulse")
			send_pulse_to_connected()
		else
			for(var/obj/item/device/assembly/A in get_connected_devices())
				A.misc_special(M)
/obj/item/device/assembly/voice/activate()
	on = !on
	return 1

/obj/item/device/assembly/voice/get_data()
	return list("Activation Phrase", recorded, "Sending", send_type, "On", on)

/obj/item/device/assembly/voice/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Activation Phrase")
				usr << "<span class='notice'>Enter an activation phrase for \the [src]</span>"
				var/inp = input(usr, "What would you like to set the activation phrase too?", "Activation")
				if(inp && istext(inp))
					recorded = inp
			if("Sending")
				if(send_type == "Target Communication") send_type = "Pulse"
				else send_type = "Target Communication"
			if("On")
				process_activation()

<<<<<<< HEAD
	..()
=======
/obj/item/device/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
>>>>>>> ac332ef302030356ad51c2640b86541a24f9a16f
