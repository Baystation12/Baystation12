/obj/machinery/camera/network/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/network/ert
	network = list(NETWORK_ERT)

/obj/machinery/camera/network/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/network/mercenary
	network = list(NETWORK_MERCENARY)

/obj/machinery/camera/network/mining
	network = list(NETWORK_MINE)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/thunder
	network = list(NETWORK_THUNDER)

// EMP

/obj/machinery/camera/emp_proof/Initialize()
	..()
	. = upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/Initialize()
	. = ..()
	upgradeXRay()

// MOTION

/obj/machinery/camera/motion/Initialize()
	. = ..()
	upgradeMotion()

// ALL UPGRADES

/obj/machinery/camera/all/Initialize()
	. = ..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME left as a map stub
/obj/machinery/camera/autoname

// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	var/O = locate(/obj/item/stack/material/osmium) in assembly.upgrades
	return O

/obj/machinery/camera/proc/isXRay()
	var/obj/item/weapon/stock_parts/scanning_module/O = locate(/obj/item/weapon/stock_parts/scanning_module) in assembly.upgrades
	if (O && O.rating >= 2)
		return O
	return null

/obj/machinery/camera/proc/isMotion()
	var/O = locate(/obj/item/device/assembly/prox_sensor) in assembly.upgrades
	return O

// UPGRADE PROCS

/obj/machinery/camera/proc/upgradeEmpProof()
	assembly.upgrades.Add(new /obj/item/stack/material/osmium(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeXRay()
	assembly.upgrades.Add(new /obj/item/weapon/stock_parts/scanning_module/adv(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeMotion()
	assembly.upgrades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	setPowerUsage()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	update_coverage()

/obj/machinery/camera/proc/setPowerUsage()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	change_power_consumption(mult*initial(active_power_usage), POWER_USE_ACTIVE)