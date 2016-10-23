/obj/item/integrated_circuit/input/external_examine(var/mob/user)
	var/initial_name = initial(name)
	var/message
	if(initial_name == name)
		message = "There is \a [src]."
	else
		message = "There is \a ["\improper[initial_name]"] labeled '[name]'."
	to_chat(user, message)

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	complexity = 1
	inputs = list()
	outputs = list()
	activators = list("on pressed")

/obj/item/integrated_circuit/input/button/get_topic_data(mob/user)
	return list("Press" = "press=1")

/obj/item/integrated_circuit/input/button/OnTopic(href_list, user)
	if(href_list["press"])
		to_chat(user, "<span class='notice'>You press the button labeled '[src.name]'.</span>")
		var/datum/integrated_io/A = activators[1]
		if(A.linked.len)
			for(var/datum/integrated_io/activate/target in A.linked)
				target.holder.check_then_do_work()
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	complexity = 2
	inputs = list()
	outputs = list("number entered")
	activators = list("on entered")

/obj/item/integrated_circuit/input/numberpad/get_topic_data(mob/user)
	return list("Enter Number" = "enter_number=1")

/obj/item/integrated_circuit/input/numberpad/OnTopic(href_list, user)
	if(href_list["enter_number"])
		var/new_input = input(user, "Enter a number, please.","Number pad") as null|num
		if(isnum(new_input) && CanInteract(user, physical_state))
			var/datum/integrated_io/O = outputs[1]
			O.data = new_input
			O.push_data()
			var/datum/integrated_io/A = activators[1]
			A.push_data()
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	complexity = 2
	inputs = list()
	outputs = list("string entered")
	activators = list("on entered")

/obj/item/integrated_circuit/input/textpad/get_topic_data(mob/user)
	return list("Enter Words" = "enter_number=1")

/obj/item/integrated_circuit/input/textpad/OnTopic(href_list, user)
	if(href_list["enter_words"])
		var/new_input = input(user, "Enter some words, please.","Number pad") as null|text
		if(istext(new_input) && CanInteract(user, physical_state))
			var/datum/integrated_io/O = outputs[1]
			O.data = new_input
			O.push_data()
			var/datum/integrated_io/A = activators[1]
			A.push_data()
			return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is."
	icon_state = "medscan"
	complexity = 4
	inputs = list("target ref")
	outputs = list("total health %", "total missing health")
	activators = list("scan")

/obj/item/integrated_circuit/input/med_scanner/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/mob/living/carbon/human/H = I.data_as_type(/mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/total_health = round(H.health/H.maxHealth, 0.1)*100
		var/missing_health = H.maxHealth - H.health

		var/datum/integrated_io/total = outputs[1]
		var/datum/integrated_io/missing = outputs[2]

		total.data = total_health
		missing.data = missing_health

	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/input/adv_med_scanner
	name = "integrated advanced medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is.  \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target ref")
	outputs = list(
		"total health %",
		"total missing health",
		"brute damage",
		"burn damage",
		"tox damage",
		"oxy damage",
		"clone damage"
	)
	activators = list("scan")

