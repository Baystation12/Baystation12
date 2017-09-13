/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon_state = "holowarrant"
	item_state = "holowarrant"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/datum/data/record/warrant/active

//look at it
/obj/item/device/holowarrant/examine(mob/user)
	. = ..()
	if(active)
		to_chat(user, "It's a holographic warrant for '[active.fields["namewarrant"]]'.")
	if(in_range(user, src) || isghost(user))
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to be closer if you want to read it.</span>")

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	active = null
	var/list/warrants = list()
	if(!isnull(GLOB.data_core.general))
		for(var/datum/data/record/warrant/W in GLOB.data_core.warrants)
			if(!W.archived)
				warrants += W.fields["namewarrant"]
	if(warrants.len == 0)
		to_chat(user,"<span class='notice'>There are no warrants available</span>")
		return
	var/temp
	temp = input(user, "Which warrant would you like to load?") as null|anything in warrants
	for(var/datum/data/record/warrant/W in GLOB.data_core.warrants)
		if(W.fields["namewarrant"] == temp)
			active = W
	update_icon()

/obj/item/device/holowarrant/attackby(obj/item/weapon/W, mob/user)
	if(active)
		var/obj/item/weapon/card/id/I = W.GetIdCard()
		if(I && (access_security in I.access))
			var/choice = alert(user, "Would you like to authorize this warrant?","Warrant authorization","Yes","No")
			if(choice == "Yes")
				active.fields["auth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
			user.visible_message("<span class='notice'>You swipe \the [I] through the [src].</span>", \
					"<span class='notice'>[user] swipes \the [I] through the [src].</span>")
			broadcast_security_hud_message("\A [active.fields["arrestsearch"]] warrant for <b>[active.fields["namewarrant"]]</b> has been authorized by [I.assignment ? I.assignment+" " : ""][I.registered_name].", src)
		else
			to_chat(user, "<span class='notice'>A red \"Access Denied\" light blinks on \the [src]</span>")
		return 1
	..()

//hit other people with it
/obj/item/device/holowarrant/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	user.visible_message("<span class='notice'>[user] holds up a warrant projector and shows the contents to [M].</span>", \
			"<span class='notice'>You show the warrant to [M].</span>")
	M.examinate(src)

/obj/item/device/holowarrant/update_icon()
	if(active)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	if(!active)
		return
	if(active.fields["arrestsearch"] == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>[active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center><large><b>Sol Central Government Colonial Marshal Bureau</b></large></br>
		in the jurisdiction of the</br>
		[GLOB.using_map.boss_name] in [GLOB.using_map.system_name]</br>
		</br>
		<b>ARREST WARRANT</b></center></br>
		</br>
		This document serves as authorization and notice for the arrest of _<u>[active.fields["namewarrant"]]</u>____ for the crime(s) of:</br>[active.fields["charges"]]</br>
		</br>
		Vessel or habitat: _<u>[GLOB.using_map.station_name]</u>____</br>
		</br>_<u>[active.fields["auth"]]</u>____</br>
		<small>Person authorizing arrest</small></br>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of [active.fields["namewarrant"]]")
	if(active.fields["arrestsearch"] ==  "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: [active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center>in the jurisdiction of the</br>
		[GLOB.using_map.boss_name] in [GLOB.using_map.system_name]</br>
		</br>
		<b>SEARCH WARRANT</b></center></br>
		</br>
		<small><i>The Security Officer(s) bearing this Warrant are hereby authorized by the Issuer </br>
		to conduct a one time lawful search of the Suspect's person/belongings/premises and/or Department </br>
		for any items and materials that could be connected to the suspected criminal act described below, </br>
		pending an investigation in progress. The Security Officer(s) are obligated to remove any and all</br>
		such items from the Suspects posession and/or Department and file it as evidence. The Suspect/Department </br>
		staff is expected to offer full co-operation. In the event of the Suspect/Department staff attempting </br>
		to resist/impede this search or flee, they must be taken into custody immediately! </br>
		All confiscated items must be filed and taken to Evidence!</small></i></br>
		</br>
		<b>Suspect's/location name: </b>[active.fields["namewarrant"]]</br>
		</br>
		<b>For the following reasons: </b> [active.fields["charges"]]</br>
		</br>
		<b>Warrant issued by: </b> [active.fields ["auth"]]</br>
		</br>
		Vessel or habitat: _<u>[GLOB.using_map.station_name]</u>____</br>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [active.fields["namewarrant"]]")
