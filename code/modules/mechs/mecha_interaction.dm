/mob/living/MouseDrop(atom/over)
	if(usr == src && usr != over)
		if(istype(over, /mob/living/heavy_vehicle))
			var/mob/living/heavy_vehicle/mech = over
			if(mech.body)
				if(usr.mob_size >= mech.body.min_pilot_size && usr.mob_size <= mech.body.max_pilot_size)
					if(mech.enter(src))
						return
				else
					to_chat(usr, "<span class='warning'>You cannot pilot a mech of this size.</span>")
					return
	return ..()


/mob/living/heavy_vehicle/ClickOn(var/atom/A, var/params, var/mob/user)

	if(!user || incapacitated() || user.incapacitated())
		return

	if(!loc) return
	var/adj = A.Adjacent(src) // Why in the fuck isn't Adjacent() commutative.

	var/modifiers = params2list(params)
	if(modifiers["shift"])
		A.examine(user)
		return

	if(user != pilot && user != src)
		return

	// Are we facing the target?
	if(A.loc != src && !(get_dir(src, A) & dir))
		return

	if(!canClick())
		return

	if(!arms)
		to_chat(user, "<span class='warning'>\The [src] has no manipulators!</span>")
		setClickCooldown(3)
		return

	if(!arms.motivator || !arms.motivator.is_functional())
		to_chat(user, "<span class='warning'>Your motivators are damaged! You can't use your manipulators!</span>")
		setClickCooldown(15)
		return

	// You may attack the target with your MECH FIST if you're malfunctioning.
	if(!((emp_damage>EMP_ATTACK_DISRUPT) && prob(emp_damage*2)))
		if(selected_system)
			if(selected_system == A)
				selected_system.attack_self(user)
				setClickCooldown(5)
				return

			// Mounted non-exosuit systems have some hacky loc juggling
			// to make sure that they work.
			var/system_moved
			var/obj/item/temp_system
			if(istype(selected_system, /obj/item/mecha_equipment))
				var/obj/item/mecha_equipment/ME = selected_system
				temp_system = ME.get_effective_obj()
				if(temp_system in ME)
					system_moved = 1
					temp_system.forceMove(src)
			else
				temp_system = selected_system

			// Slip up and attack yourself maybe.
			if(emp_damage>EMP_MOVE_DISRUPT && prob(10))
				A = src
				adj = 1

			var/resolved
			if(adj) resolved = A.attackby(temp_system, src)
			if(!resolved && A && temp_system)
				temp_system.afterattack(A,src,adj,params)
			setClickCooldown(arms ? arms.action_delay : 15)
			if(system_moved)
				temp_system.forceMove(selected_system)
			return

	if(A == src)
		setClickCooldown(5)
		return attack_self(pilot)
	else if(adj)
		setClickCooldown(arms ? arms.action_delay : 15)
		return A.attack_generic(src, arms.melee_damage, "attacked")
	return

/mob/living/heavy_vehicle/proc/set_hardpoint(var/hardpoint_tag)
	clear_selected_hardpoint()
	if(hardpoints[hardpoint_tag])
		// Set the new system.
		selected_system = hardpoints[hardpoint_tag]
		selected_hardpoint = hardpoint_tag
		return 1 // The element calling this proc will set its own icon.
	return 0

/mob/living/heavy_vehicle/proc/clear_selected_hardpoint()

	if(selected_hardpoint)
		for(var/hardpoint in hardpoints)
			if(hardpoint != selected_hardpoint)
				continue
			var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
			if(istype(H))
				H.icon_state = "hardpoint"
				break
		selected_system = null
	selected_hardpoint = null

/mob/living/heavy_vehicle/proc/enter(var/mob/user)
	if(!user || user.incapacitated())
		return
	if(!user.Adjacent(src))
		return
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	if(hatch_closed)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is closed.</span>")
		return
	if(pilot)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return
	to_chat(user, "<span class='notice'>You start climbing into \the [src]...</span>")
	if(!do_after(user, 30))
		return
	if(!user || user.incapacitated())
		return
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	if(hatch_closed)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is closed.</span>")
		return
	if(pilot)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return
	to_chat(user, "<span class='notice'>You climb into \the [src].</span>")
	user.forceMove(src)
	pilot = user
	sync_access()
	update_pilot_overlay()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	to_chat(pilot, sound('sound/mecha/nominal.ogg',volume=50))
	if(user.client) user.client.screen |= hud_elements
	update_icon()
	return 1

