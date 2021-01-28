/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon_state = "holowarrant"
	item_state = "holowarrant"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	req_access = list(list(access_heads, access_security))
	var/datum/computer_file/data/warrant/active

//look at it
/obj/item/device/holowarrant/examine(mob/user, distance)
	. = ..()
	if(active)
		to_chat(user, "It's a holographic warrant for '[active.fields["namewarrant"]]'.")
	if(distance <= 1)
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to be closer if you want to read it.</span>")

// an active warrant with access authorized grants access
/obj/item/device/holowarrant/GetAccess()
	. = list()

	if(!active)
		return

	if(active.archived)
		return

	. |= active.fields["access"]

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	active = null
	var/list/warrants = list()
	for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
		if(!W.archived)
			warrants += W.fields["namewarrant"]
	if(warrants.len == 0)
		to_chat(user,"<span class='notice'>There are no warrants available</span>")
		return
	var/temp
	temp = input(user, "Which warrant would you like to load?") as null|anything in warrants
	for(var/datum/computer_file/data/warrant/W in GLOB.all_warrants)
		if(W.fields["namewarrant"] == temp)
			active = W
	update_icon()

/obj/item/device/holowarrant/attackby(obj/item/weapon/W, mob/user)
	if(active)
		var/obj/item/weapon/card/id/I = W.GetIdCard()
		if(I && check_access_list(I.GetAccess()))
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

/obj/item/device/holowarrant/on_update_icon()
	if(active)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	if(!active)
		return
	if(active.fields["arrestsearch"] == "arrest")
		var/output = {"
		<HTML><meta charset=\"UTF-8\"><HEAD><TITLE>[active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#ffffff'><center><large><b>SCG SFP Warrant Tracker System</b></large></br>
		</br>
		Issued in the jurisdiction of the</br>
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
		<HTML><meta charset=\"UTF-8\"><HEAD><TITLE>Search Warrant: [active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#ffffff'><center><large><b>SCG SFP Warrant Tracker System</b></large></br>
		</br>
		Issued in the jurisdiction of the</br>
		[GLOB.using_map.boss_name] in [GLOB.using_map.system_name]</br>
		</br>
		<b>SEARCH WARRANT</b></center></br>
		</br>
		<b>Suspect's/location name: </b>[active.fields["namewarrant"]]</br>
		</br>
		<b>For the following reasons: </b> [active.fields["charges"]]</br>
		</br>
		<b>Warrant issued by: </b> [active.fields ["auth"]]</br>
		</br>
		Vessel or habitat: _<u>[GLOB.using_map.station_name]</u>____</br>
		</br>
		<center><small><i>The Security Officer(s) bearing this Warrant are hereby authorized by the Issuer to conduct a one time lawful search of the Suspect's person/belongings/premises and/or Department for any items and materials that could be connected to the suspected criminal act described below, pending an investigation in progress.</br>
		</br>
		The Security Officer(s) are obligated to remove any and all such items from the Suspects posession and/or Department and file it as evidence.</br>
		</br>
		The Suspect/Department staff is expected to offer full co-operation.</br>
		</br>
		In the event of the Suspect/Department staff attempting to resist/impede this search or flee, they must be taken into custody immediately! </br>
		</br>
		All confiscated items must be filed and taken to Evidence!</small></i></center></br>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [active.fields["namewarrant"]]")