/obj/item/integrated_circuit/input/adv_med_scanner/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/mob/living/carbon/human/H = I.data_as_type(/mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/total_health = round(H.health/H.maxHealth, 0.1)*100
		var/missing_health = H.maxHealth - H.health

		var/datum/integrated_io/total = outputs[1]
		var/datum/integrated_io/missing = outputs[2]
		var/datum/integrated_io/brute = outputs[3]
		var/datum/integrated_io/burn = outputs[4]
		var/datum/integrated_io/tox = outputs[5]
		var/datum/integrated_io/oxy = outputs[6]
		var/datum/integrated_io/clone = outputs[7]

		total.data = total_health
		missing.data = missing_health
		brute.data = H.getBruteLoss()
		burn.data = H.getFireLoss()
		tox.data = H.getToxLoss()
		oxy.data = H.getOxyLoss()
		clone.data = H.getCloneLoss()

	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is holding the machine containing it."
	inputs = list()
	outputs = list("located ref")
	activators = list("locate")

/obj/item/integrated_circuit/input/local_locator/do_work()
	var/datum/integrated_io/O = outputs[1]
	O.data = null

	var/obj/item/device/electronic_assembly/assembly = get_assembly(loc)
	if(assembly) // Check to make sure we're actually in a machine.
		if(istype(assembly.loc, /mob/living)) // Now check if someone's holding us.
			O.data = weakref(assembly.loc)

	O.push_data()

/obj/item/integrated_circuit/input/adjacent_locator
	name = "adjacent locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is standing a meter away from the machine."
	extended_desc = "The first pin requires a ref to a kind of object that you want the locator to acquire.  This means that it will \
	give refs to nearby objects that are similar.  If more than one valid object is found nearby, it will choose one of them at \
	random."
	inputs = list("desired type ref")
	outputs = list("located ref")
	activators = list("locate")

/obj/item/integrated_circuit/input/adjacent_locator/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	var/desired_type = A.type

	var/list/nearby_things = range(1, get_turf(src))
	var/list/valid_things = list()
	for(var/atom/thing in nearby_things)
		if(thing.type != desired_type)
			continue
		valid_things.Add(thing)
	if(valid_things.len)
		O.data = weakref(pick(valid_things))
	O.push_data()

/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	complexity = 4
	inputs = list("frequency","code")
	outputs = list()
	activators = list("send signal","on signal received")

	var/frequency = 1457
	var/code = 30
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_circuit/input/signaler/initialize()
	..()
	set_frequency(frequency)
	var/datum/integrated_io/new_freq = inputs[1]
	var/datum/integrated_io/new_code = inputs[2]
	// Set the pins so when someone sees them, they won't show as null
	new_freq.data = frequency
	new_code.data = code

/obj/item/integrated_circuit/input/signaler/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	frequency = 0
	. = ..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/datum/integrated_io/new_freq = inputs[1]
	var/datum/integrated_io/new_code = inputs[2]
	if(isnum(new_freq.data) && new_freq.data > 0)
		set_frequency(new_freq.data)
	if(isnum(new_code.data))
		code = new_code.data


/obj/item/integrated_circuit/input/signaler/do_work() // Sends a signal.
	if(!radio_connection)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	radio_connection.post_signal(src, signal)

/obj/item/integrated_circuit/input/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	if(!radio_controller)
		sleep(20)
	if(!radio_controller)
		return
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/integrated_circuit/input/signaler/receive_signal(datum/signal/signal)
	var/datum/integrated_io/new_code = inputs[2]
	var/code = 0

	if(isnum(new_code.data))
		code = new_code.data
	if(!signal)
		return 0
	if(signal.encryption != code)
		return 0
	if(signal.source == src) // Don't trigger ourselves.
		return 0

	var/datum/integrated_io/A = activators[2]
	A.push_data()

	for(var/mob/O in hearers(1, get_turf(src)))
		O.show_message(text("\icon[] *beep* *beep*", src), 3, "*beep* *beep*", 2)

/obj/item/integrated_circuit/input/teleporter_locator
	name = "teleporter locator"
	desc = "This circuit can locate and allow for selection of teleporter computers."
	icon_state = "gps"
	complexity = 5
	inputs = list()
	outputs = list("teleporter")
	activators = list("on selected")

/obj/item/integrated_circuit/input/teleporter_locator/get_topic_data(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/obj/machinery/computer/teleporter/current_console = O.data_as_type(/obj/machinery/computer/teleporter)

	. = list()
	. += "Current selection: [(current_console && current_console.id) || "None"]"
	. += "Please select a teleporter to lock in on:"
	for(var/obj/machinery/teleport/hub/R in machines)
		var/obj/machinery/computer/teleporter/com = R.com
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use && com.operable())
			.["[com.id] ([R.icon_state == "tele1" ? "Active" : "Inactive"])"] = "tport=[any2ref(com)]"
	.["None (Dangerous)"] = "tport=random"

/obj/item/integrated_circuit/input/teleporter_locator/OnTopic(href_list, user)
	if(href_list["tport"])
		var/datum/integrated_io/O = outputs[1]
		var/output = href_list["tport"] == "random" ? null : locate(href_list["tport"])
		O.data = output && weakref(output)
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		A.push_data()
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/output/screen
	name = "screen"
	desc = "This small screen can display a single piece of data, when the machine is examined closely."
	icon_state = "screen"
	inputs = list("displayed data")
	outputs = list()
	activators = list("load data")
	var/stuff_to_display = null

/obj/item/integrated_circuit/output/screen/disconnect_all()
	..()
	stuff_to_display = null

/obj/item/integrated_circuit/output/screen/any_examine(mob/user)
	to_chat(user, "There is a little screen labeled '[name]', which displays [stuff_to_display ? "'[stuff_to_display]'" : "nothing"].")

/obj/item/integrated_circuit/output/screen/get_topic_data()
	return stuff_to_display ? list(stuff_to_display) : list()

/obj/item/integrated_circuit/output/screen/do_work()
	var/datum/integrated_io/I = inputs[1]
	if(isweakref(I.data))
		var/datum/d = I.data_as_type(/datum)
		if(d)
			stuff_to_display = "[d]"
	else
		stuff_to_display = I.data

/obj/item/integrated_circuit/output/light
	name = "light"
	desc = "This light can turn on and off on command."
	icon_state = "light_adv"
	complexity = 4
	inputs = list()
	outputs = list()
	activators = list("toggle light")
	var/light_toggled = 0
	var/light_brightness = 3
	var/light_rgb = "#FFFFFF"

/obj/item/integrated_circuit/output/light/do_work()
	light_toggled = !light_toggled
	update_lighting()

/obj/item/integrated_circuit/output/light/proc/update_lighting()
	if(light_toggled)
		set_light(l_range = light_brightness, l_power = light_brightness, l_color = light_rgb)
	else
		set_light(0)

/obj/item/integrated_circuit/output/light/advanced/update_lighting()
	var/datum/integrated_io/R = inputs[1]
	var/datum/integrated_io/G = inputs[2]
	var/datum/integrated_io/B = inputs[3]
	var/datum/integrated_io/brightness = inputs[4]

	if(isnum(R.data) && isnum(G.data) && isnum(B.data) && isnum(brightness.data))
		R.data = Clamp(R.data, 0, 255)
		G.data = Clamp(G.data, 0, 255)
		B.data = Clamp(B.data, 0, 255)
		brightness.data = Clamp(brightness.data, 0, 6)
		light_rgb = rgb(R.data, G.data, B.data)
		light_brightness = brightness.data

	..()

/obj/item/integrated_circuit/output/light/advanced
	name = "advanced light"
	desc = "This light can turn on and off on command, in any color, and in various brightness levels."
	icon_state = "light_adv"
	complexity = 8
	inputs = list(
		"R",
		"G",
		"B",
		"Brightness"
	)
	outputs = list()

/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	update_lighting()

/obj/item/integrated_circuit/output/sound
	name = "speaker circuit"
	desc = "A miniature speaker is attached to this component."
	icon_state = "speaker"
	complexity = 8
	cooldown_per_use = 4 SECONDS
	inputs = list(
		"sound ID",
		"volume",
		"frequency"
	)
	outputs = list()
	activators = list("play sound")
	var/list/sounds = list()
	category = /obj/item/integrated_circuit/output/sound

/obj/item/integrated_circuit/output/sound/New()
	..()
	extended_desc = list()
	extended_desc += "The first input pin determines which sound is used. The choices are; "
	extended_desc += jointext(sounds, ", ")
	extended_desc += ". The second pin determines the volume of sound that is played"
	extended_desc += ", and the third determines if the frequency of the sound will vary with each activation."
	extended_desc = jointext(extended_desc, null)

/obj/item/integrated_circuit/output/sound/do_work()
	var/datum/integrated_io/ID = inputs[1]
	var/datum/integrated_io/vol = inputs[2]
	var/datum/integrated_io/frequency = inputs[3]
	if(istext(ID.data) && isnum(vol.data) && (!frequency.data || isnum(frequency.data)))
		var/selected_sound = sounds[ID.data]
		if(!selected_sound)
			return
		vol.data = Clamp(vol.data, 0, 100)
		frequency.data = round(Clamp(frequency.data, 0, 1))
		playsound(get_turf(src), selected_sound, vol.data, frequency.data, -1)
		audible_message("\The [istype(loc, /obj/item/device/electronic_assembly) ? loc : src] plays the sound '[ID.data]'.")

/obj/item/integrated_circuit/output/sound/beeper
	name = "beeper circuit"
	desc = "A miniature speaker is attached to this component.  This is often used in the construction of motherboards, which use \
	the speaker to tell the user if something goes very wrong when booting up.  It can also do other similar synthetic sounds such \
	as buzzing, pinging, chiming, and more."
	sounds = list(
		"beep"			= 'sound/machines/twobeep.ogg',
		"chime"			= 'sound/machines/chime.ogg',
		"buzz sigh"		= 'sound/machines/buzz-sigh.ogg',
		"buzz twice"	= 'sound/machines/buzz-two.ogg',
		"ping"			= 'sound/machines/ping.ogg',
		"synth yes"		= 'sound/machines/synth_yes.ogg',
		"synth no"		= 'sound/machines/synth_no.ogg',
		"warning buzz"	= 'sound/machines/warning-buzzer.ogg'
		)

/obj/item/integrated_circuit/output/sound/beepsky
	name = "securitron sound circuit"
	desc = "A miniature speaker is attached to this component.  Considered by some to be the essential component for a securitron."
	sounds = list(
		"creep"			= 'sound/voice/bcreep.ogg',
		"criminal"		= 'sound/voice/bcriminal.ogg',
		"freeze"		= 'sound/voice/bfreeze.ogg',
		"god"			= 'sound/voice/bgod.ogg',
		"i am the law"	= 'sound/voice/biamthelaw.ogg',
		"insult"		= 'sound/voice/binsult.ogg',
		"radio"			= 'sound/voice/bradio.ogg',
		"secure day"	= 'sound/voice/bsecureday.ogg',
		)

/obj/item/integrated_circuit/output/text_to_speech
	name = "text-to-speech circuit"
	desc = "A miniature speaker is attached to this component."
	extended_desc = "This unit is more advanced than the plain speaker circuit, able to transpose any valid text to speech."
	icon_state = "speaker"
	complexity = 12
	cooldown_per_use = 4 SECONDS
	inputs = list("text")
	outputs = list()
	activators = list("to speech")

/obj/item/integrated_circuit/output/text_to_speech/do_work()
	var/datum/integrated_io/text = inputs[1]
	if(istext(text.data))
		audible_message("\The [istype(loc, /obj/item/device/electronic_assembly) ? loc : src] states, \"[text.data]\"")

/obj/item/integrated_circuit/output/led
	name = "light-emitting diode"
	desc = "This a LED that is lit whenever there is TRUE-equivalent data on its input."
	extended_desc = "TRUE-equivalent values are: Non-empty strings, non-zero numbers, and valid refs."
	complexity = 0.1
	size = 0.1
	icon_state = "led"
	inputs = list("lit")
	outputs = list()
	activators = list()

	var/led_color
	category = /obj/item/integrated_circuit/output/led

/obj/item/integrated_circuit/output/led/external_examine(mob/user)
	var/text_output = list()
	var/initial_name = initial(name)

	// Doing all this work just to have a color-blind friendly output.
	text_output += "There is "
	if(name == initial_name)
		text_output += "\an [name]"
	else
		text_output += "\an ["\improper[initial_name]"] labeled '[name]'"
	text_output += " which is currently [get_pin_data(IC_INPUT, 1) ? "lit <font color=[led_color]>�</font>" : "unlit."]"
	to_chat(user,jointext(text_output,null))

/obj/item/integrated_circuit/output/led/get_topic_data()
	return list("\An [initial(name)] that is currently [get_pin_data(IC_INPUT, 1) ? "lit" : "unlit."]")

/obj/item/integrated_circuit/output/led/red
	name = "red LED"
	led_color = COLOR_RED

/obj/item/integrated_circuit/output/led/orange
	name = "orange LED"
	led_color = COLOR_ORANGE

/obj/item/integrated_circuit/output/led/yellow
	name = "yellow LED"
	led_color = COLOR_YELLOW

/obj/item/integrated_circuit/output/led/green
	name = "green LED"
	led_color = COLOR_GREEN

/obj/item/integrated_circuit/output/led/blue
	name = "blue LED"
	led_color = COLOR_BLUE

/obj/item/integrated_circuit/output/led/purple
	name = "purple LED"
	led_color = COLOR_PURPLE

/obj/item/integrated_circuit/output/led/cyan
	name = "cyan LED"
	led_color = COLOR_CYAN

/obj/item/integrated_circuit/output/led/white
	name = "white LED"
	led_color = COLOR_WHITE

/obj/item/integrated_circuit/output/led/pink
	name = "pink LED"
	led_color = COLOR_PINK
