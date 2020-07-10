
#define SPACE_PER_COMPONENT 5

/obj/machinery/research/protolathe
	var/list/stored_components = list()
	var/components_storage_used = 0
	var/list/components_types_names = list()
	var/list/accepted_objs = list(\
		/obj/item/plasma_core,\
		/obj/item/weapon/cell/device/standard,\
		/obj/item/device/assembly/signaler,\
		/obj/item/device/assembly/timer,\
		/obj/item/device/assembly/igniter,\
		/datum/autolathe/recipe/sensor_prox,\
		/datum/autolathe/recipe/sensor_infra,\
		/obj/item/dumb_ai_chip,\
		/obj/item/weapon/reagent_containers/syringe)

/obj/machinery/research/protolathe/proc/attempt_load_component(var/obj/item/I, var/mob/user as mob)

	//do we accept this thing?
	var/base_type
	for(var/check_type in accepted_objs)
		if(istype(I, check_type))
			base_type = check_type
			break

	if(!base_type)
		to_chat(user,"<span class='notice'>[src] cannot accept items of that type.</span>")
		return FALSE

	//check for free space here
	if(get_free_storage() < SPACE_PER_COMPONENT)
		to_chat(user,"<span class='notice'>Insufficient space in [src].</span>")
		return FALSE

	//might not always be a user trying to load something
	if(user)
		user.drop_item()
		to_chat(user, "<span class='info'>You insert \icon[I] [I] into [src].</span>")

	//convert it to the base type
	var/insert_name = components_types_names[base_type]
	if(!insert_name)
		components_types_names[base_type] = initial(I.name)

	//safety check here
	if(!stored_components[base_type])
		stored_components[base_type] = 0

	//increment the stock
	stored_components[base_type] += 1
	components_storage_used += SPACE_PER_COMPONENT

	//delete the thing
	qdel(I)

	//update the ui
	UpdateComponentsString()

	return TRUE

/obj/machinery/research/protolathe/proc/consume_obj(var/consume_type, var/amount)
	//decrement the stock
	stored_components[consume_type] -= amount
	components_storage_used -= SPACE_PER_COMPONENT

	//forget about it
	if(!stored_components[consume_type])
		stored_components -= consume_type
		components_types_names -= consume_type

	//update the ui
	UpdateComponentsString()

/obj/machinery/research/protolathe/proc/eject_obj(var/obj_type)
	//to_debug_listeners("Ejecting \'[obj_name]\' from protolathe")
	var/obj/M = new obj_type(src.loc)
	consume_obj(M.type, 1)


	//move it out from the protolathe's tile
	if(output_dir)
		spawn(5)
			if(M && M.loc == src.loc)
				var/turf/target_turf = get_step(src, output_dir)
				M.Move(target_turf)

#undef SPACE_PER_COMPONENT
