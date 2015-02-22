//Virtual-Reality Helmet for the spy bug
/obj/item/clothing/head/helmet/virtual
	name = "virtual reality helmet"
	desc = "Used to enter virtual reality simulations and uplinks. Has a built-in beta-wave sensor and neural clamp."

	icon_state = "virtualhelmet"
	item_state = "virtualhelmet"
	flags = HEADCOVERSEYES
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = HEAD|FACE|EYES
	var/mob/living/user = null

/obj/item/clothing/head/helmet/virtual/equipped(mob/M)
	user = M
	verbs += /client/virtual/proc/connect

/client/virtual/proc/connect()
	set name = "Connect"
	set desc = "Connect to the VR uplink."
	set category = "Virtual Reality"
	set src in usr

	for(var/mob/living/silicon/platform/O in orange(usr.loc, 3)) // Finding suitable VR platforms in area
		if(alert(usr, "Would you like to connect to platform: [O.real_name]?", "Confirm", "Yes", "No") == "Yes")
			usr << "<b>Attempting connection...</b>"
			if(O.active != 1)
				var/list/descriptive_text = list( "<b>Please hold still.</b>",
												  "\blue Loading beta-wave profile...",
												  "\blue The helmet vibrates softly..",
												  "<b>Loaded</b>.",
												  "\blue Locking neural clamp...",
												  "\blue The helmet begins to emit an unearthly pitch...",
												  "\blue You begin to feel your senses melt away...",
												  "\red You panic as you realize you no longer have control over your body!",
												  "<b>Locked</b>." )

				for(var/text in descriptive_text)
					sleep(rand(10,30))
					usr << text

				O.activate(usr)
			else
				usr << "<b> Error another encrypted connection is active on that platform."

	usr << "No suitable platform found within 3 meters of device."