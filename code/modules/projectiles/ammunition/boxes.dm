/obj/item/ammo_magazine/speedloader
	name = "speed loader"
	desc = "A speed loader for revolvers."
	icon_state = "spdloader"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/speedloader/magnum
	icon_state = "spdloader_magnum"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/magnum/rubber
	ammo_type = /obj/item/ammo_casing/pistol/magnum/rubber

/obj/item/ammo_magazine/speedloader/small
	name = "speed loader"
	icon_state = "spdloader_small"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1060)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/small/rubber
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/speedloader/pclip
	name = "magnum pistol stripper clip"
	desc = "A stripper clip for pistol magnum caliber weapons."
	icon_state = "pclip"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	matter = list(MATERIAL_STEEL = 1300)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/hpclip
	name = "holdout pistol stripper clip"
	desc = "A stripper clip for pistol holdout caliber weapons."
	icon_state = "hpclip"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1800)
	max_ammo = 10
	multiple_sprites = TRUE

/obj/item/ammo_magazine/speedloader/clip
	name = "rifle stripper clip"
	desc = "A stripper clip for rifle caliber weapons."
	icon_state = "clip"
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	matter = list(MATERIAL_STEEL = 1800)
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 1440)
	max_ammo = 4
	multiple_sprites = 1
	var/marking_color

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/attack_hand(mob/user)
	if((user.a_intent == I_HURT) && (stored_ammo.len))
		var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
		stored_ammo-=C
		user.put_in_hands(C)
		user.visible_message("\The [user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
		update_icon()
	else
		..()

/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/flechette
	name = "flechette shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flechette
	marking_color = COLOR_BLUE

/obj/item/ammo_magazine/shotholder/beanbag
	name = "beanbag shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 720)
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/flash
	name = "illumination shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	matter = list(MATERIAL_STEEL = 360, MATERIAL_GLASS = 360)
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	name = "stun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	matter = list(MATERIAL_STEEL = 1440, MATERIAL_GLASS = 2880)
	marking_color = COLOR_MUZZLE_FLASH

/obj/item/ammo_magazine/shotholder/empty
	name = "shotgun ammunition holder"
	matter = list(MATERIAL_STEEL = 250)
	initial_ammo = 0

/obj/item/ammo_magazine/machine_pistol
	name = "stick magazine"
	icon_state = "machine_pistol"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/machine_pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg_top
	name = "top mounted magazine"
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg_top/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg_top/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/smg_top/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/smg
	name = "box magazine"
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	matter = list(MATERIAL_STEEL = 1500)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol
	name = "pistol magazine"
	icon_state = "pistol_mag"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	matter = list(MATERIAL_STEEL = 750)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/double
	name = "doublestack pistol magazine"
	icon_state = "pistol_mag"
	matter = list(MATERIAL_STEEL = 1050)
	max_ammo = 15

/obj/item/ammo_magazine/pistol/double/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/double/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/pistol/small
	icon_state = "holdout"
	matter = list(MATERIAL_STEEL = 480)
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/magnum
	name = "magazine"
	icon_state = "magnum"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_MAGNUM
	matter = list(MATERIAL_STEEL = 1680)
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/magnum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/smallpistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(MATERIAL_STEEL = 1800)
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = list(TECH_COMBAT = 2)
	caliber = CALIBER_PISTOL
	matter = list(MATERIAL_STEEL = 2250)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/throwback
	name = "pistol magazine"
	caliber = CALIBER_PISTOL_ANTIQUE
	ammo_type = /obj/item/ammo_casing/pistol/throwback

/obj/item/ammo_magazine/box/emp/pistol
	name = "ammunition box"
	desc = "A box containing loose rounds of standard EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp
	caliber = CALIBER_PISTOL
	max_ammo = 15

/obj/item/ammo_magazine/box/emp/smallpistol
	name = "ammunition box"
	desc = "A box containing loose rounds of small EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 8

/obj/item/ammo_magazine/proto_smg
	name = "submachine gun magazine"
	icon_state = CALIBER_PISTOL_FLECHETTE
	origin_tech = list(TECH_COMBAT = 4)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	matter = list(MATERIAL_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/flechette
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/gyrojet
	name = "microrocket magazine"
	icon_state = "gyrojet"
	mag_type = MAGAZINE
	caliber = CALIBER_GYROJET
	ammo_type = /obj/item/ammo_casing/gyrojet
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/gyrojet/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/machinegun
	name = "magazine box"
	icon_state = "machinegun"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	matter = list(MATERIAL_STEEL = 4500)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 80
	multiple_sprites = 1

/obj/item/ammo_magazine/box/machinegun/empty
	initial_ammo = 0

/obj/item/ammo_magazine/rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/mil_rifle
	name = "assault rifle magazine"
	icon_state = "bullup"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	matter = list(MATERIAL_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 30 //if we lived in a world where normal mags had 30 rounds, this would be a 20 round mag
	multiple_sprites = 1

/obj/item/ammo_magazine/mil_rifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mil_rifle/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/rifle/military/practice

/obj/item/ammo_magazine/caps
	name = "speed loader"
	desc = "A cheap plastic speed loader for some kind of revolver."
	icon_state = "T38"
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 600)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/iclipr
	name = "internal rifle magazine"
	desc = "An internal clip for rifle caliber weapons."
	icon_state = "iclipr"
	caliber = CALIBER_RIFLE
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/rifle
	matter = list(MATERIAL_STEEL = 1500)
	max_ammo = 8
	multiple_sprites = TRUE
