//ID based turret control instead of area, avoids having ten thousand segmented areas.


GLOBAL_LIST_INIT(antiboarding_turret_list, list())

/obj/machinery/turretid/tur_ID
	name = "wireless turret control system"
	desc = "A wireless point to point turret control system, relying on a seperate data network from the usual turret control systems."
	var/list/turrets = list() //What are our turrets.

/obj/machinery/turretid/tur_ID/dagon
	id_tag = "dagonturret"

/obj/machinery/turretid/tur_ID/Destroy()
	. = ..()

/obj/machinery/turretid/tur_ID/Initialize()
	for(var/obj/machinery/porta_turret/T in GLOB.antiboarding_turret_list)
		if(T.id_tag == id_tag)
			turrets += T
	power_change() //Checks power and initial settings
	. = ..()

/obj/machinery/turretid/tur_ID/Destroy()
	turrets.Cut()
	. = ..()

/obj/machinery/turretid/tur_ID/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	for (var/obj/machinery/porta_turret/aTurret in turrets)
		aTurret.setState(TC)

	queue_icon_update()

/obj/machinery/porta_turret/exterior/dagon
	id_tag = "dagonturret"

/obj/machinery/porta_turret/exterior/Initialize()
	GLOB.antiboarding_turret_list += src
	. = ..()

/obj/machinery/porta_turret/exterior/Destroy()
	GLOB.antiboarding_turret_list -= src
	. = ..()