//Virtual-Reality Helmet for the spy bug
/obj/item/clothing/head/helmet/virtual
	name = "virtual reality helmet"
	desc = "Used to enter virtual reality simulations and uplinks. Has a built-in beta-wave sensor and neural clamp."

	icon_state = "VR-helmet"
	item_state = "VR-helmet"
	var/mob/living/user = null

/obj/item/clothing/head/helmet/virtual/equipped(mob/M)
	user = M
	verbs += /client/virtual/proc/connect

/client/virtual/proc/connect()
	set name = "Connect"
	set desc = "Connect to the VR uplink."
	set category = "Virtual Reality"

	var/list/platforms_in_area

	for( var/mob/living/silicon/platform/O in orange( src.mob, 3 )) // Finding suitable VR platforms in area
		platforms_in_area += O
		src << "Platform \"[O.name]\" found on [O.loc]"

	if( platforms_in_area )
		src << "<b>Attempting connection...</b>"
		var/mob/living/silicon/platform/P = input(src, "Which platform do you wish to connect to?") in null|platforms_in_area
		if(isnull( P ))
			src << "\red Connection aborted."
			return

		var/list/descriptive_text = list( "<b>Please hold still.</b>",
										  "Loading beta-wave profile... ",
										  "\blue The helmet vibrates softly. ",
										  "<b>Loaded</b>.",
										  "Locking neural clamp...",
										  "\blue The helmet begins to emit an unearthly pitch...",
										  "\blue You begin to feel your senses melt away...",
										  "\red You panic as you realize you no longer have control over your body!",
										  "<b>Locked</b>." )

		for( var/text in descriptive_text )
			src << text
			sleep( rand( 10, 30 ))

		P.activate( src.mob )
	else
		src << "No suitable platform found within 3 meters of device."