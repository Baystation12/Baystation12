//Contains the rapid construction device.

/obj/item/rcd
	name = "rapid construction device"
	desc = "Small, portable, and far, far heavier than it looks, this gun-shaped device has a port into which one may insert compressed matter cartridges."
	icon = 'icons/obj/tools/rcd.dmi'
	icon_state = "rcd"
	opacity = 0
	density = FALSE
	anchored = FALSE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	var/datum/effect/spark_spread/spark_system
	var/stored_matter = 0
	var/max_stored_matter = 120

	var/work_id = 0
	var/singleton/hierarchy/rcd_mode/work_mode
	var/static/list/work_modes

	var/canRwall = 0
	var/disabled = 0

	var/crafting = FALSE //Rapid Crossbow Device memes

/obj/item/rcd/Initialize()
	. = ..()

	if(!work_modes)
		var/singleton/hierarchy/h = GET_SINGLETON(/singleton/hierarchy/rcd_mode)
		work_modes = h.children
	work_mode = work_modes[1]

/obj/item/rcd/proc/can_use(mob/user,turf/T)
	return (user.Adjacent(T) && user.get_active_hand() == src && !user.incapacitated())

/obj/item/rcd/examine(mob/user)
	. = ..()
	if(src.type == /obj/item/rcd && loc == user)
		to_chat(user, "The current mode is '[work_mode]'")
		to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")

/obj/item/rcd/New()
	..()
	src.spark_system = new /datum/effect/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	update_icon()	//Initializes the ammo counter

/obj/item/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/rcd/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		if(stored_matter >= max_stored_matter)
			to_chat(user, SPAN_NOTICE("The RCD is at maximum capacity."))
			return
		var/matter_exchange = min(cartridge.remaining,max_stored_matter - stored_matter)
		stored_matter += matter_exchange
		cartridge.remaining -= matter_exchange
		if(cartridge.remaining <= 0)
			qdel(W)
		cartridge.matter = list(MATERIAL_STEEL = 500 * cartridge.remaining,MATERIAL_GLASS = 250 * cartridge.remaining)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("The RCD now holds [stored_matter]/[max_stored_matter] matter-units."))
		update_icon()
		return

	if(isScrewdriver(W))
		crafting = !crafting
		if(!crafting)
			to_chat(user, SPAN_NOTICE("You reassemble the RCD"))
		else
			to_chat(user, SPAN_NOTICE("The RCD can now be modified."))
		src.add_fingerprint(user)
		return

	..()

/obj/item/rcd/attack_self(mob/user)
	//Change the mode
	var/list/options = list(
		"Airlocks" = mutable_appearance('icons/screen/radial.dmi', "airlock"),
		"Floors & Walls" = mutable_appearance('icons/screen/radial.dmi', "wallfloor"),
		"Wall Frames" = mutable_appearance('icons/screen/radial.dmi', "grillewindow"),
		"Machine Frame" = mutable_appearance('icons/screen/radial.dmi', "machine"),
		"Computer Frame" = mutable_appearance('icons/screen/radial.dmi', "computer_dir"),
		"Deconstruction" = mutable_appearance('icons/screen/radial.dmi', "delete"),
	)
	var/choice = show_radial_menu(user, user, options, require_near = TRUE, radius = 42, tooltips = TRUE, check_locs = list(src))

	if (!choice || !user.use_sanity_check(src))
		return


	switch(choice)
		if ("Airlocks")
			work_mode = GET_SINGLETON(/singleton/hierarchy/rcd_mode/airlock)
		if ("Floors & Walls")
			work_mode = GET_SINGLETON(/singleton/hierarchy/rcd_mode/floor_and_walls)
		if ("Wall Frames")
			work_mode = GET_SINGLETON(/singleton/hierarchy/rcd_mode/wall_frame)
		if ("Machine & Computer Frame")
			work_mode = GET_SINGLETON(/singleton/hierarchy/rcd_mode/machine_frame)
		if ("Deconstruction")
			work_mode = GET_SINGLETON(/singleton/hierarchy/rcd_mode/deconstruction)

	work_id++

	to_chat(user, SPAN_NOTICE("Changed mode to '[work_mode]'"))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if(prob(20)) src.spark_system.start()

/obj/item/rcd/use_after(atom/A, mob/living/user, click_parameters)
	if(disabled && !isrobot(user))
		return FALSE
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return FALSE
	work_id++
	work_mode.do_work(src, A, user)
	return TRUE

/obj/item/rcd/proc/useResource(amount, mob/user)
	if(stored_matter < amount)
		return 0
	stored_matter -= amount
	queue_icon_update()	//Updates the ammo counter if ammo is succesfully used
	return 1

/obj/item/rcd/on_update_icon()	//For the fancy "ammo" counter
	ClearOverlays()
	var/ratio = 0
	ratio = stored_matter / max_stored_matter
	ratio = max(round(ratio, 0.10) * 100, 10)
	AddOverlays("rcd-[ratio]")

