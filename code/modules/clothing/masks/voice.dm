/obj/item/voice_changer
	name = "voice changer"
	desc = "A voice scrambling module. If you can see this, report it as a bug on the tracker."
	var/voice //If set and item is present in mask/suit, this name will be used for the wearer's speech.
	var/active

/obj/item/clothing/mask/gas/voice
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. It seems to house some odd electronics."
	var/obj/item/voice_changer/changer
	origin_tech = "syndicate=4"

/obj/item/clothing/mask/gas/voice/verb/Toggle_Voice_Changer()
	set category = "Object"
	set src in usr

	changer.active = !changer.active
	usr << "\blue You [changer.active ? "enable" : "disable"] the voice-changing module in \the [src]."

/obj/item/clothing/mask/gas/voice/verb/Set_Voice(name as text)
	set category = "Object"
	set src in usr

	var/voice = sanitize(copytext(name,1,MAX_MESSAGE_LEN))
	if(!voice || !length(voice)) return
	changer.voice = voice
	usr << "\blue You are now mimicking <B>[changer.voice]</B>.</font>"

/obj/item/clothing/mask/gas/voice/New()
	..()
	changer = new(src)
