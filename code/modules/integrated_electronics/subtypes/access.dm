/obj/item/integrated_circuit/input/card_reader
	name = "ID card reader" //To differentiate it from the data card reader
	desc = "A circuit that can read the registred name, assignment, and PassKey string from an ID card."
	icon_state = "card_reader"

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	outputs = list(
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
		"passkey" = IC_PINTYPE_STRING
	)
	activators = list(
		"on read" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/input/card_reader/attackby_react(obj/item/I, mob/living/user, intent)
	var/obj/item/weapon/card/id/card = I.GetIdCard()
	var/list/access = I.GetAccess()
	var/passkey = str2hex(XorEncrypt(json_encode(access), SScircuit.cipherkey))

	if(card) // An ID card.
		set_pin_data(IC_OUTPUT, 1, card.registered_name)
		set_pin_data(IC_OUTPUT, 2, card.assignment)

	else if(length(access))	// A non-card object that has access levels.
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)

	else
		return FALSE

	set_pin_data(IC_OUTPUT, 3, passkey)

	push_data()
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/output/access_displayer
	name = "access circuit"
	desc = "broadcasts access for your assembly via a passkey."
	extended_desc = "Useful for moving drones through airlocks."

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list("passkey" = IC_PINTYPE_STRING)
	activators = list(
		"set passkey" = IC_PINTYPE_PULSE_IN
	)
	var/list/access

/obj/item/integrated_circuit/output/access_displayer/do_work()
	access = json_decode(XorEncrypt(hex2str(get_pin_data(IC_INPUT, 1), TRUE), SScircuit.cipherkey))

/obj/item/integrated_circuit/output/access_displayer/GetAccess()
	return access