var/global/list/empty_playable_ai_cores = list()

/obj/structure/AIcore
	density = TRUE
	anchored = FALSE
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/state = STATE_FRAME
	/// The AI core is only a frame
	var/const/STATE_FRAME = 0
	/// The AI core frame is secured to the ground
	var/const/STATE_ANCHORED = 1
	/// The AI core has a circuit inserted
	var/const/STATE_CIRCUIT = 2
	/// The AI core's circuit has been screwed into place
	var/const/STATE_CIRCUIT_SECURED = 3
	/// The AI core's circuit has been wired
	var/const/STATE_WIRED = 4
	/// The AI core has a brain installed
	var/const/STATE_BRAIN = 5
	/// The AI core has a glass panel installed
	var/const/STATE_GLASS = 6
	/// The AI core is completed
	var/const/STATE_COMPLETE = 7

	var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen
	var/obj/item/stock_parts/circuitboard/circuit = null
	var/obj/item/device/mmi/brain = null
	var/authorized

/obj/structure/AIcore/emag_act(remaining_charges, mob/user, emag_source)
	if(!authorized)
		to_chat(user, SPAN_WARNING("You swipe [emag_source] at [src] and jury rig it into the systems of [GLOB.using_map.full_name]!"))
		authorized = 1
		return 1
	. = ..()


/obj/structure/AIcore/get_construction_info()
	return list(
		"Use a <b>Wrench</b> to anchor the core to the floor.",
		"Add a <b>Circuit Board (AI Core)</b>.",
		"Use a <b>Screwdriver</b> to secure the circuit board in place.",
		"Use 5 lengths of <b>Cable</b> to wire the circuit board.",
		"(Optional) Add a <b>Man-Machine Interface</b> or a <b>Positronic Brain</b> that has an active player in it and is not dead.",
		"Use 2 sheets of <b>Reinforced Glass</b> to install a glass panel and complete the AI core.",
		"Use an <b>ID Card</b> with <b>AI Upload</b> access to authorize the AI core.",
		"Use a <b>Screwdriver</b> to finalize the AI core. <b>WARNING: The core cannot be deconstructed once you complete this step.</b>"
	)


/obj/structure/AIcore/get_deconstruction_info()
	return list(
		"Use a <b>Crowbar</b> to remove the glass panel. This yields 2 sheets of reinforced glass.",
		"If the core has a brain, use a <b>Crowbar</b> to remove it.",
		"Use <b>Wirecutters</b> to remove the wiring.",
		"Use a <b>Screwdriver</b> to unsecure the circuit board.",
		"Use a <b>Crowbar</b> to remove the circuit board.",
		"Use a <b>Wrench</b> to unanchor the core from the floor.",
		"Use a <b>Welding Tool</b> to finish deconstructing the frame. This uses 5 units of welding fuel and yields 4 sheets of plasteel."
	)


/obj/structure/AIcore/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_ID_CARD] = "<p>If the ID has access, toggles the core's authorization.</p>"
	.[CODEX_INTERACTION_WRENCH] += "<p>The core can only be anchored/deanchored in the initial construction, or final deconstruction steps, before a circuit board is installed.</p>"


