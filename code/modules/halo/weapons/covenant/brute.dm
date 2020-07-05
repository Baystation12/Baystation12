


/* SPIKE GRENADE */

/obj/item/weapon/grenade/frag/spike
	name = "spike grenade"
	desc = "This device embeds itself into soft targets and explodes into a hail of deadly shards. Works well as a melee weapon."
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_state = "spikegren0"
	icon_override = 'code/modules/halo/weapons/icons/jiralhanae_gear.dmi'
	item_state = "spikegren1"
	item_state_slots = list(slot_l_hand_str = "spnade", slot_r_hand_str = "spnade")

	force = 35
	armor_penetration = 35

	sharp = 1
	edge = 1

	//less explosive power but more spikes
	explosion_size = 0
	num_fragments = 250 //50 more than a high yield frag bomb

	lunge_dist = 3

/obj/item/weapon/grenade/frag/spike/can_embed()
	return 0

/obj/item/weapon/grenade/frag/spike/activate(mob/user as mob)
	. = ..()
	spawn(30)
		playsound(user, 'code/modules/halo/sounds/Spikenade.ogg', 60, 1)


/obj/item/weapon/grenade/frag/spike/throw_at(atom/target, range, speed, thrower)
	icon_state = "spikegren_spin"
	. = ..()
	icon_state = "spikegren1"



/* SPIKER */

#define CASELESS 4

/obj/item/weapon/gun/projectile/spiker
	name = "Type-25 Spiker Carbine"
	desc = "A sidearm with two wicked blades curving out from under the barrel."
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_override = 'code/modules/halo/weapons/icons/jiralhanae_gear.dmi'
	icon_state = "spiker"
	item_state = "blank"
	slot_flags = SLOT_BACK | SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/spiker
	allowed_magazines = /obj/item/ammo_magazine/spiker
	caliber = "spiker"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE
	handle_casings = CASELESS
	fire_sound = 'code/modules/halo/sounds/Spikershotfire.ogg'
	burst = 3
	edge = 1
	sharp = 1
	force = 40
	is_heavy = 1
	armor_penetration = 35
	accuracy = -1
	dispersion = list(0.2,0.3,0.5)
	//reload_sound = 'code/modules/halo/sounds/Spikershotfire.ogg'
	item_state_slots = list(slot_l_hand_str = "spiker", slot_r_hand_str = "spiker")
	lunge_dist = 3

/obj/item/weapon/gun/projectile/spiker/update_icon()
	if(ammo_magazine)
		icon_state = "spiker"
	else
		icon_state = "spiker_unloaded"
	. = ..()

/obj/item/weapon/gun/projectile/spiker/can_embed()
	return 0

/obj/item/ammo_magazine/spiker
	name = "spiker magazine"
	desc = "A 30 round magazine for the Jiralhanae spiker"
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_state = "spiker_mag"
	item_state = "blank"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/spiker
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "spiker"
	max_ammo = 30

/obj/item/ammo_casing/spiker
	desc = "A spike round casing."
	caliber = "spiker"
	projectile_type = /obj/item/projectile/bullet/spiker

/obj/item/projectile/bullet/spiker
	name = "Spike"
	armor_penetration = 20
	damage = 20

/obj/item/projectile/bullet/spiker/on_hit(var/mob/living/carbon/human/L, var/blocked, var/def_zone )
	if(blocked >= 100 || !istype(L))
		return
	var/obj/shard = new /obj/item/weapon/material/shard/shrapnel
	var/obj/item/organ/external/embed_organ = pick(L.organs)
	shard.name = "Spike shrapnel"
	embed_organ.embed(shard)
	. = ..()

#undef CASELESS



/* MAULER */

/obj/item/weapon/gun/projectile/mauler
	name = "Type-52 \"Mauler\""
	desc = "A single shot, short range Jiralhanae sidearm with a powerful punch. Has a blade underneath."
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_override = 'code/modules/halo/weapons/icons/jiralhanae_gear.dmi'
	icon_state = "mauler"
	item_state = "blank"
	slot_flags = SLOT_BACK | SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/mauler
	allowed_magazines = /obj/item/ammo_magazine/mauler
	load_method = MAGAZINE
	caliber = "mauler"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'code/modules/halo/sounds/mauler_firing.ogg'
	edge = 1
	sharp = 1
	force = 40
	is_heavy = 1
	armor_penetration = 35
	accuracy = -1
	dispersion = list(0.45)
	w_class = ITEM_SIZE_NORMAL
	item_state_slots = list(slot_l_hand_str = "mauler", slot_r_hand_str = "mauler")
	lunge_dist = 3

/obj/item/weapon/gun/projectile/mauler/update_icon()
	if(ammo_magazine)
		icon_state = "mauler"
	else
		icon_state = "mauler_unloaded"
	. = ..()

/obj/item/weapon/gun/projectile/mauler/can_embed()
	return 0

/obj/item/ammo_magazine/mauler
	name = "mauler magazine"
	desc = "A 5 round magazine for the Jiralhanae mauler"
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_state = "mauler_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/mauler
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "mauler"
	max_ammo = 5

/obj/item/ammo_casing/mauler
	desc = "A mauler round casing."
	caliber = "mauler"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun

/*
/obj/item/projectile/bullet/mauler
	damage = 75
/obj/item/projectile/bullet/mauler/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	. = ..()
	if(.)
		//reduced damage from further away
		damage -= get_dist(starting, src) * 10*/



/* GRAVITY HAMMER */

/obj/item/weapon/grav_hammer
	name = "Type-2 Energy Weapon/Hammer"
	desc = "A long haft and a heavy head with a tungsten-alloy blade on the reverse end. Within the head is a short-range shock-field-generating gravity drive for extra punch."
	icon = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_obj_heavy.dmi'
	icon_override = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_gear.dmi'
	icon_state = "gravhammer"
	item_state = "blank"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	force = 50 //Less than sword due to afterattack ability
	edge = 0
	sharp = 0
	armor_penetration = 35
	lunge_dist = 2
	hitsound = 'code/modules/halo/sounds/gravhammer.ogg'
	sprite_sheets = list(
	"Jiralhanae" = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_gear.dmi',
	)
	item_state_slots = list(slot_l_hand_str = "gravhammer", slot_r_hand_str = "gravhammer", slot_back_str = "back_hammer")

/obj/item/weapon/grav_hammer/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	if(get_dist(A,user) > 1)
		return

	var/atom/throw_target = get_edge_target_turf(A, get_dir(user, A))
	if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		AM.throw_at(throw_target, 6, 4, user)

	for(var/atom/movable/M in range(A,1))
		if(M == user)
			continue

		if(M == A)
			continue

		if(!M.anchored)
			M.throw_at(throw_target, 3, 4, user)

		if(isliving(M))
			var/mob/living/victim = M
			victim.hit_with_weapon(src, user, force/2)


/obj/item/weapon/grav_hammer/gravless
	name = "Type-2 Energy Weapon/Hammer, Depowered"
	desc = "A long haft and a heavy head with a tungsten-alloy blade on the reverse end. The short-range gravity field in the head of the weapon has been disabled."
	force = 45

/obj/item/weapon/grav_hammer/gravless/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	return

/* BRUTE SHOT */

/obj/item/weapon/gun/launcher/grenade/brute_shot
	name = "Type-25 \"Brute Shot\" Grenade Launcher"
	desc = "A hip fired fast firing launcher for HE munitions with a curved backwards facing blade mounted to its underside."
	icon = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_obj_heavy.dmi'
	icon_override = 'code/modules/halo/covenant/species/jiralhanae/jiralhanae_gear.dmi'
	icon_state = "bruteshot"
	item_state = "blank"
	pump_sound = null
	max_grenades = 6
	one_hand_penalty = -1
	fire_sound = 'code/modules/halo/sounds/bruteshotfire.ogg'
	var/reload_sound = 'code/modules/halo/sounds/bruteshotreload.ogg'
	var/reload_time = 30
	force = 50
	edge = 1
	armor_penetration = 35
	item_state_slots = list(slot_l_hand_str = "bruteshot", slot_r_hand_str = "bruteshot", slot_back_str = "bruteshot back")
	advanced_covenant = 1

	whitelisted_grenades = list(/obj/item/weapon/grenade/brute_shot)

	lunge_dist = 3

/obj/item/weapon/gun/launcher/grenade/brute_shot/can_embed()
	return 0

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
	icon = 'code/modules/halo/weapons/icons/jiralhanae_obj.dmi'
	icon_state = "bruteshot_belt"
	var/fire_sound = null
	det_time = 50
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

	explosion(get_turf(src), 0, 0, max(amount / 2, 2), max(amount / 2, 3), 0)

	for(var/atom/movable/M in range(src,1))
		if(M == src)
			continue

		if(!M.anchored)
			var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
			M.throw_at(throw_target, 1, 4, src)
	. = ..()
	qdel(src)

/obj/item/weapon/grenade/brute_shot/proc/modify_amount(var/transferred, var/delete_if_empty = 1)
	amount += transferred

	//update the throw range... more = heaver = shorter range
	throw_range = 10
	if(amount > 1)
		if(amount > 3)
			throw_range = 2
		else
			throw_range = 3

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
		var/image/gren = image('code/modules/halo/weapons/icons/jiralhanae_obj.dmi', "bruteshot_gren")
		var/matrix/M = matrix()
		M.Translate(rand(-8, 8), rand(-8, 8))
		M.Turn(pick(0,45))
		gren.transform = M

		//add it to our overlays
		src.overlays += gren

		grensleft -= 1

/obj/item/weapon/grenade/toxic_gas
	name = "toxic gas grenade"
	icon_state = "banana"
	item_state = "grenade"
	desc = "A chemical smoke grenade made from gasses toxic to carbon based lifeforms."

/obj/item/weapon/grenade/toxic_gas/New()
	. = ..()
	create_reagents(500)
	reagents.add_reagent(/datum/reagent/toxin/phoron, 500)

/obj/item/weapon/grenade/toxic_gas/detonate()
	playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)

	var/datum/effect/effect/system/smoke_spread/chem/poison_gas = new()
	poison_gas.set_up(reagents, 10, 0, src.loc)
	poison_gas.start()
	for(var/mob/living/M in range(7, src))
		if(M.wear_mask && (M.wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT))
			continue
		M.adjustToxLoss(20)

	if(istype(loc, /mob/living/carbon))		//drop dat grenade if it goes off in your hand
		var/mob/living/carbon/C = loc
		C.drop_from_inventory(src)
		C.throw_mode_off()
	qdel(src)

/obj/item/weapon/grenade/toxic_gas/chlorine
	name = "chlorine gas grenade"

/obj/item/weapon/grenade/toxic_gas/sulfur_dioxide
	name = "sulfur dioxide gas grenade"

/obj/item/weapon/grenade/toxic_gas/carbon_monodixe
	name = "carbon monodixe gas grenade"
