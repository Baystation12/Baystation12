/mob/living/silicon/ai/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	var/list/possibleNames = ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(ai_names)
		for (var/mob/living/silicon/ai/A in world)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	networks = list("SS13",
					"Medbay",
					"Research",
					"Engineering",
					"Command",
					"Singularity",
					"Tcomsat",
					"Solars",
					"Security",
					"Cargo",
					"Bomb Testing",
					"Research",
					"Medbay",
					"Atmospherics",
					"Mess Hall",
					"Arrivals",
					"Singularity",
					"Arrivals",
					"Mine")

	real_name = pickedName
	name = real_name
	original_name = real_name
	anchored = 1
	canmove = 0
	loc = loc
	holo_icon = getHologramIcon(icon('AI.dmi',"holo1"))

	proc_holder_list = new()

	if(L)
		if (istype(L, /datum/ai_laws))
			laws = L
	else
		laws = new /datum/ai_laws/nanotrasen

	verbs += /mob/living/silicon/ai/proc/show_laws_verb

	if (istype(loc, /turf))
		verbs += /mob/living/silicon/ai/proc/ai_call_shuttle
		verbs += /mob/living/silicon/ai/proc/ai_camera_track
		verbs += /mob/living/silicon/ai/proc/ai_camera_list
		//Added ai_network_change by Mord_Sith
		verbs += /mob/living/silicon/ai/proc/ai_network_change
		verbs += /mob/living/silicon/ai/proc/ai_statuschange
		//Hologram verb./N
		verbs += /mob/living/silicon/ai/proc/ai_hologram_change

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			del(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

			src << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
			src << "<B>To look at other parts of the station, double-click yourself to get a camera menu.</B>"
			src << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
			src << "To use something, simply double-click it."
			src << "Currently right-click functions will not work for the AI (except examine), and will either be replaced with dialogs or won't be usable by the AI."
			src << "Remember to <b>adjust your camera network</b> if you are having difficulty navigating the camera networks with the arrow keys or clicking on certain objects.<br>"

			if (!(ticker && ticker.mode && (mind in ticker.mode.malf_ai)))
				show_laws()
				src << "<b>These laws may be changed by other players, or by you being the traitor.</b>"
				src << "<br><b><font color=red>IMPORTANT GAMEPLAY ASPECTS:</font></b>"
				src << "1.) Act like an AI.  If someone is breaking into your upload, say something like \"Alert.  Unauthorised Access Detected: AI Upload.\" not \"Help! Urist is trying to subvert me!\""
				src << "2.) Do not watch the traitor like a hawk alerting the station to his/her every move.  This relates to 1."
				src << "3.) You are theoretically omniscient, but you should not be Beepsky 5000, laying down the law left and right.  That is security's job.  Instead, try to keep the station productive and effective.  (Feel free to report the location of major violence and crimes and all that, just do not be the evil thing looking over peoples shoulders)"
				src << "<br>We want everyone to have a good time, so we, the admins, will try to correct you if you stray from these rules.  Just try to keep it sensible."
			job = "AI"

			spawn(0)
				ainame(src)

	if(src.mind)
		ticker.mode.remove_revolutionary(src.mind)

	if(client)
		for(var/obj/effect/rune/rune in world)
			var/image/blood = image('blood.dmi', loc = rune, icon_state = "floor[rand(1,7)]")
			blood.override = 1
			client.images += blood

	return

/mob/living/silicon/ai/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		if(anchored)
			user.visible_message("\blue [user] starts to unbolt [src] from the plating...")
			if(!do_after(user,40))
				user.visible_message("\blue [user] decides not to unbolt [src]")
				return
			user.visible_message("\blue [user] finishes unfastening [src]")
			anchored = 0
			return
		else
			user.visible_message("\blue [user] starts to bolt [src] to the plating...")
			if(!do_after(user,40))
				user.visible_message("\blue [user] decides not to bolt [src]")
				return
			user.visible_message("\blue [user] finishes fastening down [src]")
			anchored = 1
			return
	else
		return ..()


/mob/living/silicon/ai/verb/pick_icon()
	set category = "AI Commands"
	set name = "Change AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

		//if(icon_state == initial(icon_state))
	var/icontype = ""
	var/list/icons = list("Blue", "Monochrome", "Rainbow", "Inverted", "Firewall", "Green", "Text", "Smiley", "Angry", "Dorf", "Matrix", "Bliss", "Red", "Static")
	if (src.name == "B.A.N.N.E.D." && src.ckey == "spaceman96")
		icons += "B.A.N.N.E.D."
	icontype = input("Please, select a display!", "AI", null/*, null*/) in icons
	if(icontype == "Blue")
		icon_state = "ai"
	else if(icontype == "Monochrome")
		icon_state = "ai-mono"
	else if(icontype == "Rainbow")
		icon_state = "ai-clown"
	else if(icontype == "Inverted")
		icon_state = "ai-u"
	else if(icontype == "Firewall")
		icon_state = "ai-magma"
	else if(icontype == "Green")
		icon_state = "ai-wierd"
	else if(icontype == "Text")
		icon_state = "ai-text"
	else if(icontype == "Smiley")
		icon_state = "ai-smiley"
	else if(icontype == "Angry")
		icon_state = "ai-angryface"
	else if(icontype == "Dorf")
		icon_state = "ai-dorf"
	else if(icontype == "Bliss")
		icon_state = "ai-bliss"
	else if(icontype == "B.A.N.N.E.D.")
		icon_state = "ai-banned"
	else if(icontype == "Red")
		icon_state = "ai-malf"
	else if(icontype == "Static")
		icon_state = "ai-static"
	else//(icontype == "Matrix")
		icon_state = "ai-matrix"

	//else
			//usr <<"You can only change your display once!"
			//return

/mob/living/silicon/ai/Stat()
	..()
	statpanel("Status")
	if (client.statpanel == "Status")
		if(emergency_shuttle.online && emergency_shuttle.location < 2)
			var/timeleft = emergency_shuttle.timeleft()
			if (timeleft)
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

		if(ticker.mode.name == "AI malfunction")
			var/datum/game_mode/malfunction/malf = ticker.mode
			for (var/datum/mind/malfai in malf.malf_ai)
				if (mind == malfai)
					if (malf.apcs >= 3)
						stat(null, "Time until station control secured: [max(malf.AI_win_timeleft/(malf.apcs/3), 0)] seconds")

		if(!stat)
			stat(null, text("System integrity: [(health+100)/2]%"))
		else
			stat(null, text("Systems nonfunctional"))

/mob/living/silicon/ai/proc/ai_alerts()
	set category = "AI Commands"
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[src];mach_close=aialerts'>Close</A><BR><BR>"
	for (var/cat in alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/L = alarms[cat]
		if (L.len)
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/C = alm[2]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				if (C && istype(C, /list))
					var/dat2 = ""
					for (var/obj/machinery/camera/I in C)
						dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (dat2=="") ? "" : " | ", src, I, I.c_tag)
					dat += text("-- [] ([])", A.name, (dat2!="") ? dat2 : "No Camera")
				else if (C && istype(C, /obj/machinery/camera))
					var/obj/machinery/camera/Ctmp = C
					dat += text("-- [] (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", A.name, src, C, Ctmp.c_tag)
				else
					dat += text("-- [] (No Camera)", A.name)
				if (sources.len > 1)
					dat += text("- [] sources", sources.len)
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

/mob/living/silicon/ai/proc/ai_roster()
	set category = "AI Commands"
	set name = "Show Crew Manifest"

	var/dat = "<html><head><title>Crew Roster</title></head><body><b>Crew Roster:</b><br><br>"

	for (var/datum/data/record/t in data_core.general)
		dat += "[t.fields["name"]] - [t.fields["rank"]]<br>"

	dat += "</body></html>"

	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

/mob/living/silicon/ai/proc/ai_cancel_call()
	set category = "AI Commands"
	if(usr.stat == 2)
		usr << "You can't send the shuttle back because you are dead!"
		return
	cancel_call_proc(src)
	return

/mob/living/silicon/ai/check_eye(var/mob/user as mob)
	if (!current)
		return null
	user.reset_view(current)
	return 1

/mob/living/silicon/ai/blob_act()
	if (stat != 2)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if (prob(30))
		switch(pick(1,2))
			if(1)
				cancel_camera()
			if(2)
				ai_call_shuttle()
	..()

/mob/living/silicon/ai/ex_act(severity)
	flick("flash", flash)

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)

	updatehealth()


