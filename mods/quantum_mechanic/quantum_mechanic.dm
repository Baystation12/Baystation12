
/singleton/modpack/bstechnican
	name = "Bluespace technican"
	dreams = list("bluespace anomalies")

/*
// Quantum Mechanic is a godmode avatar designed for debugging and admin actions
// Their primary benefit is the ability to spawn in wherever you are, making it quick to get a human for your needs
// They also have incorporeal flying movement if they choose, which is often the fastest way to get somewhere specific
// They are mostly invincible, although godmode is a bit imperfect.
// Most of their superhuman qualities can be toggled off if you need a normal human for testing biological functions
*/

/client/proc/spawn_quantum_mechanic()
	set category = "Debug"
	set name = "Spawn Quantum Mechanic"
	set desc = "Spawns a Quantum Mechanic to debug stuff."

	if(!check_rights(R_ADMIN|R_DEBUG))
		return

	var/T = get_turf(mob)
	var/mob/living/carbon/human/quantum/Q = new (T)

	prefs.copy_to(Q)

	Q.set_dir(mob.dir)
	Q.ckey = ckey

	var/singleton/hierarchy/outfit/outfit = outfit_by_type(/singleton/hierarchy/outfit/quantum)
	outfit.equip(Q)

	//Sort out ID
	var/obj/item/card/id/quantum/id = new (Q)
	id.registered_name = Q.real_name
	id.assignment = "Quantum Mechanic"
	Q.equip_to_slot_or_del(id, slot_wear_id_str)

	Q.reload_fullscreen()

	for(var/language in subtypesof(/datum/language))
		Q.add_language(language)

	sparks(3, 1, Q)
	Q.phase_in(get_turf(Q))
	log_debug("Quantum Mechanic spawned at X: [Q.x], Y: [Q.y], Z: [Q.z]. User: [src]")

/singleton/hierarchy/outfit/quantum
	name = "Quantum Mechanic"
	glasses =  /obj/item/clothing/glasses/sunglasses/quantum
	uniform =  /obj/item/clothing/under/quantum/suit
	shoes =    /obj/item/clothing/shoes/black/quantum
	l_ear =    /obj/item/device/radio/headset/specops/quantum
	back =     /obj/item/storage/backpack/holding/quantum
	head =     /obj/item/clothing/head/helmet/quantum/helmet
	belt =     /obj/item/storage/belt/utility/full/quantum
	id_slot = slot_wear_id
	id_types = list(/obj/item/card/id/quantum)

/mob/living/carbon/human/quantum
	status_flags = NO_ANTAG
	universal_understand = TRUE
	var/fall_override = TRUE
	movement_handlers = list(
		/datum/movement_handler/mob/relayed_movement,
		/datum/movement_handler/mob/death,
		/datum/movement_handler/mob/conscious,
		/datum/movement_handler/mob/eye,
		/datum/movement_handler/move_relay,
		/datum/movement_handler/mob/buckle_relay,
		/datum/movement_handler/mob/delay,
		/datum/movement_handler/mob/stop_effect,
		/datum/movement_handler/mob/physically_capable,
		/datum/movement_handler/mob/physically_restrained,
		/datum/movement_handler/mob/space,
		/datum/movement_handler/mob/multiz,
		/datum/movement_handler/mob/multiz_connected,
		/datum/movement_handler/mob/movement
	)

/mob/living/carbon/human/quantum/can_inject(mob/user, target_zone)
	to_chat(user, SPAN_DANGER("\The [src] disarms you before you can inject them."))
	user.drop_item()
	return FALSE

/mob/living/carbon/human/quantum/binarycheck()
	return TRUE

