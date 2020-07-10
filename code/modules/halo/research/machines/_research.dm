
/obj/machinery/research
	icon = 'code/modules/halo/research/machines/research.dmi'
	var/state_base
	var/state_loaded
	var/state_loading
	var/obj/item/loaded_item
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000
	flags = OBJ_ANCHORABLE
	var/circuit_type

	var/datum/nano_module/program/experimental_analyzer/controller
	var/automated = FALSE

	//used by protolathe and citcuit printer
	var/accepting_reagents = TRUE
	var/do_reagents_update = FALSE

/obj/machinery/research/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	if(loaded_item)
		to_chat(user, "\icon[src] <span class='warning'>Not while [src] already has something loaded.</span>")
		return 1

	create_default_components()

	if(default_deconstruction_screwdriver(user, W))
		return 1

	else if(default_deconstruction_crowbar(user, W))
		return 1

	else if(panel_open)
		to_chat(user, "\icon[src] <span class='warning'>Not while \the [src] panel is open.</span>")
		return 1

	return attempt_load_item(W, user)

/obj/machinery/research/proc/can_load_item(var/obj/item/I, var/mob/user as mob)

	if(!user && !automated)
		return FALSE

	if(panel_open)
		to_chat(user, "\icon[src] <span class='warning'>Not while \the [src] panel is open.</span>")
		return FALSE
	return TRUE

/obj/machinery/research/proc/attempt_load_reagent_container(var/obj/item/W, var/mob/user as mob)
	//only attempt to load chemicals if we have valid storage for them
	if(reagents)
		if(accepting_reagents)
			//call afterattack() so that the beaker transfers reagents to us
			do_reagents_update = TRUE
			return 0
		else
			//dont call afterattack()
			//we will now attempt to eject reagents to the beaker
			if(W.reagents.get_free_space())
				if(reagents.total_volume)
					var/target_amount = 10
					if(istype(W,/obj/item/weapon/reagent_containers))
						var/obj/item/weapon/reagent_containers/R = W
						target_amount = R.amount_per_transfer_from_this
					var/amount = reagents.trans_to_holder(W.reagents, target_amount)
					if(amount)
						do_reagents_update = TRUE
					to_chat(user, "<span class='notice'>You remove [amount] units of reagents from [src] to [W].</span>")
				else
					to_chat(user, "<span class='notice'>There are no reagents left in [src].</span>")
			else
				to_chat(user, "<span class='notice'>There is no space left in [W].</span>")

			return TRUE

	return FALSE

/obj/machinery/research/proc/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	. = FALSE

	if(!user && !automated)
		return FALSE

	if(can_load_item(I, user))
		if(loaded_item)
			to_chat(user, "\icon[src] <span class='warning'>[src] already has something loaded.</span>")
		else
			//do we have custom handling for reagent containers?
			if(I.is_open_container())
				if(attempt_load_reagent_container(I, user))
					return TRUE

			if(user)
				to_chat(user, "\icon[src] <span class='info'>You load [I] into [src].</span>")
				user.drop_item()
			I.loc = src
			loaded_item = I
			update_icon()
			if(state_loading)
				flick(state_loading, src)
			return TRUE

/obj/machinery/research/update_icon()
	if(panel_open)
		icon_state = "[state_base]_t"
	else if(loaded_item && state_loaded)
		icon_state = state_loaded
	else
		icon_state = state_base

/obj/machinery/research/proc/toggle_reagent_mode(var/mob/user)
	accepting_reagents = !accepting_reagents
	to_chat(user,"\icon[src] <span class='info'>[src] is now [accepting_reagents ? "accepting" : "ejecting"] \
		chemicals [accepting_reagents ? "from" : "to"] a beaker.</span>")

/obj/machinery/research/dismantle()
	create_default_components()

	if(controller)
		controller.unlink_machine(src)

	. = ..()

/obj/machinery/research/proc/create_default_components()
	if(component_parts)
		return

	if(circuit_type)
		//create the circuitboard
		circuit = new circuit_type(src)

		//create the internal components
		component_parts = list()
		for(var/req_type in circuit.req_components)
			//a stack of mats
			if(ispath(req_type, /obj/item/stack))
				var/obj/item/stack/S = new req_type(src)
				S.amount = 0
				S.add(circuit.req_components[req_type])
				component_parts.Add(S)
				continue

			//stock parts
			for(var/i = 1, i <= circuit.req_components[req_type], i++)
				var/obj/item/A = new req_type(src)
				component_parts.Add(A)

		//for all /research machine subtypes, this should give the default stats
		RefreshParts()
	else
		to_debug_listeners("ERROR: [src.type] has no circuit_type defined!")
