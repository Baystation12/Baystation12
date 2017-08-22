/obj/item/weapon/gun/energy/railrifle
	name = " Asymmetric Recoilless Carbine-920"
	desc = "An Hesphaistos Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon_state = "phantom"
	item_state = "phantom"
	fire_sound = 'sound/weapons/pulse.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	max_shots = 4
	charge_meter = 0
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/effect/projectile/laser_blue/impact

/obj/item/weapon/gun/energy/railrifle/innie
	name = " Asymmetric Recoilless Carbine-920"
	desc = "A compact-channel linear accelerator that fires a high-explosive round at incredible speed. The UNSC logo is scratched out and besides it reads 'UNSC SUKS DIKS'"
	icon_state = "spartanlaser"
	item_state = "spartanlaser"
	fire_sound = 'sound/weapons/pulse.ogg'
	slot_flags = SLOT_BACK
	w_class = 3
	max_shots = 2
	charge_meter = 0
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/effect/projectile/laser_blue/impact

/obj/item/weapon/gun/energy/spartanlaser
	name = "M6 Grindell/Galilean Nonlinear Rifle"
	desc = "Also known as the spartan laser, is the most powerful handheld weapon produced by the UNSC. It can disable most vehicles and infantry in a single hit."
	icon_state = "spartanlaser"
	item_state = "spartanlaser"
	slot_flags = SLOT_BACK
	w_class = 3
	max_shots = 4
	charge_meter = 0
	force = 10
	origin_tech = list(TECH_COMBAT = 10, TECH_POWER = 20)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/spartan