/obj/structure/AIcore/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cable Coil - Wire circuit board (STATE_CIRCUIT -> STATE_WIRED)
	if (isCoil(tool))
		if (state < STATE_CIRCUIT_SECURED)
			to_chat(user, SPAN_WARNING("\The [src] needs a circuit board installed before you can wire it."))
			return TRUE
		if (state > STATE_CIRCUIT_SECURED)
			to_chat(user, SPAN_WARNING("\The [src] is already wired."))
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.can_use(5))
			to_chat(user, SPAN_WARNING("You need at least 5 [cable.plural_name] of \the [cable] to wire \the [src]."))
			return TRUE
		if (!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!cable.use(5))
			to_chat(user, SPAN_WARNING("You need at least 5 [cable.plural_name] of \the [cable] to wire \the [src]."))
			return TRUE
		state = STATE_WIRED
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \the [src] with \a [tool]."),
			SPAN_NOTICE("You wire \the [src] with \the [tool].")
		)
		update_icon()
		return TRUE

	// Circuit Board (AI Core) - Installs circuit board (STATE_ANCHORED -> STATE_CIRCUIT)
	if (istype(tool, /obj/item/stock_parts/circuitboard/aicore))
		if (state < STATE_ANCHORED)
			to_chat(user, SPAN_WARNING("\The [src] needs to be anchored before you can install the circuit."))
			return TRUE
		if (state > STATE_ANCHORED)
			to_chat(user, SPAN_WARNING("\The [src] already has a circuit installed."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		state = STATE_CIRCUIT
		CLEAR_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE)
		circuit = tool
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		update_icon()
		return TRUE

	// Crowbar
	// - Remove circuit board (STATE_CIRCUIT -> STATE_ANCHORED)
	// - Remove brain (STATE_BRAIN -> STATE_WIRED)
	// - Remove glass panel (STATE_GLASS -> STATE_BRAIN || STATE_WIRED)
	if (isCrowbar(tool))
		if (state < STATE_CIRCUIT)
			to_chat(user, SPAN_WARNING("\The [src] has no circuit board to remove."))
			return TRUE
		if (state > STATE_CIRCUIT && state < STATE_BRAIN)
			to_chat(user, SPAN_WARNING("You need to unscrew \the [src]'s circuit board before you can remove it."))
			return TRUE
		switch (state)
			if (STATE_CIRCUIT)
				state = STATE_ANCHORED
				SET_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE)
				circuit.dropInto(loc)
				circuit = null
				playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] removes \the [src]'s circuit board with \a [tool]."),
					SPAN_NOTICE("You remove \the [src]'s circuit board with \the [tool].")
				)
				update_icon()
			if (STATE_BRAIN)
				state = STATE_WIRED
				playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] removes \the [brain] from \the [src] with \a [tool]."),
					SPAN_NOTICE("You remove \the [brain] from \the [src] with \the [tool].")
				)
				brain.dropInto(loc)
				brain = null
				update_icon()
			if (STATE_GLASS)
				state = brain ? STATE_BRAIN : STATE_WIRED
				playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
				new /obj/item/stack/material/glass/reinforced(loc, 2)
				user.visible_message(
					SPAN_NOTICE("\The [user] removes \the [src]'s glass panel with \a [tool]."),
					SPAN_NOTICE("You remove \the [src]'s glass panel with \the [tool].")
				)
				update_icon()
		return TRUE

	// ID Card - Authorize the core to access the station
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_NAME(id, tool)
		if (!(access_ai_upload in id.GetAccess()))
			to_chat(user, SPAN_WARNING("\The [src] refuses [id_name]."))
			return TRUE
		authorized = !authorized
		user.visible_message(
			SPAN_NOTICE("\The [user] sets \the [src]'s authorization with \a [tool]."),
			SPAN_NOTICE("You [authorized ? "authorize" : "deauthorize"] \the [src]'s connection to [GLOB.using_map.full_name] with [id_name].")
		)
		return TRUE

	// Law Boards - Upload laws directly to the AI
	if (istype(tool, /obj/item/aiModule))
		if (state > STATE_BRAIN)
			to_chat(user, SPAN_WARNING("\The [src]'s glass panel blocks access."))
			return TRUE
		if (state < STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src] needs a wired circuit board to upload laws to."))
			return TRUE
		var/obj/item/aiModule/ai_module = tool
		laws = ai_module.laws
		log_and_message_admins(append_admin_tools("\The [user] ([user.key]) uploaded \a [tool] to \a [src].", user, get_turf(src)))
		user.visible_message(
			SPAN_NOTICE("\The [user] scans \a [tool] in \the [src]'s law upload panel."),
			SPAN_NOTICE("You scans \the [tool] in \the [src]'s law upload panel, changing the core's lawset.")
		)
		return TRUE

	// Material Stack (Glass) - Install glass panel (STATE_WIRED || STATE_BRAIN -> STATE_GLASS)
	if (istype(tool, /obj/item/stack/material))
		var/obj/item/stack/material/stack = tool
		if (stack.get_material_name() != MATERIAL_GLASS)
			return ..()
		if (state < STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src] must be wired before you can install a glass panel."))
			return TRUE
		if (state > STATE_BRAIN)
			to_chat(user, SPAN_WARNING("\The [src] already has a glass panel installed."))
			return TRUE
		if (!stack.reinf_material)
			to_chat(user, SPAN_WARNING("\The [tool] needs to be reinforced before you can install it in \the [src]."))
			return TRUE
		if (!stack.can_use(2))
			to_chat(user, SPAN_WARNING("You need at least 2 [stack.plural_name] of [stack.get_material_display_name()] to install a glass panel in \the [src]."))
			return TRUE
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts installing a glass panel in \the [src] with \a [tool]."),
			SPAN_NOTICE("You start installing a glass panel in \the [src] with \the [tool].")
		)
		if (!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!stack.use(2))
			to_chat(user, SPAN_WARNING("You need at least 2 [stack.plural_name] of [stack.get_material_display_name()] to install a glass panel in \the [src]."))
			return TRUE
		state = STATE_GLASS
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs a glass panel in \the [src] with \a [tool]."),
			SPAN_NOTICE("You install a glass panel in \the [src] with \the [tool].")
		)
		update_icon()
		return TRUE

	// Man-Machine Interface, Positronic Brain - Install brain
	if (istype(tool, /obj/item/device/mmi) || istype(tool, /obj/item/organ/internal/posibrain))
		if (state < STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src] needs to be wired before you can install \the [tool]."))
			return TRUE
		if (state == STATE_BRAIN)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [brain] installed."))
			return TRUE
		if (state > STATE_BRAIN)
			to_chat(user, SPAN_WARNING("You need to remove \the [src]'s glass panel before you can install \the [tool]."))
			return TRUE
		var/mob/living/carbon/brain/_brain
		if (istype(tool, /obj/item/device/mmi))
			var/obj/item/device/mmi/mmi = tool
			_brain = mmi.brainmob
		else if (istype(tool, /obj/item/organ/internal/posibrain))
			var/obj/item/organ/internal/posibrain/posibrain = tool
			_brain = posibrain.brainmob
		if (!_brain)
			to_chat(user, SPAN_WARNING("\The [_brain] is empty and cannot be installed into \the [src]."))
			return TRUE
		if (_brain.stat == DEAD)
			to_chat(user, SPAN_WARNING("\The [_brain] is dead and cannot be installed into \the [src]."))
			return TRUE
		if (jobban_isbanned(brain, "AI"))
			to_chat(user, SPAN_WARNING("\The [_brain] cannot be installed into \the [src]."))
			to_chat(_brain, SPAN_DANGER("You are job banned from AI and cannot be installed into this core."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		if (_brain.mind)
			clear_antag_roles(_brain.mind, TRUE)
		brain = _brain
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		update_icon()
		return TRUE

	// Screwdriver
	// - Screw circuit board into place (STATE_CIRCUIT -> STATE_CIRCUIT_SECURED)
	// - Complete AI core (STATE_GLASS -> NEW AI CORE)
	if (isScrewdriver(tool))
		if (state < STATE_CIRCUIT)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a circuit board installed."))
			return TRUE
		if (state > STATE_CIRCUIT_SECURED && state < STATE_GLASS)
			to_chat(user, SPAN_WARNING("You need to remove \the [src]'s wiring before you can detach the circuitboard."))
			return TRUE
		if (state > STATE_GLASS)
			to_chat(user, SPAN_WARNING("\The [src] is already complete."))
			return TRUE
		switch (state)
			if (STATE_CIRCUIT, STATE_CIRCUIT_SECURED)
				if (state == STATE_CIRCUIT)
					state = STATE_CIRCUIT_SECURED
				else
					state = STATE_CIRCUIT
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] [state == STATE_CIRCUIT ? "unsecures" : "secures"] \the [src]'s circuit board with \a [tool]."),
					SPAN_NOTICE("You [state == STATE_CIRCUIT ? "unsecure" : "secure"] \the [src]'s circuit board with \a [tool].")
				)
				update_icon()
			if (STATE_GLASS)
				if (!authorized)
					to_chat(user, SPAN_WARNING("\The [src] has not been authorized to connect to the systems of [GLOB.using_map.full_name] and cannot be completed."))
					return TRUE
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] connects \the [src]'s monitor with \a [tool], completing it."),
					SPAN_NOTICE("You connect \the [src]'s monitor with \the [tool], completing it."),
				)
				if (!brain)
					var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoining AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
					var/obj/structure/AIcore/deactivated/aicore = new(loc)
					if (open_for_latejoin)
						empty_playable_ai_cores += aicore
				else
					var/mob/living/silicon/ai/ai = new /mob/living/silicon/ai ( loc, laws, brain )
					if (ai) //if there's no brain, the mob is deleted and a structure/AIcore is created
						ai.on_mob_init()
						ai.rename_self("ai", 1)
				qdel(src)
		return TRUE

	// Welder - Deconstruct frame (STATE_FRAME -> QDEL)
	if (isWelder(tool))
		if (state != STATE_FRAME)
			to_chat(user, SPAN_WARNING("\The [src] isn't ready to be deconstructed. See the Codex for deconstruction steps."))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(5, user, "to deconstruct \the [src]"))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts deconstructing \the [src] with \a [tool]."),
			SPAN_NOTICE("You start deconstructing \the [src] with \the [tool].")
		)
		if (!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool) || !welder.can_use(5, user, "to deconstruct \the [src]"))
			return TRUE
		welder.remove_fuel(5, user)
		new /obj/item/stack/material/plasteel(loc, 4)
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] deconstructs \the [src] with \a [tool]."),
			SPAN_NOTICE("You deconstruct \the [src] with \the [tool].")
		)
		qdel(src)
		return TRUE

	// Wirecutters - Remove wiring (STATE_WIRED -> STATE_CIRCUIT_SECURED)
	if (isWirecutter(tool))
		if (state < STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src] has no wiring to remove."))
			return TRUE
		if (state > STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src]'s brain needs to be removed before you can access the wiring."))
			return TRUE
		state = STATE_CIRCUIT_SECURED
		new /obj/item/stack/cable_coil(loc, 5)
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wiring with \the [tool].")
		)
		update_icon()
		return TRUE

	return ..()


