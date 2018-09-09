
/obj/vehicles/ghost
	name = "Type-32 \"Ghost\" Rapid Assault Vehicle"
	desc = ""

	bound_height = 32
	bound_width = 64

	comp_prof = /datum/component_profile/ghost

	sprite_offsets = list("1" = list(16,2),"2" = list(16,2),"4" = list(10,2),"8" = list(22,2))

	vehicle_move_delay = 1.5

	occupants = list(0,0)
	exposed_positions = list("driver" = 20)

	icon = 'code/modules/halo/vehicles/ghost.dmi'
	icon_state = "base"

	vehicle_size = 16

/obj/item/vehicle_component/health_manager/ghost
	integrity = 300
	resistances = list("brute"=35,"burn"=20,"emp"=15)

/datum/component_profile/ghost
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/covenant/ghost)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/ghost)

/obj/item/weapon/gun/vehicle_turret/covenant/ghost
	name = "Type-32 RAV Plasma Weapon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = ""

	projectile_fired = /obj/item/projectile/covenant/plasmarifle
	fire_sound = 'code/modules/halo/sounds/plasrifle3burst.ogg'
	burst_delay = 0.3 SECONDS
	fire_delay = 1.5 SECONDS

	burst = 4

/obj/item/weapon/gun/vehicle_turret/covenant/ghost/relay_fire_action()
	. = ..()
	linked_vehicle.vehicle_move_delay = 2.5
	spawn(burst_delay*burst)
		linked_vehicle.vehicle_move_delay = initial(linked_vehicle.vehicle_move_delay)
