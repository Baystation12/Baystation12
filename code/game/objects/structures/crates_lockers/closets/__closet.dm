/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closets/bases/closet.dmi'
	icon_state = "base"
	density = TRUE
	w_class = ITEM_SIZE_NO_CONTAINER
	health_max = 100

	var/welded = 0
	var/large = 1
	var/wall_mounted = FALSE //equivalent to non-dense for air movement
	var/breakout = 0 //if someone is currently breaking out. mutex
	var/storage_capacity = 2 * MOB_MEDIUM //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/effects/closet_open.ogg'
	var/close_sound = 'sound/effects/closet_close.ogg'

	var/storage_types = CLOSET_STORAGE_ALL
	var/setup = CLOSET_CAN_BE_WELDED
	var/closet_appearance = /singleton/closet_appearance
	material = MATERIAL_STEEL

	// TODO: Turn these into flags. Skipped it for now because it requires updating 100+ locations...
	var/broken = FALSE
	var/opened = FALSE
	var/locked = FALSE

/obj/structure/closet/Initialize()
	..()

	if((setup & CLOSET_HAS_LOCK))
		verbs += /obj/structure/closet/proc/togglelock_verb

	if(ispath(closet_appearance))
		var/singleton/closet_appearance/app = GET_SINGLETON(closet_appearance)
		if(app)
			icon = app.icon
			color = null
			queue_icon_update()

	material = SSmaterials.get_material_by_name(material)

	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/LateInitialize(mapload)
	var/list/will_contain = WillContain()
	if(will_contain)
		create_objects_in_loc(src, will_contain)
	if(mapload && !opened)
		store_contents()

/obj/structure/closet/proc/WillContain()
	return null

/obj/structure/closet/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && !opened)
		var/content_size = 0
		for(var/atom/movable/AM in src.contents)
			if(!AM.anchored)
				content_size += content_size(AM)
		if(!content_size)
			to_chat(user, "It is empty.")
		else if(storage_capacity > content_size*4)
			to_chat(user, "It is barely filled.")
		else if(storage_capacity > content_size*2)
			to_chat(user, "It is less than half full.")
		else if(storage_capacity > content_size)
			to_chat(user, "There is still some free space.")
		else
			to_chat(user, "It is full.")

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if((setup & CLOSET_HAS_LOCK) && locked)
		return 0
	if((setup & CLOSET_CAN_BE_WELDED) && welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/atom/movable/object in get_turf(src))
		if (istype(object, /obj/structure/closet) && object != src)
			return FALSE
		if (istype(object, /mob/living))
			var/mob/living/L = object
			if (L.mob_size >= MOB_LARGE)
				return FALSE
	return TRUE

/obj/structure/closet/proc/dump_contents()
	for(var/mob/M in src)
		M.dropInto(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	for(var/atom/movable/AM in src)
		AM.dropInto(loc)

/obj/structure/closet/proc/store_contents()
	var/stored_units = 0

	if(storage_types & CLOSET_STORAGE_ITEMS)
		stored_units += store_items(stored_units)
	if(storage_types & CLOSET_STORAGE_MOBS)
		stored_units += store_mobs(stored_units)
	if(storage_types & CLOSET_STORAGE_STRUCTURES)
		stored_units += store_structures(stored_units)

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.opened = 1
	playsound(src.loc, open_sound, 50, 1, -3)
	set_density(FALSE)
	update_icon()
	return 1

/obj/structure/closet/proc/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	store_contents()
	src.opened = 0

	playsound(src.loc, close_sound, 50, 0, -3)
	if(!wall_mounted)
		set_density(TRUE)

	update_icon()

	return 1

#define CLOSET_CHECK_TOO_BIG(x) (stored_units + . + x > storage_capacity)
/obj/structure/closet/proc/store_items(stored_units)
	. = 0

	for(var/obj/dummy/chameleon/AD in loc)
		if(CLOSET_CHECK_TOO_BIG(1))
			break
		.++
		AD.forceMove(src)

	for(var/obj/item/I in loc)
		if(I.anchored)
			continue
		var/item_size = content_size(I)
		if(CLOSET_CHECK_TOO_BIG(item_size))
			break
		. += item_size
		I.forceMove(src)
		I.pixel_x = 0
		I.pixel_y = 0
		I.pixel_z = 0

/obj/structure/closet/proc/store_mobs(stored_units)
	. = 0
	for(var/mob/living/M in loc)
		if(M.buckled || length(M.pinned) || M.anchored)
			continue
		var/mob_size = content_size(M)
		if(CLOSET_CHECK_TOO_BIG(mob_size))
			break
		. += mob_size
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)

