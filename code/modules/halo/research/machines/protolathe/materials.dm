
/obj/machinery/research/protolathe
	var/list/stored_materials = list()
	var/material_storage_used = 0

/obj/machinery/research/protolathe/proc/load_material(var/obj/item/stack/material/M, var/mob/user as mob)

	//check for free space here
	var/free_storage = get_free_storage()
	if(!free_storage)
		to_chat(user, "<span class='info'>[src] has no free space.</span>")
		return

	var/amount_taken = min(free_storage, M.amount)
	//might not always be a user trying to load something
	/*if(user)
		user.drop_item()*/

	var/descripter = M.amount == 1 ? M.material.sheet_singular_name : M.material.sheet_plural_name
	to_chat(user, "<span class='info'>You insert [amount_taken] [descripter] of \icon[M] [M.material.name] into [src].</span>")

	//do we already have some?
	var/material_name = M.default_type
	if(!stored_materials[material_name])
		stored_materials[material_name] = 0

	//add it
	stored_materials[material_name] += amount_taken
	material_storage_used += amount_taken

	//delete the obj
	M.use(amount_taken)

	//update the ui
	UpdateMaterialsString()

	//add a sprite effect
	overlays += "protolathe_metal"
	spawn(10)
		overlays -= "protolathe_metal"

	return TRUE

/obj/machinery/research/protolathe/proc/consume_material(var/mat_name, var/amount)
	stored_materials[mat_name] -= amount
	material_storage_used -= amount

	//forget about it
	if(!stored_materials[mat_name])
		stored_materials -= mat_name

	//update the ui
	UpdateMaterialsString()

/obj/machinery/research/protolathe/proc/eject_materials(var/mat_name, var/mob/user)
	//dont eject more than we have
	var/eject_max = stored_materials[mat_name]

	//how much does the user want to eject?
	var/eject_amount = eject_max

	if(user)
		eject_amount = input("Choose the amount to eject (0-[eject_max]). Enter [round(eject_max) + 1] to dump any leftovers.",\
		"Ejecting [mat_name]",10) as num|null

	if(eject_amount)
		//sometimes there might be an imprecise amount eg 0.8 sheets worth of material
		//we can either dump it to free some space, or leave it in the machine
		if(eject_amount <= eject_max)
			//the player wants to keep the leftovers
			//round down to the nearest whole number
			eject_amount = round(eject_amount)

		//create the stack item for the material
		var/material/mat = get_material_by_name(mat_name)
		var/obj/item/stack/material/M = new mat.stack_type(src.loc)
		M.amount = 0

		//stacks have an inherent size limit
		//will we max out the stack? dont eject any more than that
		eject_max = min(eject_max, M.max_amount)

		//dont go over the limit we set
		//this means we dont dump any leftovers if we are ejecting the limit
		eject_amount = min(eject_amount, eject_max)

		//increase the stack size
		M.add(round(eject_amount))

		//move it out from the protolathe's tile
		if(output_dir)
			spawn(5)
				if(M && M.loc == src.loc)
					var/turf/target_turf = get_step(src, output_dir)
					M.Move(target_turf)

		//remove the materials from storage
		consume_material(mat_name, eject_amount)

		//tell the user
		var/descriptor = eject_amount == 1 ? M.material.sheet_singular_name : M.material.sheet_plural_name
		to_chat(user,"<span class='info'>Ejected [eject_amount] [M.material.name] [descriptor] from [src].</span>")
