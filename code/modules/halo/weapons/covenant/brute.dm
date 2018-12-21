


/* SPIKE GRENADE */

/obj/item/weapon/grenade/frag/spike
	name = "spike grenade"
	desc = "This device embeds itself into soft targets and explodes into a hail of deadly shards."
	icon = 'code/modules/halo/icons/species/jiralhanae_obj.dmi'
	icon_state = "spikegren0"
	icon_override = 'code/modules/halo/icons/species/jiralhanae_gear.dmi'
	item_state = "spnade"

	//less explosive power but more spikes
	explosion_size = 0
	num_fragments = 150

/obj/item/weapon/grenade/frag/spike/activate(mob/user as mob)
	. = ..()
	spawn(30)
		playsound(user, 'code/modules/halo/sounds/Spikenade.ogg', 60, 1)


/obj/item/weapon/grenade/frag/spike/throw_at(atom/target, range, speed, thrower)
	icon_state = "spikegren_spin"
	. = ..()
	icon_state = "spikegren[active]"



/* SPIKER */

#define CASELESS 4

/obj/item/weapon/gun/projectile/spiker
	name = "Type-25 Spiker Carbine"
	desc = "A sidearm with two wicked blades curving out from under the barrel."
	icon = 'code/modules/halo/icons/species/jiralhanae_obj.dmi'
	icon_override = 'code/modules/halo/icons/species/jiralhanae_gear.dmi'
	icon_state = "spiker"
	magazine_type = /obj/item/ammo_magazine/spike
	allowed_magazines = /obj/item/ammo_magazine/spike
	caliber = "spike"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE
	handle_casings = CASELESS
	fire_sound = 'code/modules/halo/sounds/Spikershotfire.ogg'
	//reload_sound = 'code/modules/halo/sounds/Spikershotfire.ogg'

/obj/item/ammo_magazine/spike
	name = "spiker magazine"
	desc = "A 20 round magazine for the Jiralhanae spiker"
	icon = 'code/modules/halo/icons/species/jiralhanae_obj.dmi'
	icon_state = "spikermag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m5
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "spike"
	max_ammo = 20

/obj/item/ammo_casing/spike
	desc = "A spike round casing."
	caliber = "spike"
	projectile_type = /obj/item/projectile/bullet/spike

/obj/item/projectile/bullet/spike
	damage = 20
	accuracy = -3

#undef CASELESS



/* GRAVITY HAMMER */

/obj/item/weapon/grav_hammer
	name = "Type-2 Energy Weapon/Hammer"
	desc = "A long haft and a heavy head with a tungsten-alloy blade on the reverse end. Within the head is a short-range shock-field-generating gravity drive for extra punch."
	icon = 'code/modules/halo/icons/species/jiralhanae_obj_large.dmi'
	icon_override = 'code/modules/halo/icons/species/jiralhanae_gear.dmi'
	icon_state = "gravhammer"
	w_class = ITEM_SIZE_HUGE
	force = 65
	edge = 0
	sharp = 0
	hitsound = 'code/modules/halo/sounds/gravhammer.ogg'

/obj/item/weapon/grav_hammer/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	for(var/atom/movable/M in range(user,1))
		if(M == user)
			continue

		if(!M.anchored)
			var/atom/throw_target = get_edge_target_turf(M, get_dir(user, get_step_away(M, src)))
			M.throw_at(throw_target, 1, 4)

		if(M == A)
			continue

		if(isliving(M))
			var/mob/living/victim = M
			victim.hit_with_weapon(src, user, force/2)



/* BRUTE SHOT */

/obj/item/weapon/gun/launcher/grenade/brute_shot
	name = "Type-25 \"Brute Shot\" Grenade Launcher"
	desc = "A hip fired fast firing launcher for HE munitions with a curved backwards facing blade mounted to its underside."
	icon = 'code/modules/halo/icons/species/jiralhanae_obj_large.dmi'
	icon_override = 'code/modules/halo/icons/species/jiralhanae_gear.dmi'
	icon_state = "bruteshot"
	item_state = "bruteshot"
	pump_sound = null
	max_grenades = 6
	one_hand_penalty = 4
	fire_sound = 'code/modules/halo/sounds/bruteshotfire.ogg'
	var/reload_sound = 'code/modules/halo/sounds/bruteshotreload.ogg'
	var/reload_time = 30

	whitelisted_grenades = list(/obj/item/weapon/grenade/brute_shot)

