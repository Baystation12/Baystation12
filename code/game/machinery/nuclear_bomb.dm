var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!"
	icon = 'icons/obj/nuke.dmi'
	icon_state = "idle"
	density = TRUE
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	unacidable = TRUE
	interact_offline = TRUE

	var/deployable = 0
	var/extended = 0
	var/lighthack = 0
	var/timeleft = 120
	var/minTime = 120
	var/maxTime = 600
	var/timing = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0
	var/safety = 1
	var/obj/item/disk/nuclear/auth = null
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	var/previous_level = ""
	wires = /datum/wires/nuclearbomb
	var/decl/security_level/original_level

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.

/obj/machinery/nuclearbomb/Destroy()
	qdel(auth)
	auth = null
	return ..()

/obj/machinery/nuclearbomb/Process(var/wait)
	if(timing)
		timeleft = max(timeleft - (wait / 10), 0)
		playsound(loc, 'sound/items/timer.ogg', 50)
		if(timeleft <= 0)
			addtimer(CALLBACK(src, .proc/explode), 0)
		SSnano.update_uis(src)

/obj/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob, params)
	if(isScrewdriver(O))
		add_fingerprint(user)
		if(auth)
			if(panel_open == 0)
				panel_open = 1
				overlays |= "panel_open"
				to_chat(user, "You unscrew the control panel of [src].")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			else
				panel_open = 0
				overlays -= "panel_open"
				to_chat(user, "You screw the control panel of [src] back on.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		else
			if(panel_open == 0)
				to_chat(user, "\The [src] emits a buzzing noise, the panel staying locked in.")
			if(panel_open == 1)
				panel_open = 0
				overlays -= "panel_open"
				to_chat(user, "You screw the control panel of \the [src] back on.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			flick("lock", src)
		return

	if(panel_open && isMultitool(O) || isWirecutter(O))
		return attack_hand(user)

	if(extended)
		if(istype(O, /obj/item/disk/nuclear))
			if(!user.unEquip(O, src))
				return
			auth = O
			add_fingerprint(user)
			return attack_hand(user)

	if(anchored)
		switch(removal_stage)
			if(0)
				if(isWelder(O))
					var/obj/item/weldingtool/WT = O
					if(!WT.isOn()) return
					if(WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [O]...")

					if(do_after(user,40, src))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("\The [user] cuts through the bolt covers on \the [src].", "You cut through the bolt cover.")
						removal_stage = 1
				return

			if(1)
				if(isCrowbar(O))
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [O]...")

					if(do_after(user, 15, src))
						if(!src || !user) return
						user.visible_message("\The [user] forces open the bolt covers on \the [src].", "You force open the bolt covers.")
						removal_stage = 2
				return

			if(2)
				if(isWelder(O))
					var/obj/item/weldingtool/WT = O
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting apart the anchoring system sealant on [src].", "You start cutting apart the anchoring system's sealant with [O]...")

					if(do_after(user, 40, src))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("\The [user] cuts apart the anchoring system sealant on \the [src].", "You cut apart the anchoring system's sealant.")
						removal_stage = 3
				return

			if(3)
				if(isWrench(O))
					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")
					if(do_after(user, 50, src))
						if(!src || !user) return
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
				return

			if(4)
				if(isCrowbar(O))
					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")
					if(do_after(user, 80, src))
						if(!src || !user) return
						user.visible_message("\The [user] crowbars \the [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						anchored = FALSE
						removal_stage = 5
				return
	..()

/obj/machinery/nuclearbomb/physical_attack_hand(mob/user)
	if(!extended && deployable)
		. = TRUE
		if(removal_stage < 5)
			src.anchored = TRUE
			visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring!</span>")
		else
			visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
		extended = 1
		if(!src.lighthack)
			flick("lock", src)
			update_icon()	

/obj/machinery/nuclearbomb/interface_interact(mob/user as mob)
	if(extended && !panel_open)
		ui_interact(user)
		return TRUE

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["hacking"] = 0
	data["auth"] = is_auth(user)
	data["moveable_anchor"] = !istype(src, /obj/machinery/nuclearbomb/station)
	if(is_auth(user))
		if(yes_code)
			data["authstatus"] = timing ? "Functional/Set" : "Functional"
		else
			data["authstatus"] = "Auth. S2"
	else
		if(timing)
			data["authstatus"] = "Set"
		else
			data["authstatus"] = "Auth. S1"
	data["safe"] = safety ? "Safe" : "Engaged"
	data["time"] = timeleft
	data["timer"] = timing
	data["safety"] = safety
	data["anchored"] = anchored
	data["yescode"] = yes_code
	data["message"] = "AUTH"
	if(is_auth(user))
		data["message"] = code
		if(yes_code)
			data["message"] = "*****"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl", "Nuke Control Panel", 300, 510)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/nuclearbomb/verb/toggle_deployable()
	set category = "Object"
	set name = "Toggle Deployable"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if(deployable)
		to_chat(usr, "<span class='warning'>You close several panels to make [src] undeployable.</span>")
		deployable = 0
	else
		to_chat(usr, "<span class='warning'>You adjust some panels to make [src] deployable.</span>")
		deployable = 1
	return

/obj/machinery/nuclearbomb/proc/is_auth(var/mob/user)
	if(auth)
		return 1
	if(user.can_admin_interact())
		return 1
	return 0

/obj/machinery/nuclearbomb/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["auth"])
		if(auth)
			auth.forceMove(loc)
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/disk/nuclear))
				if(!usr.unEquip(I, src))
					return 1
				auth = I
	if(is_auth(usr))
		if(href_list["type"])
			if(href_list["type"] == "E")
				if(code == r_code)
					yes_code = 1
					code = null
					log_and_message_admins("has armed \the [src]")
				else
					code = "ERROR"
			else
				if(href_list["type"] == "R")
					yes_code = 0
					code = null
				else
					lastentered = text("[]", href_list["type"])
					if(text2num(lastentered) == null)
						log_and_message_admins("tried to exploit a nuclear bomb by entering non-numerical codes")
					else
						code += lastentered
						if(length(code) > 5)
							code = "ERROR"
		if(yes_code)
			if(href_list["time"])
				if(timing)
					to_chat(usr, "<span class='warning'>Cannot alter the timing during countdown.</span>")
					return

				var/time = text2num(href_list["time"])
				timeleft += time
				timeleft = clamp(timeleft, minTime, maxTime)
			if(href_list["timer"])
				if(timing == -1)
					return 1
				if(!anchored)
					to_chat(usr, "<span class='warning'>\The [src] needs to be anchored.</span>")
					return 1
				if(safety)
					to_chat(usr, "<span class='warning'>The safety is still on.</span>")
					return 1
				if(wires.IsIndexCut(NUCLEARBOMB_WIRE_TIMING))
					to_chat(usr, "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>")
					return 1
				if(!timing && !safety)
					start_bomb()
				else
					check_cutoff()
			if(href_list["safety"])
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					to_chat(usr, "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>")
					return 1
				safety = !safety
				if(safety)
					secure_device()
				update_icon()
			if(href_list["anchor"])
				if(removal_stage == 5)
					anchored = FALSE
					visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
					return 1

				if(!isinspace())
					anchored = !anchored
					if(anchored)
						visible_message("<span class='warning'>With a steely snap, bolts slide out of \the [src] and anchor it to the flooring.</span>")
					else
						secure_device()
						visible_message("<span class='warning'>The anchoring bolts slide back into the depths of \the [src].</span>")
				else
					to_chat(usr, "<span class='warning'>There is nothing to anchor to!</span>")
	return 1

/obj/machinery/nuclearbomb/proc/start_bomb()
	timing = 1
	log_and_message_admins("activated the detonation countdown of \the [src]")
	bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	original_level = security_state.current_security_level
	security_state.set_security_level(security_state.severe_security_level, TRUE)
	update_icon()

/obj/machinery/nuclearbomb/proc/check_cutoff()
	secure_device()

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	security_state.set_security_level(original_level, TRUE)
	bomb_set--
	safety = TRUE
	timing = 0
	timeleft = clamp(timeleft, minTime, maxTime)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if (safety)
		timing = 0
		return
	timing = -1
	yes_code = 0
	safety = 1
	update_icon()

	SetUniversalState(/datum/universal_state/nuclear_explosion, arguments=list(src))

/obj/machinery/nuclearbomb/on_update_icon()
	if(lighthack)
		icon_state = "idle"
	else if(timing == -1)
		icon_state = "exploding"
	else if(timing)
		icon_state = "urgent"
	else if(extended || !safety)
		icon_state = "greenlight"
	else
		icon_state = "idle"

//====The nuclear authentication disc====
/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/disk/nuclear/Initialize()
	. = ..()
	nuke_disks |= src
	// Can never be quite sure that a game mode has been properly initiated or not at this point, so always register
	GLOB.moved_event.register(src, src, /obj/item/disk/nuclear/proc/check_z_level)

/obj/item/disk/nuclear/proc/check_z_level()
	if(!(istype(SSticker.mode, /datum/game_mode/nuclear)))
		GLOB.moved_event.unregister(src, src, /obj/item/disk/nuclear/proc/check_z_level) // However, when we are certain unregister if necessary
		return
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		qdel(src)

/obj/item/disk/nuclear/Destroy()
	GLOB.moved_event.unregister(src, src, /obj/item/disk/nuclear/proc/check_z_level)
	nuke_disks -= src
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
	return ..()

//====the nuclear football (holds the disk and instructions)====
/obj/item/storage/secure/briefcase/nukedisk
	desc = "A large briefcase with a digital locking system."
	startswith = list(
		/obj/item/disk/nuclear,
		/obj/item/pinpointer,
		/obj/item/folder/envelope/nuke_instructions,
		/obj/item/modular_computer/laptop/preset/custom_loadout/cheap/
	)

/obj/item/storage/secure/briefcase/nukedisk/examine(mob/user)
	. = ..()
	to_chat(user,"On closer inspection, you see \a [GLOB.using_map.company_name] emblem is etched into the front of it.")

/obj/item/folder/envelope/nuke_instructions
	name = "instructions envelope"
	desc = "A small envelope. The label reads 'open only in event of high emergency'."

/obj/item/folder/envelope/nuke_instructions/Initialize()
	. = ..()
	var/obj/item/paper/R = new(src)
	R.set_content("<center><img src=sollogo.png><br><br>\
	<b>Warning: Classified<br>[GLOB.using_map.station_name] Self-Destruct System - Instructions</b></center><br><br>\
	In the event of a Delta-level emergency, this document will guide you through the activation of the vessel's \
	on-board nuclear self-destruct system. Please read carefully.<br><br>\
	1) (Optional) Announce the imminent activation to any surviving crew members, and begin evacuation procedures.<br>\
	2) Notify two heads of staff, both with ID cards with access to the ship's Keycard Authentication Devices.<br>\
	3) Proceed to the self-destruct chamber, located on Deck One by the stairwell.<br>\
	4) Unbolt the door and enter the chamber.<br>\
	5) Both heads of staff should stand in front of their own Keycard Authentication Devices. On the KAD interface, select \
	Grant Nuclear Authentication Code. Both heads of staff should then swipe their ID cards simultaneously.<br>\
	6) The KAD will now display the Authentication Code. Memorize this code.<br>\
	7) Insert the nuclear authentication disk into the self-destruct terminal.<br>\
	8) Enter the code into the self-destruct terminal.<br>\
	9) Authentication procedures are now complete. Open the two cabinets containing the nuclear cylinders. They are \
	located on the back wall of the chamber.<br>\
	10) Place the cylinders upon the six nuclear cylinder inserters.<br>\
	11) Activate the inserters. The cylinders will be pulled down into the self-destruct system.<br>\
	12) Return to the terminal. Enter the desired countdown time.<br>\
	13) When ready, disable the safety switch.<br>\
	14) Start the countdown.<br><br>\
	This concludes the instructions.", "vessel self-destruct instructions")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	R.stamped += /obj/item/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

//====vessel self-destruct system====
/obj/machinery/nuclearbomb/station
	name = "self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'icons/obj/nuke_station.dmi'
	anchored = TRUE
	deployable = 1
	extended = 1

	var/list/flash_tiles = list()
	var/list/inserters = list()
	var/last_turf_state

	var/announced = 0
	var/time_to_explosion = 0
	var/self_destruct_cutoff = 60 //Seconds
	timeleft = 300 
	minTime = 300
	maxTime = 900

/obj/machinery/nuclearbomb/station/Initialize()
	. = ..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	for(var/turf/simulated/floor/T in get_area(src))
		if(istype(T.flooring, /decl/flooring/reinforced/circuit/red))
			flash_tiles += T
	update_icon()
	for(var/obj/machinery/self_destruct/ch in get_area(src))
		inserters += ch

/obj/machinery/nuclearbomb/station/attackby(obj/item/O as obj, mob/user as mob)
	if(isWrench(O))
		return

/obj/machinery/nuclearbomb/station/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["anchor"])
		return

