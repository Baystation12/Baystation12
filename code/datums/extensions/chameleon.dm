/datum/extension/chameleon
	base_type = /datum/extension/chameleon
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	var/emp_amount = 0
	var/static/list/chameleon_choices_by_type
	var/chameleon_choices
	var/obj/item/item_holder
	var/static/chameleon_verbs = list(
		/obj/item/proc/ChameleonFlexibleAppearance,
		/obj/item/proc/ChameleonOutfitAppearanceSingle,
		/obj/item/proc/ChameleonOutfitAppearanceAll)

/**
 * **Parameters**:
 * - `holder` - The instance which is granted the chameleon verbs.
 * - `chameleon_base_type` - The base type from which to generate the list of valid chameleon options. Defaults to the holder's `parent_type` if unset.
 * - `exclude_outfits` - Whether to exclude the chameleon outfit verbs.
 */
/datum/extension/chameleon/New(datum/holder, chameleon_base_type, exclude_outfits)
	..()

	if (!chameleon_choices)
		var/chameleon_type = chameleon_base_type || holder.parent_type
		chameleon_choices = LAZYACCESS(chameleon_choices_by_type, chameleon_type)

		if (!chameleon_choices)
			chameleon_choices = GenerateChameleonChoices(chameleon_type)
			LAZYSET(chameleon_choices_by_type, chameleon_type, chameleon_choices)

	item_holder = holder
	if (exclude_outfits)
		item_holder.verbs += /obj/item/proc/ChameleonFlexibleAppearance
	else
		item_holder.verbs += chameleon_verbs
	GLOB.empd_event.register(item_holder, src, /datum/extension/chameleon/proc/OnEMP)

/datum/extension/chameleon/Destroy()
	if (emp_amount)
		STOP_PROCESSING(SSobj, src)
	GLOB.empd_event.unregister(item_holder, src)
	item_holder.verbs -= chameleon_verbs // We don't complicate things, remove all the verbs every time no matter the initial setup
	item_holder = null
	return ..()

/datum/extension/chameleon/proc/Disguise(newtype, newname, newdesc)
	SHOULD_NOT_OVERRIDE(TRUE) // Subtypes should override OnDisguise

	var/obj/item/copy = new newtype(null) // initial() does not handle lists well
	item_holder.name = newname || copy.name
	item_holder.desc = newdesc || copy.desc
	item_holder.icon = copy.icon
	item_holder.color = copy.color
	item_holder.icon_state = copy.icon_state
	item_holder.flags_inv = copy.flags_inv
	item_holder.item_state = copy.item_state
	item_holder.body_parts_covered = copy.body_parts_covered

	item_holder.item_icons = copy.item_icons
	item_holder.item_state_slots = copy.item_state_slots
	item_holder.sprite_sheets = copy.sprite_sheets

	OnDisguise(item_holder, copy)
	qdel(copy)

/datum/extension/chameleon/proc/OnDisguise(obj/item/holder, obj/item/copy)
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

/datum/extension/chameleon/proc/OnEMP(holder, severity)
	if(!prob(50/severity))
		return

	if (emp_amount == 0)
		START_PROCESSING(SSobj, src)

	emp_amount += rand((30 SECONDS)/severity, (1 MINUTE)/severity)
	emp_amount = min(2 MINUTES, emp_amount) // Cap EMP duration to 2 minutes
	Malfunction()

/datum/extension/chameleon/Process(wait)
	var/trigger = FALSE
	// For each second, check if a malfunction is triggered
	for (var/i = 1 to ceil(wait / (1 SECOND)))
		// There's a (EMP seconds left / 2) probability of another malfunction triggering
		if (!trigger && prob(emp_amount / 2 / 1 SECOND))
			trigger = TRUE
			emp_amount -= 10 SECONDS // If a malfunction did trigger, we're kind and reduce the remaining time by 10 seconds
		else // Otherwise we only reduce it by 1 second
			emp_amount -= 1 SECOND

	if (trigger)
		Malfunction()

	if (emp_amount <= 0)
		emp_amount = 0
		STOP_PROCESSING(SSobj, src)

/datum/extension/chameleon/proc/Malfunction()
	playsound(item_holder.loc, "sparks", 75, 1, -1)
	Disguise(chameleon_choices[pick(chameleon_choices)])

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
	Disguise(chameleon_choices[choice], newname, newdesc)

/obj/item/proc/ChameleonOutfitAppearanceSingle()
	set name = "Change Appearance - Outfit (Selected Only)"
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
	set name = "Change Appearance - Outfit (All Equipped)"
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
	if (ispath(outfit.back, expected_type))
		return outfit.back
	for (var/potential_backpack_type in list_values(outfit.backpack_overrides))
		if (ispath(potential_backpack_type, expected_type))
			return potential_backpack_type

