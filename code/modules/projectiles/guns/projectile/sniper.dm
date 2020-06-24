/obj/item/weapon/gun/projectile/heavysniper
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
	var/bolt_open = 0
	wielded_item_state = "heavysniper-wielded" //sort of placeholder
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	fire_delay = 12

/obj/item/weapon/gun/projectile/heavysniper/on_update_icon()
	..()
	if(bolt_open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/heavysniper/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(user && user.skill_check(SKILL_WEAPONS, SKILL_PROF))
		to_chat(user, "<span class='notice'>You work the bolt open with a reflexive motion, ejecting [chambered]!</span>")
		unload_shell()

/obj/item/weapon/gun/projectile/heavysniper/proc/unload_shell()
	if(chambered)
		if(!bolt_open)
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
			bolt_open = 1
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/weapon/gun/projectile/heavysniper/attack_self(mob/user as mob)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			unload_shell()
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()


/obj/item/weapon/gun/projectile/heavysniper/boltaction
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
