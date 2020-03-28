/obj/machinery/exonet
	var/enabled = 1				// Set to 0 if the device was turned off
	var/initial_ennid			// Optional variable for setting the device up with an ennid right on initialize.
	var/initial_keydata			// The keydata for the ennid in order to validate/authenticate with the network.

/obj/machinery/exonet/New()
	set_extension(src, /datum/extension/exonet_device)

/obj/machinery/exonet/Initialize()
	if(initial_ennid)
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.set_tag(null, initial_ennid, NETWORKSPEED_ETHERNET, initial_keydata)
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