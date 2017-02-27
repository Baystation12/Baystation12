//BS12 Explosive
/obj/item/weapon/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	icon_state = "implant_evil"
	var/elevel
	var/phrase
	var/code = 13
	var/frequency = 1443
	var/datum/radio_frequency/radio_connection

/obj/item/weapon/implant/explosive/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
	<b>Life:</b> Activates upon codephrase.<BR>
	<b>Important Notes:</b> Explodes<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
	<b>Special Features:</b> Explodes<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	if(!malfunction)
		. += {"
		<HR>Explosion yield mode:<BR>
		<A href='byond://?src=\ref[src];mode=1'>[elevel ? elevel : "NONE SET"]</A><BR>
		Activation phrase:<BR>
		<A href='byond://?src=\ref[src];phrase=1'>[phrase ? phrase : "NONE SET"]</A><BR>
		Frequency:<BR>
		<A href='byond://?src=\ref[src];freq=-10'>-</A>
		<A href='byond://?src=\ref[src];freq=-2'>-</A>
		[format_frequency(src.frequency)]
		<A href='byond://?src=\ref[src];freq=2'>+</A>
		<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
		Code:<BR>
		<A href='byond://?src=\ref[src];code=-5'>-</A>
		<A href='byond://?src=\ref[src];code=-1'>-</A>
		<A href='byond://?src=\ref[src];code=set'>[src.code]</A>
		<A href='byond://?src=\ref[src];code=1'>+</A>
		<A href='byond://?src=\ref[src];code=5'>+</A><BR>"}

/obj/item/weapon/implant/explosive/initialize()
	..()
	set_frequency(frequency)

/obj/item/weapon/implant/explosive/Topic(href, href_list)
	..()
	if (href_list["freq"])
		var/new_frequency = frequency + text2num(href_list["freq"])
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		set_frequency(new_frequency)
		interact(usr)
	if (href_list["code"])
		var/adj = text2num(href_list["code"])
		if(!adj)
			code = input("Set radio activation code","Radio activation") as num
		else
			code += adj
		code = Clamp(code,1,100)
		interact(usr)
	if (href_list["mode"])
		var/mod = input("Set explosion mode", "Explosion mode") as null|anything in list("Localized Limb", "Destroy Body", "Full Explosion")
		if(mod)
			elevel = mod
		interact(usr)
	if (href_list["phrase"])
		var/talk = input("Set activation phrase", "Audio activation", phrase) as text|null
		if(talk)
			phrase = talk
		interact(usr)

/obj/item/weapon/implant/explosive/receive_signal(datum/signal/signal)
	if(signal && signal.encryption == code)
		activate()

/obj/item/weapon/implant/explosive/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

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

	imp_in.visible_message("<span class='warning'>Something beeps inside [imp_in][part ? "'s [part.name]" : ""]!</span>")
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
	if(!elevel)
		elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	if(!phrase)
		phrase = sanitize_phrase(input("Choose activation phrase:") as text)
	var/memo = "Explosive implant in [target] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate. It can also be triggered with a radio signal on frequency <b>[format_frequency(src.frequency)]</b> with code <b>[code]</b>."
	usr.mind.store_memory(memo, 0, 0)
	to_chat(usr, memo)
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