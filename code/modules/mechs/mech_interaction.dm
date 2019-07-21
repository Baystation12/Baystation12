/mob/living/MouseDrop(atom/over)
	if(usr == src && usr != over)
		if(istype(over, /mob/living/exosuit))
			var/mob/living/exosuit/exosuit = over
			if(exosuit.body)
				if(usr.mob_size >= exosuit.body.min_pilot_size && usr.mob_size <= exosuit.body.max_pilot_size)
					if(exosuit.enter(src))
						return
				else
					to_chat(usr, SPAN_WARNING("You cannot pilot a exosuit of this size."))
					return
	return ..()

/mob/living/exosuit/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C))
		body.MouseDrop_T(dropping, user)
	else . = ..()


/mob/living/exosuit/ClickOn(var/atom/A, var/params, var/mob/user)

	if(!user || incapacitated() || user.incapacitated())
		return

	if(!loc) return
	var/adj = A.Adjacent(src) // Why in the fuck isn't Adjacent() commutative.

	var/modifiers = params2list(params)
	if(modifiers["shift"])
		A.examine(user)
		return

	if(!(user in pilots) && user != src)
		return

	// Are we facing the target?
	if(A.loc != src && !(get_dir(src, A) & dir))
		return

	if(!canClick())
		return

	if(!arms)
		to_chat(user, SPAN_WARNING("\The [src] has no manipulators!"))
		setClickCooldown(3)
		return

	if(!arms.motivator || !arms.motivator.is_functional())
		to_chat(user, SPAN_WARNING("Your motivators are damaged! You can't use your manipulators!"))
		setClickCooldown(15)
		return

	if(!get_cell().checked_use(arms.power_use * CELLRATE))
		to_chat(user, SPAN_WARNING("Error: Power levels insufficient."))

	// User is not necessarily the exosuit, or the same person, so update intent.
	if(user != src)
		a_intent = user.a_intent
		zone_sel.set_selected_zone(user.zone_sel.selecting)
	// You may attack the target with your exosuit FIST if you're malfunctioning.
	var/atom/movable/AM = A
	var/fail_prob = (user != src && istype(AM) && AM.loc != src) ? (user.skill_check(SKILL_MECH, HAS_PERK) ? 0: 15 ) : 0
	var/failed = FALSE
	if(prob(fail_prob))
		to_chat(user, SPAN_DANGER("Your incompetence leads you to target the wrong thing with the exosuit!"))
		failed = TRUE
	else if(emp_damage > EMP_ATTACK_DISRUPT && prob(emp_damage*2))
		to_chat(user, SPAN_DANGER("The wiring sparks as you attempt to control the exosuit!"))
		failed = TRUE

	if(!failed)
		if(selected_system)
			if(selected_system == A)
				selected_system.attack_self(user)
				setClickCooldown(5)
				return

			// Mounted non-exosuit systems have some hacky loc juggling
			// to make sure that they work.
			var/system_moved = FALSE
			var/obj/item/temp_system
			var/obj/item/mech_equipment/ME
			if(istype(selected_system, /obj/item/mech_equipment))
				ME = selected_system
				temp_system = ME.get_effective_obj()
				if(temp_system in ME)
					system_moved = 1
					temp_system.forceMove(src)
			else
				temp_system = selected_system

			// Slip up and attack yourself maybe.
			failed = FALSE
			if(prob(fail_prob))
				to_chat(user, SPAN_DANGER("You artlessly shove the exosuit controls the wrong way!"))
				failed = TRUE
			else if(emp_damage>EMP_MOVE_DISRUPT && prob(10))
				failed = TRUE

			if(failed)
				var/list/other_atoms = orange(1, A)
				A = null
				while(LAZYLEN(other_atoms))
					var/atom/picked = pick_n_take(other_atoms)
					if(istype(picked) && picked.simulated)
						A = picked
						break
				if(!A)
					A = src
				adj = A.Adjacent(src)

			var/resolved

			if(adj) resolved = A.attackby(temp_system, src)
			if(!resolved && A && temp_system)
				var/mob/ruser = src
				if(!system_moved) //It's more useful to pass along clicker pilot when logic is fully mechside
					ruser = user
				temp_system.afterattack(A,ruser,adj,params)
			if(system_moved) //We are using a proxy system that may not have logging like mech equipment does
				log_and_message_admins("used [temp_system] targetting [A]", user, src.loc)
			//Mech equipment subtypes can add further click delays
			var/extra_delay = 0
			if(ME != null)
				ME = selected_system
				extra_delay = ME.equipment_delay	
			setClickCooldown(arms ? arms.action_delay + extra_delay : 15 + extra_delay)
			if(system_moved)
				temp_system.forceMove(selected_system)
			return

	if(A == src)
		setClickCooldown(5)
		return attack_self(user)
	else if(adj)
		setClickCooldown(arms ? arms.action_delay : 15)
		return A.attack_generic(src, arms.melee_damage, "attacked")
	return

