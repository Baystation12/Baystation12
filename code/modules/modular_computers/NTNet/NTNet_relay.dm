// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	use_power = 1
	idle_power_usage = 20000 //20kW, apropriate for machine that keeps massive cross-Zlevel wireless network operational.
	icon_state = "bus"

// TODO: Implement more logic here. For now it's only a placeholder.
/obj/machinery/ntnet_relay/proc/is_operational()
	if(stat & (BROKEN | NOPOWER | EMPED))
		return 0
	return 1

/obj/machinery/ntnet_relay/New()
	if(ntnet_global)
		ntnet_global.relays.Add(src)

/obj/machinery/ntnet_relay/Destroy()
	if(ntnet_global)
		ntnet_global.relays.Remove(src)