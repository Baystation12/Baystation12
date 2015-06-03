/obj/machinery/virtualgameboard
	name = "Virtual Game Board"
	desc = "Used to play virtualized games."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virtual"
	density = 1
	anchored = 1.0
	throwpass = 1	//You can throw objects over this, despite it's density.")
	idle_power_usage	= 20
	active_power_usage	= 50



/obj/machinery/virtualgameboard/New()
	..()

/obj/machinery/virtualgameboard/verb/play()
	set name = "Play"
	set category = "Object"
	set src in oview(1)
	if(!iscarbon(usr))
		return
	usr.set_machine(src)
	ui_interact(usr)

	if(!iscarbon(usr))
		usr.visible_message("The virtualboard lights up")
	else
		usr.visible_message("[usr] begins to play a game")


/obj/machinery/virtualgameboard/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/game = checkgame()
	var/data[0]
	data["myName"] = user.name
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		switch(game)
			if("Chess")
				ui = new(user, src, ui_key, "chess.tmpl", "Virtual Game Board", 815, 775)
			if("Flap")
				ui = new(user, src, ui_key, "flappy.tmpl", "Virtual Game Board", 815, 775)
			if("Mahj")
				ui = new(user, src, ui_key, "mahjong.tmpl", "Virtual Game Board", 815, 775)
			if("OMG")
				ui = new(user, src, ui_key, "omg.tmpl", "Virtual Game Board", 815, 775)
			if("Soli")
				ui = new(user, src, ui_key, "soli.tmpl", "Virtual Game Board", 815, 775)
			if("Sudo")
				ui = new(user, src, ui_key, "sudoku.tmpl", "Virtual Game Board", 815, 775)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/virtualgameboard/Topic(href, href_list)
	if(..())
		return
	if (href_list["close"])
		usr.unset_machine()
		nanomanager.close_user_uis(usr, src)

/obj/machinery/virtualgameboard/proc/checkgame()
	var/list/buttons = list("Flappy Beak","OMGPOP","Mahjong","Multiplayer Chess","Solitaire Suite","Sudoku")
	var/style = "<style>BODY {margin:0;font:verdana;background:#464646;color:#e9c179;}</style>"
	var/game = sd_Alert(usr, "<center><b><font face=verdana size=5>Which game would you like to play?</font></b></center>","Virtual Gameboard", buttons,,0,,"400x150",,style)
	switch(game)
		if("Multiplayer Chess")
			return "Chess"
		if("Solitaire Suite")
			return "Soli"
		if("Mahjong")
			return "Mahj"
		if("Flappy Beak")
			return "Flap"
		if("Sudoku")
			return "Sudo"
		if("OMGPOP")
			return "OMG"

/obj/machinery/virtualgameboard/attack_hand(mob/user)
	if(!user)
		return

	src.add_fingerprint(user)
	user.set_machine(src)
	src.ui_interact(user)
	if(!iscarbon(usr))
		user.visible_message("The virtualboard lights up")
	else
		user.visible_message("[user] begins to play a game")

///obj/machinery/virtualgameboard/attack_paw(mob/user as mob)
//	return src.attack_hand(user)

/obj/machinery/virtualgameboard/attack_ghost(mob/dead/observer/user as mob)
	return src.attack_hand(user)