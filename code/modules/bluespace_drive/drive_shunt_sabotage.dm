/obj/machinery/power/shunt/attackby(obj/item/O, mob/user)

	// Toggle locked status.
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/modular_computer/pda))
		var/obj/item/id = O
		if(!check_access_list(id.GetAccess()))
			to_chat(user, SPAN_WARNING("Access denied."))
			return

		if(shunt_state & SHUNT_STATE_LOCKED)
			if(drive)
				drive.remove_shunt(src)
			else
				shunt_state &= ~SHUNT_STATE_LOCKED
		else
			if(!drive)
				to_chat(user, SPAN_WARNING("\The [src] is not connected to a drive core and cannot be locked down."))
				return
			shunt_state |= ~SHUNT_STATE_LOCKED

		to_chat(user, SPAN_WARNING("\The [src] swipes \the [O] through \the [src], [(shunt_state & SHUNT_STATE_LOCKED) ? "locking it in place" : "disconnecting it"]."))

	// Toggle anchored status.
	else if(isWrench(O))
		if(drive && (shunt_state & SHUNT_STATE_LOCKED))
			to_chat(user, SPAN_WARNING("\The [src] is locked in place and cannot be disconnected."))
			return
		visible_message(SPAN_NOTICE("\The [user] begins [anchored ? "unsecuring" : "securing"] \the [src]..."))
		if(!do_after(usr, 50, src) || (drive && (shunt_state & SHUNT_STATE_LOCKED)))
			return
		if(drive)
			drive.remove_shunt(src)
		anchored = !anchored
		user.visible_message(SPAN_NOTICE("\The [user] [anchored ? "secured" : "unsecures"] \the [src]."))
		update_connection()

	// Screw/unscrew panel.
	else if(isScrewdriver(O))
		if(shunt_state & SHUNT_STATE_PANEL_UNSCREWED)
			if(shunt_state & SHUNT_STATE_PANEL_OPEN)
				to_chat(user, SPAN_WARNING("You must crowbar the panel closed first."))
				return
			shunt_state &= ~SHUNT_STATE_PANEL_UNSCREWED
			visible_message(SPAN_NOTICE("\The [user] screws \the [src]'s maintenance panel into place."))
		else
			shunt_state |= SHUNT_STATE_PANEL_UNSCREWED
			visible_message(SPAN_NOTICE("\The [user] loosens the screws holding \the [src]'s maintenance panel in place."))

	// Open/close panel.
	else if(isCrowbar(O))
		if(shunt_state & SHUNT_STATE_PANEL_OPEN)
			shunt_state &= ~SHUNT_STATE_PANEL_OPEN
			visible_message(SPAN_NOTICE("\The [user] levers \the [src]'s maintenance panel closed."))
		else
			if(!(shunt_state & SHUNT_STATE_PANEL_UNSCREWED))
				to_chat(user, SPAN_WARNING("You must unscrew the panel first."))
				return
			shunt_state |= SHUNT_STATE_PANEL_OPEN
			visible_message(SPAN_NOTICE("\The [user] levers \the [src]'s maintenance panel open."))

	// Perform sabotage.
	else if(isWirecutter(O))
		if(shunt_state & SHUNT_STATE_ADJUSTED)
			shunt_state &= ~SHUNT_STATE_ADJUSTED
			visible_message(SPAN_NOTICE("\The [user] connects and adjusts some of \the [src]'s internal wiring."))
			to_chat(user, SPAN_NOTICE("You reconnect the voltometer and enable the surge protection inside \the [src]."))
		else
			shunt_state |= SHUNT_STATE_ADJUSTED
			to_chat(user, SPAN_DANGER("You disconnect the voltometer and disable the surge protection inside \the [src]!"))

	// Prime it for the antag bluespace jump disaster effect.
	else if(istype(O, /obj/item/stack/telecrystal))

		if(!drive)
			to_chat(user, SPAN_WARNING("\The [src] is not connected to a drive core, priming it with a telecrystal would be pointless."))
			return

		if(!(shunt_state & SHUNT_STATE_PANEL_OPEN))
			to_chat(user, SPAN_WARNING("Open the maintenance panel first!"))
			return

		if(!(shunt_state & SHUNT_STATE_ADJUSTED))
			to_chat(user, SPAN_WARNING("Disconnect the power monitors first!"))
			return

		if(shunt_state & SHUNT_STATE_PRIMED)
			to_chat(user, SPAN_WARNING("\The [src]'s internals are already warped by a knot of compressed spacetime."))
			return

		var/obj/item/stack/telecrystal/tc = O
		if(tc.get_amount() < TC_SABOTAGE_COST)
			to_chat(user, SPAN_WARNING("You need at least [TC_SABOTAGE_COST] crystal\s to sabotage a power shunt."))
			return

		user.visible_message(SPAN_DANGER("\The [user] presses some telecrystals into the internals of \the [src], and spacetime itself warps ominously around it."))
		shunt_state |= SHUNT_STATE_PRIMED
		tc.use(TC_SABOTAGE_COST)

		switch(drive.is_sabotaged())
			if(1)
				to_chat(usr, SPAN_NOTICE("You have sabotaged one power shunt. The core will suffer a minor failure when spooled."))
			if(2)
				to_chat(usr, SPAN_NOTICE("You have sabotaged two power shunts. The core will suffer a major failure when spooled."))
			if(3)
				to_chat(usr, SPAN_NOTICE("You have sabotaged three power shunts. The core will suffer a disastrous failure when spooled."))
			else
				to_chat(usr, SPAN_NOTICE("You have sabotaged several power shunts. The core will suffer a disastrous failure when spooled."))
	else
		..()
	update_icon()