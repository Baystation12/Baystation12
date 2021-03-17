

// The Area Power Controller (APC)
// Controls and provides power to most electronics in an area
// Only one required per area
// Requires a wire connection to a power network through a terminal
// Generates a terminal based on the direction of the APC on spawn

// There are three different power channels, lighting, equipment, and enviroment
// Each may have one of the following states

#define POWERCHAN_OFF		0	// Power channel is off
#define POWERCHAN_OFF_TEMP	1	// Power channel is off until there is power
#define POWERCHAN_OFF_AUTO	2	// Power channel is off until power passes a threshold
#define POWERCHAN_ON		3	// Power channel is on until there is no power
#define POWERCHAN_ON_AUTO	4	// Power channel is on until power drops below a threshold

// Power channels set to Auto change when power levels rise or drop below a threshold

#define AUTO_THRESHOLD_LIGHTING  50
#define AUTO_THRESHOLD_EQUIPMENT 25
// The ENVIRON channel stays on as long as possible, and doesn't have a threshold

#define CRITICAL_APC_EMP_PROTECTION 10	// EMP effect duration is divided by this number if the APC has "critical" flag
#define APC_UPDATE_ICON_COOLDOWN 100	// Time between automatically updating the icon (10 seconds)

// Used to check whether or not to update the icon_state
#define UPDATE_CELL_IN 1
#define UPDATE_OPENED1 2
#define UPDATE_OPENED2 4
#define UPDATE_MAINT 8
#define UPDATE_BROKE 16
#define UPDATE_BLUESCREEN 32
#define UPDATE_WIREEXP 64
#define UPDATE_ALLGOOD 128

// Used to check whether or not to update the overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_LOCKED 8
#define APC_UPOVERLAY_OPERATING 16

// Various APC types
/obj/machinery/power/apc/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/critical
	is_critical = 1

/obj/machinery/power/apc/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/high/inactive
	cell_type = /obj/item/cell/high
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/super/critical
	is_critical = 1

/obj/machinery/power/apc/hyper
	cell_type = /obj/item/cell/hyper

// Main APC code
/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."

	icon_state = "apc0"
	icon = 'icons/obj/apc.dmi'
	anchored = TRUE
	use_power = POWER_USE_IDLE // Has custom handling here.
	power_channel = LOCAL      // Do not manipulate this; you don't want to power the APC off itself.
	interact_offline = TRUE    // Can use UI even if unpowered
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery
		)
	req_access = list(access_engine_equip)
	clicksound = "switch"
	layer = ABOVE_WINDOW_LAYER
	var/needs_powerdown_sound
	var/area/area
	var/areastring = null
	var/cell_type = /obj/item/cell/standard
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1       // Bool for main toggle.
	var/charging = 0        // Whether or not it's charging. 0 - not charging but not full, 1 - charging, 2 - full
	var/chargemode = 1      // Whether charging is toggled on or off.
	var/locked = 1
	var/coverlocked = 1     // Whether you can crowbar off the cover or need to swipe ID first.
	var/aidisabled = 0
	var/lastused_light = 0    // Internal stuff for UI and bookkeeping; can read off values but don't modify.
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_charging = 0 // Not an actual channel, and not summed into total. How much battery was recharged, if any, last tick.
	var/lastused_total = 0
	var/main_status = 0     // UI var for whether we are getting external power. 0 = no external power at all, 1 = some, but not enough, 2 = getting enough.
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = FALSE // whether you can access the wires for hacking or not.
	powernet = 0		 // set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/debug= 0         // Legacy debug toggle, left in for admin use.
	var/autoflag= 0		 // 0 = off, 1= eqp and lights off, 2 = eqp off, 3 = all on.
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10  // Counter to smooth out power state changes; do not modify.
	wires = /datum/wires/apc
	var/update_state = -1
	var/update_overlay = -1
	var/list/update_overlay_chan		// Used to determine if there is a change in channels
	var/is_critical = 0
	var/global/status_overlays = 0
	var/failure_timer = 0               // Cooldown thing for apc outage event
	var/force_update = 0
	var/emp_hardened = 0
	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ
	var/autoname = 1

