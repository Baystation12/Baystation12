var/bomb_set

//Code to pick a random pass-phrase for Project Orion
var/global/orion_password = null
/proc/get_orion_password()
	if (orion_password)
		return orion_password

	var/name = ""

	name += pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Gamma", "Zulu")
	name += "-" + pick("Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Yankee")
	name += "-" + pick("Oscar", "Papa", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "Xray")
	name += "-" + pick("1","2","3","4","5","6","7","8","9","0")
	name += pick("1","2","3","4","5","6","7","8","9","0")
	name += pick("1","2","3","4","5","6","7","8","9","0")
	orion_password = name

	return name

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/nuke.dmi'
	icon_state = "idle"
	density = 1
	use_power = 0
	unacidable = 1

	var/deployable = 0
	var/extended = 0
	var/lighthack = 0
	var/timeleft = 120
	var/timing = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0
	var/safety = 1
	var/obj/item/weapon/disk/nuclear/auth = null
	var/removal_stage = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	var/previous_level = ""
	var/datum/wires/nuclearbomb/wires = null

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.
	wires = new/datum/wires/nuclearbomb(src)

/obj/machinery/nuclearbomb/Destroy()
	qdel(wires)
	wires = null
	qdel(auth)
	auth = null
	return ..()

/obj/machinery/nuclearbomb/process()
	if (timing)
		timeleft = max(timeleft - (process_schedule_interval("machinery") / 10), 0)
		if (timeleft <= 0)
			spawn
				explode()
		GLOB.nanomanager.update_uis(src)

