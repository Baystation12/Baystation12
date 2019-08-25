#define SANITIZE_LATHE_COST(n) round(n * mat_efficiency, 0.01)


#define ERR_OK 0
#define ERR_NOTFOUND "not found"
#define ERR_NOMATERIAL "no material"
#define ERR_NOREAGENT "no reagent"
#define ERR_NOLICENSE "no license"
#define ERR_PAUSED "paused"


/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	layer = BELOW_OBJ_LAYER
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000


	circuit = /obj/item/weapon/circuitboard/autolathe
	var/obj/item/weapon/computer_hardware/hard_drive/portable/disk = null

	var/list/stored_material =  list()
	var/storage_capacity = 30 * SHEET_MATERIAL_AMOUNT

	var/obj/item/weapon/reagent_containers/glass/container = null
	var/show_category = "All"

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/paused = FALSE

	var/working = FALSE
	var/anim = 0

	var/error = null

	var/unfolded = null

	var/datum/computer_file/binary/design/current_file = null
	var/list/queue = list()
	var/queue_max = 20

	var/speed = 15

	var/progress = 0

	var/mat_efficiency = 1

	var/have_disk = TRUE
	var/have_reagents = TRUE
	var/have_materials = TRUE

	var/list/error_messages = list(
		ERR_NOLICENSE = "Disk licenses have been exhausted.",
		ERR_NOTFOUND = "Design data not found.",
		ERR_NOMATERIAL = "Not enough materials.",
		ERR_NOREAGENT = "Not enough reagents.",
		ERR_PAUSED = "**Construction Paused**"
	)

	var/tmp/datum/wires/autolathe/wires = null


/obj/machinery/autolathe/Initialize()
	. = ..()
	wires = new(src)

/obj/machinery/autolathe/Destroy()
	if(wires)
		QDEL_NULL(wires)
	return ..()



/obj/machinery/autolathe/ui_data()
	var/list/data = list()

	data["have_disk"] = have_disk
	data["have_reagents"] = have_reagents
	data["have_materials"] = have_materials

	data["error"] = error
	data["paused"] = paused

	data["unfolded"] = unfolded

	data["mat_efficiency"] = mat_efficiency
	data["mat_capacity"] = storage_capacity
	data["speed"] = speed

	if(disk)
		data["disk"] = list(
			"name" = disk.get_disk_name(),
			"license" = disk.license,
			"read_only" = disk.read_only
		)


	var/list/L = list()
	for(var/d in design_list())
		var/datum/computer_file/binary/design/design_file = d
		L.Add(list(design_file.ui_data()))
	data["designs"] = L

	data["container"] = FALSE
	if(container)
		data["container"] = TRUE
		if(container.reagents)
			L = list()
			for(var/datum/reagent/R in container.reagents.reagent_list)
				var/list/LE = list("name" = R.name, "count" = "[R.volume]")

				L.Add(list(LE))

			data["reagents"] = L

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material[mtype] <= 0)
			continue

		var/list/ME = list("name" = mtype, "count" = stored_material[mtype], "ejectable" = TRUE)

		var/material/MAT = get_material_by_name(mtype)
		if(!MAT.stack_type)
			ME["ejectable"] = FALSE

		M.Add(list(ME))

	data["materials"] = M

	if(current_file)
		data["current"] = current_file.ui_data()
		data["progress"] = progress

	var/list/Q = list()
	var/licenses_used = 0
	var/list/qmats = stored_material.Copy()

	for(var/i = 1; i <= queue.len; i++)
		var/datum/computer_file/binary/design/design_file = queue[i]
		var/list/QR = design_file.ui_data()

		QR["ind"] = i

		QR["error"] = 0

		if(design_file.copy_protected)
			licenses_used++

			if(!disk || licenses_used > disk.license)
				QR["error"] = 1

		for(var/rmat in design_file.design.materials)
			if(!(rmat in qmats))
				qmats[rmat] = 0

			qmats[rmat] -= design_file.design.materials[rmat]
			if(qmats[rmat] < 0)
				QR["error"] = 1

		if(can_print(design_file) != ERR_OK)
			QR["error"] = 2

		Q.Add(list(QR))

	data["queue"] = Q
	data["queue_len"] = queue.len
	data["queue_max"] = queue_max

	return data


