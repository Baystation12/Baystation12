//Simple borg hand.
//Limited use.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	icon = 'icons/obj/gripper.dmi'
	icon_state = "gripper"

	item_flags = ITEM_FLAG_NO_BLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/firealarm_electronics,
		/obj/item/airalarm_electronics,
		/obj/item/airlock_electronics,
		/obj/item/tracker_electronics,
		/obj/item/module/power_control,
		/obj/item/stock_parts,
		/obj/item/frame,
		/obj/item/camera_assembly,
		/obj/item/tank,
		/obj/item/stock_parts/circuitboard,
		/obj/item/stock_parts/smes_coil,
		/obj/item/stock_parts/computer,
		/obj/item/fuel_assembly,
		/obj/item/stack/material/deuterium,
		/obj/item/stack/material/tritium,
		/obj/item/stack/tile
		)

	var/obj/item/wrapped = null // Item currently being held.
	var/wrapped_offset_y = -8
	var/wrapped_offset_x = 0

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."

	icon_state = "gripper-mining"

	can_hold = list(
	/obj/item/cell,
	/obj/item/stock_parts,
	/obj/item/stock_parts/circuitboard/miningdrill
	)

/obj/item/gripper/clerical
	name = "clerical gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/material/clipboard,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/card/id,
		/obj/item/book,
		/obj/item/newspaper,
		/obj/item/smallDelivery
		)

/obj/item/gripper/chemistry
	name = "chemistry gripper"
	desc = "A simple grasping tool for chemical work."

	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/ivbag,
		/obj/item/reagent_containers/chem_disp_cartridge,
		/obj/item/stack/material/phoron,
		/obj/item/storage/pill_bottle,
		)

/obj/item/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/cell,
		/obj/item/stock_parts,
		/obj/item/device/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/device/flash,
		/obj/item/organ/internal/brain,
		/obj/item/organ/internal/posibrain,
		/obj/item/stack/cable_coil,
		/obj/item/stock_parts/circuitboard,
		/obj/item/slime_extract,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/stock_parts/computer,
		/obj/item/device/transfer_valve,
		/obj/item/device/assembly/signaler,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/infra,
		/obj/item/tank
		)

/obj/item/gripper/cultivator
	name = "cultivator gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the xenobiology division, such as handling plant samples and disks."
	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/seeds,
		/obj/item/slime_extract,
		/obj/item/disk/botany
	)

/obj/item/gripper/service //Used to handle food, drinks, seeds, and service fabricator items.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."
	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food,
		/obj/item/seeds,
		/obj/item/glass_extra,
		/obj/item/clothing/mask/smokable,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/storage/pill_bottle/dice,
		/obj/item/dice
	)

/obj/item/gripper/organ //Used to handle organs.
	name = "organ gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool for holding and manipulating organic and mechanical organs, both internal and external."

	can_hold = list(
		/obj/item/organ,
		/obj/item/robot_parts,
		/obj/item/reagent_containers/ivbag
	)

/obj/item/gripper/auto_cpr // Special gripper that looks like an auto-compressor, for that item only
	name = "auto-compressor unit"
	desc = "A manipulator unit for carrying and operating an auto-compressor, a device that gives regular compression to the victim's ribcage, used in case of urgent heart issues."
	icon = 'icons/obj/auto_cpr.dmi'
	icon_state = "pumper"
	can_hold = list(/obj/item/auto_cpr)

/obj/item/gripper/ivbag // Used to handle IV bags. Deliberately more limited than the organ gripper so the Emergency Response module can't do surgery.
	name = "\improper IV bag gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool for holding and manipulating IV bags."
	can_hold = list(/obj/item/reagent_containers/ivbag)

/obj/item/gripper/forensics// Used to handle forensics equipment.
	name = "forensics gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool for holding forensics evidence and paper."

	can_hold = list(
		/obj/item/sample,
		/obj/item/evidencebag,
		/obj/item/forensics,
		/obj/item/photo,
		/obj/item/paper,
		/obj/item/paper_bundle
	)

/obj/item/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/gripper/no_use/attack_self(mob/user as mob)
	return

/obj/item/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material
		)

/obj/item/gripper/examine(mob/user)
	. = ..()
	if(wrapped)
		to_chat(user, "It is holding \a [wrapped].")

/obj/item/gripper/attack_self(mob/user as mob)
	if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/gripper/verb/drop_gripped_item()

	set name = "Drop Gripped Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Silicon Commands"
	if(!wrapped)
		// Ensure fumbled items are accessible.
		for(var/obj/item/thing in src.contents)
			thing.dropInto(loc)
		return

	if(wrapped.loc != src)
		wrapped = null
		update_icon()
		return

	to_chat(src.loc, SPAN_WARNING("You drop \the [wrapped]."))
	wrapped.dropInto(loc)
	wrapped = null
	update_icon()

