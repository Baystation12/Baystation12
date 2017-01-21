/obj/item/weapon/beartrap
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
	matter = list(DEFAULT_WALL_MATERIAL = 18750)
	can_buckle = 0 //disallow manual un/buckling
	var/deployed = 0

/obj/item/weapon/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/beartrap/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob && can_use(user))
		user.visible_message(
			"<span class='notice'>\The [user] begins freeing \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)
		if(do_after(user, 60, src))
			user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
			unbuckle_mob()
			anchored = 0

/obj/item/weapon/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60, src))
			user.visible_message(
				"<span class='danger'>\The [user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1

/obj/item/weapon/beartrap/attack_hand(mob/user as mob)
	if(buckled_mob)
		user_unbuckle_mob(user)
	else if(deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to disarm \the [src].</span>",
			"<span class='notice'>You begin disarming \the [src]!</span>",
			"You hear a latch click followed by the slow creaking of a spring."
			)
		if(do_after(user, 60, src))
			user.visible_message(
				"<span class='danger'>[user] has disarmed \the [src].</span>",
				"<span class='notice'>You have disarmed \the [src]!</span>"
				)
			deployed = 0
			anchored = 0
			update_icon()
	else
		..()

/obj/item/weapon/beartrap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")

	if(blocked >= 100)
		return

	if(!L.apply_damage(30, BRUTE, target_zone, blocked, used_weapon=src))
		return 0

	//trap the victim in place
	set_dir(L.dir)
	buckle_mob(L)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = 0

/obj/item/weapon/beartrap/Crossed(AM as mob|obj)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!buckled_mob)
				anchored = 0
			deployed = 0
			update_icon()
	..()

/obj/item/weapon/beartrap/update_icon()
	..()

	if(!deployed)
		icon_state = "beartrap0"
	else
		icon_state = "beartrap1"
