
#define KIT_ITEM_SPAWNS 0x1
#define KIT_ITEM_CONNECTS 0x2
#define KIT_ITEM_REMOVABLE 0x4


/obj/item/reagent_kit
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	icon = 'icons/obj/reagent_kit.dmi'
	var/spawn_reagents = 300
	var/obj/item/kit_item
	var/kit_flags

/obj/item/reagent_kit/Initialize()
	. = ..()
	if (type == /obj/item/reagent_kit)
		. = INITIALIZE_HINT_QDEL
		crash_with("base [type] created erroneously")
	if (islist(spawn_reagents))
		create_reagents(0, spawn_reagents)
	else
		create_reagents(spawn_reagents)
	if (kit_item && kit_flags & KIT_ITEM_SPAWNS)
		kit_item = new kit_item(src)
		if (kit_flags & KIT_ITEM_CONNECTS)
			START_PROCESSING(SSobj, src)
		update_icon()
	else
		kit_item = null

/obj/item/reagent_kit/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(kit_item)
	. = ..()

/obj/item/reagent_kit/examine(mob/user, distance)
	. = ..()
	if (distance < 5)
		if (kit_item)
			to_chat(user, "\An [kit_item] is [(kit_flags & KIT_ITEM_CONNECTS) ? "connected by a[(kit_flags & KIT_ITEM_REMOVABLE) ? " detachable" : " fixed"] hose" : "clipped to the side"].")
		if (distance < 2)
			var/fullness = PERCENT(reagents.total_volume, reagents.maximum_volume, 0)
			to_chat(user, "A gauge shows it is [fullness ? "about [fullness]% full" : "empty"].")

/obj/item/reagent_kit/on_update_icon()
	..()
	overlays.Cut()
	if (kit_item && (kit_item in src))
		var/image/I = image(kit_item.icon, icon_state = kit_item.icon_state)
		I.pixel_y = -8
		overlays += I

/obj/item/reagent_kit/Process()
	if (!kit_item)
		return PROCESS_KILL
	if (!Adjacent(kit_item) && !(kit_item in src))
		if (~kit_flags & KIT_ITEM_REMOVABLE)
			var/success = TRUE
			if (istype(kit_item.loc, /mob))
				var/mob/M = kit_item.loc
				success = M.unEquip(kit_item, src)
			else
				kit_item.forceMove(src)
			if (success)
				visible_message(SPAN_WARNING("\The [kit_item]'s connector reels it back to \the [src]!"), range = 5)
				update_icon()
				return
		visible_message(SPAN_WARNING("\The [kit_item]'s connector snaps away from \the [src]!"), range = 5)
		kit_item = null
		return PROCESS_KILL
	if (kit_flags & KIT_ITEM_CONNECTS)
		on_process()

/obj/item/reagent_kit/attackby(obj/item/I, mob/user)
	if (user.a_intent == I_GRAB && istype(I, initial(kit_item)))
		if (kit_item && I != kit_item)
			to_chat(user, SPAN_WARNING("\The [src] already has \an [kit_item] [(kit_flags & KIT_ITEM_CONNECTS) ? "connected" : "clipped on"]."))
		else
			var/message = disallow_item(I)
			if (message)
				to_chat(user, message)
			else if (user.unEquip(I, src))
				user.visible_message(SPAN_ITALIC("\The [user] [(kit_flags & KIT_ITEM_CONNECTS) ? "connects" : "clips"] \an [I] to \the [src]."))
				kit_item = I
				if (kit_flags & KIT_ITEM_CONNECTS)
					START_PROCESSING(SSobj, src)
				update_icon()
		return TRUE
	. = ..()

/obj/item/reagent_kit/attack_hand(mob/user)
	if (user.a_intent == I_GRAB)
		if (detach_item(user))
			return
	. = ..()

/obj/item/reagent_kit/attack_self(mob/user)
	detach_item(user)

/obj/item/reagent_kit/proc/detach_item(mob/user)
	if (!kit_item || !(kit_item in src))
		return FALSE
	if (!user)
		visible_message(SPAN_ITALIC("\The [kit_item] falls away from \the [src]."), range = 5)
		kit_item.dropInto(get_turf(src))
	else
		user.visible_message(SPAN_ITALIC("\The [user] tugs \the [kit_item] from \the [src]."), range = 5)
		user.put_in_hands(kit_item)
	update_icon()
	if (~kit_flags & KIT_ITEM_CONNECTS)
		kit_item = null
	return TRUE

/obj/item/reagent_kit/proc/on_process()
	return

/obj/item/reagent_kit/proc/disallow_item(obj/item/I)
	return


/obj/item/reagent_kit/chemsprayer
	name = "chem sprayer kit"
	icon_state = "welderpack"
	desc = "An unwieldy, heavy backpack with two massive tanks. Includes a connector for multi-purpose liquid sprayers."
	spawn_reagents = 600
	kit_item = /obj/item/weapon/reagent_containers/spray/chemsprayer
	kit_flags = KIT_ITEM_CONNECTS | KIT_ITEM_REMOVABLE

