/datum/extension/chameleon
	base_type = /datum/extension/chameleon
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	var/static/list/chameleon_choices_by_type
	var/chameleon_choices
	var/atom/atom_holder
	var/static/chameleon_verbs = list(
		/obj/item/proc/ChameleonFlexibleAppearance,
		/obj/item/proc/ChameleonOutfitAppearanceSingle,
		/obj/item/proc/ChameleonOutfitAppearanceAll)

/datum/extension/chameleon/New(datum/holder, base_type)
	..()

	if (!chameleon_choices)
		var/chameleon_type = base_type || holder.parent_type
		chameleon_choices = LAZYACCESS(chameleon_choices_by_type, chameleon_type)
		if (!chameleon_choices)
			chameleon_choices = GenerateChameleonChoices(chameleon_type)

	atom_holder = holder
	atom_holder.verbs += chameleon_verbs

/datum/extension/chameleon/Destroy()
	. = ..()
	atom_holder.verbs -= chameleon_verbs
	atom_holder = null

/datum/extension/chameleon/proc/Disguise(newtype, mob/user, newname, newdesc)
	SHOULD_NOT_OVERRIDE(TRUE) // Subtypes should override OnDisguise

	var/obj/item/copy = new newtype(null) // initial() does not handle lists well
	var/obj/item/C = atom_holder
	C.name = newname || copy.name
	C.desc = newdesc || copy.desc
	C.icon = copy.icon
	C.color = copy.color
	C.icon_state = copy.icon_state
	C.flags_inv = copy.flags_inv
	C.item_state = copy.item_state
	C.body_parts_covered = copy.body_parts_covered

	C.item_icons = copy.item_icons
	C.item_state_slots = copy.item_state_slots
	C.sprite_sheets = copy.sprite_sheets

	OnDisguise(user, holder, copy)
	qdel(copy)

/datum/extension/chameleon/proc/OnDisguise(mob/user, obj/item/holder, obj/item/copy)
	return

/datum/extension/chameleon/proc/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	return null

/datum/extension/chameleon/proc/GenerateChameleonChoices(basetype)
	var/choices = list()
	var/types = islist(basetype) ? basetype : typesof(basetype)
	for (var/path in types)
		AddChameleonChoice(choices, path)
	return sortAssoc(choices)

/datum/extension/chameleon/proc/AddChameleonChoice(list/target, path)
	var/obj/item/I = path
	if (initial(I.icon) && initial(I.icon_state) && !(initial(I.item_flags) & ITEM_FLAG_INVALID_FOR_CHAMELEON))
		var/name = initial(I.name)
		if (target[name])
			name += " ([initial(I.icon_state)])"
		if (target[name])
			var/snowflake = 1
			while (target["[name] [snowflake]"])
				++snowflake
			target["[name] [snowflake]"] = path
		else
			target[name] = path

/**
 * Verbs to handle changing the appearance of atoms that have the chameleon extension.
 */
/obj/item/proc/ChameleonFlexibleAppearance()
	set name = "Change Appearance - Flexible"
	set desc = "Activate the holographic appearance changing module."
	set category = "Object"

	if (!CanPhysicallyInteractWith(usr, src))
		return

	var/datum/extension/chameleon/C = get_extension(src, /datum/extension/chameleon)
	if (C)
		C.ChangeGeneral(usr)
	else
		src.verbs -= C.chameleon_verbs

/datum/extension/chameleon/proc/ChangeGeneral(mob/user)
	var/choice = input(user, "Select a new appearance", "Select appearance") as null|anything in chameleon_choices
	if (!choice)
		return

	var/newname = input(user, "Choose a new name, or leave blank to use the default", "Choose item name") as null|text
	var/newdesc = input(user, "Choose a new description, or leave blank to use the default", "Choose item description") as null|text
	if(!CanPhysicallyInteractWith(user, holder))
		to_chat(user, SPAN_WARNING("You can't reach \the [holder]."))
		return
	Disguise(chameleon_choices[choice], user, newname, newdesc)

/obj/item/proc/ChameleonOutfitAppearanceSingle()
	set name = "Change Appearance - Outfit (Single)"
	set desc = "Activate the holographic appearance changing module."
	set category = "Object"

	if (!CanPhysicallyInteractWith(usr, src))
		return

	var/datum/extension/chameleon/C = get_extension(src, /datum/extension/chameleon)
	if (C)
		C.ChangeOutfitSingle(usr)
	else
		src.verbs -= C.chameleon_verbs

/datum/extension/chameleon/proc/ChangeOutfitSingle(mob/user)
	var/choice = input(user, "Select a new appearance for the selected chameleon item", "Select appearance") as null|anything in outfits()
	if (!choice)
		return
	if(!CanPhysicallyInteractWith(user, holder))
		to_chat(user, SPAN_WARNING("You can't reach \the [holder]."))
		return
	SetOutfitAppearance(user, list(src), choice)

/obj/item/proc/ChameleonOutfitAppearanceAll()
	set name = "Change Appearance - Outfit (All)"
	set desc = "Activate the holographic appearance changing module."
	set category = "Object"

	if (!CanPhysicallyInteractWith(usr, src))
		return

	var/datum/extension/chameleon/C = get_extension(src, /datum/extension/chameleon)
	if (C)
		C.ChangeOutfitAll(usr)
	else
		src.verbs -= C.chameleon_verbs

