
#define ALL_SHIP_JOBS list(/datum/job/UNSC_ship/commander,/datum/job/UNSC_ship/exo,/datum/job/UNSC_ship/cag,\
/datum/job/UNSC_ship/bridge,/datum/job/UNSC_ship/mechanic_chief,/datum/job/UNSC_ship/mechanic,\
/datum/job/UNSC_ship/logistics_chief,/datum/job/UNSC_ship/logistics,/datum/job/UNSC_ship/marine_co,/datum/job/UNSC_ship/marine_xo,\
/datum/job/UNSC_ship/marine_sl,/datum/job/UNSC_ship/weapons,/datum/job/UNSC_ship/marine,/datum/job/UNSC_ship/odst,/datum/job/UNSC_ship/marine/driver,\
/datum/job/UNSC_ship/medical_chief,/datum/job/UNSC_ship/medical,/datum/job/UNSC_ship/security_chief,/datum/job/UNSC_ship/security,\
/datum/job/UNSC_ship/ops_chief,/datum/job/UNSC_ship/ops,/datum/job/UNSC_ship/cmdr_wing,/datum/job/UNSC_ship/cmdr_sqr,\
/datum/job/UNSC_ship/pilot,/datum/job/UNSC_ship/ai,/datum/job/UNSC_ship/gunnery_chief,/datum/job/UNSC_ship/gunnery,\
/datum/job/UNSC_ship/technician_chief,/datum/job/UNSC_ship/technician)

#include "command.dm"
#include "flight.dm"
#include "logistics.dm"
#include "marines.dm"
#include "medical.dm"
#include "naval_security.dm"
#include "operations.dm"
#include "pilot.dm"
#include "ship_ai.dm"
#include "tactical.dm"
#include "technical.dm"

/decl/hierarchy/outfit/job/UNSC_ship
	name = "UNSC_SHIP"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc
	shoes = /obj/item/clothing/shoes/black
	pda_slot = null

	id_type = /obj/item/weapon/card/id/unsc

	flags = 0