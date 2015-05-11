#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/message_monitor
	name = T_BOARD("message monitor console")
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/aiupload
	name = T_BOARD("AI upload console")
	build_path = /obj/machinery/computer/aiupload
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/borgupload
	name = T_BOARD("cyborg upload console")
	build_path = /obj/machinery/computer/borgupload
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/med_data
	name = T_BOARD("medical records console")
	build_path = /obj/machinery/computer/med_data

/obj/item/weapon/circuitboard/pandemic
	name = T_BOARD("PanD.E.M.I.C. 2200")
	build_path = /obj/machinery/computer/pandemic
	origin_tech = "programming=2;biotech=2"

/obj/item/weapon/circuitboard/scan_consolenew
	name = T_BOARD("DNA machine")
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = "programming=2;biotech=2"

/obj/item/weapon/circuitboard/communications
	name = T_BOARD("command and communications console")
	build_path = /obj/machinery/computer/communications
	origin_tech = "programming=2;magnets=2"

/obj/item/weapon/circuitboard/card
	name = T_BOARD("ID card modification console")
	build_path = /obj/machinery/computer/card

/obj/item/weapon/circuitboard/card/centcom
	name = T_BOARD("CentCom ID card modification console")
	build_path = /obj/machinery/computer/card/centcom

/obj/item/weapon/circuitboard/teleporter
	name = T_BOARD("teleporter control console")
	build_path = /obj/machinery/computer/teleporter
	origin_tech = "programming=2;bluespace=2"

/obj/item/weapon/circuitboard/secure_data
	name = T_BOARD("security records console")
	build_path = /obj/machinery/computer/secure_data

/obj/item/weapon/circuitboard/skills
	name = T_BOARD("employment records console")
	build_path = /obj/machinery/computer/skills

/obj/item/weapon/circuitboard/stationalert_engineering
	name = T_BOARD("station alert console (engineering)")
	build_path = /obj/machinery/computer/station_alert
	
/obj/item/weapon/circuitboard/stationalert_security
	name = T_BOARD("station alert console (security)")
	build_path = /obj/machinery/computer/station_alert
	
/obj/item/weapon/circuitboard/stationalert_all
	name = T_BOARD("station alert console (all)")
	build_path = /obj/machinery/computer/station_alert/all

/obj/item/weapon/circuitboard/atmos_alert
	name = T_BOARD("atmospheric alert console")
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/weapon/circuitboard/pod
	name = T_BOARD("massdriver control")
	build_path = /obj/machinery/computer/pod

/obj/item/weapon/circuitboard/robotics
	name = T_BOARD("robotics control console")
	build_path = /obj/machinery/computer/robotics
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/drone_control
	name = T_BOARD("drone control console")
	build_path = /obj/machinery/computer/drone_control
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/cloning
	name = T_BOARD("cloning control console")
	build_path = /obj/machinery/computer/cloning
	origin_tech = "programming=3;biotech=3"

/obj/item/weapon/circuitboard/arcade
	name = T_BOARD("arcade machine")
	build_path = /obj/machinery/computer/arcade
	origin_tech = "programming=1"

/obj/item/weapon/circuitboard/turbine_control
	name = T_BOARD("turbine control console")
	build_path = /obj/machinery/computer/turbine_computer

/obj/item/weapon/circuitboard/solar_control
	name = T_BOARD("solar control console")
	build_path = /obj/machinery/power/solar_control
	origin_tech = "programming=2;powerstorage=2"

/obj/item/weapon/circuitboard/powermonitor
	name = T_BOARD("power monitoring console")
	build_path = /obj/machinery/computer/power_monitor

/obj/item/weapon/circuitboard/olddoor
	name = T_BOARD("DoorMex")
	build_path = /obj/machinery/computer/pod/old

/obj/item/weapon/circuitboard/syndicatedoor
	name = T_BOARD("ProComp Executive")
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/weapon/circuitboard/swfdoor
	name = T_BOARD("Magix")
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/weapon/circuitboard/prisoner
	name = T_BOARD("prisoner management console")
	build_path = /obj/machinery/computer/prisoner

/obj/item/weapon/circuitboard/mecha_control
	name = T_BOARD("exosuit control console")
	build_path = /obj/machinery/computer/mecha

/obj/item/weapon/circuitboard/rdservercontrol
	name = T_BOARD("R&D server control console")
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/weapon/circuitboard/crew
	name = T_BOARD("crew monitoring console")
	build_path = /obj/machinery/computer/crew
	origin_tech = "programming=3;biotech=2;magnets=2"

/obj/item/weapon/circuitboard/mech_bay_power_console
	name = T_BOARD("mech bay power control console")
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = "programming=2;powerstorage=3"

/obj/item/weapon/circuitboard/operating
	name = T_BOARD("patient monitoring console")
	build_path = /obj/machinery/computer/operating
	origin_tech = "programming=2;biotech=2"

/obj/item/weapon/circuitboard/curefab
	name = T_BOARD("cure fabricator")
	build_path = /obj/machinery/computer/curer

/obj/item/weapon/circuitboard/splicer
	name = T_BOARD("disease splicer")
	build_path = /obj/machinery/computer/diseasesplicer

/obj/item/weapon/circuitboard/ordercomp
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/ordercomp
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/mining_shuttle
	name = T_BOARD("mining shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/mining
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/engineering_shuttle
	name = T_BOARD("engineering shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/engineering
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/research_shuttle
	name = T_BOARD("research shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/research
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/aifixer
	name = T_BOARD("AI integrity restorer")
	build_path = /obj/machinery/computer/aifixer
	origin_tech = "programming=3;biotech=2"

/obj/item/weapon/circuitboard/area_atmos
	name = T_BOARD("area air control console")
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/prison_shuttle
	name = T_BOARD("prison shuttle control console")
	build_path = /obj/machinery/computer/prison_shuttle
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/rcon_console
	name = T_BOARD("RCON remote control console")
	build_path = /obj/machinery/computer/rcon
	origin_tech = "programming=4;engineering=3;powerstorage=5"
