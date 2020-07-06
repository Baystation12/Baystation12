
//BASE THRONE//

/obj/vehicles/prophet_throne
	name = "Gravity Throne"
	desc = "A symbol of power, this gravity throne is often used by important prophets for fast movement."
	icon = 'code/modules/halo/vehicles/types/throne.dmi'
	icon_state = "chair-back"

	comp_prof = /datum/component_profile/throne
	occupants = list(0,0)

	exposed_positions = list("driver" = 20)

	sprite_offsets = list("1" = list(1,6),"2" = list(1,6),"4" = list(7,6),"8" = list(1,6))

	vehicle_size = ITEM_SIZE_VEHICLE
	can_space_move = 1
	internal_air = new

	min_speed = 8.5
	max_speed = 2.5

	light_color = "#C1CEFF"

/obj/vehicles/prophet_throne/update_object_sprites()
	overlays.Cut()
	var/list/offsets_to_use = sprite_offsets["[dir]"]
	var/list/drivers = get_occupants_in_position("driver")
	if(!(isnull(offsets_to_use) || isnull(drivers) || drivers.len == 0))
		var/image/driver_image = image(pick(drivers))
		driver_image.plane = ABOVE_HUMAN_PLANE
		driver_image.layer = VEHICLE_LOAD_LAYER
		driver_image.pixel_x = offsets_to_use[1]
		driver_image.pixel_y = offsets_to_use[2]
		overlays += driver_image
		var/image/front = image(icon,null,"chair-front")
		front.plane = ABOVE_HUMAN_PLANE
		front.layer = VEHICLE_LOAD_LAYER
		overlays += front

/obj/item/vehicle_component/health_manager/throne
	integrity = 500
	resistances = list("bullet"=85,"energy"=85,"emp"=15,"bomb" = 0)

/datum/component_profile/throne
	gunner_weapons = list()
	vital_components = newlist(/obj/item/vehicle_component/health_manager/throne)

//ARMED THRONE//

/obj/vehicles/prophet_throne/armed
	desc = "A symbol of power, this gravity throne is often used by important prophets for fast movement. This is armed with a gravity cannon for self-defense."
	comp_prof = /datum/component_profile/throne/armed
	ammo_containers = newlist(/obj/item/ammo_magazine/throne_mag)

/obj/item/weapon/gun/vehicle_turret/throne_cannon
	name = "Gravity Cannon"
	desc = "A gravity cannon, often found on Prophet thrones."
	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "plasmaturret_obj"
	item_state = ""

	fire_sound = 'code/modules/halo/sounds/Fuelrodfire.ogg'
	fire_delay = 25

	sustain_time = 2 SECONDS
	sustain_delay = 2

	irradiate_non_cov = 20

	magazine_type = /obj/item/ammo_magazine/throne_mag

/obj/item/ammo_magazine/throne_mag
	name = "Internal Gravity Cannon Energy Store"

	max_ammo = 200
	ammo_type = /obj/item/ammo_casing/cannon_shot

/obj/item/ammo_casing/cannon_shot
	name = "gravcannon casing"
	projectile_type = /obj/item/projectile/bullet/covenant/gravity_cannon

/obj/item/projectile/bullet/covenant/gravity_cannon
	name = "Gravity Cannon Bolt"

	damage = 50
	shield_damage = 300

	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/bullet/covenant/gravity_cannon/on_impact(var/atom/A)
	. = ..()
	new /obj/effect/plasma_explosion/green(get_turf(src))
	explosion(get_turf(A),-1,-1,1,5,guaranteed_damage = 60, guaranteed_damage_range = 1)

/datum/component_profile/throne/armed
	pos_to_check = "driver"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/throne_cannon)
