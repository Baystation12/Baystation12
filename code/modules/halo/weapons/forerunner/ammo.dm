
/obj/item/ammo_magazine/boltshot
	name = "Z-110 DEP magazine"
	desc = "A magazine containing hardlight charge cells. This places the gun in pistol configuration"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "boltshot_magazine"
	caliber = "hardlightBoltshot"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/boltshot
	max_ammo = 24

/obj/item/ammo_magazine/boltshot_sg
	name = "Z-110 DEP Magazine, Shotgun Configuration."
	desc = "A magazine containing hardlight charge cells. This places the gun in shotgun configuration."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "boltshot_magazine"
	caliber = "hardlightBoltshot"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/boltshot_sg
	max_ammo = 6

/obj/item/ammo_casing/boltshot
	name = "hardlight cell"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "casing"
	caliber = "hardlightBoltshot"
	projectile_type = /obj/item/projectile/bullet/boltshot

/obj/item/ammo_casing/boltshot_sg
	name = "hardlight cell"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "casing"
	caliber = "hardlightBoltshot"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/boltshot

/obj/item/projectile/bullet/boltshot
	name = "hardlight round"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "boolet"
	fire_sound = 'code/modules/halo/sounds/boltshot_fire.ogg'
	damage = 30
	armor_penetration = 30

/obj/item/projectile/bullet/pellet/shotgun/boltshot
	name = "hardlight shrapnel"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "boltshot_ammo"
	fire_sound = 'code/modules/halo/sounds/boltshot_sg_fire.ogg'
	damage = 25
	pellets = 8
	range_step = 2

/obj/item/ammo_magazine/binaryrifle
	name = "Z-750 SASR magazine"
	desc = "A magazine containing hardlight charge cells."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "binaryrifle_magazine"
	caliber = "hardlightBinaryrifle"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/binaryrifle
	max_ammo = 2

/obj/item/ammo_casing/binaryrifle
	name = "hardlight cell"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "casing"
	caliber = "hardlightBinaryrifle"
	projectile_type = /obj/item/projectile/bullet/binaryrifle

/obj/item/projectile/bullet/binaryrifle
	name = "hardlight round"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = " "
	damage = 55
	armor_penetration = 60
	step_delay = 0
	penetrating = 1
	shield_damage = 210
	tracer_type = /obj/effect/projectile/binaryrifle
	tracer_delay_time = 2 SECONDS

/obj/effect/projectile/binaryrifle
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "binaryrifle_trail"
	alpha = 160

/obj/item/ammo_magazine/suppressor
	name = "Z-130 DEAW magazine"
	desc = "A magazine containing hardlight charge cells."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "suppressor_magazine"
	caliber = "hardlightSuppressor"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/suppressor
	max_ammo = 60

/obj/item/ammo_casing/suppressor
	name = "hardlight cell"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "casing"
	caliber = "hardlightSuppressor"
	projectile_type = /obj/item/projectile/bullet/suppressor

/obj/item/projectile/bullet/suppressor
	name = "hardlight round"
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "suppressor_ammo"
	damage = 25
	armor_penetration = 20
	penetrating = 1
	shield_damage = 15
