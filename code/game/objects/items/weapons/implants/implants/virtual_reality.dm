/obj/item/implant/virtual_reality
	name = "\improper VR implant"
	desc = "Allows remote access to VR, anywhere, anytime."
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 3)
	var/activation_emote

/obj/item/implant/virtual_reality/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Ward-Takahashi VR Dual-Link Implant<BR>
	<b>Life:</b> One year.<BR>
	<b>Important Notes:</b> Reroutes brain stimuli into a virtual surrogate.<BR>
	<HR>
	<b>Implant Details:</b> Allows remote access to the virtual space shared by VR pods. With this implant, you don't need to enter a pod to actually access VR.<BR><BR>
	<b>Function:</b> On activation, creates a virtual surrogate in exactly the same way as a VR pod. Your normal body will immediately collapse and be rendered unconscious, so make sure you're laying down or somewhere safe!<BR><BR>
	<b>Special Features:</b> Like a VR pod, the implant will fully block all external stimuli. Unlike a VR pod, you won't be dragged back to reality if you're moved or your pod malfunctions. <b><i>You will have no way of knowing what's happening to your biological body without exiting VR.</i></b>"}

/obj/item/implant/virtual_reality/trigger(emote, mob/source)
	if (emote == activation_emote)
		activate()
		
/obj/item/implant/virtual_reality/activate()
	var/list/spawn_locs = list()
	for (var/obj/effect/landmark/L in landmarks_list)
		if (L.name == "vr entrance")
			spawn_locs += get_turf(L)
	imp_in.visible_message(
		SPAN_WARNING("\The [imp_in] abruptly stiffens and goes unresponsive."),
		SPAN_NOTICE("Your awareness rapidly shifts as your VR implant activates.")
	)
	SSvirtual_reality.create_virtual_mob(imp_in, imp_in.type, pick(spawn_locs))

/obj/item/implant/virtual_reality/emp_act(severity)
	var/mob/living/carbon/human/C = imp_in
	if (istype(C) && C.can_feel_pain())
		C.custom_pain("Your head suddenly reverberates with agony!", 200)
		C.playsound_local(C.loc, 'sound/misc/interference.ogg', 100)
		C.Weaken(4)
		var/mob/living/carbon/human/virtual_mob = SSvirtual_reality.virtual_occupants_to_mobs[imp_in]
		if (istype(virtual_mob) && virtual_mob.can_feel_pain())
			virtual_mob.custom_pain("Your head suddenly reverberates with agony!", 200)
			virtual_mob.playsound_local(virtual_mob.loc, 'sound/misc/interference.ogg', 100)
			virtual_mob.Weaken(4)

/obj/item/implant/virtual_reality/implanted(mob/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if (source.mind)
		source.StoreMemory("Your VR implant can be activated by using the [activation_emote] emote, <B>say *[activation_emote]</B> to attempt to activate.", /decl/memory_options/system)
	to_chat(source, "The VR implant can be activated by using the [activation_emote] emote, <B>say *[activation_emote]</B> to attempt to activate.")
	return TRUE

/obj/item/implanter/virtual_reality
	name = "implanter-VR"
	imp = /obj/item/implant/virtual_reality

/obj/item/implantcase/virtual_reality
	name = "glass case - 'VR'"
	imp = /obj/item/implant/virtual_reality
