/obj/machinery/fusion_fuel_injector
	name = "fuel injector"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "injector0"
	density = TRUE
	anchored = FALSE
	req_access = list(access_engine)
	idle_power_usage = 10
	active_power_usage = 500
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/fusion_fuel_injector

	var/fuel_usage = 0.001
	var/initial_id_tag
	var/injecting = 0
	var/obj/item/fuel_assembly/cur_assembly
	var/injection_rate = 1

/obj/machinery/fusion_fuel_injector/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)
	. = ..()

/obj/machinery/fusion_fuel_injector/Destroy()
	if(cur_assembly)
		cur_assembly.dropInto(loc)
		cur_assembly = null
	. = ..()

/obj/machinery/fusion_fuel_injector/mapped
	anchored = TRUE

/obj/machinery/fusion_fuel_injector/Process()
	if(injecting)
		if(stat & (BROKEN|NOPOWER))
			StopInjecting()
		else
			Inject()

/obj/machinery/fusion_fuel_injector/attackby(obj/item/W, mob/user)

	if(isMultitool(W))
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		lanm.set_tag(null, initial_id_tag)
		return

	if(istype(W, /obj/item/fuel_assembly))

		if(injecting)
			to_chat(user, "<span class='warning'>Shut \the [src] off before playing with the fuel rod!</span>")
			return
		if(!user.unEquip(W, src))
			return
		if(cur_assembly)
			visible_message("<span class='notice'>\The [user] swaps \the [src]'s [cur_assembly] for \a [W].</span>")
		else
			visible_message("<span class='notice'>\The [user] inserts \a [W] into \the [src].</span>")
		if(cur_assembly)
			cur_assembly.dropInto(loc)
			user.put_in_hands(cur_assembly)
		cur_assembly = W
		return

	if(isWrench(W))
		if(injecting)
			to_chat(user, "<span class='warning'>Shut \the [src] off first!</span>")
			return
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("\The [user] secures \the [src] to the floor.")
		else
			user.visible_message("\The [user] unsecures \the [src] from the floor.")
		return

	return ..()

/obj/machinery/fusion_fuel_injector/physical_attack_hand(mob/user)
	if(injecting)
		to_chat(user, "<span class='warning'>Shut \the [src] off before playing with the fuel rod!</span>")
		return TRUE

	if(cur_assembly)
		cur_assembly.dropInto(loc)
		user.put_in_hands(cur_assembly)
		visible_message("<span class='notice'>\The [user] removes \the [cur_assembly] from \the [src].</span>")
		cur_assembly = null
		return TRUE
	else
		to_chat(user, "<span class='warning'>There is no fuel rod in \the [src].</span>")
		return TRUE

/obj/machinery/fusion_fuel_injector/proc/BeginInjecting()
	if(!injecting && cur_assembly)
		icon_state = "injector1"
		injecting = 1
		update_use_power(POWER_USE_IDLE)

/obj/machinery/fusion_fuel_injector/proc/StopInjecting()
	if(injecting)
		injecting = 0
		icon_state = "injector0"
		update_use_power(POWER_USE_OFF)

/obj/machinery/fusion_fuel_injector/proc/Inject()
	if(!injecting)
		return
	if(cur_assembly)
		var/amount_left = 0
		for(var/reagent in cur_assembly.rod_quantities)
			if(cur_assembly.rod_quantities[reagent] > 0)
				var/amount = cur_assembly.rod_quantities[reagent] * fuel_usage * injection_rate
				if(amount < 1)
					amount = 1
				var/obj/effect/accelerated_particle/A = new/obj/effect/accelerated_particle(get_turf(src), dir)
				A.particle_type = reagent
				A.additional_particles = amount
				A.move(1)
				if(cur_assembly)
					cur_assembly.rod_quantities[reagent] -= amount
					amount_left += cur_assembly.rod_quantities[reagent]
		if(cur_assembly)
			cur_assembly.percent_depleted = amount_left / cur_assembly.initial_amount
		flick("injector-emitting",src)
	else
		StopInjecting()

/obj/machinery/fusion_fuel_injector/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.incapacitated() || usr.restrained()  || anchored)
		return

	src.dir = turn(src.dir, -90)

/obj/machinery/fusion_fuel_injector/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counter-clockwise)"
	set src in view(1)

	if (usr.incapacitated() || usr.restrained()  || anchored)
		return

	src.dir = turn(src.dir, 90)