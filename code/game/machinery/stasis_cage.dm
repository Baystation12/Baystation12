var/global/const/STASISCAGE_WIRE_SAFETY    = 1
var/global/const/STASISCAGE_WIRE_RELEASE   = 2
var/global/const/STASISCAGE_WIRE_LOCK      = 4

/obj/machinery/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/machines/research/stasis_cage.dmi'
	icon_state = "stasis_cage"
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	req_access = list(access_research)
	idle_power_usage = 0
	active_power_usage = 5 KILOWATTS
	use_power = POWER_USE_IDLE
	health_max = 200
	health_min_damage = 10
	construct_state = /singleton/machine_construction/default/panel_closed

	machine_name = "stasis cage"
	machine_desc = "A container with an internal stasis suspender to keep any fauna inside safe and secure for transport. Fauna not included."

	var/mob/living/contained
	var/datum/gas_mixture/airtank
	var/broken = FALSE
	var/safety = TRUE

	var/god = FALSE //Check if mob had godmode before being contained

	var/obj/item/cell/cell = null


/obj/machinery/stasis_cage/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T20C
	airtank.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, FALSE)
	airtank.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)

	cell = get_cell()

	var/mob/living/A = locate() in loc
	if(!A)
		release(A)
	else
		contain(A)

	wires = new/datum/wires/stasis_cage(src)


/obj/machinery/stasis_cage/Process()
	if (!is_powered())
		return
	if (contained)
		if (iscarbon(contained))
			var/mob/living/carbon/C = contained
			C.SetStasis(20)
		if (isanimal(contained))
			var/mob/living/simple_animal/SA = contained
			SA.in_stasis = TRUE
			if (!god)
				SA.status_flags ^= GODMODE


/obj/machinery/stasis_cage/proc/try_release(mob/user)
	if(!contained)
		to_chat(user, SPAN_WARNING("There's no animals inside \the [src]"))
		return
	if (broken)
		to_chat(user, SPAN_WARNING("\The [src]'s lid is broken!"))
		return
	if (!allowed(user))
		to_chat(user, SPAN_WARNING("\The [src] refuses access."))
		return
	if (!is_powered())
		to_chat(user, SPAN_WARNING("\The [src] is unpowered."))
		return
	if (health_dead())
		to_chat(usr, SPAN_NOTICE("\The [src] is completely destroyed."))
		return

	user.visible_message("[user] begins undoing the locks and latches on \the [src].")
	if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) && user.use_sanity_check(src))
		user.visible_message("[user] releases \the [contained] from \the [src]!")
		release()


/obj/machinery/stasis_cage/proc/release()
	if (contained)
		contained.dropInto(src)
		if (HAS_FLAGS(contained.status_flags, GODMODE) && !god)
			var/mob/living/SA = contained
			CLEAR_FLAGS(SA.status_flags, GODMODE)
		contained = null
		playsound(loc, 'sound/machines/airlock_heavy.ogg', 40)
		update_icon()
		update_use_power(POWER_USE_IDLE)


/obj/machinery/stasis_cage/proc/contain(mob/user, mob/thing)
	if(contained || broken)
		return
	if (!is_powered())
		to_chat(usr, SPAN_WARNING("\The [src] is unpowered."))
		return
	if (health_dead())
		to_chat(usr, SPAN_WARNING("\The [src] is completely destroyed."))
		return
	user.visible_message(
		"[user] has stuffed \the [thing] into \the [src].",
		"You have stuffed \the [thing] into \the [src]."
	)
	set_contained(thing)
	update_use_power(POWER_USE_ACTIVE)


/obj/machinery/stasis_cage/proc/set_contained(mob/contained)
	src.contained = contained
	contained.forceMove(src)
	update_icon()


/obj/machinery/stasis_cage/physical_attack_hand(mob/user)
	if (!panel_open)
		try_release(user)


/obj/machinery/stasis_cage/attack_robot(mob/user)
	if (Adjacent(user) && !panel_open)
		try_release(user)


/obj/machinery/stasis_cage/examine(mob/user)
	. = ..()
	if (contained)
		if (HAS_FLAGS(stat, MACHINE_STAT_NOSCREEN))
			to_chat(user, "\The [src] seems to be occupied.")
		else
			to_chat(user, "\The [contained] is kept inside.")
	if (broken)
		to_chat(user, SPAN_WARNING("\The [src]'s lid is broken. It probably can not be used."))
	if (cell)
		to_chat(user, "\The [src]'s power gauge shows [cell.percent()]% remaining.")


