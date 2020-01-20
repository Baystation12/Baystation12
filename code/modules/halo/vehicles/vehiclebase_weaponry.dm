
/obj/item/weapon/gun/vehicle_turret
	name = "Vehicle Turret"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"
	w_class = ITEM_SIZE_LARGE
	can_rename = 0

	var/obj/vehicles/linked_vehicle
	var/obj/item/projectile/projectile_fired = /obj/item/projectile/bullet/hmg127_he //The typepath of the projectile fired by this gun.

	fire_delay = 7

	burst = 1

/obj/item/weapon/gun/vehicle_turret/New(var/vehicle)
	linked_vehicle = vehicle
	. = ..()

/obj/item/weapon/gun/vehicle_turret/dropped(var/mob/user)
	loc = null
	qdel(src)

//Inside-vehicle attack related procs.
/obj/item/weapon/gun/vehicle_turret/afterattack(atom/target, var/mob/living/carbon/human/user, inrange, params)
	if(target == linked_vehicle)
		to_chat(user,"<span class = 'notice'>You can't fire at yourself.</span>")
		return
	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return
	if(!linked_vehicle.comp_prof.gunner_fire_check(user,linked_vehicle,src))
		user.drop_from_inventory(src)
		return
	if(linked_vehicle.guns_disabled)
		to_chat(user,"<span class = 'notice'>[linked_vehicle]'s weapons have been heavily damaged.</span>")
		return
	for(var/i = 0,i<burst,i++)
	//	linked_vehicle.controller.gunner_turret_fire(user,target)
		if(i == 0) //First shot: Don't delay.
			relay_fire_action(user,target)
			continue
		spawn(burst_delay * i)
			relay_fire_action(user,target)
	next_fire_time = world.time + fire_delay

/obj/item/weapon/gun/vehicle_turret/proc/relay_fire_action(var/mob/user,var/atom/target)
	playsound(user, fire_sound, 50, 1)
	var/obj/item/projectile/new_projectile_fired = new projectile_fired
	new_projectile_fired.permutated += list(linked_vehicle) + linked_vehicle.occupants.Copy()
	new_projectile_fired.loc = pick(linked_vehicle.locs)
	new_projectile_fired.launch(target)

/obj/item/weapon/gun/vehicle_turret/switchable
	var/list/guns_switchto = list()

/obj/item/weapon/gun/vehicle_turret/switchable/attack_self(var/mob/user)
	if(world.time < next_fire_time)
		to_chat(user,"<span class = 'notice'>Wait for the current burst to finish.</span>")
		return
	var/current_gun_index = null
	for(var/datum/vehicle_gun/gun in guns_switchto)
		if(gun.name == name && gun.proj_fired == projectile_fired)
			current_gun_index = guns_switchto.Find(gun)
	var/next_gun_index = current_gun_index + 1
	if(next_gun_index > guns_switchto.len)
		next_gun_index -= guns_switchto.len

	var/datum/vehicle_gun/next_gun = guns_switchto[next_gun_index]
	name = next_gun.name
	desc = next_gun.desc
	projectile_fired = next_gun.proj_fired
	burst = next_gun.burst_size
	fire_delay = next_gun.fire_delay
	burst_delay = next_gun.burst_delay
	fire_sound = next_gun.fire_sound
	to_chat(user,"<span class = 'notice'>Switched to [name]</span>")

/datum/vehicle_gun
	var/name = "gun"
	var/desc = "gun"
	var/burst_size = 1
	var/burst_delay = 1
	var/fire_delay = 1
	var/fire_sound
	var/proj_fired = /obj/item/projectile

#undef REFILL_SUCCEED
#undef REFILL_FAIL