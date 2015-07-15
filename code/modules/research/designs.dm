//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials:
- $metal (/obj/item/stack/metal). One sheet = 3750 units.
- $glass (/obj/item/stack/glass). One sheet = 3750 units.
- $phoron (/obj/item/stack/phoron). One sheet = 3750 units.
- $silver (/obj/item/stack/silver). One sheet = 3750 units.
- $gold (/obj/item/stack/gold). One sheet = 3750 units.
- $uranium (/obj/item/stack/uranium). One sheet = 3750 units.
- $diamond (/obj/item/stack/diamond). One sheet = 3750 units.
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 phorontech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 3750 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16	//Remember, objects utilising this flag should have construction_time and construction_cost vars.
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/reliability_mod = 0			//Reliability modifier of the device at it's starting point.
	var/reliability_base = 100		//Base reliability of a device before modifiers.
	var/reliability = 100			//Reliability of the device.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/build_path = null			//The path of the object that gets created.
	var/locked = 0					//If true it will spawn inside a lockbox with currently sec access.
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything.

//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
//Input: A list of /datum/tech; Output: The new reliabilty.
datum/design/proc/CalcReliability(var/list/temp_techs)
	var/new_reliability = reliability_mod + reliability_base
	for(var/datum/tech/T in temp_techs)
		if(T.id in req_tech)
			new_reliability += T.level
	new_reliability = between(reliability_base, new_reliability, 100)
	reliability = new_reliability
	return

datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

///////////////////////////////////
/////General Type Definitions//////
///////////////////////////////////
datum/design/circuit
	build_type = IMPRINTER
	req_tech = list("programming" = 2)
	materials = list("$glass" = 2000, "sacid" = 20)

datum/design/circuit/AssembleDesignName()
	..()
	name = "Circuit design ([item_name])"

datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

datum/design/item
	build_type = PROTOLATHE

///////////////////////////////////
//////////Computer Boards//////////
///////////////////////////////////
datum/design/circuit/seccamera
	name = "security camera monitor"
	id = "seccamera"
	build_path = /obj/item/weapon/circuitboard/security

datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list("programming" = 4, "biotech" = 3)
	build_path = /obj/item/weapon/circuitboard/aicore

datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/aiupload

datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/borgupload

datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating

datum/design/circuit/pandemic
	name = "PanD.E.M.I.C. 2200"
	id = "pandemic"
	build_path = /obj/item/weapon/circuitboard/pandemic

datum/design/circuit/scan_console
	name = "DNA machine"
	id = "scan_console"
	build_path = /obj/item/weapon/circuitboard/scan_consolenew

datum/design/circuit/comconsole
	name = "communications console"
	id = "comconsole"
	build_path = /obj/item/weapon/circuitboard/communications

datum/design/circuit/idcardconsole
	name = "ID card modification console"
	id = "idcardconsole"
	build_path = /obj/item/weapon/circuitboard/card

datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list("programming" = 3, "magnets" = 2, "biotech" = 2)
	build_path = /obj/item/weapon/circuitboard/crew

datum/design/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list("programming" = 3, "bluespace" = 2)

datum/design/circuit/emp_data
	name = "employment records console"
	id = "emp_data"
	build_path = /obj/item/weapon/circuitboard/skills

datum/design/circuit/med_data
	name = "medical records console"
	id = "med_data"
	build_path = /obj/item/weapon/circuitboard/med_data

datum/design/circuit/secdata
	name = "security records console"
	id = "sec_data"
	build_path = /obj/item/weapon/circuitboard/secure_data

datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert

datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management

datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list("programming" = 4, "engineering" = 3, "powerstorage" = 5)
	build_path = /obj/item/weapon/circuitboard/rcon_console

/* Uncomment if someone makes these buildable
datum/design/circuit/general_alert
	name = "general alert console"
	id = "general_alert"
	build_path = /obj/item/weapon/circuitboard/general_alert
*/

datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/robotics

datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/drone_control

datum/design/circuit/clonecontrol
	name = "cloning control console"
	id = "clonecontrol"
	req_tech = list("programming" = 3, "biotech" = 3)
	build_path = /obj/item/weapon/circuitboard/cloning

datum/design/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list("programming" = 3, "biotech" = 3)
	build_path = /obj/item/weapon/circuitboard/clonepod

datum/design/circuit/clonescanner
	name = "cloning scanner"
	id = "clonescanner"
	req_tech = list("programming" = 3, "biotech" = 3)
	build_path = /obj/item/weapon/circuitboard/clonescanner

datum/design/circuit/arcademachine
	name = "arcade machine"
	id = "arcademachine"
	req_tech = list("programming" = 1)
	build_path = /obj/item/weapon/circuitboard/arcade

datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor

datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control

datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner

datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/mecha_control

datum/design/circuit/mechapower
	name = "mech bay power control console"
	id = "mechapower"
	build_path = /obj/item/weapon/circuitboard/mech_bay_power_console

datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole

datum/design/circuit/ordercomp
	name = "supply ordering console"
	id = "ordercomp"
	build_path = /obj/item/weapon/circuitboard/ordercomp

datum/design/circuit/supplycomp
	name = "supply control console"
	id = "supplycomp"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/supplycomp

datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor

datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server

datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list("programming" = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor

datum/design/circuit/aifixer
	name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list("programming" = 3, "biotech" = 2)
	build_path = /obj/item/weapon/circuitboard/aifixer

///////////////////////////////////
/////////Shield Generators/////////
///////////////////////////////////
datum/design/circuit/shield
	req_tech = list("bluespace" = 4, "phorontech" = 3)
	materials = list("$glass" = 2000, "sacid" = 20, "$diamond" = 5000, "$gold" = 10000)

datum/design/circuit/shield/AssembleDesignName()
	name = "Shield generator circuit design ([name])"
datum/design/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

datum/design/circuit/shield/bubble
	name = "bubble"
	id = "shield_gen"
	build_path = /obj/item/weapon/circuitboard/shield_gen

datum/design/circuit/shield/hull
	name = "hull"
	id = "shield_gen_ex"
	build_path = /obj/item/weapon/circuitboard/shield_gen_ex

datum/design/circuit/shield/capacitor
	name = "capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	id = "shield_cap"
	req_tech = list("magnets" = 3, "powerstorage" = 4)
	build_path = /obj/item/weapon/circuitboard/shield_cap

///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////
datum/design/aimodule/
	build_type = IMPRINTER
	materials = list("$glass" = 2000, "sacid" = 20, "$gold" = 100)

datum/design/aimodule/AssembleDesignName()
	name = "AI module design ([name])"
datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list("programming" = 3, "materials" = 4)
	build_path = /obj/item/weapon/aiModule/safeguard

datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list("programming" = 4, "materials" = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman

datum/design/aimodule/protectstation
	name = "ProtectStation"
	id = "protectstation"
	req_tech = list("programming" = 3, "materials" = 6)
	build_path = /obj/item/weapon/aiModule/protectStation

datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline

datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_path = /obj/item/weapon/aiModule/quarantine

datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_path = /obj/item/weapon/aiModule/oxygen

datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list("programming" = 4, "materials" = 4)
	build_path = /obj/item/weapon/aiModule/freeform

datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list("programming" = 3, "materials" = 6)
	build_path = /obj/item/weapon/aiModule/reset

datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list("programming" = 4, "materials" = 6)
	build_path = /obj/item/weapon/aiModule/purge

// *** Core modules
datum/design/aimodule/core
	req_tech = list("programming" = 4, "materials" = 6)

datum/design/aimodule/core/AssembleDesignName()
	name = "AI core module design ([name])"
datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/weapon/aiModule/freeformcore

datum/design/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/weapon/aiModule/asimov

datum/design/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/weapon/aiModule/paladin

datum/design/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list("programming" = 4, "syndicate" = 2, "materials" = 6)
	build_path = /obj/item/weapon/aiModule/tyrant

///////////////////////////////////
////////Telecomms Machinery////////
///////////////////////////////////
datum/design/circuit/tcom
	req_tech = list("programming" = 4, "engineering" = 4)

datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."


datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server

datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor

datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus

datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub

datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list("programming" = 3, "engineering" = 4, "bluespace" = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay

datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list("programming" = 4, "engineering" = 4, "bluespace" = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster

datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list("programming" = 4, "engineering" = 3, "bluespace" = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver

datum/design/circuit/tcom/bluespacerelay
	name = "emergency bluespace relay"
	id = "bluespace-relay"
	req_tech = list("programming" = 4, "bluespace" = 4)
	build_path = /obj/item/weapon/circuitboard/bluespacerelay

///////////////////////////////////
////////////Mecha Modules//////////
///////////////////////////////////
datum/design/circuit/mecha
	req_tech = list("programming" = 3)

datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."


datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/main

datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/peripherals

datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list("programming" = 3,"biotech" = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/main

datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list("programming" = 3,"biotech" = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/peripherals

datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/main

datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/peripherals

datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list("programming" = 4, "combat" = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/targeting

datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/main

datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list("programming" = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/peripherals

datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list("programming" = 4, "combat" = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/targeting

datum/design/circuit/mecha/honker_main
	name = "'H.O.N.K' central control"
	id = "honker_main"
	build_path = /obj/item/weapon/circuitboard/mecha/honker/main

datum/design/circuit/mecha/honker_peri
	name = "'H.O.N.K' peripherals control"
	id = "honker_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/honker/peripherals

datum/design/circuit/mecha/honker_targ
	name = "'H.O.N.K' weapon control and targeting"
	id = "honker_targ"
	build_path = /obj/item/weapon/circuitboard/mecha/honker/targeting

////////////////////////////////////////
/////////// Mecha Equpment /////////////
////////////////////////////////////////

datum/design/item/mecha
	build_type = MECHFAB
	req_tech = list("combat" = 3)
	category = "Exosuit Equipment"

datum/design/item/mecha/AssembleDesignName()
	..()
	name = "Exosuit module design ([item_name])"
datum/design/item/mecha/weapon/AssembleDesignName()
	..()
	name = "Exosuit weapon design ([item_name])"
datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

// *** Weapon modules
datum/design/item/mecha/weapon/scattershot
	id = "mech_scattershot"
	req_tech = list("combat" = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

datum/design/item/mecha/weapon/laser
	id = "mech_laser"
	req_tech = list("combat" = 3, "magnets" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

datum/design/item/mecha/weapon/laser_rigged
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list("combat" = 2, "magnets" = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

datum/design/item/mecha/weapon/laser_heavy
	id = "mech_laser_heavy"
	req_tech = list("combat" = 4, "magnets" = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

datum/design/item/mecha/weapon/ion
	id = "mech_ion"
	req_tech = list("combat" = 4, "magnets" = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

datum/design/item/mecha/weapon/grenade_launcher
	id = "mech_grenade_launcher"
	req_tech = list("combat" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

datum/design/item/mecha/weapon/clusterbang_launcher
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list("combat"= 5, "materials" = 5, "syndicate" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited

// *** Nonweapon modules
datum/design/item/mecha/wormhole_gen
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list("bluespace" = 3, "magnets" = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

datum/design/item/mecha/teleporter
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list("bluespace" = 10, "magnets" = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

datum/design/item/mecha/rcd
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	req_tech = list("materials" = 4, "bluespace" = 3, "magnets" = 4, "powerstorage"=4, "engineering" = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

datum/design/item/mecha/gravcatapult
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list("bluespace" = 2, "magnets" = 3, "engineering" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

datum/design/item/mecha/repair_droid
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list("magnets" = 3, "programming" = 3, "engineering" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

datum/design/item/mecha/phoron_generator
	desc = "Exosuit-mounted phoron generator."
	id = "mech_phoron_generator"
	req_tech = list("phorontech" = 2, "powerstorage"= 2, "engineering" = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator

datum/design/item/mecha/energy_relay
	id = "mech_energy_relay"
	req_tech = list("magnets" = 4, "powerstorage" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

datum/design/item/mecha/ccw_armor
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list("materials" = 5, "combat" = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster

datum/design/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list("materials" = 5, "combat" = 5, "engineering"=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster

datum/design/item/mecha/syringe_gun
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	req_tech = list("materials" = 3, "biotech"=4, "magnets"=4, "programming"=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun

datum/design/item/mecha/diamond_drill
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list("materials" = 4, "engineering" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

datum/design/item/mecha/generator_nuclear
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list("powerstorage"= 3, "engineering" = 3, "materials" = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear


////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
datum/design/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list("programming" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list("$metal" = 30, "$glass" = 10)
	build_path = /obj/item/weapon/disk/design_disk

datum/design/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list("programming" = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list("$metal" = 30, "$glass" = 10)
	build_path = /obj/item/weapon/disk/tech_disk

///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////

datum/design/item/intellicard
	name = "'intelliCard', AI preservation and transportation system"
	desc = "Allows for the construction of an intelliCard."
	id = "intellicard"
	req_tech = list("programming" = 4, "materials" = 4)
	materials = list("$glass" = 1000, "$gold" = 200)
	build_path = /obj/item/device/aicard

datum/design/item/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list("programming" = 2)
	materials = list("$glass" = 500, "$metal" = 500)
	build_path = /obj/item/device/paicard

datum/design/item/posibrain
	id = "posibrain"
	req_tech = list("engineering" = 4, "materials" = 6, "bluespace" = 2, "programming" = 4)
	materials = list("$metal" = 2000, "$glass" = 1000, "$silver" = 1000, "$gold" = 500, "$phoron" = 500, "$diamond" = 100)
	build_path = /obj/item/device/mmi/digital/posibrain

////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////
datum/design/item/stock_part
	build_type = PROTOLATHE

datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list("engineering" = 3, "materials" = 3)
	materials = list("$metal" = 15000, "$glass" = 5000)
	build_path = /obj/item/weapon/storage/part_replacer

datum/design/item/stock_part/basic_capacitor
	build_type = PROTOLATHE | AUTOLATHE
	id = "basic_capacitor"
	req_tech = list("powerstorage" = 1)
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor

datum/design/item/stock_part/basic_sensor
	build_type = PROTOLATHE | AUTOLATHE
	id = "basic_sensor"
	req_tech = list("magnets" = 1)
	materials = list("$metal" = 50, "$glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module

datum/design/item/stock_part/micro_mani
	build_type = PROTOLATHE | AUTOLATHE
	id = "micro_mani"
	req_tech = list("materials" = 1, "programming" = 1)
	materials = list("$metal" = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator

datum/design/item/stock_part/basic_micro_laser
	build_type = PROTOLATHE | AUTOLATHE
	id = "basic_micro_laser"
	req_tech = list("magnets" = 1)
	materials = list("$metal" = 10, "$glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser

datum/design/item/stock_part/basic_matter_bin
	build_type = PROTOLATHE | AUTOLATHE
	id = "basic_matter_bin"
	req_tech = list("materials" = 1)
	materials = list("$metal" = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin

datum/design/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list("powerstorage" = 3)
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv

datum/design/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list("magnets" = 3)
	materials = list("$metal" = 50, "$glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv

datum/design/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list("materials" = 3, "programming" = 2)
	materials = list("$metal" = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano

datum/design/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list("magnets" = 3)
	materials = list("$metal" = 10, "$glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high

datum/design/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list("materials" = 3)
	materials = list("$metal" = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv

datum/design/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list("powerstorage" = 5, "materials" = 4)
	reliability_base = 71
	materials = list("$metal" = 50, "$glass" = 50, "$gold" = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super

datum/design/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list("magnets" = 5, "materials" = 3)
	materials = list("$metal" = 50, "$glass" = 20, "$silver" = 10)
	reliability_base = 72
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic

datum/design/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list("materials" = 5, "programming" = 2)
	materials = list("$metal" = 30)
	reliability_base = 73
	build_path = /obj/item/weapon/stock_parts/manipulator/pico

datum/design/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list("magnets" = 5, "materials" = 5)
	materials = list("$metal" = 10, "$glass" = 20, "$uranium" = 10)
	reliability_base = 70
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra

datum/design/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list("materials" = 5)
	materials = list("$metal" = 80)
	reliability_base = 75
	build_path = /obj/item/weapon/stock_parts/matter_bin/super

/////////////////////////////////////////
//////////Tcommsat Stock Parts///////////
/////////////////////////////////////////

datum/design/item/stock_part/subspace_ansible
	id = "s-ansible"
	req_tech = list("programming" = 3, "magnets" = 4, "materials" = 4, "bluespace" = 2)
	materials = list("$metal" = 80, "$silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible

datum/design/item/stock_part/hyperwave_filter
	id = "s-filter"
	req_tech = list("programming" = 3, "magnets" = 3)
	materials = list("$metal" = 40, "$silver" = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter

datum/design/item/stock_part/subspace_amplifier
	id = "s-amplifier"
	req_tech = list("programming" = 3, "magnets" = 4, "materials" = 4, "bluespace" = 2)
	materials = list("$metal" = 10, "$gold" = 30, "$uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier

datum/design/item/stock_part/subspace_treatment
	id = "s-treatment"
	req_tech = list("programming" = 3, "magnets" = 2, "materials" = 4, "bluespace" = 2)
	materials = list("$metal" = 10, "$silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment

datum/design/item/stock_part/subspace_analyzer
	id = "s-analyzer"
	req_tech = list("programming" = 3, "magnets" = 4, "materials" = 4, "bluespace" = 2)
	materials = list("$metal" = 10, "$gold" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer

datum/design/item/stock_part/subspace_crystal
	id = "s-crystal"
	req_tech = list("magnets" = 4, "materials" = 4, "bluespace" = 2)
	materials = list("$glass" = 1000, "$silver" = 20, "$gold" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal

datum/design/item/stock_part/subspace_transmitter
	id = "s-transmitter"
	req_tech = list("magnets" = 5, "materials" = 5, "bluespace" = 3)
	materials = list("$glass" = 100, "$silver" = 10, "$uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter

////////////////////////////////////////
//////////Misc Circuit Boards///////////
////////////////////////////////////////

datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list("programming" = 2, "magnets" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer

datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe

datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter

datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe

datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol

datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver

datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list("programming" = 3, "engineering" = 3)
	build_path = /obj/item/weapon/circuitboard/mechfab

datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list("powerstorage" = 2, "engineering" = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater

datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list("magnets" = 2, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler

datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list("programming" = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure

datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list("programming" = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator

datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list("programming" = 3, "engineering" = 2)
	build_path = /obj/item/weapon/circuitboard/recharge_station

/////////////////////////////////////////
////////Power Stuff Circuitboards////////
/////////////////////////////////////////
datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list("programming" = 3, "phorontech" = 3, "powerstorage" = 3, "engineering" = 3)
	reliability_base = 79
	materials = list("$glass" = 2000, "sacid" = 20)
	build_path = /obj/item/weapon/circuitboard/pacman

datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list("programming" = 3, "powerstorage" = 4, "engineering" = 4)
	reliability_base = 76
	materials = list("$glass" = 2000, "sacid" = 20)
	build_path = /obj/item/weapon/circuitboard/pacman/super

datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list("programming" = 3, "powerstorage" = 5, "engineering" = 5)
	reliability_base = 74
	materials = list("$glass" = 2000, "sacid" = 20)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs

datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list("powerstorage" = 3, "engineering" = 2)
	materials = list("$glass" = 2000, "sacid" = 20)
	build_path = /obj/item/weapon/circuitboard/batteryrack

datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list("powerstorage" = 7, "engineering" = 5)
	//A uniquely-priced board; probably not the best idea
	materials = list("$glass" = 2000, "sacid" = 20, "$gold" = 1000, "$silver" = 1000, "$diamond" = 500)
	build_path = /obj/item/weapon/circuitboard/smes

////////////////////////////////////////
///////////////Power Items//////////////
////////////////////////////////////////
datum/design/item/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list("magnets" = 3, "materials" = 4)
	materials = list("$metal" = 1500, "$silver" = 150, "$glass" = 3000)
	build_path = /obj/item/device/lightreplacer

// *** Power cells
datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

datum/design/item/powercell/AssembleDesignName()
	name = "Power cell model ([item_name])"

datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

datum/design/item/powercell/basic
	name = "basic"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	id = "basic_cell"
	req_tech = list("powerstorage" = 1)
	materials = list("$metal" = 700, "$glass" = 50)
	build_path = /obj/item/weapon/cell
	category = "Misc"

datum/design/item/powercell/high
	name = "high-capacity"
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	id = "high_cell"
	req_tech = list("powerstorage" = 2)
	materials = list("$metal" = 700, "$glass" = 60)
	build_path = /obj/item/weapon/cell/high
	category = "Misc"

datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list("powerstorage" = 3, "materials" = 2)
	reliability_base = 75
	materials = list("$metal" = 700, "$glass" = 70)
	build_path = /obj/item/weapon/cell/super
	category = "Misc"

datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list("powerstorage" = 5, "materials" = 4)
	reliability_base = 70
	materials = list("$metal" = 400, "$gold" = 150, "$silver" = 150, "$glass" = 70)
	build_path = /obj/item/weapon/cell/hyper
	category = "Misc"

/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////
datum/design/item/medical
	materials = list("$metal" = 30, "$glass" = 20)

datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

datum/design/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list("magnets" = 3, "biotech" = 2, "engineering" = 3)
	materials = list("$metal" = 500, "$glass" = 200)
	build_path = /obj/item/device/robotanalyzer

datum/design/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list("biotech" = 2, "magnets" = 2)
	reliability_base = 76
	build_path = /obj/item/device/mass_spectrometer

datum/design/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list("biotech" = 2, "magnets" = 4)
	reliability_base = 74
	build_path = /obj/item/device/mass_spectrometer/adv

datum/design/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list("biotech" = 2, "magnets" = 2)
	reliability_base = 76
	build_path = /obj/item/device/reagent_scanner

datum/design/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list("biotech" = 2, "magnets" = 4)
	reliability_base = 74
	build_path = /obj/item/device/reagent_scanner/adv

datum/design/item/medical/mmi
	id = "mmi"
	req_tech = list("programming" = 2, "biotech" = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list("$metal" = 1000, "$glass" = 500)
	reliability_base = 76
	build_path = /obj/item/device/mmi
	category = "Misc"

datum/design/item/medical/mmi_radio
	id = "mmi_radio"
	req_tech = list("programming" = 2, "biotech" = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list("$metal" = 1200, "$glass" = 500)
	reliability_base = 74
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"

datum/design/item/medical/synthetic_flash
	id = "sflash"
	req_tech = list("magnets" = 3, "combat" = 2)
	build_type = MECHFAB
	materials = list("$metal" = 750, "$glass" = 750)
	reliability_base = 76
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

datum/design/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list("materials" = 4, "engineering" = 3)
	materials = list("$metal" = 7000, "$glass" = 7000)
	build_path = /obj/item/stack/nanopaste

datum/design/item/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list("biotech" = 2, "materials" = 2, "magnets" = 2)
	materials = list("$metal" = 12500, "$glass" = 7500)
	build_path = /obj/item/weapon/scalpel/laser1

datum/design/item/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list("biotech" = 3, "materials" = 4, "magnets" = 4)
	materials = list("$metal" = 12500, "$glass" = 7500, "$silver" = 2500)
	build_path = /obj/item/weapon/scalpel/laser2

datum/design/item/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list("biotech" = 4, "materials" = 6, "magnets" = 5)
	materials = list("$metal" = 12500, "$glass" = 7500, "$silver" = 2000, "$gold" = 1500)
	build_path = /obj/item/weapon/scalpel/laser3

datum/design/item/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list("biotech" = 4, "materials" = 7, "magnets" = 5, "programming" = 4)
	materials = list ("$metal" = 12500, "$glass" = 7500, "$silver" = 1500, "$gold" = 1500, "$diamond" = 750)
	build_path = /obj/item/weapon/scalpel/manager

// *** Beakers (not really a subtype of design/item/medical)
datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

datum/design/item/beaker/bluespace
	name = "bluespace"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list("bluespace" = 2, "materials" = 6)
	materials = list("$metal" = 3000, "$phoron" = 3000, "$diamond" = 500)
	reliability_base = 76
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace

datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list("materials" = 2)
	materials = list("$metal" = 3000)
	reliability_base = 76
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	category = "Misc"

// *** Implants (not really a subtype of design/item/medical)
datum/design/item/implant
	materials = list("$metal" = 50, "$glass" = 50)

datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/* // Removal of loyalty implants. Can't think of a way to add this to the config option.
datum/design/item/implant/loyalty
	name = "loyalty"
	id = "implant_loyal"
	req_tech = list("materials" = 2, "biotech" = 3)
	materials = list("$metal" = 7000, "$glass" = 7000)
	build_path = /obj/item/weapon/implantcase/loyalty"
*/

datum/design/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list("materials" = 2, "biotech" = 3)
	build_path = /obj/item/weapon/implantcase/chem

datum/design/item/implant/freedom
	name = "freedom"
	id = "implant_free"
	req_tech = list("syndicate" = 2, "biotech" = 3)
	build_path = /obj/item/weapon/implantcase/freedom

/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////
datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

datum/design/item/weapon/nuclear_gun
	id = "nuclear_gun"
	req_tech = list("combat" = 3, "materials" = 5, "powerstorage" = 3)
	materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 500)
	reliability_base = 76
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	locked = 1

datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list("combat" = 3, "materials" = 3, "powerstorage" = 2)
	materials = list("$metal" = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	locked = 1

datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list("combat" = 4, "materials" = 3, "powerstorage" = 3)
	materials = list("$metal" = 10000, "$glass" = 1000, "$diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	locked = 1

datum/design/item/weapon/decloner
	id = "decloner"
	req_tech = list("combat" = 8, "materials" = 7, "biotech" = 5, "powerstorage" = 6)
	materials = list("$gold" = 5000,"$uranium" = 10000, "mutagen" = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	locked = 1

datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list("materials" = 3, "engineering" = 3, "biotech" = 2)
	materials = list("$metal" = 5000, "$glass" = 1000)
	reliability_base = 100
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer

datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3, "biotech" = 2)
	materials = list("$metal" = 5000, "$glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
/*
datum/design/item/weapon/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	id = "largecrossbow"
	req_tech = list("combat" = 4, "materials" = 5, "engineering" = 3, "biotech" = 4, "syndicate" = 3)
	materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 1000, "$silver" = 1000)
	build_path = /obj/item/weapon/gun/energy/crossbow/largecrossbow"
*/
datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list("combat" = 3, "materials" = 4, "powerstorage" = 3, "magnets" = 2)
	materials = list("$metal" = 5000, "$glass" = 500, "$silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	locked = 1

datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list("materials" = 2, "biotech" = 3, "powerstorage" = 3)
	materials = list("$metal" = 2000, "$glass" = 500, "$uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/floragun

datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list("combat" = 3, "materials" = 2)
	materials = list("$metal" = 3000)
	reliability_base = 79
	build_path = /obj/item/weapon/grenade/chem_grenade/large

datum/design/item/weapon/smg
	id = "smg"
	req_tech = list("combat" = 4, "materials" = 3)
	materials = list("$metal" = 8000, "$silver" = 2000, "$diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	locked = 1

datum/design/item/weapon/ammo_9mm
	id = "ammo_9mm"
	req_tech = list("combat" = 4, "materials" = 3)
	materials = list("$metal" = 3750, "$silver" = 100)
	build_path = /obj/item/ammo_magazine/c9mm

datum/design/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list("combat" = 3, "materials" = 3)
	materials = list("$metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list("combat" = 5, "phorontech" = 4)
	materials = list("$metal" = 5000, "$glass" = 1000, "$phoron" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun

/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////
//Subtype of item/weapon/, because we get the nice desc update
datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list("materials" = 3, "powerstorage" = 2, "engineering" = 2)
	materials = list("$metal" = 2000, "$glass" = 500, "$silver" = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer

datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list("materials" = 2, "powerstorage" = 3, "engineering" = 2)
	materials = list("$metal" = 6000, "$glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill

datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list("materials" = 4, "phorontech" = 3, "engineering" = 3)
	materials = list("$metal" = 1500, "$glass" = 500, "$gold" = 500, "$phoron" = 500)
	reliability_base = 79
	build_path = /obj/item/weapon/pickaxe/plasmacutter

datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list("materials" = 6)
	materials = list("$diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond

datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list("materials" = 6, "powerstorage" = 4, "engineering" = 4)
	materials = list("$metal" = 3000, "$glass" = 1000, "$diamond" = 3750) //Yes, a whole diamond is needed.
	reliability_base = 79
	build_path = /obj/item/weapon/pickaxe/diamonddrill

/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////
datum/design/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list("bluespace" = 1)
	materials = list ("$metal" = 20, "$glass" = 10)
	build_path = /obj/item/device/radio/beacon

datum/design/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list("bluespace" = 4, "materials" = 6)
	materials = list("$gold" = 3000, "$diamond" = 1500, "$uranium" = 250)
	reliability_base = 80
	build_path = /obj/item/weapon/storage/backpack/holding

/*
datum/design/bluespace_crystal
	name = "Artificial bluespace crystal"
	desc = "A small blue crystal with mystical properties."
	id = "bluespace_crystal"
	req_tech = list("bluespace" = 5, "materials" = 7)
	build_type = PROTOLATHE
	materials = list("$gold" = 1500, "$diamond" = 3000, "$phoron" = 1500)
	reliability_base = 100
	build_path = /obj/item/bluespace_crystal/artificial"
*/

/////////////////////////////////////////
/////////////////HUDs////////////////////
/////////////////////////////////////////
datum/design/item/hud
	materials = list("$metal" = 50, "$glass" = 50)

datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list("biotech" = 2, "magnets" = 3)
	build_path = /obj/item/clothing/glasses/hud/health

datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list("magnets" = 3, "combat" = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/////////////////////////////////////////
////////////////PDA Stuff////////////////
/////////////////////////////////////////
datum/design/item/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/device/pda

// *** Cartridges
datum/design/item/pda_cartridge
	req_tech = list("engineering" = 2, "powerstorage" = 3)
	materials = list("$metal" = 50, "$glass" = 50)

datum/design/item/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

datum/design/item/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
datum/design/item/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
datum/design/item/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
datum/design/item/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
datum/design/item/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
datum/design/item/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	locked = 1
datum/design/item/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
/*
datum/design/item/pda_cartridge/clown
	id = "cart_clown"
	build_path = /obj/item/weapon/cartridge/clown"
datum/design/item/pda_cartridge/mime
	id = "cart_mime"
	build_path = /obj/item/weapon/cartridge/mime"
*/
datum/design/item/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
datum/design/item/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	locked = 1
datum/design/item/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	locked = 1
datum/design/item/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	locked = 1
datum/design/item/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	locked = 1
datum/design/item/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	locked = 1
datum/design/item/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	locked = 1
datum/design/item/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	locked = 1

/////////////////////////////////////////
///////////////Misc Stuff////////////////
/////////////////////////////////////////
datum/design/item/borg_syndicate_module
	name = "Cyborg lethal weapons upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	build_type = MECHFAB
	req_tech = list("combat" = 4, "syndicate" = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Cyborg Upgrade Modules"

datum/design/item/mesons
	name = "Optical meson scanners design"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list("magnets" = 2, "engineering" = 2)
	materials = list("$metal" = 50, "$glass" = 50)
	build_path = /obj/item/clothing/glasses/meson

datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list("syndicate" = 2)
	materials = list("$metal" = 300, "$glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary

datum/design/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list("syndicate" = 2)
	materials = list("$metal" = 500)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
