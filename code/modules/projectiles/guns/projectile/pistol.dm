
/obj/item/weapon/gun/projectile/pistol
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = /obj/item/ammo_magazine/pistol
	accuracy_power = 7
	var/empty_icon = TRUE  //If it should change icon when empty
	var/ammo_indicator = FALSE

/obj/item/weapon/gun/projectile/pistol/on_update_icon()
	..()
	if(empty_icon)
		if(ammo_magazine && ammo_magazine.stored_ammo.len)
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)]-e"
	if(ammo_indicator)
		if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
			overlays += image(icon, "ammo_bad")
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			overlays += image(icon, "ammo_warn")
			return
		else
			overlays += image(icon, "ammo_ok")
	
/obj/item/weapon/gun/projectile/pistol/military
	name = "military pistol"
	desc = "The Hephaestus Industries P20 - a mass produced kinetic sidearm in widespread service with the SCGDF."
	magazine_type = /obj/item/ammo_magazine/pistol/double
	allowed_magazines = /obj/item/ammo_magazine/pistol/double
	icon = 'icons/obj/guns/military_pistol.dmi'
	icon_state = "military"
	item_state = "secgundark"
	safety_icon = "safety"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_delay = 7
	ammo_indicator = TRUE

/obj/item/weapon/gun/projectile/pistol/military/alt
	desc = "The HelTek Optimus, best known as the standard-issue sidearm for the ICCG Navy."
	icon = 'icons/obj/guns/military_pistol2.dmi'
	icon_state = "military-alt"
	safety_icon = "safety"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	fire_delay = 8

/obj/item/weapon/gun/projectile/pistol/sec
	name = "pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"
	safety_icon = "safety"
	magazine_type = /obj/item/ammo_magazine/pistol/rubber
	accuracy = -1
	fire_delay = 6
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)

/obj/item/weapon/gun/projectile/pistol/sec/lethal
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/weapon/gun/projectile/pistol/magnum_pistol
	name = "magnum pistol"
	desc = "The HelTek Magnus, a robust Terran handgun that uses high-caliber ammo."
	icon = 'icons/obj/guns/magnum_pistol.dmi'
	icon_state = "magnum"
	item_state = "magnum"
	safety_icon = "safety"
	force = 9
	caliber = CALIBER_PISTOL_MAGNUM
	fire_delay = 12
	screen_shake = 2
	magazine_type = /obj/item/ammo_magazine/magnum
	allowed_magazines = /obj/item/ammo_magazine/magnum
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	accuracy = 2
	one_hand_penalty = 2
	bulk = 3
	ammo_indicator = TRUE

/obj/item/weapon/gun/projectile/pistol/throwback
	name = "pistol"
	desc = "A product of one of thousands of illegal workshops from around the galaxy. Often replicas of ancient Earth handguns, these guns are usually found in hands of frontier colonists and pirates."
	icon = 'icons/obj/guns/pistol_throwback.dmi'
	icon_state = "pistol1"
	magazine_type = /obj/item/ammo_magazine/pistol/throwback
	accuracy_power = 5
	one_hand_penalty = 2
	fire_delay = 7
	caliber = CALIBER_PISTOL_ANTIQUE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	var/base_icon = "pistol1"

/obj/item/weapon/gun/projectile/pistol/throwback/Initialize()
	. = ..()
	base_icon = "pistol[rand(1,4)]"
	update_icon()

/obj/item/weapon/gun/projectile/pistol/throwback/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = base_icon
	else
		icon_state = "[base_icon]-e"

/obj/item/weapon/gun/projectile/pistol/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds."
	icon = 'icons/obj/guns/gyropistol.dmi'
	icon_state = "gyropistol"
	max_shells = 8
	caliber = CALIBER_GYROJET
	origin_tech = list(TECH_COMBAT = 3)
	magazine_type = /obj/item/ammo_magazine/gyrojet
	allowed_magazines = /obj/item/ammo_magazine/gyrojet
	handle_casings = CLEAR_CASINGS	//the projectile is the casing
	fire_delay = 25
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	empty_icon = FALSE

/obj/item/weapon/gun/projectile/pistol/gyropistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/weapon/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "pistol"
	item_state = null
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 0
	fire_delay = 4
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ESOTERIC = 2)
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/weapon/gun/projectile/pistol/holdout/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = initial(silenced)
			w_class = initial(w_class)
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/holdout/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		if(!user.unEquip(I, src))
			return//put the silencer into the gun
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/holdout/on_update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL
