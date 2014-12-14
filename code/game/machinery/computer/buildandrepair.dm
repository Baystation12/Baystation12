//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name)	"circuit board (" + (name) + ")"

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
//	weight = 1.0E8

/obj/item/weapon/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = "programming=2"
	density = 0
	anchored = 0
	w_class = 2.0
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/frame_desc = null
	var/contain_parts = 1

//Not sure where else to put this
/obj/item/weapon/circuitboard/broken
	name = "broken electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics_smoked"
	origin_tech = null
	board_type = "other"

//Called when the circuitboard is used to contruct a new machine.
/obj/item/weapon/circuitboard/proc/construct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/weapon/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0

/*
	Circuit Board Definitions
*/

/obj/item/weapon/circuitboard/message_monitor
	name = T_BOARD("message monitor console")
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = "programming=3"

//TODO: Move these into computer/camera.dm
/obj/item/weapon/circuitboard/security
	name = T_BOARD("security camera monitor")
	build_path = /obj/machinery/computer/security
	var/network = list("SS13")
	req_access = list(access_security)
	var/locked = 1
	var/emagged = 0

/obj/item/weapon/circuitboard/security/construct(var/obj/machinery/computer/security/C)
	if (..(C))
		C.network = network

/obj/item/weapon/circuitboard/security/deconstruct(var/obj/machinery/computer/security/C)
	if (..(C))
		network = C.network

/obj/item/weapon/circuitboard/security/engineering
	name = T_BOARD("engineering camera monitor")
	build_path = /obj/machinery/computer/security/engineering
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	req_access = list()
/obj/item/weapon/circuitboard/security/mining
	name = T_BOARD("mining camera monitor")
	build_path = /obj/machinery/computer/security/mining
	network = list("MINE")
	req_access = list()
/obj/item/weapon/circuitboard/aicore
	name = T_BOARD("AI core")
	origin_tech = "programming=4;biotech=2"
	board_type = "other"
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
//obj/item/weapon/circuitboard/shield
//	name = T_BOARD("shield control console")
//	build_path = "/obj/machinery/computer/stationshield"
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
/obj/item/weapon/circuitboard/stationalert
	name = T_BOARD("station alert console")
	build_path = /obj/machinery/computer/station_alert
///obj/item/weapon/circuitboard/atmospheresiphonswitch
//	name = T_BOARD("atmosphere siphon control console")
//	build_path = /obj/machinery/computer/atmosphere/siphonswitch
/obj/item/weapon/circuitboard/air_management
	name = T_BOARD("atmosphere monitoring console")
	build_path = /obj/machinery/computer/general_air_control
	var/frequency = 1439
/obj/item/weapon/circuitboard/air_management/tank_control
	name = T_BOARD("tank control")
	build_path = /obj/machinery/computer/general_air_control/large_tank_control
	frequency = 1441
/obj/item/weapon/circuitboard/air_management/supermatter_core
	name = T_BOARD("core control")
	build_path = /obj/machinery/computer/general_air_control/supermatter_core
	frequency = 1438
/obj/item/weapon/circuitboard/air_management/injector_control
	name = T_BOARD("injector control")
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/weapon/circuitboard/air_management/construct(var/obj/machinery/computer/general_air_control/C)
	if (..(C))
		C.frequency = frequency

/obj/item/weapon/circuitboard/air_management/deconstruct(var/obj/machinery/computer/general_air_control/C)
	if (..(C))
		frequency = C.frequency

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
/obj/item/weapon/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core
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
/obj/item/weapon/circuitboard/ordercomp
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/ordercomp
	origin_tech = "programming=2"
/obj/item/weapon/circuitboard/supplycomp
	name = T_BOARD("supply shuttle console")
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = "programming=3"
	var/contraband_enabled = 0

/obj/item/weapon/circuitboard/supplycomp/construct(var/obj/machinery/computer/supplycomp/SC)
	if (..(SC))
		SC.can_order_contraband = contraband_enabled

/obj/item/weapon/circuitboard/supplycomp/deconstruct(var/obj/machinery/computer/supplycomp/SC)
	if (..(SC))
		contraband_enabled = SC.can_order_contraband

/obj/item/weapon/circuitboard/operating
	name = T_BOARD("patient monitoring console")
	build_path = /obj/machinery/computer/operating
	origin_tech = "programming=2;biotech=2"
/obj/item/weapon/circuitboard/comm_monitor
	name = T_BOARD("telecommunications monitor console")
	build_path = /obj/machinery/computer/telecomms/monitor
	origin_tech = "programming=3"
/obj/item/weapon/circuitboard/comm_server
	name = T_BOARD("telecommunications server monitor console")
	build_path = /obj/machinery/computer/telecomms/server
	origin_tech = "programming=3"
/obj/item/weapon/circuitboard/comm_traffic
	name = T_BOARD("telecommunications traffic control console")
	build_path = /obj/machinery/computer/telecomms/traffic
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/curefab
	name = T_BOARD("cure fabricator")
	build_path = /obj/machinery/computer/curer
/obj/item/weapon/circuitboard/splicer
	name = T_BOARD("disease splicer")
	build_path = /obj/machinery/computer/diseasesplicer
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
/obj/item/weapon/circuitboard/HolodeckControl // Not going to let people get this, but it's just here for future
	name = T_BOARD("holodeck control console")
	build_path = /obj/machinery/computer/HolodeckControl
	origin_tech = "programming=4"
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

/obj/item/weapon/circuitboard/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/device/multitool))
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch( alert("Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface","Switch to [opposite_catastasis]","Cancel") )
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel")
				return
			else
				user << "DERP! BUG! Report this (And what you were doing to cause it) to Agouri"
	return

/obj/item/weapon/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		if(emagged)
			user << "Circuit lock is already removed."
			return
		user << "\blue You override the circuit lock and open controls."
		emagged = 1
		locked = 0
	else if(istype(I,/obj/item/weapon/card/id))
		if(emagged)
			user << "\red Circuit lock does not respond."
			return
		if(check_access(I))
			locked = !locked
			user << "\blue You [locked ? "" : "un"]lock the circuit controls."
		else
			user << "\red Access denied."
	else if(istype(I,/obj/item/device/multitool))
		if(locked)
			user << "\red Circuit controls are locked."
			return
		var/existing_networks = list2text(network,",")
		var/input = strip_html(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			usr << "No input found please hang up and try your call again."
			return
		var/list/tempnetwork = text2list(input, ",")
		tempnetwork = difflist(tempnetwork,RESTRICTED_CAMERA_NETWORKS,1)
		if(tempnetwork.len < 1)
			usr << "No network found please hang up and try your call again."
			return
		network = tempnetwork
	return

/obj/item/weapon/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/screwdriver))
		user.visible_message("\blue \the [user] adjusts the jumper on the [src]'s access protocol pins.", "\blue You adjust the jumper on the access protocol pins.")
		if(src.build_path == /obj/machinery/computer/rdconsole/core)
			src.name = T_BOARD("RD Console - Robotics")
			src.build_path = /obj/machinery/computer/rdconsole/robotics
			user << "\blue Access protocols set to robotics."
		else
			src.name = T_BOARD("RD Console")
			src.build_path = /obj/machinery/computer/rdconsole/core
			user << "\blue Access protocols set to default."
	return

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					src.anchored = 1
					src.state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "The welding tool must be on to complete this task."
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					user << "\blue You deconstruct the frame."
					new /obj/item/stack/sheet/metal( src.loc, 5 )
					del(src)
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You unfasten the frame."
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You place the circuit board inside the frame."
					src.icon_state = "1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					user << "\red This frame does not accept circuit boards of this type!"
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You screw the circuit board into place."
				src.state = 2
				src.icon_state = "2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "\blue You remove the circuit board."
				src.state = 1
				src.icon_state = "0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You unfasten the circuit board."
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
					return
				user << "<span class='notice'>You start to add cables to the frame.</span>"
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && state == 2)
					if (C.use(5))
						user << "<span class='notice'>You add cables to the frame.</span>"
						state = 3
						icon_state = "3"
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/sheet/glass))
				var/obj/item/stack/sheet/glass/G = P
				if (G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "\blue You remove the glass panel."
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/sheet/glass( src.loc, 2 )
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You connect the monitor."
				var/B = new src.circuit.build_path ( src.loc )
				src.circuit.construct(B)
				del(src)

#undef T_BOARD
