/obj/item/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	randpixel = 0
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 18750)
	var/deployed = 0

/obj/item/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/beartrap/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob && can_use(user) && can_unbuckle(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins freeing \the [buckled_mob] from \the [src]."),
			SPAN_NOTICE("You carefully begin to free \the [buckled_mob] from \the [src]."),
			SPAN_NOTICE("You hear metal creaking.")
			)
		if(do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE) && can_unbuckle(user))
			user.visible_message(SPAN_NOTICE("\The [buckled_mob] has been freed from \the [src] by \the [user]."))
			unbuckle_mob()
			anchored = FALSE

/obj/item/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("[user] starts to deploy \the [src]."),
			SPAN_DANGER("You begin deploying \the [src]!"),
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE) && user.unEquip(src))
			user.visible_message(
				SPAN_DANGER("\The [user] has deployed \the [src]."),
				SPAN_DANGER("You have deployed \the [src]!"),
				"You hear a latch click loudly."
				)

			deployed = 1
			update_icon()
			anchored = TRUE

/obj/item/beartrap/attack_hand(mob/user as mob)
	if(buckled_mob)
		user_unbuckle_mob(user)
	else if(deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("[user] starts to disarm \the [src]."),
			SPAN_NOTICE("You begin disarming \the [src]!"),
			"You hear a latch click followed by the slow creaking of a spring."
			)
		if(do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE))
			user.visible_message(
				SPAN_DANGER("[user] has disarmed \the [src]."),
				SPAN_NOTICE("You have disarmed \the [src]!")
				)
			deployed = 0
			anchored = FALSE
			update_icon()
	else
		..()

/obj/item/beartrap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	if(!L.apply_damage(30, DAMAGE_BRUTE, target_zone, used_weapon=src))
		return 0

	//trap the victim in place
	if (can_buckle(L))
		set_dir(L.dir)
		buckle_mob(L)
		to_chat(L, SPAN_DANGER("The steel jaws of \the [src] bite into you, trapping you in place!"))
	else
		to_chat(L, SPAN_DANGER("The steel jaws of \the [src] bite into you, but fail to hold you in place!"))
	deployed = 0

/obj/item/beartrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(!MOVING_DELIBERATELY(L))
			L.visible_message(
				SPAN_DANGER("[L] steps on \the [src]."),
				SPAN_DANGER("You step on \the [src]!"),
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!buckled_mob)
				anchored = FALSE
			deployed = 0
			update_icon()
	..()

/obj/item/beartrap/on_update_icon()
	..()

	if(!deployed)
		icon_state = "beartrap0"
	else
		icon_state = "beartrap1"
