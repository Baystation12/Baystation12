var/global/list/empty_playable_ai_cores = list()

/obj/structure/AIcore
	density = TRUE
	anchored = FALSE
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"

	/// State 1 - AI core frame is built.
	var/const/STATE_FRAME = 1
	/// State 2 - Circuitboard is installed
	var/const/STATE_CIRCUIT = 2
	/// State 3 - Circuitboard is installed and secured
	var/const/STATE_CIRCUIT_SECURE = 3
	/// State 4 - Frame is wired
	var/const/STATE_WIRED = 4
	/// State 5 - Brain is installed
	var/const/STATE_BRAIN = 5
	/// State 6 - Glass panel is installed
	var/const/STATE_PANEL = 6
	var/state = STATE_FRAME

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


/obj/structure/AIcore/on_update_icon()
	switch (state)
		if (STATE_FRAME)
			icon_state = "0"
		if (STATE_CIRCUIT)
			icon_state = "1"
		if (STATE_CIRCUIT_SECURE)
			icon_state = "2"
		if (STATE_WIRED)
			icon_state = "3"
		if (STATE_BRAIN)
			icon_state = "3b"
		if (STATE_PANEL)
			icon_state = "4"


/obj/structure/AIcore/use_tool(obj/item/tool, mob/user, list/click_params)
	// AI Module
	// - State 4 - Apply lawset
	if (istype(tool, /obj/item/aiModule))
		if (state < STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can apply \the [tool].")
			return TRUE
		if (state > STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src]'s panel needs to be removed before you can apply \the [tool].")
			return TRUE
		// Special handling for certain law board
		// Freeform - Apply freeform law without deleting existing laws
		if (istype(tool, /obj/item/aiModule/freeform))
			var/obj/item/aiModule/freeform/freeform_lawboard = tool
			laws.add_inherent_law(freeform_lawboard.newFreeFormLaw)
		// Purge - Remove all laws
		else if (istype(tool, /obj/item/aiModule/purge))
			laws.clear_inherent_laws()
		// All others - Standard sync
		else
			var/obj/item/aiModule/lawboard = tool
			lawboard.laws.sync(src)
		user.visible_message(
			SPAN_NOTICE("\The [user] scans \a [tool] with \the [src]."),
			SPAN_NOTICE("You scan \the [tool] with \the [src], updating its lawset.")
		)
		return TRUE

	// Cable Coil
	// - State 3 - Add wiring, move to State 4
	if (isCoil(tool))
		if (state < STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to wire.")
			return TRUE
		if (state < STATE_CIRCUIT_SECURE)
			USE_FEEDBACK_FAILURE("\The [src]'s [circuit.name] needs to be fastened into place before you can wire it.")
			return TRUE
		if (state > STATE_CIRCUIT_SECURE)
			USE_FEEDBACK_FAILURE("\The [src]'s [circuit.name] is already wired.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.can_use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 5, "to wire \the [src]'s [circuit.name]")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts wiring \the [src] with \a [tool]."),
			SPAN_NOTICE("You start wiring \the [src] with \the [tool].")
		)
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
		if (!user.do_skilled(2 SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state < STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to wire.")
			return TRUE
		if (state < STATE_CIRCUIT_SECURE)
			USE_FEEDBACK_FAILURE("\The [src]'s [circuit.name] needs to be fastened into place before you can wire it.")
			return TRUE
		if (state > STATE_CIRCUIT_SECURE)
			USE_FEEDBACK_FAILURE("\The [src]'s [circuit.name] is already wired.")
			return TRUE
		if (!cable.use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 5, "to wire \the [src]'s [circuit.name]")
			return TRUE
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
		state = STATE_WIRED
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \the [src] with \a [tool]."),
			SPAN_NOTICE("You wire \the [src] with \the [tool].")
		)
		return TRUE

	// Circuitboard (AI Core)
	// - State 1 - Install circuitboard, move to State 2
	if (istype(tool, /obj/item/stock_parts/circuitboard/aicore))
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be anchored to the floor before you can install \the [tool].")
			return TRUE
		if (state > STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [circuit] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
		circuit = tool
		state = STATE_CIRCUIT
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	// Crowbar
	// - State 2 - Remove circuitboard, move to State 1
	// - State 4 - Remove brain, move to State 3
	// - State 5 - Remove panel, move to State 4 or 3
	if (isCrowbar(tool))
		if (state < STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		if (state > STATE_CIRCUIT && state < STATE_BRAIN)
			USE_FEEDBACK_FAILURE("\The [src]'s [circuit.name] needs to be unfastened before you can remove it.")
			return TRUE
		// Remove circuitboard
		if (state == STATE_CIRCUIT)
			state = STATE_FRAME
			update_icon()
			user.visible_message(
				SPAN_NOTICE("\The [user] removes \the [src]'s [circuit.name] with \a [tool]."),
				SPAN_NOTICE("\The [user] removes \the [src]'s [circuit.name] with \a [tool].")
			)
			circuit.dropInto(loc)
			circuit = null
		// Remove posibrain
		else if (state == STATE_BRAIN)
			state = STATE_WIRED
			update_icon()
			brain.dropInto(loc)
			user.visible_message(
				SPAN_NOTICE("\The [user] removes \the [src]'s [brain.name] with \a [tool]."),
				SPAN_NOTICE("You remove \the [src]'s [brain.name] with \the [tool]."),
				exclude_mobs = list(brain.brainmob)
			)
			to_chat(brain.brainmob, SPAN_NOTICE("\The [user] removes you from \the [src] with \a [tool]."))
			brain = null
		// Remove panel
		else if (state == STATE_PANEL)
			state = brain ? STATE_BRAIN : STATE_WIRED
			update_icon()
			playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
			new /obj/item/stack/material/glass/reinforced(loc, 2)
			user.visible_message(
				SPAN_NOTICE("\The [user] removes \the [src]'s glass panel with \a [tool]."),
				SPAN_NOTICE("You remove \the [src]'s glass panel with \the [tool].")
			)
		return TRUE

	// ID - Authorize core
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_NAME(id, tool)
		if (!check_access(id))
			USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
			return TRUE
		if (authorized)
			USE_FEEDBACK_FAILURE("\The [src] has already been authorized.")
			return TRUE
		authorized = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] scans \a [tool] over \the [src]'s ID scanner."),
			SPAN_NOTICE("You scan [id_name] over \the [src]'s ID scanner and authorize it to connect into the area's systems.")
		)
		return TRUE

	// Man-Machine Interface, Positronic Matrix
	// - State 4 - Install brain, move to State 5
	if (istype(tool, /obj/item/device/mmi) || istype(tool, /obj/item/organ/internal/posibrain))
		if (state < STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [tool].")
			return TRUE
		if (brain)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [brain] installed.")
			return TRUE
		if (state > STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src]'s panel needs to be removed before you can install \the [tool].")
			return TRUE
		var/mob/living/carbon/brain/new_brain
		if (istype(tool, /obj/item/device/mmi))
			var/obj/item/device/mmi/mmi = tool
			new_brain = mmi.brainmob
		else if (istype(tool, /obj/item/organ/internal/posibrain))
			var/obj/item/organ/internal/posibrain/posibrain = tool
			new_brain = posibrain.brainmob
		if (!new_brain)
			USE_FEEDBACK_FAILURE("\The [tool] is empty and cannot be installed into \the [src].")
			return TRUE
		if (new_brain.stat == DEAD)
			USE_FEEDBACK_FAILURE("\The [tool] is dead and cannot be installed into \the [src].")
			return TRUE
		if (jobban_isbanned(brain, "AI"))
			USE_FEEDBACK_FAILURE("This particular intelligence cannot be installed into an AI core.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		if (new_brain.mind)
			clear_antag_roles(new_brain.mind, TRUE)
		brain = tool
		state = STATE_BRAIN
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src]."),
			exclude_mobs = list(brain.brainmob)
		)
		if (brain)
			to_chat(brain.brainmob, SPAN_NOTICE("\The [user] installs you into \the [src]."))
		return TRUE

	// Material Stack
	// - State 4 or 5 - Install glass panel, move to State 6
	if (istype(tool, /obj/item/stack/material))
		if (tool.get_material_name() != MATERIAL_GLASS)
			return ..()
		var/obj/item/stack/material/material_stack = tool
		if (state < STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install a glass panel.")
			return TRUE
		if (state > STATE_BRAIN)
			USE_FEEDBACK_FAILURE("\The [src] already has a glass panel.")
			return TRUE
		if (!material_stack.reinf_material)
			USE_FEEDBACK_FAILURE("\The [tool] needs to be reinforced before it can be used as a panel for \the [src].")
			return TRUE
		if (!material_stack.can_use(2))
			USE_FEEDBACK_STACK_NOT_ENOUGH(material_stack, 2, "to install a panel into \the [src]")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts installing a panel into \the [src] with \a [tool]."),
			SPAN_NOTICE("You start installing a panel into \the [src] with \the [tool].")
		)
		if (!user.do_skilled(2 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state < STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install a glass panel.")
			return TRUE
		if (state > STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] already has a glass panel.")
			return TRUE
		if (!material_stack.use(2))
			USE_FEEDBACK_FAILURE("\The [tool] needs to be reinforced before it can be used as a panel for \the [src].")
			return TRUE
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		state = STATE_PANEL
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] installs a panel into \the [src] with \a [tool]."),
			SPAN_NOTICE("You install a panel into \the [src] with \the [tool].")
		)
		return TRUE

	// Screwdriver
	// - State 2 - Fasten circuitboard, move to State 3
	// - State 3 - Unfasten circuitboard, move to State 2
	// - State 5 - Finish core
	if (isScrewdriver(tool))
		if (state < STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to fasten.")
			return TRUE
		if (state > STATE_CIRCUIT_SECURE && state < STATE_PANEL)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring blocks access to \the [circuit].")
			return TRUE
		// Finish core
		if (state == STATE_PANEL)
			if (!authorized)
				USE_FEEDBACK_FAILURE("\The [src] is not authorized and cannot be finished.")
				return TRUE
			playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes \the [src] with \a [tool]."),
				SPAN_NOTICE("You finish \the [src] with \the [tool]."),
				exclude_mobs = list(brain?.brainmob)
			)
			if (brain)
				to_chat(brain.brainmob, SPAN_NOTICE("\The [user] finishes your [name] with \a [tool]."))
				var/mob/living/silicon/ai/ai = new /mob/living/silicon/ai(loc, laws, brain)
				if (ai)
					ai.on_mob_init()
					ai.rename_self("ai", TRUE)
					transfer_fingerprints_to(ai)
			else
				var/obj/structure/AIcore/deactivated/ai = new(loc)
				transfer_fingerprints_to(ai)
				var/timecheck = world.time
				spawn(0) // Don't block wrapping things up if the user doesn't select an option
					var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoining AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
					if (open_for_latejoin && !QDELETED(ai) && ((world.time - timecheck) <= 1 MINUTE))
						empty_playable_ai_cores += ai
			qdel_self()
			return TRUE

		// Fasten circuit
		else
			if (state == STATE_CIRCUIT_SECURE)
				state = STATE_CIRCUIT
			else
				state = STATE_CIRCUIT_SECURE
			update_icon()
			playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] [state == STATE_CIRCUIT ? "un" : null]fastens \the [src]'s circuits with \a [tool]."),
				SPAN_NOTICE("You [state == STATE_CIRCUIT ? "un" : null]fasten \the [src]'s circuits with \the [tool].")
			)
		return TRUE

	// Welding Tool
	// - State 1 - Deconstruct frame
	if (isWelder(tool))
		if (state == STATE_FRAME)
			if (anchored)
				USE_FEEDBACK_FAILURE("\The [src] needs to be unanchored from the floor before you can dismantle it with \the [tool].")
				return TRUE
			var/obj/item/weldingtool/welder = tool
			if (!welder.can_use(1, user, "to deconstruct \the [src]"))
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] starst dismantling \the [src] with \a [tool]."),
				SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
			)
			playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
			if (!user.do_skilled(SKILL_CONSTRUCTION, 2 SECONDS, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
				return TRUE
			if (!welder.remove_fuel(1, user))
				return TRUE
			new /obj/item/stack/material/plasteel(loc, 4)
			user.visible_message(
				SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
				SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
			)
			qdel_self()
			return TRUE

	// Wirecutters
	// - State 4 - Remove wiring, move to State 3
	if (isWirecutter(tool))
		if (state < STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (state > STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src]'s [brain.name] needs to be removed before you can cut the wiring.")
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		new /obj/item/stack/cable_coil(loc, 5)
		state = STATE_CIRCUIT_SECURE
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s wiring with \the [tool].")
		)
		return TRUE

	// Wrench
	// - State 1 - Un/Anchor frame (Handled in parent)

	return ..()


/obj/structure/AIcore/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	// Wrench - Toggle anchorable state
	if (interaction_handled && isWrench(tool))
		if (state == STATE_FRAME)
			SET_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE)
		else
			CLEAR_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE)
		update_icon()

	..()


/obj/structure/AIcore/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = TRUE
	state = 20//So it doesn't interact based on the above. Not really necessary.
	obj_flags = OBJ_FLAG_ANCHORABLE

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


/obj/structure/AIcore/deactivated/use_tool(obj/item/tool, mob/user, list/click_params)
	// AI Card - Load AI
	if (istype(tool, /obj/item/aicard))
		var/mob/living/silicon/ai/ai = locate() in tool
		if (!ai)
			USE_FEEDBACK_FAILURE("\The [tool] lacks an AI to install into \the [src].")
			return TRUE
		load_ai(ai, tool, user)
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
