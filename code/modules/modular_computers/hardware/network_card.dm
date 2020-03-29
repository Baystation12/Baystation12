/obj/item/weapon/stock_parts/computer/network_card/
	name = "basic EXONET network card"
	desc = "A basic network card for usage with standard EXONET frequencies."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	var/identification_id = null	// Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_string = "" 	// Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.
	var/proxy_id     // If set, uses the value to funnel connections through another network card.
	var/ennid		// Associated EXONET ENNID.
	var/keydata		// encryption key to access ennid.
	malfunction_probability = 1

/obj/item/weapon/stock_parts/computer/network_card/diagnostics()
	. = ..()
	. += "NIX Unique ID: [identification_id]"
	. += "NIX User Tag: [identification_string]"
	. += "EXONET ennid: [ennid]"
	. += "Supported protocols:"
	. += "511.m SFS (Subspace) - Standard Frequency Spread"
	if(long_range)
		. += "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth"
	if(ethernet)
		. += "OpenEth (Physical Connection) - Physical network connection port"

/obj/item/weapon/stock_parts/computer/network_card/New(var/l)
	..(l)

/obj/item/weapon/stock_parts/computer/network_card/advanced
	name = "advanced EXONET network card"
	desc = "An advanced network card for usage with standard EXONET frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1

/obj/item/weapon/stock_parts/computer/network_card/wired
	name = "wired EXONET network card"
	desc = "An advanced network card for usage with standard EXONET frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3

/obj/item/weapon/stock_parts/computer/network_card/Destroy()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()
	return ..()

// Returns a string identifier of this network card
/obj/item/weapon/stock_parts/computer/network_card/proc/get_network_tag(list/routed_through) // Argument is a safety parameter for internal calls. Don't use manually.
	if(proxy_id && !(src in routed_through))
		var/datum/extension/interactive/ntos/comp = ntnet_global.get_os_by_nid(proxy_id)
		if(comp) // If not we default to exposing ourselves, but it means there was likely a logic error elsewhere.
			LAZYADD(routed_through, src)
			var/obj/item/weapon/stock_parts/computer/network_card/network_card = comp.get_component(PART_NETWORK)
			if(network_card)
				return network_card.get_network_tag(routed_through)
	return "[identification_string] (NID [identification_id])"

/obj/item/weapon/stock_parts/computer/network_card/proc/is_banned()
	return ntnet_global.check_banned(identification_id)

/obj/item/weapon/stock_parts/computer/network_card/proc/get_netspeed()
	var/strength = 1
	if(ethernet)
		strength = 3
	else if(long_range)
		strength = 2
	return strength

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/weapon/stock_parts/computer/network_card/proc/get_signal(var/specific_action = 0, list/routed_through)
	. = 0
	if(!enabled || !check_functionality())
		return

	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()

	if(!network || is_banned())
		return

	if(!network.check_function(specific_action)) // NTNet is down and we are not connected via wired connection. No signal.
		if(!ethernet || specific_action) // Wired connection ensures a basic connection to NTNet, however no usage of disabled network services.
			return

	var/turf/T = get_turf(src)
	if(!istype(T)) //no reception in nullspace
		return

	var/strength = network.get_signal_strength(src, get_netspeed())
	if(strength <= 0)
		return 0
	else if(strength <= 6)
		return 1
	else
		return 2

/obj/item/weapon/stock_parts/computer/network_card/on_disable()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.connect_network(null, ennid, get_netspeed(), keydata)

/obj/item/weapon/stock_parts/computer/network_card/on_enable(var/datum/extension/interactive/ntos/os)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()

/obj/item/weapon/stock_parts/computer/network_card/on_install(var/obj/machinery/machine)
	..()
	var/datum/extension/interactive/ntos/os = get_extension(machine, /datum/extension/interactive/ntos)
	if(os)
		on_enable(os)

/obj/item/weapon/stock_parts/computer/network_card/on_uninstall(var/obj/machinery/machine, var/temporary = FALSE)
	..()
	on_disable()

/obj/item/weapon/stock_parts/computer/network_card/Initialize()
	..()
	set_extension(src, /datum/extension/exonet_device)
	return INITIALIZE_HINT_LATELOAD

/obj/item/weapon/stock_parts/computer/network_card/LateInitialize()
	if(ennid)
		set_ennid(ennid)

/obj/item/weapon/stock_parts/computer/network_card/proc/set_ennid(var/new_ennid)
	ennid = new_ennid
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.connect_network(null, ennid, get_netspeed(), keydata)
	refresh_network()

/obj/item/weapon/stock_parts/computer/network_card/proc/set_keydata(var/new_keydata)
	keydata = new_keydata
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.connect_network(null, ennid, get_netspeed(), keydata)
	refresh_network()

/obj/item/weapon/stock_parts/computer/network_card/proc/refresh_network()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	identification_id = exonet.get_mac_address()