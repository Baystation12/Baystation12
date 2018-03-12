#define SINGLE_CASING 	1
#define SPEEDLOADER 	2
#define MAGAZINE 		4



//used by: Magnum M6D, Magnum M6S

/obj/item/ammo_magazine/m127_saphe
	name = "magazine (12.7mm) M225 SAP-HE"
	desc = "12.7x40mm M225 Semi-Armor-Piercing High-Explosive magazine containing 12 shots. Very deadly."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "magnummag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a127_saphe
	matter = list(DEFAULT_WALL_MATERIAL = 1000) //12.7mm casing = 83.3 metal each
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_casing/a127_saphe
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/a127_saphe

/obj/item/projectile/bullet/a127_saphe
	damage = 50		//deadly but inaccurate
	accuracy = -1

/obj/item/weapon/storage/box/m127_saphe
	name = "box of 12.7mm M225 magazines"
	startswith = list(/obj/item/ammo_magazine/m127_saphe = 7)

//used by: Magnum M6D, Magnum M6S

/obj/item/ammo_magazine/m127_saphp
	name = "magazine (12.7mm) M228 SAP-HP"
	desc = "12.7x40mm M228 Semi-Armor-Piercing High-Penetration magazine containing 12 shots. Low profile rounds."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOMmag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a127_saphp
	matter = list(DEFAULT_WALL_MATERIAL = 1000) //12.7mm casing = 83.3 metal each
	caliber = "12.7mm"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_casing/a127_saphp
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/a127_saphp

//deadly but inaccurate
/obj/item/projectile/bullet/a127_saphp
	damage = 20
	armor_penetration = 35
	accuracy = 1

/obj/item/weapon/storage/box/m127_saphp
	name = "box of 12.7mm M228 magazines"
	startswith = list(/obj/item/ammo_magazine/m127_saphp = 7)

//used by: MA5B assault rifle, M739 Light Machine Gun, M392 designated marksman rifle

/obj/item/ammo_magazine/m762_ap
	name = "magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 30 shots. Fits both the MA5B and M392."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a762_ap
	matter = list(DEFAULT_WALL_MATERIAL = 3000) //7.62mm casing = 50 metal each
	caliber = "a762"
	max_ammo = 30		//lets try 30 instead of 60 for now
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_ap/MA5B
	name = "MA5B magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 30 shots. Specific to the MA5B."
	icon_state = "MA5B_mag"
	max_ammo = 60

/obj/item/ammo_magazine/m762_ap/M392
	name = "M392 magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 30 shots. Specific to the M392."
	ammo_type = /obj/item/ammo_casing/a762_m392

/obj/item/ammo_magazine/m762_ap/MA37
	icon_state = "MA37_mag"
	max_ammo = 32

/obj/item/ammo_casing/a762_ap
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762_ap

/obj/item/ammo_casing/a762_m392
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762/M392

/obj/item/projectile/bullet/a762_ap
	damage = 30

/obj/item/projectile/bullet/a762/M392
	damage = 35
	armor_penetration = 10

/obj/item/weapon/storage/box/m762_ap
	name = "box of 7.62mm M118 magazines"
	startswith = list(/obj/item/ammo_magazine/m762_ap = 7)

//used by: BR55 battle rifle

/obj/item/ammo_magazine/m95_sap
	name = "magazine (9.5mm) M634 X-HP-SAP"
	desc = "9.5x40mm M634 Experimental High-Powered Semi-Armor-Piercing magazine containing 36 shots. Standard issue."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a95_sap
	matter = list(DEFAULT_WALL_MATERIAL = 3000) //7.62mm casing = 50 metal each
	caliber = "9.5mm"
	max_ammo = 36		//lets try 20 instead of 60 for now
	multiple_sprites = 1

/obj/item/ammo_casing/a95_sap
	desc = "A 7.62mm bullet casing."
	caliber = "9.5mm"
	projectile_type = /obj/item/projectile/bullet/m95_sap

/obj/item/projectile/bullet/m95_sap
	damage = 35
	accuracy = 1

/obj/item/weapon/storage/box/m95_sap
	name = "box of 9.5mm M634 magazines"
	startswith = list(/obj/item/ammo_magazine/m95_sap = 7)

//used by: M739 Light Machine Gun

/obj/item/ammo_magazine/a762_box_ap
	name = "box magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing box magazine containing 50 shots. Designed for heavier use."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	mag_type = MAGAZINE
	icon_state = "M739mag"
	ammo_type = /obj/item/ammo_casing/a762_ap
	matter = list(DEFAULT_WALL_MATERIAL = 5000) //7.62mm casing = 50 metal each
	caliber = "a762"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/a762_box_ap/empty
	initial_ammo = 0



//used by: SRS99 sniper rifle

/obj/item/ammo_magazine/m145_ap
	name = "magazine (14.5mm) M112 AP-FS-DS"
	desc = "14.5×114mm M112 armor piercing, fin-stabilized, discarding sabot magazine containing 4 shots. Not much this won't penetrate"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SRS99mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a145_ap
	matter = list(DEFAULT_WALL_MATERIAL = 4000) //7.62mm casing = 50 metal each
	caliber = "14.5mm"
	max_ammo = 4
	multiple_sprites = 1

/obj/item/ammo_casing/a145_ap
	desc = "A 14.5mm bullet casing."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/a145_ap

/obj/item/projectile/bullet/a145_ap
	damage = 80
	step_delay = 0.3
	penetrating = 5
	armor_penetration = 80
	accuracy = 6
	tracer_type = /obj/effect/projectile/srs99
	tracer_delay_time = 2 SECONDS

/obj/effect/projectile/srs99
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "sniper_trail"

/obj/item/weapon/storage/box/m145_ap
	name = "box of 14.5mm M112 magazines"
	startswith = list(/obj/item/ammo_magazine/m145_ap = 4)

//used by: M7 submachine gun
//todo: these are not supposed to eject spent shell casings on firing, so figure out a way to disable that
/obj/item/ammo_magazine/m5
	name = "magazine (5mm) M443 Caseless FMJ"
	desc = "5x23mm M443 Caseless Full Metal Jacket magazine. Fun sized with no pesky casing!"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m7mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m5
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "5mm"
	max_ammo = 60
	multiple_sprites = 1

/obj/item/ammo_magazine/m5/rubber
	name = "magazine (5mm) M443 Caseless Rubber"
	desc = "Rubber bullets for riot suppression."
	ammo_type = /obj/item/ammo_casing/m5/rubber

/obj/item/ammo_casing/m5
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m5

/obj/item/ammo_casing/m5/rubber
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m5/rubber

/obj/item/projectile/bullet/m5
	damage = 15
	accuracy = -3

/obj/item/projectile/bullet/m5/rubber //"rubber" bullets
	name = "rubber bullet"
	check_armour = "melee"
	damage = 5
	agony = 25
	embed = 0
	sharp = 0


/obj/item/weapon/storage/box/m5
	name = "box of 5mm M443 magazines"
	startswith = list(/obj/item/ammo_magazine/m5 = 7)
