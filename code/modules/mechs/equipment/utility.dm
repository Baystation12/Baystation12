/obj/item/mech_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/carrying_capacity = 5
	var/list/obj/carrying = list()

/obj/item/mech_equipment/clamp/resolve_attackby(atom/A, mob/user, click_params)
	if(owner)
		return 0
	return ..()

/obj/item/mech_equipment/clamp/attack_hand(mob/user)
	if(owner && LAZYISIN(owner.pilots, user))
		if(!owner.hatch_closed && length(carrying))
			var/obj/chosen_obj = input(user, "Choose an object to grab.", "Clamp Claw") as null|anything in carrying
			if(!chosen_obj)
				return
			if(!do_after(user, 20, owner)) return
			if(owner.hatch_closed || !chosen_obj) return
			if(user.put_in_active_hand(chosen_obj))
				owner.visible_message(SPAN_NOTICE("\The [user] carefully grabs \the [chosen_obj] from \the [src]."))
				playsound(src, 'sound/mecha/hydraulic.ogg', 50, 1)
				carrying -= chosen_obj
	. = ..()

/obj/item/mech_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()

	if(.)
		if(length(carrying) >= carrying_capacity)
			to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
			return
		if(istype(target, /obj))
			var/obj/O = target
			if(O.buckled_mob)
				return
			if(locate(/mob/living) in O)
				to_chat(user, SPAN_WARNING("You can't load living things into the cargo compartment."))
				return

			if(O.anchored)
				//Special door handling
				if(istype(O, /obj/machinery/door/firedoor))
					var/obj/machinery/door/firedoor/FD = O
					if(FD.blocked)
						FD.visible_message(SPAN_DANGER("\The [owner] begins prying on \the [FD]!"))
						if(do_after(owner,10 SECONDS,FD) && FD.blocked)
							playsound(FD, 'sound/effects/meteorimpact.ogg', 100, 1)
							playsound(FD, 'sound/machines/airlock_creaking.ogg', 100, 1)
							FD.blocked = FALSE
							addtimer(CALLBACK(FD, /obj/machinery/door/firedoor/.proc/open, TRUE), 0)
							FD.set_broken(TRUE)
							FD.visible_message(SPAN_WARNING("\The [owner] tears \the [FD] open!"))
					else
						FD.visible_message(SPAN_DANGER("\The [owner] begins forcing \the [FD]!"))
						if(do_after(owner, 4 SECONDS,FD) && !FD.blocked)
							playsound(FD, 'sound/machines/airlock_creaking.ogg', 100, 1)
							if(FD.density)
								FD.visible_message(SPAN_DANGER("\The [owner] forces \the [FD] open!"))
								addtimer(CALLBACK(FD, /obj/machinery/door/firedoor/.proc/open, TRUE), 0)
							else
								FD.visible_message(SPAN_WARNING("\The [owner] forces \the [FD] closed!"))
								addtimer(CALLBACK(FD, /obj/machinery/door/firedoor/.proc/close, TRUE), 0)
					return
				else if(istype(O, /obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AD = O
					if(!AD.operating && !AD.locked)
						if(AD.welded)
							AD.visible_message(SPAN_DANGER("\The [owner] begins prying on \the [AD]!"))
							if(do_after(owner, 15 SECONDS,AD) && !AD.locked)
								AD.welded = FALSE
								AD.update_icon()
								playsound(AD, 'sound/effects/meteorimpact.ogg', 100, 1)
								playsound(AD, 'sound/machines/airlock_creaking.ogg', 100, 1)
								AD.visible_message(SPAN_DANGER("\The [owner] tears \the [AD] open!"))
								addtimer(CALLBACK(AD, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
								AD.set_broken(TRUE)
								return
						else
							AD.visible_message(SPAN_DANGER("\The [owner] begins forcing \the [AD]!"))
							if((AD.is_broken(NOPOWER) || do_after(owner, 5 SECONDS,AD)) && !(AD.operating || AD.welded || AD.locked))
								playsound(AD, 'sound/machines/airlock_creaking.ogg', 100, 1)
								if(AD.density)
									addtimer(CALLBACK(AD, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
									if(!AD.is_broken(NOPOWER))
										AD.set_broken(TRUE)
									AD.visible_message(SPAN_DANGER("\The [owner] forces \the [AD] open!"))
								else
									addtimer(CALLBACK(AD, /obj/machinery/door/airlock/.proc/close, TRUE), 0)
									if(!AD.is_broken(NOPOWER))
										AD.set_broken(TRUE)
									AD.visible_message(SPAN_DANGER("\The [owner] forces \the [AD] closed!"))
					if(AD.locked)
						to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
					return

				to_chat(user, SPAN_WARNING("\The [target] is firmly secured."))
				return

			owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [O]."))
			if(do_after(owner, 20, O, do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND))
				if(O in carrying || O.buckled_mob || O.anchored || (locate(/mob/living) in O)) //Repeat checks
					return
				if(length(carrying) >= carrying_capacity)
					to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
					return
				O.forceMove(src)
				carrying += O
				owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [O] into its cargo compartment."))
				playsound(src, 'sound/mecha/hydraulic.ogg', 50, 1)

		//attacking - Cannot be carrying something, cause then your clamp would be full
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(user.a_intent == I_HURT)
				admin_attack_log(user, M, "attempted to clamp [M] with [src] ", "Was subject to a clamping attempt.", ", using \a [src], attempted to clamp")
				owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
				if(prob(33))
					owner.visible_message(SPAN_DANGER("[owner] swings its [src] in a wide arc at [target] but misses completely!"))
					return
				M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
				M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				to_chat(user, "<span class='warning'>You slam [target] with [src.name].</span>")
				owner.visible_message(SPAN_DANGER("[owner] slams [target] with the hydraulic clamp."))
			else
				step_away(M, owner)
				to_chat(user, "You push [target] out of the way.")
				owner.visible_message("[owner] pushes [target] out of the way.")

/obj/item/mech_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		drop_carrying(user, TRUE)

/obj/item/mech_equipment/clamp/CtrlClick(mob/user)
	if(owner)
		drop_carrying(user, FALSE)
	else
		..()

/obj/item/mech_equipment/clamp/proc/drop_carrying(var/mob/user, var/choose_object)
	if(!length(carrying))
		to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		return
	var/obj/chosen_obj = carrying[1]
	if(choose_object)
		chosen_obj = input(user, "Choose an object to set down.", "Clamp Claw") as null|anything in carrying
	if(!chosen_obj)
		return
	if(chosen_obj.density)
		for(var/atom/A in get_turf(src))
			if(A != owner && A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
				to_chat(user, SPAN_WARNING("\The [A] blocks you from putting down \the [chosen_obj]."))
				return

	owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [chosen_obj]."))
	playsound(src, 'sound/mecha/hydraulic.ogg', 50, 1)
	chosen_obj.forceMove(get_turf(src))
	carrying -= chosen_obj

/obj/item/mech_equipment/clamp/get_hardpoint_status_value()
	if(length(carrying) > 1)
		return length(carrying)/carrying_capacity
	return null

/obj/item/mech_equipment/clamp/get_hardpoint_maptext()
	if(length(carrying) == 1)
		return carrying[1].name
	else if(length(carrying) > 1)
		return "Multiple"
	. = ..()

/obj/item/mech_equipment/clamp/uninstalled()
	if(length(carrying))
		for(var/obj/load in carrying)
			var/turf/location = get_turf(src)
			var/list/turfs = location.AdjacentTurfsSpace()
			if(load.density)
				if(turfs.len > 0)
					location = pick(turfs)
					turfs -= location
				else
					load.dropInto(location)
					load.throw_at_random(FALSE, rand(2,4), 4)
					location = null
			if(location)
				load.dropInto(location)
			carrying -= load
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	item_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)


	var/on = 0
	var/l_max_bright = 0.9
	var/l_inner_range = 1
	var/l_outer_range = 6
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)

/obj/item/mech_equipment/light/installed(mob/living/exosuit/_owner)
	. = ..()
	update_icon()

/obj/item/mech_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		toggle()
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")

/obj/item/mech_equipment/light/proc/toggle()
	on = !on
	update_icon()
	owner.update_icon()
	active = on
	passive_power_use = on ? 0.1 KILOWATTS : 0

/obj/item/mech_equipment/light/deactivate()
	if(on)
		toggle()
	..()

/obj/item/mech_equipment/light/on_update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(l_max_bright, l_inner_range, l_outer_range)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0, 0)

	//Check our layers
	if(owner && (owner.hardpoints[HARDPOINT_HEAD] == src))
		mech_layer = MECH_INTERMEDIATE_LAYER
	else mech_layer = initial(mech_layer)

#define CATAPULT_SINGLE 1
#define CATAPULT_AREA   2

/obj/item/mech_equipment/catapult
	name = "gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = CATAPULT_SINGLE
	var/atom/movable/locked
	equipment_delay = 30 //Stunlocks are not ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	require_adjacent = FALSE

/obj/item/mech_equipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string


/obj/item/mech_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == CATAPULT_SINGLE ? CATAPULT_AREA : CATAPULT_SINGLE
		to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == CATAPULT_SINGLE ? "single" : "multi"]-target mode."))
		update_icon()


/obj/item/mech_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)

		switch(mode)
			if(CATAPULT_SINGLE)
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored || !AM.simulated)
						to_chat(user, SPAN_NOTICE("Unable to lock on [target]."))
						return
					locked = AM
					to_chat(user, SPAN_NOTICE("Locked on [AM]."))
					return
				else if(target != locked)
					if(locked in view(owner))
						locked.throw_at(target, 14, 1.5, owner)
						log_and_message_admins("used [src] to throw [locked] at [target].", user, owner.loc)
						locked = null

						var/obj/item/cell/C = owner.get_cell()
						if(istype(C))
							C.use(active_power_use * CELLRATE)

					else
						locked = null
						to_chat(user, SPAN_NOTICE("Lock on [locked] disengaged."))
			if(CATAPULT_AREA)

				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored || !A.simulated) continue
					var/dist = 5-get_dist(A,target)
					A.throw_at(get_edge_target_turf(A,get_dir(target, A)),dist,0.7)


				log_and_message_admins("used [src]'s area throw on [target].", user, owner.loc)
				var/obj/item/cell/C = owner.get_cell()
				if(istype(C))
					C.use(active_power_use * CELLRATE * 2) //bit more expensive to throw all