/mob/living/silicon/ai/Topic(href, href_list)
	..()
	if (href_list["mach_close"])
		if (href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		machine = null
		src << browse(null, t1)
	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"]))
	if (href_list["showalerts"])
		ai_alerts()

	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				src << "<span class='notice'>Unable to locate the holopad.</span>"

	if (href_list["lawc"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawc"])
		switch(lawcheck[L+1])
			if ("Yes") lawcheck[L+1] = "No"
			if ("No") lawcheck[L+1] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if (href_list["lawi"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawi"])
		switch(ioncheck[L])
			if ("Yes") ioncheck[L] = "No"
			if ("No") ioncheck[L] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if (href_list["laws"]) // With how my law selection code works, I changed statelaws from a verb to a proc, and call it through my law selection panel. --NeoFite
		statelaws()

	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		return

	else if (href_list["faketrack"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)

			A:cameraFollow = target
			A << text("Now tracking [] on camera.", target.name)
			if (usr.machine == null)
				usr.machine = usr

			while (usr:cameraFollow == target)
				usr << "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb)."
				sleep(40)
				continue

		return

	return

/mob/living/silicon/ai/meteorhit(obj/O as obj)
	for(var/mob/M in viewers(src, null))
		M.show_message(text("\red [] has been hit by []", src, O), 1)
		//Foreach goto(19)
	if (health > 0)
		adjustBruteLoss(30)
		if ((O.icon_state == "flaming"))
			adjustFireLoss(40)
		updatehealth()
	return

/mob/living/silicon/ai/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	updatehealth()
	return 2

/mob/living/silicon/ai/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	switch(M.a_intent)

		if ("help")
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\blue [M] caresses [src]'s plating with its scythe like arm."), 1)

		else //harm
			var/damage = rand(10, 20)
			if (prob(90))
				playsound(loc, 'slash.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has slashed at []!</B>", M, src), 1)
				if(prob(8))
					flick("noise", flash)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'slashmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] took a swipe at []!</B>", M, src), 1)
	return

/mob/living/silicon/ai/attack_hand(mob/living/carbon/M as mob)
	if(ishuman(M))//Checks to see if they are ninja
		if(istype(M:gloves, /obj/item/clothing/gloves/space_ninja)&&M:gloves:candrain&&!M:gloves:draining)
			if(M:wear_suit:s_control)
				M:wear_suit:transfer_ai("AICORE", "NINJASUIT", src, M)
			else
				M << "\red <b>ERROR</b>: \black Remote access channel disabled."
	return


/mob/living/silicon/ai/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()



/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	usr:cameraFollow = null
	if (!C)
		machine = null
		reset_view(null)
		return 0
	if (stat == 2 || !C.status || !(C.network in src.networks) ) return 0

	// ok, we're alive, camera is good and in our network...

	if(client.eye == eyeobj)
		eyeobj.loc = C.loc
	else
		machine = src
		src:current = C
		reset_view(C)
	return 1

/mob/living/silicon/ai/proc/triggerUnmarkedAlarm(var/class, area/A, var/O)
	if(stat == 2) // stat = 2 = dead AI
		return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	var/alarmtext = ""
	if(class == "AirlockHacking") // In case more unmarked alerts would be added eventually;
		alarmtext = "--- Unauthorized remote access detected"
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	if (A)
		alarmtext += " in " + A.name
		if (O)
			if (C && C.status)
				alarmtext += text("! (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", src, C, C.c_tag)
			else if (CL && CL.len)
				var/foo = 0
				var/dat2 = ""
				for (var/obj/machinery/camera/I in CL)
					dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (!foo) ? "" : " | ", src, I, I.c_tag)
					foo = 1
				alarmtext += text("! ([])", dat2)
			else
				alarmtext += "! (No Camera)"
		else
			alarmtext += "! (No Camera)"
	else
		alarmtext += "!"
	src << alarmtext
	return 1

/mob/living/silicon/ai/triggerAlarm(var/class, area/A, var/O, var/alarmsource)
	if (stat == 2)
		return 1
	var/list/L = alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	if (O)
		if (C && C.status)
			src << text("--- [] alarm detected in []! (<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>)", class, A.name, src, C, C.c_tag)
		else if (CL && CL.len)
			var/foo = 0
			var/dat2 = ""
			for (var/obj/machinery/camera/I in CL)
				dat2 += text("[]<A HREF=?src=\ref[];switchcamera=\ref[]>[]</A>", (!foo) ? "" : " | ", src, I, I.c_tag)
				foo = 1
			src << text ("--- [] alarm detected in []! ([])", class, A.name, dat2)
		else
			src << text("--- [] alarm detected in []! (No Camera)", class, A.name)
	else
		src << text("--- [] alarm detected in []! (No Camera)", class, A.name)
	if (viewalerts) ai_alerts()
	return 1

/mob/living/silicon/ai/cancelAlarm(var/class, area/A as area, obj/origin)
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	if (cleared)
		src << text("--- [] alarm in [] has been cleared.", class, A.name)
		if (viewalerts) ai_alerts()
	return !cleared

/mob/living/silicon/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"
	reset_view(null)
	machine = null
	src:cameraFollow = null

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/ai_network_change()
	set category = "AI Commands"
	set name = "Jump to Camera Network"
	reset_view(null)
	machine = null
	src:cameraFollow = null
	var/cameralist[0]

	if(usr.stat == 2)
		usr << "You can't change your camera network because you are dead!"
		return

	for (var/obj/machinery/camera/C in world)
		if(!C.status)
			continue
		if(C.network == "AI Satellite")
			if (ticker.mode.name == "AI malfunction")
				var/datum/game_mode/malfunction/malf = ticker.mode
				for (var/datum/mind/M in malf.malf_ai)
					if (mind == M)
						cameralist[C.network] = C.network
		else
			if(C.network != "CREED" && C.network != "thunder" && C.network != "Prison" )
				cameralist[C.network] = C.network

	var/newnet = input(usr, "Which network would you like to view?") as null|anything in cameralist

	cameralist = new/list
	for(var/obj/machinery/camera/C in world)
		if(C.network == newnet)
			cameralist.Add(C)

	switchCamera( pick(cameralist) )
	src << "\blue Jumped to [newnet] camera network."
//End of code by Mord_Sith
//cael - with the multiple onstation networks all linked together, changing networks is legacy functionality
//so i recycled it to instantly jump to any network


/mob/living/silicon/ai/proc/choose_modules()
	set category = "Malfunction"
	set name = "Choose Module"

	malf_picker.use(src)

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in data_core.locked)//Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				del(holo_icon)//Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face"
		)
		input = input("Please select a hologram:") as null|anything in icon_list
		if(input)
			del(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('AI.dmi',"holo2"))
	return

/mob/living/silicon/ai/proc/corereturn()
	set category = "Malfunction"
	set name = "Return to Main Core"

	var/obj/machinery/power/apc/apc = src.loc
	if(!istype(apc))
		src << "\blue You are already in your Main Core."
		return
	apc.malfvacate()