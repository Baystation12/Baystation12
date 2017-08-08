#define CRITICAL_APC_EMP_PROTECTION 10 // EMP effect duration is divided by this number if the APC has "critical" flag
//update_state
#define UPDATE_CELL_IN 1
#define UPDATE_OPENED1 2
#define UPDATE_OPENED2 4
#define UPDATE_MAINT 8
#define UPDATE_BROKE 16
#define UPDATE_BLUESCREEN 32
#define UPDATE_WIREEXP 64
#define UPDATE_ALLGOOD 128

//update_overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_EQUIPMENT0 8
#define APC_UPOVERLAY_EQUIPMENT1 16
#define APC_UPOVERLAY_EQUIPMENT2 32
#define APC_UPOVERLAY_LIGHTING0 64
#define APC_UPOVERLAY_LIGHTING1 128
#define APC_UPOVERLAY_LIGHTING2 256
#define APC_UPOVERLAY_ENVIRON0 512
#define APC_UPOVERLAY_ENVIRON1 1024
#define APC_UPOVERLAY_ENVIRON2 2048
#define APC_UPOVERLAY_LOCKED 4096
#define APC_UPOVERLAY_OPERATING 8192


#define APC_UPDATE_ICON_COOLDOWN 100 // 10 seconds


// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network through a terminal

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto
#define POWERCHAN_OFF      0
#define POWERCHAN_OFF_AUTO 1
#define POWERCHAN_ON       2
#define POWERCHAN_ON_AUTO  3

//thresholds for channels going off automatically. ENVIRON channel stays on as long as possible, and doesn't have a threshold
#define AUTO_THRESHOLD_LIGHTING  50
#define AUTO_THRESHOLD_EQUIPMENT 25

//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx

/obj/machinery/power/apc/critical
	is_critical = 1

/obj/machinery/power/apc/high
	cell_type = /obj/item/weapon/cell/high

// Construction site APC, starts turned off
/obj/machinery/power/apc/high/inactive
	cell_type = /obj/item/weapon/cell/high
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/super
	cell_type = /obj/item/weapon/cell/super

/obj/machinery/power/apc/super/critical
	is_critical = 1

/obj/machinery/power/apc/hyper
	cell_type = /obj/item/weapon/cell/hyper

/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."

	icon_state = "apc0"
	anchored = 1
	use_power = 0
	req_access = list(access_engine_equip)
	clicksound = "switch"
	var/area/area
	var/areastring = null
	var/obj/item/weapon/cell/cell
	var/chargelevel = 0.0005  // Cap for how fast APC cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
	var/cell_type = /obj/item/weapon/cell/apc
	var/opened = 0 //0=closed, 1=opened, 2=cover removed
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1
	var/charging = 0
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/tdir = null
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_charging = 0
	var/lastused_total = 0
	var/main_status = 0
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = 0
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/debug= 0
	var/autoflag= 0		// 0 = off, 1= eqp and lights off, 2 = eqp off, 3 = all on.
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/datum/wires/apc/wires = null
	var/update_state = -1
	var/update_overlay = -1
	var/is_critical = 0
	var/global/status_overlays = 0
	var/updating_icon = 0
	var/failure_timer = 0
	var/force_update = 0
	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ

/obj/machinery/power/apc/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(!terminal)
		make_terminal()
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

	var/drained_energy = 0

	// First try to drain the power directly from attached power grid.
	if(terminal && terminal.powernet)
		terminal.powernet.trigger_warning()
		drained_energy += terminal.powernet.draw_power(amount)

	// If the power grid provided enough power, we're good. If not, take the rest from the power cell.
	if((drained_energy < amount) && cell)
		drained_energy += cell.use((amount - drained_energy) * CELLRATE)

	return drained_energy