/obj/item/reagent_kit/chemsprayer/on_process()
	reagents.trans_to_holder(kit_item.reagents, 20)

/obj/item/reagent_kit/chemsprayer/attackby(obj/item/I, mob/user)
	. = ..()
	if (.)
		return
	else if (I.is_open_container() && I.reagents)
		if (!reagents.get_free_space())
			to_chat(user, SPAN_WARNING("\The [src] is already full."))
			return
		I.reagents.trans_to_holder(reagents, I.reagents.total_volume)
		visible_message(SPAN_ITALIC("\The [user] transfers some of \the [I] to \the [src]."), range = 5)


/obj/item/reagent_kit/extinguisher
	name = "firefighting kit"
	icon_state = "welderpack"
	desc = "An unwieldy, heavy backpack with two massive tanks. Includes a connector for fire extinguishers."
	spawn_reagents = list(/datum/reagent/water = 4000)
	kit_item = /obj/item/weapon/extinguisher
	kit_flags = KIT_ITEM_SPAWNS | KIT_ITEM_CONNECTS

/obj/item/reagent_kit/extinguisher/on_process()
	reagents.trans_to_holder(kit_item.reagents, 120)

/obj/item/reagent_kit/extinguisher/attackby(obj/item/I, mob/user)
	. = ..()
	if (.)
		return
	if (istype(I, /obj/item/weapon/extinguisher))
		if (reagents.trans_to_obj(I, I.reagents.maximum_volume))
			user.visible_message(SPAN_ITALIC("\The [user] refills \the [I] from \the [src]."), range = 5)
			playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return TRUE

/obj/item/reagent_kit/extinguisher/afterattack(obj/O, mob/user, proximity)
	if (!proximity)
		return
	if (istype(O, /obj/structure/reagent_dispensers/watertank))
		if (!reagents.get_free_space())
			to_chat(user, SPAN_WARNING("\The [src] is already full."))
		else if (!O.reagents.total_volume)
			to_chat(user, SPAN_WARNING("\The [O] is empty."))
		else
			user.visible_message(SPAN_ITALIC("\The [user] refills \the [src] from \the [O]."), range = 5)
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			O.reagents.trans_to_obj(src, reagents.maximum_volume)


/obj/item/reagent_kit/weldingtool
	name = "welding kit"
	icon_state = "welderpack"
	desc = "An unwieldy, heavy backpack with two massive tanks. Includes a connector for portable welding tools."
	spawn_reagents = list(/datum/reagent/fuel = 300)
	kit_item = /obj/item/weapon/weldingtool
	kit_flags = KIT_ITEM_SPAWNS | KIT_ITEM_CONNECTS | KIT_ITEM_REMOVABLE

/obj/item/reagent_kit/weldingtool/on_process()
	var/obj/item/weapon/weldingtool/welder = kit_item
	if (welder.tank)
		reagents.trans_to_holder(welder.tank.reagents, 10)

/obj/item/reagent_kit/weldingtool/disallow_item(obj/item/weapon/weldingtool/W)
	if (W.welding)
		return SPAN_WARNING("\The [W] is still hot. Turn it off!")

/obj/item/reagent_kit/weldingtool/attackby(obj/item/I, mob/user)
	. = ..()
	if (.)
		return
	if (isWelder(I))
		var/obj/item/weapon/weldingtool/W = I
		if (W.welding)
			if (user.a_intent != I_HURT)
				to_chat(user, SPAN_WARNING("You almost hold the hot [W] to \the [src], but pull away!"))
			else
				user.visible_message(SPAN_DANGER("\The [user] holds \the hot [W] to \the [src]!"))
				log_and_message_admins("is trying to set off a fuel kit explosion.", user, get_turf(src))
				if (do_after(user, 5 SECONDS, src) && !QDELETED(src) && Adjacent(user))
					explosion(get_turf(src), 0, 1, 2)
					qdel(src)
		else if (W.tank)
			if (reagents.trans_to_obj(W.tank, W.tank.max_fuel))
				user.visible_message(SPAN_ITALIC("\The [user] refuels \the [W] from \the [src]."), range = 5)
				playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return TRUE

/obj/item/reagent_kit/weldingtool/afterattack(obj/O, mob/user, proximity)
	if (!proximity)
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank))
		if (!reagents.get_free_space())
			to_chat(user, SPAN_WARNING("\The [src] is already full."))
		else if (!O.reagents.total_volume)
			to_chat(user, SPAN_WARNING("\The [O] is empty."))
		else
			user.visible_message(SPAN_ITALIC("\The [user] refills \the [src] from \the [O]."))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			O.reagents.trans_to_obj(src, reagents.maximum_volume)


#undef KIT_ITEM_SPAWNS
#undef KIT_ITEM_CONNECTS
#undef KIT_ITEM_REMOVABLE
