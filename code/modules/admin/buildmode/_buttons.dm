/obj/effect/bmode
	density = TRUE
	anchored = TRUE
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	icon = 'icons/misc/buildmode.dmi'
	var/datum/click_handler/build_mode/host

/obj/effect/bmode/New(var/host)
	..()
	src.host = host

/obj/effect/bmode/Destroy()
	host = null
	. = ..()

/obj/effect/bmode/proc/OnClick(var/list/params)
	return

/obj/effect/bmode/dir
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/effect/bmode/dir/New()
	..()
	set_dir(host.dir)

/obj/effect/bmode/dir/OnClick(var/list/parameters)
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

/obj/effect/bmode/help
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/help/OnClick()
	host.current_build_mode.Help()

/obj/effect/bmode/mode
	screen_loc = "NORTH,WEST+2"

/obj/effect/bmode/mode/New()
	..()
	icon_state = host.current_build_mode.icon_state

/obj/effect/bmode/mode/OnClick(var/list/parameters)
	if(parameters["left"])
		var/datum/build_mode/build_mode = input("Select build mode", "Select build mode", host.current_build_mode) as null|anything in host.build_modes
		if(build_mode && host && (build_mode in host.build_modes))
			host.current_build_mode.Unselected()
			build_mode.Selected()
			host.current_build_mode = build_mode
			icon_state = build_mode.icon_state
			to_chat(usr, "<span class='notice'>Build mode '[host.current_build_mode]' selected.</span>")
	else if(parameters["right"])
		host.current_build_mode.Configurate()

/obj/effect/bmode/quit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/effect/bmode/quit/OnClick()
	usr.RemoveClickHandler(/datum/click_handler/build_mode)