/mob/living/heavy_vehicle/proc/sync_access()
	access_card.access = saved_access.Copy()
	if(!sync_access || !pilot) return
	var/obj/item/weapon/card/id/pilot_id = pilot.GetIdCard()
	if(pilot_id && pilot_id.access) access_card.access |= pilot_id.access
	to_chat(pilot, "<span class='notice'>Security access permissions synchronized.</span>")

/mob/living/heavy_vehicle/proc/eject(var/mob/user, var/silent)
	if(!user || !(user in src.contents))
		return
	if(hatch_closed)
		if(hatch_locked)
			if(!silent)
				to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
			return
		hud_open.toggled()
		if(!silent)
			to_chat(user, "<span class='notice'>You open the hatch and climb out of \the [src].</span>")
	else
		if(!silent)
			to_chat(user, "<span class='notice'>You climb out of \the [src].</span>")

	user.forceMove(get_turf(src))
	if(user.client)
		user.client.screen -= hud_elements
		user.client.eye = user
	if(user == pilot)
		zone_sel = null
		a_intent = I_HURT
		pilot = null
		update_pilot_overlay()
	return 1

/mob/living/heavy_vehicle/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/mecha_equipment))
		if(hardpoints_locked)
			to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
			return

		for(var/hardpoint in hardpoints)
			if(install_system(thing, hardpoint, user))
				return
		to_chat(user, "<span class='warning'>\The [src] has no available, compatible hardpoints to use.</span>")
		return

	else if(istype(thing, /obj/item/device/kit/paint))
		user.visible_message("<span class='notice'>\The [user] opens \the [thing] and spends some quality time customising \the [src].</span>")
		var/obj/item/device/kit/paint/P = thing
		SetName(P.new_name)
		desc = P.new_desc
		decal = P.new_icon
		if(P.new_icon_file)
			icon = P.new_icon_file
		update_icon()
		P.use(1, user)
		return 1

	else
		if(user.a_intent != I_HURT)
			if(isMultitool(thing))
				if(hardpoints_locked)
					to_chat(user, "<span class='warning'>Hardpoint system access is disabled.</span>")
					return
				for(var/hardpoint in hardpoints)
					if(remove_system(hardpoint, user))
						return
				to_chat(user, "<span class='warning'>\The [src] has no hardpoint systems to remove.</span>")
				return
			else if(isWrench(thing))
				if(!maintenance_protocols)
					to_chat(user, "<span class='warning'>The securing bolts are not visible while maintenance protocols are disabled.</span>")
					return
				to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
				dismantle()
				return
	return ..()

/mob/living/heavy_vehicle/attack_hand(var/mob/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_HURT)
		if(!pilot)
			to_chat(user, "<span class='warning'>There is nobody inside \the [src].</span>")
		else if(!hatch_closed)
			user.visible_message("<span class='danger'>\The [user] is trying to pull \the [pilot] out of \the [src]!</span>")
			if(do_after(user, 30) && user.Adjacent(src) && pilot && !hatch_closed)
				user.visible_message("<span class='danger'>\The [user] drags \the [pilot] out of \the [src]!</span>")
				eject(pilot, silent=1)
		return

	// Otherwise toggle the hatch.
	if(hatch_locked)
		to_chat(user, "<span class='warning'>The [body.hatch_descriptor] is locked.</span>")
		return
	hatch_closed = !hatch_closed
	to_chat(user, "<span class='notice'>You [hatch_closed ? "close" : "open"] the [body.hatch_descriptor].</span>")
	hud_open.update_icon()
	update_icon()
	return

/mob/living/heavy_vehicle/proc/attack_self(var/mob/user)
	return visible_message("\The [src] pokes itself.")
