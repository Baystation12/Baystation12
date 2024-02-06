/*
	Overview:
	Used to create objects that need a per step proc call.  Default definition of 'Initialize()' stores a reference to src machine in global 'machines list'.  Default definition of 'Destroy' removes reference to src machine in global 'machines list'.

	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	icon = 'icons/obj/machines/wooden_tv.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = STRUCTURE_LAYER // Layer under items
	init_flags = INIT_MACHINERY_START_PROCESSING
	throw_speed = 1
	throw_range = 5

	health_resistances = DAMAGE_RESIST_ELECTRICAL

	/// Boolean. Whether or not the machine has been emagged.
	var/emagged = FALSE
	/// Boolean. Whether or not the machine has been upgrade by a malfunctioning AI.
	var/malf_upgraded = FALSE
	/// Wire datum, if any. If you place a type path, it will be autoinitialized.
	var/datum/wires/wires
	/// One of `POWER_USE_*`. The power usage state of the machine. Use `update_use_power()` to modify this during runtime.
	var/use_power = POWER_USE_IDLE
	/// Power usage for idle machinery. Used if `use_power` is set to `POWER_USE_IDLE`. Use `change_power_consumption()` to modify this during runtime.
	var/idle_power_usage = 0
	/// Power usage for active machinery. Used if `use_power` is set to `POWER_USE_ACTIVE`. Use `change_power_consumption()` to modify this during runtime.
	var/active_power_usage = 0
	/// Power channel the machine draws from in APCs. `EQUIP`, `ENVIRON`, or `LIGHT`. Use `update_power_channel()` to modify this during runtime.
	var/power_channel = EQUIP
	/// Helps with bookkeeping when initializing atoms. Don't modify.
	var/power_init_complete = FALSE
	/// List of component instances. Expected type: `/obj/item/stock_parts.`
	var/list/component_parts
	/// LAZYLIST of component paths which have delayed init. Indeces = number of components.
	var/list/uncreated_component_parts = list(/obj/item/stock_parts/power/apc)
	/// List of componant paths and the maximum number of that specific path that can be inserted into the machine. `null` - no max. `list(type part = number max)`.
	var/list/maximum_component_parts = list(/obj/item/stock_parts = 10)
	/// Numeric unique ID number. Set to the value of `gl_uid++` when used.
	var/uid
	/// Boolean. Whether or not the maintenance panel is open.
	var/panel_open = FALSE
	/// Numeric unique ID number tracker. Used for ensuring `uid` is unique.
	var/static/gl_uid = 1
	/// Boolean. Can the machine be interacted with while de-powered.
	var/interact_offline = FALSE
	/// Sound played on succesful interface use by a carbon lifeform.
	var/clicksound
	/// Sound played on succesful interface use.
	var/clickvol = 40
	/// Value to compare with `world.time` for whether to play `clicksound` according to `CLICKSOUND_INTERVAL`.
	var/next_clicksound = 0
	/// The skill used for skill checks for this machine (mostly so subtypes can use different skills).
	var/core_skill = SKILL_DEVICES
	/// Machines often do all operations on `Process()`. This caches the user's skill while the operations are running.
	var/operator_skill
	/// For mapped buildable types, set this to be the base type actually buildable.
	var/base_type
	/// This generic variable is to be used by mappers to give related machines a string key. In principle used by radio stock parts.
	var/id_tag
	/// What is created when the machine is dismantled.
	var/frame_type = /obj/machinery/constructable_frame/machine_frame/deconstruct
	/// Whether or not the machine is allowed to be dismantled/modified. Used for snowflake consoles that would break permanently if dismantled. Also prevents damage, since the machine would be irreparable in this state. Has to be defined here because machinery datums.
	var/can_use_tools = TRUE
	/// Component parts queued for processing by the machine. Expected type: `/obj/item/stock_parts`
	var/list/processing_parts
	/// Bitflag. What is being processed. One of `MACHINERY_PROCESS_*`.
	var/processing_flags
	/// One of the `STATUS_*` flags. If set, will force the given status flag if a silicon tries to access the machine.
	var/silicon_restriction = null

	/// The human-readable name of this machine, shown when examining circuit boards.
	var/machine_name = null
	/// A simple description of what this machine does, shown on examine for circuit boards.
	var/machine_desc = null

/obj/machinery/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(d)
		set_dir(d)
	if (init_flags & INIT_MACHINERY_START_PROCESSING)
		START_PROCESSING_MACHINE(src, INIT_MACHINERY_START_PROCESSING)
	SSmachines.machinery += src // All machines should remain in this list, always.
	if(ispath(wires))
		wires = new wires(src)
	populate_parts(populate_parts)
	RefreshParts()
	power_change()

/obj/machinery/post_health_change(health_mod, prior_health, damage_type)
	if (health_mod < 0 && !health_dead())
		var/initial_damage_percentage = Percent(get_max_health() - prior_health, get_max_health(), 0)
		var/damage_percentage = get_damage_percentage()
		if (damage_percentage >= 75 && initial_damage_percentage < 75)
			visible_message("\The [src] looks like it's about to break!" )
		else if (damage_percentage >= 50 && initial_damage_percentage < 50)
			visible_message("\The [src] looks seriously damaged!" )
		else if (damage_percentage >= 25 && initial_damage_percentage < 25)
			visible_message("\The [src] shows signs of damage!" )

/obj/machinery/Destroy()
	if(istype(wires))
		QDEL_NULL(wires)
	SSmachines.machinery -= src
	QDEL_NULL_LIST(component_parts) // Further handling is done via destroyed events.
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)
	. = ..()

/obj/machinery/on_death()
	..()
	set_broken(TRUE, MACHINE_BROKEN_HEALTH)
	queue_icon_update()

/obj/machinery/on_revive()
	..()
	set_broken(FALSE, MACHINE_BROKEN_HEALTH)
	queue_icon_update()

/obj/machinery/Process()
	return PROCESS_KILL // Only process if you need to.

/obj/machinery/emp_act(severity)
	if(use_power && operable())
		use_power_oneoff(7500/severity)

		var/obj/overlay/pulse2 = new /obj/overlay(loc)
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.SetName("emp sparks")
		pulse2.anchored = TRUE
		pulse2.set_dir(pick(GLOB.cardinal))

		QDEL_IN(pulse2, 1 SECOND)

		if (prob(100 / severity) && istype(wires))
			if (prob(20))
				wires.RandomCut()
				visible_message(SPAN_DANGER("A shower of sparks sprays out of \the [src]'s wiring panel!"))
				sparks(3, 0, get_turf(src))
			else
				wires.RandomPulse()
				visible_message(SPAN_WARNING("Something sparks inside \the [src]'s wiring panel!"))
				new /obj/sparks(get_turf(src))

		..()

/obj/machinery/ex_act(severity)
	..()
	if (get_max_health())
		return
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
		if(EX_ACT_LIGHT)
			if (prob(25))
				qdel(src)

/obj/machinery/CanUseTopic(mob/user)
	if(MACHINE_IS_BROKEN(src))
		return STATUS_CLOSE

	if(!interact_offline && (!is_powered()))
		return STATUS_CLOSE

	if(user.direct_machine_interface(src))
		var/mob/living/silicon/silicon = user
		if (silicon_restriction && ismachinerestricted(silicon))
			if (silicon_restriction == STATUS_CLOSE)
				to_chat(user, SPAN_WARNING("Remote AI systems detected. Firewall protections forbid remote AI access."))
			return silicon_restriction

		return ..()

	if(GET_FLAGS(stat, MACHINE_STAT_NOSCREEN))
		return STATUS_CLOSE

	if(GET_FLAGS(stat, MACHINE_STAT_NOINPUT))
		return min(..(), STATUS_UPDATE)
	return ..()

/// Whether or not the mob can directly interact with the machine regardless of screen and input status. Checked in `CanUseTopic()`.
/mob/proc/direct_machine_interface(obj/machinery/machine)
	return FALSE

/mob/living/silicon/direct_machine_interface(obj/machinery/machine)
	return TRUE

/mob/observer/ghost/direct_machine_interface(obj/machinery/machine)
	return TRUE

/obj/machinery/CanUseTopicPhysical(mob/user)
	if(MACHINE_IS_BROKEN(src))
		return STATUS_CLOSE

	return GLOB.physical_state.can_use_topic(nano_host(), user)

/obj/machinery/CouldUseTopic(mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(mob/user)
	user.unset_machine()

/obj/machinery/Topic(href, href_list, datum/topic_state/state)
	if(href_list["mechanics_text"] && construct_state) // This is an OOC examine thing handled via Topic; specifically bypass all checks, but do nothing other than message to chat.
		var/list/info = construct_state.mechanics_info()
		if(info)
			to_chat(usr, jointext(info, "<br>"))
			return TOPIC_HANDLED

	. = ..()
	if(. == TOPIC_REFRESH)
		updateUsrDialog() // Update legacy UIs to the extent possible.

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user)
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)

/obj/machinery/attack_robot(mob/user)
	if((. = attack_hand(user))) // This will make a physical proximity check, and allow them to deal with components and such.
		return
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user) // This may still work even if the physical checks fail.

// After a recent rework this should mostly be safe.
/obj/machinery/attack_ghost(mob/user)
	interface_interact(user)

// If you don't call parent in this proc, you must make all appropriate checks yourself.
// If you do, you must respect the return value.
/obj/machinery/attack_hand(mob/user)
	if((. = ..())) // Buckling, climbers; unlikely to return true unless on harm intent and damage is dealt.
		return
	if(!CanPhysicallyInteract(user))
		return FALSE // The interactions below all assume physical access to the machine. If this is not the case, we let the machine take further action.
	if(!user.IsAdvancedToolUser())
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 80)
			visible_message(SPAN_WARNING("\The [H] stares cluelessly at \the [src]."))
			return TRUE
	if((. = component_attack_hand(user)))
		return TRUE
	if(wires && (. = wires.Interact(user)))
		return TRUE
	if((. = physical_attack_hand(user)))
		return TRUE
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)


/obj/machinery/post_anchor_change()
	update_use_power(anchored)
	power_change()
	..()

/**
 * Called by machines that can hold a mob (sleeper, suit cycler, etc.), checking if mob can be moved before doing so.
 * Call parent first if you want to add new checks specific for each machine, this proc handles the common stuff.
 * Returns TRUE if mob can be moved into a machine, FALSE if it cannot.
 */