/obj/machinery/power/apc/New(turf/loc, var/ndir, var/building=0)
	wires = new(src)

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		set_dir(ndir)
	src.tdir = dir		// to fix Vars bug
	set_dir(SOUTH)

	pixel_x = (src.tdir & 3)? 0 : (src.tdir == 4 ? 24 : -24)
	pixel_y = (src.tdir & 3)? (src.tdir ==1 ? 24 : -24) : 0

	if (building==0)
		init_round_start()
	else
		area = get_area(src)
		area.apc = src
		opened = 1
		operating = 0
		name = "\improper [area.name] APC"
		stat |= MAINT
		src.update_icon()

	..()

/obj/machinery/power/apc/Initialize()
	. = ..()
	if(operating)
		src.update()

/obj/machinery/power/apc/Destroy()
	src.update()
	area.apc = null
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()
	qdel(wires)
	wires = null
	qdel(terminal)
	terminal = null
	if(cell)
		cell.forceMove(loc)
		cell = null

	// Malf AI, removes the APC from AI's hacked APCs list.
	if((hacker) && (hacker.hacked_apcs) && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src

	return ..()

/obj/machinery/power/apc/proc/energy_fail(var/duration)
	failure_timer = max(failure_timer, round(duration))

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.set_dir(tdir)
	terminal.master = src

/obj/machinery/power/apc/proc/init_round_start()
	has_electronics = 2 //installed and secured
	// is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		src.cell = new cell_type(src)

	var/area/A = src.loc.loc

	//if area isn't specified use current
	if(isarea(A) && src.areastring == null)
		src.area = A
		name = "\improper [area.name] APC"
	else
		src.area = get_area_name(areastring)
		name = "\improper [area.name] APC"
	area.apc = src
	update_icon()

	make_terminal()

/obj/machinery/power/apc/examine(mob/user)
	if(..(user, 1))
		if(stat & BROKEN)
			to_chat(user, "Looks broken.")
			return
		if(opened)
			if(has_electronics && terminal)
				to_chat(user, "The cover is [opened==2?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"].")
			else if (!has_electronics && terminal)
				to_chat(user, "There are some wires but no any electronics.")
			else if (has_electronics && !terminal)
				to_chat(user, "Electronics installed but not wired.")
			else /* if (!has_electronics && !terminal) */
				to_chat(user, "There is no electronics nor connected wires.")

		else
			if (stat & MAINT)
				to_chat(user, "The cover is closed. Something wrong with it: it doesn't work.")
			else if (hacker)
				to_chat(user, "The cover is locked.")
			else
				to_chat(user, "The cover is closed.")


// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 4
		status_overlays_lighting.len = 4
		status_overlays_environ.len = 4

		status_overlays_lock[1] = image(icon, "apcox-0")    // 0=blue 1=red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		status_overlays_equipment[1] = image(icon, "apco0-0")
		status_overlays_equipment[2] = image(icon, "apco0-1")
		status_overlays_equipment[3] = image(icon, "apco0-2")
		status_overlays_equipment[4] = image(icon, "apco0-3")

		status_overlays_lighting[1] = image(icon, "apco1-0")
		status_overlays_lighting[2] = image(icon, "apco1-1")
		status_overlays_lighting[3] = image(icon, "apco1-2")
		status_overlays_lighting[4] = image(icon, "apco1-3")

		status_overlays_environ[1] = image(icon, "apco2-0")
		status_overlays_environ[2] = image(icon, "apco2-1")
		status_overlays_environ[3] = image(icon, "apco2-2")
		status_overlays_environ[4] = image(icon, "apco2-3")

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays
	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPDATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2))
			var/basestate = "apc[ cell ? "2" : "1" ]"
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
			overlays = 0
			return

	if(update & 2)
		if(overlays.len)
			overlays.len = 0
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
			set_light(l_range = 2, l_power = 0.5, l_color = "#0000FF")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#F86060"
				if(1)
					color = "#A8B0F8"
				if(2)
					color = "#82FF4C"
			set_light(l_range = 2, l_power = 0.5, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()

	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
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
	else if(emagged || hacker || failure_timer)
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

		if (!equipment)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == 1)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == 2)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(!lighting)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == 1)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == 2)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(!environ)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ==1)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ==2)
			update_overlay |= APC_UPOVERLAY_ENVIRON2


	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay)
		results += 2
	return results

// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()

	if(!updating_icon)
		updating_icon = 1
		// Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/attackby(obj/item/W, mob/user)

	if (istype(user, /mob/living/silicon) && get_dist(src,user)>1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/weapon/crowbar) && opened)
		if (has_electronics==1)
			if (terminal)
				to_chat(user, "<span class='warning'>Disconnect wires first.</span>")
				return
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, "You are trying to remove the power control board...")//lpeters - fixed grammar issues

			if(do_after(user, 50, src))
				if (has_electronics==1)
					has_electronics = 0
					if ((stat & BROKEN))
						user.visible_message(\
							"<span class='warning'>[user.name] has broken the power control board inside [src.name]!</span>",\
							"<span class='notice'>You broke the charred power control board and remove the remains.</span>",
							"You hear a crack!")
						//ticker.mode:apcs-- //XSI said no and I agreed. -rastaf0
					else
						user.visible_message(\
							"<span class='warning'>[user.name] has removed the power control board from [src.name]!</span>",\
							"<span class='notice'>You remove the power control board.</span>")
						new /obj/item/weapon/module/power_control(loc)
		else if (opened!=2) //cover isn't removed
			opened = 0
			update_icon()
	else if (istype(W, /obj/item/weapon/crowbar) && !((stat & BROKEN) || hacker) )
		if(coverlocked && !(stat & MAINT))
			to_chat(user, "<span class='warning'>The cover is locked and cannot be opened.</span>")
			return
		else
			opened = 1
			update_icon()
	else if	(istype(W, /obj/item/weapon/cell) && opened)	// trying to put a cell inside
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return
		if (stat & MAINT)
			to_chat(user, "<span class='warning'>There is no connector for your power cell.</span>")
			return
		if(W.w_class != ITEM_SIZE_NORMAL)
			to_chat(user, "\The [W] is too [W.w_class < ITEM_SIZE_NORMAL? "small" : "large"] to fit here.")
			return

		user.drop_item()
		W.forceMove(src)
		cell = W
		user.visible_message(\
			"<span class='warning'>[user.name] has inserted the power cell to [src.name]!</span>",\
			"<span class='notice'>You insert the power cell.</span>")
		chargecount = 0
		update_icon()
	else if	(istype(W, /obj/item/weapon/screwdriver))	// haxing
		if(opened)
			if (cell)
				to_chat(user, "<span class='warning'>Close the APC first.</span>")//Less hints more mystery!

				return
			else
				if (has_electronics==1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You screw the circuit electronics into place.")
				else if (has_electronics==2)
					has_electronics = 1
					stat |= MAINT
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You unfasten the electronics.")
				else /* has_electronics==0 */
					to_chat(user, "<span class='warning'>There is nothing to secure.</span>")
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
			update_icon()

	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))			// trying to unlock the interface with an ID card
		if(emagged)
			to_chat(user, "The interface is broken.")
		else if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else if(hacker)
			to_chat(user, "<span class='warning'>Access denied.</span>")
		else
			if(src.allowed(usr) && !isWireCut(APC_WIRE_IDSCAN))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
	else if (istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need ten lengths of cable for APC.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] adds cables to the APC frame.</span>", \
							"You start adding cables to the APC frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20, src))
			if (C.amount >= 10 && !terminal && opened && has_electronics != 2)
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(user.stunned)
						return
				C.use(10)
				user.visible_message(\
					"<span class='warning'>[user.name] has added cables to the APC frame!</span>",\
					"You add cables to the APC frame.")
				make_terminal()
				terminal.connect_to_network()
	else if (istype(W, /obj/item/weapon/wirecutters) && terminal && opened && has_electronics!=2)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of the APC first.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] dismantles the power terminal from [src].</span>", \
							"You begin to cut the cables...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50, src))
			if(terminal && opened && has_electronics!=2)
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					if(usr.stunned)
						return
				new /obj/item/stack/cable_coil(loc,10)
				to_chat(user, "<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
				qdel(terminal)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && !((stat & BROKEN)))
		user.visible_message("<span class='warning'>[user.name] inserts the power control board into [src].</span>", \
							"You start to insert the power control board into the frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10, src))
			if(has_electronics==0)
				has_electronics = 1
				reboot() //completely new electronics
				to_chat(user, "<span class='notice'>You place the power control board inside the frame.</span>")
				qdel(W)
	else if (istype(W, /obj/item/weapon/module/power_control) && opened && has_electronics==0 && ((stat & BROKEN)))
		to_chat(user, "<span class='warning'>You cannot put the board inside, the frame is damaged.</span>")
		return
	else if (istype(W, /obj/item/weapon/weldingtool) && opened && has_electronics==0 && !terminal)
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] welds [src].</span>", \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50, src))
			if(!src || !WT.remove_fuel(3, user)) return
			if (emagged || (stat & BROKEN) || opened==2)
				new /obj/item/stack/material/steel(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut apart by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You disassembled the broken APC frame.</span>",\
					"You hear welding.")
			else
				new /obj/item/frame/apc(loc)
				user.visible_message(\
					"<span class='warning'>[src] has been cut from the wall by [user.name] with the weldingtool.</span>",\
					"<span class='notice'>You cut the APC frame from the wall.</span>",\
					"You hear welding.")
			qdel(src)
			return
	else if (istype(W, /obj/item/frame/apc) && opened && emagged)
		emagged = 0
		if (opened==2)
			opened = 1
		user.visible_message(\
			"<span class='warning'>[user.name] has replaced the damaged APC frontal panel with a new one.</span>",\
			"<span class='notice'>You replace the damaged APC frontal panel with a new one.</span>")
		qdel(W)
		update_icon()
	else if (istype(W, /obj/item/frame/apc) && opened && ((stat & BROKEN) || hacker))
		if (has_electronics)
			to_chat(user, "<span class='warning'>You cannot repair this APC until you remove the electronics still inside.</span>")
			return
		user.visible_message("<span class='warning'>[user.name] replaces the damaged APC frame with a new one.</span>",\
							"You begin to replace the damaged APC frame...")
		if(do_after(user, 50, src))
			user.visible_message(\
				"<span class='notice'>[user.name] has replaced the damaged APC frame with new one.</span>",\
				"You replace the damaged APC frame with new one.")
			qdel(W)
			stat &= ~BROKEN
			// Malf AI, removes the APC from AI's hacked APCs list.
			if(hacker && hacker.hacked_apcs && (src in hacker.hacked_apcs))
				hacker.hacked_apcs -= src
				hacker = null
			if (opened==2)
				opened = 1
			update_icon()
	else
		if (((stat & BROKEN) || hacker) \
				&& !opened \
				&& W.force >= 5 \
				&& W.w_class >= 3.0 \
				&& prob(20) )
			opened = 2
			user.visible_message("<span class='danger'>The APC cover was knocked down with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You knock down the APC cover with your [W.name]!</span>", \
				"You hear bang")
			update_icon()
		else
			if (istype(user, /mob/living/silicon))
				return src.attack_hand(user)
			if (!opened && wiresexposed && \
				(istype(W, /obj/item/device/multitool) || \
				istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/device/assembly/signaler)))
				return src.attack_hand(user)
			user.visible_message("<span class='danger'>The [src.name] has been hit with the [W.name] by [user.name]!</span>", \
				"<span class='danger'>You hit the [src.name] with your [W.name]!</span>", \
				"You hear bang")

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/emag_act(var/remaining_charges, var/mob/user)
	if (!(emagged || hacker))		// trying to unlock with an emag card
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
					emagged = 1
					locked = 0
					to_chat(user, "<span class='notice'>You emag the APC interface.</span>")
					update_icon()
				else
					to_chat(user, "<span class='warning'>You fail to [ locked ? "unlock" : "lock"] the APC interface.</span>")
				return 1

