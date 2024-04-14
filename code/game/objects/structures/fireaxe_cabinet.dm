/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	health_max = 30
	health_min_damage = 15
	damage_hitsound = 'sound/effects/Glasshit.ogg'

	var/open
	var/unlocked
	var/obj/item/material/twohanded/fireaxe/fireaxe

/obj/structure/fireaxecabinet/on_death()
	playsound(src, 'sound/effects/Glassbr3.ogg', 50, TRUE)
	open = TRUE
	unlocked = TRUE
	update_icon()

/obj/structure/fireaxecabinet/on_revive()
	update_icon()

/obj/structure/fireaxecabinet/on_update_icon()
	ClearOverlays()
	if(fireaxe)
		AddOverlays(image(icon, "fireaxe_item"))
	if(health_dead())
		AddOverlays(image(icon, "fireaxe_window_broken"))
	else if(!open)
		AddOverlays(image(icon, "fireaxe_window"))

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

	// Material Stack - Repair damage
	if (istype(tool, /obj/item/stack/material))
		var/obj/item/stack/material/stack = tool
		if (stack.material.name != MATERIAL_GLASS)
			return ..()
		if (!health_dead() && !health_damaged())
			USE_FEEDBACK_FAILURE("\The [src] doesn't need repair.")
			return TRUE
		if (!stack.reinf_material)
			USE_FEEDBACK_FAILURE("\The [src] can only be repaired with reinforced glass.")
			return TRUE
		if (!stack.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to repair \the [src].")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [src]'s damage with [stack.get_vague_name(FALSE)]."),
			SPAN_NOTICE("You repair \the [src]'s damage with [stack.get_exact_name(1)].")
		)
		revive_health()
		return TRUE

	// Multitool - Toggle manual lock
	if (isMultitool(tool))
		if (open)
			USE_FEEDBACK_FAILURE("\The [src] must be closed before you can lock it.")
			return TRUE
		if (health_dead())
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
	if(health_dead())
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()
