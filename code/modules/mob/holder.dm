var/global/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/ash.dmi'
	slot_flags = SLOT_HEAD | SLOT_HOLSTER

	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi'
		)

	origin_tech = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_holder.dmi',
		)
	pixel_y = 8

	var/mob/living/last_holder

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/proc/destroy_all()
	for(var/atom/movable/AM in src)
		qdel(AM)
	qdel(src)

/obj/item/holder/Destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	last_holder = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/holder/Process()
	update_state()

/obj/item/holder/dropped()
	..()
	spawn(1)
		update_state()

/obj/item/holder/proc/update_state()
	if(last_holder != loc)
		for(var/mob/M in contents)
			unregister_all_movement(last_holder, M)

	if(istype(loc,/turf) || !(length(contents)))
		for(var/mob/M in contents)
			var/atom/movable/mob_container = M
			mob_container.dropInto(loc)
			M.reset_view()
		qdel(src)
	else if(last_holder != loc)
		for(var/mob/M in contents)
			register_all_movement(loc, M)

	last_holder = loc

/obj/item/holder/onDropInto(atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetIdCard()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null

/obj/item/holder/GetAccess()
	var/obj/item/I = GetIdCard()
	return I ? I.GetAccess() : ..()

/obj/item/holder/attack_self(mob/user)
	if (!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	for(var/mob/M in contents)
		H.species.hug(H, M)

/obj/item/holder/MouseDrop(atom/over_atom, atom/source_loc, atom/over_loc, source_control, over_control, list/mouse_params)
	if(over_atom != usr)
		return ..()
	for(var/mob/M in contents)
		M.show_inv(usr)

/obj/item/holder/use_before(mob/target, mob/user)
	. = FALSE
	// Devour on click on self with holder
	if (target == user && istype(user,/mob/living/carbon))
		var/mob/living/carbon/M = user
		for (var/mob/victim in src.contents)
			M.devour(victim)
		update_state()
		return TRUE

/obj/item/holder/proc/sync(mob/living/M)
	dir = 2
	ClearOverlays()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	CopyOverlays(M)
	var/mob/living/carbon/human/H = loc
	last_holder = H
	if (M.pulledby)
		if (M.pulledby.pulling == src)
			M.pulledby.pulling = null
		M.pulledby = null
	register_all_movement(H, M)

	update_held_icon()

//Mob specific holders.
/obj/item/holder/drone
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/holder/mouse
	w_class = ITEM_SIZE_TINY

/obj/item/holder/small
	w_class = ITEM_SIZE_SMALL

/obj/item/holder/borer
	origin_tech = list(TECH_BIO = 6)

//need own subtype to work with recipes
/obj/item/holder/corgi
	origin_tech = list(TECH_BIO = 4)

/obj/item/holder/possum
	origin_tech = list(TECH_BIO = 3)

/obj/item/holder/possum/poppy
	origin_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 4)
	item_state = "poppy"


/obj/item/holder/use_grab(obj/item/grab/grab, list/click_params)
	// Handled by `use_tool()`
	return FALSE


/obj/item/holder/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)

	// Handled by `use_tool()`
	return FALSE


/obj/item/holder/use_tool(obj/item/tool, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)

	. = FALSE
	for (var/mob/held in contents)
		if (tool.resolve_attackby(held, user, click_params))
			. = TRUE


//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(mob/living/carbon/human/grabber, self_grab)
	if(!holder_type || buckled || length(pinned))
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src))

	if(self_grab)
		if(!grabber.equip_to_slot_if_possible(H, slot_back, TRYEQUIP_REDRAW | TRYEQUIP_SILENT))
			to_chat(src, SPAN_WARNING("You can't climb onto [grabber]!"))
			return

		to_chat(grabber, SPAN_NOTICE("\The [src] clambers onto you!"))
		to_chat(src, SPAN_NOTICE("You climb up onto \the [grabber]!"))
	else
		if(!grabber.put_in_hands(H))
			to_chat(grabber, SPAN_WARNING("Your hands are full!"))
			return

		to_chat(grabber, SPAN_NOTICE("You scoop up \the [src]!"))
		to_chat(src, SPAN_NOTICE("\The [grabber] scoops you up!"))

	src.forceMove(H)

	grabber.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/mob/living/MouseDrop(mob/living/carbon/human/over_object)
	if(istype(over_object) && Adjacent(over_object) && (usr == src || usr == over_object) && over_object.a_intent == I_GRAB)
		if(scoop_check(over_object))
			get_scooped(over_object, (usr == src))
			return
	return ..()

/mob/living/proc/scoop_check(mob/living/scooper)
	return 1

/mob/living/carbon/human/scoop_check(mob/living/scooper)
	return (scooper.mob_size > src.mob_size && a_intent == I_HELP)
