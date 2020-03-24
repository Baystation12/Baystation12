
/obj/vehicles/warthog
	name = "M12 Warthog LRV"
	desc = "A nimble vehicle capable of providing anti-infantry support and small-scale troop transport."

	icon = 'code/modules/halo/vehicles/types/finalwarthog-chaingun.dmi'
	icon_state = "warthog-chaingun"
	anchored = 1

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/warthog

	vehicle_move_delay = 1.5

	occupants = list(1,1)
	exposed_positions = list("driver" = 25,"passenger" = 25,"gunner" = 25)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_NORMAL

	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	light_color = "#E1FDFF"

	min_speed = 8.5
	max_speed = 2.5

/obj/vehicles/warthog/on_death()
	. = ..()
	guns_disabled = 0

/obj/item/vehicle_component/health_manager/warthog
	integrity = 500
	resistances = list("brute"=40,"burn"=35,"emp"=25,"bomb"=25)

/datum/component_profile/warthog
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/warthog_turret)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/warthog)

/obj/item/weapon/gun/vehicle_turret/warthog_turret
	name = "Warthog Turret"
	desc = "A rapid-fire mounted machine gun."

	projectile_fired = /obj/item/projectile/bullet/a762_ap

	fire_delay = 1.25 SECONDS

	burst_delay = 0.2 SECONDS

	burst = 5

/obj/vehicles/warthog/turretless
	name = "M12 Warthog LRV Recon Modified"
	desc = "A nimble vehicle capable of performing small scale recon operations."

	icon = 'code/modules/halo/vehicles/types/finalwarthog-turretless.dmi'
	icon_state = "warthog-turretless"

	vehicle_move_delay = 1.6
	capacity_flag = ITEM_SIZE_LARGE

	occupants = list(2,0)
	exposed_positions = list("driver" = 15,"passenger" = 20)

/obj/vehicles/warthog/troop
	name = "M12 Warthog LRV Troop Transport Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicles/types/finalwarthog.dmi'
	icon_state = "Warthog"

	vehicle_move_delay = 1.4
	capacity_flag = ITEM_SIZE_HUGE

	occupants = list(4,0)
	exposed_positions = list("driver" = 15,"passenger" = 30)

/obj/vehicles/warthog/troop/police
	name = "M12 Warthog LRV Police Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicles/types/GCPD_Warthog.dmi'
	icon_state = "Warthog"