/obj/machinery/stasis_cage/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Pry thing out of cage
	if (isCrowbar(tool))
		if (panel_open)
			USE_FEEDBACK_FAILURE("\The [src]'s panel is open!")
			return TRUE
		if (contained)
			if (is_powered())
				USE_FEEDBACK_FAILURE("\The [src] is still powered shut.")
				return TRUE
			user.visible_message(
				SPAN_DANGER("\The [user] begins to pry open \the [src] with the crowbar!"),
				SPAN_DANGER("You being to pry open \the [src] with the crowbar.")
			)
			playsound(loc, 'sound/machines/airlock_creaking.ogg', 40)
			if (!do_after(user, 7 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
				return TRUE
			if (!prob(20 * (user.get_skill_value(SKILL_CONSTRUCTION))))
				USE_FEEDBACK_FAILURE("You fail to pry open \the [src]'s lid!")
				return TRUE
			if (!user.skill_check(SKILL_CONSTRUCTION, SKILL_TRAINED))
				user.visible_message(
					SPAN_DANGER("\The [user] jams open \the [src]'s lid, damaging it in the process!"),
					SPAN_DANGER("You successfully manage to jam open \the [src]'s lid, damaging it in the process.")
				)
				release()
				broken = TRUE
				update_icon()
				return TRUE
			user.visible_message(
				SPAN_DANGER("\The [user] jams open \the [src]'s lid!"),
				SPAN_DANGER("You successfully manage to jam open \the [src]'s lid.")
			)
			release()
			return TRUE

	// Coil - Repair cage
	if (isCoil(tool))
		if (health_dead())
			if (contained)
				USE_FEEDBACK_FAILURE("\The [src] must be emptied before repairs can be done!")
				return TRUE
			var/obj/item/stack/cable_coil/I = tool
			if(!I.can_use(10))
				USE_FEEDBACK_STACK_NOT_ENOUGH(I, 10, "to repair \the [src].")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("[user] begins to repair \the [src]'s electronics with \the [tool]."),
				SPAN_NOTICE("You being to repair \the [src]'s electronics with \the [tool].")
			)
			if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
				return TRUE
			if (!prob(20 * (user.get_skill_value(SKILL_DEVICES))))
				USE_FEEDBACK_FAILURE("You fail to successfully repair \the [src]'s electronics.")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("[user] repairs \the [src]'s containment with \the [tool]."),
				SPAN_NOTICE("You repair \the [src]'s containment with \the [tool].")
			)
			I.use(10)
			revive_health()
			broken = TRUE
			safety = TRUE
			update_icon()
			return TRUE

	// Wrench - Repair lid
	if (isWrench(tool))
		if (broken)
			if (health_dead())
				USE_FEEDBACK_FAILURE("You need to repair the rest of \the [src] first!")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] begins to clamp \the [src]'s lid back into position."),
				SPAN_NOTICE("You begin to clamp \the [src]'s lid back into position.")
			)
			playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
			if (!user.skill_check(SKILL_CONSTRUCTION, SKILL_BASIC))
				to_chat(user, SPAN_WARNING("You fail to repair \the [src]."))
				return TRUE
			if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] successfully repairs \the [src]'s lid!"),
				SPAN_NOTICE("You successfully repair \the [src]'s lid!")
			)
			broken = FALSE
			update_icon()
			return TRUE

	return ..()


/obj/machinery/stasis_cage/return_air() //Used to make stasis cage protect from vacuum.
	if (!is_powered())
		return
	if(airtank)
		return airtank
	..()


/obj/machinery/stasis_cage/RefreshParts()
	..()
	var/charge_multiplier = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 10)
	change_power_consumption(initial(active_power_usage) / charge_multiplier, POWER_USE_ACTIVE)


/obj/machinery/stasis_cage/Destroy()
	release()
	QDEL_NULL(airtank)
	QDEL_NULL(contained)
	if (cell)
		QDEL_NULL(cell)
	return ..()


/obj/machinery/stasis_cage/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if (health_dead())
		return
	if (inoperable())
		return
	if(contained)
		if(prob(30))
			visible_message(SPAN_DANGER("\The [src]'s lights flicker, unlocking the container!"))
			release()
			broken = TRUE
			update_icon()
			new /obj/sparks(get_turf(src))
			return
	visible_message(SPAN_DANGER("\The [src] sparks violently, damaging the lid!"))
	broken = TRUE
	new /obj/sparks(get_turf(src))

	if (cell)
		cell.emp_act(severity)

	update_icon()
	GLOB.empd_event.raise_event(src, severity)