/obj/machinery/nuclearbomb/attackby(obj/item/weapon/O as obj, mob/user as mob, params)
	if (istype(O, /obj/item/weapon/screwdriver))
		src.add_fingerprint(user)
		if (src.auth)
			if (panel_open == 0)
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
			if (panel_open == 0)
				to_chat(user, "\The [src] emits a buzzing noise, the panel staying locked in.")
			if (panel_open == 1)
				panel_open = 0
				overlays -= "panel_open"
				to_chat(user, "You screw the control panel of \the [src] back on.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			flick("lock", src)
		return

	if (panel_open && (istype(O, /obj/item/device/multitool) || istype(O, /obj/item/weapon/wirecutters)))
		return attack_hand(user)

	if (src.extended)
		if (istype(O, /obj/item/weapon/disk/nuclear))
			usr.drop_item()
			O.forceMove(src)
			src.auth = O
			src.add_fingerprint(user)
			return attack_hand(user)

	if (src.anchored)
		switch(removal_stage)
			if(0)
				if(istype(O,/obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
						return

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [O]...")

					if(do_after(user,40, src))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("\The [user] cuts through the bolt covers on \the [src].", "You cut through the bolt cover.")
						removal_stage = 1
				return

			if(1)
				if(istype(O,/obj/item/weapon/crowbar))
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [O]...")

					if(do_after(user, 15, src))
						if(!src || !user) return
						user.visible_message("\The [user] forces open the bolt covers on \the [src].", "You force open the bolt covers.")
						removal_stage = 2
				return

			if(2)
				if(istype(O,/obj/item/weapon/weldingtool))

					var/obj/item/weapon/weldingtool/WT = O
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
				if(istype(O,/obj/item/weapon/wrench))

					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")

					if(do_after(user, 50, src))
						if(!src || !user) return
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
				return

			if(4)
				if(istype(O,/obj/item/weapon/crowbar))

					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")

					if(do_after(user, 80, src))
						if(!src || !user) return
						user.visible_message("\The [user] crowbars \the [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
						anchored = 0
						removal_stage = 5
				return
	..()

/obj/machinery/nuclearbomb/attack_ghost(mob/user as mob)
	attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if (extended)
		if (panel_open)
			wires.Interact(user)
		else
			ui_interact(user)
	else if (deployable)
		if(removal_stage < 5)
			src.anchored = 1
			visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring!</span>")
		else
			visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
		extended = 1
		if(!src.lighthack)
			flick("lock", src)
			update_icon()
	return

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["hacking"] = 0
	data["auth"] = is_auth(user)
	if (is_auth(user))
		if (yes_code)
			data["authstatus"] = timing ? "Functional/Set" : "Functional"
		else
			data["authstatus"] = "Auth. S2"
	else
		if (timing)
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
	if (is_auth(user))
		data["message"] = code
		if (yes_code)
			data["message"] = "*****"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
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

	if (src.deployable)
		to_chat(usr, "<span class='warning'>You close several panels to make [src] undeployable.</span>")
		src.deployable = 0
	else
		to_chat(usr, "<span class='warning'>You adjust some panels to make [src] deployable.</span>")
		src.deployable = 1
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

	if (href_list["auth"])
		if (auth)
			auth.forceMove(loc)
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/disk/nuclear))
				usr.drop_item()
				I.forceMove(src)
				auth = I
	if (is_auth(usr))
		if (href_list["type"])
			if (href_list["type"] == "E")
				if (code == r_code)
					yes_code = 1
					code = null
					log_and_message_admins("has armed \the [src]")
				else
					code = "ERROR"
			else
				if (href_list["type"] == "R")
					yes_code = 0
					code = null
				else
					lastentered = text("[]", href_list["type"])
					if (text2num(lastentered) == null)
						log_and_message_admins("tried to exploit a nuclear bomb by entering non-numerical codes")
					else
						code += lastentered
						if (length(code) > 5)
							code = "ERROR"
		if (yes_code)
			if (href_list["time"])
				if (timing)
					to_chat(usr, "<span class='warning'>Cannot alter the timing during countdown.</span>")
					return

				var/time = text2num(href_list["time"])
				timeleft += time
				timeleft = Clamp(timeleft, 120, 600)
			if (href_list["timer"])
				if (timing == -1)
					return 1
				if (!anchored)
					to_chat(usr, "<span class='warning'>\The [src] needs to be anchored.</span>")
					return 1
				if (safety)
					to_chat(usr, "<span class='warning'>The safety is still on.</span>")
					return 1
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_TIMING))
					to_chat(usr, "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>")
					return 1

				if (!timing && !safety)
					timing = 1
					log_and_message_admins("activated the detonation countdown of \the [src]")
					bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
					update_icon()
				else
					secure_device()
			if (href_list["safety"])
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					to_chat(usr, "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>")
					return 1
				safety = !safety
				if(safety)
					secure_device()
				update_icon()
			if (href_list["anchor"])
				if(removal_stage == 5)
					anchored = 0
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

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return

	bomb_set--
	safety = TRUE
	timing = 0
	timeleft = Clamp(timeleft, 120, 600)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/explode()
	if (src.safety)
		timing = 0
		return
	src.timing = -1
	src.yes_code = 0
	src.safety = 1
	update_icon()

	SetUniversalState(/datum/universal_state/nuclear_explosion, arguments=list(src))

/obj/machinery/nuclearbomb/update_icon()
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
/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

/obj/item/weapon/disk/nuclear/New()
	..()
	nuke_disks |= src

/obj/item/weapon/disk/nuclear/Initialize()
	. = ..()
	// Can never be quite sure that a game mode has been properly initiated or not at this point, so always register
	GLOB.moved_event.register(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level)

/obj/item/weapon/disk/nuclear/proc/check_z_level()
	if(!(ticker && istype(ticker.mode, /datum/game_mode/nuclear)))
		GLOB.moved_event.unregister(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level) // However, when we are certain unregister if necessary
		return
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		qdel(src)

/obj/item/weapon/disk/nuclear/Destroy()
	GLOB.moved_event.unregister(src, src, /obj/item/weapon/disk/nuclear/proc/check_z_level)
	nuke_disks -= src
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/weapon/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
	return ..()

