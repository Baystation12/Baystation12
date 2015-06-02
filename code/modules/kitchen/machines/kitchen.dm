var/list/stove_overlay_cache = list()
/obj/machinery/kitchen/proc/retrieve_cached_image(var/cstate, var/calpha, var/ccolour, var/xoffset, var/yoffset)
	if(!cstate)
		cstate = ""
	var/cache_key = cstate
	if(!isnull(calpha))
		cache_key += "-a[calpha]"
	if(!isnull(ccolour))
		cache_key += "-#[ccolour]"
	if(!isnull(xoffset))
		cache_key += "-x[xoffset]"
	if(!isnull(yoffset))
		cache_key += "-y[yoffset]"
	if(!stove_overlay_cache[cache_key])
		var/image/I = image(icon, cstate)
		if(!isnull(calpha))  I.alpha = calpha
		if(!isnull(ccolour)) I.color = ccolour
		if(!isnull(xoffset)) I.pixel_x = xoffset
		if(!isnull(yoffset)) I.pixel_y = yoffset
		stove_overlay_cache[cache_key] = I
	return stove_overlay_cache[cache_key]

/obj/machinery/kitchen
	name = "kitchen machine"
	desc = "This should not exist."
	icon = 'icons/obj/kitchen/inedible/machines.dmi'
	icon_state = "oven"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 0
	idle_power_usage = 20
	active_power_usage = 300
	light_color = "#FF0000"
	light_range = 2
	light_power = 0

	var/nano_template = "oven.tmpl"
	var/acceptable_containers = list()
	var/min_temp = 20
	var/max_temp = 260

/obj/machinery/kitchen/New()
	..()
	update_icon()

/obj/machinery/kitchen/examine()
	..()
	usr << "It is turned [(use_power == 2) ? "on" : "off"]."
	if(stat & BROKEN)
		usr << "It is damaged and not functional."

/obj/machinery/kitchen/proc/get_data()
	var/list/data = list()
	data["on"] = (use_power==2) ? 1 : 0
	data["minTemp"] = min_temp
	data["maxTemp"] = max_temp
	return data

/obj/machinery/kitchen/proc/get_temperature_string(var/input_temperature)
	if(!input_temperature)
		input_temperature = 0
	switch(input_temperature)
		if(0 to 59)
			return "normal"
		if(60 to 159)
			return "good"
		if(160 to 219)
			return "average"
		else
			return "bad"

/obj/machinery/kitchen/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/kitchen/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/kitchen/Topic(href, href_list)
	if(..())
		return
	. = 0
	if (href_list["togglePower"])
		if(use_power)
			use_power = 0
		else
			use_power = 2
		update_use_power(use_power)
		update_icon()
		. = 1
	src.add_fingerprint(usr)

/obj/machinery/kitchen/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = get_data()
	if(!data)
		return
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, nano_template, "[capitalize(src.name)]", 440, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
