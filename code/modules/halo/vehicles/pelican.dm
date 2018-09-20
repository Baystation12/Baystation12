/obj/vehicles/air/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.5

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	comp_prof = /datum/component_profile/pelican

	occupants = list(13,1)

	exposed_positions = list("driver" = 20,"passengers" = 15)//Passengers could technically be hit by bullets through the troop bay.

	vehicle_size = 128

/obj/vehicles/air/pelican/update_object_sprites()


//Pelican component profile define//
/obj/item/vehicle_component/health_manager/pelican
	integrity = 300
	resistances = list("brute"=30,"burn"=20,"emp"=50)

/datum/component_profile/pelican
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican)
	cargo_capacity = 24
	max_vehicle_size = 64
	vehicle_capacity = 32

/obj/vehicles/air/pelican/unsc
	faction = "unsc"

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon
	name = "M370 Autocannon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	projectile_fired = /obj/item/projectile/bullet/hmg127_he

	fire_delay = 1.5 SECONDS

	burst = 5

/obj/vehicles/air/overmap/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"
	vehicle_move_delay = 1.5

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	overmap_range = 1

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	comp_prof = /datum/component_profile/pelican

	occupants = list(13,1)

	exposed_positions = list("driver" = 20,"passengers" = 15)//Passengers could technically be hit by bullets through the troop bay.

	vehicle_size = 128

/obj/vehicles/air/overmap/pelican/unsc
	faction = "unsc"

/obj/vehicles/air/overmap/pelican/urf
	faction = "innie"

	icon_state = "inni-base"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. This one has a red fist painted onto the armor. A 40mm Chain-Gun is mounted on the nose."
	faction = "innie"
	occupants = list(13,1)

	comp_prof = /datum/component_profile/pelican/urf

/obj/vehicles/air/pelican/innie/update_object_sprites()
	. = ..()
	overlays += image(icon,"innie_overlay")

/obj/item/vehicle_component/health_manager/pelican/urf
	resistances = list("brute"=25,"burn"=20,"emp"=35)

/datum/component_profile/pelican/urf
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/innie)

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie
	name = "40mm Chain-Gun"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	projectile_fired = /obj/item/projectile/bullet/a762_ap

	fire_delay = 5.5 SECONDS

	burst = 3


/obj/vehicles/air/pelican/civ
	desc = "A civilian pelican lacking in both weapons and armor."
	faction = "police"
	occupants = list(6,0)

	comp_prof = /datum/component_profile/pelican/civ

/obj/item/vehicle_component/health_manager/pelican/civ
	resistances = list("brute"=15,"burn"=10,"emp"=20)

/datum/component_profile/pelican/civ
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/civ)

/obj/vehicles/air/pelican/innie
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. This one has a red fist painted onto the armor. A 40mm Chain-Gun is mounted on the nose."
	faction = "innie"
	occupants = list(13,1)

	comp_prof = /datum/component_profile/pelican/innie

/obj/vehicles/air/pelican/innie/update_object_sprites()
	. = ..()
	overlays += image(icon,"innie_overlay")

/obj/item/vehicle_component/health_manager/pelican/innie
	resistances = list("brute"=25,"burn"=20,"emp"=35)

/datum/component_profile/pelican/innie
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/innie)

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie
	name = "40mm Chain-Gun"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	projectile_fired = /obj/item/projectile/bullet/a762_ap

	fire_delay = 2.5 SECONDS

	burst = 7
