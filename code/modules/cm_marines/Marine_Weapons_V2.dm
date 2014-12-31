///**************COLONIAL MARINES WEAPON/VENDING/FLASHLIGHT LAST EDIT: 21DEC2014 BY APOPHIS7755**************///



///***Bullets***///
/obj/item/projectile/bullet/m4a3 //M4A3 Pistol
	damage = 25

/obj/item/projectile/bullet/m44m //44 Magnum Peacemaker
	damage = 45

/obj/item/projectile/bullet/m39 // M39 SMG
	damage = 20

/obj/item/projectile/bullet/m41 //M41 Assault Rifle
	damage = 30

/obj/item/projectile/bullet/m37 //M37 Pump Shotgun
	damage = 80

///***Ammo***///

/obj/item/ammo_casing/m4a3 //45 Pistol
	desc = "A .45 special bullet casing."
	caliber = "45s"
	projectile_type = "/obj/item/projectile/bullet/m4a3"

/obj/item/ammo_casing/m44m //44 Magnum Peacemaker
	desc = "A 44 Magnul bullet casing."
	caliber = "38s"
	projectile_type = "/obj/item/projectile/bullet/m44m"

/obj/item/ammo_casing/m39 // M39 SMG
	desc = "A .9mm special bullet casing."
	caliber = "9mms"
	projectile_type = "/obj/item/projectile/bullet/m39"

/obj/item/ammo_casing/m41 //M41Assault Rifle
	desc = "A 10mm special bullet casing."
	caliber = "10mms"
	projectile_type = "/obj/item/projectile/bullet/m41"

/obj/item/ammo_casing/m37 //M37 Pump Shotgun
	name = "Shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	caliber = "12gs"
	projectile_type = "/obj/item/projectile/bullet/m37"

///***Ammo Boxes***///

/obj/item/ammo_magazine/m4a3 //45 Pistol
	name = "Magazine (.45)"
	desc = "A magazine with .45 ammo"
	icon_state = ".45a"
	ammo_type = "/obj/item/ammo_casing/m4a3"
	max_ammo = 12

/obj/item/ammo_magazine/m4a3e/empty //45 Pistol
	icon_state = ".45a0"
	max_ammo = 0

/obj/item/weapon/gun/projectile/pistol/m4a3/New() //45 Pistol
	..()
	empty_mag = new /obj/item/ammo_magazine/m4a3e/empty(src) //45 Pistol
	return

/obj/item/ammo_magazine/m44m // 44 Magnum Peacemaker
	name = "Speed loader (44 Mag)"
	desc = "A 44 Magnum speed loader"
	icon_state = "38"
	ammo_type = "/obj/item/ammo_casing/m44m"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/m39 // M39 SMG
	name = "Magazine (9mm-S)"
	desc = "A 9mm special magazine"
	icon_state = "9x19p-8"
	ammo_type = "/obj/item/ammo_casing/m39"
	max_ammo = 30

/obj/item/ammo_magazine/m39/empty // M39 SMG
	icon_state = "9x19p-0"
	max_ammo = 0

/obj/item/ammo_magazine/m41 //M41 Assault Rifle
	name = "magazine (10mm-S)"
	desc = "A 10mm special magazine"
	icon_state = "m309a"
	ammo_type = "/obj/item/ammo_casing/m41"
	max_ammo = 30

/obj/item/ammo_magazine/m41/empty //Assault Rifle
	max_ammo = 0
	icon_state = "m309a0"


/obj/item/weapon/storage/box/m37 //M37 Shotgun
	name = "box of shotgun shells"
	desc = "It has a picture of a M37 shotgun on the side."
	icon_state = "shells"
	w_class = 2 //Can fit in belts
	New()
		..()
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)


///***Pistols***///

/obj/item/weapon/gun/projectile/pistol/m4a3 //45 Pistol
	name = "\improper M4A3 Service Pistol"
	desc = "M4A3 Service Pistol. Uses .45 special rounds."
	icon_state = "colt"
	max_shells = 12
	caliber = "45s"
	ammo_type = "/obj/item/ammo_casing/m4a3"
	recoil = 0

/obj/item/weapon/gun/projectile/pistol/m4a3/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
	return

/obj/item/weapon/gun/projectile/m44m //mm44 Magnum Peacemaker
	name = "\improper 44 Magnum"
	desc = "A 44 Magnum revolver. Uses 44 Magnum rounds"
	icon_state = "mateba"
	caliber = "38s"
	ammo_type = "/obj/item/ammo_casing/m44m"


///***SMGS***///

/obj/item/weapon/gun/projectile/automatic/m39 // M39 SMG
	name = "\improper M39 SMG"
	desc = " Armat Battlefield Systems M39 SMG. Uses 9mm rounds."
	icon_state = "smg"
	item_state = "c20r"
	max_shells = 30
	caliber = "9mms"
	ammo_type = "/obj/item/ammo_casing/m39"
	fire_delay = 0
	force = 9.0

	isHandgun()
		return 0


///***RIFLES***///

/obj/item/weapon/gun/projectile/Assault/m41 //M41 Assault Rifle
	name = "\improper M41A Rifle"
	desc = "M41A Pulse Rifle. Uses 10mm special ammunition."
	icon_state = "m41a0"
	item_state = "m41a"
	w_class = 3.0
	max_shells = 30
	caliber = "10mms"
	icon = 'icons/Marine/marine-weapons.dmi'
	ammo_type = "/obj/item/ammo_casing/m41"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = 2
	force = 10.0
	fire_delay = 4
	slot_flags = SLOT_BACK

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/m41/empty(src)
		update_icon()
		return

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return

	update_icon()
		..()
		if(empty_mag)
			icon_state = "m41a"
		else
			icon_state = "m41a0"
		return