/mob/living/exosuit/proc/set_hardpoint(var/hardpoint_tag)
	clear_selected_hardpoint()
	if(hardpoints[hardpoint_tag])
		// Set the new system.
		selected_system = hardpoints[hardpoint_tag]
		selected_hardpoint = hardpoint_tag
		return 1 // The element calling this proc will set its own icon.
	return 0

/mob/living/exosuit/proc/clear_selected_hardpoint()

	if(selected_hardpoint)
		for(var/hardpoint in hardpoints)
			if(hardpoint != selected_hardpoint)
				continue
			var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
			if(istype(H))
				H.icon_state = "hardpoint"
				break
		selected_system = null
	selected_hardpoint = null

/mob/living/exosuit/proc/check_enter(var/mob/user)
	if(!user || user.incapacitated())
		return FALSE
	if(!user.Adjacent(src))
		return FALSE
	if(hatch_locked)
		to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
		return FALSE
	if(hatch_closed)
		to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is closed."))
		return FALSE
	if(LAZYLEN(pilots) >= LAZYLEN(body.pilot_positions))
		to_chat(user, SPAN_WARNING("\The [src] is occupied to capacity."))
		return FALSE
	return TRUE

/mob/living/exosuit/proc/enter(var/mob/user)
	if(!check_enter(user))
		return
	to_chat(user, SPAN_NOTICE("You start climbing into \the [src]..."))
	if(!do_after(user, 25))
		return
	if(!check_enter(user))
		return
	to_chat(user, SPAN_NOTICE("You climb into \the [src]."))
	user.forceMove(src)
	LAZYDISTINCTADD(pilots, user)
	sync_access()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	user.playsound_local(null, 'sound/mecha/nominal.ogg', 50)
	if(user.client) user.client.screen |= hud_elements
	LAZYDISTINCTADD(user.additional_vision_handlers, src)
	update_pilots()
	return 1

/mob/living/exosuit/proc/sync_access()
	access_card.access = saved_access.Copy()
	if(sync_access)
		for(var/mob/pilot in pilots)
			access_card.access |= pilot.GetAccess()
			to_chat(pilot, SPAN_NOTICE("Security access permissions synchronized."))

/mob/living/exosuit/proc/eject(var/mob/user, var/silent)
	if(!user || !(user in src.contents))
		return
	if(hatch_closed)
		if(hatch_locked)
			if(!silent)
				to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
			return
		hud_open.toggled()
		if(!silent)
			to_chat(user, SPAN_NOTICE("You open the hatch and climb out of \the [src]."))
	else
		if(!silent)
			to_chat(user, SPAN_NOTICE("You climb out of \the [src]."))

	user.forceMove(get_turf(src))
	LAZYREMOVE(user.additional_vision_handlers, src)
	if(user.client)
		user.client.screen -= hud_elements
		user.client.eye = user
	if(user in pilots)
		a_intent = I_HURT
		LAZYREMOVE(pilots, user)
		UNSETEMPTY(pilots)
		update_pilots()
	return 1

