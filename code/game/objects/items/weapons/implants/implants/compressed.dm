/obj/item/weapon/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	var/activation_emote
	var/obj/item/scanned

/obj/item/weapon/implant/compressed/get_data()
	var/dat = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [GLOB.using_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
	<b>Life:</b> Activates upon death.<BR>
	<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
	<b>Special Features:</b> Alerts crew to crewmember death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/weapon/implant/compressed/trigger(emote, mob/source)
	if (src.scanned == null)
		return 0

	if (emote == src.activation_emote)
		to_chat(source, "The air glows as \the [src.scanned.name] uncompresses.")
		activate()

/obj/item/weapon/implant/compressed/activate()
	var/turf/T = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(T)
	qdel(src)

/obj/item/weapon/implant/compressed/implanted(mob/source)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if (source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return TRUE

/obj/item/weapon/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	desc = "The matter compressor safety is on."
	var/safe = 1
	imp = /obj/item/weapon/implant/compressed

/obj/item/weapon/implanter/compressed/update_icon()
	if (imp)
		var/obj/item/weapon/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/weapon/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/weapon/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please compress an object with the implanter first.")
		return
	..()

/obj/item/weapon/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/weapon/implant/compressed/c = imp
		if (c.scanned)
			if (!istype(A,/obj/item/weapon/storage))
				to_chat(user, "<span class='warning'>Something is already compressed inside the implant!</span>")
			return
		else if(safe)
			if (!istype(A,/obj/item/weapon/storage))
				to_chat(user, "<span class='warning'>The matter compressor safeties prevent you from doing that.</span>")
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		safe = 2
		desc = "It currently contains some matter."
		update_icon()

/obj/item/weapon/implanter/compressed/attack_self(var/mob/user)
	if(!imp || safe == 2)
		return ..()

	safe = !safe
	to_chat(user, "<span class='notice'>You [safe ? "enable" : "disable"] the matter compressor safety.</span>")
	src.desc = "The matter compressor safety is [safe ? "on" : "off"]."