#undef CATAPULT_SINGLE
#undef CATAPULT_AREA


/obj/item/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "drill_head"

/obj/item/material/drill_head/proc/get_percent_durability()
	return round((durability / material.integrity) * 50)

/obj/item/material/drill_head/proc/get_visible_durability()
	switch (get_percent_durability())
		if (95 to INFINITY) . = "shows no wear"
		if (75 to 95) . = "shows some wear"
		if (50 to 75) . = "is fairly worn"
		if (10 to 50) . = "is very worn"
		else . = "looks close to breaking"

/obj/item/material/drill_head/examine(mob/user, distance)
	. = ..()
	to_chat(user, "It [get_visible_durability()].")


/obj/item/material/drill_head/steel
	default_material = MATERIAL_STEEL

/obj/item/material/drill_head/titanium
	default_material = MATERIAL_TITANIUM

/obj/item/material/drill_head/plasteel
	default_material = MATERIAL_PLASTEEL

/obj/item/material/drill_head/diamond
	default_material = MATERIAL_DIAMOND

/obj/item/material/drill_head/Initialize()
	. = ..()
	durability = 2 * material.integrity

/obj/item/mech_equipment/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mech_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	//Drill can have a head
	var/obj/item/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)



/obj/item/mech_equipment/drill/Initialize()
	. = ..()
	if (ispath(drill_head))
		drill_head = new drill_head(src)

