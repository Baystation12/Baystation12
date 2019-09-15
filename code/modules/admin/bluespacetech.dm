/*
// Bluespace Technician is a godmode avatar designed for debugging and admin actions
// Their primary benefit is the ability to spawn in wherever you are, making it quick to get a human for your needs
// They also have incorporeal flying movement if they choose, which is often the fastest way to get somewhere specific
// They are mostly invincible, although godmode is a bit imperfect.
// Most of their superhuman qualities can be toggled off if you need a normal human for testing biological functions
*/

#define TESTING 1
//ADMIN_VERB_ADD(/client/proc/cmd_dev_bst, R_ADMIN|R_DEBUG, TRUE)

/client/proc/cmd_dev_bst()
	set category = "Debug"
	set name = "Spawn Bluespace Tech"
	set desc = "Spawns a Bluespace Tech to debug stuff"

	if(!check_rights(R_ADMIN|R_DEBUG, C = src))
		return

	var/T = get_turf(mob)
	var/mob/living/carbon/human/bst/bst = new(T)
	bst.anchored = TRUE
	bst.ckey = ckey
	bst.name = "Bluespace Technician"
	bst.real_name = "Bluespace Technician"
	bst.voice_name = "Bluespace Technician"
	bst.gender = prefs.gender
	if (prefs.gender == MALE)
		bst.h_style = "Crewcut"
	else if (prefs.gender == FEMALE)
		bst.h_style = "Long Hair Alt 2"
		bst.change_hair_color(255,255,204)
	//Items
	bst.equip_to_slot_or_del(new /obj/item/clothing/under/assistantformal/bst(bst), slot_w_uniform)
	bst.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert/bst(bst), slot_l_ear)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/holding/bst(bst), slot_back)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/clothing/shoes/black/bst(bst), slot_shoes)
	bst.equip_to_slot_or_del(new /obj/item/clothing/head/beret(bst), slot_head)
	bst.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/bst(bst), slot_glasses)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full/bst(bst), slot_belt)
	bst.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/white/bst(bst), slot_gloves)

	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/device/t_scanner(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/modular_computer/pda/captain(bst.back), slot_in_backpack)

	var/obj/item/weapon/storage/box/pills = new /obj/item/weapon/storage/box(null, TRUE)
	pills.name = "adminordrazine"
	for(var/i = 1, i < 12, i++)
		new /obj/item/weapon/reagent_containers/pill/adminordrazine(pills)
	bst.equip_to_slot_or_del(pills, slot_in_backpack)

	//Sort out ID
	var/obj/item/weapon/card/id/bst/id = new/obj/item/weapon/card/id/bst(bst)
	id.registered_name = bst.real_name
	id.assignment = "Bluespace Technician"
	id.name = "[id.assignment]"
	bst.equip_to_slot_or_del(id, slot_wear_id)
	bst.update_inv_wear_id()
	bst.regenerate_icons()

	//TODO:
	//Add the rest of the languages
	//bst.add_language(LANGUAGE_COMMON)

	spawn(10)
		bst_post_spawn(bst)

	log_admin("Bluespace Tech Spawned: X:[bst.x] Y:[bst.y] Z:[bst.z] User:[src]")
	return 1

/client/proc/bst_post_spawn(mob/living/carbon/human/bst/bst)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	bst.anchored = FALSE

/mob/living/carbon/human/bst
	universal_understand = TRUE
	status_flags = GODMODE
	var/fall_override = TRUE
	var/mob/original_body = null

/mob/living/carbon/human/bst/can_inject(var/mob/user, var/error_msg, var/target_zone)
	user << span("alert", "The [src] disarms you before you can inject them.")
	user.drop_item()
	return FALSE

/mob/living/carbon/human/bst/binarycheck()
	return TRUE

/mob/living/carbon/human/bst/proc/suicide()

	src.custom_emote(1,"presses a button on their suit, followed by a polite bow.")
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	spawn(10)
		qdel(src)
	if(key)

		var/mob/observer/ghost/ghost = ghostize(TRUE)
		ghost.name = "[ghost.key] BSTech"
		ghost.real_name = "[ghost.key] BSTech"
		ghost.voice_name = "[ghost.key] BSTech"
		ghost.admin_ghosted = TRUE

/mob/living/carbon/human/bst/verb/antigrav()
	set name = "Toggle Gravity"
	set desc = "Toggles on/off falling for you."
	set category = "BST"

	if (fall_override)
		fall_override = FALSE
		src << SPAN_NOTICE("You will now fall normally.")
	else
		fall_override = TRUE
		src << SPAN_NOTICE("You will no longer fall.")

/mob/living/carbon/human/bst/verb/bstwalk()
	set name = "Ruin Everything"
	set desc = "Uses bluespace technology to phase through solid matter and move quickly."
	set category = "BST"
	set popup_menu = 0

	if(!HasMovementHandler(/datum/movement_handler/mob/incorporeal))
		src << SPAN_NOTICE("You will now phase through solid matter.")
		//incorporeal_move = TRUE
		ReplaceMovementHandler(/datum/movement_handler/mob/incorporeal)
	else
		src << SPAN_NOTICE("You will no-longer phase through solid matter.")
		//incorporeal_move = FALSE
		RemoveMovementHandler(/datum/movement_handler/mob/incorporeal)

