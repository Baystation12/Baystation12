GLOBAL_LIST_EMPTY(active_diseases)
GLOBAL_LIST_EMPTY(med_hud_users)          // List of all entities using a medical HUD.
GLOBAL_LIST_EMPTY(sec_hud_users)          // List of all entities using a security HUD.
GLOBAL_LIST_EMPTY(hud_icon_reference)

GLOBAL_LIST_EMPTY(listening_objects) // List of objects that need to be able to hear, used to avoid recursive searching through contents.

GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_LIST_EMPTY(reg_dna)

GLOBAL_LIST_EMPTY(global_map)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/device/radio/announcer, new)
GLOBAL_DATUM_INIT(global_headset, /obj/item/device/radio/announcer/subspace, new)

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed
GLOBAL_DATUM_INIT(sun, /datum/sun, new)
GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_LIST_INIT(full_alphabet, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))

//This list contains the iconic (ie default, baseline, most well-known) tool for each tool quality.
//It is primarily used to display icons for recipes
//GLOBAL_LIST_INIT(iconic_tools, list(QUALITY_BOLT_TURNING = /obj/item/weapon/tool/wrench,QUALITY_PULSING = /obj/item/weapon/tool/multitool,QUALITY_PRYING = /obj/item/weapon/tool/crowbar,QUALITY_WELDING = /obj/item/weapon/tool/weldingtool,QUALITY_SCREW_DRIVING = /obj/item/weapon/tool/screwdriver,QUALITY_WIRE_CUTTING =  /obj/item/weapon/tool/wirecutters,QUALITY_CLAMPING =  /obj/item/weapon/tool/hemostat,QUALITY_CAUTERIZING = /obj/item/weapon/tool/cautery,QUALITY_RETRACTING = /obj/item/weapon/tool/retractor,QUALITY_DRILLING = /obj/item/weapon/tool/surgicaldrill,QUALITY_SAWING = /obj/item/weapon/tool/saw,QUALITY_BONE_SETTING = /obj/item/weapon/tool/bonesetter,QUALITY_SHOVELING = /obj/item/weapon/tool/shovel,QUALITY_DIGGING = /obj/item/weapon/tool/pickaxe.QUALITY_EXCAVATION = /obj/item/weapon/tool/pickaxe/excavation,QUALITY_CUTTING = /obj/item/weapon/material/knife,QUALITY_LASER_CUTTING = /obj/item/weapon/tool/scalpel/laser,//laser scalpels and e-swords - bloodless cuttingQUALITY_ADHESIVE = /obj/item/weapon/tool/tape_roll,QUALITY_SEALING = /obj/item/weapon/tool/tape_roll,QUALITY_WORKBENCH = /obj/item/weapon/tool/tape_roll))
GLOBAL_LIST_INIT(iconic_tools,
list(QUALITY_BOLT_TURNING = /obj/item/weapon/tool/wrench,
QUALITY_PULSING = /obj/item/weapon/tool/multitool,
QUALITY_PRYING = /obj/item/weapon/tool/crowbar,
QUALITY_WELDING = /obj/item/weapon/tool/weldingtool,
QUALITY_SCREW_DRIVING = /obj/item/weapon/tool/screwdriver,
QUALITY_WIRE_CUTTING =  /obj/item/weapon/tool/wirecutters,
QUALITY_CLAMPING =  /obj/item/weapon/tool/hemostat,
QUALITY_CAUTERIZING = /obj/item/weapon/tool/cautery,
QUALITY_RETRACTING = /obj/item/weapon/tool/retractor,
QUALITY_DRILLING = /obj/item/weapon/tool/surgicaldrill,
QUALITY_SAWING = /obj/item/weapon/tool/saw,
QUALITY_BONE_SETTING = /obj/item/weapon/tool/bonesetter,
QUALITY_SHOVELING = /obj/item/weapon/tool/shovel,
QUALITY_DIGGING = /obj/item/weapon/tool/pickaxe,
QUALITY_EXCAVATION = /obj/item/weapon/tool/pickaxe/excavation,
QUALITY_CUTTING = /obj/item/weapon/material/knife,
QUALITY_LASER_CUTTING = /obj/item/weapon/tool/scalpel/laser,//laser scalpels and e-swords - bloodless cutting
QUALITY_ADHESIVE = /obj/item/weapon/tool/tape_roll,
QUALITY_SEALING = /obj/item/weapon/tool/tape_roll,
QUALITY_WORKBENCH = /obj/item/weapon/tool/tape_roll))