/obj/machinery/power/apc/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	var/obj/machinery/power/terminal/terminal = terminal()
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	// Prevents APCs from being stuck on 0% cell charge while reporting "Fully Charged" status.
	charging = 0

	// If the APC's interface is locked, limit the charge rate to 25%.
	if(locked)
		amount /= 4

	return amount - use_power_oneoff(amount, LOCAL)

/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/populate_parts = TRUE, var/building=0)
	// offset 22 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		set_dir(ndir)

	if(areastring)
		area = get_area_name(areastring)
	else
		var/area/A = get_area(src)
		//if area isn't specified use current
		area = A
	if(autoname)
		SetName("\improper [area.name] APC")
	area.apc = src

	. = ..()

	if (building==0)
		init_round_start()
	else
		opened = 1
		operating = 0
		stat |= MAINT
		queue_icon_update()

	if(operating)
		force_update_channels()
	power_change()

/obj/machinery/power/apc/Destroy()
	src.update()
	area.apc = null
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()

	// Malf AI, removes the APC from AI's hacked APCs list.
	if((hacker) && (hacker.hacked_apcs) && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src

	return ..()

/obj/machinery/power/apc/get_req_access()
	if(!locked)
		return list()
	return ..()

/obj/machinery/power/apc/proc/energy_fail(var/duration)
	if(emp_hardened)
		return
	failure_timer = max(failure_timer, round(duration))
	playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)

/obj/machinery/power/apc/proc/init_round_start()
	has_electronics = 2 //installed and secured

	var/obj/item/stock_parts/power/battery/bat = get_component_of_type(/obj/item/stock_parts/power/battery)
	bat.add_cell(src, new cell_type(bat))
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	term.make_terminal(src)

	queue_icon_update()

/obj/machinery/power/apc/proc/terminal()
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	return term && term.terminal

/obj/machinery/power/apc/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(stat & BROKEN)
			to_chat(user, "Looks broken.")
			return
		var/terminal = terminal()
		if(opened)
			if(has_electronics && terminal)
				to_chat(user, "The cover is [opened==2?"removed":"open"] and the power cell is [ get_cell() ? "installed" : "missing"].")
			else if (!has_electronics && terminal)
				to_chat(user, "There are some wires but no any electronics.")
			else if (has_electronics && !terminal)
				to_chat(user, "Electronics installed but not wired.")
			else /* if (!has_electronics && !terminal) */
				to_chat(user, "There is no electronics nor connected wires.")

		else
			if (stat & MAINT)
				to_chat(user, "The cover is closed. Something wrong with it: it doesn't work.")
			else if (hacker && !hacker.hacked_apcs_hidden)
				to_chat(user, "The cover is locked.")
			else
				to_chat(user, "The cover is closed.")


// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/on_update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 5
		status_overlays_lighting.len = 5
		status_overlays_environ.len = 5

		status_overlays_lock[1] = image(icon, "apcox-0")    // 0=blue 1=red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		var/list/channel_overlays = list(status_overlays_equipment, status_overlays_lighting, status_overlays_environ)
		var/channel = 0
		for(var/list/channel_leds in channel_overlays)
			channel_leds[POWERCHAN_OFF + 1] = overlay_image(icon,"apco[channel]",COLOR_RED)
			channel_leds[POWERCHAN_OFF_TEMP + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_OFF_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_ON + 1] = overlay_image(icon,"apco[channel]",COLOR_LIME)
			channel_leds[POWERCHAN_ON_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_BLUE)
			channel++

	if(update_state < 0)
		pixel_x = 0
		pixel_y = 0
		var/turf/T = get_step(get_turf(src), dir)
		if(istype(T) && T.density)
			if(dir == SOUTH)
				pixel_y = -22
			else if(dir == NORTH)
				pixel_y = 22
			else if(dir == EAST)
				pixel_x = 22
			else if(dir == WEST)
				pixel_x = -22

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays

	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPDATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2))
			var/basestate = "apc[ get_cell() ? "2" : "1" ]"
			if(update_state & UPDATE_OPENED1)
				if(update_state & (UPDATE_MAINT|UPDATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPDATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPDATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPDATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPDATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPDATE_ALLGOOD))
		if(overlays.len)
			overlays.Cut()
			return

	if(update & 2)
		if(overlays.len)
			overlays.Cut()
		if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			overlays += status_overlays_lock[locked+1]
			overlays += status_overlays_charging[charging+1]
			if(operating)
				overlays += status_overlays_equipment[equipment+1]
				overlays += status_overlays_lighting[lighting+1]
				overlays += status_overlays_environ[environ+1]

	if(update & 3)
		if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2|UPDATE_BROKE))
			set_light(0)
		else if(update_state & UPDATE_BLUESCREEN)
			set_light(0.8, 0.1, 1, 2, "#00ecff")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#f86060"
				if(1)
					color = "#a8b0f8"
				if(2)
					color = "#82ff4c"
			set_light(0.8, 0.1, 1, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()
	if(!update_overlay_chan)
		update_overlay_chan = new/list()
	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	var/list/last_update_overlay_chan = update_overlay_chan.Copy()
	update_state = 0
	update_overlay = 0
	if(get_cell())
		update_state |= UPDATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPDATE_BROKE
	if(stat & MAINT)
		update_state |= UPDATE_MAINT
	if(opened)
		if(opened==1)
			update_state |= UPDATE_OPENED1
		if(opened==2)
			update_state |= UPDATE_OPENED2
	else if(emagged || (hacker && !hacker.hacked_apcs_hidden) || failure_timer)
		update_state |= UPDATE_BLUESCREEN
	else if(wiresexposed)
		update_state |= UPDATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPDATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPDATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGEING2


		update_overlay_chan["Equipment"] = equipment
		update_overlay_chan["Lighting"] = lighting
		update_overlay_chan["Enviroment"] = environ


	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay && last_update_overlay_chan == update_overlay_chan)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay || last_update_overlay_chan != update_overlay_chan)
		results += 2
	return results

