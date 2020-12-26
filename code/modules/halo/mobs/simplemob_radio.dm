
/obj/item/device/radio/simplemob_radio
	name = "Radio uplink"

/obj/item/device/radio/simplemob_radio/emp_act()
	return

/mob/living/simple_animal
	var/obj/item/device/radio/simplemob_radio/sm_radio

/mob/living/simple_animal/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	..()
	if(sm_radio && message_mode)
		if(message_mode == "general")
			message_mode = null
		return sm_radio.talk_into(src,message,message_mode,verb,speaking)

/mob/living/simple_animal/Destroy()
	qdel(sm_radio)
	. = ..()

/mob/living/simple_animal/examine(var/examiner)
	. = ..()
	if(sm_radio && examiner == src)
		sm_radio.examine(examiner)