/mob/living/carbon/human/bst/verb/bstrecover()
	set name = "Rejuv"
	set desc = "Use the bluespace within you to restore your health"
	set category = "BST"
	set popup_menu = FALSE

	src.revive()

/mob/living/carbon/human/bst/verb/bstawake()
	set name = "Wake up"
	set desc = "This is a quick fix to the relogging sleep bug"
	set category = "BST"
	set popup_menu = FALSE

	src.sleeping = FALSE

/mob/living/carbon/human/bst/verb/bstquit()
	set name = "Teleport out"
	set desc = "Activate bluespace to leave and return to your original mob (if you have one)."
	set category = "BST"

	src.suicide()

/mob/living/carbon/human/bst/verb/tgm()
	set name = "Toggle Godmode"
	set desc = "Enable or disable god mode. For testing things that require you to be vulnerable."
	set category = "BST"

	status_flags ^= GODMODE
	src << SPAN_NOTICE("God mode is now [status_flags & GODMODE ? "enabled" : "disabled"]")

	src << span("notice", "God mode is now [status_flags & GODMODE ? "enabled" : "disabled"]")


///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////I T E M S/////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/storage/backpack/holding/bst
	//worn_access = TRUE

/obj/item/device/radio/headset/ert/bst
	name = "bluespace technician's headset"
	desc = "A Bluespace Technician's headset. The letters 'BST' are stamped on the side."
	translate_binary = TRUE

/obj/item/device/radio/headset/ert/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

/obj/item/device/radio/headset/ert/bst/recalculateChannels(var/setDescription = FALSE)
	..(setDescription)
	translate_binary = TRUE
	//translate_hive = TRUE

/obj/item/clothing/under/assistantformal/bst
	name = "bluespace technician's uniform"
	desc = "A Bluespace Technician's Uniform. There is a logo on the sleeve that reads 'BST'."
	has_sensor = FALSE
	sensor_mode = 0
	siemens_coefficient = 0
	cold_protection = FULL_BODY
	heat_protection = FULL_BODY

/obj/item/clothing/under/assistantformal/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

/obj/item/clothing/gloves/color/white/bst
	name = "bluespace technician's gloves"
	desc = "A pair of modified gloves. The letters 'BST' are stamped on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0

/obj/item/clothing/gloves/color/white/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

/obj/item/clothing/glasses/sunglasses/bst
	name = "bluespace technician's glasses"
	desc = "A pair of modified sunglasses. The word 'BST' is stamped on the side."
	vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/glasses/sunglasses/bst/verb/toggle_xray(mode in list("X-Ray without Lighting", "X-Ray with Lighting", "Normal"))
	set name = "Change Vision Mode"
	set desc = "Changes your glasses' vision mode."
	set category = "BST"
	set src in usr

	switch (mode)
		if ("X-Ray without Lighting")
			vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
			see_invisible = SEE_INVISIBLE_NOLIGHTING
		if ("X-Ray with Lighting")
			vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
			see_invisible = -1
		if ("Normal")
			vision_flags = FALSE
			see_invisible = -1

	usr << "<span class='notice'>\The [src]'s vision mode is now <b>[mode]</b>.</span>"

/obj/item/clothing/glasses/sunglasses/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

/obj/item/clothing/shoes/black/bst
	name = "bluespace technician's shoes"
	desc = "A pair of black shoes with extra grip. The letters 'BST' are stamped on the side."
	icon_state = "black"
	//TODO: Enable noslip
	//item_flags = NOSLIP

/obj/item/clothing/shoes/black/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

	return TRUE //Because Bluespace

/obj/item/weapon/card/id/bst
	icon_state = "centcom"
	desc = "An ID straight from Central Command. This one looks highly classified."

/obj/item/weapon/card/id/bst/New()
		access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()

/obj/item/weapon/card/id/bst/attack_hand()
	if(!usr)
		return
	if(!isbst(usr))
		usr << span("alert", "Your hand seems to go right through the [src]. It's like it doesn't exist.")
		return
	else
		..()

/obj/item/weapon/storage/belt/utility/full/bst

/obj/item/weapon/storage/belt/utility/full/bst/New()
	..()
	//new /obj/item/weapon/tool/multitool(src)
	new /obj/item/device/t_scanner(src)

/mob/living/carbon/human/bst/restrained()
	return !(status_flags & GODMODE)


/mob/living/carbon/human/bst/can_fall()
	return fall_override ? FALSE : ..()


//These are just wrappers on the standard move up/down verbs, duplicating them into the BST menu for easy clicking
/mob/living/carbon/human/bst/verb/moveup()
	set name = "Phase Upwards"
	set category = "BST"
	up()
	//zMove(UP)

/mob/living/carbon/human/bst/verb/movedown()
	set name = "Phase Downwards"
	set category = "BST"
	down()
	//zMove(DOWN)