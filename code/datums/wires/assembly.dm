//Used in assembly.dm
#define MAX_FLAG 65535
/datum/wires/assembly
	holder_type = /obj/item/device/assembly
	wire_count = 3
	window_x = 470
	window_y = 470
	row_options2 = " width='360px'"
	random = 1
	can_diagnose = 1
	var/diagnosing = 0


/datum/wires/assembly/New(var/atom/holder, var/num = 3)
	wire_count = num // So we can have different kind of assemblies with different wires.
	..()

/datum/wires/assembly/GenerateWires()
	var/list/colours_to_pick = wireColours.Copy()
	var/list/indexes_to_pick = list()
	var/obj/item/device/assembly/A = holder
	//Generate our indexes
	for(var/i = 1; i < MAX_FLAG && indexes_to_pick.len < wire_count; i += i)
		if(A.wires & i)
			indexes_to_pick += i

	colours_to_pick.len = indexes_to_pick.len

	while(colours_to_pick.len && indexes_to_pick.len)
		// Pick and remove a colour
		var/colour = pick_n_take(colours_to_pick)

		// Pick and remove an index
		var/index = pick_n_take(indexes_to_pick)

		src.wires[colour] = index
		//wires = shuffle(wires)

//Signal wires						// Purpose: Connect to other devices
var/const/WIRE_DIRECT_RECEIVE = 1 	// Can receive signals via direct wiring
var/const/WIRE_DIRECT_SEND = 2		// Can send signals via direct wiring
var/const/WIRE_RADIO_RECEIVE = 4 	// Can receive radio signals
var/const/WIRE_RADIO_SEND = 8		// Can send radio signals
//Processing wires					// Purpose: 'Faulty' wiring without complete failure
var/const/WIRE_PROCESS_RECEIVE = 16	// Can process the received signal proc
var/const/WIRE_PROCESS_SEND = 32	// Can process sent signal proc
var/const/WIRE_PROCESS_ACTIVATE = 64// Can activate it's main function
//Power in/out wires.				// Purpose: Deal with power changes. E.G charging batteries
var/const/WIRE_POWER_RECEIVE = 128	// Can receive power.
var/const/WIRE_POWER_SEND = 256		// Can send out power.
//Miscellaneous/special wires		// Purpose: Anything.
var/const/WIRE_MISC_ACTIVATE = 512	// Optional wire
var/const/WIRE_MISC_SPECIAL = 1024	// Mob reference proc wire check.
var/const/WIRE_MISC_CONNECTION = 2048// Used for data connections.
//Other wires:
var/const/WIRE_ASSEMBLY_PROCESS = 4096 // For things that repeat.
var/const/WIRE_ASSEMBLY_SAFETY = 8192 // For devices with a failsafe
var/const/WIRE_ASSEMBLY_PASSWORD = 16384 // All assemblies have these

