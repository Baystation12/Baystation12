
/obj/vehicles/ghost
	name = "Type-32 Rapid Assault Vehicle"
	desc = ""

	passengers = list(0)
	gunners = list(1)

	health = list(400,400)

	bound_height = 32
	bound_width = 64

	sprite_offsets = list("1" = list(16,2),"2" = list(16,2),"4" = list(10,2),"8" = list(22,2))
	damage_resistances = list("brute" = 35.0, "burn" = 20.0,"emp" = 15)

	controller = /datum/vehicle_control/base

	vehicle_move_delay = 1.5

	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/covenant/ghost)
	icon = 'code/modules/halo/vehicles/ghost.dmi'
	icon_state = "base"

/obj/vehicles/ghost/assign_driver(var/mob/user)
	. = ..()
	assign_gunner(user)

/obj/vehicles/ghost/unassign_driver(var/mob/user)
	. = ..()
	unassign_gunner(user)

/obj/vehicles/ghost/render_mob_sprites()
	underlays.Cut()
	if(!driver)
		return
	var/image/driver_image = image(driver)
	var/list/offsets = list()
	if(num2text(dir) in sprite_offsets)
		offsets = sprite_offsets[num2text(dir)]
	if(offsets.len)
		driver_image.pixel_x = offsets[1]
		driver_image.pixel_y = offsets[2]

	underlays += driver_image

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
