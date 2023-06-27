/obj/item/device/radio/intercom
	name = "intercom (General)"
	desc = "Talk through this."
	icon_state = "intercom"
	randpixel = 0
	anchored = TRUE
	w_class = ITEM_SIZE_HUGE
	canhear_range = 2
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	layer = ABOVE_WINDOW_LAYER
	cell = null
	power_usage = 0
	var/wiresexposed = FALSE
	///2 = wired/built, 1 = circuit installed, 0 = frame
	var/buildstage = 2
	var/number = 0
	var/last_tick //used to delay the powercheck
	intercom_handling = TRUE

/obj/item/device/radio/intercom/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/device/radio/intercom/map_preset
	var/preset_name
	var/use_common = FALSE
	channels = list()
	var/default_hailing = FALSE

/obj/item/device/radio/intercom/map_preset/Initialize()
	if (!preset_name)
		return ..()

	var/name_lower = lowertext(preset_name)
	name = "[name_lower] intercom"
	frequency = assign_away_freq(preset_name)
	if (default_hailing)
		frequency = HAIL_FREQ
	channels += list(
		preset_name = 1,
		"Hailing" = 1
	)
	if (use_common)
		channels += list("Common" = 1)

	. = ..()

	internal_channels = list(
		num2text(assign_away_freq(preset_name)) = list(),
		num2text(HAIL_FREQ) = list(),
	)
	if (use_common)
		internal_channels += list(num2text(PUB_FREQ) = list())

/obj/item/device/radio/intercom/custom
	name = "intercom (Custom)"
	broadcasting = 0
	listening = 0

/obj/item/device/radio/intercom/hailing
	name = "intercom (Hailing)"
	frequency = HAIL_FREQ

/obj/item/device/radio/intercom/interrogation
	name = "intercom (Interrogation)"
	frequency  = 1449

/obj/item/device/radio/intercom/private
	name = "intercom (Private)"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = ERT_FREQ

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/device/radio/intercom/department/medbay
	name = "intercom (Medbay)"
	frequency = MED_I_FREQ

/obj/item/device/radio/intercom/department/security
	name = "intercom (Security)"
	frequency = SEC_I_FREQ

/obj/item/device/radio/intercom/entertainment
	name = "entertainment intercom"
	frequency = ENT_FREQ
	canhear_range = 4

/obj/item/device/radio/intercom/Initialize(loc, dir, atom/frame)
	. = ..()
	START_PROCESSING(SSobj, src)

	if (dir)
		set_dir(dir)

	if (istype(frame))
		buildstage = 0
		wiresexposed = TRUE
		pixel_x = (dir & 3) ? 0 : (dir == 4 ? -21 : 21)
		pixel_y = (dir & 3) ? (dir == 1 ? -28 : 23) : 0
		frame.transfer_fingerprints_to(src)

	update_icon()

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_FREQ) = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/entertainment/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(ENT_FREQ) = list()
	)

/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly."
	frequency = SYND_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/raider
	name = "illicit intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	frequency = RAID_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/raider/Initialize()
	. = ..()
	internal_channels[num2text(RAID_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/radio/intercom/attack_ai(mob/user)
	add_fingerprint(user)
	if (buildstage == 2)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user)
	add_fingerprint(user)
	if (buildstage == 2)
		attack_self(user)

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range


/obj/item/device/radio/intercom/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cable Coil - Install wiring
	if (isCoil(tool))
		if (buildstage > 1)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (buildstage < 1)
			USE_FEEDBACK_FAILURE("\The [src] has no circuitry to wire.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 5, "to wire \the [src].")
			return TRUE
		b_stat = TRUE
		buildstage = 2
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \a [src] with [cable.get_vague_name(TRUE)]."),
			SPAN_NOTICE("You wire \the [src] with [cable.get_exact_name(5)].")
		)
		return TRUE

	// Crowbar - Remove circuits
	if (isCrowbar(tool))
		if (buildstage > 1)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring needs to be removed before you can remove the circuit.")
			return TRUE
		if (buildstage < 1)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts removing \a [src]'s circuit with \a [tool]."),
			SPAN_NOTICE("You start removing \the [src]'s circuit with \the [tool].")
		)
		if (!user.do_skilled(tool.toolspeed, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (buildstage > 1)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring needs to be removed before you can remove the circuit.")
			return TRUE
		if (buildstage < 1)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		var/obj/item/intercom_electronics/circuit = new(get_turf(src))
		buildstage = 0
		update_icon()
		playsound(loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [circuit] from \a [src] with \a [tool]."),
			SPAN_NOTICE("You remove \the [circuit] from \the [src] with \the [tool].")
		)
		return TRUE

	// Intercom Electronics - Install circuit
	if (istype(tool, /obj/item/intercom_electronics))
		if (buildstage > 0)
			USE_FEEDBACK_FAILURE("\The [src] already has a circuit installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		buildstage = 1
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] into \a [src]."),
			SPAN_NOTICE("You insert \the [tool] into \the [src].")
		)
		qdel(tool)
		return TRUE

	// Screwdriver - Toggle wire panel
	if (isScrewdriver(tool))
		if (buildstage < 2)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to expose.")
			return TRUE
		wiresexposed = !wiresexposed
		update_icon()
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] [wiresexposed ? "opens" : "closes"] \a [src]'s wiring panel with \a [tool]."),
			SPAN_NOTICE("You [wiresexposed ? "open" : "close"] \the [src]'s wiring panel with \the [tool].")
		)
		return TRUE

	// Wirecutters - Cut wiring
	if (isWirecutter(tool))
		if (buildstage < 2)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (!wiresexposed)
			USE_FEEDBACK_FAILURE("\The [src]'s wire panel needs to be opened before you can cut the wiring.")
			return TRUE
		new /obj/item/stack/cable_coil(get_turf(src), 5)
		b_stat = FALSE
		buildstage = 1
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \a [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wiring with \the [tool].")
		)
		return TRUE

	// Wrench - Remove from wall
	if (isWrench(tool))
		new /obj/item/frame/intercom(get_turf(src))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [src] from the wall with \a [tool]."),
			SPAN_NOTICE("You remove \the [src] from the wall with \the [tool].")
		)
		qdel(src)
		return TRUE

	return ..()


/obj/item/device/radio/intercom/get_mechanics_info()
	. = ..()
	. += "<p>To construct:</p>\
			<ol>\
				<li>Attach the frame to the wall</li>\
				<li>Install the circuitboard into the frame</li>\
				<li>Use cables to wire the intercom</li>\
				<li>Screwdriver to close the panel</li>\
			</ol>\
		<p>To deconstruct:</p>\
			<ol>\
				<li>Screwdriver to open the panel</li>\
				<li>Wirecutters to remove the wiring</li>\
				<li>Crowbar to remove the circuitry</li>\
				<li>Wrench to remove the frame from the wall</li>\
			</ol>"

/obj/item/device/radio/intercom/get_interactions_info()
	. = ..()
	.["Cable Coil"] += "<p>Used for construction. See construction steps.</p>"
	.["Circuitboard"] += "<p>Used for construction. See construction steps.</p>"
	.["Crowbar"] += "<p>Used for desconstruction. See deconstruction steps.</p>"
	.["Screwdriver"] += "<p>Toggles the maintenance panel open and closed.</p>"
	.["Wirecutters"] += "<p>Used for deconstruction. See deconstruction steps.</p>"
	.["Wrench"] += "<p>Used for deconstruction. See deconstruction steps.</p>"

/obj/item/device/radio/intercom/Process()
	if (wiresexposed)
		on = FALSE
		return
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday
		var/old_on = on

		if(!src.loc)
			on = FALSE
		else
			var/area/A = get_area(src)
			if(!A)
				on = FALSE
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if (on != old_on)
			update_icon()

/obj/item/device/radio/intercom/on_update_icon()
	if (buildstage == 2 && wiresexposed)
		icon_state = "intercom-b2"
	else if (buildstage == 1)
		icon_state = "intercom-b1"
	else if (buildstage == 0)
		icon_state = "intercom-f"
	else if (!on)
		icon_state = "intercom-p"
	else
		icon_state = "intercom_[broadcasting][listening]"

/obj/item/device/radio/intercom/ToggleBroadcast()
	..()
	update_icon()

/obj/item/device/radio/intercom/ToggleReception()
	..()
	update_icon()

/obj/item/device/radio/intercom/broadcasting
	broadcasting = 1

/obj/item/intercom_electronics
	name = "intercom electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "The label reads 'Intercom'. Wonder what it's for?"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/obj/item/intercom_electronics/get_mechanics_info()
	. = ..()
	. += "<p>To construct:</p>\
			<ol>\
				<li>Attach the frame to the wall</li>\
				<li>Install the circuitboard into the frame</li>\
				<li>Use cables to wire the intercom</li>\
				<li>Screwdriver to close the panel</li>\
			</ol>"
/obj/item/device/radio/intercom/locked
	var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency()
	..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	locked_frequency = AI_FREQ
	broadcasting = 1
	listening = 1

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	locked_frequency = 1480