/obj/item/weapon/gun/launcher/grenade/brute_shot/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/grenade/brute_shot))
		user.visible_message("<span class='info'>[user] begins reloading \icon[src][src]...</span>")
		playsound(user, reload_sound, 60, 1)
		if(do_after(user, reload_time))
			var/obj/item/weapon/grenade/brute_shot/grenade = W

			//strip off grenades from the belt one by one and load them
			var/transferred = 0
			while(transferred < grenade.amount && grenades.len < max_grenades)
				transferred += 1
				var/obj/item/weapon/grenade/brute_shot/single/S = new(src)
				load(S, user, 1)

			//tell the user what happened
			if(transferred > 0)
				to_chat(user,"<span class='info'>You transfer [transferred] grenades from \icon[grenade][grenade] into \icon[src][src].</span>")
				pump(user, 1)
				grenade.modify_amount(-transferred, 0)
				if(grenade.amount <= 0)
					user.drop_item()
					qdel(grenade)
			else
				to_chat(user,"<span class='notice'>\icon[src][src] is already full.</span>")

			return

	return ..()

/obj/item/weapon/gun/launcher/grenade/brute_shot/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	. = ..()

	playsound(user, fire_sound, 60, 1)

	//automatically cycle the chamber
	pump(user, 1)

/obj/item/weapon/grenade/brute_shot
	name = "belt of type-25 antipersonnel grenades"
	desc = "A small explosive device designed to be propelled out of the type-25 grenade launcher. Can also be thrown manually."
	icon = 'code/modules/halo/icons/species/jiralhanae_obj.dmi'
	icon_state = "bruteshot_belt"
	var/fire_sound = null
	det_time = 0
	arm_sound = null
	var/amount = 12
	var/max_amount = 12

/obj/item/weapon/grenade/brute_shot/single
	amount = 1

/obj/item/weapon/grenade/brute_shot/New()
	. = ..()
	modify_amount(0,0)

/obj/item/weapon/grenade/brute_shot/examine(mob/user)
	. = ..(user)
	to_chat(user, "<span class='info'>It has [amount] grenade[amount != 1 ? "s" : ""] remaining on the belt.</span>")

/obj/item/weapon/grenade/brute_shot/detonate()
	..()
	explosion(get_turf(src), -1, -1, max(amount / 2, 1), max(amount / 2, 2), 0)
	qdel(src)

/obj/item/weapon/grenade/brute_shot/proc/modify_amount(var/transferred, var/delete_if_empty = 1)
	amount += transferred

	//update the throw range... more = heaver = shorter range
	throw_range = 20
	if(amount > 1)
		throw_range -= amount * 2
		throw_range = max(throw_range, 4)

	//delete if none
	if(!amount && delete_if_empty)
		qdel(src)
	else
		update_icon()

/obj/item/weapon/grenade/brute_shot/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/grenade/brute_shot))
		//combine the two stacks
		var/obj/item/weapon/grenade/brute_shot/other = W

		//work out how much we can transfer
		var/transferred = other.amount
		if(src.amount + other.amount > max_amount)
			transferred = max_amount - src.amount

		//transfer the amount
		modify_amount(transferred)
		other.modify_amount(-transferred, 0)

		//just merge the two if they are low enough
		if(other.amount <= 0)
			user.drop_item()
			qdel(other)

		update_icon()

		to_chat(user,"\icon[src]<span class='info'>You transfer [transferred] to [src].</span>")
		return

	return ..()

/obj/item/weapon/grenade/brute_shot/update_icon()
	//clear our overlays
	overlays.Cut()

	//update the icon
	var/grensleft = amount
	while(grensleft > 0)

		//create an image of a grenade and tweak it a bit
		var/image/gren = image('code/modules/halo/icons/species/jiralhanae_obj.dmi', "bruteshot_gren")
		var/matrix/M = matrix()
		M.Translate(rand(-8, 8), rand(-8, 8))
		M.Turn(pick(0,45))
		gren.transform = M

		//add it to our overlays
		src.overlays += gren

		grensleft -= 1
