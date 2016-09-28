/obj/item/device/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 10)
	var/recorded = "NULL"	//the activation message
	var/on = 0
	var/send_type = "Pulse"

	wires = WIRE_MISC_SPECIAL | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_ASSEMBLY_PROCESS
	wire_num = 7

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


	..()

