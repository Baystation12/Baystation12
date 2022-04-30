
/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE

	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/datum/reagent/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = "10;25;50;100;500"

/obj/structure/reagent_dispensers/attackby(obj/item/W as obj, mob/user as mob)
	return

/obj/structure/reagent_dispensers/New()
	create_reagents(initial_capacity)

	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this

	for(var/reagent_type in initial_reagent_types)
		var/reagent_ratio = initial_reagent_types[reagent_type]
		reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

	..()

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	to_chat(user, "<span class='notice'>It contains:</span>")
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			to_chat(user, "<span class='notice'>[R.volume] units of [R.name]</span>")
	else
		to_chat(user, "<span class='notice'>Nothing.</span>")

/obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, "<span class='notice'>You're in no condition to do that!'</span>")
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_number_list_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, "<span class='notice'>You're in no condition to do that!'</span>")
		return
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
		else
	return

/obj/structure/reagent_dispensers/AltClick(var/mob/user)
	if(possible_transfer_amounts)
		set_amount_per_transfer_from_this()
	else
		return ..()


//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A tank containing water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/fill_level = FLUID_SHALLOW // Can be adminbussed for silly room-filling tanks.
	possible_transfer_amounts = "10;25;50;100"
	initial_capacity = 50000
	initial_reagent_types = list(/datum/reagent/water = 1)
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/watertank/proc/drain_water()
	if(reagents.total_volume <= 0)
		return

	// To prevent it from draining while in a container.
	if(!isturf(src.loc))
		return

	// Check for depth first, and pass if the water's too high. A four foot high water tank
	// cannot jettison water above the level of a grown adult's head!
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	// For now, this cheats and only checks/leaks water, pending additions to the fluid system.
	var/W = reagents.remove_reagent(/datum/reagent/water, amount_per_transfer_from_this * 5)
	if(W > 0)
		// Artificially increased flow - a 1:1 rate doesn't result in very much water at all.
		T.add_fluid(W * 100, /datum/reagent/water)

/obj/structure/reagent_dispensers/watertank/examine(mob/user)
	. = ..()

	if(modded)
		to_chat(user, "<span class='warning'>Someone has wrenched open its tap - it's spilling everywhere!</span>")

/obj/structure/reagent_dispensers/watertank/attackby(obj/item/W, mob/user)

	src.add_fingerprint(user)

	if((istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm)) && user.unEquip(W))
		to_chat(user, "You add \the [W] arm to \the [src].")
		qdel(W)
		new /obj/item/farmbot_arm_assembly(loc, src)
		return

	if(isWrench(W))
		modded = !modded
		user.visible_message("<span class='notice'>\The [user] wrenches \the [src]'s tap [modded ? "open" : "shut"].</span>", \
			"<span class='notice'>You wrench [src]'s drain [modded ? "open" : "shut"].</span>")

		if (modded)
			log_and_message_admins("opened a water tank at [get_area(loc)], leaking water.")
			// Allows the water tank to continuously expel water, differing it from the fuel tank.
			START_PROCESSING(SSprocessing, src)
		else
			STOP_PROCESSING(SSprocessing, src)

	return ..()

/obj/structure/reagent_dispensers/watertank/Process()
	if(modded)
		drain_water()

/obj/structure/reagent_dispensers/watertank/Destroy()
	. = ..()

	STOP_PROCESSING(SSprocessing, src)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank containing welding fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	initial_reagent_types = list(/datum/reagent/fuel = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()

	if (modded)
		to_chat(user, "<span class='warning'>The faucet is wrenched open, leaking fuel!</span>")
	if(rig)
		to_chat(user, "<span class='notice'>There is some kind of device rigged to the tank.</span>")

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message("<span class='notice'>\The [usr] begins to detach \the [rig] from \the [src].</span>", "<span class='notice'>You begin to detach \the [rig] from \the [src].</span>")
		if(do_after(usr, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			usr.visible_message("<span class='notice'>\The [usr] detaches \the [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.dropInto(usr.loc)
			rig = null
			overlays.Cut()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W,/obj/item/wrench))
		user.visible_message("\The [user] wrenches \the [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		if (modded)
			log_and_message_admins("opened a fuel tank at [loc.loc.name], leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)
	else if (istype(W,/obj/item/device/assembly_holder))
		if (rig)
			to_chat(user, "<span class='warning'>There is another device already in the way.</span>")
			return ..()
		user.visible_message("\The [user] begins rigging \the [W] to \the [src].", "You begin rigging \the [W] to \the [src]")
		if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(!user.unEquip(W, src))
				return
			user.visible_message("<span class='notice'>\The [user] rigs \the [W] to \the [src].</span>", "<span class='notice'>You rig \the [W] to \the [src].</span>")

			var/obj/item/device/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
				log_and_message_admins("rigged a fuel tank for explosion at [loc.loc.name].")
			rig = W
			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test

	else if(isflamesource(W))
		if(user.a_intent != I_HURT)
			to_chat(user, "<span class='warning'>You almost got \the [W] too close to [src]! That could have ended very badly for you.</span>")
			return

		user.visible_message("<span class='warning'>\The [user] draws closer to the fuel tank with \the [W].</span>", "<span class='warning'>You draw closer to the fuel tank with \the [W].</span>")
		if(do_after(user, 5 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT)) // No public progress - Leave the people that might try to rush it guessing
			log_and_message_admins("triggered a fuel tank explosion with \the [W].")
			user.visible_message("<span class='danger'>\The [user] puts \the [W] to \the [src]!</span>", "<span class='danger'>You put \the [W] to \the [src] and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.</span>")
			src.explode()

		return

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			var/turf/turf = get_turf(src)
			if(turf)
				var/area/area = turf.loc || "*unknown area*"
				log_and_message_admins("[key_name_admin(Proj.firer)] shot a fuel tank in \the [area].")
			else
				log_and_message_admins("shot a fuel tank outside the world.")

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	for(var/datum/reagent/R in reagents.reagent_list)
		R.ex_act(src, 1)
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (modded)
		explode()
	else if (exposed_temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(/datum/reagent/fuel,amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45
	initial_reagent_types = list(/datum/reagent/capsaicin/condensed = 1)


/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses cool water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	initial_capacity = 500
	initial_reagent_types = list(/datum/reagent/water = 1)
	var/cups = 12
	var/cup_type = /obj/item/reagent_containers/food/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/attack_hand(var/mob/user)
	if(cups > 0)
		var/visible_messages = DispenserMessages(user)
		visible_message(visible_messages[1], visible_messages[2])
		var/cup = new cup_type(loc)
		user.put_in_active_hand(cup)
		cups--
	else
		to_chat(user, RejectionMessage(user))

/obj/structure/reagent_dispensers/water_cooler/proc/DispenserMessages(var/mob/user)
	return list("\The [user] grabs a paper cup from \the [src].", "You grab a paper cup from \the [src]'s cup compartment.")

/obj/structure/reagent_dispensers/water_cooler/proc/RejectionMessage(var/mob/user)
	return "The [src]'s cup dispenser is empty."

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W,/obj/item/wrench))
		src.add_fingerprint(user)
		if(anchored)
			user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else
		flick("[icon_state]-vend", src)
		return ..()

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	initial_reagent_types = list(/datum/reagent/ethanol/beer = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/acid
	name = "sulphuric acid dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	initial_reagent_types = list(/datum/reagent/acid = 1)
