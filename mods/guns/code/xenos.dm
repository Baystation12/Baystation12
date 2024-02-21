/obj/item/gun/energy/gun/skrell
	icon = 'mods/guns/icons/obj/skrell_pistol.dmi'

/obj/item/gun/energy/pulse_rifle/skrell
	icon = 'mods/guns/icons/obj/skrell_carbine.dmi'

/obj/item/gun/magnetic/railgun/flechette/skrell
	icon = 'icons/obj/guns/skrell_rifle.dmi'

// VOX BOX

/obj/item/projectile/beam/darkmatter
	damage = 30
	armor_penetration = 35

/obj/item/projectile/beam/stun/darkmatter
	agony = 70
	eyeblur = 6

/obj/item/projectile/energy/darkmatter
	damage = 10
	armor_penetration = 40

/obj/item/gun/energy/darkmatter
	firemodes = list(
		list(mode_name="stunning", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/stun/darkmatter, charge_cost = 60),
		list(mode_name="focused", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/darkmatter, charge_cost = 100),
		list(mode_name="scatter burst", burst=8, fire_delay=null, move_delay=4, burst_accuracy=list(0, 0, 0, 0, 0, 0, 0, 0), dispersion=list(0, 0, 0, 1, 1, 1, 2, 2, 3), projectile_type=/obj/item/projectile/energy/darkmatter, charge_cost = 7)
		)

/obj/item/gun/energy/sonic
	firemodes = list(
		list(mode_name="normal", projectile_type=/obj/item/projectile/energy/plasmastun/sonic/weak, charge_cost = 50),
		list(mode_name="overcharge", projectile_type=/obj/item/projectile/energy/plasmastun/sonic/strong, charge_cost = 100)
		)

/obj/item/projectile/energy/plasmastun/sonic
	life_span = 6

/obj/item/projectile/energy/plasmastun/sonic/strong
	damage = 35

/obj/item/gun/launcher/alien/spikethrower
	max_ammo = 4

/obj/item/gun/launcher/alien/slugsling
	ammo_gen_time = 200
