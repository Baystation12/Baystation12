/obj/item/gun/projectile/boltloader // This category of guns needs their bolt open to load more ammo.
	abstract_type = /obj/item/gun/projectile/boltloader
	name = "master boltloader object"
	desc = "You should not see this."

	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'

	caliber = CALIBER_RIFLE
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING

	rackdelay = 10
	force = 10


/obj/item/gun/projectile/boltloader/heavysniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 was originally designed to be used against \
			armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease."

	icon = 'icons/obj/guns/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper" //sort of placeholder
	wielded_item_state = "heavysniper-wielded" //sort of placeholder

	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'

	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	caliber = CALIBER_ANTIMATERIAL
	bulk = GUN_BULK_HEAVY_RIFLE + 2
	hold_open = FALSE

	ammo_type = /obj/item/ammo_casing/shell
	screen_shake = 2 //extra kickback
	max_shells = 1
	one_hand_penalty = 6
	accuracy = -2
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	fire_delay = 12
	rackdelay = 15


/obj/item/gun/projectile/boltloader/on_update_icon()
	..()
	if(bolt_open)
		icon_state = "[initial(icon_state)]-open"
		wielded_item_state = "[initial(wielded_item_state)]-open"
	else
		icon_state = "[initial(icon_state)]"
		wielded_item_state = initial(wielded_item_state)


/obj/item/gun/projectile/boltloader/handle_post_fire(mob/user, atom/target, pointblank=0, reflex=0)
	..()
	if (handle_casings != HOLD_CASINGS)
		return
	if (!user?.skill_check(SKILL_WEAPONS, SKILL_MASTER))
		return
	to_chat(user, SPAN_NOTICE("You work the bolt open with a reflexive motion, ejecting [chambered]!"))
	open_bolt(TRUE)


/obj/item/gun/projectile/boltloader/attack_self(mob/user as mob)
	if (!is_held_twohanded(user) || is_jammed)
		var/end = ""
		var/operation = ""
		var/floor = ""
		if (bolt_open)
			end = "barrel"
			operation = "pushing"
		else
			end = "butt"
			operation = "pulling"
		floor = get_turf(user)
		if (is_space_turf(floor) || !has_gravity(floor))
			to_chat(user, SPAN_WARNING("You need gravity and a stable surface to mortar the bolt!"))
			return
		user.visible_message(
			SPAN_WARNING("\The [user] presses the [end] of \the [src] into \the [floor] and begins [operation] on the bolt with one hand..."),
			SPAN_WARNING("You press the [end] of \the [src] into \the [floor] and begin [operation] on the bolt with one hand...")
			)
		if (!do_after(user, round((50/(user.get_skill_value(SKILL_WEAPONS))), 1), src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_SHOW_PROGRESS))
			return
	if (!bolt_open)
		var/obj/item/ammo_casing/ejected = open_bolt(TRUE)
		if (bolt_open)
			if (ejected)
				to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [ejected]!"))
			else
				to_chat(user, SPAN_NOTICE("You work the bolt open."))
		playsound(loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, TRUE)
	else
		close_bolt(TRUE)
		if (!bolt_open)
			to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, TRUE)

	recentrack = world.time
	autorackdelay = 1 // Reset auto-rack delay.
	add_fingerprint(user)
	update_icon()


/obj/item/gun/projectile/boltloader/special_check(mob/user)
	if (bolt_open)
		if (!user.skill_check(SKILL_WEAPONS, SKILL_TRAINED))
			to_chat(user, SPAN_WARNING("You can't fire \the [src] while the bolt is open!"))
			return FALSE

		autorackdelay = 6 - user.skillset.get_value(SKILL_WEAPONS)

		if (!(world.time >= recentrack + (rackdelay * autorackdelay)))
			to_chat(user, SPAN_WARNING("You can't rack the bolt on \the [src] this quickly!"))
			autorackdelay = 1 // Reset auto-rack delay.

		else
			attack_self(user) // Process auto-rack.
		return FALSE

	return ..()


/obj/item/gun/projectile/boltloader/load_ammo(obj/item/ammo, mob/user)
	if (!bolt_open)
		USE_FEEDBACK_FAILURE("\The [src]'s bolt needs to be open before you can reload it.")
		return

	return ..()


/obj/item/gun/projectile/boltloader/unload_ammo(mob/user, allow_dump = TRUE)
	if (!bolt_open)
		USE_FEEDBACK_FAILURE("\The [src]'s bolt needs to be open before you can unload it.")
		return

	..()


/obj/item/gun/projectile/boltloader/close_bolt(manual)
	if (!manual && hold_open && !ammo_magazine && !length(loaded)) //automatic boltloaders will stay open, even with no magazine
		return
	..()


/obj/item/gun/projectile/boltloader/boltaction
	name = "bolt action rifle"
	desc = "An old bolt action rifle from some forgotten war, still commonplace among farmers and colonists as an anti-varmint rifle."

	icon = 'icons/obj/guns/boltaction.dmi'
	icon_state = "boltaction"
	item_state = "boltaction"
	wielded_item_state = "boltaction-wielded"

	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_COMBAT = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	hold_open = FALSE

	ammo_type = /obj/item/ammo_casing/rifle
	max_shells = 5
	accuracy = 4
	scope_zoom = 0
	scoped_accuracy = 0


/obj/item/gun/projectile/boltloader/garand
	name = "garand rifle"
	desc = "The rugged garand is a old semi-automatic weapon popular on the frontier worlds. PING!"

	icon = 'icons/obj/guns/garand.dmi'
	icon_state = "garand"
	item_state = "garand"
	wielded_item_state = "garand-wielded"

	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/garand_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	auto_eject_sound = 'sound/weapons/guns/interaction/garand_magout.ogg'

	origin_tech = list(TECH_COMBAT = 2)
	handle_casings = EJECT_CASINGS
	load_method = MAGAZINE
	bulk = GUN_BULK_HEAVY_RIFLE
	auto_eject = TRUE

	magazine_type = /obj/item/ammo_magazine/iclipr
	allowed_magazines = list(/obj/item/ammo_magazine/iclipr)
	one_hand_penalty = 9
	accuracy_power = 5
	accuracy = 2


/obj/item/gun/projectile/boltloader/garand/load_ammo(obj/item/A, mob/user)
	..()

	if (!istype(A, /obj/item/ammo_magazine))
		return
	var/old_chance = jam_chance
	var/obj/item/ammo_magazine/magazine = A
	if (length(magazine.stored_ammo))
		if (prob(user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_BASIC, 0.5))) //watch out for garand thumb
			to_chat(user, "\The [src]'s bolt snaps shut as you insert \the [A], catching your thumb.")
			jam_chance += 20
		else
			to_chat(user, "\The [src]'s bolt snaps shut as you insert \the [A].")
	close_bolt(FALSE)
	jam_chance = old_chance


/obj/item/gun/projectile/boltloader/semistrip
	name = "carbine rifle"
	desc = "An old semi-automatic carbine chambered in large pistol rounds, this thing looks older than the SCG."

	icon = 'icons/obj/guns/semistrip.dmi'
	icon_state = "semistrip"
	item_state = "semistrip"
	wielded_item_state = "semistrip-wielded"

	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_PISTOL_MAGNUM
	handle_casings = EJECT_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER

	ammo_type = /obj/item/ammo_casing/pistol/magnum
	fire_delay = 2
	one_hand_penalty = 8
	max_shells = 10
	accuracy = 1
