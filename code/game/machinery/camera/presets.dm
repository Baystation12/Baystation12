// PRESETS
#define NETWORK_CIVILIAN_WEST "Civilian West"
#define NETWORK_ENGINE "Engine"
#define NETWORK_ENGINEERING "Engineering"
#define NETWORK_ENGINEERING_OUTPOST "Engineering Outpost"
#define NETWORK_MINE "MINE"
#define NETWORK_RESEARCH_OUTPOST "Research Outpost"
#define NETWORK_PRISON "Prison"
#define NETWORK_SECURITY "Security"

var/global/list/station_networks = list(
										"SS13",
										NETWORK_CIVILIAN_WEST,
										NETWORK_ENGINE,
										NETWORK_ENGINEERING,
										NETWORK_ENGINEERING_OUTPOST,
										NETWORK_MINE,
										NETWORK_RESEARCH_OUTPOST,
										NETWORK_PRISON,
										NETWORK_SECURITY
										)
var/global/list/engineering_networks = list(
										NETWORK_ENGINE,
										NETWORK_ENGINEERING,
										NETWORK_ENGINEERING_OUTPOST,
										"Atmosphere Alarms",
										"Fire Alarms",
										"Power Alarms")

/obj/machinery/camera/network/civilian_west
	network = list(NETWORK_CIVILIAN_WEST)

/obj/machinery/camera/network/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/network/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/network/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/network/prison
	network = list(NETWORK_PRISON)

/obj/machinery/camera/network/security
	network = list(NETWORK_SECURITY)

// EMP

/obj/machinery/camera/emp_proof/New()
	..()
	upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/New()
	..()
	upgradeXRay()

// MOTION

/obj/machinery/camera/motion/New()
	..()
	upgradeMotion()

// ALL UPGRADES

/obj/machinery/camera/all/New()
	..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME

/obj/machinery/camera/autoname/civilian_west
	network = list(NETWORK_CIVILIAN_WEST)

/obj/machinery/camera/autoname/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/autoname/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/autoname/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/autoname/mining_outpost
	network = list(NETWORK_MINE)

/obj/machinery/camera/autoname/research_outpost
	network = list(NETWORK_RESEARCH_OUTPOST)

/obj/machinery/camera/autoname/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/autoname
	var/number = 0 //camera number in area

//This camera type automatically sets it's name to whatever the area that it's in is called.
/obj/machinery/camera/autoname/New()
	..()
	spawn(10)
		number = 1
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/camera/autoname/C in world)
				if(C == src) continue
				var/area/CA = get_area(C)
				if(CA.type == A.type)
					if(C.number)
						number = max(number, C.number+1)
			c_tag = "[A.name] #[number]"
		invalidateCameraCache()


// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	var/O = locate(/obj/item/stack/sheet/mineral/osmium) in assembly.upgrades
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
	assembly.upgrades.Add(new /obj/item/stack/sheet/mineral/osmium(assembly))
	setPowerUsage()

/obj/machinery/camera/proc/upgradeXRay()
	assembly.upgrades.Add(new /obj/item/weapon/stock_parts/scanning_module/adv(assembly))
	setPowerUsage()

// If you are upgrading Motion, and it isn't in the camera's New(), add it to the machines list.
/obj/machinery/camera/proc/upgradeMotion()
	assembly.upgrades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	setPowerUsage()

/obj/machinery/camera/proc/setPowerUsage()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	active_power_usage = mult*initial(active_power_usage)

#undef NETWORK_CIVILIAN_WEST
#undef NETWORK_ENGINE
#undef NETWORK_ENGINEERING
#undef NETWORK_ENGINEERING_OUTPOST
#undef NETWORK_MINE
#undef NETWORK_RESEARCH_OUTPOST
#undef NETWORK_PRISON
#undef NETWORK_SECURITY
