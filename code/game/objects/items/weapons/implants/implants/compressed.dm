/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 2, TECH_ESOTERIC = 2)
	hidden = 1
	var/activation_emote
	var/obj/item/scanned

/obj/item/implant/compressed/trigger(emote, mob/source)
	if (src.scanned == null)
		return 0

	if (emote == src.activation_emote)
		to_chat(source, "The air glows as \the [src.scanned.name] uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	if(malfunction) return
	var/turf/T = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(T)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if (source.mind)
		source.StoreMemory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", /decl/memory_options/system)
	to_chat(source, "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return TRUE

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	desc = "The matter compressor safety is on."
	var/safe = 1
	imp = /obj/item/implant/compressed

/obj/item/implanter/compressed/on_update_icon()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please compress an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(obj/item/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A) && imp)
		var/obj/item/implant/compressed/c = imp
		if (c.scanned)
			if (!istype(A,/obj/item/storage))
				to_chat(user, "<span class='warning'>Something is already compressed inside the implant!</span>")
			return
		else if(safe)
			if (!istype(A,/obj/item/storage))
				to_chat(user, "<span class='warning'>The matter compressor safeties prevent you from doing that.</span>")
			return
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			if(!H.unEquip(A))
				return
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		c.scanned = A
		A.forceMove(c)  //Store it inside
		safe = 2
		desc = "It currently contains some matter."
		update_icon()

/obj/item/implanter/compressed/attack_self(var/mob/user)
	if(!imp || safe == 2)
		return ..()

	safe = !safe
	to_chat(user, "<span class='notice'>You [safe ? "enable" : "disable"] the matter compressor safety.</span>")
	src.desc = "The matter compressor safety is [safe ? "on" : "off"]."
