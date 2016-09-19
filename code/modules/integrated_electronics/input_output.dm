/obj/item/integrated_circuit/input
	var/can_be_asked_input = 0

/obj/item/integrated_circuit/input/proc/ask_for_input(mob/user)
	return

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	number_of_inputs = 0
	number_of_outputs = 0
	number_of_activators = 1
	complexity = 1
	can_be_asked_input = 1
	activator_names = list(
		"on pressed"
	)

/obj/item/integrated_circuit/input/button/ask_for_input(mob/user) //Bit misleading name for this specific use.
	var/datum/integrated_io/A = activators[1]
	if(A.linked.len)
		for(var/datum/integrated_io/activate/target in A.linked)
			target.holder.work()
	user << "<span class='notice'>You press the button labeled '[src.name]'.</span>"

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 2
	can_be_asked_input = 1
	output_names = list(
		"number entered"
	)
	activator_names = list(
		"on entered"
	)

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.","Number pad") as null|num
	if(isnum(new_input))
		var/datum/integrated_io/O = outputs[1]
		O.data = new_input
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		A.push_data()

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 2
	can_be_asked_input = 1
	output_names = list(
		"string entered"
	)
	activator_names = list(
		"on entered"
	)

/obj/item/integrated_circuit/input/textpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter some words, please.","Number pad") as null|text
	if(new_input && istext(new_input))
		var/datum/integrated_io/O = outputs[1]
		O.data = new_input
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		A.push_data()

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is."
	icon_state = "medscan"
	number_of_inputs = 1
	number_of_outputs = 2
	number_of_activators = 1
	complexity = 4
	input_names = list(
		"target ref"
	)
	output_names = list(
		"total health %",
		"total missing health"
	)
	activator_names = list(
		"scan"
	)

/obj/item/integrated_circuit/input/med_scanner/work()
	if(..())
		var/datum/integrated_io/I = inputs[1]
		if(!I.data || !ishuman(I.data)) //Invalid input
			return
		var/mob/living/carbon/human/H = I.data
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
	number_of_inputs = 1
	number_of_outputs = 7
	number_of_activators = 1
	complexity = 12
	input_names = list(
		"target ref"
	)
	output_names = list(
		"total health %",
		"total missing health",
		"brute damage",
		"burn damage",
		"tox damage",
		"oxy damage",
		"clone damage"
	)
	activator_names = list(
		"scan"
	)

/obj/item/integrated_circuit/input/adv_med_scanner/work()
	if(..())
		var/datum/integrated_io/I = inputs[1]
		if(!I.data || !ishuman(I.data)) //Invalid input
			return
		var/mob/living/carbon/human/H = I.data
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
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 4
	output_names = list(
		"located ref"
	)
	activator_names = list(
		"locate"
	)

/obj/item/integrated_circuit/input/local_locator/work()
	if(..())
		var/mob/living/L = null
		var/datum/integrated_io/O = outputs[1]
		O.data = null
		if(istype(src.loc, /obj/item/device/electronic_assembly)) // Check to make sure we're actually in a machine.
			var/obj/item/device/electronic_assembly/assembly = src.loc
			if(istype(assembly.loc, /mob/living)) // Now check if someone's holding us.
				L = assembly.loc

		if(L)
			O.data = L

		O.push_data()

/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	number_of_inputs = 2
	number_of_outputs = 0
	number_of_activators = 2
	complexity = 4
	input_names = list(
		"frequency",
		"code"
	)
	activator_names = list(
		"send signal",
		"on signal received"
	)
	var/frequency = 1457
	var/code = 30
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_circuit/input/signaler/New()
	..()
	spawn(4 SECONDS)
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
	..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/datum/integrated_io/new_freq = inputs[1]
	var/datum/integrated_io/new_code = inputs[2]
	if(isnum(new_freq.data))
		set_frequency(new_freq.data)
	if(isnum(new_code.data))
		code = new_code.data


/obj/item/integrated_circuit/input/signaler/work() // Sends a signal.
	if(..())
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

	for(var/mob/O in hearers(1, src.loc))
		O.show_message(text("\icon[] *beep* *beep*", src), 3, "*beep* *beep*", 2)


/obj/item/integrated_circuit/input/EPv2
	name = "\improper EPv2 circuit"
	desc = "Enables the sending and receiving of messages on the Exonet with the EPv2 protocol."
	extended_desc = "An EPv2 address is a string with the format of XXXX:XXXX:XXXX:XXXX.  Data can be send or received using the \
	second pin on each side, with additonal data reserved for the third pin.  When a message is received, the second activaiton pin \
	will pulse whatever's connected to it.  Pulsing the first activation pin will send a message."
	icon_state = "signal"
	number_of_inputs = 3
	number_of_outputs = 3
	number_of_activators = 2
	complexity = 4
	input_names = list(
		"target EPv2 address",
		"data to send",
		"secondary text"
	)
	output_names = list(
		"address received",
		"data received",
		"secondary text received"
	)
	activator_names = list(
		"send data",
		"on data received"
	)
	var/datum/exonet_protocol/exonet = null