/obj/machinery/power/apc/attack_hand(mob/user)
//	if (!can_use(user)) This already gets called in interact() and in topic()
//		return
	if(!user)
		return
	src.add_fingerprint(user)

	//Human mob special interaction goes here.
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user

		if(H.species.can_shred(H))
			user.visible_message("<span class='warning'>\The [user] slashes at \the [src]!</span>", "<span class='notice'>You slash at \the [src]!</span>")
			playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

			var/allcut = wires.IsAllCut()

			if(beenhit >= pick(3, 4) && wiresexposed != 1)
				wiresexposed = 1
				src.update_icon()
				src.visible_message("<span class='warning'>\The The [src]'s cover flies open, exposing the wires!</span>")

			else if(wiresexposed == 1 && allcut == 0)
				wires.CutAll()
				src.update_icon()
				src.visible_message("<span class='warning'>\The [src]'s wires are shredded!</span>")
			else
				beenhit += 1
			return

	if(usr == user && opened && (!issilicon(user)))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.update_icon()

			src.cell = null
			user.visible_message("<span class='warning'>[user.name] removes the power cell from [src.name]!</span>",\
								 "<span class='notice'>You remove the power cell.</span>")
//			to_chat(user, "You remove the power cell.")
			charging = 0
			src.update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return
	// do APC interaction
	src.interact(user)

