/obj/machinery/exonet
	idle_power_usage = 100
	icon_state = "bus"
	anchored = 1
	density = 1
	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = 0
	use_power = POWER_USE_ACTIVE

	var/enabled = 1				// Set to 0 if the device was turned off
	var/ui_template				// If interacted with by a multitool, what UI (if any) to display.
	var/ennid					// The ennid in use.
	var/keydata					// The security passphrase for the network
	var/net_tag					// A user-friendly unique name for this device on the network.
	req_components = list(
		/obj/item/weapon/stock_parts/power/apc
	)

/obj/machinery/exonet/New()
	set_extension(src, /datum/extension/exonet_device)
	..()

/obj/machinery/exonet/Initialize()
	if(ennid)
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.connect_network(null, ennid, NETWORKSPEED_ETHERNET, keydata)
	..()

// TODO: Implement more logic here. For now it's only a placeholder.
/obj/machinery/exonet/operable()
	if(!..(EMPED))
		return 0
	if(!enabled)
		return 0
	return 1

/obj/machinery/exonet/Process()
	if(operable())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)

/obj/machinery/exonet/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/exonet/proc/build_ui_data()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()
	var/list/data = list()
	data["network"] = network
	data["name"] = name
	data["ennid"] = ennid
	data["keydata"] = keydata
	data["net_tag"] = net_tag

	. = data

/obj/machinery/exonet/Destroy()
	..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()