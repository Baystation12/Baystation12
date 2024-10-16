/obj/item/gun/projectile/boltloader
	slot_flags = SLOT_BACK
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'

/obj/item/gun/projectile/boltloader/heavysniper //this category of guns needs their bolt open to load more ammo
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to be used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease."
	icon = 'icons/obj/guns/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper" //sort of placeholder
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	caliber = CALIBER_ANTIMATERIAL
	screen_shake = 2 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/shell
	one_hand_penalty = 6
	accuracy = -2
	bulk = 8
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	wielded_item_state = "heavysniper-wielded" //sort of placeholder
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	fire_delay = 12
	hold_open = FALSE

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
	if(handle_casings == HOLD_CASINGS)
		if(user && user.skill_check(SKILL_WEAPONS, SKILL_MASTER))
			to_chat(user, SPAN_NOTICE("You work the bolt open with a reflexive motion, ejecting [chambered]!"))
			open_bolt(manual = TRUE)

/obj/item/gun/projectile/boltloader/attack_self(mob/user as mob)
	if (world.time >= recentrack + rackdelay)
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
			var/obj/item/ammo_casing/ejected = open_bolt(manual = TRUE)
			if (bolt_open)
				if (ejected)
					to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [ejected]!"))
				else
					to_chat(user, SPAN_NOTICE("You work the bolt open."))
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
		else
			close_bolt(manual = TRUE)
			if (!bolt_open)
				to_chat(user, SPAN_NOTICE("You work the bolt closed."))
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		add_fingerprint(user)
		update_icon()

/obj/item/gun/projectile/boltloader/special_check(mob/user)
	if (bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/boltloader/load_ammo(obj/item/A, mob/user)
	if (!bolt_open)
		to_chat(user, SPAN_DANGER("You can't load \the [src] without opening the bolt first!"))
		return
	..()

/obj/item/gun/projectile/boltloader/unload_ammo(mob/user, allow_dump=1)
	if (!bolt_open)
		to_chat(user, SPAN_DANGER("You can't unload \the [src] without opening the bolt first!"))
		return
	..()

/obj/item/gun/projectile/boltloader/close_bolt(manual)
	if (!manual && hold_open)
		if (!ammo_magazine && !length(loaded)) //automatic boltloaders will stay open, even with no magazine
			return
	..()


/obj/item/gun/projectile/boltloader/boltaction
	name = "bolt action rifle"
	desc = "An old bolt action rifle from some forgotten war, still commonplace among farmers and colonists as an anti-varmint rifle."
	icon = 'icons/obj/guns/boltaction.dmi'
	icon_state = "boltaction"
	item_state = "boltaction"
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 5
	accuracy = 4
	scope_zoom = 0
	scoped_accuracy = 0
	wielded_item_state = "boltaction-wielded"
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	hold_open = FALSE

/obj/item/gun/projectile/sniper/panther //semi-automatic only
	name = "marksman rifle"
	desc = "An SD-Panther. It is a simple and durable rifle made of stamped steel manufactured by Novaya Zemlya Arms for the Confederation Navy. \
	While it lacks the burst fire of other military rifles, it's exceptionally accurate and has a powerful optic."
	icon = 'icons/obj/guns/terran_rifle.dmi'
	icon_state = "dmr"
	item_state = "dmr"
	fire_delay = 8
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_ESOTERIC = 5)
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle
	allowed_magazines = /obj/item/ammo_magazine/rifle
	one_hand_penalty = 8
	scoped_accuracy = 8
	scope_zoom = 1
	accuracy_power = 8
	accuracy = 4
	bulk = GUN_BULK_RIFLE
	wielded_item_state = "dmr-wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

/obj/item/gun/projectile/sniper/panther/on_update_icon()
	if(ammo_magazine)
		icon_state = "dmr"
	else
		icon_state = "dmr-empty"
	..()

/obj/item/gun/projectile/boltloader/garand
	name = "garand rifle"
	desc = "The rugged garand is a old semi-automatic weapon popular on the frontier worlds. PING!"
	icon = 'icons/obj/guns/garand.dmi'
	icon_state = "garand"
	item_state = "garand"
	origin_tech = list(TECH_COMBAT = 2)
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = CALIBER_RIFLE
	slot_flags = SLOT_BACK
	handle_casings = EJECT_CASINGS
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/iclipr
	allowed_magazines = /obj/item/ammo_magazine/iclipr
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/guns/interaction/garand_magout.ogg'
	one_hand_penalty = 9
	accuracy_power = 5
	accuracy = 2
	bulk = GUN_BULK_HEAVY_RIFLE
	wielded_item_state = "garand-wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/garand_magout.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'

/obj/item/gun/projectile/boltloader/garand/load_ammo(obj/item/A, mob/user)
	..()
	if (istype(A, /obj/item/ammo_magazine))
		var/old_chance = jam_chance
		var/obj/item/ammo_magazine/magazine = A
		if (length(magazine.stored_ammo))
			if (prob(user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_EXPERIENCED, 0.5))) //watch out for garand thumb
				to_chat(user, "\The [src]'s bolt snaps shut as you insert \the [A], catching your thumb.")
				jam_chance += 15
			else
				to_chat(user, "\The [src]'s bolt snaps shut as you insert \the [A].")
		close_bolt(manual = FALSE)
		jam_chance = old_chance

/obj/item/gun/projectile/boltloader/semistrip
	name = "carbine rifle"
	desc = "An old semi-automatic carbine chambered in large pistol rounds, this thing looks older than the SCG."
	icon = 'icons/obj/guns/semistrip.dmi'
	icon_state = "semistrip"
	item_state = "semistrip"
	w_class = ITEM_SIZE_HUGE
	force = 10
	origin_tech = list(TECH_COMBAT = 2)
	slot_flags = SLOT_BACK
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	handle_casings = EJECT_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	fire_delay = 2
	one_hand_penalty = 8
	max_shells = 10
	accuracy = 1
	wielded_item_state = "semistrip-wielded"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