/mob/living/carbon/human/quantum/proc/delete_self()
	if(QDELETED(src))
		return

	custom_emote(VISIBLE_MESSAGE, "[src] presses a button on their suit, followed by a polite bow.")
	phase_out(get_turf(src))
	sparks(3, 1, src)

	if(key)
		var/mob/observer/ghost/ghost = ghostize(1)
		ghost.set_dir(dir)
		ghost.can_reenter_corpse = TRUE
		ghost.reload_fullscreen()

	QDEL_IN(src, 7)

/mob/living/carbon/human/quantum/verb/quantum_antigrav()
	set name = "Toggle Gravity"
	set desc = "Toggles falling."
	set category = "Ω"

	if (fall_override)
		fall_override = FALSE
		to_chat(usr, SPAN_NOTICE("You will now fall normally."))
	else
		fall_override = TRUE
		to_chat(usr, SPAN_NOTICE("You will no longer fall."))

/mob/living/carbon/human/quantum/verb/quantum_walk()
	set name = "Toggle Phase Walking"
	set desc = "Uses quantum technology to phase through solid matter and move quickly."
	set category = "Ω"
	set popup_menu = 0

	if(usr.HasMovementHandler(/datum/movement_handler/mob/incorporeal))
		usr.RemoveMovementHandler(/datum/movement_handler/mob/incorporeal)
		to_chat(usr, SPAN_NOTICE("You will no longer phase through solid matter."))
	else
		usr.ReplaceMovementHandler(/datum/movement_handler/mob/incorporeal)
		to_chat(usr, SPAN_NOTICE("You will now phase through solid matter."))

/mob/living/carbon/human/quantum/verb/quantum_recover()
	set name = "Rejuvenate Self"
	set desc = "Use quantum powers you to restore your health."
	set category = "Ω"
	set popup_menu = FALSE

	revive()

/mob/living/carbon/human/quantum/verb/quantum_quit()
	set name = "Teleport Out"
	set desc = "Activate quantum magic to leave and return to your original mob (if you have one)."
	set category = "Ω"

	delete_self()

/mob/living/carbon/human/quantum/verb/quantum_tgm()
	set name = "Toggle Godmode"
	set desc = "Enable or disable god mode. For testing things that require you to be vulnerable."
	set category = "Ω"

	status_flags ^= GODMODE
	to_chat(usr, SPAN_NOTICE("God mode is now [(status_flags & GODMODE) ? "enabled" : "disabled"]."))

// Bag o Holding
/obj/item/storage/backpack/holding/quantum
	storage_slots = 56
	max_w_class = 400
	startswith = list(/obj/item/clothing/glasses/sunglasses/quantum = 1)

/obj/item/storage/backpack/holding/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// Headset
/obj/item/device/radio/headset/specops/quantum
	name = "quantum mechanic's headset"
	desc = "A quantum mechanic's headset. The letter 'Ω' is stamped on the side."
	translate_binary = TRUE
	ks1type = /obj/item/device/encryptionkey/full_access


/obj/item/device/radio/headset/specops/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// overload this so we can force translate flags without the required keys
/obj/item/device/radio/headset/specops/quantum/recalculateChannels(setDescription = FALSE)
	. = ..(setDescription)
	translate_binary = TRUE

// Clothes

