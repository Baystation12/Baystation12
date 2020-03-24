
/obj/vehicles/wraith
	name = "Type-26 Assault Gun Carriage"
	desc = "The Type-26 Assault Gun Carriage is equipped with a heavy plasma mortar and a set of twin linked medium plasma cannons."

	icon = 'code/modules/halo/vehicles/types/Wraith.dmi'
	icon_state = "wraith"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/wraith

	vehicle_move_delay = 4.75
	exposed_positions = list("gunner" = 5)

	occupants = list(0,1)

	vehicle_size = ITEM_SIZE_VEHICLE

	move_sound = 'code/modules/halo/sounds/ghost_move.ogg'

	vehicle_view_modifier = 1.75

	light_color = "#C1CEFF"

	min_speed = 13.75
	max_speed = 5.75
	drag = 2

/obj/vehicles/wraith/update_object_sprites()
	. = ..()
	if(dir == EAST || dir == WEST)
		bounds = "64,64"
	else
		bounds = "96,64"


/obj/item/vehicle_component/health_manager/wraith
	integrity = 700
	resistances = list("brute"=65,"burn"=50,"emp"=40,"bomb"=65)
	repair_materials = list("nanolaminate")

/datum/component_profile/wraith
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/switchable/wraith_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/wraith)

/obj/item/weapon/gun/vehicle_turret/switchable/wraith_cannon
	name = "Wraith Cannon"
	desc = "A arcing-projecile firing cannon capable of inflicting heavy damage on both infantry and vehicles."

	projectile_fired = /obj/item/projectile/bullet/covenant/wraith_cannon

	fire_delay = 4.5 SECONDS
	fire_sound = 'code/modules/halo/sounds/wraith_cannon_fire.ogg'

	guns_switchto = newlist(/datum/vehicle_gun/wraith_cannon,/datum/vehicle_gun/wraith_machinegun)

	irradiate_non_cov = 15

/datum/vehicle_gun/wraith_cannon
	name = "Wraith Cannon"
	desc = "A arcing-projecile firing cannon capable of inflicting heavy damage on both infantry and vehicles."
	burst_size = 1
	burst_delay = 1
	fire_delay = 4.5 SECONDS
	fire_sound = 'code/modules/halo/sounds/wraith_cannon_fire.ogg'
	proj_fired = /obj/item/projectile/bullet/covenant/wraith_cannon

/datum/vehicle_gun/wraith_machinegun
	name = "Wraith Medium Plasma Cannons"
	desc = "A short burst, mounted Plasma Rifle, used for anti-infantry purposes."
	burst_size = 3
	burst_delay = 0.15 SECONDS
	fire_delay = 0.6 SECONDS
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	proj_fired = /obj/item/projectile/bullet/covenant/plasmarifle

/obj/item/projectile/bullet/covenant/wraith_cannon
	damage = 100
	icon = 'code/modules/halo/vehicles/types/Wraith.dmi'
	icon_state = "Mortar_Projectile"
	damage_type = "bomb"
	step_delay = 1.5
	armor_penetration = 25

/obj/item/projectile/bullet/covenant/needles/launch_from_gun(var/atom/target)
	. = ..()
	kill_count = get_dist(starting,original) + rand(-2,2) //Sometimes it can fly a bit over or under the target

/obj/item/projectile/bullet/covenant/wraith_cannon/Move(var/newloc,var/dir)
	if(get_dist(loc,original) > (get_dist(starting,original)/2))
		change_elevation(1)
	else
		change_elevation(-1)
	. = ..()

/obj/item/projectile/bullet/covenant/wraith_cannon/on_impact(var/atom/impacted)
	explosion(impacted,0,2,3,5,guaranteed_damage = 100,guaranteed_damage_range = 3)
	. = ..()
