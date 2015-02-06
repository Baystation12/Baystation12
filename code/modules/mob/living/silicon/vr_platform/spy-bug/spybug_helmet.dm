//Virtual-Reality Helmet for the spy bug
/obj/item/clothing/head/helmet/VR
	name = "virtual reality helmet"
	desc = "Used to enter virtual reality simulations and uplinks. Has a built-in beta-wave sensor and neural clamp."

	icon_state = "VR-helmet"
	item_state = "VR-helmet"
	var/mob/living/user = null

/obj/item/clothing/head/helmet/VR/equipped(mob/M)
	user = M
	verbs += /obj/item/clothing/head/helmet/VR/verb/connect

/obj/item/clothing/head/helmet/VR/verb/connect()
	set name = "Connect"
	set desc = "Connect to the VR uplink."
	set category = "Virtual Reality"

	var/list/platforms_in_area

	for(var/mob/living/silicon/platform/O in orange( user, 3 ))
		platforms_in_area += O
		user << "Platform \"[O.name]\" found on [O.loc]"

	if( platforms_in_area )
		user << "<b>Attempting connection...</b>"
		var/mob/living/silicon/platform/P = input(src, "Which platform do you wish to connect to?") in null|platforms_in_area
		if(isnull( P ))
			user << "\red Connection aborted."
			return
		user << "<b>Please hold still.</b>"
		user << "Loading beta-wave profile... "
		sleep(10)
		user << "\blue The helmet vibrates softly. "
		sleep(50)
		user << "<b>Loaded</b>."
		user << "Locking neural clamp..."
		sleep(10)
		user << "\blue The helmet begins to emit an unearthly pitch..."
		sleep(30)
		user << "\blue You begin to feel your senses melt away..."
		sleep(30)
		user << "\red You panic as you realize you no longer have control over your body!"
		user.SetParalysis(1) // Kind of a hack way to do this, but oh well, deal with it :P
		sleep(20)
		user << "<b>Locked</b>."
		user.SetParalysis(0)

		P.activate( src )
	else
		user << "No suitable platform found within 3 meters of device."