/obj/item/integrated_circuit/input/EPv2/New()
	..()
	exonet = new(src)
	exonet.make_address("EPv2_circuit-\ref[src]")
	desc += "This circuit's EPv2 address is: [exonet.address]."

/obj/item/integrated_circuit/input/EPv2/Destroy()
	if(exonet)
		exonet.remove_address()
		qdel(exonet)
	..()

/obj/item/integrated_circuit/input/EPv2/work()
	if(..())
		var/datum/integrated_io/target_address = inputs[1]
		var/datum/integrated_io/message = inputs[2]
		var/datum/integrated_io/text = inputs[3]
		if(istext(target_address.data))
			exonet.send_message(target_address.data, message.data, text.data)

/obj/item/integrated_circuit/input/receive_exonet_message(var/atom/origin_atom, var/origin_address, var/message, var/text)
	var/datum/integrated_io/message_received = outputs[1]
	var/datum/integrated_io/data_received = outputs[2]
	var/datum/integrated_io/text_received = outputs[3]

	var/datum/integrated_io/A = activators[2]
	A.push_data()

	message_received.write_data_to_pin(origin_address)
	data_received.write_data_to_pin(message)
	text_received.write_data_to_pin(text)

/obj/item/integrated_circuit/output/screen
	name = "screen"
	desc = "This small screen can display a single piece of data, when the machine is examined closely."
	icon_state = "screen"
	complexity = 4
	number_of_inputs = 1
	number_of_outputs = 0
	number_of_activators = 1
	input_names = list(
		"displayed data"
	)
	activator_names = list(
		"load data"
	)
	var/stuff_to_display = null

/obj/item/integrated_circuit/output/screen/work()
	var/datum/integrated_io/I = inputs[1]
	stuff_to_display = I.data

/obj/item/integrated_circuit/output/light
	name = "light"
	desc = "This light can turn on and off on command."
	icon_state = "light_adv"
//	icon_state = "light"
	complexity = 4
	number_of_inputs = 0
	number_of_outputs = 0
	number_of_activators = 1
	activator_names = list(
		"toggle light"
	)
	var/light_toggled = 0
	var/light_brightness = 3
	var/light_rgb = "#FFFFFF"

/obj/item/integrated_circuit/output/light/work()
	if(..())
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
	number_of_inputs = 4
	number_of_outputs = 0
	number_of_activators = 1
	input_names = list(
		"R",
		"G",
		"B",
		"Brightness"
	)

/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	update_lighting()

/obj/item/integrated_circuit/output/sound
	name = "speaker circuit"
	desc = "A miniature speaker is attached to this component."
	icon_state = "speaker"
	complexity = 8
	cooldown_per_use = 4 SECONDS
	number_of_inputs = 3
	number_of_outputs = 0
	number_of_activators = 1
	input_names = list(
		"sound ID",
		"volume",
		"frequency"
	)
	activator_names = list(
		"play sound"
	)
	var/list/sounds = list()

/obj/item/integrated_circuit/output/sound/work()
	if(..())
		var/datum/integrated_io/ID = inputs[1]
		var/datum/integrated_io/vol = inputs[2]
		var/datum/integrated_io/frequency = inputs[3]
		if(istext(ID.data) && isnum(vol.data) && isnum(frequency.data))
			var/selected_sound = sounds[ID.data]
			vol.data = Clamp(vol.data, 0, 1)
			frequency.data = Clamp(frequency.data, 0, 100)
			playsound(get_turf(src), selected_sound, vol.data, frequency.data, -1)

/obj/item/integrated_circuit/output/sound/beeper
	name = "beeper circuit"
	desc = "A miniature speaker is attached to this component.  This is often used in the construction of motherboards, which use \
	the speaker to tell the user if something goes very wrong when booting up.  It can also do other similar synthetic sounds such \
	as buzzing, pinging, chiming, and more."
	extended_desc = "The first input pin determines what sound is used.  The choices are; beep, chime, buzz sigh, buzz twice, ping, \
	synth yes, synth no, warning buzz.  The second pin determines the volume of sound that is played, and the third determines if \
	the frequency of the sound will vary with each activation."
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
	extended_desc = "The first input pin determines what sound is used.  The choices are; creep, criminal, freeze, god, \
	i am the law, insult, radio, secure day.  The second pin determines the volume of sound that is played, and the \
	third determines if the frequency of the sound will vary with each activation."
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

