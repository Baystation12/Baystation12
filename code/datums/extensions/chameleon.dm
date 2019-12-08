/datum/extension/chameleon
	base_type = /datum/extension/chameleon
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/chameleon_choices
	var/static/list/chameleon_choices_by_type
	var/atom/atom_holder
	var/chameleon_type = null //if we want an item to have chameleon changes not of its parent_type or base_type
	var/chameleon_verb

/datum/extension/chameleon/New(datum/holder, base_type)
	..()

	if(!chameleon_choices)
		var/chameleon_type = base_type || holder.parent_type
		chameleon_choices = LAZYACCESS(chameleon_choices_by_type, chameleon_type)
		if(!chameleon_choices)
			chameleon_choices = generate_chameleon_choices(chameleon_type)
			LAZYSET(chameleon_choices_by_type, chameleon_type, chameleon_choices)	

	atom_holder = holder
	chameleon_verb += new/atom/proc/chameleon_appearance(atom_holder,"Change [atom_holder.name] Appearance")

/datum/extension/chameleon/Destroy()
	. = ..()
	atom_holder.verbs -= chameleon_verb
	atom_holder = null

/datum/extension/chameleon/proc/disguise(var/newtype, var/mob/user)
	//this is necessary, unfortunately, as initial() does not play well with list vars
	var/obj/item/copy = new newtype(null)
	var/obj/item/C = atom_holder

	C.name = copy.name
	C.desc = copy.desc
	C.icon = copy.icon
	C.color = copy.color
	C.icon_state = copy.icon_state
	C.flags_inv = copy.flags_inv
	C.item_state = copy.item_state
	C.body_parts_covered = copy.body_parts_covered

	if(copy.item_icons)
		C.item_icons = copy.item_icons.Copy()
	if(copy.item_state_slots)
		C.item_state_slots = copy.item_state_slots.Copy()
	if(copy.sprite_sheets)
		C.sprite_sheets = copy.sprite_sheets.Copy()

	OnDisguise(copy)
	qdel(copy)

/datum/extension/chameleon/proc/OnDisguise(var/obj/item/copy)

/datum/extension/chameleon/clothing
	expected_type = /obj/item/clothing

/datum/extension/chameleon/clothing/accessory
	expected_type = /obj/item/clothing/accessory

/datum/extension/chameleon/clothing/accessory/OnDisguise(var/obj/item/clothing/accessory/copy)
	..()
	var/obj/item/clothing/accessory/A = holder

	A.slot = copy.slot
	A.has_suit = copy.has_suit
	A.inv_overlay = copy.inv_overlay
	A.mob_overlay = copy.mob_overlay
	A.overlay_state = copy.overlay_state
	A.accessory_icons = copy.accessory_icons
	A.on_rolled = copy.on_rolled
	A.high_visibility = copy.high_visibility

/datum/extension/chameleon/proc/generate_chameleon_choices(var/basetype)
	. = list()

	var/types = islist(basetype) ? basetype : typesof(basetype)
	var/i = 1 //in case there is a collision with both name AND icon_state
	for(var/typepath in types)
		var/obj/item/I = typepath
		if(initial(I.icon) && initial(I.icon_state) && !(initial(I.item_flags) & ITEM_FLAG_INVALID_FOR_CHAMELEON))
			var/name = initial(I.name)
			if(name in .)
				name += " ([initial(I.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath
	return sortAssoc(.)

/atom/proc/chameleon_appearance()
	set name = "Change Appearance"
	set desc = "Activate the holographic appearance changing module."
	set category = "Chameleon Items"

	if(!CanPhysicallyInteract(usr))
		return
	if(has_extension(src,/datum/extension/chameleon))
		var/datum/extension/chameleon/C = get_extension(src, /datum/extension/chameleon)
		C.change(usr)
	else
		src.verbs -= /atom/proc/chameleon_appearance

/datum/extension/chameleon/proc/change(mob/user)
	var/choice = input(user, "Select a new appearance", "Select appearance") as null|anything in chameleon_choices
	if(choice)
		disguise(chameleon_choices[choice], user)
		OnChange(user,holder)

/datum/extension/chameleon/proc/OnChange(mob/user, var/obj/item/clothing/C) //contains icon updates
	if(istype(C))
		C.update_clothing_icon()

/datum/extension/chameleon/backpack
	expected_type = /obj/item/weapon/storage/backpack

/datum/extension/chameleon/backpack/OnChange(mob/user,var/obj/item/weapon/storage/backpack/C)
	if(ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_back()

/datum/extension/chameleon/headset
	expected_type = /obj/item/device/radio/headset

/datum/extension/chameleon/headset/OnChange(mob/user,var/obj/item/device/radio/headset/C)
	if(ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_ears()

/datum/extension/chameleon/gun
	expected_type = /obj/item/weapon/gun
	var/obj/item/projectile/copy_projectile = null

/datum/extension/chameleon/gun/OnChange(mob/user,var/obj/item/weapon/gun/C)
	if(ismob(C.loc))
		var/mob/M = C.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/datum/extension/chameleon/gun/proc/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.SetName(initial(copy_projectile.name))
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/datum/extension/chameleon/gun/OnDisguise(var/obj/item/weapon/gun/copy)
	var/obj/item/weapon/gun/G = src

	G.flags_inv = copy.flags_inv
	G.fire_sound = copy.fire_sound
	G.fire_sound_text = copy.fire_sound_text
	G.icon = copy.icon

	var/obj/item/weapon/gun/energy/E = copy
	if(istype(E))
		copy_projectile = E.projectile_type
	else
		copy_projectile = null

/datum/extension/chameleon/emag
	expected_type = /obj/item/weapon/card
	chameleon_choices = list(
							/obj/item/weapon/card/emag,
							/obj/item/weapon/card/union,
							/obj/item/weapon/card/data,
							/obj/item/weapon/card/data/full_color,
							/obj/item/weapon/card/data/disk,
							/obj/item/weapon/card/id,
						) //Should be enough of a selection for most purposes

/datum/extension/chameleon/emag/proc/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_DEVICES,SKILL_ADEPT))
		to_chat(user, SPAN_WARNING("This ID card has some form of non-standard modifications."))