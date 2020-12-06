/obj/item/device/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 50, MATERIAL_WASTE = 10)
	var/listening = 0
	var/recorded	//the activation message

/obj/item/device/assembly/voice/New()
	..()
	GLOB.listening_objects += src

/obj/item/device/assembly/voice/Destroy()
	GLOB.listening_objects -= src
	return ..()

/obj/item/device/assembly/voice/hear_talk(mob/living/M as mob, msg)
	if(listening)
		recorded = msg
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("[icon2html(src, viewers(get_turf(src)))] beeps, \"Activation message is '[recorded]'.\"")
	else
		if(findtext(msg, recorded))
			pulse(0)

/obj/item/device/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("[icon2html(src, viewers(get_turf(src)))] beeps, \"[listening ? "Now" : "No longer"] recording input.\"")


/obj/item/device/assembly/voice/attack_self(mob/user)
	if(!user)	return 0
	activate()
	return 1


/obj/item/device/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