/datum/wires/assembly/GetInteractWindow()
	var/obj/item/device/assembly/A = holder
	. += ..()
	if(A)
		var/off = "<font color=#FF0000>off!</font>"
		var/on = "<font color=#00FF00>on</font>"
		var/blinking = "<font color=#FFA500>blinking!</font>"
		if(A.wires & (WIRE_DIRECT_RECEIVE|WIRE_DIRECT_SEND) && (A.wires & WIRE_DIRECT_SEND))
			if(A.active_wires & WIRE_DIRECT_RECEIVE && A.active_wires & WIRE_DIRECT_SEND)
				. += "The <font color=#80000>dark red</font> light is [on]"
			else if(!(A.active_wires & (WIRE_DIRECT_RECEIVE|WIRE_DIRECT_SEND)))
				. += "The <font color=#80000>dark red</font> light is [off]"
			else
				. += "The <font color=#80000>dark red</font> light is [blinking]"
		else if(A.wires & (WIRE_DIRECT_RECEIVE|WIRE_DIRECT_SEND))
			. += "The <font color=#80000>dark red</font> light is [(A.active_wires & WIRE_DIRECT_RECEIVE || A.active_wires & WIRE_DIRECT_SEND)? "[on]" : "[off]"]"


		if(A.wires & WIRE_RADIO_RECEIVE && A.wires & WIRE_RADIO_SEND)
			if(A.active_wires & WIRE_RADIO_RECEIVE && A.active_wires & WIRE_RADIO_SEND)
				. += "<br>The <font color=#0000A0>dark blue</font> light is [on]"
			else if(!(A.active_wires & (WIRE_RADIO_RECEIVE|WIRE_RADIO_SEND)))
				. += "<br>The <font color=#0000A0>dark blue</font> light is [off]"
			else
				. += "<br>The <font color=#0000A0>dark blue</font> light is [blinking]"
		else if(A.wires & (WIRE_RADIO_RECEIVE|WIRE_RADIO_SEND))
			. += "<br>The <font color=#0000A0>dark blue</font> light is [(A.active_wires & WIRE_RADIO_RECEIVE || A.active_wires & WIRE_RADIO_SEND)? "[on]" : "[off]"]"


		if(A.wires & WIRE_PROCESS_RECEIVE && A.wires & WIRE_PROCESS_SEND)
			if(A.active_wires & WIRE_PROCESS_RECEIVE && A.active_wires & WIRE_PROCESS_SEND)
				. += "<br>The <font color=#800080>dark purple</font> light is [on]"
			else if(!(A.active_wires & (WIRE_PROCESS_RECEIVE|WIRE_PROCESS_SEND)))
				. += "<br>The <font color=#800080>dark purple</font> light is [off]"
			else
				. += "<br>The <font color=#800080>dark purple</font> light is [blinking]"
		else if(A.wires & (WIRE_PROCESS_RECEIVE|WIRE_PROCESS_SEND))
			. += "<br>The <font color=#800080>dark purple</font> light is [(A.active_wires & WIRE_PROCESS_RECEIVE || A.active_wires & WIRE_PROCESS_SEND)? "[on]" : "[off]"]"

		if(A.wires & WIRE_PROCESS_ACTIVATE)
			. += "<br>The <font color=#008000>green</font> light is [A.active_wires & WIRE_PROCESS_ACTIVATE ? "[on]" : "[off]"]"

		if(A.wires & WIRE_POWER_RECEIVE && WIRE_POWER_SEND)
			if(A.active_wires & WIRE_POWER_RECEIVE && A.active_wires & WIRE_POWER_SEND)
				. += "<br>The <font color=#FFFF00>yellow</font> light is [on]"
			else if(!(A.active_wires & (WIRE_POWER_RECEIVE|WIRE_POWER_SEND)))
				. += "<br>The <font color=#FFFF00>yellow</font> light is [off]"
			else
				. += "<br>The <font color=#FFFF00>yellow</font> light is [blinking]"
		else if(A.wires & (WIRE_POWER_RECEIVE|WIRE_POWER_SEND))
			. += "<br>The <font color=#FFFF00>yellow</font> light is [(A.active_wires & WIRE_RADIO_RECEIVE || A.active_wires & WIRE_RADIO_SEND)? "[on]" : "[off]"]"
		if(A.wires & WIRE_MISC_ACTIVATE)
			. += "<br>The <font color=#FFA500>orange</font> light is [A.active_wires & WIRE_MISC_ACTIVATE ? "[on]" : "[off]"]"
		if(A.wires & WIRE_MISC_SPECIAL)
			. += "<br>The <font color=#FF00FF>pink</font> light is [A.active_wires & WIRE_MISC_SPECIAL ? "[on]" : "[off]"]"
		if(A.wires & WIRE_MISC_CONNECTION)
			. += "<br>The <font color=#FFFFFF>white</font> light is [A.active_wires & WIRE_MISC_CONNECTION ? "[on]" : "[off]"]<br><hr>"
		if(A.wires & WIRE_ASSEMBLY_PROCESS)
			. += "<br>The check wiring light is [A.active_wires & WIRE_ASSEMBLY_PROCESS ? "[off]" : "[on]"]"
		if(A.wires & WIRE_ASSEMBLY_SAFETY)
			. += "<br>The safety light is [A.active_wires & WIRE_ASSEMBLY_SAFETY ? "[on]" : "[off]"]"
		. += "<br>The maintenance light is [A.active_wires & WIRE_ASSEMBLY_PASSWORD ? "[off]" : "[on]"]"

/datum/wires/assembly/UpdatePulsed(var/index)
	var/obj/item/device/assembly/A = holder
	A.wire_safety(index, 1)
	if(A.holder) A.holder.wire_pulsed(A, index)
	sleep(0)

	switch(index)
		if(WIRE_POWER_RECEIVE, WIRE_POWER_SEND, WIRE_MISC_ACTIVATE, WIRE_MISC_SPECIAL, WIRE_ASSEMBLY_PROCESS, WIRE_ASSEMBLY_SAFETY, WIRE_MISC_CONNECTION)
			A.active_wires ^= index
		if(WIRE_DIRECT_RECEIVE)
			A.receive_direct_pulse()
		if(WIRE_DIRECT_SEND)
			A.send_pulse_to_connected()
		if(WIRE_RADIO_RECEIVE)
			for(var/mob/M in view(1))
				M.show_message("<small>*beep*</small>", 2)
		if(WIRE_RADIO_SEND)
			if(A.radio)
				A.send_radio_pulse()
		if(WIRE_PROCESS_ACTIVATE)
			A.process_activation()
		if(WIRE_ASSEMBLY_PASSWORD)
			if(A.holder)
				A.holder.audible_message("<span class='warning'><small>*click*</small></span>")
			else
				A.audible_message("<span class='warning'><small>*click*</small></span>")
			A.active_wires ^= index

