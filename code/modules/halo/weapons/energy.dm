/obj/item/weapon/gun/energy/railrifle
	name = "Asymmetric Recoilless Carbine-920"
	desc = "An Hesphaistos Industries G40E carbine, designed to kill with concentrated energy blasts."
	icon_state = "phantom"
	item_state = "phantom"
	fire_sound = 'sound/weapons/pulse.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	max_shots = 4
	charge_meter = 0
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/effect/projectile/laser_blue/impact

/obj/item/weapon/gun/energy/railrifle/innie
	name = "Asymmetric Recoilless Carbine-920"
	desc = "A compact-channel linear accelerator that fires a high-explosive round at incredible speed. The UNSC logo is scratched out and besides it reads 'UNSC SUKS DIKS'"
	icon_state = "spartanlaser"
	item_state = "spartanlaser"
	fire_sound = 'sound/weapons/pulse.ogg'
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	max_shots = 2
	charge_meter = 0
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/effect/projectile/laser_blue/impact
