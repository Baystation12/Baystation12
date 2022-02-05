
/obj/vehicles/warthog
	name = "M12 Warthog LRV"
	desc = "A nimble vehicle capable of providing anti-infantry support and small-scale troop transport."

	icon = 'code/modules/halo/vehicles/types/finalwarthog-chaingun.dmi'
	icon_state = "warthog-chaingun"
	anchored = 1

	bound_height = 64
	bound_width = 64

	comp_prof = /datum/component_profile/warthog

	ammo_containers = newlist(/obj/item/ammo_magazine/warthog_mag)


	occupants = list(1,1)
	exposed_positions = list("driver" = 0,"passenger" = 5,"gunner" = 5)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_NORMAL

	move_sound = 'code/modules/halo/sounds/warthog_move.ogg'

	vehicle_view_modifier = 1.5

	light_color = "#E1FDFF"

	can_smoke = 1
	smoke_ammo = 3
	smoke_ammo_max = 3
	smoke_step_dist = 0

	acceleration = 2
	min_speed = 8.5
	max_speed = 2.5

/obj/vehicles/warthog/on_death()
	. = ..()
	guns_disabled = 0

/obj/item/vehicle_component/health_manager/warthog
	integrity = 500
	resistances = list("bullet"=65,"energy"=65,"emp"=25,"bomb"=45)

/datum/component_profile/warthog
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/warthog_turret)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/warthog)

/obj/item/ammo_magazine/warthog_mag
	name = "Internal Ammunition Storage"
	caliber = "a762"
	max_ammo = 400
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/weapon/gun/vehicle_turret/warthog_turret
	name = "Warthog Turret"
	desc = "A rapid-fire mounted machine gun."

	fire_delay = 8

	dispersion = list(0.15,0.3,0.45,0.5,0.55)

	burst = 15
	burst_delay = 1.75

	magazine_type = /obj/item/ammo_magazine/warthog_mag

/obj/vehicles/warthog/turretless
	name = "M12 Warthog LRV Recon Modified"
	desc = "A nimble vehicle capable of performing small scale recon operations."

	icon = 'code/modules/halo/vehicles/types/finalwarthog-turretless.dmi'
	icon_state = "warthog-turretless"

	ammo_containers = list()
	max_speed = 2.3
	capacity_flag = ITEM_SIZE_LARGE

	occupants = list(2,0)

/obj/vehicles/warthog/turretless/supplydrop_recon/on_death()
	. = ..()
	for(var/turf in trange(2,loc))
		if(prob(75))
			new /obj/item/salvage/metal (turf)
	qdel(src)

/obj/vehicles/warthog/troop
	name = "M12 Warthog LRV Troop Transport Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicles/types/finalwarthog.dmi'
	icon_state = "Warthog"

	max_speed = 2.4

	occupants = list(6,0)
	exposed_positions = list("driver" = 0,"passenger" = 10)

/obj/vehicles/warthog/troop/police
	name = "M12 Warthog LRV Police Modified"
	desc = "A nimble vehicle capable of providing small to medium scale troop transport."

	icon = 'code/modules/halo/vehicles/types/GCPD_Warthog.dmi'
	icon_state = "Warthog"