/obj/structure/AIcore/wrench_floor_bolts(mob/user, delay)
	if (state > STATE_ANCHORED)
		to_chat(user, SPAN_DEBUG("\The [src] is in an invalid state and cannot be anchored/deanchored. This is a bug."))
		log_debug(append_admin_tools("\A [src] ([type]) had an invalid pair of state ([state]) and object flags ([obj_flags]) and someone tried to wrench it.", user, get_turf(src)))
		CLEAR_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE)
		return
	..()
	if (anchored)
		state = STATE_ANCHORED
	else
		state = STATE_FRAME


/obj/structure/AIcore/on_update_icon()
	switch (state)
		if (STATE_FRAME, STATE_ANCHORED)
			icon_state = "0"
		if (STATE_CIRCUIT)
			icon_state = "1"
		if (STATE_CIRCUIT_SECURED)
			icon_state = "2"
		if (STATE_WIRED)
			icon_state = "3"
		if (STATE_BRAIN)
			icon_state = "3b"
		if (STATE_GLASS)
			icon_state = "4"
		if (STATE_COMPLETE)
			icon_state = "ai-empty"


/obj/structure/AIcore/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	state = STATE_COMPLETE

/obj/structure/AIcore/deactivated/Destroy()
	empty_playable_ai_cores -= src
	. = ..()

