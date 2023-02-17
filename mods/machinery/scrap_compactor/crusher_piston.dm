#define PISTON_MOVE_DAMAGE 30
#define PISTON_MOVE_DIVISOR 8

/obj/machinery/crusher_base
	name = "trash compactor"
	desc = "A colossal piston used for crushing garbage."
	icon = 'crusher_base.dmi'
	icon_state = "standalone"
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	//Just 300 Watts here. Power is drawn by the piston when it moves
	use_power = 1
	idle_power_usage = 300

	var/obj/machinery/crusher_piston/piston //Piston
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc
	)

	var/action = "idle" //Action the piston should perform
	// idle -> Do nothing
	// extend -> Extend the piston
	// retract -> Retract the piston

	var/status = "idle"//The status the piston is in
	// idle -> The piston is idle, doing nothing
	// pre_start -> The piston is pre-starting
	// stage1 -> The piston is at stage 1
	// stage2 -> The piston is at stage 2
	// stage3 -> The piston is at stage 3

	var/blocked = 0 //If the piston has been blocked by something - Piston is stuck and preassure valve needs to be opened
	var/valve_open = 0 //If the de-preassure valve is open - Pison cant be extended
	var/num_progress = 0 //Numerical Progress value

	var/asmtype = "standalone" //If the base is a stand alone base or part of a combined crusher
	// standalone -> Standalone base
	// leftcap -> Left piece of a combined crusher
	// middle -> Middle piece of a combined crusher
	// rightcap -> Right piece of a combined crusher

	var/action_start_time = null //The time when the action has been started
	var/time_stage_pre = 150 //The time it takes for the stage to complete
	var/time_stage_1 = 100 //The time it takes for the stage to complete
	var/time_stage_2 = 100 //The time it takes for the stage to complete
	var/time_stage_3 = 100 //The time it takes for the stage to complete
	var/time_stage_full = 100 //The time to wait when the piston is full extended

	var/list/items_to_move = list() //The list of tiems that should be moved by the piston
	var/list/items_to_crush = list() //The list of items that should be destroyed by the piston

	var/initial = 1 // initial run of the piston process

	var/process_lock = 0 //If the call to process is locked because it is still running

/obj/machinery/crusher_base/Initialize()
	. = ..()

/*
	//Create parts for crusher.
	component_parts = list()
	component_parts += new /obj/item/stock_parts/circuitboard/crusher(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker(src)
	RefreshParts()
*/
	action_start_time = world.time

	//Spawn the stage 1 pistons south of it with a density of 0
	piston = new(get_step(src, SOUTH))
	piston.crs_base = src

	update_icon()
	// Change the icons of the neighboring bases
	change_neighbor_base_icons()

/obj/machinery/crusher_base/Destroy()
	var/oldloc = loc
	var/obj/machinery/crusher_base/left = locate(/obj/machinery/crusher_base, get_step(src, WEST))
	var/obj/machinery/crusher_base/right = locate(/obj/machinery/crusher_base, get_step(src, EAST))

	loc=null
	if(left)
		left.update_icon()
	if(right)
		right.update_icon()
	loc=oldloc

	QDEL_NULL(piston)
	return ..()

/obj/machinery/crusher_base/attackby(obj/item/O as obj, mob/user as mob)
	if(status != "idle" && prob(40) && ishuman(user))
		var/mob/living/carbon/human/M = user
		var/prot = 0

		if(M.getSpeciesOrSynthTemp(HEAT_LEVEL_1) > 400)
			prot = 1
		else if(M.gloves)
			var/obj/item/clothing/gloves/G = M.gloves
			if(G.max_heat_protection_temperature)
				if(G.max_heat_protection_temperature > 400)
					prot = 1
		else if(MUTATION_COLD_RESISTANCE in user.mutations)
			prot = 1

		if(prot == 0)
			M.apply_damage(45, INJURY_TYPE_BRUISE, user.get_active_hand())
			M.apply_damage(EFFECT_PAIN)
			M.visible_message(SPAN_DANGER("[user]'s hand catches in the [src]!"), SPAN_DANGER("Your hand gets caught in the [src]!"))
			if(M.can_feel_pain())
				M.emote("scream")
		return

	//Stuff you can do if the maint hatch is open
	if(panel_open)
		if(isWrench(O))
			to_chat(user, SPAN_NOTICE("You start [valve_open ? "closing" : "opening"] the pressure relief valve of [src]."))
			if(do_after(user,50))
				valve_open = !valve_open
				to_chat(user, SPAN_NOTICE("You [valve_open ? "open" : "close"] the pressure relief valve of [src]."))
				if(valve_open)
					blocked = 0
					action = "retract"
			return
	..()

