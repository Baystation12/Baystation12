/datum/extension/holster
	base_type = /datum/extension/holster
	var/atom/atom_holder
	var/obj/item/storage/storage
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'
	var/list/can_holster = null
	var/obj/item/holstered = null

/datum/extension/holster/New(holder, storage, sound_in, sound_out, can_holster)
	..()
	atom_holder = holder
	src.storage = storage
	src.sound_in = sound_in || src.sound_in
	src.sound_out = sound_out || src.sound_out
	src.can_holster = can_holster

/datum/extension/holster/proc/can_holster(obj/item/I)
	if(can_holster)
		if(is_type_in_list(I,can_holster))
			return 1
		return 0
	if(I.slot_flags & SLOT_HOLSTER)
		return 1
	return 0

/datum/extension/holster/proc/holster(obj/item/I, mob/living/user)
	if(!storage)
		return 1
	if(!holstered && storage.storage_slots != null && length(storage.contents) >= storage.storage_slots - 1)
		if(!can_holster(I))
			to_chat(user, SPAN_NOTICE("\The [I] won't fit in \the [atom_holder]'s holster!."))
			return 1
	if(can_holster(I))
		if(holstered && istype(user))
			to_chat(user, SPAN_WARNING("There is already \a [holstered] holstered here!"))
			return 1
		if(sound_in)
			playsound(get_turf(atom_holder), sound_in, 50)
		if(istype(user))
			user.stop_aiming(no_message=1)
		if(istype(I, /obj/item/gun))
			var/obj/item/gun/G = I
			G.check_accidents(user)
			if(user.a_intent == I_HELP && G.has_safety && !G.safety_state && user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
				G.toggle_safety(user)
		holstered = I
		storage.handle_item_insertion(holstered, 1)
		holstered.add_fingerprint(user)
		storage.w_class = max(storage.w_class, holstered.w_class)
		user.visible_message(SPAN_NOTICE("\The [user] holsters \the [holstered]."), SPAN_NOTICE("You holster \the [holstered]."))
		atom_holder.SetName("occupied [initial(atom_holder.name)]")
		atom_holder.update_icon()
		GLOB.moved_event.register(holstered, src, PROC_REF(check_holster))
		GLOB.destroyed_event.register(holstered, src, PROC_REF(clear_holster))
		return 1
	return 0

/datum/extension/holster/proc/clear_holster()
	GLOB.moved_event.unregister(holstered, src, PROC_REF(check_holster))
	GLOB.destroyed_event.unregister(holstered, src, PROC_REF(clear_holster))
	holstered = null
	atom_holder.SetName(initial(atom_holder.name))

/datum/extension/holster/proc/unholster(mob/user as mob, avoid_intent = FALSE)
	if(!holstered)
		return 0
	if (!user.HasFreeHand())
		to_chat(user, SPAN_WARNING("You need an empty hand to draw \the [holstered]!"))
		return 0
	var/using_intent_preference = user.client ? user.client.get_preference_value(/datum/client_preference/holster_on_intent) == GLOB.PREF_YES : FALSE
	if(avoid_intent || (using_intent_preference && user.a_intent != I_HELP))
		var/sound_vol = 25
		if(user.a_intent == I_HURT)
			sound_vol = 50
			if(istype(holstered, /obj/item/gun))
				var/obj/item/gun/G = holstered
				G.check_accidents(user)
				if(G.safety() && user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED)) // Experienced shooter will disable safety before shooting.
					G.toggle_safety(user)
			usr.visible_message(
				SPAN_DANGER("\The [user] draws \the [holstered], ready to go!"),
				SPAN_WARNING("You draw \the [holstered], ready to go!")
				)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] draws \the [holstered], pointing it at the ground."),
				SPAN_NOTICE("You draw \the [holstered], pointing it at the ground.")
				)
		if(sound_out)
			playsound(get_turf(atom_holder), sound_out, sound_vol)
		holstered.add_fingerprint(user)
		holstered.queue_icon_update()
		user.put_in_hands(holstered)
		storage.w_class = initial(storage.w_class)
		atom_holder.update_icon()
		return 1
	return 0

/datum/extension/holster/proc/examine_holster(mob/user)
	if (holstered)
		to_chat(user, "\A [holstered] is holstered here.")
	else
		to_chat(user, "It is empty.")

/datum/extension/holster/proc/check_holster()
	if(holstered.loc != storage)
		clear_holster()

/**
 * Verb to handle quick-holstering an item in the mob's active hand, or retrieving an item from this atom's holster
 * extension.
 */
/mob/living/verb/holster_verb()
	set name = "Holster"
	set category = "Object"

	if(usr.incapacitated())
		return

	var/list/holsters = list()
	for (var/obj/item/item in contents)
		holsters += item.get_holsters()
		continue

	if (!length(holsters))
		return

	var/holster_name
	if (length(holsters) > 1)
		var/list/options = list()
		for (var/holster in holsters)
			var/datum/extension/holster/H = holsters[holster]
			var/atom/holder = H.atom_holder
			options[holster] = mutable_appearance(holder.icon, holder.icon_state)

		holster_name = show_radial_menu(usr, usr, options, tooltips = TRUE, use_labels = TRUE)

		if (!holster_name)
			return
	else
		holster_name = holsters[1]
	var/datum/extension/holster/H = holsters[holster_name]
	if (!H || !usr.use_sanity_check(H.atom_holder))
		return

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, SPAN_WARNING("You're not holding anything to holster."))
			return
		H.holster(W, usr)
	else
		H.unholster(usr, 1)

/**
 * Retrieves all holsters contained within the atom, including itself. Generally, this is any atom that has the
 * `/datum/extension/holster` extension.
 *
 * Returns associative list (name = instance of `/datum/extension/holster`)
 */
/atom/proc/get_holsters()
	. = list()
	if(has_extension(src, /datum/extension/holster))
		.[name] = get_extension(src, /datum/extension/holster)

/obj/item/clothing/under/get_holsters()
	. = ..()
	var/holster_accessories_by_name = list()
	for(var/obj/accessory in accessories)
		if(has_extension(accessory, /datum/extension/holster))
			group_by(holster_accessories_by_name , accessory.name, accessory)

	for(var/accessory_name in holster_accessories_by_name)
		var/list/holster_accessories = holster_accessories_by_name[accessory_name]
		if(length(holster_accessories) == 1)
			.[accessory_name] = get_extension(holster_accessories[1], /datum/extension/holster)
		else
			for(var/i = 1 to length(holster_accessories))
				var/holster_name = "[accessory_name] [i]"
				.[holster_name] = get_extension(holster_accessories[i], /datum/extension/holster)