/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed && !istype(user, /mob/living/silicon/ai))
		wires.Interact(user)

	return ui_interact(user)


/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return

	var/list/data = list(
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
					"auto" = list("eqp" = 3),
					"on"   = list("eqp" = 2),
					"off"  = list("eqp" = 1)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on"   = list("lgt" = 2),
					"off"  = list("lgt" = 1)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on"   = list("env" = 2),
					"off"  = list("env" = 1)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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

/obj/machinery/power/apc/proc/isWireCut(var/wireIndex)
	return wires.IsIndexCut(wireIndex)


/obj/machinery/power/apc/proc/can_use(mob/user as mob, var/loud = 0) //used by attack_hand() and Topic()
	if (user.stat)
		to_chat(user, "<span class='warning'>You must be conscious to use [src]!</span>")
		return 0
	if(!user.client)
		return 0
	if(inoperable())
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(user.restrained())
		to_chat(user, "<span class='warning'>You must have free hands to use [src].</span>")
		return 0
	if(user.lying)
		to_chat(user, "<span class='warning'>You must stand to use [src]!</span>")
		return 0
	autoflag = 5
	if (istype(user, /mob/living/silicon))
		var/permit = 0 // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(hacker)
			if(hacker == AI)
				permit = 1
			else if(istype(robot) && robot.connected_ai && robot.connected_ai == hacker) // Cyborgs can use APCs hacked by their AI
				permit = 1

		if(aidisabled && !permit)
			if(!loud)
				to_chat(user, "<span class='danger'>\The [src] have AI control disabled!</span>")
			return 0
	else
		if (!in_range(src, user) || !istype(src.loc, /turf))
			return 0
	var/mob/living/carbon/human/H = user
	if (istype(H) && prob(H.getBrainLoss()))
		to_chat(user, "<span class='danger'>You momentarily forget how to use [src].</span>")
		return 0
	return 1

/obj/machinery/power/apc/Topic(href, href_list)
	if(..())
		return 1

	if(!can_use(usr, 1))
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
		chargemode = !chargemode
		if(!chargemode)
			charging = 0
			update_icon()

	else if (href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = setsubsystem(val)
		update_icon()
		update()

	else if (href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = setsubsystem(val)
		update_icon()
		update()

	else if (href_list["env"])
		var/val = text2num(href_list["env"])
		environ = setsubsystem(val)
		update_icon()
		update()

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

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	src.update()
	update_icon()


/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

//Returns 1 if the APC should attempt to charge
/obj/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)


/obj/machinery/power/apc/draw_power(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/machinery/power/apc/process()

	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return
	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = 1
		return

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	if(debug)
		log_debug("Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light] - Longterm: [longtermpower]")

	if(cell && !shorted)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)

		if(excess > lastused_total)		// if power excess recharge the cell
										// by the same amount just used
			var/draw = draw_power(cellused/CELLRATE) // draw the power needed to charge this cell
			cell.give(draw * CELLRATE)
		else		// no excess, and not enough per-apc
			if( (cell.charge/CELLRATE + excess) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				var/draw = draw_power(excess)
				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * draw)	//recharge with what we can
				charging = 0
			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0


		// Set channels depending on how much charge we have left
		update_channels()

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(src.attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess*CELLRATE, cell.maxcharge*chargelevel)

				ch = draw_power(ch/CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch*CELLRATE) // actually recharge the cell
				lastused_charging = ch
				lastused_total += ch // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = 2

		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge*chargelevel)
					chargecount++
				else
					chargecount = 0

				if(chargecount >= 10)

					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		power_alarm.triggerAlarm(loc, src)
		autoflag = 0

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = 0
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/obj/machinery/power/apc/proc/update_channels()
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2

	if((cell.percent() > AUTO_THRESHOLD_LIGHTING) || longtermpower > 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != 3)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			autoflag = 3
			power_alarm.clearAlarm(loc, src)
	else if((cell.percent() <= AUTO_THRESHOLD_LIGHTING) && (cell.percent() > AUTO_THRESHOLD_EQUIPMENT) && longtermpower < 0)                       // <50%, turn off lighting
		if(autoflag != 2)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 2
	else if(cell.percent() <= AUTO_THRESHOLD_EQUIPMENT)        // <25%, turn off lighting & equipment
		if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 1
	else                                   // zero charge, turn all off
		if(autoflag != 0)
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			power_alarm.triggerAlarm(loc, src)
			autoflag = 0

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
obj/machinery/power/apc/proc/autoset(var/cur_state, var/on)
	switch(cur_state)
		if(POWERCHAN_OFF); //autoset will never turn on a channel set to off
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged


// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
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
	switch(severity)
		if(1.0)
			if (cell)
				cell.ex_act(1.0) // more lags woohoo
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				set_broken()
				if (cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if (prob(25))
				set_broken()
				if (cell && prob(25))
					cell.ex_act(3.0)
	return

/obj/machinery/power/apc/disconnect_terminal(var/obj/machinery/power/terminal/term)
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/proc/set_broken()
	// Aesthetically much better!
	src.visible_message("<span class='notice'>[src]'s screen flickers with warnings briefly!</span>")
	power_alarm.triggerAlarm(loc, src)
	spawn(rand(2,5))
		src.visible_message("<span class='notice'>[src]'s screen suddenly explodes in rain of sparks and small debris!</span>")
		stat |= BROKEN
		operating = 0
		update_icon()
		update()

/obj/machinery/power/apc/proc/reboot()
	//reset various counters so that process() will start fresh
	charging = initial(charging)
	chargecount = initial(chargecount)
	autoflag = initial(autoflag)
	longtermpower = initial(longtermpower)
	failure_timer = initial(failure_timer)

	//start with main breaker off, chargemode in the default state and all channels on auto upon reboot
	operating = 0
	chargemode = initial(chargemode)
	power_alarm.clearAlarm(loc, src)

	lighting = POWERCHAN_ON_AUTO
	equipment = POWERCHAN_ON_AUTO
	environ = POWERCHAN_ON_AUTO

	update_icon()
	update()

// overload the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting(var/chance = 100)
	if(/* !get_connection() || */ !operating || shorted)
		return
	if( cell && cell.charge>=20)
		cell.use(20);
		spawn(0)
			for(var/obj/machinery/light/L in area)
				if(prob(chance))
					L.on = 1
					L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val==1) ? 0 : val
	else if(val == 3)
		return 1
	else
		return 0

// Malfunction: Transfers APC under AI's control
/obj/machinery/power/apc/proc/ai_hack(var/mob/living/silicon/ai/A = null)
	if(!A || !A.hacked_apcs || hacker || aidisabled || A.stat == DEAD)
		return 0
	src.hacker = A
	A.hacked_apcs += src
	locked = 1
	update_icon()
	return 1

/obj/item/weapon/module/power_control
	name = "power control module"
	desc = "Heavy-duty switching circuits for power control."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	item_state = "electronic"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT
#undef APC_UPDATE_ICON_COOLDOWN
