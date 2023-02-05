/obj/item/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = ITEM_SIZE_HUGE
	throw_speed = 2
	throw_range = 10
	force = 5.0
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = 0
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/effects/bang.ogg'
	combustion = 1

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()

/obj/item/gun/launcher/rocket/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("[length(rockets)] / [max_rockets] rockets."))


/obj/item/gun/launcher/rocket/get_interactions_info()
	. = ..()
	.["Rocket Shell"] = "<p>Loads the rocket into the launcher. The launcher can hold up to [initial(max_rockets)] rocket\s at a time.</p>"


/obj/item/gun/launcher/rocket/use_tool(obj/item/tool, mob/user, list/click_params)
	// Rocket Shell - Add ammo
	if (istype(tool, /obj/item/ammo_casing/rocket))
		if (length(rockets) >= max_rockets)
			to_chat(user, SPAN_WARNING("\The [src] cannot hold more rockets."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		rockets += tool
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] into \the [src]."),
			SPAN_NOTICE("You insert \a [tool] into \the [src].")
		)
		return TRUE

	return ..()


/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(length(rockets))
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	log_and_message_admins("fired a rocket from a rocket launcher ([src.name]) at [target].")
	..()