/obj/machinery/nuclearbomb/station
	name = "self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'icons/obj/nuke_station.dmi'
	anchored = 1
	deployable = 1
	extended = 1

	var/list/flash_tiles = list()
	var/last_turf_state

/obj/machinery/nuclearbomb/station/Initialize()
	. = ..()
	verbs -= /obj/machinery/nuclearbomb/verb/toggle_deployable
	for(var/turf/simulated/floor/T in trange(1, src))
		T.set_flooring(get_flooring_data(/decl/flooring/reinforced/circuit/red))
		flash_tiles += T
	update_icon()

/obj/machinery/nuclearbomb/station/Destroy()
	flash_tiles.Cut()
	return ..()

/obj/machinery/nuclearbomb/station/update_icon()
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

/obj/item/weapon/folder/envelope/nuke_instructions
	name = "instructions envelope"
	desc = "A small envelope. The label reads 'open only in event of high emergency'."

/obj/item/weapon/folder/envelope/nuke_instructions/Initialize()
	. = ..()
	var/obj/item/weapon/paper/R = new(src)
	R.set_content("<center><img src=sollogo.png><br><br>\
	<b>CLASSIFICATION: TOP SECRET<br>Debrief on activation of United Nations Space Command Emergency Priority Order 098831A-1</b></center><br><br>\
	In the event of an alien boarding party, this document will guide you through the activation of the vessel's \
	on-board nuclear self destruct system. Please read carefully.<br><br>\
	1) Order the enlisted men to secure the terminal, evacuate the Officers.<br>\
	2) Notify your Executive officer about the Emergency Priority Order.<br>\
	3) Proceed to the self-destruct chamber with your Executive Officer, located on Deck Three by the medbay.<br>\
	4) Open the shutters and enter the chamber.<br>\
	5) You and your Executive Officer should stand in front of each Keycard Authentication Device. On the KAD interface, select \
	Activate Protocol 098831A1. Then swipe your ID cards simultaneously.<br>\
	6) The KAD will now display the Authentication Code. Memorize this code.<br>\
	7) Insert the authentication disk into the self-destruct terminal.<br>\
	8) Enter the code into the self-destruct terminal.<br>\
	9) Authentication procedures are now complete.<br>\
	10) Enter the desired countdown time.<br>\
	11) When ready, disable the safety switch.<br>\
	12) Start the countdown.<br><br>\
	This concludes the instructions.")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	R.stamped += /obj/item/weapon/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

/obj/item/weapon/folder/nt/rd

/obj/item/weapon/folder/envelope/project_orion
	name= "Top-Secret"
	desc = "A thick envelope. The UNSC logo is stamped in the corner, along with 'TOP-SECRET-ORION'."