// Helmet
/obj/item/clothing/head/helmet/quantum
	abstract_type = /obj/item/clothing/head/helmet/quantum
	name = "quantum mechanic's helmet"
	desc = "A quantum mechanic's helmet. There is a letter on front that reads 'Q'."
	icon = 'mods/quantum_mechanic/uniform_quantum.dmi'
	item_icons = list(
		slot_head_str = 'mods/quantum_mechanic/uniform_quantum.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"

/obj/item/clothing/head/helmet/quantum/get_icon_state(mob/user_mob, slot)
	return item_state_slots[slot]


/obj/item/clothing/head/helmet/quantum/helmet
	name = "quantum mechanic's helmet"
	desc = "A quantum mechanic's helmet. There is a letter on front that reads 'Q'."
	icon_state = "chron_helmet_item"

	item_state_slots = list(
		slot_l_hand_str = "quantum_held_l",
		slot_r_hand_str = "quantum_held_r",
		slot_head_str = "chron_helmet"
	)

	body_parts_covered = FULL_HEAD


// Suit
/obj/item/clothing/under/quantum
	abstract_type = /obj/item/clothing/under/quantum
	name = "base quantum uniform"
	desc = "You should not see this."
	icon = 'mods/quantum_mechanic/uniform_quantum.dmi'
	item_icons = list(
		slot_w_uniform_str = 'mods/quantum_mechanic/uniform_quantum.dmi'
	)
	sprite_sheets = list()
	icon_state = "error"
	body_parts_covered = FULL_TORSO | ARMS | FULL_LEGS
	cold_protection = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	sensor_mode = SUIT_SENSOR_OFF
	has_sensor = FALSE
	siemens_coefficient = 0

/obj/item/clothing/under/quantum/get_icon_state(mob/user_mob, slot)
	return item_state_slots[slot]

/obj/item/clothing/under/quantum/suit
	name = "quantum mechanic's uniform"
	desc = "A quantum mechanic's uniform. There is a letter on front that reads 'Q'."
	icon_state = "quantum"
	item_state_slots = list(
		slot_l_hand_str = "quantum_held_l",
		slot_r_hand_str = "quantum_held_r",
		slot_w_uniform_str = "quantum_worn"
	)

/obj/item/clothing/under/color/quantum/suit/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// Gloves
/obj/item/clothing/gloves/white/quantum
	name = "quantum mechanic's gloves"
	desc = "A pair of modified gloves. The letter 'Ω' is stamped on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0

/obj/item/clothing/gloves/white/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// Sunglasses
/obj/item/clothing/glasses/sunglasses/quantum
	name = "quantum mechanic's glasses"
	desc = "A pair of modified sunglasses. The letter 'Ω' is stamped on the side."
	vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/glasses/sunglasses/quantum/verb/toggle_xray(mode in list("X-Ray without Lighting", "X-Ray with Lighting", "Normal"))
	set name = "Change Vision Mode"
	set desc = "Changes your glasses vision mode."
	set category = "Ω"
	set src in usr

	switch (mode)
		if ("X-Ray without Lighting")
			vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
			see_invisible = SEE_INVISIBLE_NOLIGHTING
		if ("X-Ray with Lighting")
			vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
			see_invisible = -1
		if ("Normal")
			vision_flags = 0
			see_invisible = -1

	to_chat(usr, SPAN_NOTICE("\The [src]'s vision mode is now <b>[mode]</b>."))

/obj/item/clothing/glasses/sunglasses/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// Shoes
/obj/item/clothing/shoes/black/quantum
	name = "quantum mechanic's shoes"
	desc = "A pair of black shoes with extra grip. The letter 'Ω' is stamped on the side."
	item_flags = ITEM_FLAG_NOSLIP

/obj/item/clothing/shoes/black/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// ID
/obj/item/card/id/quantum
	desc = "ID-карта прямиком из Департамента пространственно-временных аномалий. На вид очень секретная."

/obj/item/card/id/quantum/Initialize()
	. = ..()
	access = get_all_accesses() | get_all_centcom_access() | get_all_syndicate_access()

/obj/item/card/id/quantum/attack_hand(mob/user)
	if(!user)
		return TRUE

	if(!istype(user, /mob/living/carbon/human/quantum))
		to_chat(user, SPAN_WARNING("Your hand seems to go right through \the [src]. It's like it doesn't exist."))
		return TRUE

	return ..()

// Belt
/obj/item/storage/belt/utility/full/quantum/Initialize()
	. = ..()
	// Full set of tools
	new /obj/item/device/multitool(src)

/mob/living/carbon/human/quantum/restrained()
	return FALSE

/mob/living/carbon/human/quantum/can_fall()
	return fall_override ? FALSE : ..()