/obj/machinery/crusher_base/proc/change_neighbor_base_icons()
	var/obj/machinery/crusher_base/left = locate(/obj/machinery/crusher_base, get_step(src, WEST))
	var/obj/machinery/crusher_base/right = locate(/obj/machinery/crusher_base, get_step(src, EAST))
	if(left)
		left.update_icon()

	if(right)
		right.update_icon()

/obj/machinery/crusher_base/on_update_icon()
	overlays.Cut()
	var/obj/machinery/crusher_base/left = locate(/obj/machinery/crusher_base, get_step(src, WEST))
	var/obj/machinery/crusher_base/right = locate(/obj/machinery/crusher_base, get_step(src, EAST))

	if(QDELETED(left))
		left = null

	if(QDELETED(right))
		right = null

	if(left && right)
		asmtype = "middle"
		icon_state = asmtype
	else if(left)
		asmtype = "rightcap"
		icon_state = asmtype
	else if(right)
		asmtype = "leftcap"
		icon_state = asmtype
	else
		asmtype = "standalone"
		icon_state = asmtype

	if(powered(EQUIP))
		if(blocked == 1)
			overlays += "[asmtype]-overlay-red"
		else if(action != "idle")
			overlays += "[asmtype]-overlay-orange"
		else
			overlays += "[asmtype]-overlay-green"
	if(panel_open)
		overlays += image(icon, "[asmtype]-hatch")

	var/turf/above = GetAbove(get_turf(src))
	if(above && isopenspace(above))
		above.update_icon()

/obj/machinery/crusher_base/power_change()
	..()
	update_icon()

