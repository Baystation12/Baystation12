
//HMG AMMO DEFINES//
/obj/item/ammo_magazine/HMG_boxmag
	name = "box magazine (12.7mm) HE HV AP"
	desc = "High Explosive, High Velocity, Armour Piercing. This has it all."

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "hmgturretbox"

	ammo_type = /obj/item/ammo_casing/hmg127_he
	caliber = "12.7mm"
	mag_type = MAGAZINE


	max_ammo = 100
	multiple_sprites = 1

/obj/item/ammo_casing/hmg127_he
	desc = "A 12.7mm bullet casing."
	caliber = "12.7mm"
	projectile_type = /obj/item/projectile/bullet/hmg127_he

/obj/item/projectile/bullet/hmg127_he
	damage = 50

//CHAINGUN AMMO DEFINES//
/obj/item/ammo_magazine/chaingun_boxmag
	name = "box magazine (7.62mm) AP"
	desc = "A large box filled with 7.62mm AP ammo."

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingunturretbox"

	ammo_type = /obj/item/ammo_casing/a762_ap
	caliber = "a762"
	mag_type = MAGAZINE


	max_ammo = 250
	multiple_sprites = 1

//PLASTURRET AMMO DEFINES//
/obj/item/ammo_magazine/plasturret_boxmag
	name = "cell container (Type-52 Directed Energy Support Weapon)"
	desc = "A container for cells, designed for use with the Type-52 Directed Energy Support Weapon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "plasmacellbox"

	ammo_type = /obj/item/ammo_casing/plasturret
	caliber = "plas_turret_cells"
	mag_type = MAGAZINE


	max_ammo = 175
	multiple_sprites = 1

/obj/item/ammo_casing/plasturret
	name = "Type-52 Directed Energy Support Weapon Power Cell"
	desc = "A self-contained power cell for the Type-52 Directed Energy Support Weapon"
	icon = 'code/modules/halo/weapons/turrets/turret_cov_casing.dmi'
	caliber = "plas_turret_cells"
	projectile_type = /obj/item/projectile/bullet/covenant/plasmarifle