/obj/machinery/nuclearbomb/station/start_bomb()
	for(var/inserter in inserters)
		var/obj/machinery/self_destruct/sd = inserter
		if(!istype(sd) || !sd.armed)
			to_chat(usr, "<span class='warning'>An inserter has not been armed or is damaged.</span>")
			return
	visible_message("<span class='warning'>Warning. The self-destruct sequence override will be disabled [self_destruct_cutoff] seconds before detonation.</span>")
	..()

/obj/machinery/nuclearbomb/station/check_cutoff()
	if(timeleft <= self_destruct_cutoff)
		visible_message("<span class='warning'>Self-Destruct abort is no longer possible.</span>")
		return
	..()

/obj/machinery/nuclearbomb/station/Destroy()
	flash_tiles.Cut()
	return ..()

/obj/machinery/nuclearbomb/station/Process()
	..()
	if(timeleft > 0 && GAME_STATE < RUNLEVEL_POSTGAME)
		if(timeleft <= self_destruct_cutoff)
			if(!announced)
				priority_announcement.Announce("The self-destruct sequence has reached terminal countdown, abort systems have been disabled.", "Self-Destruct Control Computer")
				announced = 1
			if(world.time >= time_to_explosion)
				var/range
				var/high_intensity
				var/low_intensity
				if(timeleft <= (self_destruct_cutoff/2))
					range = rand(2, 3)
					high_intensity = rand(5,8)
					low_intensity = rand(7,10)
					time_to_explosion = world.time + 2 SECONDS
				else
					range = rand(1, 2)
					high_intensity = rand(3, 6)
					low_intensity = rand(5, 8)
					time_to_explosion = world.time + 5 SECONDS
				var/turf/T = pick_area_and_turf(GLOB.is_station_but_not_space_or_shuttle_area)
				explosion(T, range, high_intensity, low_intensity)

/obj/machinery/nuclearbomb/station/secure_device()
	..()
	announced = 0

/obj/machinery/nuclearbomb/station/on_update_icon()
	var/target_icon_state
	if(lighthack)
		target_icon_state = "rcircuit_off"
		icon_state = "idle"
	else if(timing == -1)
		target_icon_state = "rcircuitanim"
		icon_state = "exploding"
	else if(timing)
		target_icon_state = "rcircuitanim"
		icon_state = "urgent"
	else if(!safety)
		target_icon_state = "rcircuit"
		icon_state = "greenlight"
	else
		target_icon_state = "rcircuit_off"
		icon_state = "idle"

	if(!last_turf_state || target_icon_state != last_turf_state)
		for(var/thing in flash_tiles)
			var/turf/simulated/floor/T = thing
			if(!istype(T.flooring, /decl/flooring/reinforced/circuit/red))
				flash_tiles -= T
				continue
			T.icon_state = target_icon_state
		last_turf_state = target_icon_state