/obj/item/mech_equipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message(SPAN_WARNING("[owner] revs the [drill_head], menancingly."))
			playsound(src, 'sound/mecha/mechdrill.ogg', 50, 1)

/obj/item/mech_equipment/drill/get_hardpoint_maptext()
	if(drill_head)
		return "Integrity: [drill_head.get_percent_durability()]%"
	return

/obj/item/mech_equipment/drill/examine(mob/user, distance)
	. = ..()
	if (drill_head)
		to_chat(user, "It has a[distance > 3 ? "" : " [drill_head.material.name]"] drill head installed.")
		if (distance < 4)
			to_chat(user, "The drill head [drill_head.get_visible_durability()].")
	else
		to_chat(user, "It does not have a drill head installed.")

/obj/item/mech_equipment/drill/proc/attach_head(obj/item/material/drill_head/DH, mob/user)
	if (user && !user.unEquip(DH))
		return
	if (drill_head)
		visible_message(SPAN_NOTICE("\The [user] detaches \the [drill_head] mounted on \the [src]."))
		drill_head.dropInto(get_turf(src))
	user.visible_message(SPAN_NOTICE("\The [user] mounts \the [drill_head] on \the [src]."))
	DH.forceMove(src)
	drill_head = DH


/obj/item/mech_equipment/drill/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/material/drill_head))
		attach_head(I, user)
		return TRUE
	. = ..()

