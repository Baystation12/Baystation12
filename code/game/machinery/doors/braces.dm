/obj/item/material/twohanded/jack
	name = "maintenance jack"
	desc = "A heavy-duty combination hammer and prying tool that can be used to remove airlock braces."
	icon = 'icons/obj/tools/crowbar.dmi'
	icon_state = "jack0"
	base_icon = "jack"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 2.5 * DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -25
	throwforce = 15
	force = 25
	force_multiplier = 1.1
	unwielded_force_divisor = 0.7
	attack_cooldown_modifier = 1
	base_parry_chance = 30
	applies_material_colour = FALSE


/obj/item/material/twohanded/jack/IsCrowbar()
	return TRUE


/obj/item/material/twohanded/jack/aluminium
	default_material = MATERIAL_ALUMINIUM


/obj/item/material/twohanded/jack/titanium
	default_material = MATERIAL_TITANIUM


/obj/item/material/twohanded/jack/silver
	default_material = MATERIAL_SILVER


/obj/item/airlock_brace
	name = "airlock brace"
	desc = "A sturdy device that can be attached to an airlock to reinforce it and provide additional security."
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "brace_open"
	health_max = 300
	var/obj/machinery/door/airlock/airlock
	var/obj/item/airlock_electronics/brace/electronics


/obj/item/airlock_brace/Destroy()
	if (airlock)
		airlock.brace = null
		airlock = null
	QDEL_NULL(electronics)
	return ..()


/obj/item/airlock_brace/Initialize()
	. = ..()
	electronics = new (src)
	if (length(req_access))
		electronics.set_access(src)
	update_access()


/obj/item/airlock_brace/on_update_icon()
	if (airlock)
		icon_state = "brace_closed"
	else
		icon_state = "brace_open"


/obj/item/airlock_brace/attack_self(mob/living/user)
	electronics.attack_self(user)


/obj/item/airlock_brace/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (istype(item.GetIdCard(), /obj/item/card/id))
		if (airlock)
			update_access()
			if (check_access(item))
				user.visible_message(
					SPAN_ITALIC("\The [user] swipes \a [item] through \a [src]."),
					SPAN_ITALIC("You swipe \the [item] through \the [src]."),
				)
				if (do_after(user, 1 SECOND, airlock, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					to_chat(user, "\The [src] clicks and detaches from \the [airlock]!")
					user.put_in_hands(src)
					airlock.brace = null
					airlock.update_icon()
					airlock = null
					update_icon()
				return TRUE
			else
				to_chat(user, "You swipe \the [item] through \the [src], but it does not react.")
				return TRUE
		else
			attack_self(user)
			return TRUE

	if (istype(item, /obj/item/material/twohanded/jack))
		if (!airlock)
			to_chat(user, SPAN_WARNING("\The [src] is not attached to an airlock!"))
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] begins removing \a [src] with \a [item]."),
			SPAN_ITALIC("You begin removing \the [src] with \the [item].")
		)
		if (do_after(user, 20 SECONDS, airlock, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			user.visible_message(
				SPAN_ITALIC("\The [user] removes \a [src] with \a [item]."),
				SPAN_ITALIC("You remove \the [src] with \the [item].")
			)
			user.put_in_hands(src)
			airlock.brace = null
			airlock.update_icon()
			airlock = null
			update_icon()
		return TRUE

	if (isWelder(item))
		if (!health_damaged())
			to_chat(user, SPAN_NOTICE("\The [src] does not require repairs."))
			return TRUE
		var/obj/item/weldingtool/welder = item
		if (welder.can_use(1, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			user.visible_message(
				SPAN_ITALIC("\The [user] begins repairing damage on \a [src]."),
				SPAN_ITALIC("You begin repairing damage on the [src].")
			)
			if (do_after(user, (item.toolspeed * 3) SECONDS, airlock, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && welder.remove_fuel(1, user))
				user.visible_message(
					SPAN_ITALIC("\The [user] repairs damage on \a [src]."),
					SPAN_ITALIC("You repair damage on the [src].")
				)
				restore_health(rand(75, 150))
		return TRUE
	return ..()


/obj/item/airlock_brace/on_death()
	if (airlock)
		visible_message(SPAN_DANGER("\The [src] breaks, falling from \the [airlock]!"))
		airlock.brace = null
		airlock.update_icon()
	qdel(src)


/obj/item/airlock_brace/proc/update_access()
	if (!electronics)
		return
	req_access = electronics.conf_access
	if (electronics.one_access)
		req_access = list(req_access)
