//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = BLOCKHAIR
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet",
		)
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	species_restricted = list("exclude","Diona", "Xenomorph")
	flash_protection = FLASH_PROTECTION_MAJOR

	var/obj/machinery/camera/camera

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/head/helmet/space/initialize()
	..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_camera

/obj/item/clothing/head/helmet/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			usr << "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>"
		else
			usr << "<span class='notice'>Camera deactivated.</span>"

/obj/item/clothing/head/helmet/space/examine(var/mob/user)
	if(..(user, 1) && camera)
		user << "This helmet has a built-in camera. Its [!ispath(camera) && camera.status ? "" : "in"]active."

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments. \"NSS EXODUS\" is written in large block letters on the back."
	icon_state = "space"
	item_state = "s_suit"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_spacesuits.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_spacesuits.dmi',
		)
	w_class = 4//large item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency,/obj/item/device/suit_cooling_unit)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	species_restricted = list("exclude","Diona", "Xenomorph")

/obj/item/clothing/suit/space/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1
