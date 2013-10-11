#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer

/obj/machinery/status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	anchored = 1
	density = 0
	use_power = 1
	idle_power_usage = 10
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state	// icon_state of alert picture
	var/message1 = ""	// message line 1
	var/message2 = ""	// message line 2
	var/index1			// display index for scrolling messages or 0 if non-scrolling
	var/index2

	var/frequency = 1435		// radio frequency
	var/supply_display = 0		// true if a supply shuttle display

	var/friendc = 0      // track if Friend Computer mode

	maptext_height = 26
	maptext_width = 32

	// new display
	// register for radio system
	New()
		..()
		spawn(5)	// must wait for map loading to finish
			if(radio_controller)
				radio_controller.add_object(src, frequency)


	// timed process

	process()
		if(stat & NOPOWER)
			remove_display()
			return
		update()

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		set_picture("ai_bsod")
		..(severity)

	// set what is displayed

	proc/update()
		if(friendc && mode!=4) //Makes all status displays except supply shuttle timer display the eye -- Urist
			set_picture("ai_friend")
			return

		switch(mode)
			if(0)				//blank
				remove_display()
			if(1)				//emergency shuttle timer
				if(emergency_shuttle.online)
					var/line1
					var/line2 = get_shuttle_timer()
					if(emergency_shuttle.location == 1)
						line1 = "-ETD-"
					else
						line1 = "-ETA-"
					if(length(line2) > CHARS_PER_LINE)
						line2 = "Error!"
					update_display(line1, line2)
				else
					remove_display()
			if(2)				//custom messages
				var/line1
				var/line2

				if(!index1)
					line1 = message1
				else
					line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
					var/message1_len = length(message1)
					index1 += SCROLL_SPEED
					if(index1 > message1_len)
						index1 -= message1_len

				if(!index2)
					line2 = message2
				else
					line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
					var/message2_len = length(message2)
					index2 += SCROLL_SPEED
					if(index2 > message2_len)
						index2 -= message2_len
				update_display(line1, line2)
			if(4)				// supply shuttle timer
				var/line1 = "SUPPLY"
				var/line2
				if(supply_shuttle.moving)
					line2 = get_supply_shuttle_timer()
					if(lentext(line2) > CHARS_PER_LINE)
						line2 = "Error"
				else
					if(supply_shuttle.at_station)
						line2 = "Docked"
					else
						line1 = ""
				update_display(line1, line2)

	examine()
		set src in view()
		. = ..()
		switch(mode)
			if(1,2,4)
				usr << "The display says:<br>\t<xmp>[message1]</xmp><br>\t<xmp>[message2]</xmp>"


	proc/set_message(m1, m2)
		if(m1)
			index1 = (length(m1) > CHARS_PER_LINE)
			message1 = m1
		else
			message1 = ""
			index1 = 0

		if(m2)
			index2 = (length(m2) > CHARS_PER_LINE)
			message2 = m2
		else
			message2 = ""
			index2 = 0

	proc/set_picture(state)
		picture_state = state
		remove_display()
		overlays += image('icons/obj/status_display.dmi', icon_state=picture_state)

	proc/update_display(line1, line2)
		var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
		if(maptext != new_text)
			maptext = new_text

	proc/get_shuttle_timer()
		var/timeleft = emergency_shuttle.timeleft()
		if(timeleft)
			return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
		return ""

	proc/get_supply_shuttle_timer()
		if(supply_shuttle.moving)
			var/timeleft = round((supply_shuttle.eta_timeofday - world.timeofday) / 10,1)
			if(timeleft < 0)
				return "Late"
			return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
		return ""

	proc/remove_display()
		if(overlays.len)
			overlays.Cut()
		if(maptext)
			maptext = ""


	receive_signal(datum/signal/signal)

		switch(signal.data["command"])
			if("blank")
				mode = 0

			if("shuttle")
				mode = 1

			if("message")
				mode = 2
				set_message(signal.data["msg1"], signal.data["msg2"])

			if("alert")
				mode = 3
				set_picture(signal.data["picture_state"])

			if("supply")
				if(supply_display)
					mode = 4



/obj/machinery/ai_status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "AI display"
	anchored = 1
	density = 0

	var/mode = 0	// 0 = Blank
					// 1 = AI emoticon
					// 2 = Blue screen of death

	var/picture_state	// icon_state of ai picture

	var/emotion = "Neutral"


	process()
		if(stat & NOPOWER)
			overlays.Cut()
			return

		update()

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		set_picture("ai_bsod")
		..(severity)

	proc/update()

		if(mode==0) //Blank
			overlays.Cut()
			return

		if(mode==1)	// AI emoticon
			switch(emotion)
				if("Very Happy")
					set_picture("ai_veryhappy")
				if("Happy")
					set_picture("ai_happy")
				if("Neutral")
					set_picture("ai_neutral")
				if("Unsure")
					set_picture("ai_unsure")
				if("Confused")
					set_picture("ai_confused")
				if("Sad")
					set_picture("ai_sad")
				if("BSOD")
					set_picture("ai_bsod")
				if("Blank")
					set_picture("ai_off")
				if("Problems?")
					set_picture("ai_trollface")
				if("Awesome")
					set_picture("ai_awesome")
				if("Dorfy")
					set_picture("ai_urist")
				if("Facepalm")
					set_picture("ai_facepalm")
				if("Friend Computer")
					set_picture("ai_friend")

			return

		if(mode==2)	// BSOD
			set_picture("ai_bsod")
			return


	proc/set_picture(var/state)
		picture_state = state
		if(overlays.len)
			overlays.Cut()
		overlays += image('icons/obj/status_display.dmi', icon_state=picture_state)

#undef CHARS_PER_LINE
#undef FOND_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED