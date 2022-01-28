
/obj/vehicles/hrunting
	name = "HRUNTING/YGGDRASIL Mark I ADS"
	desc = "An experimental bipedal powered exoskeleton/armored fighting vehicle."

	icon = 'code/modules/halo/vehicles/types/hrunting_vehicle.dmi'
	icon_state = "hrunting"
	anchored = 1

	bound_height = 32
	bound_width = 32
	pixel_x = -16

	comp_prof = /datum/component_profile/hrunting

	ammo_containers = newlist(/obj/item/ammo_magazine/hrunting_mg,/obj/item/ammo_magazine/hrunting_recoilless,/obj/item/ammo_magazine/hrunting_rockets)
	melee_type = /obj/item/weapon/hrunting_melee

	occupants = list(0,0)
	exposed_positions = list()

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_NORMAL

	move_sound = 'sound/mecha/mechmove01.ogg'

	light_color = "#E1FDFF"

	can_smoke = 1
	smoke_ammo = 2
	smoke_ammo_max = 2
	smoke_step_dist = 2

	acceleration = 2
	drag = 2
	min_speed = 8
	max_speed = 6

/obj/vehicles/hrunting/on_death()
	. = ..()
	guns_disabled = 0

/obj/item/vehicle_component/health_manager/hrunting
	integrity = 500
	resistances = list("bullet"=65,"energy"=65,"emp"=25,"bomb"=45)
	repair_materials = list("plasteel")

/datum/component_profile/hrunting
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/switchable/hrunting_mg)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/hrunting)


/obj/item/weapon/gun/vehicle_turret/switchable/hrunting_mg
	name = "Hrunting MG"
	desc = "A fast-firing, arm mounted gatling gun."

	fire_delay = 6
	fire_sound = 'code/modules/halo/sounds/scorp_machinegun_fire.ogg'

	burst = 15
	burst_delay = 1.2

	guns_switchto = newlist(/datum/vehicle_gun/hrunting_machinegun,/datum/vehicle_gun/hrunting_recoilless,/datum/vehicle_gun/hrunting_rockets)
	magazine_type = /obj/item/ammo_magazine/hrunting_mg

/datum/vehicle_gun/hrunting_machinegun
	name = "Hrunting MG"
	desc = "A fast-firing, arm mounted gatling gun."
	burst_size = 15
	burst_delay = 1.2
	dispersion = list(0.55)
	fire_delay = 6
	fire_sound = 'code/modules/halo/sounds/scorp_machinegun_fire.ogg'
	mag_used = /obj/item/ammo_magazine/hrunting_mg

/datum/vehicle_gun/hrunting_recoilless
	name = "Hrunting Recoilless Rifle"
	desc = "A low-ammo but heavily damaging explosive weapon."
	burst_size = 1
	burst_delay = 1
	dispersion = list(0)
	fire_delay = 35
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'
	mag_used = /obj/item/ammo_magazine/hrunting_recoilless

/datum/vehicle_gun/hrunting_rockets
	name = "Hrunting Rockets"
	desc = "A 5-round magazine rocket launcher."
	burst_size = 1
	burst_delay = 1
	dispersion = list(0)
	fire_delay = 30
	fire_sound = 'code/modules/halo/sounds/Rocket_Launcher_Fire_New.wav'
	mag_used = /obj/item/ammo_magazine/hrunting_rockets

/obj/item/ammo_magazine/hrunting_mg
	name = "Internal Machine Gun Ammunition Storage"
	caliber = "a762"
	max_ammo = 650
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/ammo_magazine/hrunting_recoilless
	name = "Internal Recoilless Rifle Shell Rack"
	caliber = "90mm Shell"
	max_ammo = 10
	ammo_type = /obj/item/ammo_casing/scorp_round

/obj/item/ammo_magazine/hrunting_rockets
	name = "Internal Rocket Rack"
	caliber = "spnkr"
	max_ammo = 5
	ammo_type = /obj/item/ammo_casing/spnkr

/obj/item/weapon/hrunting_melee
	name = "\the Hrunting fist"
	desc = "punch"
	force = 40
	armor_penetration = 80

/obj/item/weapon/hrunting_melee/resolve_attackby(atom/movable/a, mob/user, var/click_params)
	var/mob/living/m = a
	var/obj/vehicles/v = a
	var/do_knockback = 0
	if(istype(v))
		do_knockback = 3
	if(istype(m))
		do_knockback = 8
	if(do_knockback)
		var/turf/t = get_turf(user)
		var/throw_dir = get_dir(t, m)
		var/turf/targ = t
		for(var/i = 0 to do_knockback)
			var/turf/targ_temp = get_step(targ,throw_dir)
			if(targ_temp.density == 1)
				break
			targ = targ_temp
		a.throw_at(targ, do_knockback, 1, user)
	. = ..()