/obj/machinery/proc/user_can_move_target_inside(mob/target, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if (!user.use_sanity_check(src, target))
		return FALSE
	if (!istype(target))
		to_chat(user, SPAN_WARNING("\The [src] cannot handle such a lifeform!"))
		return FALSE
	if (user.incapacitated() || !istype(user))
		return FALSE
	if (!target.simulated)
		return FALSE
	if (inoperable())
		to_chat(user, SPAN_WARNING("\The [src] is not functioning."))
		return FALSE
	if (target.abiotic())
		to_chat(user, SPAN_WARNING("[user == target ? "You" : "[target]"] can't enter \the [src] while wearing abiotic items."))
		return FALSE
	if (target.buckled)
		to_chat(user, SPAN_WARNING("Unbuckle [user == target ? "yourself" : "\the [target]"] before attempting to [user == target ? "enter \the [src]" : "move them"]."))
		return FALSE
	if (panel_open)
		to_chat(user, SPAN_WARNING("Close the maintenance panel before attempting to place [user == target ? "yourself" : "\the [target]"] in \the [src]."))
		return FALSE
	for (var/mob/living/carbon/slime/slime in range(0,target))
		if (slime.Victim == target)
			to_chat(user, "[target] will not fit into \the [src] because they have a slime latched onto them.")
			return FALSE
	for (var/obj/item/grab/grab in target.grabbed_by)
		if (grab.assailant == user || grab.assailant == target)
			continue
		to_chat(user, SPAN_WARNING("\The [target] is being grabbed by [grab.assailant] and can't be placed in \the [src]."))
		return FALSE
	return TRUE

/**
 * If you want to have interface interactions handled for you conveniently, use this.
 * Return `TRUE` for handled.
 * If you perform direct interactions in here, you are responsible for ensuring that full interactivity checks have been made (i.e `CanInteract()`).
 * The checks leading in to here only guarantee that the user should be able to view a UI.
 */
/obj/machinery/proc/interface_interact(user)
	return FALSE

/**
 * If you want a physical interaction which happens after all relevant checks but preempts the UI interactions, do it here.
 * Return `TRUE` for handled.
 */
/obj/machinery/proc/physical_attack_hand(user)
	return FALSE

/// Refreshes the machines parts-related `stat` flags, and calls `on_refresh()` on each component.
/obj/machinery/proc/RefreshParts()
	set_stat(MACHINE_STAT_NOINPUT, TRUE)
	set_stat(MACHINE_STAT_NOSCREEN, TRUE)
	for(var/thing in component_parts)
		var/obj/item/stock_parts/part = thing
		part.on_refresh(src)
	var/list/missing = missing_parts()
	set_broken(!!missing, MACHINE_BROKEN_NO_PARTS)

/// Displays a message for mobs in range.
/obj/machinery/proc/state(msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("[icon2html(src, O)] " + SPAN_NOTICE(msg), AUDIBLE_MESSAGE)

/// Displays a ping message and sound effect.
/obj/machinery/proc/ping(text)
	if (!text)
		text = "\The [src] pings."

	state(text)
	playsound(loc, 'sound/machines/ping.ogg', 50, 0)

/// Electrocutes the mob `user` based on probability `prb`, if the machine is in a state capable of doing so. Returns `TRUE` if the user was shocked.
/obj/machinery/proc/shock(mob/user, prb)
	if (!user)
		return FALSE
	if(inoperable())
		return FALSE
	if(!prob(prb))
		return FALSE
	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
			var/obj/machinery/power/terminal/terminal = temp_apc && temp_apc.terminal()

			if(terminal && terminal.powernet)
				terminal.powernet.trigger_warning()
		if(user.stunned)
			return TRUE
	return FALSE

/// Deconstructs the machine into its base frame and ejects all of its components. Returns boolean.
/obj/machinery/proc/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	var/obj/item/stock_parts/circuitboard/circuit = get_component_of_type(/obj/item/stock_parts/circuitboard)
	if(circuit)
		circuit.deconstruct(src)
	if(ispath(frame_type, /obj/item/pipe))
		new frame_type(get_turf(src), src)
	else
		new frame_type(get_turf(src), dir)
	for(var/I in component_parts)
		uninstall_component(I, refresh_parts = FALSE)
	while(LAZYLEN(uncreated_component_parts))
		var/path = uncreated_component_parts[1]
		uninstall_component(path, refresh_parts = FALSE)
	for(var/obj/O in src)
		O.dropInto(loc)

	qdel(src)
	return TRUE

/obj/machinery/InsertedContents()
	return (contents - component_parts)

/// Applies visual overlays relating to viewing through a specific datum, i.e. cameras.
/datum/proc/apply_visual(mob/M)
	return

/// Removes visual overlays relating to viewing through a specific datum, i.e. cameras.
/datum/proc/remove_visual(mob/M)
	return

/// Handles updgrading the machine for a malfunctioning AI. Return `TRUE` if the machine was successfully upgraded.
/obj/machinery/proc/malf_upgrade(mob/living/silicon/ai/user)
	return FALSE

/obj/machinery/CouldUseTopic(mob/user)
	..()
	if(clicksound && world.time > next_clicksound && istype(user, /mob/living/carbon))
		next_clicksound = world.time + CLICKSOUND_INTERVAL
		playsound(src, clicksound, clickvol)

/// Displays all components in the machine to the user.
/obj/machinery/proc/display_parts(mob/user)
	to_chat(user, SPAN_NOTICE("Following parts detected in the machine:"))
	for(var/obj/item/C in component_parts)
		to_chat(user, SPAN_NOTICE("	[C.name]"))
	for(var/path in uncreated_component_parts)
		var/obj/item/thing = path
		to_chat(user, SPAN_NOTICE("	[initial(thing.name)] ([uncreated_component_parts[path] || 1])"))

/obj/machinery/examine(mob/user)
	. = ..()
	if (panel_open)
		to_chat(user, SPAN_NOTICE("The service panel is open."))
	if(component_parts && hasHUD(user, HUD_SCIENCE))
		display_parts(user)
	if(GET_FLAGS(stat, MACHINE_STAT_NOSCREEN))
		to_chat(user, SPAN_WARNING("It is missing a screen, making it hard to interact with."))
	else if(GET_FLAGS(stat, MACHINE_STAT_NOINPUT))
		to_chat(user, SPAN_WARNING("It is missing any input device."))
	else if((!is_powered()) && !interact_offline)
		to_chat(user, SPAN_WARNING("It is not receiving power."))
	if(construct_state && construct_state.mechanics_info())
		to_chat(user, SPAN_NOTICE("It can be <a href='?src=\ref[src];mechanics_text=1'>manipulated</a> using tools."))
	var/list/missing = missing_parts()
	if(missing)
		var/list/parts = list()
		for(var/type in missing)
			var/obj/item/fake_thing = type
			parts += "[num2text(missing[type])] [initial(fake_thing.name)]"
		to_chat(user, SPAN_WARNING("\The [src] is missing [english_list(parts)], rendering it inoperable."))
	if (user.skill_check(SKILL_CONSTRUCTION, SKILL_BASIC) || isobserver(user))
		to_chat(user, SPAN_NOTICE(machine_desc))

/obj/machinery/get_mechanics_info()
	. = ..()
	if (maximum_component_parts)
		var/component_parts_list
		for (var/atom/item as anything in maximum_component_parts)
			var/count = maximum_component_parts[item]
			if (isnull(count))
				component_parts_list += "<li>Infinite [initial(item.name)]</li>"
			else
				component_parts_list += "<li>[count] [initial(item.name)]\s</li>"
		. += {"
			<p>It can hold the following component types:</p>
			<ul>
				[component_parts_list]
			</ul>
		"}

	if (silicon_restriction)
		switch (silicon_restriction)
			if (STATUS_UPDATE)
				. += "<p>Silicons are blocked from controlling it.</p>"
			if (STATUS_DISABLED, STATUS_CLOSE)
				. += "<p>Silicons are blocked from viewing or controlling it.</p>"

	var/power_channel_name
	switch (initial(power_channel))
		if (EQUIP)
			power_channel_name = "Equipment"
		if (LIGHT)
			power_channel_name = "Lighting"
		if (ENVIRON)
			power_channel_name = "Environment"
		if (LOCAL)
			power_channel_name = "Local"
	. += "<p>By default, it draws power from the [power_channel_name] channel.</p>"

	if (idle_power_usage && active_power_usage)
		. += "<p>It draws [idle_power_usage] watts while idle, and [active_power_usage] watts while active."
	else if (idle_power_usage)
		. += "<p>It draws [idle_power_usage] watts while idle.</p>"
	else if (active_power_usage)
		. += "<p>It draws [active_power_usage] watts while active.</p>"

	if (core_skill)
		var/singleton/hierarchy/skill/core_skill_singleton = core_skill
		. += "<p>It utilizes the [initial(core_skill_singleton.name)] skill.</p>"

	var/wire_mechanics = wires?.get_mechanics_info()
	if (wire_mechanics)
		. += "<hr><h5>Wiring</h5>[wire_mechanics]"

/obj/machinery/get_interactions_info()
	. = ..()
	var/wire_interactions = wires?.get_interactions_info()
	if (wire_interactions)
		for (var/key in wire_interactions)
			.["[key]"] += "[wire_interactions[key]]"

// This is really pretty crap and should be overridden for specific machines.
/obj/machinery/water_act(depth)
	..()
	if(operable() && !waterproof && (depth > FLUID_DEEP))
		ex_act(EX_ACT_LIGHT)

/obj/machinery/Move()
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()

/obj/machinery/get_cell()
	var/obj/item/stock_parts/power/battery/battery = get_component_of_type(/obj/item/stock_parts/power/battery)
	if(battery)
		return battery.get_cell()

/// Called by `/mob/Login()` if the mob has an associated `machine`.
/obj/machinery/proc/on_user_login(mob/M)
	return
