
/datum/component_profile

	var/list/gunner_weapons = list(/obj/item/weapon/gun/vehicle_turret)
	var/pos_to_check = "gunner" //Allows for overriding position checks for equip/firing of mounted weapon.
	var/obj/vehicles/contained_vehicle

	var/list/components = list() //Non-vital components such as armor plating, ect.
	var/list/vital_components = newlist(/obj/item/vehicle_component/health_manager) //Vital components, engine, thrusters etc.

	var/cargo_capacity = 0 //The capacity of the cargo hold. Items increase the space taken by  base_storage_cost(w_class) formula used in inventory_sizes.dm.
	var/vehicle_capacity = 0 //The capacity of the vehicle hold. Vehicles increase space taken by base_storage_cost(vehicle_size + 5)
	var/max_vehicle_size = 0//Determines the maximum vehicle size. Used alongside vehicle ferrying to determine biggest vehicle carriable and quantity.
	var/cargo_allow_massive = 0
	var/list/current_cargo = list()

/datum/component_profile/New(var/obj/vehicles/creator)
	. = ..()
	contained_vehicle = creator
	if(isnull(contained_vehicle))
		return
	for(var/obj/comp in components)
		contained_vehicle.contents += comp
	for(var/obj/comp in vital_components)
		contained_vehicle.contents += comp

/datum/component_profile/proc/can_attach_vehicle(var/vehicle_size)
	return can_put_cargo(vehicle_size + 5,1)//+5 to start at inventory size huge.(value of 16)

/datum/component_profile/proc/can_put_cargo(var/item_w_class,var/for_vehicle = 0)
	var/used_capacity = cargo_capacity
	if(for_vehicle)
		used_capacity = vehicle_capacity
		if(item_w_class > max_vehicle_size)
			return 0
	if(item_w_class == ITEM_SIZE_NO_CONTAINER)
		return 0
	if(!cargo_allow_massive)
		if((item_w_class == ITEM_SIZE_HUGE || item_w_class == ITEM_SIZE_GARGANTUAN))
			return 0
	var/new_used = get_cargo_used(for_vehicle) + base_storage_cost(item_w_class)
	if(for_vehicle)
		if(new_used > vehicle_capacity)
			return 0
	else
		if(new_used > used_capacity)
			return 0
	return 1

/datum/component_profile/proc/get_cargo_used(var/get_vehicle = 0)
	var/total_amount = 0
	if(get_vehicle)
		for(var/obj/vehicles/vehicle in current_cargo)
			total_amount += base_storage_cost(vehicle.vehicle_size + 5)
	else
		for(var/obj/item in current_cargo)
			total_amount +=  base_storage_cost(item.w_class)
	return total_amount

/datum/component_profile/proc/get_coverage_sum()
	var/coverage_sum = 0
	for(var/obj/item/vehicle_component/component in components)
		coverage_sum += component.coverage * (component.integrity/initial(component.integrity))
	return coverage_sum

/datum/component_profile/proc/cargo_transfer(var/obj/object,var/remove = 0)
	if(remove && !(object in current_cargo))
		return 0
	else if(remove)
		contained_vehicle.contents -= object
		current_cargo -= object
		object.loc = pick(contained_vehicle.locs)
		return object
	else
		var/obj/vehicles/vehicle = object
		if(istype(vehicle))
			vehicle.kick_occupants()
		object.loc = null
		contained_vehicle.contents += object
		current_cargo += object
		return 1

/datum/component_profile/proc/take_component_damage(var/proj_damage,var/proj_damtype)
	var/max_comp_coverage = get_coverage_sum()
	var/obj/item/vehicle_component/comp_to_dam
	if(!components || !components.len)
		comp_to_dam = pick(vital_components)
	else
		if(max_comp_coverage >= 100 && (components.len > 0))
			comp_to_dam = pick(components)
		else if(prob(100 - max_comp_coverage))
			comp_to_dam = pick(vital_components)
	var/comp_resistance = comp_to_dam.get_resistance_for(proj_damtype)
	comp_to_dam.damage_integrity(proj_damage*(1 - comp_resistance/100))

/datum/component_profile/proc/take_comp_explosion_dam(var/ex_severity)
	var/max_comp_coverage = get_coverage_sum()
	var/list/comps_to_dam
	if(!components || !components.len)
		comps_to_dam = vital_components
	else if(max_comp_coverage >= 100 && (components.len > 0))
		comps_to_dam = components
	else if(prob(100 - max_comp_coverage))
		comps_to_dam = vital_components
	for(var/obj/item/vehicle_component/component in comps_to_dam)
		var/comp_resistance = component.get_resistance_for("explosion")
		component.damage_integrity((initial(component.integrity)/2 /(ex_severity)) * (1- comp_resistance/100),)

/datum/component_profile/proc/give_gunner_weapons(var/obj/vehicles/source_vehicle)
	var/list/gunners = source_vehicle.get_occupants_in_position(pos_to_check)
	for(var/mob/living/carbon/human/gunner in gunners)
		if(gunner.get_active_hand() || gunner.get_inactive_hand()) //Let's not give anyone a gun if they're messing with their inventory, or already have a gun.
			continue
		var/obj/item/weapon/gun/vehicle_turret/weapon = gunner_weapons[gunners.Find(gunner)]
		if(isnull(weapon))
			continue
		weapon = new weapon(source_vehicle)
		gunner.put_in_hands(weapon)

/datum/component_profile/proc/gunner_fire_check(var/mob/user,var/obj/vehicles/source_vehicle)
	var/list/gunners = source_vehicle.get_occupants_in_position(pos_to_check)
	if(user in gunners)
		return 1
	else
		to_chat(user,"<span class = 'notice'>You need to be in the [pos_to_check] position to fire that!</span>")
	return 0

//BASE VEHICLE COMPONENT DEFINE
/obj/item/vehicle_component
	name = "Vehicle Component"
	desc = "A component of a vehicle."

	var/integrity = 100
	var/coverage = 10
	var/list/resistances = list("brute"=0.0,"burn"=0.0,"emp"=0.0,"explosion" = 0.0) //Functions as a percentage reduction of damage of the type taken.

/obj/item/vehicle_component/proc/get_resistance_for(var/damage_type)
	var/resistance = resistances[damage_type]
	if(isnull(resistance))
		return 0
	else
		return resistance

/obj/item/vehicle_component/proc/full_integ_loss() //This is called when the vehicle loses it's integrity entirely.

/obj/item/vehicle_component/proc/damage_integrity(var/adjust_by = 0)
	var/new_integ = integrity - adjust_by
	if(new_integ > initial(integrity))
		integrity = initial(integrity)
	else if(new_integ < 0)
		integrity = 0
		full_integ_loss()
	else
		integrity = new_integ

/obj/item/vehicle_component/health_manager //Essentially a way for vehicles to just use basic "health" instead of the component system.
	integrity = 200
	coverage = 10000

/obj/item/vehicle_component/health_manager/full_integ_loss()
	var/obj/vehicles/vehicle_contain = loc
	if(!istype(loc))
		return
	vehicle_contain.on_death()
	qdel(src)
