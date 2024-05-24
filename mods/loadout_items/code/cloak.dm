/obj/item/clothing/accessory/cloak
	name = "cloak"
	desc = "A cloak."
	icon = 'mods/loadout_items/icons/obj_accessory.dmi'
	icon_state = "colorcloak"

	accessory_icons = list(
		slot_w_uniform_str = 'mods/loadout_items/icons/onmob_accessory.dmi', \
		slot_tie_str = 'mods/loadout_items/icons/onmob_accessory.dmi', \
		slot_wear_suit_str = 'mods/loadout_items/icons/onmob_accessory.dmi')
	item_icons = list(
		slot_wear_suit_str = 'mods/loadout_items/icons/onmob_accessory.dmi')

	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_accessory.dmi',
		SPECIES_NABBER = 'mods/loadout_items/icons/onmob_accessory.dmi'
	)

	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/oxygen_emergency)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY

	species_restricted = null
	valid_accessory_slots = null

/obj/item/clothing/accessory/cloak/colorable
	name = "blank cloak"
	desc = "A simple, bland cloak."
	icon_state = "colorcloak"

/obj/item/clothing/accessory/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"

/obj/item/clothing/accessory/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"

/obj/item/clothing/accessory/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"

/obj/item/clothing/accessory/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"

/obj/item/clothing/accessory/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"

/obj/item/clothing/accessory/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon_state = "hoscloak"

/obj/item/clothing/accessory/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the colony director."
	icon_state = "capcloak"

/obj/item/clothing/accessory/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cargocloak"

/obj/item/clothing/accessory/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "miningcloak"

/obj/item/clothing/accessory/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "seccloak"

/obj/item/clothing/accessory/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "servicecloak"

/obj/item/clothing/accessory/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "engicloak"

/obj/item/clothing/accessory/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "atmoscloak"

/obj/item/clothing/accessory/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "scicloak"

/obj/item/clothing/accessory/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "medcloak"

/obj/item/clothing/accessory/cloak/antiq
	name = "antiquated cape"
	desc = "This cape is so much aged that you can almost think it's a relic."
	icon_state = "antiquated_cape"

/obj/item/clothing/accessory/cloak/zpci
	name = "ZPCI cloak"
	desc = "A formal cape of a ZPCI operative, used as part of the Order's parade uniform. Usually worn on one shoulder."
	icon_state = "zpci_cloak"
	slot = ACCESSORY_SLOT_INSIGNIA
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_accessory_unathi.dmi'
	)


/obj/item/clothing/accessory/cloak/hooded
	var/obj/item/clothing/head/hood
	var/hoodtype = null
	var/suittoggled = 0
	name = "Crimson Fleece"
	desc = "A huge crimson cloak. Its outer shell is made of heavy and durable tarp-like material, and the inner shell is made of very warm and comfortable fleece."
	icon_state = "crimson_cloak"
	item_state = "crimson_cloak"
	action_button_name = "Toggle Hood"
	hoodtype = /obj/item/clothing/head/cloak_hood

/obj/item/clothing/accessory/cloak/hooded/New()
	MakeHood()
	..()

/obj/item/clothing/accessory/cloak/hooded/Destroy()
	QDEL_NULL(hood)
	return ..()

/obj/item/clothing/accessory/cloak/hooded/proc/MakeHood()
	if(!hood)
		hood = new hoodtype(src)

/obj/item/clothing/accessory/cloak/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/accessory/cloak/hooded/equipped(mob/user, slot)
	if((slot != slot_w_uniform) && (slot != slot_tie))
		RemoveHood()
	..()

/obj/item/clothing/accessory/cloak/hooded/proc/RemoveHood()
	if(!hood)
		return
	suittoggled = 0
	update_icon()
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.drop_from_inventory(hood)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/accessory/cloak/hooded/dropped()
	RemoveHood()

/obj/item/clothing/accessory/cloak/hooded/proc/ToggleHood()
	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				FEEDBACK_FAILURE(H, "You must be wearing \the [src] to put up the hood!")
				return
			if(H.head)
				FEEDBACK_FAILURE(H, "You're already wearing something on your head!")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
				hood.icon_state = "[icon_state]_hood"
				hood.item_state = "[item_state]_hood"
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/accessory/cloak/hooded/on_update_icon()
	if(suittoggled)
		icon_state = "[initial(icon_state)]_t"
	else
		icon_state = "[initial(icon_state)]"


/obj/item/clothing/head/cloak_hood
	name = "crimson hood"
	desc = "A hood."
	icon = 'maps/sierra/icons/mob/onmob/onmob_head.dmi'
	item_icons = list(slot_head_str = 'maps/sierra/icons/mob/onmob/onmob_head.dmi')
	icon_state = "crimson_cloak_hood"
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD

//Aurora stuff

/obj/item/clothing/accessory/cloak/dominia/red
	name = "Avalon grand mantle"
	desc = "A heavy cape, found usually upon shoulders of the richest - and most conceited - among the Avalonian nobles."
	icon = 'mods/loadout_items/icons/obj_accessory.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'mods/loadout_items/icons/onmob_accessory.dmi', \
		slot_tie_str = 'mods/loadout_items/icons/onmob_accessory.dmi', \
		slot_wear_suit_str = 'mods/loadout_items/icons/onmob_accessory.dmi')
	item_icons = list(
		slot_wear_suit_str = 'mods/loadout_items/icons/onmob_accessory.dmi')
	icon_state = "dominian_cape_red"
	item_state = "dominian_cape_red"
	overlay_state = "dominian_cape_red"
	slot = ACCESSORY_SLOT_INSIGNIA
	icon_override = null
	var/rolled = FALSE

/obj/item/clothing/accessory/cloak/dominia/red/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_suit()
	get_mob_overlay(TRUE)
	get_inv_overlay(TRUE)

/obj/item/clothing/accessory/cloak/dominia/red/verb/roll_up_mantle()
	set name = "Roll Up Cape Mantle"
	set desc = "Roll up your cape's mantle."
	set category = "Object"
	set src in usr

	var/list/icon_states = icon_states(icon)
	var/initial_state = initial(icon_state)
	var/new_state = "[initial_state]_h"
	if(!(new_state in icon_states))
		to_chat(usr, SPAN_WARNING("Your cape doesn't allow this!"))
		return

	rolled = !rolled
	to_chat(usr, SPAN_NOTICE("You roll your cape's mantle [rolled ? "up" : "down"]."))
	icon_state = rolled ? new_state : initial_state
	item_state = rolled ? new_state : initial_state
	overlay_state = rolled ? new_state : initial_state
	update_icon()
	update_clothing_icon()
