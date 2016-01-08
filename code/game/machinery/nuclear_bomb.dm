var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1
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
	use_power = 0
	unacidable = 1
	var/previous_level = ""
	var/datum/wires/nuclearbomb/wires = null

/obj/machinery/nuclearbomb/New()
	..()
	r_code = "[rand(10000, 99999.0)]"//Creates a random code upon object spawn.
	wires = new/datum/wires/nuclearbomb(src)

/obj/machinery/nuclearbomb/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/nuclearbomb/process()
	if (src.timing)
		src.timeleft = max(timeleft - 2, 0) // 2 seconds per process()
		if (timeleft <= 0)
			spawn
				explode()
		nanomanager.update_uis(src)
	return

/obj/machinery/nuclearbomb/attackby(obj/item/weapon/O as obj, mob/user as mob, params)
	if (istype(O, /obj/item/weapon/screwdriver))
		src.add_fingerprint(user)
		if (src.auth)
			if (panel_open == 0)
				panel_open = 1
				overlays += image(icon, "npanel_open")
				user << "You unscrew the control panel of [src]."
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			else
				panel_open = 0
				overlays -= image(icon, "npanel_open")
				user << "You screw the control panel of [src] back on."
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		else
			if (panel_open == 0)
				user << "\The [src] emits a buzzing noise, the panel staying locked in."
			if (panel_open == 1)
				panel_open = 0
				overlays -= image(icon, "npanel_open")
				user << "You screw the control panel of \the [src] back on."
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			flick("nuclearbombc", src)
		return

	if (panel_open && (istype(O, /obj/item/device/multitool) || istype(O, /obj/item/weapon/wirecutters)))
		return attack_hand(user)

	if (src.extended)
		if (istype(O, /obj/item/weapon/disk/nuclear))
			usr.drop_item()
			O.loc = src
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
						user << "<span class='warning'>You need more fuel to complete this task.</span>"
						return

					user.visible_message("[user] starts cutting loose the anchoring bolt covers on [src].", "You start cutting loose the anchoring bolt covers with [O]...")

					if(do_after(user,40))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("[user] cuts through the bolt covers on [src].", "You cut through the bolt cover.")
						removal_stage = 1
				return

			if(1)
				if(istype(O,/obj/item/weapon/crowbar))
					user.visible_message("[user] starts forcing open the bolt covers on [src].", "You start forcing open the anchoring bolt covers with [O]...")

					if(do_after(user,15))
						if(!src || !user) return
						user.visible_message("[user] forces open the bolt covers on [src].", "You force open the bolt covers.")
						removal_stage = 2
				return

			if(2)
				if(istype(O,/obj/item/weapon/weldingtool))

					var/obj/item/weapon/weldingtool/WT = O
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						user << "<span class='warning'>You need more fuel to complete this task.</span>"
						return

					user.visible_message("[user] starts cutting apart the anchoring system sealant on [src].", "You start cutting apart the anchoring system's sealant with [O]...")

					if(do_after(user,40))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("[user] cuts apart the anchoring system sealant on [src].", "You cut apart the anchoring system's sealant.")
						removal_stage = 3
				return

			if(3)
				if(istype(O,/obj/item/weapon/wrench))

					user.visible_message("[user] begins unwrenching the anchoring bolts on [src].", "You begin unwrenching the anchoring bolts...")

					if(do_after(user,50))
						if(!src || !user) return
						user.visible_message("[user] unwrenches the anchoring bolts on [src].", "You unwrench the anchoring bolts.")
						removal_stage = 4
				return

			if(4)
				if(istype(O,/obj/item/weapon/crowbar))

					user.visible_message("[user] begins lifting [src] off of the anchors.", "You begin lifting the device off the anchors...")

					if(do_after(user,80))
						if(!src || !user) return
						user.visible_message("[user] crowbars [src] off of the anchors. It can now be moved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!")
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
			flick("nuclearbombc", src)
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

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		usr << "<span class='warning'>You close several panels to make [src] undeployable.</span>"
		src.deployable = 0
	else
		usr << "<span class='warning'>You adjust some panels to make [src] deployable.</span>"
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
			auth.loc = loc
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/disk/nuclear))
				usr.drop_item()
				I.loc = src
				auth = I
	if (is_auth(usr))
		if (href_list["type"])
			if (href_list["type"] == "E")
				if (code == r_code)
					yes_code = 1
					code = null
				else
					code = "ERROR"
			else
				if (href_list["type"] == "R")
					yes_code = 0
					code = null
				else
					lastentered = text("[]", href_list["type"])
					if (text2num(lastentered) == null)
						var/turf/LOC = get_turf(usr)
						message_admins("[key_name_admin(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: <a href='?_src_=vars;Vars=\ref[src]'>[lastentered]</a>! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
						log_admin("EXPLOIT: [key_name(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: [lastentered]!")
					else
						code += lastentered
						if (length(code) > 5)
							code = "ERROR"
		if (yes_code)
			if (href_list["time"])
				var/time = text2num(href_list["time"])
				timeleft += time
				timeleft = Clamp(timeleft, 120, 600)
			if (href_list["timer"])
				if (timing == -1)
					nanomanager.update_uis(src)
					return
				if (!anchored)
					usr << "<span class='warning'>\The [src] needs to be anchored.</span>"
					nanomanager.update_uis(src)
					return
				if (safety)
					usr << "<span class='warning'>The safety is still on.</span>"
					nanomanager.update_uis(src)
					return
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_TIMING))
					usr << "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>"
					nanomanager.update_uis(src)
					return

				if (!timing && !safety)
					timing = 1
					log_and_message_admins("engaged a nuclear bomb")
					bomb_set++ //There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
					update_icon()
				else
					secure_device()
			if (href_list["safety"])
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					usr << "<span class='warning'>Nothing happens, something might be wrong with the wiring.</span>"
					nanomanager.update_uis(src)
					return
				safety = !safety
				if(safety)
					secure_device()
			if (href_list["anchor"])
				if(removal_stage == 5)
					anchored = 0
					visible_message("<span class='warning'>\The [src] makes a highly unpleasant crunching noise. It looks like the anchoring bolts have been cut.</span>")
					nanomanager.update_uis(src)
					return

				if(!isinspace())
					anchored = !anchored
					if(anchored)
						visible_message("<span class='warning'>With a steely snap, bolts slide out of [src] and anchor it to the flooring.</span>")
					else
						secure_device()
						visible_message("<span class='warning'>The anchoring bolts slide back into the depths of [src].</span>")
				else
					usr << "<span class='warning'>There is nothing to anchor to!</span>"

	nanomanager.update_uis(src)

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timing <= 0)
		return

	bomb_set--
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
	playsound(src,'sound/machines/Alarm.ogg',100,0,5)
	if (ticker && ticker.mode)
		ticker.mode.explosion_in_progress = 1
	sleep(100)

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	if(bomb_location && (bomb_location.z in config.station_levels))
		if( (bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)) )
			off_station = 1
	else
		off_station = 2

	if(ticker)
		if(ticker.mode && ticker.mode.name == "Mercenary")
			var/obj/machinery/computer/shuttle_control/multi/syndicate/syndie_location = locate(/obj/machinery/computer/shuttle_control/multi/syndicate)
			if(syndie_location)
				ticker.mode:syndies_didnt_escape = (syndie_location.z > 1 ? 0 : 1)	//muskets will make me change this, but it will do for now
			ticker.mode:nuke_off_station = off_station
		ticker.station_explosion_cinematic(off_station,null)
		if(ticker.mode)
			ticker.mode.explosion_in_progress = 0
			if(off_station == 1)
				world << "<b>A nuclear device was set off, but the explosion was out of reach of the station!</b>"
			else if(off_station == 2)
				world << "<b>A nuclear device was set off, but the device was not on the station!</b>"
			else
				world << "<b>The station was destoyed by the nuclear blast!</b>"

			ticker.mode.station_was_nuked = (off_station<2)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
															//kinda shit but I couldn't  get permission to do what I wanted to do.

			if(!ticker.mode.check_finished())//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
				universe_has_ended = 1
				return
	return

/obj/machinery/nuclearbomb/update_icon()
	if(lighthack)
		icon_state = "nuclearbomb0"
		return

	else if(timing == -1)
		icon_state = "nuclearbomb3"
	else if(timing)
		icon_state = "nuclearbomb2"
	else if(extended)
		icon_state = "nuclearbomb1"
	else
		icon_state = "nuclearbomb0"
/*
if(!N.lighthack)
	if (N.icon_state == "nuclearbomb2")
		N.icon_state = "nuclearbomb1"
		*/

//====The nuclear authentication disc====
/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0

/obj/item/weapon/disk/nuclear/New()
	..()
	nuke_disks |= src

/obj/item/weapon/disk/nuclear/Destroy()
	nuke_disks -= src
	if(!nuke_disks.len)
		var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(T)
			var/obj/D = new /obj/item/weapon/disk/nuclear(T)
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Spawning [D] at ([D.x], [D.y], [D.z]).", location = T)
		else
			log_and_message_admins("[src], the last authentication disk, has been destroyed. Failed to respawn disc!")
	return ..()

/obj/item/weapon/disk/nuclear/touch_map_edge()
	qdel(src)
