#define VOTE_WINDOW_MAIN_SCREEN "main_screen"
#define VOTE_WINDOW_VOTE_SCREEN "vote_screen"
#define VOTE_WINDOW_SETUP_SCREEN "setup_screen"

/datum/vote/window
	var/datum/vote/window_screen/screen
	var/list/screens

/datum/vote/window/New()
	..()
	screens = list()
	for(var/screen_type in subtypesof(/datum/vote/window_screen))
		screens[screen_type] = new screen_type(src)
	screen = screens[/datum/vote/window_screen/main]

/datum/vote/window/proc/interact(var/user)
	screen.interact(user)

/datum/vote/window/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 1, datum/tgui/master_ui = null, datum/ui_state/state = tg_interactive_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vote", "Vote", 350, 600, master_ui, state)
		ui.open()

/datum/vote/window/ui_act(action, params, user)
	return Topic(null, params)

/datum/vote/window/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 1, datum/ui_state/state = interactive_state)
	return

/datum/vote/window/ui_data(var/mob/user)
	var/data[0]
	data["screen"] = screen.id
	screen.screen_data(data, user)
	return data

/datum/vote/window/Topic(href, href_list, state = interactive_state)
	if(..())
		return TRUE
	if(href_list["back"])
		set_screen(/datum/vote/window_screen/main)
		return TRUE
	return screen.Topic(href, href_list)

/datum/vote/window/proc/set_screen()
	var/new_screen = screens[args[1]]
	if(new_screen)
		if(screen)
			screen.on_back()
		screen = new_screen
		screen.before_show(arglist(args-args[1]))

/datum/vote/window_screen
	var/id = ""
	var/datum/vote/window/window

/datum/vote/window_screen/New(window)
	src.window = window

/datum/vote/window_screen/CanUseTopic()
	return window.screen == src ? STATUS_INTERACTIVE : STATUS_CLOSE

/datum/vote/window_screen/proc/interact(var/mob/user)
	return

/datum/vote/window_screen/proc/screen_data(var/list/data, var/mob/user)
	return

/datum/vote/window_screen/proc/before_show()
	return

/datum/vote/window_screen/proc/on_back()
	return

/datum/vote/window_screen/proc/may_start_vote(var/mob/user)
	return check_rights(R_ADMIN, 0, user)