/obj/machinery/autolathe/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe.tmpl", "Autolathe", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/autolathe/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_crowbar(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(istype(I, /obj/item/weapon/computer_hardware/hard_drive/portable))
		insert_disk(user)

	if(istype(I,/obj/item/stack))
		eat(user)

	user.set_machine(src)
	ui_interact(user)


/obj/machinery/autolathe/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)

	usr.set_machine(src)

	if(href_list["insert"])
		eat(usr)

	if(href_list["disk"])
		if(disk)
			eject_disk()
		else
			insert_disk(usr)

	if(href_list["insert_beaker"])
		insert_beaker(usr)

	if(!current_file || paused)
		if(href_list["eject_material"])
			var/material = href_list["eject_material"]
			var/material/M = get_material_by_name(material)

			if(!M.stack_type)
				return

			var/num = input("Enter sheets number to eject. 0-[stored_material[material]]","Eject",0) as num

			if(!Adjacent(usr))
				return

			num = min(max(num,0), stored_material[material])

			eject(material, num)

		if(href_list["eject_container"])
			container.forceMove(src.loc)

			if(isliving(usr))
				var/mob/living/L = usr
				if(istype(L))
					L.put_in_active_hand(container)

			container = null


	if(href_list["add_to_queue"])
		var/recipe_filename = href_list["add_to_queue"]
		var/datum/computer_file/binary/design/design_file

		for(var/f in design_list())
			var/datum/computer_file/temp_file = f
			if(temp_file.filename == recipe_filename)
				design_file = temp_file
				break

		if(design_file)
			var/amount = 1

			if(href_list["several"])
				amount = input("How many \"[design_file.design.name]\" you want to print ?", "Print several") as null|num
				if(..() || !(design_file in design_list()))
					return

			// Copy the designs that are not copy protected so they can be printed even if the disk is ejected.
			if(!design_file.copy_protected)
				design_file = design_file.clone()

			while(amount && queue.len < queue_max)
				queue.Add(design_file)
				amount--

			if(!current_file)
				next_file()

	if(href_list["remove_from_queue"])
		var/ind = text2num(href_list["remove_from_queue"])
		if(ind >= 1 && ind <= queue.len)
			queue.Cut(ind, ind + 1)

	if(href_list["move_up_queue"])
		var/ind = text2num(href_list["move_up_queue"])
		if(ind >= 2 && ind <= queue.len)
			queue.Swap(ind, ind - 1)

	if(href_list["move_down_queue"])
		var/ind = text2num(href_list["move_down_queue"])
		if(ind >= 1 && ind <= queue.len-1)
			queue.Swap(ind, ind + 1)


	if(href_list["abort_print"])
		abort()

	if(href_list["pause"])
		paused = !paused

	if(href_list["unfold"])
		if(unfolded == href_list["unfold"])
			unfolded = null
		else
			unfolded = href_list["unfold"]

	return 1

