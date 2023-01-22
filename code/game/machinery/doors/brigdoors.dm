#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

///////////////////////////////////////////////////////////////////////////////////////////////
// Brig Door control displays.
//  Description: This is a controls the timer for the brig doors, displays the timer on itself and
//               has a popup window when used, allowing to set the timer.
//  Code Notes: Combination of old brigdoor.dm code from rev4407 and the status_display.dm code
//  Date: 01/September/2010
//  Programmer: Veryinky
/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/door_timer
	name = "Door Timer"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	req_access = list(access_brig)
	anchored = TRUE    		// can't pick it up
	density = FALSE       		// can walk through it.
	var/id = null     		// id of door it controls.
	var/releasetime = 0		// when world.timeofday reaches it - release the prisoner
	var/timing = 1    		// boolean, true/1 timer is on, false/0 means it's not timing
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/machinery/targets = list()
	var/timetoset = 0		// Used to set releasetime upon starting the timer

	maptext_height = 26
	maptext_width = 32

/obj/machinery/door_timer/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door_timer/LateInitialize()
	for(var/obj/machinery/door/window/brigdoor/M in SSmachines.machinery)
		if (M.id == src.id)
			targets += M

	for(var/obj/machinery/flasher/F in SSmachines.machinery)
		if(F.id_tag == src.id)
			targets += F

	for(var/obj/structure/closet/secure_closet/brig/C in world)
		if(C.id == src.id)
			targets += C

	if(targets.len==0)
		set_broken(TRUE)
	queue_icon_update()

//Main door timer loop, if it's timing and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
/obj/machinery/door_timer/Process()
	if(stat & (NOPOWER|BROKEN))	return
	if(src.timing)

		// poorly done midnight rollover
		// (no seriously there's gotta be a better way to do this)
		var/timeleft = timeleft()
		if(timeleft > 1e5)
			src.releasetime = 0


		if(world.timeofday > src.releasetime)
			src.timer_end(TRUE) // open doors, reset timer, clear status screen, broadcast to sec HUDs
			src.timing = 0

		src.update_icon()

	else
		timer_end()

	return


// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.

// Closes and locks doors, power check
/obj/machinery/door_timer/proc/timer_start()
	if(stat & (NOPOWER|BROKEN))	return 0

	// Set releasetime
	releasetime = world.timeofday + timetoset


	//set timing
	timing = 1

	for(var/obj/machinery/door/window/brigdoor/door in targets)
		if(door.density)	continue
		spawn(0)
			door.close()

	for(var/obj/structure/closet/secure_closet/brig/C in targets)
		if(C.broken)	continue
		if(C.opened && !C.close())	continue
		C.locked = TRUE
		C.queue_icon_update()
	return 1


// Opens and unlocks doors, power check
/obj/machinery/door_timer/proc/timer_end(var/broadcast_to_huds = 0)
	if(stat & (NOPOWER|BROKEN))	return 0

	// Reset releasetime
	releasetime = 0

	//reset timing
	timing = 0

	if (broadcast_to_huds)
		broadcast_security_hud_message("The timer for [id] has expired.", src)

	for(var/obj/machinery/door/window/brigdoor/door in targets)
		if(!door.density)	continue
		spawn(0)
			door.open()

	for(var/obj/structure/closet/secure_closet/brig/C in targets)
		if(C.broken)	continue
		if(C.opened)	continue
		C.locked = 0
		C.queue_icon_update()

	return 1


// Check for releasetime timeleft
/obj/machinery/door_timer/proc/timeleft()
	. = round((releasetime - world.timeofday)/10)
	if(. < 0)
		. = 0

// Set timetoset
/obj/machinery/door_timer/proc/timeset(var/seconds)
	timetoset = seconds * 10

	if(timetoset <= 0)
		timetoset = 0

	return

/obj/machinery/door_timer/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/door_timer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	var/timeval = timing ? timeleft() : timetoset/10
	data["timing"] = timing
	data["minutes"] = round(timeval/60)
	data["seconds"] = timeval % 60

	var/list/flashes = list()

	for(var/obj/machinery/flasher/flash  in targets)
		var/list/flashdata = list()
		if(flash.last_flash && (flash.last_flash + 150) > world.time)
			flashdata["status"] = 0
		else
			flashdata["status"] = 1
		flashes[++flashes.len] = flashdata

	data["flashes"] = flashes

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "brig_timer.tmpl", name, 270, 150)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door_timer/CanUseTopic(user, state)
	if(!allowed(user))
		return STATUS_UPDATE
	return ..()

/obj/machinery/door_timer/OnTopic(var/mob/user, var/list/href_list, state)
	if (href_list["toggle"])
		if(timing)
			timer_end()
		else
			timer_start()
			if(timetoset > 18000)
				log_and_message_admins("has started a brig timer over 30 minutes in length!")
		. =  TOPIC_REFRESH

	if (href_list["flash"])
		for(var/obj/machinery/flasher/F in targets)
			F.flash()
		. =  TOPIC_REFRESH

	if (href_list["adjust"])
		timetoset += text2num(href_list["adjust"])
		timetoset = clamp(timetoset, 0, 36000)
		. = TOPIC_REFRESH

	update_icon()


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timing=true, run update display function
/obj/machinery/door_timer/on_update_icon()
	if(stat & (NOPOWER))
		icon_state = "frame"
		return
	if(stat & (BROKEN))
		set_picture("ai_bsod")
		return
	if(src.timing)
		var/disp1 = id
		var/timeleft = timeleft()
		var/disp2 = "[pad_left(num2text((timeleft / 60) % 60), 2, "0")]~[pad_left(num2text(timeleft % 60), 2, "0")]"
		if(length(disp2) > CHARS_PER_LINE)
			disp2 = "Error"
		update_display(disp1, disp2)
	else
		if(maptext)
			maptext = ""
		update_display("Set","Time") // would be nice to have some default printed text
	return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
/obj/machinery/door_timer/proc/set_picture(var/state)
	picture_state = state
	overlays.Cut()
	overlays += image('icons/obj/status_display.dmi', icon_state=picture_state)


//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
/obj/machinery/door_timer/proc/update_display(var/line1, var/line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text


//Actual string input to icon display for loop, with 5 pixel x offsets for each letter.
//Stolen from status_display
/obj/machinery/door_timer/proc/texticon(var/tn, var/px = 0, var/py = 0)
	var/image/I = image('icons/obj/status_display.dmi', "blank")
	var/len = length(tn)

	for(var/d = 1 to len)
		var/char = copytext_char(tn, len-d+1, len-d+2)
		if(char == " ")
			continue
		var/image/ID = image('icons/obj/status_display.dmi', icon_state=char)
		ID.pixel_x = -(d-1)*5 + px
		ID.pixel_y = py
		I.overlays += ID
	return I


/obj/machinery/door_timer/cell_1
	name = "Cell 1"
	id = "Cell 1"

/obj/machinery/door_timer/cell_2
	name = "Cell 2"
	id = "Cell 2"

/obj/machinery/door_timer/cell_3
	name = "Cell 3"
	id = "Cell 3"

/obj/machinery/door_timer/cell_4
	name = "Cell 4"
	id = "Cell 4"

/obj/machinery/door_timer/cell_5
	name = "Cell 5"
	id = "Cell 5"

/obj/machinery/door_timer/cell_6
	name = "Cell 6"
	id = "Cell 6"

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE
