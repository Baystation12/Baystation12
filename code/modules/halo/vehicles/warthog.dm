
/obj/vehicles/warthog
	name = "whog"
	desc = "warthog"

	icon = 'code/modules/halo/vehicles/finalwarthog-chaingun.dmi'
	icon_state = "warthog-chaingun"

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/warthog

	vehicle_move_delay = 2

	occupants = list(1,1)
	exposed_positions = list("driver" = 25,"passenger" = 25,"gunner" = 25)

	vehicle_size = 32

/obj/item/vehicle_component/health_manager/warthog
	integrity = 500
	resistances = list("brute"=40,"burn"=35,"emp"=25,"explosion"=25)

/datum/component_profile/warthog
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/warthog_turret)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/warthog)
	cargo_capacity = 20 //Can hold, at max, 5 normals

/obj/item/weapon/gun/vehicle_turret/warthog_turret
	name = "Warthog Turret"
	desc = "A rapid-fire mounted machine gun."

	projectile_fired = /obj/item/projectile/bullet/a762_ap

	fire_delay = 2.5 SECONDS

	burst_delay = 0.4 SECONDS

	burst = 5
