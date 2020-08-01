
#define SPACE_PER_COMPONENT 5

/obj/machinery/research/protolathe
	var/list/stored_components = list()
	var/components_storage_used = 0
	var/list/accepted_objs = list(\
		/obj/item/crystal,\
		/obj/item/plasma_core,\
		/obj/item/weapon/cell/device/standard,\
		/obj/item/device/assembly/signaler,\
		/obj/item/device/assembly/timer,\
		/obj/item/device/assembly/igniter,\
		/datum/autolathe/recipe/sensor_prox,\
		/datum/autolathe/recipe/sensor_infra,\
		/obj/item/dumb_ai_chip,\
		/obj/item/weapon/reagent_containers/syringe,\
		/obj/item/weapon/stock_parts,\
		/obj/item/weapon/pickaxe,\
		/obj/item/device/flashlight)

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
		I.forceMove(src)
		to_chat(user, "<span class='info'>You insert \icon[I] [I] into [src].</span>")

	//safety check here
	var/list/L = stored_components[I.type]
	if(!L)
		L = list()
		stored_components[I.type] = L

	//increment the stock
	L.Add(I)
	components_storage_used += SPACE_PER_COMPONENT

	//update the ui
	UpdateComponentsString()

	return TRUE

/obj/machinery/research/protolathe/proc/consume_obj(var/consume_type, var/amount, var/do_eject = FALSE)
	var/list/L = stored_components[consume_type]

	if(L)
		//decrement the stock
		while(L.len && amount > 0)
			amount--
			var/atom/movable/A = pop(L)
			components_storage_used -= SPACE_PER_COMPONENT

			if(do_eject)
				//move it onto the turf
				A.forceMove(src.loc)

				//move it out from the protolathe's tile
				if(output_dir)
					spawn(5)
						if(A && A.loc == src.loc)
							var/turf/target_turf = get_step(src, output_dir)
							A.Move(target_turf)
			else
				qdel(A)

	//forget about it
	if(!L || !L.len)
		stored_components -= consume_type

	//update the ui
	UpdateComponentsString()

#undef SPACE_PER_COMPONENT