/datum/wires/assembly/UpdateCut(var/index, var/mended)
	var/obj/item/device/assembly/A = holder
	if(!mended) spawn(1)
		A.wire_safety(index, 0)
		if(A.holder)
			A.holder.wire_cut(A, index)
	world << "[index]"
	if(A.active_wires & index)
		if(!mended)
			A.active_wires &= ~index
	else if(mended)
		A.active_wires |= index

/datum/wires/assembly/DiagnoseColour(var/colour, var/mob/living/L) // I'm sure there's a better way to do this
	if(L && colour && !diagnosing)
		L << "<span class='notice'>You begin diagnosing \the [colour] wire in \the [holder]..</span>"
		diagnosing = 1
		if(!do_after(L, rand(50, 300)))
			diagnosing = 0
			return 0
		var/P = rand(0,100)
		var/prob_text = ""
		if(holder)
			var/obj/item/device/assembly/ass = holder
			if(ass.holder && ass.holder.advanced_settings["wiredetector"]==1)
				P = 100
		switch(P)
			if(0 to 10)
				prob_text = "randomly guess that"
			if(11 to 30)
				prob_text = "mixed them up, but found that"
			if(30 to 50)
				prob_text = "are not sure, but you think that"
			if(50 to 60)
				prob_text = "think that"
			if(60 to 75)
				prob_text = "found that"
			if(75 to 90)
				prob_text = "are pretty sure that"
			if(90 to 99)
				prob_text = "are completely sure"
			if(100)
				prob_text = "are certain that"
		var/list/random_lights = list()
		var/obj/item/device/assembly/A = holder
		if(A.wires & (WIRE_DIRECT_RECEIVE|WIRE_DIRECT_SEND)) // Is there a better way to do this?
			random_lights += "Dark Red"
		if(A.wires & (WIRE_RADIO_RECEIVE|WIRE_RADIO_SEND))
			random_lights += "Dark Blue"
		if(A.wires & (WIRE_PROCESS_RECEIVE|WIRE_PROCESS_SEND))
			random_lights += "Dark Purple"
		if(A.wires & WIRE_PROCESS_ACTIVATE)
			random_lights += "Green"
		if(A.wires & (WIRE_POWER_SEND|WIRE_POWER_RECEIVE))
			random_lights += "Yellow"
		if(A.wires & WIRE_MISC_ACTIVATE)
			random_lights += "Orange"
		if(A.wires & WIRE_MISC_SPECIAL)
			random_lights += "Pink"
		if(A.wires & WIRE_MISC_CONNECTION)
			random_lights += "White"
		if(A.wires & WIRE_ASSEMBLY_PROCESS)
			random_lights += "Check Wiring"
		if(A.wires & WIRE_ASSEMBLY_SAFETY)
			random_lights += "Safety"
		random_lights += "Maintenance"
		var/random_light = pick(random_lights)
		var/index = GetIndex(colour)
		if(A.IndexHasSafety(index))
			L << "<span class='notice'>You find a safety device on \the [colour] wire!</span>"
		if(prob(P))
			switch(index)
				if(WIRE_DIRECT_RECEIVE,WIRE_DIRECT_SEND)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to the Dark Purple and Dark Red light.</span>"
				if(WIRE_RADIO_RECEIVE,WIRE_RADIO_SEND)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to the Dark Purple and Dark Blue light.</span>"
				if(WIRE_PROCESS_RECEIVE, WIRE_PROCESS_SEND)
					var/temp = ""
					if(A.wires & (WIRE_DIRECT_RECEIVE|WIRE_DIRECT_SEND)) temp += "Dark Red[A.wires & (WIRE_RADIO_SEND|WIRE_RADIO_RECEIVE) ? "and" : ""]"
					if(A.wires & (WIRE_RADIO_SEND|WIRE_RADIO_RECEIVE)) temp += "Dark Blue"
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the [temp] light.</span>"
				if(WIRE_PROCESS_ACTIVATE)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Green light.</span>"
				if(WIRE_POWER_SEND,WIRE_POWER_RECEIVE)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Yellow light.</span>"
				if(WIRE_MISC_ACTIVATE)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Orange light.</span>"
				if(WIRE_MISC_SPECIAL)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Pink light.</span>"
				if(WIRE_MISC_CONNECTION)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the White light.</span>"
				if(WIRE_ASSEMBLY_PROCESS) // Impossible to diagnose. Shh
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the [random_light] light.</span>"
				if(WIRE_ASSEMBLY_SAFETY)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Safety light.</span>"
				if(WIRE_ASSEMBLY_PASSWORD)
					L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to \the Maintenance light.</span>"

		else
			if(prob(80))
				L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to the [random_light] light.</span>"
			else
				var/temp = random_light
				random_light = pick(random_lights)
				L << "<span class='notice'>You [prob_text] \the [colour] wire is connected to the [random_light] and [temp] light.</span>"
		diagnosing = 0



#undef MAX_FLAG