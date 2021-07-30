
/obj/vehicles/cobra
	name = "SP42 Cobra"
	desc = "An anti-fortification and anti-materiel tank capable of providing high damage anti-armour at incredible ranges, however, its durability is low."

	icon = 'code/modules/halo/vehicles/types/Cobra.dmi'
	icon_state = "cobra"
	anchored = 1

	bound_height = 64
	bound_width = 96

	comp_prof = /datum/component_profile/cobra

	ammo_containers = newlist(/obj/item/ammo_magazine/cobra_cannon,/obj/item/ammo_magazine/cobra_sniper)

	exposed_positions = list("passenger"=5)

	occupants = list(2,1)

	vehicle_size = ITEM_SIZE_VEHICLE
	capacity_flag = ITEM_SIZE_NORMAL

	move_sound = 'code/modules/halo/sounds/scorp_move.ogg'

	vehicle_view_modifier = 1.5

	light_color = "#FEFFE1"

	can_smoke = 1
	smoke_ammo = 5 //Technically the urf tank but it's also light armored so let's use same amount as 'hog and shadow.
	smoke_ammo_max = 5
	smoke_step_dist = 1

	can_overrun_cover = 1

	min_speed = 12.5
	max_speed = 4.5
	acceleration = 4
	drag = 3

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
		vehicle_view_modifier = 1.8
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
		vehicle_view_modifier = 1.8

	spawn(5)
		for(var/mob/occupant in occupants)
			update_user_view(occupant,1)
			spawn(1)
				update_user_view(occupant)

/obj/item/vehicle_component/health_manager/cobra
	integrity = 500
	resistances = list("bullet"=75,"energy"=75,"emp"=25,"bomb"=70)
	repair_materials = list("plasteel")

/datum/component_profile/cobra
	pos_to_check = "gunner"
	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret/cobra_cannon)
	vital_components = newlist(/obj/item/vehicle_component/health_manager/cobra)

/obj/item/weapon/gun/vehicle_turret/cobra_cannon
	name = "Cobra Cannon"
	desc = "Twin linked railguns."

	fire_delay = 2 SECONDS
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'

	burst = 2
	burst_delay = 0.5 SECONDS
	magazine_type = /obj/item/ammo_magazine/cobra_cannon

/obj/item/weapon/gun/vehicle_turret/cobra_sniper
	name = "Cobra Sniper Cannon"
	desc = "Railgun single fire mode, heavy anti armour."

	fire_delay = 35
	fire_sound = 'code/modules/halo/sounds/scorp_cannon_fire.ogg'

	burst = 1
	magazine_type = /obj/item/ammo_magazine/cobra_sniper

/obj/item/ammo_magazine/cobra_cannon
	name = "Internal Railgun Ammunition"
	max_ammo = 100
	caliber = "railgun"
	ammo_type = /obj/item/ammo_casing/cobra_cannon

/obj/item/ammo_casing/cobra_cannon
	name = "railgun round"
	caliber = "railgun"
	projectile_type = /obj/item/projectile/bullet/cobra_cannon

/obj/item/projectile/bullet/cobra_cannon
	name = "railgun round"
	damage = 40
	armor_penetration = 50

/obj/item/ammo_magazine/cobra_sniper
	name = "Internal Sniper Railgun Ammunition"
	max_ammo = 40
	caliber = "railgun sniper"
	ammo_type = /obj/item/ammo_casing/cobra_sniper

/obj/item/ammo_casing/cobra_sniper
	name = "railgun round"
	caliber = "railgun sniper"
	projectile_type = /obj/item/projectile/bullet/cobra_sniper

/obj/item/projectile/bullet/cobra_sniper
	name = "railgun round"
	damage = 150
	damage_type = "bomb"
	damtype = "bomb"
	armor_penetration = 200
	shield_damage = 240

/obj/item/projectile/bullet/cobra_sniper/get_structure_damage()
	return damage * 5

/obj/item/projectile/bullet/cobra_sniper/attack_mob()
	damage_type = BRUTE
	damtype = BRUTE
	return ..()