/obj/structure/AIcore/deactivated/proc/load_ai(mob/living/silicon/ai/transfer, obj/item/aicard/card, mob/user)

	if(!istype(transfer) || locate(/mob/living/silicon/ai) in src)
		return

	transfer.aiRestorePowerRoutine = 0
	transfer.control_disabled = 0
	transfer.ai_radio.disabledAi = 0
	transfer.dropInto(src)
	transfer.create_eyeobj()
	transfer.cancel_camera()
	to_chat(user, "[SPAN_NOTICE("Transfer successful:")] [transfer.name] ([rand(1000,9999)].exe) downloaded to host terminal. Local copy wiped.")
	to_chat(transfer, "You have been uploaded to a stationary terminal. Remote device connection restored.")

	if(card)
		card.clear()

	qdel(src)

/obj/structure/AIcore/deactivated/proc/check_malf(mob/living/silicon/ai/ai)
	if(!ai) return
	for (var/datum/mind/malfai in GLOB.malf.current_antagonists)
		if (ai.mind == malfai)
			return 1


/obj/structure/AIcore/deactivated/get_deconstruction_info()
	return list() // You can't deconstruct once you reach this point.


/obj/structure/AIcore/deactivated/get_interactions_info()
	. = ..()
	.["InteliCard"] = "<p>If the card has an AI in it, uploads the AI into the core.</p>"


/obj/structure/AIcore/deactivated/use_tool(obj/item/tool, mob/user, list/click_params)
	// InteliCard - Load AI into core
	if (istype(tool, /obj/item/aicard))
		var/obj/item/aicard/aicard = tool
		var/mob/living/silicon/ai/ai = locate() in aicard
		if (!ai)
			to_chat(user, SPAN_WARNING("\The [tool] does not have an AI to load."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \a [tool] into \the [src]."),
			SPAN_NOTICE("You load \the [tool] into \the [src].")
		)
		load_ai(ai, aicard, user)
		return TRUE

	return ..()


/client/proc/empty_ai_core_toggle_latejoin()
	set name = "Toggle AI Core Latejoin"
	set category = "Admin"

	var/list/cores = list()
	for(var/obj/structure/AIcore/deactivated/D in world)
		cores["[D] ([D.loc.loc])"] = D

	var/id = input("Which core?", "Toggle AI Core Latejoin", null) as null|anything in cores
	if(!id) return

	var/obj/structure/AIcore/deactivated/D = cores[id]
	if(!D) return

	if(D in empty_playable_ai_cores)
		empty_playable_ai_cores -= D
		to_chat(src, "\The [id] is now [SPAN_COLOR("#ff0000", "not available")] for latejoining AIs.")
	else
		empty_playable_ai_cores += D
		to_chat(src, "\The [id] is now [SPAN_COLOR("#008000", "available")] for latejoining AIs.")
