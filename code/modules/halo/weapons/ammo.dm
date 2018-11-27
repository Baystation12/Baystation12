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
	desc = "12.7x40mm M228 Semi-Armor-Piercing High-Penetration magazine containing 12 rounds."
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
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 30 rounds. Fits both the MA5B and M392."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a762_ap
	matter = list(DEFAULT_WALL_MATERIAL = 1500) //7.62mm casing = 50 metal each
	caliber = "a762"
	max_ammo = 30		//lets try 30 instead of 60 for now
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_ap/MA5B
	name = "MA5B magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 60 rounds. Specific to the MA5B."
	icon_state = "MA5B_mag"
	max_ammo = 60

/obj/item/ammo_magazine/m762_ap/MA5B/TTR
	name = "MA5B magazine (7.62mm) Tactical Training Rounds"
	desc = "7.62x51mm Tactical Training Rounds, powerful chemicals inside of a plastic polymer shell that disperse upon impact and render the target immobile."
	ammo_type = /obj/item/ammo_casing/a762_ttr

/obj/item/ammo_magazine/m762_ap/M392
	name = "M392 magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 15 rounds. Specific to the M392."
	ammo_type = /obj/item/ammo_casing/a762_m392
	max_ammo = 15
	matter = list(DEFAULT_WALL_MATERIAL = 750)

/obj/item/ammo_magazine/m762_ap/M392/innie
	name = "Modified M392 magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 20 rounds. A modified version of the magazine specific to the M392."
	ammo_type = /obj/item/ammo_casing/a762_m392
	max_ammo = 20
	matter = list(DEFAULT_WALL_MATERIAL = 1000)

/obj/item/ammo_magazine/m762_ap/MA37
	name = "MA37 magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing magazine containing 32 rounds. Specific to the MA37."
	icon_state = "MA37_mag"
	max_ammo = 32
	matter = list(DEFAULT_WALL_MATERIAL = 1600)

/obj/item/ammo_magazine/m762_ap/MA3
	name = "MA3 magazine (7.62mm) FMJ-AP"
	desc = "7.62x51mm Full Metal Jacket Armor Piercing magazine containing 40 rounds. Specific to the MA3."
	icon_state = "MA3_mag"
	max_ammo = 40
	matter = list(DEFAULT_WALL_MATERIAL = 2000)

/obj/item/ammo_casing/a762_ttr
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762_ttr

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

/obj/item/projectile/bullet/a762_ttr
	armor_penetration = 1
	nodamage = 1
	agony = 10
	damage_type = PAIN
	penetrating = 0

/obj/item/projectile/bullet/a762/M392
	damage = 35
	armor_penetration = 10

/obj/item/weapon/storage/box/m762_ap
	name = "box of 7.62mm M118 magazines"
	startswith = list(/obj/item/ammo_magazine/m762_ap = 7)

/obj/item/weapon/storage/box/m762_ap_ma5b
	name = "box of 7.62mm M118 magazines for the MA5B rifle"
	startswith = list(/obj/item/ammo_magazine/m762_ap/MA5B = 7)

//used by: BR55 battle rifle

/obj/item/ammo_magazine/m95_sap
	name = "magazine (9.5mm) M634 X-HP-SAP"
	desc = "9.5x40mm M634 Experimental High-Powered Semi-Armor-Piercing magazine containing 36 rounds. Standard issue."
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
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing box magazine containing 72 rounds. Designed for heavier use."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	mag_type = MAGAZINE
	icon_state = "M739mag"
	ammo_type = /obj/item/ammo_casing/a762_ap
	matter = list(DEFAULT_WALL_MATERIAL = 5000) //7.62mm casing = 50 metal each
	caliber = "a762"
	max_ammo = 72
	multiple_sprites = 1

/obj/item/ammo_magazine/a762_box_ap/empty
	initial_ammo = 0

/obj/item/ammo_magazine/lmg_30cal_box_ap
	name = "box magazine (7.62mm) M118 FMJ-AP"
	desc = "7.62x51mm M118 Full Metal Jacket Armor Piercing box magazine containing 72 rounds. Designed for heavier use."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	mag_type = MAGAZINE
	icon_state = "30cal_lmg_mag"
	ammo_type = /obj/item/ammo_casing/a762_ap
	matter = list(DEFAULT_WALL_MATERIAL = 5000) //7.62mm casing = 50 metal each
	caliber = "a762"
	max_ammo = 72
	multiple_sprites = 1


//used by: SRS99 sniper rifle

/obj/item/ammo_magazine/m145_ap
	name = "magazine (14.5mm) M112 AP-FS-DS"
	desc = "14.5×114mm M112 armor piercing, fin-stabilized, discarding sabot magazine containing 4 rounds. Not much this won't penetrate"
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

/obj/item/ammo_casing/a145_ap/tracerless
	desc = "A 14.5mm bullet casing. Some modifications appear to have been made to remove the tracer-effect, however, this is likely to reduce the penetration of the round."
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/a145_ap/tracerless

/obj/item/projectile/bullet/a145_ap
	damage = 80
	step_delay = 0.1
	penetrating = 5
	armor_penetration = 80
	accuracy = 6
	tracer_type = /obj/effect/projectile/srs99
	tracer_delay_time = 2 SECONDS

/obj/item/projectile/bullet/a145_ap/tracerless //Modified slightly to provide a downside for using the innie-heavy-sniper-rounds over normal rounds.
	penetrating = 0
	armor_penetration = 70
	tracer_type = null
	tracer_delay_time = null

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
	damage = 20
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