/obj/machinery/stasis_cage/on_update_icon()
	ClearOverlays()
	if (health_dead())
		icon_state = "[initial(icon_state)]_dead"
	else if (is_powered())
		if (contained)
			if (broken)
				icon_state = "[initial(icon_state)]_broke"
			else
				icon_state = "[initial(icon_state)]_on"
		else
			if (broken)
				icon_state = "[initial(icon_state)]_broke"
			else
				icon_state = "[initial(icon_state)]_power"
	else
		if (broken)
			icon_state = "[initial(icon_state)]_dead"
		else
			icon_state = initial(icon_state)

	if (panel_open)
		AddOverlays("[initial(icon_state)]_panel")


/obj/machinery/stasis_cage/on_death()
	. = ..()
	visible_message(
		SPAN_DANGER("\The [src] lets out a painful whine, as its structure deforms!")
	)


/obj/machinery/stasis_cage/MouseDrop_T(mob/target, mob/user)
	if(!CanMouseDrop(target, user))
		return
	if (!isanimal(target) && safety)
		to_chat(user, SPAN_WARNING("\The [src] smartly refuses \the [target]."))
		return
	if (!allowed(user))
		to_chat(user, "\The [src] blinks, refusing access.")
		return
	if (!stat && !istype(target.buckled, /obj/energy_net))
		to_chat(user, "It's going to be difficult to convince \the [target] to move into \the [src] without capturing it in a net.")
		return
	if (HAS_FLAGS(target.status_flags, GODMODE))
		god = TRUE
	user.visible_message(
		"\The [user] begins stuffing \the [target] into \the [src].",
		"You begin stuffing \the [target] into \the [src]."
		)
	playsound(src, 'sound/items/shuttle_beacon_prepare.ogg', 100)
	Bumped(user)
	if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		var/obj/energy_net/EN = target.buckled
		qdel(EN)
		contain(user, target)


/datum/wires/stasis_cage
	holder_type = /obj/machinery/stasis_cage
	random = TRUE
	wire_count = 3
	window_y = 500
	descriptions = list(
		new /datum/wire_description(STASISCAGE_WIRE_SAFETY, "This wire is connected to the internal biometric sensors.", SKILL_EXPERIENCED),
		new /datum/wire_description(STASISCAGE_WIRE_RELEASE, "This wire is connected to the automated lid latches.", SKILL_TRAINED),
		new /datum/wire_description(STASISCAGE_WIRE_LOCK, "This wire is connected to the lid motors.", SKILL_TRAINED)
	)


/datum/wires/stasis_cage/CanUse(mob/living/L)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	if (stasis_cage.panel_open)
		return TRUE
	return FALSE


/datum/wires/stasis_cage/GetInteractWindow(mob/user)
	. = ..()
	. += "<ul>"
	. += "<li>The panel is powered.</li>"
	if (user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += "<li>The biometric safety sensors are [IsIndexCut(STASISCAGE_WIRE_SAFETY) ? "disconnected" : "connected"].</li>"
		. += "<li>The cage's emergency auto-release mechanism is [IsIndexCut(STASISCAGE_WIRE_RELEASE) ? "disabled" : "enabled"].</li>"
		. += "<li>The cage lid motors are [IsIndexCut(STASISCAGE_WIRE_LOCK) ? "overriden" : "nominal"].</li>"
	else
		. += "<li>There are lights and wires here, but you don't know how the wiring works.</li>"
	. += "</ul>"


/datum/wires/stasis_cage/UpdateCut(index, mended)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	switch (index)
		if (STASISCAGE_WIRE_SAFETY)
			if (!mended)
				stasis_cage.safety = FALSE
		if (STASISCAGE_WIRE_RELEASE)
			if (stasis_cage.contained && !mended)
				stasis_cage.release()
		if (STASISCAGE_WIRE_LOCK)
			if (!mended)
				playsound(stasis_cage.loc, 'sound/machines/BoltsDown.ogg', 60)
				holder.visible_message(
					SPAN_WARNING("The cage's lid bolts down destructively, denting itself!"),
					SPAN_NOTICE("You notice the cage lid override flag blink hastily.")
				)
				stasis_cage.broken = TRUE


/datum/wires/stasis_cage/UpdatePulsed(index)
	var/obj/machinery/stasis_cage/stasis_cage = holder
	switch (index)
		if (STASISCAGE_WIRE_SAFETY)
			if (stasis_cage.contained)
				if (prob(20) && usr.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
					holder.visible_message(
						SPAN_WARNING("The cage hastily flicks open its lid!"),
						SPAN_NOTICE("You notice the biometric sensor flag blink fervently.")
					)
					stasis_cage.release()
