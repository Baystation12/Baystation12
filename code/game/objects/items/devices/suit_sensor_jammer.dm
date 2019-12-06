#define JAMMER_MAX_RANGE world.view*2
#define JAMMER_POWER_CONSUMPTION(tick_delay) ((max(0.75, range)**2 * jammer_method.energy_cost * tick_delay) / 20)

/obj/item/device/suit_sensor_jammer
	name = "small device"
	desc = "This object menaces with tiny, dull spikes of plastic."
	icon_state = "jammer"
	w_class = ITEM_SIZE_SMALL
	var/active = FALSE
	var/range = 2 // This is a radius, thus a range of 7 covers the entire visible screen
	var/obj/item/weapon/cell/bcell = /obj/item/weapon/cell/high
	var/suit_sensor_jammer_method/jammer_method
	var/list/suit_sensor_jammer_methods_by_type
	var/list/suit_sensor_jammer_methods

/obj/item/device/suit_sensor_jammer/New()
	..()
	if(ispath(bcell))
		bcell = new bcell(src)
	suit_sensor_jammer_methods = list()
	suit_sensor_jammer_methods_by_type = list()
	for(var/jammer_method_type in subtypesof(/suit_sensor_jammer_method))
		var/new_method = new jammer_method_type(src, /obj/item/device/suit_sensor_jammer/proc/may_process_crew_data)
		dd_insertObjectList(suit_sensor_jammer_methods, new_method)
		suit_sensor_jammer_methods_by_type[jammer_method_type] = new_method
	jammer_method = suit_sensor_jammer_methods[1]
	update_icon()

/obj/item/device/suit_sensor_jammer/Destroy()
	. = ..()
	qdel(bcell)
	bcell = null
	jammer_method = null
	for(var/method in suit_sensor_jammer_methods)
		qdel(method)
	suit_sensor_jammer_methods = null
	suit_sensor_jammer_methods_by_type = null
	disable()

/obj/item/device/suit_sensor_jammer/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/device/suit_sensor_jammer/get_cell()
	return bcell

/obj/item/device/suit_sensor_jammer/attackby(obj/item/I as obj, mob/user as mob)
	if(isCrowbar(I))
		if(bcell)
			to_chat(user, "<span class='notice'>You remove \the [bcell].</span>")
			disable()
			bcell.dropInto(loc)
			bcell = null
		else
			to_chat(user, "<span class='warning'>There is no cell to remove.</span>")
	else if(istype(I, /obj/item/weapon/cell))
		if(bcell)
			to_chat(user, "<span class='warning'>There's already a cell in \the [src].</span>")
		else if(user.unEquip(I))
			I.forceMove(src)
			bcell = I
			to_chat(user, "<span class='notice'>You insert \the [bcell] into \the [src]..</span>")
		else
			to_chat(user, "<span class='warning'>You're unable to insert the battery.</span>")

/obj/item/device/suit_sensor_jammer/on_update_icon()
	overlays.Cut()
	if(bcell)
		var/percent = bcell.percent()
		switch(percent)
			if(0 to 25)
				overlays += "forth_quarter"
			if(25 to 50)
				overlays += "one_quarter"
				overlays += "third_quarter"
			if(50 to 75)
				overlays += "two_quarters"
				overlays += "second_quarter"
			if(75 to 99)
				overlays += "three_quarters"
				overlays += "first_quarter"
			else
				overlays += "four_quarters"

		if(active)
			overlays += "active"

/obj/item/device/suit_sensor_jammer/emp_act(var/severity)
	..()
	if(bcell)
		bcell.emp_act(severity)

	if(prob(70/severity))
		enable()
	else
		disable()

	if(prob(90/severity))
		set_method(suit_sensor_jammer_methods_by_type[/suit_sensor_jammer_method/random])
	else
		set_method(pick(suit_sensor_jammer_methods))

	var/new_range = range + (rand(0,6) / severity) - (rand(0,3) / severity)
	set_range(new_range)

