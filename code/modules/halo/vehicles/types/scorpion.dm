
/obj/vehicles/scorpion_tank
	name = "M808B Scorpion"
	desc = "The M808B Main Battle Tank is equipped with a 90mm cannon loaded with HE shells and a linked machine gun firing 7.62mm AP rounds. This will present a great foe to any force."

	icon = 'code/modules/halo/vehicles/types/Scorpion.dmi'
	icon_state = "move"
	anchored = 1

	bound_height = 64
	bound_width = 64
	pixel_x = -16
	comp_prof = /datum/component_profile/scorpion

	ammo_containers = newlist(/obj/item/ammo_magazine/scorp_coax,/obj/item/ammo_magazine/scorp_shell)

	exposed_positions = list("passenger" = 15)

	occupants = list(4,0)

	vehicle_size = ITEM_SIZE_VEHICLE

	move_sound = 'code/modules/halo/sounds/scorp_move.ogg'

	vehicle_view_modifier = 1.65

	light_color = "#E1FDFF"

	can_smoke = 1
	smoke_ammo = 5
	smoke_ammo_max = 5
	smoke_step_dist = 1

	can_overrun_cover = 1

	min_speed = 13
	max_speed = 4
	acceleration = 4
	drag = 5

/obj/item/vehicle_component/health_manager/scorpion
	integrity = 750
	resistances = list("bullet"=85,"energy"=85,"emp"=40,"bomb"=40)
	repair_materials = list("plasteel")

/datum/component_profile/scorpion
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/switchable/scorpion_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/scorpion)

/obj/item/weapon/gun/vehicle_turret/switchable/scorpion_cannon
	name = "Scorpion Cannon"
	desc = "A slow firing but devastatingly damaging cannon."

	fire_delay = 40
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'

	burst = 1

	guns_switchto = newlist(/datum/vehicle_gun/scorp_cannon,/datum/vehicle_gun/scorp_machinegun)
	magazine_type = /obj/item/ammo_magazine/scorp_shell

/datum/vehicle_gun/scorp_cannon
	name = "Scorpion Cannon"
	desc = "A slow firing but devastatinly damaging cannon."
	burst_size = 1
	burst_delay = 1
	dispersion = list(0)
	fire_delay = 40
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'
	mag_used = /obj/item/ammo_magazine/scorp_shell

/datum/vehicle_gun/scorp_machinegun
	name = "Scorpion Machinegun"
	desc = "A short burst machinegun, used for anti-infantry purposes."
	burst_size = 10
	burst_delay = 1
	dispersion = list(0.55)
	fire_delay = 8
	fire_sound = 'code/modules/halo/sounds/scorp_machinegun_fire.ogg'
	mag_used = /obj/item/ammo_magazine/scorp_coax

/obj/item/ammo_magazine/scorp_coax
	name = "Internal Co-axial Ammunition Storage"
	caliber = "a762"
	max_ammo = 300
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/ammo_magazine/scorp_shell
	name = "Internal Scorpion Shell Rack"
	caliber = "90mm Shell"
	max_ammo = 30
	ammo_type = /obj/item/ammo_casing/scorp_round

/obj/item/ammo_casing/scorp_round
	name = "90mm Shell"
	caliber = "90mm Shell"
	projectile_type = /obj/item/projectile/bullet/scorp_cannon

/obj/item/projectile/bullet/scorp_cannon
	name = "90mm Shell"
	damage = 100
	damage_type = "bomb"
	damtype = "bomb"
	armor_penetration = 50
	shield_damage = 240
	steps_between_delays = 3

/obj/item/projectile/bullet/scorp_cannon/on_impact(var/atom/impacted)
	explosion(get_turf(impacted),0,1,3,5,guaranteed_damage = 50,guaranteed_damage_range = 2)
	. = ..()

/obj/item/projectile/bullet/scorp_cannon/attack_mob()
	damage_type = BRUTE
	damtype = BRUTE
	return ..()
