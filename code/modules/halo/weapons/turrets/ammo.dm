
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
	damage = 70

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
