var/list/fuel_injectors = list()

/obj/machinery/fusion_fuel_injector
	name = "fuel injector"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "injector0"
	density = 1
	anchored = 0
	req_access = list(access_engine)
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 500

	var/fuel_usage = 0.0001
	var/id_tag
	var/injecting = 0
	var/obj/item/weapon/fuel_assembly/cur_assembly

/obj/machinery/fusion_fuel_injector/New()
	..()
	fuel_injectors += src
	tag = null

/obj/machinery/fusion_fuel_injector/Destroy()
	if(cur_assembly)
		cur_assembly.forceMove(get_turf(src))
		cur_assembly = null
	fuel_injectors -= src
	return ..()

/obj/machinery/fusion_fuel_injector/mapped
	anchored = 1

/obj/machinery/fusion_fuel_injector/process()
	if(injecting)
		if(stat & (BROKEN|NOPOWER))
			StopInjecting()
		else
			Inject()

/obj/machinery/fusion_fuel_injector/attackby(obj/item/W, mob/user)

	if(ismultitool(W))
		var/new_ident = input("Enter a new ident tag.", "Fuel Injector", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return

	if(istype(W, /obj/item/weapon/fuel_assembly))

		if(injecting)
			to_chat(user, "<span class='warning'>Shut \the [src] off before playing with the fuel rod!</span>")
			return

		if(cur_assembly)
			cur_assembly.forceMove(get_turf(src))
			visible_message("<span class='notice'>\The [user] swaps \the [src]'s [cur_assembly] for \a [W].</span>")
		else
			visible_message("<span class='notice'>\The [user] inserts \a [W] into \the [src].</span>")

		user.drop_from_inventory(W)
		W.forceMove(src)
		if(cur_assembly)
			cur_assembly.forceMove(get_turf(src))
			user.put_in_hands(cur_assembly)
		cur_assembly = W
		return

	if(iswrench(W))
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

/obj/machinery/fusion_fuel_injector/attack_hand(mob/user)

	if(injecting)
		to_chat(user, "<span class='warning'>Shut \the [src] off before playing with the fuel rod!</span>")
		return

	if(cur_assembly)
		cur_assembly.forceMove(get_turf(src))
		user.put_in_hands(cur_assembly)
		visible_message("<span class='notice'>\The [user] removes \the [cur_assembly] from \the [src].</span>")
		cur_assembly = null
		return
	else
		to_chat(user, "<span class='warning'>There is no fuel rod in \the [src].</span>")
		return

/obj/machinery/fusion_fuel_injector/proc/BeginInjecting()
	if(!injecting && cur_assembly)
		icon_state = "injector1"
		injecting = 1
		use_power = 1

/obj/machinery/fusion_fuel_injector/proc/StopInjecting()
	if(injecting)
		injecting = 0
		icon_state = "injector0"
		use_power = 0

/obj/machinery/fusion_fuel_injector/proc/Inject()
	if(!injecting)
		return
	if(cur_assembly)
		var/amount_left = 0
		for(var/reagent in cur_assembly.rod_quantities)
			if(cur_assembly.rod_quantities[reagent] > 0)
				var/amount = cur_assembly.rod_quantities[reagent] * fuel_usage
				var/numparticles = round(amount * 1000)
				if(numparticles < 1)
					numparticles = 1
				var/obj/effect/accelerated_particle/A = new/obj/effect/accelerated_particle(get_turf(src), dir)
				A.particle_type = reagent
				A.additional_particles = numparticles - 1
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