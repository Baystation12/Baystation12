/obj/structure/table/mag
	name = "Magnetic Table"
	desc = "It is simple magnetic table. Good for merchants."
	icon = 'mods/_maps/liberia/icons/mag_tables.dmi'
	icon_state = "magnetic_table_disabled"
	var/icon_state_open = "magnetic_table_disabled"
	var/icon_state_closed = "magnetic_table_enabled"
	req_access = list(access_merchant)
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	var/locked = 0
	var/health = 20
	var/maxhealth = 20

/obj/structure/table/mag/Initialize()
	. = ..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	name = "Magnetic Table"
	maxhealth = 20
	health = 20

/obj/structure/table/mag/on_update_icon()
	if (locked)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

/obj/structure/table/mag/can_connect()
	return FALSE

//obj/structure/table/mag/attack_generic(mob/user, damage, attack_verb) TO DO - fix
//	take_damage(amount)
//	..()
//	if(health <= 10 && locked)
//		toggle_lock()


/obj/structure/table/mag/Destroy()
	if(locked)
		toggle_lock()
	..()

/obj/structure/table/mag/break_to_parts(full_return = 0)
	if(locked)
		toggle_lock()
	..()

/obj/structure/table/mag/proc/toggle_lock()
	if(health <= 10 && !locked)
		return
	locked = !locked
	update_icon()
	for (var/obj/item/I in get_turf(src))
		I.anchored = locked
	playsound(src, 'sound/effects/storage/briefcase.ogg', 100, 1)

/obj/structure/table/mag/use_tool(obj/item/W as obj, mob/user as mob, click_params)
	if(isrobot(user))
		return..()
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer))
		if(allowed(usr))
			toggle_lock()
			visible_message(SPAN_NOTICE("[usr] [locked ? "" : "un"]locked [src]!"))
			return TRUE
	if(isitem(W))
		if(user.drop_from_inventory(W, src.loc))
			auto_align(W, click_params)
			W.anchored = locked
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	..()

/obj/structure/table/mag/CtrlClick()
	return TRUE
