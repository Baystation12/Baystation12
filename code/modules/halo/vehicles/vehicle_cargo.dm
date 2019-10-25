
/obj/vehicles/proc/can_put_cargo(var/obj/object)
	if(!istype(object))
		return 0
	if(object.w_class == ITEM_SIZE_NO_CONTAINER)
		return 0

	var/space_needed = base_storage_cost(object.w_class)
	return space_needed <= (cargo_capacity - used_cargo_space)

/obj/vehicles/proc/put_cargo_item(var/mob/user,var/obj/O)
	if(!src.Adjacent(user) || !src.Adjacent(O))
		return
	var/confirm = alert(user,"Place [O] into [src]'s storage?",,"Yes","No")
	if(confirm != "Yes")
		return
	if(!can_put_cargo(O))
		to_chat(user,"<span class = 'notice'>[src] can not fit [O]</span>")
		return
	user.drop_from_inventory(O)
	O.loc = src
	cargo_contents += O
	used_cargo_space += base_storage_cost(O.w_class)
	src.verbs |= /obj/vehicles/proc/get_cargo_item

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
	if(src.Adjacent(v))
		to_chat(user,"<span class = 'notice'>Both the vehicle and the person attaching the vehicle must be next to the targeted storage vehicle.</span>")
		return

	user.visible_message("<span class = 'notice'>[user] starts loading [v] into [src]\'s storage.</span>")
	if(!do_after(user,VEHICLE_ITEM_LOAD,v))
		return
	user.visible_message("<span class = 'info'>[user] loads [v] into [src].</span>")
	carried_vehicle = v
	v.loc = src
	verbs += /obj/vehicles/proc/detach_vehicle

/obj/vehicles/proc/detach_vehicle()
	set category = "Vehicle"
	set name = "Detach vehicle"
	set src in view(1)

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
		if(!can_put_cargo(dropping))
			to_chat(user,"<span class = 'notice'>[src] is too full to fit [dropping].</span>")
			return
		if(!do_after(user,VEHICLE_ITEM_LOAD,dropping))
			return
		user.visible_message("<span class = 'notice'>[user] loads [dropping] into [src].</span>")

/obj/vehicles/proc/get_cargo_item()
	set name = "Retrieve Cargo"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated())
		return

	var/list/cargo_list_names = list("Cancel")
	for(var/obj/item in cargo_contents)
		cargo_list_names += item.name
		cargo_list_names[item.name] = item
	var/item_name_remove = input(user,"Pick an item to remove","Item removal selection","Cancel") in cargo_list_names
	if(item_name_remove == "Cancel")
		return
	var/obj/object_removed = cargo_list_names[item_name_remove]
	user.put_in_hands(object_removed)
	cargo_contents -= object_removed
	used_cargo_space -= base_storage_cost(object_removed.w_class)
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
