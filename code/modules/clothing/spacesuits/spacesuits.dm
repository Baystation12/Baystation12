//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	flags_inv = BLOCKHAIR
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet",
		)
	permeability_coefficient = 0
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.9
	randpixel = 0
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_DIONA)
	flash_protection = FLASH_PROTECTION_MAJOR

	var/obj/machinery/camera/camera

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 0.5
	on = 0

	var/tinted = null	//Set to non-null for toggleable tint helmets

/obj/item/clothing/head/helmet/space/Destroy()
	if(camera && !ispath(camera))
		QDEL_NULL(camera)
	. = ..()

/obj/item/clothing/head/helmet/space/Initialize()
	. = ..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_camera
	if(!isnull(tinted))
		verbs += /obj/item/clothing/head/helmet/space/proc/toggle_tint
		update_tint()

/obj/item/clothing/head/helmet/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)
		camera.is_helmet_cam = TRUE

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
		else
			to_chat(usr, "<span class='notice'>Camera deactivated.</span>")

/obj/item/clothing/head/helmet/space/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && camera)
		to_chat(user, "This helmet has a built-in camera. Its [!ispath(camera) && camera.status ? "" : "in"]active.")

/obj/item/clothing/head/helmet/space/proc/update_tint()
	if(tinted)
		icon_state = "[initial(icon_state)]_dark"
		item_state = "[initial(item_state)]_dark"
		flash_protection = FLASH_PROTECTION_MAJOR
		flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
		tint = TINT_MODERATE
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		flash_protection = FLASH_PROTECTION_NONE
		flags_inv = HIDEEARS|BLOCKHAIR
		tint = TINT_NONE
	update_icon()
	update_clothing_icon()

/obj/item/clothing/head/helmet/space/proc/toggle_tint()
	set name = "Toggle Helmet Tint"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	tinted = !tinted
	to_chat(usr, "You toggle [src]'s visor tint.")
	update_tint()

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments."
	icon_state = "space"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_spacesuits.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_spacesuits.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "s_suit",
		slot_r_hand_str = "s_suit",
	)
	w_class = ITEM_SIZE_LARGE//large item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/suit_cooling_unit
	)
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	siemens_coefficient = 0.9
	randpixel = 0
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_DIONA)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	equip_delay = 5 SECONDS
	equip_delay_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT


/obj/item/clothing/suit/space/equip_delay_before(mob/user, slot, equip_flags)
	user.setClickCooldown(1 SECOND)
	user.visible_message(
		SPAN_ITALIC("\The [user] begins to struggle into \the [src]."),
		SPAN_ITALIC("You begin to struggle into \the [src]."),
		SPAN_ITALIC("You can hear metal clicking and fabric rustling."),
		range = 5
	)


/obj/item/clothing/suit/space/equip_delay_after(mob/user, slot, equip_flags)
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes putting on \the [src]."),
		SPAN_NOTICE("You finish putting on \the [src]."),
		range = 5
	)


/obj/item/clothing/suit/space/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1
