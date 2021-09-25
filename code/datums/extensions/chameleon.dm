/datum/extension/chameleon
	base_type = /datum/extension/chameleon
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/chameleon_choices
	var/static/list/chameleon_choices_by_type
	var/atom/atom_holder
	var/chameleon_verb

/datum/extension/chameleon/New(datum/holder, base_type)
	..()

	if (!chameleon_choices)
		var/chameleon_type = base_type || holder.parent_type
		chameleon_choices = LAZYACCESS(chameleon_choices_by_type, chameleon_type)
		if(!chameleon_choices)
			chameleon_choices = generate_chameleon_choices(chameleon_type)
			LAZYSET(chameleon_choices_by_type, chameleon_type, chameleon_choices)	
	else
		var/list/choices = list()
		for(var/path in chameleon_choices)
			add_chameleon_choice(choices, path)
		chameleon_choices = sortAssoc(choices)

	atom_holder = holder
	chameleon_verb += new/atom/proc/chameleon_appearance(atom_holder,"Change [atom_holder.name] Appearance")

/datum/extension/chameleon/Destroy()
	. = ..()
	atom_holder.verbs -= chameleon_verb
	atom_holder = null

/datum/extension/chameleon/proc/disguise(newtype, mob/user)
	var/obj/item/copy = new newtype(null) //initial() does not handle lists well
	var/obj/item/C = atom_holder

	C.name = copy.name
	C.desc = copy.desc
	C.icon = copy.icon
	C.color = copy.color
	C.icon_state = copy.icon_state
	C.flags_inv = copy.flags_inv
	C.item_state = copy.item_state
	C.body_parts_covered = copy.body_parts_covered

	if (copy.item_icons)
		C.item_icons = copy.item_icons.Copy()
	if (copy.item_state_slots)
		C.item_state_slots = copy.item_state_slots.Copy()
	if (copy.sprite_sheets)
		C.sprite_sheets = copy.sprite_sheets.Copy()

	OnDisguise(copy)
	qdel(copy)

/datum/extension/chameleon/proc/OnDisguise(obj/item/copy)

/datum/extension/chameleon/clothing
	expected_type = /obj/item/clothing

/datum/extension/chameleon/clothing/accessory
	expected_type = /obj/item/clothing/accessory

/datum/extension/chameleon/clothing/accessory/OnDisguise(obj/item/clothing/accessory/copy)
	..()
	var/obj/item/clothing/accessory/A = holder

	A.slot = copy.slot
	A.parent = copy.parent
	A.inv_overlay = copy.inv_overlay
	A.mob_overlay = copy.mob_overlay
	A.overlay_state = copy.overlay_state
	A.accessory_icons = copy.accessory_icons
	A.on_rolled = copy.on_rolled
	A.accessory_flags = copy.accessory_flags

/datum/extension/chameleon/proc/add_chameleon_choice(list/target, path)
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

/datum/extension/chameleon/proc/generate_chameleon_choices(basetype)
	var/choices = list()
	var/types = islist(basetype) ? basetype : typesof(basetype)
	for (var/path in types)
		add_chameleon_choice(choices, path)
	return sortAssoc(choices)

/atom/proc/chameleon_appearance()
	set name = "Change Appearance"
	set desc = "Activate the holographic appearance changing module."
	set category = "Object"

	if (!CanPhysicallyInteract(usr))
		return
	if (has_extension(src,/datum/extension/chameleon))
		var/datum/extension/chameleon/C = get_extension(src, /datum/extension/chameleon)
		C.change(usr)
	else
		src.verbs -= /atom/proc/chameleon_appearance

/datum/extension/chameleon/proc/change(mob/user)
	var/choice = input(user, "Select a new appearance", "Select appearance") as null|anything in chameleon_choices
	if (choice)
		if (QDELETED(user) || QDELETED(holder))
			return
		if(user.incapacitated() || !(holder in user))
			to_chat(user, SPAN_WARNING("You can't reach \the [holder]."))
			return
		disguise(chameleon_choices[choice], user)
		OnChange(user,holder)

/datum/extension/chameleon/proc/OnChange(mob/user, obj/item/clothing/C) //contains icon updates
	if (istype(C))
		C.update_clothing_icon()

/datum/extension/chameleon/backpack
	expected_type = /obj/item/storage/backpack

/datum/extension/chameleon/backpack/OnChange(mob/user, obj/item/storage/backpack/C)
	if (ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_back()

/datum/extension/chameleon/headset
	expected_type = /obj/item/device/radio/headset

/datum/extension/chameleon/headset/OnChange(mob/user, obj/item/device/radio/headset/C)
	if (ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_ears()

/datum/extension/chameleon/gun
	expected_type = /obj/item/gun

/datum/extension/chameleon/gun/OnChange(mob/user, obj/item/gun/C)
	if (ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/datum/extension/chameleon/gun/OnDisguise(obj/item/gun/copy)
	var/obj/item/gun/G = atom_holder

	G.flags_inv = copy.flags_inv
	G.fire_sound = copy.fire_sound
	G.fire_sound_text = copy.fire_sound_text
	G.icon = copy.icon

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
