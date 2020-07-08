/obj/item/weapon/gun/energy/railrifle
	name = "Asymmetric Recoilless Carbine-920"
	desc = "An Hesphaistos Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "railgun"
	item_state = "ionrifle-wielded"
	fire_sound = 'sound/weapons/railgun.ogg'
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	charge_meter = FALSE
	max_shots = 4
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/railrifle

/obj/item/projectile/beam/railrifle
	name = "railgun beam"
	damage = 50
	shield_damage = 100
	armor_penetration = 100

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact
