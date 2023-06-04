/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE

	var/damage_threshold = 15
	var/open
	var/unlocked
	var/shattered
	var/obj/item/material/twohanded/fireaxe/fireaxe

/obj/structure/fireaxecabinet/attack_generic(mob/user, damage, attack_verb = "hits", wallbreaker = FALSE, damtype = DAMAGE_BRUTE, armorcheck = "melee", dam_flags = EMPTY_BITFIELD)
	attack_animation(user)
	playsound(user, 'sound/effects/Glasshit.ogg', 50, 1)
	visible_message(SPAN_DANGER("[user] [attack_verb] \the [src]!"))
	if(damage_threshold > damage)
		to_chat(user, SPAN_DANGER("Your strike is deflected by the reinforced glass!"))
		return
	if(shattered)
		return
	shattered = 1
	unlocked = 1
	open = 1
	playsound(user, 'sound/effects/Glassbr3.ogg', 100, 1)
	update_icon()

/obj/structure/fireaxecabinet/on_update_icon()
	overlays.Cut()
	if(fireaxe)
		overlays += image(icon, "fireaxe_item")
	if(shattered)
		overlays += image(icon, "fireaxe_window_broken")
	else if(!open)
		overlays += image(icon, "fireaxe_window")

/obj/structure/fireaxecabinet/New()
	..()
	fireaxe = new(src)
	update_icon()

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	if(!unlocked)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return
	toggle_open(user)

/obj/structure/fireaxecabinet/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr)
		var/mob/user = over_object
		if(!istype(user))
			return

		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] is closed."))
			return

		if(!fireaxe)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return

		user.put_in_hands(fireaxe)
		fireaxe = null
		update_icon()

	return

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		fireaxe.dropInto(loc)
		fireaxe = null
	return ..()


/obj/structure/fireaxecabinet/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Snowflake damage handler - TODO: Replace with standardized damage
	if (weapon.force > 0 && !HAS_FLAGS(weapon.item_flags, ITEM_FLAG_NO_BLUDGEON))
		user.setClickCooldown(user.get_attack_speed(weapon))
		user.do_attack_animation(src)
		attack_generic(user, weapon.force, pick(weapon.attack_verb), damtype = weapon.damtype, dam_flags = weapon.damage_flags())
		return TRUE

	return ..()


/obj/structure/fireaxecabinet/use_tool(obj/item/tool, mob/user, list/click_params)
	// Fireaxe - Place inside
	if (istype(tool, /obj/item/material/twohanded/fireaxe))
		if (!open)
			USE_FEEDBACK_FAILURE("\The [src] is closed.")
			return TRUE
		if (fireaxe)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [fireaxe] inside.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		fireaxe = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] places \a [tool] into \the [src]."),
			SPAN_NOTICE("You place \the [tool] into \the [src].")
		)
		return TRUE

	// Multitool - Toggle manual lock
	if (isMultitool(tool))
		if (open)
			USE_FEEDBACK_FAILURE("\The [src] must be closed before you can lock it.")
			return TRUE
		if (shattered)
			USE_FEEDBACK_FAILURE("\The [src] is shattered and the lock doesn't function.")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] begins toggling \the [src]'s maglock with \a [tool]."),
			SPAN_NOTICE("You begin [unlocked ? "locking" : "unlocking"] \the [src]'s maglock with \the [tool].")
		)
		if (!do_after(user, (tool.toolspeed * 2) SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(src, 'sound/machines/lockreset.ogg', 50, TRUE)
		unlocked = !unlocked
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [unlocked ? "unlocks" : "locks"] \the [src]'s maglock with \a [tool]."),
			SPAN_NOTICE("You [unlocked ? "unlock" : "lock"] \the [src]'s maglock with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/fireaxecabinet/proc/toggle_open(mob/user)
	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()
