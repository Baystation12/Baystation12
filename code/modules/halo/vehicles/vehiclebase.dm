
/obj/vehicles
	name = "basevehicle"
	desc = "A base vehicle. You shouldn't be seeing this."
	density = 1

	layer = ABOVE_HUMAN_LAYER
	plane = ABOVE_HUMAN_PLANE

	var/active = 1
	var/health = list(100,100) //In format Health / Maxhealth
	var/mob/living/driver
	var/list/passengers = list(0)//A list storing the passengers of the vehicle. First entry defines the maximum.
	var/list/gunners = list(0)//Ditto, but for gunners.
	var/list/gunner_weapons = list()
	var/block_entry_exit // A variable that, when set, will stop people entering/leaving the vehicle.

	var/damage_modifiers = list("brute" = 1.0, "burn" = 1.0,"emp" = 1.0)
	var/datum/vehicle_control/controller = /datum/vehicle_control/base
	var/sprite_offsets = list("1" = list(0,0),"2" = list(0,0),"4" = list(0,0),"8" = list(0,0)) //Sprite offsets, handled on subtype basis. Format: string:Vehicle_dir - list(x,y)

	var/list/fuels = list() //fuels required for a vehicle to run. Format fuel_datum
	var/list/fuel_drainrates = list()
	var/vehicle_move_delay = 2 //The move delay in ticks.


/obj/vehicles/New()
	controller = new controller (src)
	for(var/i in fuels)
		fuels += new i
		fuels -= i

/obj/vehicles/attack_hand(var/mob/user)
	controller.on_click(null,user)

/obj/vehicles/attackby(var/obj/item/W,var/mob/living/user)
	controller.on_click(W,user)

/obj/vehicles/relaymove(var/turf/newloc,var/dir)
	Move(newloc,dir)

/obj/vehicles/Move(var/turf/newloc,var/dir)
	render_mob_sprites()
	if(!controller.try_move(newloc,dir))
		return 0
	. = ..()

/obj/vehicles/proc/on_gunner_turret_drop(var/mob/user)
	controller.gunner_turret_drop(user)

/obj/vehicles/proc/render_mob_sprites()//Currently does nothing, but can be overriden later down the line to show who's inside a vehicle.

/obj/vehicles/proc/assign_driver(var/mob/user)
	driver = user
	driver.driving = src
	contents += user
	to_chat(user,"<span class = 'notice'>You are now the driver of [src.name]</span>")

/obj/vehicles/proc/unassign_driver(var/mob/user)
	driver = null
	user.driving = null
	to_chat(user,"<span class = 'warning'>You are no longer the driver of [src.name]</span>")

/obj/vehicles/proc/give_gunner_weapon(var/mob/user)
	if(!(user in gunners))
		return
	var/mob/living/carbon/human/h = user
	if(!istype(h))
		return
	var/gunner_index = gunners.Find(user)
	var/obj/item/weapon_to_give = gunner_weapons[gunner_index-1]
	if(!h.put_in_active_hand(new weapon_to_give(src)))
		h.put_in_active_hand(new weapon_to_give(src))

/obj/vehicles/proc/remove_gunner_weapon(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	for(var/obj/item/weapon/gun/vehicle_turret/gun in list(user.l_hand,user.r_hand))
		user.drop_from_inventory(gun)

/obj/vehicles/proc/assign_gunner(var/mob/user)
	gunners += user
	contents += user
	to_chat(user,"<span class = 'notice'>You are now a gunner of [src.name]</span>")
	give_gunner_weapon(user)

/obj/vehicles/proc/unassign_gunner(var/mob/user)
	gunners -= user
	remove_gunner_weapon(user)
	to_chat(user,"<span class = 'warning'>You are no longer a gunner of [src.name]</span>")

/obj/vehicles/proc/update_description()
	var/percentile_health = health[1]/health[2]
	if(percentile_health <= 0.75)
		desc += "<span class = 'warning'>It is partially damaged.</span>"
	else if(percentile_health <= 0.5)
		desc += "<span class = 'warning'>It is badly damaged.</span>"
	else if(percentile_health <= 0.25)
		desc += "<span class = 'warning'>It is critically damaged.</span>"

/obj/vehicles/proc/process_health_damage()
	if(health[1] <= 0)
		on_death()
	else
		update_description()

/obj/vehicles/proc/on_death()
	for(var/mob/m in contents)
		exit_vehicle(m)
	explosion(loc,-1,-1,2,3)
	qdel(src)

/obj/vehicles/verb/enter_vehicle(var/mob/user)
	set name = "Enter Vehicle"
	set category = "Vehicle"
	set src in range(1)

	if(block_entry_exit)
		return
	if(!driver)
		assign_driver(user)
	else if(gunners.len < passengers[1] + 1)
		assign_gunner(user)
	else if(passengers.len < passengers[1] + 1)
		passengers += user
		contents += user
	render_mob_sprites()

/obj/vehicles/verb/exit_vehicle(var/mob/user)
	set name = "Exit Vehicle"
	set category = "Vehicle"
	set src in range(1)

	if(block_entry_exit)
		return
	if(driver == user)
		unassign_driver(user)
	if(user in passengers)
		passengers -= user
	if(user in gunners)
		unassign_gunner(user)
	user.loc = src.loc
	render_mob_sprites()

/obj/vehicles/emp_act(var/severity)
	. = controller.on_emp(severity)

/obj/vehicles/bullet_act(var/obj/item/projectile/P,var/def_zone)
	. = controller.on_bullet_act(P,def_zone)

/obj/vehicles/debug
	name = "debug vehicle"

	passengers = list(1)
	gunners = list(1)

	fuels = list(/datum/fuel/fusion)
	fuel_drainrates = list(1)

	gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret)
	icon = 'code/modules/halo/icons/Warthog.dmi'
	icon_state = "Base, no wheels"
	bound_height = 64
	bound_width = 64