//Project Orion Envelope for researchers
/obj/item/weapon/folder/envelope/project_orion/Initialize()
	. = ..()
	var/obj/item/weapon/paper/projectorion = new(src)
	projectorion.set_content("<tt><center><b><font color='red'>CONFIDENTIAL: RESEARCHERS ONLY</font></b>\
	<h3>Office of Naval Intelligence</h3>\
	<img src = ntlogo.png>\
	</center>\
	<b>FROM:</b> I.N.G. <br>\
	<b>TO:</b> Research Director of Exo-Research Outpost<br>\
	<b>SUBJECT:</b>Project Orion<br>\
	<hr>\
	We have determined to institute Project Orion and attempt to create genetically modified supersoldiers to aid in UNSC operations.<br>\
	Seeing as how your research station is relatively remote and little to nothing happens there we have decided it best you spearhead this project at this current time. This may change at a later date however.<br><br>\
	Due to the nature of Project Orion, you will be required to requisition volunteers from stationed infantry forces in the system, or if necessary, 'borrow' a specimen you deem to be capable from a nearby colony as a test subject for the augmentation process. We advise you only pick subjects with a military background who are especially gifted or talented in the use of a wide range of weaponry, and are capable and willing to follow orders. The confidentialy of this Project is paramount to your continued employment, and life expectancy within the ONI research division.<br><br>\
	We have placed the required surgical assets into the surgery rooms located east of the Weapons Testing Lab. We feel these items will be sufficient as the final product will be considered a living weapon and is likely to be a highly lethal and decisive utlility on the battlefield.<br>\
	The required armor and equipment have been stored inside of the weapons testing lab in the corresponding lockers.<br><br>\
	We are expecting great results from this project as it's successful implementation will immensely bolster our military assets on the ground, when you are done reading this document be sure to burn it in order to eliminate any trace of this project's paper trail. You have full authority to destroy the Project Orion Laboratory should it be discovered, as well as any assets attached to Project Orion.<br><br>\
	If you are successful in enabling Project Orion then you will be tasked with procedurally testing Project Orion in live military operations at your descretion.<br><br>\
	You will have limited authority to request transport for Project Orion utilizing local military vessels in the system via the following clearance phrase.<br><br>\
	'[get_orion_password()]'<br><br>\
	Any high command aboard local military vessels within the sector should be directed towards documents kept in their personal quarters or abord their bridge to verify this code and should allow Project Orion limited use of their facilites and armory during active operations.<br><br>\
	If the Project Orion subject is designate as AWOL, Unstable, Unusable, or a threat to UNSC or ONI personel you are granted the authority to initate a man hunt or, if needed, order the execution of the Project Orion Specimen. In these cases all Project Orion assets should be reclaimed if possible, or destroyed on-site ASAP.<br><br>\
	Do not disappoint us.<br><br><br>\
	<i>I.N.G.</i></tt>")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	projectorion.stamped += /obj/item/weapon/stamp
	projectorion.overlays += stampoverlay
	projectorion.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"


	//Project Orion Envelope for Naval High Command
/obj/item/weapon/folder/envelope/orion_code
	name= "Top-Secret - Orion Code"
	desc = "A thick envelope. The UNSC logo is stamped in the corner, along with 'TOP-SECRET'."

/obj/item/weapon/folder/envelope/orion_code/Initialize()
	. = ..()
	var/obj/item/weapon/paper/orioncode = new(src)
	orioncode.set_content("<tt><center><b><font color='red'>CONFIDENTIAL: Naval High Command ONLY</font></b>\
	<h3>Office of Naval Intelligence</h3>\
	<img src = ntlogo.png>\
	</center>\
	<b>FROM:</b> I.N.G. <br>\
	<b>TO:</b> Bridge Command<br>\
	<b>SUBJECT:</b>Orion Code<br>\
	We have tasked our Exo-Research station with a special project the details of which are only revealed on a need-to-know basis. This document exists solely to inform you of the following pass-phrase.<br><br>\
	'[get_orion_password()]'<br><br>\
	When you are given this phrase by a certified member of the Exo-Research outpost you are to comply with their requests to a reasonable level of accountability. Any persons or equipment which may be transferred to your vessel after the reception of this pass-phrase are <font color='red'> NOT </font>to be considered under your command or in any way under your jurisdiction or a part of your vessels property.<br><br>\
	The lead scientist who has provided this pass-phrase will advise you on what to do should extenuating circumstances arise, and if any equipment or remains are required to be secured or destroyed by military personnel under your command.<br><br><br>\
	Do not disappoint us.<br><br><br>\
	<i>I.N.G.</i></tt>")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hos"
	orioncode.stamped += /obj/item/weapon/stamp
	orioncode.overlays += stampoverlay
	orioncode.stamps += "<HR><i>This paper has been stamped as 'Top Secret'.</i>"

//Gives the blank envelope a place to exist.
/obj/item/weapon/folder/envelope/blanks
	name= "Blank Envelope"
	desc = "A thick envelope."