/obj/machinery/power/apc/components_are_accessible(var/path)
	. = opened
	if(ispath(path, /obj/item/stock_parts/power/terminal))
		. = min(., (has_electronics != 2))

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/attackby(obj/item/W, mob/user)
	if (istype(user, /mob/living/silicon) && get_dist(src,user)>1)
		return attack_robot(user)
	if(istype(W, /obj/item/inducer))
		return FALSE // inducer.dm afterattack handles this

	if(isCrowbar(W) && user.a_intent != I_HURT)//bypass when on harm intend to actually make use of the cover hammer off check further down.
		if(opened) // Closes or removes board.
			if (has_electronics == 1)
				if (terminal())
					to_chat(user, SPAN_WARNING("Disconnect the wires first."))
					return TRUE
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, "You are trying to remove the power control board...")//lpeters - fixed grammar issues

				if(do_after(user, 50, src) && opened && (has_electronics == 1) && !terminal()) // redo all checks.
					has_electronics = 0
					if ((stat & BROKEN))
						user.visible_message(\
							SPAN_WARNING("\The [user] has broken the power control board inside \the [src]!"),\
							SPAN_NOTICE("You break the charred power control board and remove the remains."),\
							"You hear a crack!")
					else
						user.visible_message(\
							SPAN_WARNING("\The [user] has removed the power control board from \the [src]!"),\
							SPAN_NOTICE("You remove the power control board."))
						new /obj/item/module/power_control(loc)
				return TRUE

			else if (opened != 2) //cover isn't removed
				opened = 0 // Closes panel.
				user.visible_message(SPAN_NOTICE("\The [user] pries the cover shut on \the [src]."), SPAN_NOTICE("You pry the cover shut."))
				update_icon()
				return TRUE

		if((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden))
			to_chat(user, SPAN_WARNING("The cover appears broken or stuck."))
			return TRUE
		if(coverlocked && !(stat & MAINT))
			to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
			return TRUE
		opened = 1
		user.visible_message(SPAN_NOTICE("\The [user] pries the cover open on \the [src]."), SPAN_NOTICE("You pry the cover open."))
		update_icon()
		return TRUE

	// Exposes wires for hacking and attaches/detaches the circuit.
	if(isScrewdriver(W))
		if(opened)
			if (get_cell())
				to_chat(user, SPAN_WARNING("Either close the cover or remove the cell first."))
				return TRUE
			switch(has_electronics)
				if(1)
					if(!terminal())
						to_chat(user, SPAN_WARNING("You must attach a wire connection first!"))
						return TRUE
					has_electronics = 2
					stat &= ~MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You screw the circuit electronics into place.")
					update_icon()
				if(2)
					has_electronics = 1
					stat |= MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You unfasten the electronics.")
					update_icon()
				if(0)
					to_chat(user, SPAN_WARNING("There is no power control board to secure!"))
			return TRUE
		// Otherwise, if not opened, expose the wires.
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		update_icon()
		return TRUE

	// trying to unlock the interface with an ID card
	if (istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if(emagged)
			to_chat(user, "The interface is broken.")
		else if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else if(hacker && !hacker.hacked_apcs_hidden)
			to_chat(user, "<span class='warning'>Access denied.</span>")
		else
			if(has_access(req_access, user.GetAccess()) && !isWireCut(APC_WIRE_IDSCAN))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	// Inserting board.
	if(istype(W, /obj/item/module/power_control))
		if(stat & BROKEN)
			to_chat(user, SPAN_WARNING("You cannot put the board inside, the frame is damaged."))
			return TRUE
		if(!opened)
			to_chat(user, SPAN_WARNING("You must first open the cover."))
			return TRUE
		if(has_electronics != 0)
			to_chat(user, SPAN_WARNING("There is already a power control board inside."))
			return TRUE
		user.visible_message(SPAN_WARNING("\The [user] inserts the power control board into \the [src]."), \
							"You start to insert the power control board into the frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10, src) && has_electronics == 0 && opened && !(stat & BROKEN))
			has_electronics = 1
			reboot() //completely new electronics
			to_chat(user, SPAN_NOTICE("You place the power control board inside the frame."))
			qdel(W)

	// Deconstruction
	if(isWelder(W))
		if(!opened)
			to_chat(user, SPAN_WARNING("You must first open the cover."))
			return TRUE
		if(has_electronics != 0)
			to_chat(user, SPAN_WARNING("You must first remove the power control board inside."))
			return TRUE
		if(terminal())
			to_chat(user, SPAN_WARNING("The wire connection is in the way."))
			return TRUE
		var/obj/item/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return
		user.visible_message(SPAN_WARNING("\The [user] begins to weld \the [src]."), \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50, src) && opened && has_electronics == 0 && !terminal())
			if(!WT.remove_fuel(3, user))
				return TRUE
			if (emagged || (stat & BROKEN) || opened==2)
				new /obj/item/stack/material/steel(loc)
				user.visible_message(\
					SPAN_WARNING("\The [src] has been cut apart by \the [user] with \the [WT]."),\
					SPAN_NOTICE("You disassembled the broken APC frame."),\
					"You hear welding.")
			else
				new /obj/item/frame/apc(loc)
				user.visible_message(\
					SPAN_WARNING("\The [src] has been cut from the wall by \the [user] with \the [WT]."),\
					SPAN_NOTICE("You cut the APC frame from the wall."),\
					"You hear welding.")
			qdel(src)
			return TRUE

	// Panel and frame repair.
	if (istype(W, /obj/item/frame/apc))
		if(!opened)
			to_chat(user, SPAN_WARNING("You must first open the cover."))
			return TRUE
		if(emagged)
			emagged = FALSE
			if(opened==2)
				opened = 1
			user.visible_message(\
				"<span class='warning'>[user.name] has replaced the damaged APC frontal panel with a new one.</span>",\
				"<span class='notice'>You replace the damaged APC frontal panel with a new one.</span>")
			qdel(W)
			update_icon()
			return TRUE

		if((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden))
			if (has_electronics)
				to_chat(user, "<span class='warning'>You cannot repair this APC until you remove the electronics still inside.</span>")
				return TRUE

			user.visible_message("<span class='warning'>[user.name] replaces the damaged APC frame with a new one.</span>",\
								"You begin to replace the damaged APC frame...")
			if(do_after(user, 50, src) && opened && !has_electronics && ((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden)))
				user.visible_message(\
					"<span class='notice'>[user.name] has replaced the damaged APC frame with new one.</span>",\
					"You replace the damaged APC frame with new one.")
				qdel(W)
				set_broken(FALSE)
				// Malf AI, removes the APC from AI's hacked APCs list.
				if(hacker && hacker.hacked_apcs && (src in hacker.hacked_apcs))
					hacker.hacked_apcs -= src
					hacker = null
				if (opened==2)
					opened = 1
				queue_icon_update()

	if((. = ..())) // Further interactions are low priority attack stuff.
		return

	if (((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden)) \
			&& !opened \
			&& W.force >= 5 \
			&& W.w_class >= 3.0 \
			&& prob(W.force) )
		opened = 2
		user.visible_message("<span class='danger'>The APC cover was knocked down with the [W.name] by [user.name]!</span>", \
			"<span class='danger'>You knock down the APC cover with your [W.name]!</span>", \
			"You hear a bang")
		update_icon()
	else
		if (istype(user, /mob/living/silicon))
			return attack_robot(user)
		if (!opened && wiresexposed && (isMultitool(W) || isWirecutter(W) || istype(W, /obj/item/device/assembly/signaler)))
			return wires.Interact(user)

		user.visible_message("<span class='danger'>The [src.name] has been hit with the [W.name] by [user.name]!</span>", \
			"<span class='danger'>You hit the [src.name] with your [W.name]!</span>", \
			"You hear a bang")
		if(W.force >= 5 && W.w_class >= ITEM_SIZE_NORMAL && prob(W.force))
			var/roulette = rand(1,100)
			switch(roulette)
				if(1 to 10)
					locked = FALSE
					to_chat(user, "<span class='notice'>You manage to disable the lock on \the [src]!</span>")
				if(50 to 70)
					to_chat(user, "<span class='notice'>You manage to bash the lid open!</span>")
					opened = 1
				if(90 to 100)
					to_chat(user, "<span class='warning'>There's a nasty sound and \the [src] goes cold...</span>")
					set_broken(TRUE)
			queue_icon_update()
	playsound(get_turf(src), 'sound/weapons/smash.ogg', 75, 1)

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/emag_act(var/remaining_charges, var/mob/user)
	if (!(emagged || (hacker && !hacker.hacked_apcs_hidden)))		// trying to unlock with an emag card
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel first")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			flick("apc-spark", src)
			if (do_after(user,6,src))
				if(prob(50))
					emagged = TRUE
					req_access.Cut()
					locked = 0
					to_chat(user, "<span class='notice'>You emag the APC interface.</span>")
					update_icon()
				else
					to_chat(user, "<span class='warning'>You fail to [ locked ? "unlock" : "lock"] the APC interface.</span>")
				return 1

/obj/machinery/power/apc/CanUseTopicPhysical(var/mob/user)
	return GLOB.physical_state.can_use_topic(nano_host(), user)

/obj/machinery/power/apc/physical_attack_hand(mob/user)
	//Human mob special interaction goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user

		if(H.species.can_shred(H))
			user.visible_message("<span class='warning'>\The [user] slashes at \the [src]!</span>", "<span class='notice'>You slash at \the [src]!</span>")
			playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

			var/allcut = wires.IsAllCut()

			if(beenhit >= pick(3, 4) && !wiresexposed)
				wiresexposed = TRUE
				src.update_icon()
				src.visible_message("<span class='warning'>\The The [src]'s cover flies open, exposing the wires!</span>")

			else if(wiresexposed && allcut == 0)
				wires.CutAll()
				src.update_icon()
				src.visible_message("<span class='warning'>\The [src]'s wires are shredded!</span>")
			else
				beenhit += 1
			return TRUE

/obj/machinery/power/apc/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return
	var/obj/item/cell/cell = get_cell()

	var/list/data = list(
		"pChan_Off" = POWERCHAN_OFF,
		"pChan_Off_T" = POWERCHAN_OFF_TEMP,
		"pChan_Off_A" = POWERCHAN_OFF_AUTO,
		"pChan_On" = POWERCHAN_ON,
		"pChan_On_A" = POWERCHAN_ON_AUTO,
		"locked" = (locked && !emagged) ? 1 : 0,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"totalCharging" = round(lastused_charging),
		"coverLocked" = coverlocked,
		"failTime" = failure_timer * 2,
		"siliconUser" = istype(user, /mob/living/silicon),
		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 2),
					"on"   = list("eqp" = 1),
					"off"  = list("eqp" = 0)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 2),
					"on"   = list("lgt" = 1),
					"off"  = list("lgt" = 0)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 2),
					"on"   = list("env" = 1),
					"off"  = list("env" = 0)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/apc/proc/report()
	var/obj/item/cell/cell = get_cell()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted && !failure_timer)

		//prevent unnecessary updates to emergency lighting
		var/new_power_light = (lighting >= POWERCHAN_ON)
		if(area.power_light != new_power_light)
			area.power_light = new_power_light
			area.set_emergency_lighting(lighting == POWERCHAN_OFF_AUTO) //if lights go auto-off, emergency lights go on

		area.power_equip = (equipment >= POWERCHAN_ON)
		area.power_environ = (environ >= POWERCHAN_ON)
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0

	area.power_change()

	var/obj/item/cell/cell = get_cell()
	if(!cell || cell.charge <= 0)
		if(needs_powerdown_sound == TRUE)
			playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)
			needs_powerdown_sound = FALSE
		else
			needs_powerdown_sound = TRUE