/obj/structure/closet/proc/store_structures(stored_units)
	. = 0

	for(var/obj/structure/S in loc)
		if(S == src)
			continue
		if(S.anchored)
			continue
		var/structure_size = content_size(S)
		if(CLOSET_CHECK_TOO_BIG(structure_size))
			break
		. += structure_size
		S.forceMove(src)

	for(var/obj/machinery/M in loc)
		if(M.anchored)
			continue
		var/structure_size = content_size(M)
		if(CLOSET_CHECK_TOO_BIG(structure_size))
			break
		. += structure_size
		M.forceMove(src)

#undef CLOSET_CHECK_TOO_BIG

// If you adjust any of the values below, please also update /proc/unit_test_weight_of_path(var/path)
/obj/structure/closet/proc/content_size(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		return M.mob_size
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		return (I.w_class / 2)
	if(istype(AM, /obj/structure) || istype(AM, /obj/machinery))
		return MOB_LARGE
	return 0

/obj/structure/closet/proc/toggle(mob/user as mob)
	if(locked)
		togglelock(user)
	else if(!(src.opened ? src.close() : src.open()))
		to_chat(user, SPAN_NOTICE("It won't budge!"))
		update_icon()

/obj/structure/closet/ex_act(severity)
	// Damage everything inside the closet.
	if (severity < EX_ACT_LIGHT)
		for (var/atom/A as anything in src)
			A.ex_act(severity + 1)
	..()

/obj/structure/closet/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	// Damage everything inside the closet. These things aren't fire proof.
	for (var/atom/A as anything in src)
		A.fire_act(air, exposed_temperature, exposed_volume)
	..()

/obj/structure/closet/bullet_act(obj/item/projectile/Proj)
	if (Proj.penetrating)
		var/distance = get_dist(Proj.starting, get_turf(loc))
		var/list/items = contents.Copy()
		while (length(items))
			var/atom/A = pick_n_take(items)
			if (isliving(A))
				Proj.attack_mob(A, distance)
			else
				A.bullet_act(Proj)
			Proj.penetrating -= 1
			if(!Proj.penetrating)
				break
	. = ..()


/obj/structure/closet/use_grab(obj/item/grab/grab, list/click_params)
	if (!opened)
		return ..()

	MouseDrop_T(grab.affecting, grab.assailant)
	return TRUE


/obj/structure/closet/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Energy Blade - Break locker open
	if (istype(weapon, /obj/item/melee/energy/blade))
		if (opened)
			return ..()
		if (!emag_act(INFINITY, user,
			SPAN_WARNING("\The [user] slices \the [src] open with \a [weapon]!"),
			SPAN_DANGER("You slice \the [src] open with \the [weapon]!"),
			SPAN_ITALIC("You hear metal being sliced and sparks flying.")
		))
			return TRUE
		var/datum/effect/spark_spread/spark_system = new /datum/effect/spark_spread()
		spark_system.set_up(5, loca = src)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, TRUE)
		playsound(src, "sparks", 50, TRUE)
		open()
		return TRUE

	// The following interactions only apply to open closets
	if (!opened)
		return ..()

	// Laundry Basket - Dump contents into closet
	if (istype(weapon, /obj/item/storage/laundry_basket) && length(weapon.contents))
		if (!opened)
			USE_FEEDBACK_FAILURE("\The [src] needs to be open before you can dump \the [src] into it.")
			return TRUE
		var/obj/item/storage/laundry_basket/basket = weapon
		for (var/obj/item/item as anything in basket.contents)
			basket.remove_from_storage(item, loc, TRUE)
		basket.finish_bulk_removal()
		user.visible_message(
			SPAN_NOTICE("\The [user] empties \a [weapon] into \the [src]."),
			SPAN_NOTICE("You empty \the [weapon] into \the [src].")
		)
		return TRUE

	// Plasma Cutter - Dismantle closet
	if (istype(weapon, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = weapon
		if (!cutter.slice(user))
			return TRUE
		slice_into_parts(weapon, user)
		return TRUE

	// Welding weapon - Dismantle closet
	if (isWelder(weapon))
		var/obj/item/weldingtool/welder = weapon
		if (!welder.remove_fuel(1, user))
			return TRUE
		slice_into_parts(weapon, user)
		return TRUE

	return ..()


/obj/structure/closet/use_tool(obj/item/tool, mob/user, list/click_params)
	// General Action - Place item in closet, if open.
	// The following interactions only apply to closed closets.
	if (opened)
		if (!user.unEquip(tool, loc))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		tool.pixel_x = 0
		tool.pixel_y = 0
		tool.pixel_z = 0
		tool.pixel_w = 0
		return TRUE

	// ID - Toggle lock
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		if (!HAS_FLAGS(setup, CLOSET_HAS_LOCK))
			return ..()
		togglelock(user, id)
		return TRUE

	// Welding Tool - Weld closet shut
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!HAS_FLAGS(setup, CLOSET_CAN_BE_WELDED))
			USE_FEEDBACK_FAILURE("\The [src] can't be welded shut.")
			return TRUE
		if (!welder.can_use(1, user))
			return TRUE
		welded = !welded
		update_icon()
		user.visible_message(
			SPAN_WARNING("\The [user] [welded ? "welds" : "unwelds"] \the [src] with \a [tool]."),
			SPAN_WARNING("You [welded ? "weld" : "unweld"] \the [src] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/closet/proc/slice_into_parts(obj/W, mob/user)
	material.place_sheet(src.loc, 2)
	user.visible_message(SPAN_NOTICE("\The [src] has been cut apart by [user] with \the [W]."), \
						 SPAN_NOTICE("You have cut \the [src] apart with \the [W]."), \
						 "You hear welding.")
	qdel(src)

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if (!O)
		return
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(ismob(O) && src.large)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, src.loc)
	if(user != O)
		user.show_viewers(SPAN_DANGER("[user] stuffs [O] into [src]!"))
	src.add_fingerprint(user)
	return

/obj/structure/closet/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		to_chat(user, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	src.toggle(user)

/obj/structure/closet/attack_ghost(mob/ghost)
	if(ghost.client && ghost.client.inquisitive_ghost)
		examinate(ghost, src)
		if (!src.opened)
			to_chat(ghost, "It contains: [english_list(contents)].")

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!CanPhysicallyInteract(usr))
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.toggle(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/on_update_icon()
	if(opened)
		icon_state = "open"
		ClearOverlays()
	else
		if(broken)
			icon_state = "closed_emagged[welded ? "_welded" : ""]"
		else
			if(locked)
				icon_state = "closed_locked[welded ? "_welded" : ""]"
			else
				icon_state = "closed_unlocked[welded ? "_welded" : ""]"
			ClearOverlays()

/obj/structure/closet/on_death()
	dump_contents()
	qdel(src)

/obj/structure/closet/proc/req_breakout()
	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if((setup & CLOSET_HAS_LOCK) && locked)
		return 1 // Closed and locked
	return (!welded) //closed but not welded...

/obj/structure/closet/mob_breakout(mob/living/escapee)

	. = ..()
	var/breakout_time = 2 //2 minutes by default
	if(breakout || !req_breakout())
		return FALSE

	. = TRUE
	escapee.setClickCooldown(100)

	//okay, so the closet is either welded or locked... resist!!!
	to_chat(escapee, SPAN_WARNING("You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)"))

	visible_message(SPAN_DANGER("\The [src] begins to shake violently!"))

	breakout = 1 //can't think of a better way to do this right now.
	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		if(!do_after(escapee, 5 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED)) //5 seconds
			breakout = 0
			return FALSE
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			return FALSE

		playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
		shake_animation()
		add_fingerprint(escapee)

	//Well then break it!
	breakout = 0
	to_chat(escapee, SPAN_WARNING("You successfully break out!"))
	visible_message(SPAN_DANGER("\The [escapee] successfully broke out of \the [src]!"))
	playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
	break_open()
	shake_animation()

/obj/structure/closet/proc/break_open()
	welded = 0

	if((setup & CLOSET_HAS_LOCK) && locked)
		make_broken()

	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/onDropInto(atom/movable/AM)
	return

// If we use the /obj/structure/closet/proc/togglelock variant BYOND asks the user to select an input for id_card, which is then mostly irrelevant.
/obj/structure/closet/proc/togglelock_verb()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	return togglelock(usr)

/obj/structure/closet/proc/togglelock(mob/user, obj/item/card/id/id_card)
	if(!(setup & CLOSET_HAS_LOCK))
		return FALSE
	if(!CanPhysicallyInteract(user))
		return FALSE
	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close \the [src] first."))
		return FALSE
	if(src.broken)
		to_chat(user, SPAN_WARNING("\The [src] appears to be broken."))
		return FALSE
	if(user.loc == src)
		to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
		return FALSE

	add_fingerprint(user)

	if(!id_card)
		id_card = user.GetIdCard()

	if(!user.IsAdvancedToolUser())
		to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
		return FALSE

	if(CanToggleLock(user, id_card))
		locked = !locked
		visible_message(
			SPAN_NOTICE("\The [src] has been [locked ? null : "un"]locked by \the [user]."),
			range = 3
		)
		update_icon()
		return TRUE
	else
		to_chat(user, SPAN_WARNING("Access denied!"))
		return FALSE

/obj/structure/closet/proc/CanToggleLock(mob/user, obj/item/card/id/id_card)
	return allowed(user) || (istype(id_card) && check_access_list(id_card.GetAccess()))

/obj/structure/closet/AltClick(mob/user)
	if(!src.opened)
		togglelock(user)
		return TRUE
	return ..()

/obj/structure/closet/CtrlAltClick(mob/user)
	verb_toggleopen()
	return TRUE

/obj/structure/closet/emp_act(severity)
	for (var/atom/A as anything in src)
		A.emp_act(severity)
	if(!broken && (setup & CLOSET_HAS_LOCK))
		if(prob(50/severity))
			locked = !locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/emag_act(remaining_charges, mob/user, emag_source, visual_feedback = "", audible_feedback = "")
	if(!opened && make_broken())
		update_icon()
		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message(SPAN_WARNING("\The [src] has been broken by \the [user] with \an [emag_source]!"), "You hear a faint electrical spark.")
		else
			visible_message(SPAN_WARNING("\The [src] sparks and breaks open!"), "You hear a faint electrical spark.")
		return 1
	else
		. = ..()

/obj/structure/closet/proc/make_broken()
	if(broken)
		return FALSE
	if(!(setup & CLOSET_HAS_LOCK))
		return FALSE
	broken = TRUE
	locked = FALSE
	desc += " It appears to be broken."
	return TRUE

/obj/structure/closet/CanUseTopicPhysical(mob/user)
	return CanUseTopic(user, GLOB.physical_no_access_state)
