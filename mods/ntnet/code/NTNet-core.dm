#include "terminal\terminal-core.dm"
GLOBAL_LIST_INIT(NTNet_machines, list())

// modify core
/obj/machinery
	var/NTNet_id

//generating ID
/obj/machinery/proc/get_new_ntnet_id(A)
	NTNet_id = A + num2text(rand(100,999))
	var/list/IDS = list()
	if(NTNet_id in IDS)
		get_new_ntnet_id()
	for(var/obj/machinery/i in GLOB.NTNet_machines)
		if(i == src)
			continue
		IDS += i.NTNet_id
	return

/obj/machinery/door/airlock/Initialize()
	. = ..()
	GLOB.NTNet_machines += src
	get_new_ntnet_id("AL")

/obj/machinery/firealarm/Initialize()
	. = ..()
	GLOB.NTNet_machines += src
	get_new_ntnet_id("FA")

/obj/machinery/power/apc/Initialize()
	. = ..()
	GLOB.NTNet_machines += src
	get_new_ntnet_id("PC")


/datum/terminal/proc/get_remote_ID(ID)
	for(var/obj/machinery/R as anything in SSmachines.get_all_machinery())
		if(R.NTNet_id == ID)
			return R
	return null