/obj/machinery/power/apc/proc/isWireCut(var/wireIndex)
	return wires.IsIndexCut(wireIndex)


/obj/machinery/power/apc/CanUseTopic(mob/user, datum/topic_state/state)
	if(user.lying)
		to_chat(user, "<span class='warning'>You must stand to use [src]!</span>")
		return STATUS_CLOSE
	if(istype(user, /mob/living/silicon))
		var/permit = 0 // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(hacker && !hacker.hacked_apcs_hidden)
			if(hacker == AI)
				permit = 1
			else if(istype(robot) && robot.connected_ai && robot.connected_ai == hacker) // Cyborgs can use APCs hacked by their AI
				permit = 1

		if(aidisabled && !permit)
			return STATUS_CLOSE
	. = ..()
	if(user.restrained())
		to_chat(user, "<span class='warning'>You must have free hands to use [src].</span>")
		. = min(., STATUS_UPDATE)

/obj/machinery/power/apc/Topic(href, href_list)
	if(..())
		return 1

	if(!istype(usr, /mob/living/silicon) && (locked && !emagged))
		// Shouldn't happen, this is here to prevent href exploits
		to_chat(usr, "You must unlock the panel to use this!")
		return 1

	if (href_list["lock"])
		coverlocked = !coverlocked

	else if( href_list["reboot"] )
		failure_timer = 0
		update_icon()
		update()

	else if (href_list["breaker"])
		toggle_breaker()

	else if (href_list["cmode"])
		set_chargemode(!chargemode)
		if(!chargemode)
			charging = 0
			update_icon()

	else if (href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = setsubsystem(val)
		force_update_channels()

	else if (href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = setsubsystem(val)
		force_update_channels()

	else if (href_list["env"])
		var/val = text2num(href_list["env"])
		environ = setsubsystem(val)
		force_update_channels()

	else if (href_list["overload"])
		if(istype(usr, /mob/living/silicon))
			src.overload_lighting()

	else if (href_list["toggleaccess"])
		if(istype(usr, /mob/living/silicon))
			if(emagged || (stat & (BROKEN|MAINT)))
				to_chat(usr, "The APC does not respond to the command.")
			else
				locked = !locked
				update_icon()

	return 0

/obj/machinery/power/apc/proc/force_update_channels()
	autoflag = -1 // This clears state, forcing a full recalculation
	update_channels(TRUE)
	update()
	queue_icon_update()

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	force_update_channels()

/obj/machinery/power/apc/get_power_usage()
	if(autoflag)
		return lastused_total // If not, we need to do something more sophisticated: compute how much power we would need in order to come back online.
	. = 0
	if(autoset(lighting, 2) >= POWERCHAN_ON)
		. += area.usage(LIGHT)
	if(autoset(equipment, 2) >= POWERCHAN_ON)
		. += area.usage(EQUIP)
	if(autoset(environ, 1) >= POWERCHAN_ON)
		. += area.usage(EQUIP)

/obj/machinery/power/apc/Process()
	if(!area.requires_power)
		return PROCESS_KILL

	if(stat & (BROKEN|MAINT))
		return

	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = 1
		return

	lastused_light = (lighting >= POWERCHAN_ON) ? area.usage(LIGHT) : 0
	lastused_equip = (equipment >= POWERCHAN_ON) ? area.usage(EQUIP) : 0
	lastused_environ = (environ >= POWERCHAN_ON) ? area.usage(ENVIRON) : 0
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/obj/machinery/power/terminal/terminal = terminal()
	var/avail = (terminal && terminal.avail()) || 0
	var/excess = (terminal && terminal.surplus()) || 0

	if(!avail)
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	var/obj/item/cell/cell = get_cell()
	if(!cell || shorted) // We aren't going to be doing any power processing in this case.
		charging = 0
	else
		..() // Actual processing happens in here.

		if(debug)
			log_debug("Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light] - Longterm: [longtermpower]")

		//update state
		var/obj/item/stock_parts/power/battery/power = get_component_of_type(/obj/item/stock_parts/power/battery)
		lastused_charging = max(power && power.cell && (power.cell.charge - power.last_cell_charge) * CELLRATE, 0)
		charging = lastused_charging ? 1 : 0
		if(cell.fully_charged())
			charging = 2

		if(stat & NOPOWER)
			power_change() // We are the ones responsible for triggering listeners once power returns, so we run this to detect possible changes.

	// Set channels depending on how much charge we have left
	update_channels()

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = 0
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/obj/machinery/power/apc/proc/update_channels(suppress_alarms = FALSE)
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2
	var/obj/item/cell/cell = get_cell()
	var/percent = cell && cell.percent()

	if(!cell || shorted || (stat & NOPOWER) || !operating)
		if(autoflag != 0)
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 0
	else if((percent > AUTO_THRESHOLD_LIGHTING) || longtermpower >= 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != 3)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			autoflag = 3
			power_alarm.clearAlarm(loc, src)
	else if((percent <= AUTO_THRESHOLD_LIGHTING) && (percent > AUTO_THRESHOLD_EQUIPMENT) && longtermpower < 0)                       // <50%, turn off lighting
		if(autoflag != 2)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 2
	else if(percent <= AUTO_THRESHOLD_EQUIPMENT)        // <25%, turn off lighting & equipment
		if(autoflag != 1)
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 1

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
obj/machinery/power/apc/proc/autoset(var/cur_state, var/on)
	//autoset will never turn on a channel set to off
	switch(cur_state)
		if(POWERCHAN_OFF_TEMP)
			if(on == 1 || on == 2)
				return POWERCHAN_ON
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF_TEMP
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged


// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	if(emp_hardened)
		return
	var/obj/item/cell/cell = get_cell()
	// Fail for 8-12 minutes (divided by severity)
	// Division by 2 is required, because machinery ticks are every two seconds. Without it we would fail for 16-24 minutes.
	if(is_critical)
		// Critical APCs are considered EMP shielded and will be offline only for about half minute. Prevents AIs being one-shot disabled by EMP strike.
		// Critical APCs are also more resilient to cell corruption/power drain.
		energy_fail(rand(240, 360) / severity / CRITICAL_APC_EMP_PROTECTION)
		if(cell)
			cell.emp_act(severity+2)
	else
		// Regular APCs fail for normal time.
		energy_fail(rand(240, 360) / severity)
		if(cell)
			cell.emp_act(severity+1)

	update_icon()
	..()

/obj/machinery/power/apc/ex_act(severity)
	var/obj/item/cell/C = get_cell()
	switch(severity)
		if(1.0)
			qdel(src)
			if (C)
				C.ex_act(1.0) // more lags woohoo
			return
		if(2.0)
			if (prob(50))
				set_broken(TRUE)
				if (C && prob(50))
					C.ex_act(2.0)
		if(3.0)
			if (prob(25))
				set_broken(TRUE)
				if (C && prob(25))
					C.ex_act(3.0)

/obj/machinery/power/apc/set_broken(new_state)
	if(!new_state || (stat & BROKEN))
		return ..()
	visible_message("<span class='notice'>[src]'s screen flickers with warnings briefly!</span>")
	power_alarm.triggerAlarm(loc, src)
	spawn(rand(2,5))
		..()
		visible_message("<span class='notice'>[src]'s screen suddenly explodes in rain of sparks and small debris!</span>")
		operating = 0
		update()
	return TRUE

/obj/machinery/power/apc/proc/reboot()
	//reset various counters so that process() will start fresh
	charging = initial(charging)
	autoflag = initial(autoflag)
	longtermpower = initial(longtermpower)
	failure_timer = initial(failure_timer)

	//start with main breaker off, chargemode in the default state and all channels on auto upon reboot
	operating = 0

	set_chargemode(initial(chargemode))
	power_alarm.clearAlarm(loc, src)

	lighting = POWERCHAN_ON_AUTO
	equipment = POWERCHAN_ON_AUTO
	environ = POWERCHAN_ON_AUTO

	force_update_channels()

/obj/machinery/power/apc/proc/set_chargemode(new_mode)
	chargemode = new_mode
	var/obj/item/stock_parts/power/battery/power = get_component_of_type(/obj/item/stock_parts/power/battery)
	if(power)
		power.can_charge = chargemode
		power.charge_wait_counter = initial(power.charge_wait_counter)

// overload the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting(var/chance = 100)
	if(/* !get_connection() || */ !operating || shorted)
		return
	var/amount = use_power_oneoff(20, LOCAL)
	if(amount <= 0)
		spawn(0)
			for(var/obj/machinery/light/L in area)
				if(prob(chance))
					L.on = 1
					L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/setsubsystem(val)
	switch(val)
		if(2)
			return POWERCHAN_OFF_AUTO
		if(1)
			return POWERCHAN_OFF_TEMP
		else
			return POWERCHAN_OFF

// Malfunction: Transfers APC under AI's control
/obj/machinery/power/apc/proc/ai_hack(var/mob/living/silicon/ai/A = null)
	if(!A || !A.hacked_apcs || hacker || aidisabled || A.stat == DEAD)
		return 0
	src.hacker = A
	A.hacked_apcs += src
	locked = 1
	update_icon()
	return 1

/obj/item/module/power_control
	name = "power control module"
	desc = "Heavy-duty switching circuits for power control."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	item_state = "electronic"
	matter = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/machinery/power/apc/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	emp_hardened = 1
	to_chat(user, "\The [src] has been upgraded. It is now protected against EM pulses.")
	return 1



#undef APC_UPDATE_ICON_COOLDOWN
