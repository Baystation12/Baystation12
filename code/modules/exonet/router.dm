// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/exonet/broadcaster/router
	name = "EXONET Router"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	active_power_usage = 8000 //8kW
	ui_template = "exonet_router_configuration.tmpl"
	var/lockdata				// Network security. This key is required to join a network device to the network.
	var/dos_failure = 0			// Set to 1 if the router failed due to (D)DoS attack
	var/list/dos_sources = list()	// Backwards reference for qdel() stuff

	// Denial of Service attack variables
	var/dos_overload = 0		// Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500		// Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 1		// Amount of DoS "packets" dissipated over time.

/obj/machinery/exonet/broadcaster/router/New()
	..()
	// This has to happen pretty early on object construction.
	if(!broadcasting_ennid)
		broadcasting_ennid = initial_ennid
	if(broadcasting_ennid)
		// Sets up the network before anything else can. go go go go
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.broadcast_network(broadcasting_ennid)

// TODO: Implement more logic here. For now it's only a placeholder.
/obj/machinery/exonet/broadcaster/router/operable()
	if(!..(EMPED))
		return 0
	if(dos_failure)
		return 0
	if(!enabled)
		return 0
	return 1

/obj/machinery/exonet/broadcaster/router/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"

/obj/machinery/exonet/broadcaster/router/Process()
	if(operable())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)

	if(dos_overload)
		dos_overload = max(0, dos_overload - dos_dissipate)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		dos_failure = 1
		update_icon()
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		var/datum/exonet/network = exonet.get_local_network()
		network.add_log("EXONET router switched from normal operation mode to overload recovery mode.")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		dos_failure = 0
		update_icon()
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		var/datum/exonet/network = exonet.get_local_network()
		network.add_log("EXONET router switched from overload recovery mode to normal operation mode.")

// /obj/machinery/exonet/broadcaster/router/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
// 	var/list/data = list()
// 	data["enabled"] = enabled
// 	data["dos_capacity"] = dos_capacity
// 	data["dos_overload"] = dos_overload
// 	data["dos_crashed"] = dos_failure
// 	data["portable_drive"] = !!get_component_of_type(/obj/item/weapon/stock_parts/computer/hard_drive/portable)

// 	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
// 	if (!ui)
// 		ui = new(user, src, ui_key, "ntnet_relay.tmpl", "NTNet Quantum Relay", 500, 300, state = state)
// 		ui.set_initial_data(data)
// 		ui.open()
// 		ui.set_auto_update(1)

// /obj/machinery/exonet/broadcaster/router/interface_interact(var/mob/living/user)
// 	ui_interact(user)
// 	return TRUE

// /obj/machinery/exonet/broadcaster/router/Topic(href, href_list)
// 	if(..())
// 		return 1
// 	if(href_list["restart"])
// 		dos_overload = 0
// 		dos_failure = 0
// 		update_icon()
// 		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
// 		var/datum/exonet/network = exonet.get_local_network()
// 		network.add_log("EXONET router manually restarted from overload recovery mode to normal operation mode.")
// 		return 1
// 	else if(href_list["toggle"])
// 		enabled = !enabled
// 		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
// 		var/datum/exonet/network = exonet.get_local_network()
// 		network.add_log("EXONET router manually [enabled ? "enabled" : "disabled"].")
// 		update_icon()
// 		return 1
// 	else if(href_list["purge"])
// 		// ntnet_global.banned_nids.Cut()
// 		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
// 		var/datum/exonet/network = exonet.get_local_network()
// 		network.add_log("Manual override: Network blacklist cleared.")
// 		return 1
// 	else if(href_list["eject_drive"] && uninstall_component(/obj/item/weapon/stock_parts/computer/hard_drive/portable))
// 		visible_message("\icon[src] [src] beeps and ejects its portable disk.")

// /obj/machinery/exonet/broadcaster/router/attackby(obj/item/P, mob/user)
// 	if (!istype(P,/obj/item/weapon/stock_parts/computer/hard_drive/portable))
// 		return
// 	else if (get_component_of_type(/obj/item/weapon/stock_parts/computer/hard_drive/portable))
// 		to_chat(user, "This relay's portable drive slot is already occupied.")
// 	else if(user.unEquip(P,src))
// 		install_component(P)
// 		to_chat(user, "You install \the [P] into \the [src]")

// /obj/machinery/exonet/broadcaster/router/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)