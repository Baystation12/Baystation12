
/obj/item/weapon/gun/vehicle_turret
	name = "Vehicle Turret"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"
	w_class = ITEM_SIZE_LARGE
	can_rename = 0

	var/obj/vehicles/linked_vehicle
	var/magazine_type = /obj/item/ammo_magazine
	var/obj/item/ammo_magazine/mag_use

	fire_delay = 7

	burst = 1

/obj/item/weapon/gun/vehicle_turret/New(var/vehicle)
	linked_vehicle = vehicle
	reconsider_magazine()
	. = ..()

/obj/item/weapon/gun/vehicle_turret/dropped(var/mob/user)
	loc = null
	qdel(src)

/obj/item/weapon/gun/vehicle_turret/afterattack(atom/attacked, mob/user, proximity)
	if(attacked == linked_vehicle)
		to_chat(user,"<span class = 'notice'>You can't fire at yourself.</span>")
		return
	if(!linked_vehicle.comp_prof.gunner_fire_check(user,linked_vehicle,src))
		user.drop_from_inventory(src)
		return
	. = ..()

/obj/item/weapon/gun/vehicle_turret/proc/reconsider_magazine()
	mag_use = locate(magazine_type) in linked_vehicle.ammo_containers

//Inside-vehicle attack related procs.
/obj/item/weapon/gun/vehicle_turret/consume_next_projectile()
	if(mag_use)
		if(mag_use.stored_ammo.len == 0)
			return null
		var/obj/item/ammo_casing/casing = mag_use.stored_ammo[1]
		var/obj/item/projectile/proj = casing.expend()
		mag_use.stored_ammo -= casing
		return proj

/obj/item/weapon/gun/vehicle_turret/switchable
	var/list/guns_switchto = list()
	var/current_index = 1

/obj/item/weapon/gun/vehicle_turret/switchable/attack_self(var/mob/user)
	. = ..()
	if(world.time < next_fire_time)
		to_chat(user,"<span class = 'notice'>Wait for the current burst to finish.</span>")
		return
	var/next_gun_index = current_index + 1
	if(next_gun_index > guns_switchto.len)
		next_gun_index = 1

	var/datum/vehicle_gun/next_gun = guns_switchto[next_gun_index]
	name = next_gun.name
	desc = next_gun.desc
	magazine_type = next_gun.mag_used
	reconsider_magazine()
	burst = next_gun.burst_size
	fire_delay = next_gun.fire_delay
	burst_delay = next_gun.burst_delay
	fire_sound = next_gun.fire_sound
	to_chat(user,"<span class = 'notice'>Switched to [name]</span>")
	current_index = next_gun_index

/datum/vehicle_gun
	var/name = "gun"
	var/desc = "gun"
	var/burst_size = 1
	var/burst_delay = 1
	var/fire_delay = 1
	var/fire_sound
	var/mag_used

#undef REFILL_SUCCEED
#undef REFILL_FAIL