obj/item/device/suit_sensor_jammer/examine(mob/user, distance)
	. = ..()
	if(distance <= 3)
		var/list/message = list()
		message += "This device appears to be [active ? "" : "in"]active and "
		if(bcell)
			message += "displays a charge level of [bcell.percent()]%."
		else
			message += "is lacking a cell."
		to_chat(user, jointext(message,.))

obj/item/device/suit_sensor_jammer/CanUseTopic(user, state)
	if(!bcell || bcell.charge <= 0)
		return STATUS_CLOSE
	return ..()

obj/item/device/suit_sensor_jammer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/methods = new
	for(var/suit_sensor_jammer_method/ssjm in suit_sensor_jammer_methods)
		methods[++methods.len] = list("name" = ssjm.name, "cost" = ssjm.energy_cost, "ref" = "\ref[ssjm]")

	var/list/data = list(
		"active" = active,
		"current_charge" = bcell ? round(bcell.charge, 1) : 0,
		"max_charge" = bcell ? bcell.maxcharge : 0,
		"range" = range,
		"max_range" = JAMMER_MAX_RANGE,
		"methods" = methods,
		"current_method" = "\ref[jammer_method]",
		"current_cost" = jammer_method.energy_cost,
		"total_cost" = "[ceil(JAMMER_POWER_CONSUMPTION(10))]"
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "suit_sensor_jammer.tmpl", "Sensor Jammer", 300, 640)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

obj/item/device/suit_sensor_jammer/OnTopic(var/mob/user, var/list/href_list, state)
	if (href_list["enable_jammer"])
		enable()
		return TOPIC_REFRESH
	if (href_list["disable_jammer"])
		disable()
		return TOPIC_REFRESH

	if (href_list["increase_range"])
		set_range(range + 1)
		return TOPIC_REFRESH
	if (href_list["decrease_range"])
		set_range(range - 1)
		return TOPIC_REFRESH

	if (href_list["select_method"])
		var/method = locate(href_list["select_method"]) in suit_sensor_jammer_methods
		if(method)
			set_method(method)
			return TOPIC_REFRESH

/obj/item/device/suit_sensor_jammer/Process(var/wait)
	if(bcell)
		// With a range of 2 and jammer cost of 3 the default (high capacity) cell will last for almost 14 minutes, give or take
		// 10000 / (2^2 * 3 / 10) ~= 8333 ticks ~= 13.8 minutes
		var/deduction = JAMMER_POWER_CONSUMPTION(wait)
		if(!bcell.use(deduction))
			disable()
	else
		disable()
	update_icon()

/obj/item/device/suit_sensor_jammer/proc/enable()
	if(active)
		return FALSE
	active = TRUE
	START_PROCESSING(SSobj, src)
	jammer_method.enable()
	update_icon()
	return TRUE

/obj/item/device/suit_sensor_jammer/proc/disable()
	if(!active)
		return FALSE
	active = FALSE
	jammer_method.disable()
	STOP_PROCESSING(SSobj, src)
	update_icon()
	return TRUE

/obj/item/device/suit_sensor_jammer/proc/set_range(var/new_range)
	range = Clamp(new_range, 0, JAMMER_MAX_RANGE) // 0 range still covers the current turf
	return range != new_range

/obj/item/device/suit_sensor_jammer/proc/set_method(var/suit_sensor_jammer_method/sjm)
	if(sjm == jammer_method)
		return
	if(active)
		jammer_method.disable()
		sjm.enable()
	jammer_method = sjm

/obj/item/device/suit_sensor_jammer/proc/may_process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos)
	if(!pos)
		return FALSE
	var/turf/T = get_turf(src)
	return T && T.z == pos.z && get_dist(T, pos) <= range

#undef JAMMER_MAX_RANGE
#undef JAMMER_POWER_CONSUMPTION
