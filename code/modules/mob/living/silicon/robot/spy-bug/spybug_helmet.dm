//Virtual-Reality Helmet for the spy bug
/obj/item/clothing/head/helmet/space/syndicate/VR
	name = "virtual reality helmet"
	desc = "Used to enter virtual reality simulations and uplinks. Has a built-in beta-wave sensor and neural clamp."

	icon_state = "VR-helmet"
	item_state = "VR-helmet"
	var/user = null

/obj/item/clothing/head/helmet/space/syndicate/VR/equipped(mob/M)
	user = M
	verbs += /obj/item/clothing/head/helmet/space/syndicate/VR/verb/connect

/obj/item/clothing/head/helmet/space/syndicate/VR/verb/connect()
	set name = "Connect"
	set desc = "Connect to the VR uplink."
	set category = "Virtual Reality"

	var/list/spybugs_in_area

	for(var/mob/living/silicon/robot/spybug/O in range(src,3))
		spybugs_in_area += O
		user << "Spy bug found at [O.loc]"

	if( spybugs_in_area )
		user << "Loading beta-wave profile... "
		sleep(50)
		user << "<b>Loaded</b>."
		user << "Locking neural clamp..."
		sleep(70)
		user << "<b>Locked</b>."

		var/mob/living/body = user
		var/mob/living/silicon/robot/spybug/spybug

		spybug.transfer_personality(user, body)
	else
		user << "No suitable platform found within 3 meters of device."