/obj/item/gripper/resolve_attackby(atom/target, mob/living/user, params)

	// Ensure fumbled items are accessible.
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			update_icon()
			break

	if(wrapped) //Already have an item.
		//Temporary put wrapped into user so target's attackby() checks pass.
		wrapped.forceMove(user)

		if (istype(target, /obj/structure/table))
			var/obj/structure/table/table = target
			wrapped.dropInto(get_turf(target))
			table.auto_align(wrapped, params)
			wrapped = null
			update_icon()
			return

		//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		var/force_holder = wrapped.force
		wrapped.force = 0.0

		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = wrapped.resolve_attackby(target,user,params)

		//If resolve_attackby forces waiting before taking wrapped, we need to let it finish before doing the rest.
		addtimer(new Callback(src, .proc/finish_using, target, user, params, force_holder, resolved), 0)

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.
		var/obj/item/I = target

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally. (prevent grabbing if the target's loc is in a robot frame)
		if(grab && !istype(target.loc,/obj/item/robot_module))
			if(I == user.s_active)
				var/obj/item/storage/storage = I
				storage.close(user) //Closes the ui.
			if(istype(I.loc, /obj/item/storage))
				var/obj/item/storage/storage = I.loc
				if(!storage.remove_from_storage(I, src))
					return
			else
				I.forceMove(src)
			to_chat(user, SPAN_NOTICE("You collect \the [I]."))
			wrapped = I
			update_icon()
			return
		else
			to_chat(user, SPAN_DANGER("Your gripper cannot hold \the [target]."))

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.components_are_accessible(/obj/item/stock_parts/power/battery))
			var/obj/item/stock_parts/power/battery/bat = A.get_component_of_type(/obj/item/stock_parts/power/battery)
			var/obj/item/cell/cell = bat.extract_cell(user)
			if(cell)
				wrapped = cell
				cell.forceMove(src)
				update_icon()

	else if(istype(target,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell)
				wrapped = A.cell
				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.update_icon()
				A.cell.forceMove(src)
				A.cell = null
				user.visible_message(SPAN_DANGER("[user] removes the power cell from [A]!"), "You remove the power cell.")
				A.power_down()
				update_icon()

/obj/item/gripper/proc/finish_using(atom/target, mob/living/user, params, force_holder, resolved)

	if(QDELETED(wrapped))
		if (wrapped)
			wrapped.forceMove(null)
		wrapped = null
		update_icon()
		return

	if(!resolved && wrapped && target)
		wrapped.afterattack(target, user, 1, params)

	if(wrapped)
		wrapped.force = force_holder

	//If wrapped was neither deleted nor put into target, put it back into the gripper.
	if(wrapped && user && !QDELETED(wrapped) && wrapped.loc == user)
		wrapped.forceMove(src)
	else
		wrapped = null
		update_icon()


/obj/item/gripper/on_update_icon()
	. = ..()
	underlays.Cut()
	SetName(initial(name))
	if (wrapped)
		underlays += image(wrapped.icon, wrapped.icon_state, pixel_x = wrapped_offset_x, pixel_y = wrapped_offset_y)
		SetName("[name] ([wrapped.name])")


//TODO: Matter decompiler.
/obj/item/matter_decompiler

	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/gripper.dmi'
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null

/obj/item/matter_decompiler/use_after(atom/target, mob/living/user, click_parameters)
	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return FALSE

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_animal/passive/lizard) || istype(M,/mob/living/simple_animal/passive/mouse))
			loc.visible_message(
				SPAN_DANGER("\The [loc] sucks \the [M] into its decompiler. There's a horrible crunching noise."),
				SPAN_DANGER("It's a bit of a struggle, but you manage to suck \the [M] into your decompiler. It makes a series of visceral crunching noises.")
			)
			new/obj/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return TRUE

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)
			var/mob/living/silicon/robot/D = loc

			if(!istype(D))
				return TRUE

			to_chat(D, SPAN_DANGER("You begin decompiling \the [M]."))

			if(!do_after(D, 5 SECONDS, M, DO_PUBLIC_UNIQUE))
				return TRUE

			if(!M || !D) return TRUE

			to_chat(D, SPAN_DANGER("You carefully and thoroughly decompile \the [M], storing as much of its resources as you can within yourself."))
			qdel(M)
			new/obj/decal/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return TRUE
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/trash/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if(istype(W,/obj/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= LIGHT_BROKEN)
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/item/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/decal/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			var/amt = R.get_amount()
			if(amt > 3)
				to_chat(user, SPAN_NOTICE("The amount of rods is too high to fit into your decompiler."))
				continue
			if(metal)
				metal.add_charge(500*amt)
		else if(istype(W,/obj/item/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, SPAN_NOTICE("You deploy your decompiler and clear out the contents of \the [T]."))
	else
		to_chat(user, SPAN_DANGER("Nothing on \the [T] is useful to you."))
	return TRUE

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()

	if(!module)
		module = new /obj/item/robot_module/drone(src)

	var/window = {"
	<b>Activated Modules</b><br>
	Module 1: [module_state_1 ? "<a href=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<a>" : "No Module"]<br>
	Module 2: [module_state_2 ? "<a href=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<a>" : "No Module"]<br>
	Module 3: [module_state_3 ? "<a href=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<a>" : "No Module"]<br>
	<br><b>Available Modules</b><br>"}
	for (var/O in module.equipment)
		if (!O)
			window += "<br><b>Depleted Resource</b>"
		else
			window += "<br>[O]: [IsHolding(O) ? "<b>Activated</b>" : "<a href='?src=\ref[src];act=\ref[O]'>Activate</a>"]"
	window = strip_improper("<head><title>Drone modules</title></head><tt>[JOINTEXT(window)]</tt>")
	show_browser(src, window, "window=robotmod")
