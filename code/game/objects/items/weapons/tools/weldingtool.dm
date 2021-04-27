/obj/item/weldingtool
	name = "welding tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	item_state = "welder"
	desc = "A portable welding gun with a port for attaching fuel tanks."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	center_of_mass = "x=14;y=15"
	waterproof = FALSE
	force = 5
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)
	origin_tech = list(TECH_ENGINEERING = 1)

	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/welding_resource = "welding fuel"
	var/obj/item/welder_tank/tank = /obj/item/welder_tank // where the fuel is stored

/obj/item/weldingtool/Initialize()
	if(ispath(tank))
		tank = new tank
		w_class = tank.size_in_use
		force = tank.unlit_force

	set_extension(src, /datum/extension/base_icon_state, icon_state)
	update_icon()

	. = ..()

/obj/item/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)

	QDEL_NULL(tank)

	return ..()

/obj/item/weldingtool/examine(mob/user, distance)
	. = ..()
	if (!tank)
		to_chat(user, "There is no [welding_resource] source attached.")
	else
		to_chat(user, (distance <= 1 ? "It has [get_fuel()] [welding_resource] remaining. " : "") + "[tank] is attached.")

/obj/item/weldingtool/MouseDrop(atom/over)
	if(!CanMouseDrop(over, usr))
		return

	if(istype(over, /obj/item/weldpack))
		var/obj/item/weldpack/wp = over
		if(wp.welder)
			to_chat(usr, "\The [wp] already has \a [wp.welder] attached.")
		else if(usr.unEquip(src, wp))
			wp.welder = src
			usr.visible_message("[usr] attaches \the [src] to \the [wp].", "You attach \the [src] to \the [wp].")
			wp.update_icon()
		return

	..()

/obj/item/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(welding)
		to_chat(user, SPAN_DANGER("Stop welding first!"))
		return

	if(isScrewdriver(W))
		status = !status
		if(status)
			to_chat(user, SPAN_NOTICE("You secure the welder."))
		else
			to_chat(user, SPAN_NOTICE("The welder can now be attached and modified."))
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/material/rods)))
		var/obj/item/stack/material/rods/R = W
		R.use(1)
		var/obj/item/flamethrower/F = new/obj/item/flamethrower(user.loc)
		user.drop_from_inventory(src, F)
		F.weldtool = src
		master = F
		add_fingerprint(user)
		return

	if (istype(W, /obj/item/welder_tank))
		if (tank)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank attached - remove it first."))
			return
		if (user.get_active_hand() != src && user.get_inactive_hand() != src)
			to_chat(user, SPAN_WARNING("You must hold the welder in your hands to attach a tank."))
			return
		if (!user.unEquip(W, src))
			return
		tank = W
		user.visible_message("[user] slots \a [W] into \the [src].", "You slot \a [W] into \the [src].")
		w_class = tank.size_in_use
		force = tank.unlit_force
		update_icon()
		return

	..()


/obj/item/weldingtool/attack_hand(mob/user as mob)
	if (tank && user.get_inactive_hand() == src)
		if (!welding)
			user.visible_message("[user] removes \the [tank] from \the [src].", "You remove \the [tank] from \the [src].")
			user.put_in_hands(tank)
			tank = null
			w_class = initial(w_class)
			force = initial(force)
			update_icon()
		else
			to_chat(user, SPAN_DANGER("Turn off the welder first!"))

	else
		..()

/obj/item/weldingtool/water_act()
	if(welding && !waterproof)
		setWelding(0)

/obj/item/weldingtool/Process()
	if(welding)
		if((!waterproof && submerged()) || !remove_fuel(0.05))
			setWelding(0)