/obj/machinery/autolathe/proc/insert_disk(mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(istype(eating, /obj/item/weapon/computer_hardware/hard_drive/portable))
		if(!have_disk)
			return

		if(disk)
			to_chat(user, SPAN_NOTICE("There's already \a [disk] inside [src]."))
			return
		user.unEquip(eating, src)
		disk = eating
		to_chat(user, SPAN_NOTICE("You put \the [eating] into [src]."))
		SSnano.update_uis(src)


/obj/machinery/autolathe/proc/insert_beaker(mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(istype(eating, /obj/item/weapon/reagent_containers/glass))
		if(container)
			user << SPAN_NOTICE("There's already \a [container] inside [src].")
			return
		user.unEquip(eating, src)
		container = eating
		user << SPAN_NOTICE("You put \the [eating] into [src].")
		SSnano.update_uis(src)

/obj/machinery/autolathe/proc/eat(mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(stat)
		return

	if(eating.loc != user && !istype(eating, /obj/item/stack))
		return FALSE

	if(is_robot_module(eating))
		return FALSE

	if(!eating.matter || !eating.matter.len)
		user << SPAN_NOTICE("\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return FALSE

	if(istype(eating, /obj/item/weapon/computer_hardware/hard_drive/portable))
		var/obj/item/weapon/computer_hardware/hard_drive/portable/disk = eating
		if(disk.license)
			to_chat(user, SPAN_NOTICE("\The [src] refuses to accept \the [eating] as it has non-null license."))
			return

	var/filltype = 0       // Used to determine message.
	var/reagents_filltype = 0
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/multiplier = 1

	for(var/obj/O in eating.GetAllContents(includeSelf = TRUE))
		var/list/_matter = O.get_matter()
		if(_matter)
			for(var/material in _matter)
				if(!(material in stored_material))
					stored_material[material] = 0

				if(stored_material[material] >= storage_capacity)
					continue

				var/total_material = _matter[material]

				//Things that aren't material stacks yield less of their matter when recycled
				multiplier = 0.75

				//If it's a stack, we eat multiple sheets.
				if(istype(O,/obj/item/stack))
					if(istype(O,/obj/item/stack/material))
						multiplier = 1
					var/obj/item/stack/material/stack = O
					total_material *= stack.get_amount()

				total_material *= multiplier

				if(stored_material[material] + total_material > storage_capacity)
					total_material = storage_capacity - stored_material[material]
					filltype = 1
				else
					filltype = 2

				stored_material[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]

		if(O.matter_reagents)
			if(container)
				var/datum/reagents/RG = new(0)
				for(var/r in O.matter_reagents)
					RG.maximum_volume += O.matter_reagents[r]
					RG.add_reagent(r ,O.matter_reagents[r])
				reagents_filltype = 1
				RG.trans_to(container, RG.total_volume)

			else
				reagents_filltype = 2

		if(O.reagents && container)
			O.reagents.trans_to(container, O.reagents.total_volume)

	if(!filltype && !reagents_filltype)
		to_chat(user, SPAN_NOTICE("\The [src] is full. Please remove material from [src] in order to insert more."))
		return
	else if(filltype == 1)
		user << SPAN_NOTICE("You fill \the [src] to capacity with \the [eating].")
	else
		user << SPAN_NOTICE("You fill \the [src] with \the [eating].")

	if(reagents_filltype == 1)
		user << SPAN_NOTICE("Some liquid flowed to \the [container].")
	else if(reagents_filltype == 2)
		user << SPAN_NOTICE("Some liquid flowed to the floor from autolathe beaker slot.")

	res_load() // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(eating)
		qdel(eating)



//////////////////////////////////////////
//Helper procs for derive possibility
//////////////////////////////////////////
/obj/machinery/autolathe/proc/design_list()
	if(!disk)
		return list()

	return disk.find_files_by_type(/datum/computer_file/binary/design)

//Procs for handling print animation
/obj/machinery/autolathe/proc/print_pre()
	return

/obj/machinery/autolathe/proc/print_post()
	if(!current_file && !queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\The [src] pings, indicating that queue is complete.")


/obj/machinery/autolathe/proc/res_load()
	flick("autolathe_o", src)


/obj/machinery/autolathe/proc/can_print(datum/computer_file/binary/design/design_file)
	if(progress <= 0)
		if(!design_file || !design_file.design)
			return ERR_NOTFOUND

		if(!design_file.check_license())
			return ERR_NOLICENSE

		var/datum/design/design = design_file.design

		for(var/rmat in design.materials)
			if(!(rmat in stored_material))
				return ERR_NOMATERIAL

			if(stored_material[rmat] < SANITIZE_LATHE_COST(design.materials[rmat]))
				return ERR_NOMATERIAL

		if(design.chemicals.len)
			if(!container || !container.is_drawable())
				return ERR_NOREAGENT

			for(var/rgn in design.chemicals)
				if(!container.reagents.has_reagent(rgn, design.chemicals[rgn]))
					return ERR_NOREAGENT


	if (paused)
		return ERR_PAUSED

	return ERR_OK


/obj/machinery/autolathe/Process()
	if(stat & NOPOWER)
		if(working)
			print_post()
			working = FALSE
		update_icon()
		return

	if(anim < world.time)
		if(current_file)
			var/err = can_print(current_file)

			if(err == ERR_OK)
				error = null

				working = TRUE
				progress += speed

			else if(err in error_messages)
				error = error_messages[err]
			else
				error = "Unknown error."

			if(current_file.design && progress >= current_file.design.time)
				finish_construction()

		else
			error = null
			working = FALSE
			next_file()

	special_process()
	update_icon()
	SSnano.update_uis(src)



/obj/machinery/autolathe/update_icon()
	overlays.Cut()

	icon_state = "autolathe"
	if(panel_open)
		overlays.Add(image(icon, "autolathe_p"))

	if(working && !error) // if error, work animation looks awkward.
		icon_state = "autolathe_n"

/obj/machinery/autolathe/proc/consume_materials(datum/design/design)
	for(var/material in design.materials)
		stored_material[material] = max(0, stored_material[material] - SANITIZE_LATHE_COST(design.materials[material]))

	for(var/reagent in design.chemicals)
		container.reagents.remove_reagent(reagent, design.chemicals[reagent])

	return TRUE


/obj/machinery/autolathe/proc/next_file()
	current_file = null
	progress = 0
	if(queue.len)
		current_file = queue[1]
		print_pre()
		working = TRUE
		queue.Cut(1, 2) // Cut queue[1]
	else
		working = FALSE

/obj/machinery/autolathe/proc/special_process()
	return

//Autolathes can eject decimal quantities of material as a shard
/obj/machinery/autolathe/proc/eject(material, amount)
	if(!(material in stored_material))
		return

	if (!amount)
		return

	var/material/M = get_material_by_name(material)

	if(!M.stack_type)
		return
	amount = min(amount, stored_material[material])

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount


	if (whole_amount)
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))

		//Accounting for the possibility of too much to fit in one stack
		if (whole_amount <= S.max_amount)
			S.amount = whole_amount
		else
			//There's too much, how many stacks do we need
			var/fullstacks = round(whole_amount / S.max_amount)
			//And how many sheets leftover for this stack
			S.amount = whole_amount % S.max_amount

			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/MS = new M.stack_type(get_turf(src))
				MS.amount = MS.max_amount


	//And if there's any remainder, we eject that as a shard
	if (remainder)
		new /obj/item/weapon/material/shard(loc, material, _amount = remainder)

	//The stored material gets the amount (whole+remainder) subtracted
	stored_material[material] -= amount



/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		eject(mat, stored_material[mat])

	eject_disk()
	..()


//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity = round(initial(storage_capacity)*(mb_rating/3))

	speed = (man_rating*5) + initial(speed)
	mat_efficiency = 1.1 - man_rating * 0.1




//Cancels the current construction
/obj/machinery/autolathe/proc/abort()
	if(working)
		print_post()
		working = FALSE
	current_file = null
	paused = TRUE
	working = FALSE

//Finishing current construction
/obj/machinery/autolathe/proc/finish_construction()
	if(current_file.use_license()) //In the case of an an unprotected design, this will always be true
		fabricate_design(current_file.design)
	else
		//If we get here, then the user attempted to print something but the disk had run out of its limited licenses
		//Those dirty cheaters will not get their item. It is aborted before it finishes
		abort()


/obj/machinery/autolathe/proc/fabricate_design(datum/design/design)
	consume_materials(design)
	design.Fabricate(get_turf(src), mat_efficiency, src)

	working = FALSE
	current_file = null
	print_post()
	next_file()

//This proc ejects the autolathe disk, but it also does some DRM fuckery to prevent exploits
/obj/machinery/autolathe/proc/eject_disk()
	if(!disk)
		return

	var/list/design_list = design_list()

	// Go through the queue and remove any recipes we find which came from this disk
	for(var/design in queue)
		if(design in design_list)
			queue -= design

	//Check the current too
	if(current_file in design_list)
		//And abort it if it came from this disk
		abort()


	//Digital Rights have been successfully managed. The corporations win again.
	//Now they will graciously allow you to eject the disk
	disk.forceMove(get_turf(src))

	if(isliving(usr))
		var/mob/living/L = usr
		if(istype(L))
			L.put_in_active_hand(disk)

	disk = null

#undef ERR_OK
#undef ERR_NOTFOUND
#undef ERR_NOMATERIAL
#undef ERR_NOREAGENT
#undef ERR_NOLICENSE
#undef SANITIZE_LATHE_COST







