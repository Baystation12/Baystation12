/obj/bmode
	density = TRUE
	anchored = TRUE
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	icon = 'icons/misc/buildmode.dmi'
	var/datum/click_handler/build_mode/host

/obj/bmode/New(host)
	..()
	src.host = host

/obj/bmode/Destroy()
	host = null
	. = ..()

/obj/bmode/proc/OnClick(list/params)
	return

/obj/bmode/dir
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/bmode/dir/New()
	..()
	set_dir(host.dir)

/obj/bmode/dir/OnClick(list/parameters)
	switch(dir)
		if(SOUTH)
			set_dir(WEST)
		if(WEST)
			set_dir(NORTH)
		if(NORTH)
			set_dir(EAST)
		if(EAST)
			set_dir(NORTHWEST)
		else
			set_dir(SOUTH)
	host.dir = dir

/obj/bmode/help
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/bmode/help/OnClick()
	host.current_build_mode.Help()

/obj/bmode/mode
	screen_loc = "NORTH,WEST+2"

/obj/bmode/mode/New()
	..()
	icon_state = host.current_build_mode.icon_state

/obj/bmode/mode/OnClick(list/parameters)
	if(parameters["left"])
		var/datum/build_mode/build_mode = input("Select build mode", "Select build mode", host.current_build_mode) as null|anything in host.build_modes
		if(build_mode && host && (build_mode in host.build_modes))
			host.current_build_mode.Unselected()
			build_mode.Selected()
			host.current_build_mode = build_mode
			icon_state = build_mode.icon_state
			to_chat(usr, SPAN_NOTICE("Build mode '[host.current_build_mode]' selected."))
	else if(parameters["right"])
		host.current_build_mode.Configurate()

/obj/bmode/quit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/bmode/quit/OnClick()
	usr.RemoveClickHandler(/datum/click_handler/build_mode)