/obj/item/mech_equipment/drill/proc/scoop_ore(at_turf)
	if (!owner)
		return
	for (var/hardpoint in owner.hardpoints)
		var/obj/item/item = owner.hardpoints[hardpoint]
		if (!istype(item))
			continue
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in item
		if (!ore_box)
			continue
		var/list/atoms_in_range = range(1, at_turf)
		for(var/obj/item/ore/ore in atoms_in_range)
			if (!(get_dir(owner, ore) & owner.dir))
				continue
			ore.Move(ore_box)

/obj/item/mech_equipment/drill/afterattack(atom/target, mob/living/user, inrange, params)
	if (!..()) // /obj/item/mech_equipment/afterattack implements a usage guard
		return

	if (istype(target, /obj/item/material/drill_head))
		attach_head(target, user)
		return

	if (!drill_head)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a head!"))
		return

	if (ismob(target))
		var/mob/tmob = target
		if (tmob.unacidable)
			to_chat(user, SPAN_WARNING("\The [target] can't be drilled away."))
			return
		else
			to_chat(tmob, FONT_HUGE(SPAN_DANGER("You're about to get drilled - dodge!")))

	else if (isobj(target))
		var/obj/tobj = target
		if (tobj.unacidable)
			to_chat(user, SPAN_WARNING("\The [target] can't be drilled away."))
			return

	else if (istype(target, /turf/unsimulated))
		to_chat(user, SPAN_WARNING("\The [target] can't be drilled away."))
		return

	var/obj/item/cell/mech_cell = owner.get_cell()
	mech_cell.use(active_power_use * CELLRATE) //supercall made sure we have one

	var/delay = 3 SECONDS //most things
	switch (drill_head.material.brute_armor)
		if (15 to INFINITY) delay = 0.5 SECONDS //voxalloy on a good roll
		if (10 to 15) delay = 1 SECOND //titanium, diamond
		if (5 to 10) delay = 2 SECONDS //plasteel, steel
	owner.setClickCooldown(delay)

	playsound(src, 'sound/mecha/mechdrill.ogg', 50, 1)
	owner.visible_message(
		SPAN_WARNING("\The [owner] starts to drill \the [target]."),
		blind_message = SPAN_WARNING("You hear a large motor whirring.")
	)
	if (!do_after(owner, delay, target, DO_DEFAULT & ~DO_USER_CAN_TURN))
		return
	if (src != owner.selected_system)
		to_chat(user, SPAN_WARNING("You must keep \the [src] selected to use it."))
		return
	if (drill_head.durability <= 0)
		drill_head.shatter()
		drill_head = null
		return

	if (istype(target, /turf/simulated/mineral))
		var/list/atoms_in_range = range(1, target)
		for (var/turf/simulated/mineral/mineral in atoms_in_range)
			if (!(get_dir(owner, mineral) & owner.dir))
				continue
			drill_head.durability -= 1
			mineral.GetDrilled()
		scoop_ore(target)
		return

	if (istype(target, /turf/simulated/floor/asteroid))
		var/list/atoms_in_range = range(1, target)
		for (var/turf/simulated/floor/asteroid/asteroid in atoms_in_range)
			if (!(get_dir(owner, asteroid) & owner.dir))
				continue
			drill_head.durability -= 1
			asteroid.gets_dug()
		scoop_ore(target)
		return

	if (istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/wall = target
		var/wall_hardness = max(wall.material.hardness, wall.reinf_material ? wall.reinf_material.hardness : 0)
		if (wall_hardness > drill_head.material.hardness)
			to_chat(user, SPAN_WARNING("\The [wall] is too hard to drill through with \the [drill_head]."))
			drill_head.durability -= 2
			return

	var/audible = "loudly grinding machinery"
	if (iscarbon(target)) //splorch
		audible = "a terrible rending of metal and flesh"

	owner.visible_message(
		SPAN_DANGER("\The [owner] drives \the [src] into \the [target]."),
		blind_message = SPAN_WARNING("You hear [audible].")
	)
	log_and_message_admins("used [src] on [target]", user, owner.loc)
	drill_head.durability -= 1
	target.ex_act(2)


/obj/item/mech_equipment/drill/steel
	drill_head = /obj/item/material/drill_head/steel

/obj/item/mech_equipment/drill/titanium
	drill_head = /obj/item/material/drill_head/titanium

/obj/item/mech_equipment/drill/plasteel
	drill_head = /obj/item/material/drill_head/plasteel

/obj/item/mech_equipment/drill/diamond
	drill_head = /obj/item/material/drill_head/diamond


/obj/item/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE


/obj/item/mech_equipment/mounted_system/taser/plasma
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "railauto" //TODO: Make a new sprite that doesn't get sec called on you.
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)