/datum/extension/chameleon/proc/ChangeOutfitAll(mob/user)
	var/choice = input(usr, "Select a new appearance for the selected chameleon item", "Select appearance") as null|anything in outfits()
	if (!choice)
		return
	if(!CanPhysicallyInteractWith(user, holder))
		to_chat(usr, SPAN_WARNING("You can't reach \the [holder]."))
		return

	var/list/extensions = list()
	for (var/obj/item/I as anything in user.get_equipped_items(TRUE))
		var/extension = get_extension(I, /datum/extension/chameleon)
		if (extension)
			extensions += extension
	extensions |= src
	SetOutfitAppearance(user, extensions, choice)

/datum/extension/chameleon/proc/SetOutfitAppearance(mob/user, list/chameleon_extensions, singleton/hierarchy/outfit/outfit)
	for (var/datum/extension/chameleon/chameleon_extension as anything in chameleon_extensions)
		var/outfit_type = chameleon_extension.GetItemDisguiseType(outfit)
		if (outfit_type)
			to_chat(user, SPAN_NOTICE("The outfit '[outfit]' appearance was applied to \the [chameleon_extension.holder]."));
			chameleon_extension.Disguise(outfit_type)
		else
			to_chat(user, SPAN_WARNING("The outfit '[outfit]' had no suitable appearance for \the [chameleon_extension.holder]."));

/********************
* Subtype overrides *
********************/
/datum/extension/chameleon/backpack
	expected_type = /obj/item/storage/backpack

/datum/extension/chameleon/backpack/OnDisguise(obj/item/storage/backpack/holder, obj/item/copy)
	if (ismob(holder.loc))
		var/mob/M = holder.loc
		M.update_inv_back()

/datum/extension/chameleon/backpack/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	return outfit.back

/datum/extension/chameleon/clothing
	expected_type = /obj/item/clothing

/datum/extension/chameleon/clothing/OnDisguise(mob/user, obj/item/clothing/holder, obj/item/copy)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if (istype(holder))
		holder.update_clothing_icon()

/datum/extension/chameleon/clothing/accessory
	expected_type = /obj/item/clothing/accessory

/datum/extension/chameleon/clothing/accessory/OnDisguise(mob/user, obj/item/clothing/accessory/holder, obj/item/clothing/accessory/copy)
	holder.slot = copy.slot
	holder.parent = copy.parent
	holder.inv_overlay = copy.inv_overlay
	holder.mob_overlay = copy.mob_overlay
	holder.overlay_state = copy.overlay_state
	holder.accessory_icons = copy.accessory_icons
	holder.on_rolled_down = copy.on_rolled_down
	holder.on_rolled_sleeves = copy.on_rolled_sleeves
	holder.accessory_flags = copy.accessory_flags
	..()

/datum/extension/chameleon/clothing/glasses
	expected_type = /obj/item/clothing/glasses

/datum/extension/chameleon/clothing/glasses/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.glasses, expected_type))
		return outfit.glasses

/datum/extension/chameleon/clothing/gloves
	expected_type = /obj/item/clothing/gloves

/datum/extension/chameleon/clothing/gloves/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.gloves, expected_type))
		return outfit.gloves

/datum/extension/chameleon/clothing/head
	expected_type = /obj/item/clothing/head

/datum/extension/chameleon/clothing/head/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.head, expected_type))
		return outfit.head

/datum/extension/chameleon/clothing/mask
	expected_type = /obj/item/clothing/mask

/datum/extension/chameleon/clothing/mask/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.mask, expected_type))
		return outfit.mask

/datum/extension/chameleon/clothing/shoes
	expected_type = /obj/item/clothing/shoes

/datum/extension/chameleon/clothing/shoes/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	..()
	if (ispath(outfit.shoes, expected_type))
		return outfit.shoes

/datum/extension/chameleon/clothing/suit
	expected_type = /obj/item/clothing/suit

/datum/extension/chameleon/clothing/suit/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.suit, expected_type))
		return outfit.suit

/datum/extension/chameleon/clothing/under
	expected_type = /obj/item/clothing/under

/datum/extension/chameleon/clothing/under/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.uniform, expected_type))
		return outfit.uniform

/datum/extension/chameleon/emag
	expected_type = /obj/item/card
	chameleon_choices = list(
		/obj/item/card/emag,
		/obj/item/card/union,
		/obj/item/card/data,
		/obj/item/card/data/full_color,
		/obj/item/card/data/disk,
		/obj/item/card/id
	)

/datum/extension/chameleon/emag/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (length(outfit.id_types) > 0)
		var/id_path = outfit.id_types[0]
		if (ispath(id_path, expected_type))
			return id_path

/datum/extension/chameleon/gun
	expected_type = /obj/item/gun

/datum/extension/chameleon/gun/OnDisguise(mob/user, obj/item/gun/holder, obj/item/gun/copy)
	holder.flags_inv = copy.flags_inv
	holder.fire_sound = copy.fire_sound
	holder.fire_sound_text = copy.fire_sound_text

	if (ismob(holder.loc))
		var/mob/M = holder.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/datum/extension/chameleon/headset
	expected_type = /obj/item/device/radio/headset

/datum/extension/chameleon/headset/OnDisguise(mob/user, obj/item/holder, obj/item/copy)
	if (ismob(holder.loc))
		var/mob/M = holder.loc
		M.update_inv_ears()

/datum/extension/chameleon/headset/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.l_ear, expected_type))
		return outfit.l_ear
	if (ispath(outfit.r_ear, expected_type))
		return outfit.r_ear