/obj/item/rcd/proc/lowAmmo(mob/user)	//Kludge to make it animate when out of ammo, but I guess you can make it blow up when it's out of ammo or something
	to_chat(user, SPAN_WARNING("The \'Low Ammo\' light on the device blinks yellow."))
	flick("[icon_state]-empty", src)

/obj/item/rcd_ammo
	name = "compressed matter cartridge"
	desc = "A highly-compressed matter cartridge usable in rapid construction (and deconstruction) devices, such as railguns."
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_STEEL = 15000,MATERIAL_GLASS = 7500)
	var/remaining = 30

/obj/item/rcd_ammo/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_NOTICE("It has [remaining] unit\s of matter left."))

/obj/item/rcd_ammo/large
	name = "high-capacity matter cartridge"
	desc = "Do not ingest."
	icon_state = "rcdlarge"
	matter = list(MATERIAL_STEEL = 45000,MATERIAL_GLASS = 22500)
	remaining = 120
	origin_tech = list(TECH_MATERIAL = 4)

/obj/item/rcd/borg
	canRwall = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_TOOLS

/obj/item/rcd/borg/useResource(amount, mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount*30
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return 1
	return 0

/obj/item/rcd/borg/can_use(mob/user,turf/T)
	return (user.Adjacent(T) && !user.incapacitated())


/obj/item/rcd/mounted
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_TOOLS

/obj/item/rcd/mounted/useResource(amount, mob/user)
	var/cost = amount*20 // About 5 deconstructions of walls on a standard cell (1k), less if it involves airlocks.
	var/obj/item/cell/cell
	if(istype(loc,/obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			cell = module.holder.cell
	else if(loc) cell = loc.get_cell()
	if(cell && cell.charge >= cost)
		cell.use(cost)
		return 1
	return 0

/obj/item/rcd/mounted/can_use(mob/user,turf/T)
	return (user.Adjacent(T) && !user.incapacitated())


/singleton/hierarchy/rcd_mode
	hierarchy_type = /singleton/hierarchy/rcd_mode
	var/cost
	var/delay
	var/handles_type
	var/work_type

/singleton/hierarchy/rcd_mode/proc/do_work(obj/item/rcd/rcd, atom/target, user)
	for(var/child in children)
		var/singleton/hierarchy/rcd_mode/rcdm = child
		if(!rcdm.can_handle_work(rcd, target))
			continue
		if(!rcd.useResource(rcdm.cost, user))
			rcd.lowAmmo(user)
			return FALSE

		playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
		rcdm.work_message(target, user, rcd)

		if(rcdm.delay)
			var/work_id = rcd.work_id
			if(!(do_after(user, rcdm.delay, target, DO_PUBLIC_UNIQUE) && work_id == rcd.work_id && rcd.can_use(user, target) && rcdm.can_handle_work(rcd, target)))
				return FALSE

		rcdm.do_handle_work(target)
		playsound(get_turf(user), 'sound/items/Deconstruct.ogg', 50, 1)
		return TRUE

	return FALSE

/singleton/hierarchy/rcd_mode/proc/can_handle_work(obj/item/rcd/rcd, atom/target)
	var/area/A = get_area(get_turf(target))
	return istype(target, handles_type) && A.can_modify_area()

/singleton/hierarchy/rcd_mode/proc/do_handle_work(atom/target)
	var/result = get_work_result(target)
	if(ispath(result,/turf))
		var/turf/T = target
		T.ChangeTurf(result, keep_air = TRUE)
	else if(result)
		new result(target)
	else
		qdel(target)

/singleton/hierarchy/rcd_mode/proc/get_work_result(atom/target)
	return work_type

/singleton/hierarchy/rcd_mode/proc/work_message(atom/target, mob/user, rcd)
	var/message
	if(work_type)
		var/atom/work = work_type
		message = SPAN_NOTICE("You begin constructing \a [initial(work.name)].")
	else
		message = SPAN_NOTICE("You begin construction.")
	user.visible_message(SPAN_NOTICE("\The [user] uses \a [rcd] to construct something."), message)

/*
	Airlock construction
*/
/singleton/hierarchy/rcd_mode/airlock
	name = "Airlock"

/singleton/hierarchy/rcd_mode/airlock/basic
	cost = 10
	delay = 5 SECONDS
	handles_type = /turf/simulated/floor
	work_type = /obj/machinery/door/airlock

/singleton/hierarchy/rcd_mode/airlock/basic/can_handle_work(rcd, turf/target)
	return ..() && !target.contains_dense_objects() && !(locate(/obj/machinery/door/airlock) in target)

/*
	Floor and Wall construction
*/
/singleton/hierarchy/rcd_mode/floor_and_walls
	name = "Floor & Walls"

/singleton/hierarchy/rcd_mode/floor_and_walls/base_turf
	cost = 1
	delay = 2 SECONDS
	work_type = /turf/simulated/floor/plating

/singleton/hierarchy/rcd_mode/floor_and_walls/base_turf/can_handle_work(rcd, turf/target)
	var/area/A = get_area(target)
	return istype(target) && (isspaceturf(target) || isopenspace(target) || istype(target, get_base_turf_by_area(target))) && A.can_modify_area()

/singleton/hierarchy/rcd_mode/floor_and_walls/floor_turf
	cost = 3
	delay = 2 SECONDS
	handles_type = /turf/simulated/floor
	work_type = /turf/simulated/wall

/*
	Low wall construction
*/

/singleton/hierarchy/rcd_mode/wall_frame
	name = "Low Walls"

/singleton/hierarchy/rcd_mode/wall_frame/steel
	cost = 1
	delay = 2 SECONDS
	handles_type = /turf/simulated/floor
	work_type = /obj/structure/wall_frame

/singleton/hierarchy/rcd_mode/wall_frame/steel/can_handle_work(rcd, turf/target)
	return ..() && !target.contains_dense_objects() && !(locate(/obj/structure/wall_frame) in target)


/*
	Machine and Computer frame construction
*/

/singleton/hierarchy/rcd_mode/machine_frame
	name = "Machine frames"

/singleton/hierarchy/rcd_mode/machine_frame/basic
	cost = 1
	delay = 2 SECONDS
	handles_type = /turf/simulated/floor
	work_type = /obj/machinery/constructable_frame/machine_frame/deconstruct

/singleton/hierarchy/rcd_mode/machine_frame/basic/can_handle_work(rcd, turf/target)
	return ..() && !target.contains_dense_objects() && !(locate(/obj/machinery) in target)

/singleton/hierarchy/rcd_mode/computer_frame
	name = "Computer frames"

/singleton/hierarchy/rcd_mode/computer_frame/basic
	cost = 1
	delay = 2 SECONDS
	handles_type = /turf/simulated/floor
	work_type = /obj/machinery/constructable_frame/computerframe/deconstruct

/singleton/hierarchy/rcd_mode/computer_frame/basic/can_handle_work(rcd, turf/target)
	return ..() && !target.contains_dense_objects() && !(locate(/obj/machinery) in target)

/*
	Deconstruction
*/
/singleton/hierarchy/rcd_mode/deconstruction
	name = "Deconstruction"

/singleton/hierarchy/rcd_mode/deconstruction/work_message(atom/target, mob/user, rcd)
	user.visible_message(SPAN_WARNING("\The [user] is using \a [rcd] to deconstruct \the [target]!"), SPAN_WARNING("You are deconstructing \the [target]!"))

/singleton/hierarchy/rcd_mode/deconstruction/airlock
	cost = 30
	delay = 5 SECONDS
	handles_type = /obj/machinery/door/airlock

/singleton/hierarchy/rcd_mode/deconstruction/airlock_assembly
	cost = 4
	delay = 2 SECONDS
	handles_type = /obj/structure/door_assembly

/singleton/hierarchy/rcd_mode/deconstruction/firedoor_assembly
	cost = 4
	delay = 2 SECONDS
	handles_type = /obj/structure/firedoor_assembly

/singleton/hierarchy/rcd_mode/deconstruction/floor
	cost = 9
	delay = 2 SECONDS
	handles_type = /turf/simulated/floor

/singleton/hierarchy/rcd_mode/deconstruction/floor/get_work_result(target)
	return get_base_turf_by_area(target)

/singleton/hierarchy/rcd_mode/deconstruction/wall
	cost = 9
	delay = 2 SECONDS
	handles_type = /turf/simulated/wall
	work_type = /turf/simulated/floor

/singleton/hierarchy/rcd_mode/deconstruction/wall/can_handle_work(obj/item/rcd/rcd, turf/simulated/wall/target)
	return ..() && (rcd.canRwall || !target.reinf_material)

/singleton/hierarchy/rcd_mode/deconstruction/wall_frame
	cost = 4
	delay = 2 SECONDS
	handles_type = /obj/structure/wall_frame

/singleton/hierarchy/rcd_mode/deconstruction/wall_frame/can_handle_work(obj/item/rcd/rcd, obj/structure/wall_frame/target)
	. = ..()
	if (.)
		var/turf/T = get_turf(target)
		var/area/A = get_area(T)
		if ((locate(/obj/structure/window) in T) || (locate(/obj/structure/grille) in T) || !A.can_modify_area())
			return FALSE

/singleton/hierarchy/rcd_mode/deconstruction/window
	cost = 4
	delay = 2 SECONDS
	handles_type = /obj/structure/window

/singleton/hierarchy/rcd_mode/deconstruction/window/can_handle_work(obj/item/rcd/rcd, obj/structure/window/target)
	return ..() && (rcd.canRwall || !target.reinf_material)

/singleton/hierarchy/rcd_mode/deconstruction/grille
	cost = 2
	delay = 1 SECOND
	handles_type = /obj/structure/grille