/mob/living/exosuit/attackby(var/obj/item/thing, var/mob/user)

	if(user.a_intent != I_HURT && istype(thing, /obj/item/mech_equipment))
		if(hardpoints_locked)
			to_chat(user, SPAN_WARNING("Hardpoint system access is disabled."))
			return

		var/obj/item/mech_equipment/realThing = thing
		if(realThing.owner)
			return

		var/free_hardpoints = list()
		for(var/hardpoint in hardpoints)
			if(hardpoints[hardpoint] == null)
				free_hardpoints += hardpoint
		var/to_place = input("Where would you like to install it?") as null|anything in (realThing.restricted_hardpoints & free_hardpoints)
		if(install_system(thing, to_place, user))
			return
		to_chat(user, SPAN_WARNING("\The [src] could not be installed in that hardpoint."))
		return

	else if(istype(thing, /obj/item/device/kit/paint))
		user.visible_message(SPAN_NOTICE("\The [user] opens \the [thing] and spends some quality time customising \the [src]."))
		var/obj/item/device/kit/paint/P = thing
		SetName(P.new_name)
		desc = P.new_desc
		for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
			comp.decal = P.new_icon
		if(P.new_icon_file)
			icon = P.new_icon_file
		queue_icon_update()
		P.use(1, user)
		return 1

	else
		if(user.a_intent != I_HURT)
			if(isMultitool(thing))
				if(hardpoints_locked)
					to_chat(user, SPAN_WARNING("Hardpoint system access is disabled."))
					return

				var/list/parts = list()
				for(var/hardpoint in hardpoints)
					if(hardpoints[hardpoint])
						parts += hardpoint

				var/to_remove = input("Which component would you like to remove") as null|anything in parts

				if(remove_system(to_remove, user))
					return
				to_chat(user, SPAN_WARNING("\The [src] has no hardpoint systems to remove."))
				return
			else if(isWrench(thing))
				if(!maintenance_protocols)
					to_chat(user, SPAN_WARNING("The securing bolts are not visible while maintenance protocols are disabled."))
					return

				visible_message(SPAN_WARNING("\The [user] begins unwrenching the securing bolts holding \the [src] together."))
				var/delay = 60 * user.skill_delay_mult(SKILL_DEVICES)
				if(!do_after(user, delay) || !maintenance_protocols)
					return
				visible_message(SPAN_NOTICE("\The [user] loosens and removes the securing bolts, dismantling \the [src]."))
				dismantle()
				return
	return ..()

/mob/living/exosuit/attack_hand(var/mob/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_HURT)
		if(!LAZYLEN(pilots))
			to_chat(user, SPAN_WARNING("There is nobody inside \the [src]."))
		else if(!hatch_closed)
			var/mob/pilot = pick(pilots)
			user.visible_message(SPAN_DANGER("\The [user] is trying to pull \the [pilot] out of \the [src]!"))
			if(do_after(user, 30) && user.Adjacent(src) && (pilot in pilots) && !hatch_closed)
				user.visible_message(SPAN_DANGER("\The [user] drags \the [pilot] out of \the [src]!"))
				eject(pilot, silent=1)
		return

	// Otherwise toggle the hatch.
	if(hatch_locked)
		to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
		return
	hatch_closed = !hatch_closed
	to_chat(user, SPAN_NOTICE("You [hatch_closed ? "close" : "open"] the [body.hatch_descriptor]."))
	hud_open.queue_icon_update()
	queue_icon_update()
	return

/mob/living/exosuit/proc/attack_self(var/mob/user)
	return visible_message("\The [src] pokes itself.")

/mob/living/exosuit/proc/rename(var/mob/user)
	if(user != src && !(user in pilots))
		return
	var/new_name = sanitize(input("Enter a new exosuit designation.", "Exosuit Name") as text|null, max_length = MAX_NAME_LEN)
	if(!new_name || new_name == name || (user != src && !(user in pilots)))
		return
	SetName(new_name)
	to_chat(user, SPAN_NOTICE("You have redesignated this exosuit as \the [name]."))
