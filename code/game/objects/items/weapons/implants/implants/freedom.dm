//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	implant_color = "r"
	var/activation_emote
	var/uses

/obj/item/weapon/implant/freedom/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Freedom Beacon<BR>
	<b>Life:</b> optimum 5 uses<BR>
	<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
	<HR>
	<b>Implant Details:</b> <BR>
	<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
	mechanisms<BR>
	<b>Special Features:</b><BR>
	<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
	<b>Integrity:</b> The battery is extremely weak and commonly after injection its
	life can drive down to only 1 use.<HR>
	No Implant Specifics"}

/obj/item/weapon/implant/freedom/New()
	uses = rand(1, 5)
	..()
	return

/obj/item/weapon/implant/freedom/trigger(emote, mob/living/carbon/source as mob)
	if (src.uses < 1)	return 0
	if (emote == src.activation_emote)
		if(remove_cuffs_and_unbuckle(source))
			src.uses--
			to_chat(source, "You feel a faint click.")

/obj/item/weapon/implant/freedom/proc/remove_cuffs_and_unbuckle(mob/living/carbon/user)
	if(!user.handcuffed)
		return 0
	. = user.unEquip(user.handcuffed)
	if(. && user.buckled && user.buckled.buckle_require_restraints)
		user.buckled.unbuckle_mob()
	return

/obj/item/weapon/implant/freedom/implanted(mob/living/carbon/source)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	source.mind.store_memory("Freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return TRUE

/obj/item/weapon/implanter/freedom
	name = "implanter (F)"
	imp = /obj/item/weapon/implant/freedom

/obj/item/weapon/implantcase/freedom
	name = "glass case - 'freedom'"
	imp = /obj/item/weapon/implant/freedom