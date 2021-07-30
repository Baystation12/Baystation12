
/obj/vehicles/proc/can_put_cargo(var/obj/object)
	if(!istype(object))
		return 0
	if(object.anchored)
		return 0

	var/space_needed = base_storage_cost(get_cargo_size(object))
	return space_needed <= (cargo_capacity - used_cargo_space)

/obj/vehicles/proc/get_cargo_size(var/obj/object)
	var/item_size = object.w_class
	if(istype(object, /obj/structure))
		item_size = ITEM_SIZE_HUGE
	if(istype(object, /obj/machinery))
		item_size = ITEM_SIZE_HUGE
	if(istype(object, /obj/vehicles))
		var/obj/vehicles/vehicle = object
		item_size = vehicle.vehicle_size
	return item_size

/obj/vehicles/proc/put_cargo_item(var/mob/user, var/obj/O)

	if(!src.Adjacent(user) || !src.Adjacent(O))
		return FALSE
	if(!can_put_cargo(O))
		to_chat(user,"<span class = 'notice'>[O] can not be loaded into [src]</span>")
		return FALSE
	var/confirm = alert(user,"Place [O] into [src]'s storage?",,"Yes","No")
	if(confirm != "Yes")
		return FALSE
	var/cargo_size = get_cargo_size(O)
	if(cargo_size > 4 && !do_after(user, 30, O, progbar_on_user = 1))
		return FALSE
	user.visible_message("<span class = 'notice'>[user] loads [O] into [src].</span>")
	user.drop_from_inventory(O)
	O.loc = src
	cargo_contents += O
	used_cargo_space += base_storage_cost(get_cargo_size(O))
	src.verbs |= /obj/vehicles/proc/get_cargo_item
	return TRUE

/obj/vehicles/proc/load_vehicle(var/obj/vehicles/v,var/mob/user)
	if(!vehicle_carry_size)
		to_chat(user,"<span class = 'notice'>[src] cannot carry vehicles!</span>")
		return
	if(v.vehicle_size > vehicle_carry_size)
		to_chat(user,"<span class = 'notice'>[src] cannot carry vehicles of [v]'s size.</span>")
		return
	if(carried_vehicle)
		to_chat(user,"<span class = 'notice'>[src] is already carrying [carried_vehicle]!</span>")
		return
	for(var/mob/living/M in v)
		to_chat(user,"<span class = 'notice'>[src] cannot be loaded while it's carrying live passengers!</span>")
		return
	if(!src.Adjacent(v))
		to_chat(user,"<span class = 'notice'>Both the vehicle and the person attaching the vehicle must be next to the targeted storage vehicle.</span>")
		return

	user.visible_message("<span class = 'notice'>[user] starts loading [v] into [src]\'s storage.</span>")
	if(!do_after(user,VEHICLE_ITEM_LOAD,v, progbar_on_user = 1))
		return
	user.visible_message("<span class = 'info'>[user] loads [v] into [src].</span>")
	carried_vehicle = v
	v.loc = src
	verbs += /obj/vehicles/proc/detach_vehicle

/obj/vehicles/proc/detach_vehicle()
	set category = "Vehicle"
	set name = "Detach vehicle"
	set src in view(1)

	if(!carried_vehicle)
		to_chat(usr,"<span class = 'notice'>You're not carrying a vehicle to detach!</span>")
		return
	verbs -= /obj/vehicles/proc/detach_vehicle
	carried_vehicle.loc = pick_valid_exit_loc()
	carried_vehicle = null

/obj/vehicles/MouseDrop_T(atom/dropping, mob/user)
	if(dropping == src)
		return
	if(dropping == user)
		return
	var/obj/vehicles/v = dropping
	if(istype(v))
		load_vehicle(v,user)
	else
		put_cargo_item(user, dropping)

/obj/vehicles/proc/get_cargo_item()
	set name = "Retrieve Cargo"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated())
		return

	if(user.loc == src)
		to_chat(user, "<span class='notice'>You cannot retrieve cargo while inside [src].</span>")
		return

	var/list/cargo_list_names = list("Cancel")
	for(var/obj/item in cargo_contents)
		cargo_list_names += item.name
		cargo_list_names[item.name] = item
	var/item_name_remove = input(user,"Pick an item to remove","Item removal selection","Cancel") in cargo_list_names
	if(item_name_remove == "Cancel")
		return
	eject_cargo_item(cargo_list_names[item_name_remove], user)

/obj/vehicles/proc/eject_cargo_item(var/obj/object_removed, var/atom/movable/target)
	object_removed.forceMove(target)
	if(isliving(target))
		var/mob/living/user = target
		if(!user.put_in_hands(object_removed))
			object_removed.forceMove(user.loc)
	cargo_contents -= object_removed
	used_cargo_space -= base_storage_cost(get_cargo_size(object_removed))
	if(!cargo_contents.len)
		src.verbs -= /obj/vehicles/proc/get_cargo_item

/obj/vehicles/proc/handle_grab_attack(var/obj/item/grab/I, var/mob/user)
	var/mob/living/grabbed_mob = I.affecting
	var/mob/living/carbon/human/h = user
	if(!istype(grabbed_mob) || !istype(h) || !src.Adjacent(grabbed_mob) || !src.Adjacent(h))
		return
	if(grabbed_mob.stat == CONSCIOUS)
		if(!do_after(user, VEHICLE_LOAD_DELAY,grabbed_mob,1,1,,1))
			return
	var/enter_result = enter_as_position(grabbed_mob,"passenger")
	h.drop_from_inventory(I)
	if(enter_result == 0)
		to_chat(user,"<span class = 'notice'>Something stops you putting [grabbed_mob] in [src.name]'s passenger seat.</span>")
	return

/obj/vehicles/verb/pull_occupant_out()
	set name = "Remove Occupant"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/puller = usr
	if(!istype(puller) || puller.incapacitated())
		return

	var/list/all_viable_occupants = list()
	for(var/mob/occ in occupants)
		all_viable_occupants += "[occ.name]"
		all_viable_occupants["[occ.name]"] = occ
	var/chosen_occ_name = input(puller,,"Occupant Removal Selection","Cancel") in all_viable_occupants + list("Cancel")
	if(chosen_occ_name == "Cancel")
		return
	var/mob/chosen_occ = all_viable_occupants[chosen_occ_name]
	if(isnull(chosen_occ) || !src.Adjacent(puller))
		return
	if(chosen_occ.stat == CONSCIOUS)
		if(!do_after(puller, VEHICLE_LOAD_DELAY*2,src,1,1,,1))
			return
	exit_vehicle(chosen_occ,1)
