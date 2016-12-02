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

//look at it
/obj/item/device/holowarrant/examine(mob/user)
	..()
	if(activename)
		to_chat(user, "It's a holographic warrant for '[activename]'.")
	if(in_range(user, src) || isghost(user))
		show_content(usr)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	if(storedwarrant.len == 0)
		user << "There seem to be no warrants stored in the device. Please sync with the station's database."
		return
	var/temp
	temp = input(usr, "Which warrant would you like to load?") in storedwarrant
	for(var/datum/data/record/warrant/W)
		if(W.fields["namew"] == temp)
			activename = W.fields["namew"]
			activecharges = W.fields["charges"]
			activeauth = W.fields ["auth"]

//hit other people with it
/obj/item/device/holowarrant/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	user.visible_message("<span class='notice'>You show the warrant to [M]. </span>", \
			"<span class='notice'>[user] holds up a warrant projector and shows the contents to [M]. </span>")
	M.examinate(src)

//sync with database
/obj/item/device/holowarrant/verb/sync(mob/living/carbon/user as mob)
	if(!isnull(data_core.general))
		for(var/datum/data/record/warrant/W)
			storedwarrant += W.fields["namew"]
		user.visible_message("<span class='notice'>The device hums faintly as it syncs with the station database</span>")
		if(storedwarrant.len == 0)
			user.visible_message("<span class='notice'>There are no warrants available</span>")

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	user << browse("<HTML><HEAD><TITLE>[activename]</TITLE></HEAD><BODY bgcolor='#FFFFFF'><center><large><b>Sol Central Government Colonial Marshal Bureau</b></large></br>in the jurisdiction of the</br>NAS Crescent in Nyx</br></br><b>ARREST WARRANT</b></center></br></br>This document serves as authorization and notice for the arrest of _<u>[activename]</u>____ for the crime(s) of:</br>[activecharges]</br></br>Vessel or habitat: _<u>NSS Exodus</u>____</br></br>_<u>[activeauth]</u>____</br><small>Person authorizing arrest</small></br></BODY></HTML>", "window=Warrant for [activename]")