//Control Datums//
/datum/vehicle_control
	var/obj/vehicles/vehicle

/datum/vehicle_control/New(var/parent_vehicle)
	vehicle = parent_vehicle

/datum/vehicle_control/proc/try_move(var/newloc,var/dir)
	return 1

/datum/vehicle_control/proc/on_click(var/obj/item/inhand_item,var/mob/living/user)

/datum/vehicle_control/proc/fuel_check()
	return 1

/datum/vehicle_control/proc/gunner_turret_drop(var/mob/user)

/datum/vehicle_control/proc/gunner_turret_fire(var/mob/user,var/atom/target)

/datum/vehicle_control/proc/on_emp(var/severity)

/datum/vehicle_control/proc/on_bullet_act(var/obj/item/projectile/P,var/def_zone)

/datum/vehicle_control/proc/on_enter_vehicle()

/datum/vehicle_control/proc/on_exit_vehicle()

//Basic control datum//

/datum/vehicle_control/base

/datum/vehicle_control/base/try_move(var/newloc,var/newdir)
	if(!vehicle.active)
		return 0
	if(!fuel_check())
		return 0
	return 1

/datum/vehicle_control/base/on_click(var/obj/item/inhand_item,var/mob/living/user)
	if(inhand_item)
		//Check if fuel-item,
		if(istype(inhand_item,/obj/item/fuel_item)) //Not entirely sure if this should be here or if fuel-related things should be moved to a sub-datum.
			var/obj/item/fuel_item/fuel_item = inhand_item
			for(var/datum/fuel/f in vehicle.fuels)
				for(var/datum/fuel/F in fuel_item.contained_fuel)
					var/fuel_result = F.drain_fuel(f.volume[2] - f.volume[1])
					switch(fuel_result)
						if(REFILL_FAIL)
							return
						if(REFILL_SUCCEED)
							f.attempt_refill(f.volume[2] - f.volume[1])
							return
					f.attempt_refill(fuel_result)

		//Or do damage
		var/damage_resist_amount = 0
		if(inhand_item.damtype in vehicle.damage_modifiers)
			damage_resist_amount = vehicle.damage_modifiers[inhand_item.damtype]
		if(inhand_item.force > damage_resist_amount)
			vehicle.health[1] -= inhand_item.force
			vehicle.visible_message("<span class = 'danger'>[user] [pick(inhand_item.attack_verb)] [vehicle.name]</span>")
	else
		if(user in vehicle.contents)
			vehicle.exit_vehicle(user)
			on_exit_vehicle()
		else
			vehicle.enter_vehicle(user)
			on_enter_vehicle(user)

/datum/vehicle_control/base/on_emp(var/severity)
	vehicle.vehicle_move_delay = vehicle.vehicle_move_delay * 2 * severity * vehicle.damage_modifiers["emp"]
	spawn(vehicle.vehicle_move_delay)
		vehicle.vehicle_move_delay = initial(vehicle.vehicle_move_delay)

/datum/vehicle_control/on_bullet_act(var/obj/item/projectile/P,var/def_zone)
	var/damage_resist_amount = 0
	if(P.damtype in vehicle.damage_modifiers)
		damage_resist_amount = vehicle.damage_modifiers[P.damtype]
	if(P.damage > damage_resist_amount)
		vehicle.health[1] -= P.damage
		vehicle.process_health_damage()
		vehicle.visible_message("<span class = 'danger'>[vehicle.name] is hit by [P.name]</span>")
		return 1

/datum/vehicle_control/base/gunner_turret_drop(var/mob/user)
	vehicle.unassign_gunner(user)

/datum/vehicle_control/base/gunner_turret_fire(var/mob/user,var/atom/target)
	vehicle.dir = get_dir(vehicle,target)
	vehicle.vehicle_move_delay = vehicle.vehicle_move_delay * 1.5
	spawn(vehicle.vehicle_move_delay)
		vehicle.vehicle_move_delay = initial(vehicle.vehicle_move_delay)

/datum/vehicle_control/base/fuel_check()
	var/check_succeeded = 1
	for(var/datum/fuel/f in vehicle.fuels) //This base vehicle controller has support for fuel, but it otherwise defaults to allowing the move.
		var/fuel_status = f.drain_fuel(vehicle.fuel_drainrates[vehicle.fuels.Find(f)])
		if(fuel_status == REFILL_FAIL)
			check_succeeded = 0
	if(!check_succeeded)
		return 0
	return 1
