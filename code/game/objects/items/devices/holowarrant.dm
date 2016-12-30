/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon_state = "holowarrant"
	item_state = "flashtool"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

var/list/storedwarrant = list() //All the warrants currently stored
var/activename = null
var/activecharges = null
var/activeauth = null //Currently active warrant
var/activetype = null //Is this a search or arrest warrtant?
var/activemap = using_map.full_name //Are we on Exodus or Torch?

//look at it
/obj/item/device/holowarrant/examine(mob/user)
	..()
	if(activename)
		to_chat(user, "It's a holographic warrant for '[activename]'.")
	if(in_range(user, src) || isghost(user))
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	if(!storedwarrant.len)
		to_chat(user, "There seem to be no warrants stored in the device. Please sync with the station's database.")
		return
	var/temp
	temp = input(user, "Which warrant would you like to load?") as null|anything in storedwarrant
	for(var/datum/data/record/warrant/W in data_core.warrants)
		if(W.fields["namewarrant"] == temp)
			activename = W.fields["namewarrant"]
			activecharges = W.fields["charges"]
			activeauth = W.fields ["auth"]
			activetype = W.fields["arrestsearch"]

//hit other people with it
/obj/item/device/holowarrant/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	user.visible_message("<span class='notice'>You show the warrant to [M]. </span>", \
			"<span class='notice'>[user] holds up a warrant projector and shows the contents to [M]. </span>")
	M.examinate(src)

//sync with database
/obj/item/device/holowarrant/verb/sync(mob/living/carbon/user as mob)
	if(!isnull(data_core.general))
		for(var/datum/data/record/warrant/W in data_core.warrants)
			storedwarrant += W.fields["namewarrant"]
		to_chat(usr, "<span class='notice'>The device hums faintly as it syncs with the station database</span>")
		if(storedwarrant.len == 0)
			user.visible_message("<span class='notice'>There are no warrants available</span>")

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	if(activetype == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>[activename]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center><large><b>Sol Central Government Colonial Marshal Bureau</b></large></br>
		in the jurisdiction of the</br>
		NAS Crescent in Nyx</br>
		</br>
		<b>ARREST WARRANT</b></center></br>
		</br>
		This document serves as authorization and notice for the arrest of _<u>[activename]</u>____ for the crime(s) of:</br>[activecharges]</br>
		</br>
		Vessel or habitat: _<u>[activemap]</u>____</br>
		</br>_<u>[activeauth]</u>____</br>
		<small>Person authorizing arrest</small></br>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of [activename]")
	if(activetype == "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: [activename]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center>in the jurisdiction of the</br>
		NAS Crescent in Nyx</br>
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
		<b>Suspect's/location name: </b>[activename]</br>
		</br>
		<b>For the following reasons: </b> [activecharges]</br>
		</br>
		<b>Warrant issued by: </b> [activeauth]</br>
		</br>
		Vessel or habitat: _<u>[activemap]</u>____</br>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [activename]")
