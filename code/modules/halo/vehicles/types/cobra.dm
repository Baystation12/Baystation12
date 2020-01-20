
/obj/vehicles/cobra
	name = "SP42 Cobra"
	desc = "An anti-fortification and anti-materiel tank capable of providing high damage anti-armour at incredible ranges, however, its durability is low."

	icon = 'code/modules/halo/vehicles/types/Cobra.dmi'
	icon_state = "cobra"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/cobra

	vehicle_move_delay = 4.5
	exposed_positions = list("passenger"=10)

	occupants = list(2,1)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_NORMAL

	move_sound = 'code/modules/halo/sounds/scorp_move.ogg'

	vehicle_view_modifier = 1.2

	light_color = "#FEFFE1"

	var/lockdown = 0
	var/zoomed = 0

/obj/vehicles/cobra/update_object_sprites()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		bounds = "64,64"
	else
		bounds = "96,64"

/obj/vehicles/cobra/verb/toggle_lockdown()
	set name = "Toggle Lockdown"
	set category = "Vehicle"
	set src in view(1)

	var/mob/user = usr
	if(!istype(user))
		return
	if(movement_destroyed)
		to_chat(user,"<span class = 'notice'>[src]'s engines have been damaged beyond use!</span>")
		return
	if(!(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You need to be the driver to do that.</span>")
		return

	visible_message("<span class = 'notice'>[user] [ lockdown ? "deactivates":"activates"] lockdown mode on [src]</span>")
	lockdown = !lockdown
	if(lockdown)
		active = 0
		icon_state = "cobra_deployed"
		vehicle_view_modifier = 1.5
		comp_prof.gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/cobra_sniper)
	else
		active = 1
		icon_state = "cobra"
		vehicle_view_modifier = 1
		comp_prof.gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/cobra_cannon)

	spawn(5)
		for(var/mob/occupant in occupants)
			update_user_view(occupant,1)
			spawn(1)
				update_user_view(occupant)

/obj/vehicles/cobra/on_death()
	. = ..()
	vehicle_view_modifier = 1
	lockdown = 0
	zoomed = 0
	comp_prof.gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/cobra_cannon)

/obj/vehicles/cobra/verb/toggle_zoom()
	set name = "Toggle Zoom"
	set category = "Vehicle"
	set src in view(1)

	var/mob/user = usr
	if(!istype(user))
		return

	if(!lockdown)
		to_chat(user,"<span class = 'notice'>Magnification apparatus deploys only in lockdown mode.</span>")
		return

	zoomed = !zoomed

	if(zoomed)
		vehicle_view_modifier = 2.5
	else
		vehicle_view_modifier = 1.5

	spawn(5)
		for(var/mob/occupant in occupants)
			update_user_view(occupant,1)
			spawn(1)
				update_user_view(occupant)

/obj/item/vehicle_component/health_manager/cobra
	integrity = 500
	resistances = list("brute"=35,"burn"=30,"emp"=25,"bomb"=25)
	repair_materials = list("plasteel")

/datum/component_profile/cobra
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/cobra_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/cobra)

/obj/item/weapon/gun/vehicle_turret/cobra_cannon
	name = "Cobra Cannon"
	desc = "Twin linked railguns."

	projectile_fired = /obj/item/projectile/bullet/cobra_cannon

	fire_delay = 2 SECONDS
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'

	burst = 2
	burst_delay = 0.5 SECONDS

/obj/item/weapon/gun/vehicle_turret/cobra_sniper
	name = "Cobra Sniper Cannon"
	desc = "Railgun single fire mode, heavy anti armour."

	projectile_fired = /obj/item/projectile/bullet/cobra_sniper

	fire_delay = 4 SECONDS
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'

	burst = 1

/obj/item/projectile/bullet/cobra_cannon
	damage = 40
	armor_penetration = 50

/obj/item/projectile/bullet/cobra_sniper
	damage = 100
	damage_type = "bomb"
	armor_penetration = 100

/obj/item/projectile/bullet/cobra_sniper/get_structure_damage()
	return damage * 5

/obj/item/projectile/bullet/cobra_sniper/attack_mob()
	damage_type = BRUTE
	damtype = BRUTE
	return ..()