/obj/item/weapon/gun/projectile/colt
	name = "\improper Colt M1911"
	desc = "A cheap Martian knock-off of a Colt M1911."
	magazine_type = /obj/item/ammo_magazine/c45m
	icon_state = "colt"
	caliber = ".45"
	origin_tech = "combat=2;materials=2"
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/colt/detective
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/c45m/rubber

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
		return 0

	var/input = stripped_input(usr,"What do you want to name the gun?", ,"", MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/sec
	desc = "A NanoTrasen designed sidearm, found pretty much everywhere humans are. Uses .45 rounds."
	name = "\improper NT Mk58"
	icon_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/c45m/rubber
	caliber = ".45"
	origin_tech = "combat=2;materials=2"
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/sec/flash
	name = "\improper NT Mk58 signal pistol"
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/sec/wood
	desc = "A Nanotrasen designed sidearm, this one has a sweet wooden grip. Uses .45 rounds."
	name = "\improper Custom NT Mk58"
	icon_state = "secgundark"

/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3
	caliber = ".45"
	silenced = 1
	origin_tech = "combat=2;materials=2;syndicate=8"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/weapon/gun/projectile/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo"
	icon_state = "deagle"
	item_state = "deagle"
	force = 14.0
	caliber = ".50"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a50
	auto_eject = 1

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'



/obj/item/weapon/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	max_shells = 8
	caliber = "75"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = "combat=3"
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a75
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/gyropistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/weapon/gun/projectile/pistol
	name = "\improper Stechtkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	item_state = null
	w_class = 2
	caliber = "9mm"
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm

/obj/item/weapon/gun/projectile/pistol/flash
	name = "\improper Stechtkin signal pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		w_class = 3
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2
