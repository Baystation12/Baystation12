GLOBAL_LIST_EMPTY(radio_jammers)
//adjusted to last a while so it can last conversations
#define JAMMER_POWER_CONSUMPTION(tick_delay) ((max(0.75, range)**2 * tick_delay) / 30)

/obj/item/device/radio_jammer
	name = "small remote"
	desc = "A small remote control covered in a number of lights, with several antennae extending from the top."
	icon = 'icons/obj/radio_jammer.dmi'
	icon_state = "jammer"
	w_class = ITEM_SIZE_SMALL
	var/is_active = FALSE
	var/range = 5
	var/square_radius = 25
	var/code = 23
	var/frequency = 1413
	var/obj/item/cell/bcell = /obj/item/cell/high

/obj/item/device/radio_jammer/Initialize()
	. = ..()
	if(ispath(bcell))
		bcell = new bcell(src)
	GLOB.listening_objects += src
	set_frequency(frequency)

/obj/item/device/radio_jammer/Destroy()
	GLOB.radio_jammers -= src
	GLOB.listening_objects -= src
	qdel(bcell)
	return ..()

/obj/item/device/radio_jammer/Process(wait)
	var/cost = JAMMER_POWER_CONSUMPTION(wait)
	if (!bcell?.use(cost))
		STOP_PROCESSING(SSobj, src)
		GLOB.radio_jammers -=src
		is_active = FALSE

/obj/item/device/radio_jammer/attack_self(mob/living/user)
	ui_interact(user)

/obj/item/device/radio_jammer/get_cell()
	return bcell

/obj/item/device/radio_jammer/emp_act(severity)
	..()
	if(bcell)
		bcell.emp_act(severity)

/obj/item/device/radio_jammer/proc/toggle(mob/user)
	if(is_active)
		STOP_PROCESSING(SSobj, src)
		to_chat(user,SPAN_WARNING("You flick a switch on \the [src], deactivating it."))
		is_active = FALSE
		GLOB.radio_jammers -= src
		update_icon()
	else
		START_PROCESSING(SSobj, src)
		to_chat(user,SPAN_WARNING("You flick a switch on \the [src], activating it."))
		is_active = TRUE
		GLOB.radio_jammers += src
		update_icon()

/obj/item/device/radio_jammer/on_update_icon()
	ClearOverlays()
	if(bcell)
		var/percent = bcell.percent()
		switch(percent)
			if(0 to 25)
				AddOverlays("quarter")
			if(25 to 50)
				AddOverlays("half")
			if(50 to 99)
				AddOverlays("full")
			else
				AddOverlays("four_quarters")

		if(is_active)
			AddOverlays("on")
		else
			AddOverlays("off")

/obj/item/device/radio_jammer/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio_jammer/receive_signal(datum/signal/signal)
	if(signal?.encryption == code)
		toggle()

/obj/item/device/radio_jammer/OnTopic(mob/user, list/href_list, state)
	if (href_list["enable_jammer"])
		toggle()
		return TOPIC_REFRESH
	if (href_list["disable_jammer"])
		toggle()
		return TOPIC_REFRESH
	if(href_list["increase_range"])
		range = min(range + 1, 10)
		square_radius = range ** 2
		return TOPIC_REFRESH
	if(href_list["decrease_range"])
		range = max(range - 1, 0)
		square_radius = range ** 2
		return TOPIC_REFRESH
	if(href_list["set_code"])
		var/adj = text2num(href_list["code"])
		if(!adj)
			code = input("Set radio activation code","Radio activation") as num
		if (QDELETED(src) || CanUseTopic(user, state, href_list) == STATUS_INTERACTIVE)
			return TOPIC_HANDLED
		else
			code += adj
		code = clamp(code,1,100)
		return TOPIC_REFRESH
	if (href_list["set_frequency"])
		var/adj = text2num(href_list["frequency"])
		if(!adj)
			var/temp = input("Set a four digit radio frequency without decimals","Radio activation") as num
			set_frequency(sanitize_frequency(temp, RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
		if (QDELETED(src) || CanUseTopic(user, state, href_list) == STATUS_INTERACTIVE)
			return TOPIC_HANDLED
		return TOPIC_REFRESH

/obj/item/device/radio_jammer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/list/data = list(
		"active" = is_active,
		"current_charge" = bcell ? round(bcell.charge, 1) : 0,
		"max_charge" = bcell ? bcell.maxcharge : 0,
		"range" = range,
		"max_range" = 10,
		"frequency" = format_frequency(frequency),
		"code" = code,
		"total_cost" = "[ceil(JAMMER_POWER_CONSUMPTION(10))]"
	)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "radio_jammer.tmpl", "Portable Radio Jammer", 300, 640)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/item/device/radio_jammer/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (isCrowbar(tool))
		if(is_active)
			STOP_PROCESSING(SSobj, src)
			is_active = FALSE
			GLOB.radio_jammers -= src
		if (!bcell)
			USE_FEEDBACK_FAILURE("\The [src] has no cell to remove.")
			return TRUE
		user.put_in_hands(bcell)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [bcell] from \a [src] with \a [tool]."),
			SPAN_NOTICE("You remove \the [bcell] from \the [src] with \the [tool].")
		)
		bcell = null
		update_icon()
		return TRUE
	if (istype(tool, /obj/item/cell))
		if (bcell)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bcell] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		bcell = tool
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \a [src]."),
			SPAN_NOTICE("you install \the [tool] into \the [src].")
		)
		update_icon()
		return TRUE

	return ..()


#undef JAMMER_POWER_CONSUMPTION
