//--------------------------------------------
// Pipe colors
//
// Add them here and to the pipe_colors list
//  to automatically add them to all relevant
//  atmospherics devices.
//--------------------------------------------
var/global/list/pipe_colors = list(
	"grey" = PIPE_COLOR_GREY,
	"red" = PIPE_COLOR_RED,
	"blue" = PIPE_COLOR_BLUE,
	"cyan" = PIPE_COLOR_CYAN,
	"green" = PIPE_COLOR_GREEN,
	"yellow" = PIPE_COLOR_YELLOW,
	"black" = PIPE_COLOR_BLACK,
	"orange" = PIPE_COLOR_ORANGE,
	"white" = PIPE_COLOR_WHITE)

/proc/pipe_color_lookup(color)
	for(var/C in pipe_colors)
		if(color == pipe_colors[C])
			return "[C]"

/proc/pipe_color_check(color)
	if(!color)
		return 1
	for(var/C in pipe_colors)
		if(color == pipe_colors[C])
			return 1
	return 0

//--------------------------------------------
// Icon cache generation
//--------------------------------------------

/datum/pipe_icon_manager
	var/list/pipe_icons[]
	var/list/manifold_icons[]
	var/list/device_icons[]
	var/list/pipe_underlays[]
	var/list/omni_icons[]

/datum/pipe_icon_manager/New()
	check_icons()

/datum/pipe_icon_manager/proc/get_atmos_icon(device, dir, color, state)
	check_icons(device, dir, color, state)

	device = "[device]"
	state = "[state]"
	color = "[color]"
	dir = "[dir]"

	switch(device)
		if("pipe")
			return pipe_icons[state + color]
		if("manifold")
			return manifold_icons[state + color]
		if("device")
			return device_icons[state]
		if("omni")
			return omni_icons[state]
		if("underlay")
			return pipe_underlays[state + dir + color]


/datum/pipe_icon_manager/proc/check_icons(device, dir, color, state)
	if(!pipe_icons)
		gen_pipe_icons()
	if(!manifold_icons)
		gen_manifold_icons()
	if(!device_icons)
		gen_device_icons()
	if(!omni_icons)
		gen_omni_icons()
	if(!pipe_underlays)
		gen_underlay_icons()

	// In case of a non-default color, generate the missing icon and add it to the cache.
	if(pipe_color_check(color))
		return
	switch("[device]")
		if("pipe")
			if(!pipe_icons[color + state])
				gen_single_pipe_icon(color, state)
		if("manifold")
			if(!manifold_icons[color + state])
				gen_single_manifold_icon(color, state)
		if("underlay")
			if(!pipe_underlays[state + "[dir]" + color])
				gen_single_underlay_icon(dir, color, state)

/datum/pipe_icon_manager/proc/gen_pipe_icons()
	if(!pipe_icons)
		pipe_icons = new()

	var/icon/pipe = new('icons/atmos/pipes.dmi')

	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue

		var/cache_name = state
		var/image/I = image('icons/atmos/pipes.dmi', icon_state = state)
		pipe_icons[cache_name] = I

		for(var/pipe_color in pipe_colors)
			I = image('icons/atmos/pipes.dmi', icon_state = state)
			I.color = pipe_colors[pipe_color]
			pipe_icons[state + "[pipe_colors[pipe_color]]"] = I

	pipe = new ('icons/atmos/heat.dmi')
	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue
		pipe_icons["hepipe" + state] = image('icons/atmos/heat.dmi', icon_state = state)

	pipe = new ('icons/atmos/junction.dmi')
	for(var/state in pipe.IconStates())
		if(!state || findtext(state, "map"))
			continue
		pipe_icons["hejunction" + state] = image('icons/atmos/junction.dmi', icon_state = state)

/datum/pipe_icon_manager/proc/gen_single_pipe_icon(color, state)
	var/image/I = image('icons/atmos/pipes.dmi', icon_state = state)
	I.color = color
	pipe_icons[state + color] = I

/datum/pipe_icon_manager/proc/gen_manifold_icons()
	if(!manifold_icons)
		manifold_icons = new()

	var/icon/pipe = new('icons/atmos/manifold.dmi')

	for(var/state in pipe.IconStates())
		if(findtext(state, "clamps"))
			var/image/I = image('icons/atmos/manifold.dmi', icon_state = state)
			manifold_icons[state] = I
			continue

		if(findtext(state, "core") || findtext(state, "4way"))
			var/image/I = image('icons/atmos/manifold.dmi', icon_state = state)
			manifold_icons[state] = I
			for(var/pipe_color in pipe_colors)
				I = image('icons/atmos/manifold.dmi', icon_state = state)
				I.color = pipe_colors[pipe_color]
				manifold_icons[state + pipe_colors[pipe_color]] = I

/datum/pipe_icon_manager/proc/gen_single_manifold_icon(color, state)
	var/image/I = image('icons/atmos/manifold.dmi', icon_state = state)
	manifold_icons[state] = I
	if(findtext(state, "clamps"))
		manifold_icons[state] = I
	else
		I.color = color
		manifold_icons[state + color] = I

/datum/pipe_icon_manager/proc/gen_device_icons()
	if(!device_icons)
		device_icons = new()

	var/icon/device

	device = new('icons/atmos/vent_pump.dmi')
	for(var/state in device.IconStates())
		if(!state || findtext(state, "map"))
			continue
		device_icons["vent" + state] = image('icons/atmos/vent_pump.dmi', icon_state = state)

	device = new('icons/atmos/vent_scrubber.dmi')
	for(var/state in device.IconStates())
		if(!state || findtext(state, "map"))
			continue
		device_icons["scrubber" + state] = image('icons/atmos/vent_scrubber.dmi', icon_state = state)

/datum/pipe_icon_manager/proc/gen_omni_icons()
	if(!omni_icons)
		omni_icons = new()

	var/icon/omni = new('icons/atmos/omni_devices.dmi')

	for(var/state in omni.IconStates())
		if(!state || findtext(state, "map"))
			continue
		omni_icons[state] = image('icons/atmos/omni_devices.dmi', icon_state = state)


/datum/pipe_icon_manager/proc/gen_underlay_icons()

	if(!pipe_underlays)
		pipe_underlays = new()

	var/icon/pipe = new('icons/atmos/pipe_underlays.dmi')

	for(var/state in pipe.IconStates())
		if(state == "")
			continue

		var/cache_name = state

		for(var/D in GLOB.cardinal)
			var/image/I = image('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
			pipe_underlays[cache_name + "[D]"] = I
			for(var/pipe_color in pipe_colors)
				I = image('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = D)
				I.color = pipe_colors[pipe_color]
				pipe_underlays[state + "[D]" + "[pipe_colors[pipe_color]]"] = I

/datum/pipe_icon_manager/proc/gen_single_underlay_icon(dir, color, state)
	var/image/I = image('icons/atmos/pipe_underlays.dmi', icon_state = state, dir = dir)
	I.color = color
	pipe_underlays[state + "[dir]" + color] = I
