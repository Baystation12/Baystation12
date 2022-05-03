var/global/ntnet_card_uid = 1

/obj/item/stock_parts/computer/network_card
	name = "basic NTNet network card"
	desc = "A basic network card for usage with standard NTNet frequencies."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	critical = FALSE
	icon_state = "netcard_basic"
	hardware_size = 1
	malfunction_probability = 1

	/// Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_id = null
	/// Identification string, technically nickname seen in the network. Can be set by user.
	var/identification_string = ""

	/// Long-range cards have stronger connections, letting them reach relays from connected Z-levels.
	var/long_range = 0
	/// Hard-wired, therefore always on, ignores NTNet wireless checks.
	var/ethernet = 0
	/// If set, uses the value to funnel connections through another network card.
	var/proxy_id

/obj/item/stock_parts/computer/network_card/advanced
	name = "advanced NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1

/obj/item/stock_parts/computer/network_card/wired
	name = "wired NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3

/obj/item/stock_parts/computer/network_card/diagnostics()
	. = ..()
	. += "NIX Unique ID: [identification_id]"
	. += "NIX User Tag: [identification_string]"
	. += "Supported protocols:"
	. += "511.m SFS (Subspace) - Standard Frequency Spread"
	if(long_range)
		. += "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth"
	if(ethernet)
		. += "OpenEth (Physical Connection) - Physical network connection port"

/obj/item/stock_parts/computer/network_card/Initialize()
	. = ..()
	identification_id = ntnet_card_uid
	ntnet_card_uid++

/obj/item/stock_parts/computer/network_card/Destroy()
	ntnet_global.unregister(identification_id)
	return ..()

/obj/item/stock_parts/computer/network_card/proc/set_identification_string(identificator)
	if(identificator && validate_identificator(identificator))
		identification_string = "[identificator]"
		return TRUE
	else if(!identificator)
		identification_string = ""
		return TRUE
	else
		return FALSE

/// Validates identificator name
/obj/item/stock_parts/computer/network_card/proc/validate_identificator(identificator)
	var/list/badchars = list("/","\\",":","*","?","\"","<",">","|","#",","," ")
	for(var/char in badchars)
		if(findtext(identificator, char))
			return FALSE
	return TRUE

/// Returns a list of all network cards this connection passes through before terminating. Argument is a safety parameter for internal calls. Don't use manually.
/obj/item/stock_parts/computer/network_card/proc/get_route(list/routed_through)
	. = !isnull(routed_through) ? routed_through : list()
	if((src in .))
		return
	. += src
	if(proxy_id)
		var/datum/extension/interactive/ntos/comp = ntnet_global.get_os_by_nid(proxy_id)
		if(comp && comp.on)
			var/obj/item/stock_parts/computer/network_card/nc = comp.get_component(PART_NETWORK)
			if(nc && nc.get_signal_direct())
				return nc.get_route(.)

/obj/item/stock_parts/computer/network_card/proc/is_banned()
	return ntnet_global.check_banned(identification_id)

/// Returns the signal strength directly to NTNet for this card. 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/stock_parts/computer/network_card/proc/get_signal_direct()
	. = 0
	if(!check_functionality() || !ntnet_global || is_banned())
		return
	if(!ntnet_global.check_function() && !ethernet)
		return
	var/strength = 1
	if(ethernet)
		strength = 3
	else if(long_range)
		strength = 2
	var/turf/T = get_turf(src)
	if(!istype(T)) //no reception in nullspace
		return
	if(T.z in GLOB.using_map.station_levels) // Computer is on station. Low/High signal depending on what type of network card you have
		. = strength
	else if(T.z in GLOB.using_map.contact_levels) // Not on station, but close enough for radio signal to travel, or long cables in case of ethernet
		. = strength - 1

/// Returns the resolved signal strength, accounting for proxies
/obj/item/stock_parts/computer/network_card/proc/get_signal(specific_action = 0)
	var/list/cards = get_route()
	for(var/i = cards.len; i > 0; i--)
		var/obj/item/stock_parts/computer/network_card/nc = cards[i]
		if(!nc)
			return 0
		// Some extra checks for the last card in the chain
		if(i == cards.len)
			if(nc.proxy_id) // We have an unresolved proxy chain. No signal
				return 0
			if(specific_action && ntnet_global && !ntnet_global.check_capability(specific_action))
				if(!nc.ethernet) // If capabilities are restricted for wireless connections, and public-facing network card is not ethernet, then no signal
					return 0
		. = isnull(.) ? nc.get_signal_direct() : min(., nc.get_signal_direct())
		if(!.) // We don't need to continue if there is no signal
			return

/// Returns the actual string identifier of this network card
/obj/item/stock_parts/computer/network_card/proc/get_network_tag_direct()
	return "[(identification_string ? identification_string : "Unidentified")] (NID [identification_id])"

/// Returns the resolved string identifier of this network card
/obj/item/stock_parts/computer/network_card/proc/get_network_tag()
	. = "Unable to resolve external NID"
	var/list/cards = get_route()
	var/obj/item/stock_parts/computer/network_card/last_card = cards[cards.len]
	if(last_card && !last_card.proxy_id)
		return last_card.get_network_tag_direct()

/obj/item/stock_parts/computer/network_card/on_disable()
	ntnet_global.unregister(identification_id)

/obj/item/stock_parts/computer/network_card/on_enable(datum/extension/interactive/ntos/os)
	ntnet_global.register(identification_id, os)

/obj/item/stock_parts/computer/network_card/on_install(obj/machinery/machine)
	..()
	var/datum/extension/interactive/ntos/os = get_extension(machine, /datum/extension/interactive/ntos)
	if(os)
		on_enable(os)

/obj/item/stock_parts/computer/network_card/on_uninstall(obj/machinery/machine, temporary = FALSE)
	..()
	on_disable()
