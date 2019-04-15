/obj/item/organ/internal/augment/active/voice_modulator
	name = "multi-tensile vocal chords"
	action_button_name = "Mimic Voice"
	roundstart = TRUE
	known = FALSE
	var/obj/item/voice_changer/VC

/obj/item/organ/internal/augment/active/voice_modulator/Initialize()
	. = ..()
	VC = new(src)

/obj/item/organ/internal/augment/active/voice_modulator/Destroy()
	. = ..()
	QDEL_NULL(VC)

/obj/item/organ/internal/augment/active/voice_modulator/verb/VoiceSelect(name as text)
	set name = "Change Mimicked Voice"
	set category = "IC"

	var/voice = sanitize(name, MAX_NAME_LEN)
	if((!voice) || (!can_activate()))
		return
	VC.voice = voice
	to_chat(usr, "You are now mimicking [VC.voice]")

/obj/item/organ/internal/augment/active/voice_modulator/activate()
	if(!can_activate())
		return
	
	if(!VC.voice)
		to_chat(usr, "Decide on a voice first!")
		return

	VC.active = !VC.active
	to_chat(usr, "You are [VC.active ? "now" : "no longer"] mimicking [VC.voice].")