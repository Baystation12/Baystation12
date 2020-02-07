
/obj/vehicles/shadow
	name = "Type 29 Troop/Vehicle Transport"
	desc = "A well armoured and armed heavy troop and vehicle transport vehicle."

	icon = 'code/modules/halo/vehicles/types/shadow.dmi'
	icon_state = "shadow"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/shadow

	vehicle_move_delay = 2
	exposed_positions = list("passenger" = 15,"driver" = 10,"gunner" = 20)

	occupants = list(4,1)

	vehicle_carry_size = ITEM_SIZE_VEHICLE_SMALL
	capacity_flag = ITEM_SIZE_VEHICLE

	move_sound = 'code/modules/halo/sounds/ghost_move.ogg'

	light_color = "#C1CEFF"

/obj/vehicles/shadow/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,64"
	else
		bounds = "96,64"

/obj/vehicles/shadow/on_death()
	. = ..()
	guns_disabled = 0

/obj/item/vehicle_component/health_manager/shadow
	integrity = 650
	resistances = list("brute"=35,"burn"=40,"emp"=20,"bomb"=30)
	repair_materials = list("nanolaminate")

/datum/component_profile/shadow
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/shadow_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/shadow)

/obj/item/weapon/gun/vehicle_turret/shadow_cannon
	name = "Shadow Cannon"
	desc = "A fast firing plasma weapon capable of inflicting heavy damage."

	projectile_fired = /obj/item/projectile/bullet/covenant/shadow_cannon

	fire_delay = 1 SECOND
	fire_sound = 'code/modules/halo/sounds/shadow_cannon_fire.ogg'

	burst_delay = 0.15 SECONDS
	burst = 5

	irradiate_non_cov = 10

/obj/item/projectile/bullet/covenant/shadow_cannon
	damage = 15
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmarifle Shot"

/obj/item/projectile/bullet/covenant/shadow_cannon/on_impact(var/atom/impacted)
	explosion(impacted,-1,-1,0,0,adminlog = 0,guaranteed_damage = 15,guaranteed_damage_range = 2)
	. = ..()
