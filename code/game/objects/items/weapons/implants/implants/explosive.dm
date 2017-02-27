//BS12 Explosive
/obj/item/weapon/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	var/elevel = "Localized Limb"
	var/phrase = "supercalifragilisticexpialidocious"
	icon_state = "implant_evil"

/obj/item/weapon/implant/explosive/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
	<b>Life:</b> Activates upon codephrase.<BR>
	<b>Important Notes:</b> Explodes<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
	<b>Special Features:</b> Explodes<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/weapon/implant/explosive/hear_talk(mob/M as mob, msg)
	hear(msg)
	return

/obj/item/weapon/implant/explosive/hear(var/msg)
	if(findtext(sanitize_phrase(msg),phrase))
		activate()
		qdel(src)

/obj/item/weapon/implant/explosive/proc/sanitize_phrase(phrase)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	return replace_characters(phrase, replacechars)

/obj/item/weapon/implant/explosive/activate()
	if (malfunction == MALFUNCTION_PERMANENT)
		return

	if(!ismob(imp_in))
		return

	var/mob/M = imp_in
	message_admins("Explosive implant triggered in [M] ([M.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>) ")
	log_game("Explosive implant triggered in [M] ([M.key]).")

	switch(elevel)
		if ("Localized Limb")
			small_boom()
		if ("Destroy Body")
			explosion(get_turf(M), -1, 0, 1, 6)
			M.gib()
		if ("Full Explosion")
			explosion(get_turf(M), 0, 1, 3, 6)
			M.gib()

	var/turf/T = get_turf(imp_in)
	if(T)
		T.hotspot_expose(3500,125)

/obj/item/weapon/implant/explosive/implanted(mob/target)
	elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	phrase = sanitize_phrase(input("Choose activation phrase:") as text)
	usr.mind.store_memory("Explosive implant in [target] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate.", 0, 0)
	to_chat(usr, "The implanted explosive implant in [target] can be activated by saying something containing the phrase ''[phrase]'', <B>say [src.phrase]</B> to attempt to activate.")
	listening_objects += src
	return TRUE

/obj/item/weapon/implant/explosive/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY
	switch (severity)
		if (2.0)	//Weak EMP will make implant tear limbs off.
			if (prob(10))
				small_boom()
		if (1.0)	//strong EMP will melt implant either making it go off, or disarming it
			if (prob(25))
				if (prob(50))
					activate()		//50% chance of bye bye
				else
					meltdown()		//50% chance of implant disarming
	spawn (20)
		malfunction = 0

/obj/item/weapon/implant/explosive/proc/small_boom()
	if (ishuman(imp_in) && part)
		imp_in.visible_message("<span class='warning'>Something beeps inside [imp_in][part ? "'s [part.name]" : ""]!</span>")
		playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
		spawn(25)
			if (ishuman(imp_in) && part)
				if (istype(part,/obj/item/organ/external/chest) ||	\
					istype(part,/obj/item/organ/external/groin))
					part.take_damage(60, used_weapon = "Explosion")
				else
					part.droplimb(0,DROPLIMB_BLUNT)
			part.implants -= src
	explosion(get_turf(imp_in), -1, -1, 2, 3)
	qdel(src)

/obj/item/weapon/implant/explosive/Destroy()
	listening_objects -= src
	return ..()