/datum/extension/chameleon/clothing
	expected_type = /obj/item/clothing

/datum/extension/chameleon/clothing/OnDisguise(obj/item/clothing/holder, obj/item/copy)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if (istype(holder))
		holder.update_clothing_icon()

/datum/extension/chameleon/clothing/accessory
	expected_type = /obj/item/clothing/accessory

/datum/extension/chameleon/clothing/accessory/OnDisguise(obj/item/clothing/accessory/holder, obj/item/clothing/accessory/copy)
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

/datum/extension/chameleon/gun/OnDisguise(obj/item/gun/holder, obj/item/gun/copy)
	holder.flags_inv = copy.flags_inv
	holder.fire_sound = copy.fire_sound
	holder.fire_sound_text = copy.fire_sound_text

	if (ismob(holder.loc))
		var/mob/M = holder.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/datum/extension/chameleon/headset
	expected_type = /obj/item/device/radio/headset

/datum/extension/chameleon/headset/OnDisguise(obj/item/holder, obj/item/copy)
	if (ismob(holder.loc))
		var/mob/M = holder.loc
		M.update_inv_ears()

/datum/extension/chameleon/headset/GetItemDisguiseType(singleton/hierarchy/outfit/outfit)
	if (ispath(outfit.l_ear, expected_type))
		return outfit.l_ear
	if (ispath(outfit.r_ear, expected_type))
		return outfit.r_ear

/// Grants the full set of chameleon selection options available to the extension.
var/global/const/CHAMELEON_FLEXIBLE_OPTIONS_EXTENSION = 1 // Not flags
/// Grants a (potential) subset of chameleon options available to the extension, based on the instance's `parent_type`. Falls back to `type` if not a valid type for the extension.
var/global/const/CHAMELEON_FLEXIBLE_OPTIONS_PARENT_TYPE   = 2
/// Grants a (potential) subset of chameleon options available to the extension, based on the instance's `type`.
var/global/const/CHAMELEON_FLEXIBLE_OPTIONS_TYPE          = 3

/**
 * Call this proc to automatically setup the best suited chameleon extension for the instance, if one exists.
 *
 * Exceptions:
 * - If the instance only matches the base /datum/extension/chameleon type it is not set for performance reasons. For these `set_extension()` has to be called explicitly.
 * - If the instance already has the /datum/extension/chameleon extension it is not overriden, but the proc still returns `TRUE`.
 *
 * **Parameters**:
 * - `chamelon_options` - Based on the relevant CHAMELEON_FLEXIBLE_OPTION_* argument
 * - `exclude_outfits` - Whether to exclude the chameleon outfit verbs.
 * - `throw_runtime` - Whether to throw a runtime exception if no matching extension was found. This includes cases when /datum/extension/chameleon would've been a match had it not been for its exclusion.
 *
 * Returns boolean - Whether or not a matching extension was found
 */
/obj/proc/SetupChameleonExtension(chamelon_options, exclude_outfits, throw_runtime)
	if (has_extension(src, /datum/extension/chameleon))
		return TRUE

	var/best_found_expected_type
	var/best_found_extension

	// Most items matching only /obj/item have a tendency to generate huge cache lists (and also lag spikes), hence the exclusion of the base extension type
	for (var/datum/extension/chameleon/chameleon_extension_type as anything in subtypesof(/datum/extension/chameleon))
		var/expected_type = initial(chameleon_extension_type.expected_type)

		if (istype(src, expected_type)) // If the type of src is a type expected by the extension then..
			// Check if the expected type is a better match than the previously found best expected type (if any)
			if (!best_found_expected_type || IS_SUBPATH(expected_type, best_found_expected_type))
				best_found_expected_type = expected_type
				best_found_extension = chameleon_extension_type

	var/chameleon_base_type
	switch (chamelon_options)
		if (CHAMELEON_FLEXIBLE_OPTIONS_EXTENSION) chameleon_base_type = best_found_expected_type
		if (CHAMELEON_FLEXIBLE_OPTIONS_PARENT_TYPE) chameleon_base_type = ispath(parent_type, best_found_expected_type) ? parent_type : type
		if (CHAMELEON_FLEXIBLE_OPTIONS_TYPE) chameleon_base_type = type
		else CRASH("Invalid chameleon flexible option: [chamelon_options]")

	if (best_found_extension)
		set_extension(src, best_found_extension, chameleon_base_type, exclude_outfits)
		return TRUE
	else if (throw_runtime)
		CRASH("The type [type] does not have a compatible chameleon extension.")
	return FALSE
