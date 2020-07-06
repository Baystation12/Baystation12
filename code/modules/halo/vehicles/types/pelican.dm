/obj/vehicles/air/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	comp_prof = /datum/component_profile/pelican

	ammo_containers = newlist(/obj/item/ammo_magazine/pelican_hmg)

	occupants = list(13,1)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

	light_color = "#E1FDFF"

	min_speed = 17.25
	max_speed = 2.25
	acceleration = 6
	drag = 7
	internal_air = new

/obj/vehicles/air/pelican/update_object_sprites()

//Pelican component profile define//
/obj/item/vehicle_component/health_manager/pelican
	integrity = 600
	resistances = list("brute"=45,"burn"=45,"emp"=50,"bomb" = 50)

/datum/component_profile/pelican
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican)

/obj/vehicles/air/pelican/unsc
	faction = "unsc"

	spawn_datum = /datum/mobile_spawn/unsc

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon
	name = "M370 Autocannon"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	fire_delay = 1.5 SECONDS

	burst = 5

	magazine_type = /obj/item/ammo_magazine/pelican_hmg

/obj/item/ammo_magazine/pelican_hmg
	name = "Internal Ammunition Storage"
	max_ammo = 100
	caliber = "12.7mm"
	ammo_type = /obj/item/ammo_casing/pelican_hmg

/obj/item/ammo_casing/pelican_hmg
	projectile_type = /obj/item/projectile/bullet/hmg127_he

/obj/vehicles/air/overmap/pelican
	name = "D77-TC Pelican"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. It can also be used as a support gunship. An M370 Autocannon is mounted on the nose."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1

	bound_height = 128
	bound_width = 128

	pixel_x = -32
	pixel_y = -32

	overmap_range = 10

	takeoff_overlay_icon_state = "thrust"
	takeoff_sound = 'code/modules/halo/shuttles/pelican_takeoff.ogg'

	comp_prof = /datum/component_profile/pelican

	ammo_containers = newlist(/obj/item/ammo_magazine/pelican_hmg)

	vehicle_size = ITEM_SIZE_VEHICLE_LARGE
	vehicle_carry_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_VEHICLE_LARGE

	occupants = list(13,1)

	exposed_positions = list("driver" = 0)//Passengers could technically be hit by bullets through the troop bay.

	light_color = "#E1FDFF"

	min_speed = 17.25
	max_speed = 2.25
	acceleration = 6
	drag = 7

	internal_air = new

/obj/vehicles/air/overmap/pelican/unsc
	faction = "unsc"

	spawn_datum = /datum/mobile_spawn/unsc

/obj/vehicles/air/overmap/pelican/urf
	faction = "innie"

	icon_state = "inni-base"
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. This one has a red fist painted onto the armor. A 40mm Chain-Gun is mounted on the nose."
	faction = "innie"

	comp_prof = /datum/component_profile/pelican/urf

	ammo_containers = newlist(/obj/item/ammo_magazine/pelican_chaingun)

	light_color = "#FEFFE1"

	spawn_datum = /datum/mobile_spawn/innie

/obj/vehicles/air/pelican/innie/update_object_sprites()
	. = ..()
	overlays += image(icon,"innie_overlay")

/obj/item/vehicle_component/health_manager/pelican/urf
	resistances = list("brute"=25,"burn"=20,"emp"=35)

/datum/component_profile/pelican/urf
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/urf)

/obj/item/weapon/gun/vehicle_turret/pelican_autocannon_innie
	name = "40mm Chain-Gun"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"

	magazine_type = /obj/item/ammo_magazine/pelican_chaingun

	fire_delay = 5.5 SECONDS

	burst = 3

/obj/item/ammo_magazine/pelican_chaingun
	max_ammo = 150
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762_ap

/obj/vehicles/air/pelican/civ
	desc = "A civilian pelican lacking in both weapons and armor."
	faction = "police"
	occupants = list(6,0)

	comp_prof = /datum/component_profile/pelican/civ

/obj/item/vehicle_component/health_manager/pelican/civ
	resistances = list("brute"=15,"burn"=10,"emp"=20)

/datum/component_profile/pelican/civ
	vital_components = newlist(/obj/item/vehicle_component/health_manager/pelican/civ)

/obj/vehicles/air/overmap/pelican/civ
	desc = "A civilian pelican lacking in both weapons and armor."
	faction = "police"
	occupants = list(6,0)

	comp_prof = /datum/component_profile/pelican/civ

/obj/vehicles/air/pelican/innie
	desc = "A versatile aircraft used by the UNSC for medium-lift operations of personnel, vehicles and equipment. This one has a red fist painted onto the armor. A 40mm Chain-Gun is mounted on the nose."
	faction = "innie"
	occupants = list(13,1)

	comp_prof = /datum/component_profile/pelican/urf

	light_color = "#FEFFE1"

/obj/vehicles/air/pelican/innie/update_object_sprites()
	. = ..()
	overlays += image(icon,"innie_overlay")