/obj/machinery/crusher_base/Process()
	set waitfor = FALSE
	if(!piston) //We dont process if theres no piston
		return
	if(process_lock)
		log_debug("crusher_piston process() has been called while it was still locked. Aborting")
		return
	process_lock = 1
	var/timediff = world.time - action_start_time

	//Check what action should be performed
	if(action == "idle")
		action_start_time = world.time
		initial = 1
	else if(action == "extend" && blocked == 0 && powered(EQUIP))
		//If we are idle, flash the warning lights and then put us into pre_start once we are done
		if(status == "idle")
			if(initial)
				playsound(loc, 'sound/machines/airalarm.ogg', 50, 1)	//Plays a beep
				initial = 0
			//TODO: Flash the lights
			if(timediff > time_stage_pre)
				initial = 1
				status = "pre_start" // Bring us into pre start
				action_start_time = world.time


		//We are now ready to expand the first piston
		else if(status == "pre_start")
			if(valve_check())
				//Call extend on all the stage 1 pistons
				if(initial)
					initial = 0
					num_progress = 33
					if(!piston.extend_0_1())
						num_progress = 0
						status = "idle"
						action = "idle"
						initial = 1
						visible_message("The hydraulic pump in [src] spins faster and shuts down a few moments later.","You hear a pump spinning faster and then shutting down.")
				if(timediff > time_stage_1)
					status = "stage1"
					action_start_time = world.time
					initial = 1

		//Extend the second piston
		else if(status == "stage1")
			if(valve_check())
				//Call extend on all the stage 2 pistons
				if(initial)
					initial = 0
					num_progress = 66
					if(!piston.extend_1_2())
						num_progress = 33
						action = "idle"
						blocked = 1
						visible_message("The hydraulic pump in [src] spins faster and shuts down a few moments later.","You hear a pump spinning faster and then shutting down.")
				if(timediff > time_stage_2)
					status = "stage2"
					action_start_time = world.time
					initial = 1

		//Extend the thrid piston
		else if(status == "stage2")
			if(valve_check())
				//Call extend on all the stage 2 pistons
				if(initial)
					initial = 0
					num_progress = 100
					if(!piston.extend_2_3())
						num_progress = 66
						action = "idle"
						blocked = 1
						visible_message("The hydraulic pump in [src] spins faster and shuts down a few moments later.","You hear a pump spinning faster and then shutting down.")
				if(timediff > time_stage_3)
					status = "stage3"
					action_start_time = world.time
					initial = 1

		//Wait a moment, then reverse the direction
		else if(status == "stage3")
			if(initial)
				initial = 0
			if(timediff > time_stage_full)
				action = "retract"
				action_start_time = world.time
				initial = 1

		//Update the icon
		update_icon()

	//Retract the pistons
	else if(action == "retract" && blocked == 0 && powered(EQUIP)) //Only retract if unblocked
		update_icon()
		num_progress = 0

		//Retract the 3rd stage pistons
		if(status == "stage3")
			if(initial)
				initial = 0
				piston.retract_3_0()
			if(timediff > time_stage_3) //Once the time is up, reset the icon state
				piston.icon_state = initial(piston.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
				update_icon()
		else if(status == "stage2")
			if(initial)
				initial = 0
				piston.retract_2_0()
			if(timediff > time_stage_2) //Once the time is up, reset the icon state
				piston.icon_state = initial(piston.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
				update_icon()
		else if(status == "stage1")
			if(initial)
				initial = 0
				piston.retract_1_0()
			if(timediff > time_stage_1) //Once the time is up, reset the icon state
				piston.icon_state = initial(piston.icon_state)
				status = "idle"
				action = "idle"
				action_start_time = world.time
				initial = 1
				update_icon()
		else //This shouldnt really happen, but its there just in case
			piston.icon_state = initial(piston.icon_state)
			piston.reset_blockers()
			status = "idle"
			action = "idle"
			action_start_time = world.time
			initial = 1
			update_icon()

	//Move all the items in the move list
	for(var/atom/movable/AM in items_to_move)
		if(!AM.simulated)
			items_to_move -= AM
			continue
		if(istype(AM,/obj/machinery/crusher_piston))
			items_to_move -= AM
			continue
		items_to_move -= AM
		//If a item could not be moved. Add it to the crush list
		if(!AM.piston_move())
			items_to_crush += AM
		CHECK_TICK

	//Destroy all the items in the crush list
	for(var/atom/movable/AM in items_to_crush)
		items_to_crush -= AM
		AM.crush_act()
		CHECK_TICK

	process_lock = 0


/obj/machinery/crusher_base/proc/crush_start()
	action = "extend"


/obj/machinery/crusher_base/proc/crush_abort()
	//Abort the crush
	//Retract all the pistons, ...
	action = "retract"
	initial = 1

/obj/machinery/crusher_base/proc/get_num_progress()
	return num_progress

/obj/machinery/crusher_base/proc/get_action()
	return action

/obj/machinery/crusher_base/proc/get_status()
	return status

/obj/machinery/crusher_base/proc/is_blocked()
	return blocked

/obj/machinery/crusher_base/proc/valve_check() //Check if the depreasurization valve is open
	if(valve_open == 1)
		visible_message("The hydraulic pump in [src] briefly spins up and then shuts down.","You hear a pump spinning up briefly and then shutting down.")
		action = "idle"
		return 0
	return 1

//Piston Stage 1
/obj/machinery/crusher_piston
	name = "trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	icon = 'crusherpiston.dmi' //Placeholder TODO: Get a proper icon
	icon_state = "piston_0"
	density = FALSE
	anchored = TRUE
	pixel_y = -64
	var/stage = 0 //The stage of the piston
	var/obj/machinery/crusher_base/crs_base //Crusher Base the piston is linked to
	var/obj/effect/piston_blocker/pb1
	var/obj/effect/piston_blocker/pb2
	var/obj/effect/piston_blocker/pb3

	var/static/list/immovable_items

/obj/machinery/crusher_piston/Initialize()
	. = ..()

	update_turf_above()
	// Setup the immovable items typecache.
	// 	(We only want to do this once as this is a huge list.)
	if(!LAZYLEN(immovable_items))
		immovable_items = typecacheof(list(
			/obj/machinery,
			/obj/structure,
			/obj/item/modular_computer/telescreen,
		)) - /obj/machinery/crusher_piston

/obj/machinery/crusher_piston/Destroy()
	reset_blockers()
	if(!QDELETED(crs_base))
		QDEL_NULL(crs_base)
	update_turf_above()
	return ..()

/obj/machinery/crusher_piston/proc/reset_blockers()
	QDEL_NULL(pb1)
	QDEL_NULL(pb2)
	QDEL_NULL(pb3)
	update_turf_above()

/obj/machinery/crusher_piston/proc/extend_0_1()
	use_power_oneoff(5 KILOWATTS)
	var/turf/T = get_turf(src)
	if(!can_extend_into(T))
		return 0
	icon_state="piston_0_1"
	stage = 1
	update_turf_above()
	pb1 = new(loc)
	for(var/atom/movable/AM in get_turf(loc))
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/extend_1_2()
	use_power_oneoff(5 KILOWATTS)
	var/turf/T = get_turf(pb1)
	var/turf/extension_turf = get_step(T,SOUTH)
	if(!can_extend_into(extension_turf))
		return 0
	icon_state="piston_1_2"
	stage = 2
	update_turf_above()
	pb2 = new(get_step(T,SOUTH))
	for(var/atom/movable/AM in extension_turf)
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/extend_2_3()
	use_power_oneoff(5 KILOWATTS)
	var/turf/T = get_turf(pb2)
	var/turf/extension_turf = get_step(T,SOUTH)
	if(!can_extend_into(extension_turf))
		return 0
	icon_state="piston_2_3"
	stage = 3
	update_turf_above()
	pb3 = new(get_step(T,SOUTH))
	for(var/atom/movable/AM in extension_turf)
		crs_base.items_to_move += AM
	return 1

/obj/machinery/crusher_piston/proc/retract_3_0()
	icon_state="piston_3_0"
	stage = 0
	update_turf_above()
	reset_blockers()
/obj/machinery/crusher_piston/proc/retract_2_0()
	icon_state="piston_2_0"
	stage = 0
	update_turf_above()
	reset_blockers()
/obj/machinery/crusher_piston/proc/retract_1_0()
	icon_state="piston_1_0"
	stage = 0
	update_turf_above()
	reset_blockers()

// Proc from old Sierra repo. This is cringe
/proc/is_type_in_typecache(atom/A, list/L)
	if(!L || !length(L)|| !A)

		return 0
	return L[A.type]

/obj/machinery/crusher_piston/proc/can_extend_into(turf/extension_turf)
	//Check if atom is of a specific Type
	if(istype(extension_turf,/turf/simulated/wall))
		return 0
	for(var/atom/A in extension_turf)
		if(is_type_in_typecache(A, immovable_items))
			return 0
	return 1

/obj/machinery/crusher_piston/proc/update_turf_above()
	var/turf/above = GetAbove(get_turf(src))
	if(above && isopenspace(above))
		above.update_icon()

/obj/effect/piston_blocker
	name = "trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	mouse_opacity = 0

//
// The piston_move proc for various objects
//
// Return 1 if it could successfully be moved
// Return 0 if it could not be moved
/atom/movable/proc/piston_move()
	var/turf/T = get_turf(src)

	var/list/valid_turfs = list()
	for(var/dir_to_test in GLOB.cardinal)
		var/turf/new_turf = get_step(T, dir_to_test)
		if(!new_turf.contains_dense_objects())
			valid_turfs += new_turf

	while(length(valid_turfs))
		T = pick(valid_turfs)
		valid_turfs -= T

		if(src.forceMove(T))
			return 1
	// We failed to move our target
	return 0

/mob/living/piston_move()
	for(var/i = 1, i <= PISTON_MOVE_DIVISOR, i++)
		adjustBruteLoss(round(PISTON_MOVE_DAMAGE / PISTON_MOVE_DIVISOR))
	AdjustStunned(5)
	AdjustWeakened(5)
	return ..()

/mob/living/carbon/piston_move()
	if(can_feel_pain())
		emote("scream")
	return ..()

//Dont call the parent and return 1 to prevent effects from getting moved
/obj/effect/piston_move()
	return 1

//
// The crush act proc
//
/atom/movable/proc/crush_act()
	ex_act(1)
	if(!QDELETED(src))
		qdel(src)//Just as a failsafe

#undef PISTON_MOVE_DAMAGE
#undef PISTON_MOVE_DIVISOR