/obj/item/weldingtool/afterattack(var/obj/O, var/mob/user, proximity)
	if(!proximity)
		return

	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !welding)
		if(!tank)
			to_chat(user, SPAN_WARNING("\The [src] has no tank attached!"))
			return
		if (!tank.can_refuel)
			to_chat(user, SPAN_WARNING("\The [tank] does not have a refuelling port."))
			return
		O.reagents.trans_to_obj(tank, tank.max_fuel)
		to_chat(user, SPAN_NOTICE("You refuel \the [tank]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if(welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		else if(istype(O))
			O.HandleObjectHeating(src, user, 700)
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return

/obj/item/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return tank ? tank.reagents.get_reagent_amount(/datum/reagent/fuel) : 0

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		burn_fuel(amount)
		if(M)
			M.welding_eyecheck()//located in mob_helpers.dm
			set_light(0.7, 2, 5, l_color = COLOR_LIGHT_CYAN)
			addtimer(CALLBACK(src, /atom/proc/update_icon), 5)
		return 1
	else
		if(M)
			to_chat(M, SPAN_NOTICE("You need more [welding_resource] to complete this task."))
		return 0

/obj/item/weldingtool/proc/burn_fuel(var/amount)
	if(!tank)
		return

	var/mob/living/in_mob = null

	//consider ourselves in a mob if we are in the mob's contents and not in their hands
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		if(!(L.l_hand == src || L.r_hand == src))
			in_mob = L

	if(in_mob)
		amount = max(amount, 2)
		tank.reagents.trans_type_to(in_mob, /datum/reagent/fuel, amount)
		in_mob.IgniteMob()

	else
		tank.reagents.remove_reagent(/datum/reagent/fuel, amount)
		var/turf/location = get_turf(src.loc)
		if(location)
			location.hotspot_expose(700, 5)

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

/obj/item/weldingtool/get_storage_cost()
	if(isOn())
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/obj/item/weldingtool/on_update_icon()
	..()
	overlays.Cut()
	if(tank)
		overlays += image('icons/obj/tools.dmi', "welder_[tank.icon_state]")
	if(welding)
		overlays += image('icons/obj/tools.dmi', "welder_on")
		set_light(0.6, 0.5, 2.5, l_color =COLOR_PALE_ORANGE)
	else
		set_light(0)
	item_state = welding ? "welder1" : "welder"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if (!status)
		return

	if(!welding && !waterproof && submerged())
		if(M)
			to_chat(M, SPAN_WARNING("You cannot light \the [src] underwater."))
		return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, SPAN_NOTICE("You switch the [src] on."))
			else if(T)
				T.visible_message(SPAN_WARNING("\The [src] turns on."))
			if (istype(src, /obj/item/weldingtool/electric))
				src.force = 11
				src.damtype = ELECTROCUTE
			else
				src.force = tank.lit_force
				src.damtype = BURN
			welding = 1
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			if(M)
				to_chat(M, SPAN_NOTICE("You need more [welding_resource] to complete this task."))
			return
	//Otherwise
	else if(!set_welding && welding)
		STOP_PROCESSING(SSobj, src)
		if(M)
			to_chat(M, SPAN_NOTICE("You switch \the [src] off."))
		else if(T)
			T.visible_message(SPAN_WARNING("\The [src] turns off."))
		if (istype(src, /obj/item/weldingtool/electric))
			src.force = initial(force)
		else
			src.force = tank.unlit_force
		src.damtype = BRUTE
		src.welding = 0
		update_icon()

/obj/item/weldingtool/attack(mob/living/M, mob/living/user, target_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.organs_by_name[target_zone]

		if(!S || !BP_IS_ROBOTIC(S) || user.a_intent != I_HELP)
			return ..()

		if(BP_IS_BRITTLE(S))
			to_chat(user, SPAN_WARNING("\The [M]'s [S.name] is hard and brittle - \the [src]  cannot repair it."))
			return 1

		if(!welding)
			to_chat(user, SPAN_WARNING("You'll need to turn [src] on to patch the damage on [M]'s [S.name]!"))
			return 1

		if(S.robo_repair(15, BRUTE, "some dents", src, user))
			remove_fuel(1, user)

	else
		return ..()

/obj/item/weldingtool/mini
	tank = /obj/item/welder_tank/mini

/obj/item/weldingtool/largetank
	tank = /obj/item/welder_tank/large

/obj/item/weldingtool/hugetank
	tank = /obj/item/welder_tank/huge

/obj/item/weldingtool/experimental
	tank = /obj/item/welder_tank/experimental

///////////////////////
//Welding tool tanks//
/////////////////////
/obj/item/welder_tank
	name = "\improper welding fuel tank"
	desc = "An interchangeable fuel tank meant for a welding tool."
	icon = 'icons/obj/tools.dmi'
	icon_state = "tank_normal"
	w_class = ITEM_SIZE_SMALL
	force = 5
	throwforce = 5
	var/max_fuel = 20
	var/can_refuel = 1
	var/size_in_use = ITEM_SIZE_NORMAL
	var/unlit_force = 7
	var/lit_force = 11

/obj/item/welder_tank/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	. = ..()

/obj/item/welder_tank/afterattack(obj/O as obj, mob/user as mob, proximity)
	if (!proximity)
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src, O) <= 1)
		if (!can_refuel)
			to_chat(user, SPAN_DANGER("\The [src] does not have a refuelling port."))
			return
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You refuel \the [src]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)

/obj/item/welder_tank/mini
	name = "small welding fuel tank"
	icon_state = "tank_small"
	w_class = ITEM_SIZE_TINY
	max_fuel = 5
	force = 4
	throwforce = 4
	size_in_use = ITEM_SIZE_SMALL
	unlit_force = 5
	lit_force = 7

/obj/item/welder_tank/large
	name = "large welding fuel tank"
	icon_state = "tank_large"
	w_class = ITEM_SIZE_SMALL
	max_fuel = 40
	force = 6
	throwforce = 6
	size_in_use = ITEM_SIZE_NORMAL


/obj/item/welder_tank/huge
	name = "huge welding fuel tank"
	icon_state = "tank_huge"
	w_class = ITEM_SIZE_NORMAL
	max_fuel = 80
	force = 8
	throwforce = 8
	size_in_use = ITEM_SIZE_LARGE
	unlit_force = 9
	lit_force = 15

/obj/item/welder_tank/experimental
	name = "experimental welding fuel tank"
	icon_state = "tank_experimental"
	w_class = ITEM_SIZE_NORMAL
	max_fuel = 40
	can_refuel = 0
	force = 8
	throwforce = 8
	size_in_use = ITEM_SIZE_LARGE
	unlit_force = 9
	lit_force = 15
	var/last_gen = 0

/obj/item/welder_tank/experimental/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/welder_tank/experimental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/welder_tank/experimental/Process()
	var/cur_fuel = reagents.get_reagent_amount(/datum/reagent/fuel)
	if(cur_fuel < max_fuel)
		var/gen_amount = ((world.time-last_gen)/25)
		reagents.add_reagent(/datum/reagent/fuel, gen_amount)
		last_gen = world.time