/obj/item/mech_equipment/mounted_system/taser/autoplasma
	icon_state = "mech_energy"
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech/auto
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 4)

/obj/item/gun/energy/plasmacutter/mounted/mech/auto
	charge_cost = 13
	name = "rotatory plasma cutter"
	desc = "A state of the art rotating, variable intensity, sequential-cascade plasma cutter. Resist the urge to aim this at your coworkers."
	max_shots = 15
	init_firemodes = list(
		list(mode_name="single shot",	can_autofire=0, burst=1, fire_delay=6),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1),
		)

/obj/item/mech_equipment/ionjets
	name = "\improper exosuit manouvering unit"
	desc = "A testament to the fact that sometimes more is actually more. These oversized electric resonance boosters allow exosuits to move in microgravity and can even provide brief speed boosts. The stabilizers can be toggled with ctrl-click."
	icon_state = "mech_jet_off"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	active_power_use = 90 KILOWATTS
	passive_power_use = 0 KILOWATTS
	var/activated_passive_power = 2 KILOWATTS
	var/movement_power = 75
	origin_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_PHORON = 3)
	var/datum/effect/effect/system/trail/ion/ion_trail
	require_adjacent = FALSE
	var/stabilizers = FALSE
	var/slide_distance = 6

/obj/item/mech_equipment/ionjets/Initialize()
	. = ..()
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)

/obj/item/mech_equipment/ionjets/proc/allowSpaceMove()
	if (!active)
		return FALSE

	var/obj/item/cell/C = owner.get_cell()
	if (istype(C))
		if (C.checked_use(movement_power * CELLRATE))
			return TRUE
		else
			deactivate()

	return FALSE

/obj/item/mech_equipment/ionjets/attack_self(mob/user)
	. = ..()
	if (!.)
		return

	if (active)
		deactivate()
	else
		activate()

/obj/item/mech_equipment/ionjets/CtrlClick(mob/user)
	if (owner && ((user in owner.pilots) || user == owner))
		if (active)
			stabilizers = !stabilizers
			to_chat(user, SPAN_NOTICE("You toggle the stabilizers [stabilizers ? "on" : "off"]"))
	else
		..()

/obj/item/mech_equipment/ionjets/proc/activate()
	passive_power_use = activated_passive_power
	ion_trail.start()
	active = TRUE
	update_icon()

/obj/item/mech_equipment/ionjets/deactivate()
	. = ..()
	passive_power_use = 0 KILOWATTS
	ion_trail.stop()
	update_icon()

/obj/item/mech_equipment/ionjets/on_update_icon()
	. = ..()
	if (active)
		icon_state = "mech_jet_on"
		set_light(1, 1, 1, l_color = COLOR_LIGHT_CYAN)
	else
		icon_state = "mech_jet_off"
		set_light(0)
	if(owner)
		owner.update_icon()

/obj/item/mech_equipment/ionjets/get_hardpoint_maptext()
	if (active)
		return "ONLINE - Stabilizers [stabilizers ? "on" : "off"]"
	else return "OFFLINE"

/obj/item/mech_equipment/ionjets/proc/slideCheck(turf/target)
	if (owner && istype(target))
		if ((get_dist(owner, target) <= slide_distance) && (get_dir(get_turf(owner), target) == owner.dir))
			return TRUE
	return FALSE

