//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	implant_color = "r"
	var/activation_emote = "chuckle"
	var/uses = 1.0


	New()
		src.activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
		src.uses = rand(1, 5)
		..()
		return

	trigger(emote, mob/living/carbon/source as mob)
		if (src.uses < 1)	return 0
		if (emote == src.activation_emote)
			if(remove_cuffs_and_unbuckle(source))
				src.uses--
				source << "You feel a faint click."

	proc/remove_cuffs_and_unbuckle(mob/living/carbon/user)
		if(!user.handcuffed)
			return 0
		. = user.unEquip(user.handcuffed)
		if(. && user.buckled && user.buckled.buckle_require_restraints)
			user.buckled.unbuckle_mob()
		return

	implanted(mob/living/carbon/source)
		source.mind.store_memory("Freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
		source << "The implanted freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate."
		return 1

	get_data()
		var/dat = {"
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
		return dat
