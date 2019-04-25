
/obj/vehicles/wraith
	name = "wraith"
	desc = "wraith"

	icon = 'code/modules/halo/vehicles/Wraith.dmi'
	icon_state = "wraith"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/wraith

	vehicle_move_delay = 4.75
	exposed_positions = list("gunner" = 10)

	occupants = list(0,1)

	vehicle_size = 64

/obj/vehicles/wraith/update_object_sprites()
	. = ..()
	if(dir == EAST || dir == WEST)
		bounds = "64,64"
	else
		bounds = "96,64"


/obj/item/vehicle_component/health_manager/wraith
	integrity = 700
	resistances = list("brute"=65,"burn"=50,"emp"=40,"explosion"=65)

/datum/component_profile/wraith
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/wraith_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/wraith)
	cargo_capacity = 12 //Can hold, at max, two normals

/obj/item/weapon/gun/vehicle_turret/wraith_cannon
	name = "Wraith Cannon"
	desc = "A arcing-projecile firing cannon capable of inflicting heavy damage on both infantry and vehicles."

	projectile_fired = /obj/item/projectile/covenant/wraith_cannon

	fire_delay = 1 SECOND
	fire_sound = 'code/modules/halo/sounds/shadow_cannon_fire.ogg'

/obj/item/projectile/covenant/wraith_cannon
	damage = 25
	icon = 'code/modules/halo/vehicles/Wraith.dmi'
	icon_state = "Mortar_Projectile"

/obj/item/projectile/covenant/wraith_cannon/on_impact(var/atom/impacted)
	explosion(impacted,-1,1,4,7,guaranteed_damage = 75,guaranteed_damage_range = 4)
	. = ..()