///***SHOTGUNS***///

/obj/item/weapon/gun/projectile/shotgun/pump/m37 //M37 Pump Shotgun
	name = "\improper M37 Pump Shotgun"
	desc = "Colonial Marine M37 Pump Shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	caliber = "12gs"
	ammo_type = "/obj/item/ammo_casing/m37"
	recoil = 1
	force = 10.0


///***MELEE/THROWABLES***///

/obj/item/weapon/combat_knife
	name = "\improper Marine Combat Knife"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "combat_knife"
	item_state = "knife"
	desc = "When shits gets serious! You can slide this knife into your boots."
	flags = FPRINT | TABLEPASS | CONDUCT
	sharp = 1
	force = 25
	w_class = 1.0
	throwforce = 20
	throw_speed = 3
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)


///******MARINE VENDOR******///

/obj/machinery/vending/marine
	name = "ColMarTech"
	desc = "A marine equipment vendor"
	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 25,

					/obj/item/weapon/gun/projectile/pistol/m4a3 = 5,
					/obj/item/weapon/gun/projectile/m44m = 5,
					/obj/item/weapon/gun/projectile/automatic/m39 = 5,
					/obj/item/weapon/gun/projectile/Assault/m41 = 5,
					/obj/item/weapon/gun/projectile/shotgun/pump/m37 = 5,


					/obj/item/ammo_magazine/m4a3 = 25,
					/obj/item/ammo_magazine/m44m =25,
					/obj/item/ammo_magazine/m39 = 25,
					/obj/item/ammo_magazine/m41 = 25,
					/obj/item/weapon/storage/box/m37 = 25,
					/obj/item/ammo_magazine/a762 = 10,
					/obj/item/ammo_magazine/a12mm = 25,


					/obj/item/weapon/combat_knife = 5,
					/obj/item/device/flashlight/flare = 10,
					)
	contraband = list(/*bj/item/weapon/storage/fancy/donut_box = 5,
					/obj/item/ammo_magazine/a357 = 5,
					/obj/item/ammo_magazine/a50 = 5,*/
					)
	premium = list(
				/obj/item/ammo_magazine/a762 = 5,
				)
	prices = list(/*/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 1,
					/obj/item/ammo_magazine/c38 = 6,
					/obj/item/weapon/storage/box/beanbags = 7,
					/obj/item/ammo_magazine/mc9mm = 20,
					/obj/item/weapon/storage/box/shotguns = 42,
					/obj/item/ammo_magazine/a12mm = 50,
					/obj/item/ammo_magazine/c45 = 60,
					/obj/item/ammo_magazine/c9mm = 75,
					/obj/item/weapon/gun/projectile/detective = 60,
					/obj/item/weapon/gun/projectile/silenced = 200,
					/obj/item/weapon/gun/projectile/pistol = 240,
					/obj/item/weapon/gun/projectile/automatic/mini_uzi = 320,
					/obj/item/weapon/gun/projectile/automatic = 450,
					/obj/item/weapon/gun/projectile/automatic/c20r = 500,
					/obj/item/weapon/gun/projectile/shotgun/pump = 40,
					/obj/item/weapon/gun/projectile/shotgun/pump/combat = 480,
					/obj/item/weapon/storage/fancy/donut_box = 7,
					/obj/item/ammo_magazine/a357 = 42,
					/obj/item/ammo_magazine/a50 = 42,
					/obj/item/ammo_magazine/a762 = 125,*/
				)


//EXTRA CODE TO MAKE THINGS WORK

/obj/item/weapon/gun/projectile/Assault
	name = "\improper C-20r SMG"
	desc = "A standard issue assault rifle. Uses 12mm ammunition."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3.0
	max_shells = 20
	caliber = "12mm"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/a12mm"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = 2
	fire_delay = 2
	var/gun_light = 7 // Defines how bright the light on the flashlight will be
	var/haslight = 0  // Checks if there is a light on the rifle
	var/islighton = 0 // Checks if the Light is on


	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/a12mm/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return


	update_icon()
		..()
		if(empty_mag)
			icon_state = "c20r-[round(loaded.len,4)]"
		else
			icon_state = "c20r"
		return

///////NEW FANCY FLASHLIGHT CODE MADE OF HOPES AND DREAMS./





/obj/item/weapon/gun/projectile/Assault/verb/toggle_light()
	set name = "Toggle Flashlight"
	set category = "Weapon"

	if(haslight && !islighton) //Turns the light on
		usr << "\blue You turn the flashlight on."
		usr.SetLuminosity(gun_light)
		islighton = 1
	else if(haslight && islighton) //Turns the light off
		usr << "\blue You turn the flashlight off."
		usr.SetLuminosity(0)
		islighton = 0
	else if(!haslight) //Points out how stupid you are
		usr << "\red You foolishly look at where the flashlight would be, if it was attached..."

/obj/item/weapon/gun/projectile/Assault/pickup(mob/user)//Transfers the lum to the user when picked up
	if(islighton)
		SetLuminosity(0)
		usr.SetLuminosity(gun_light)

/obj/item/weapon/gun/projectile/Assault/dropped(mob/user)//Transfers the Lum back to the gun when dropped
	if(islighton)
		SetLuminosity(gun_light)
		usr.SetLuminosity(0)