/obj/item/mech_equipment/ionjets/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if (. && active)
		if (owner.z != target.z)
			to_chat(user, SPAN_WARNING("You cannot reach that level!"))
			return FALSE
		var/turf/TT = get_turf(target)
		if (slideCheck(TT))
			playsound(src, 'sound/magic/forcewall.ogg', 30, 1)
			owner.visible_message(
				SPAN_WARNING("\The [src] charges up in preparation for a slide!"),
				blind_message = SPAN_WARNING("You hear a loud hum and an intense crackling.")
			)
			new /obj/effect/temporary(get_step(owner.loc, reverse_direction(owner.dir)), 2 SECONDS, 'icons/effects/effects.dmi',"cyan_sparkles")
			owner.setClickCooldown(2 SECONDS)
			if (do_after(owner, 2 SECONDS, do_flags = (DO_DEFAULT | DO_PUBLIC_PROGRESS | DO_USER_UNIQUE_ACT) & ~DO_USER_CAN_TURN) && slideCheck(TT))
				owner.visible_message(SPAN_DANGER("Burning hard, \the [owner] thrusts forward!"))
				owner.throw_at(get_ranged_target_turf(owner, owner.dir, slide_distance), slide_distance, 1, owner, FALSE)
			else
				owner.visible_message(SPAN_DANGER("\The [src] sputters and powers down"))
				owner.sparks.set_up(3,0,owner)
				owner.sparks.start()

		else
			to_chat(user, SPAN_WARNING("You cannot slide there!"))

/obj/item/mech_equipment/camera
	name = "exosuit camera"
	desc = "A dedicated visible light spectrum camera for remote feeds. It comes with its own transmitter!"
	icon_state = "mech_camera"
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	var/obj/machinery/camera/network/thunder/camera
	var/list/additional_networks //If you want to make a subtype for mercs, ert etc... Write here the extra networks

/obj/item/mech_equipment/camera/Destroy()
	QDEL_NULL(camera)
	. = ..()

/obj/item/mech_equipment/camera/Initialize()
	. = ..()
	camera = new(src)
	camera.c_tag = "null"
	camera.set_status(FALSE)
	camera.is_helmet_cam = TRUE //Can transmit locally regardless of network

/obj/item/mech_equipment/camera/installed(mob/living/exosuit/_owner)
	. = ..()
	if(owner)
		camera.c_tag = "[owner.name] camera feed"
		invalidateCameraCache()

/obj/item/mech_equipment/camera/uninstalled()
	. = ..()
	camera.c_tag = "null"
	invalidateCameraCache()

/obj/item/mech_equipment/camera/examine(mob/user)
	. = ..()
	to_chat(user, "Network: [english_list(camera.network)]; Feed is currently: [camera.status ? "Online" : "Offline"].")

/obj/item/mech_equipment/camera/proc/activate()
	camera.set_status(TRUE)
	passive_power_use = 0.2 KILOWATTS
	active = TRUE

/obj/item/mech_equipment/camera/deactivate()
	camera.set_status(FALSE)
	passive_power_use = 0
	. = ..()

/obj/item/mech_equipment/camera/attackby(obj/item/W, mob/user)
	. = ..()

	if(isScrewdriver(W))
		var/list/all_networks = list()
		for(var/network in GLOB.using_map.station_networks)
			if(has_access(get_camera_access(network), GetIdCard(user)))
				all_networks += network

		all_networks += additional_networks

		var/network = input("Which network would you like to configure it for?") as null|anything in (all_networks)
		if(!network)
			to_chat(user, SPAN_WARNING("You cannot connect to any camera network!."))
		var/delay = 20 * user.skill_delay_mult(SKILL_DEVICES)
		if(do_after(user, delay, src) && network)
			camera.network = list(network)
			camera.update_coverage(TRUE)
			to_chat(user, SPAN_NOTICE("You configure the camera for \the [network] network."))

/obj/item/mech_equipment/camera/attack_self(mob/user)
	. = ..()
	if(.)
		if(active)
			deactivate()
		else
			activate()
		to_chat(user, SPAN_NOTICE("You toggle \the [src] [active ? "on" : "off"]"))

/obj/item/mech_equipment/camera/get_hardpoint_maptext()
	return "[english_list(camera.network)]: [active ? "ONLINE" : "OFFLINE"]"
