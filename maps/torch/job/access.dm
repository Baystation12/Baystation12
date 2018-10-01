/************
* SEV Torch *
************/
/var/const/access_hangar = 73
/datum/access/hangar
	id = access_hangar
	desc = "Hangar Deck"
	region = ACCESS_REGION_GENERAL

/var/const/access_guppy_helm = 76
/datum/access/guppy_helm
	id = access_guppy_helm
	desc = "General Utility Pod Helm"
	region = ACCESS_REGION_GENERAL

/var/const/access_expedition_shuttle_helm = 77
/datum/access/exploration_shuttle_helm
	id = access_expedition_shuttle_helm
	desc = "Charon Helm"
	region = ACCESS_REGION_GENERAL

/var/const/access_aquila = 78
/datum/access/aquila
	id = access_aquila
	desc = "Aquila"
	region = ACCESS_REGION_GENERAL

/var/const/access_aquila_helm = 79
/datum/access/aquila_helm
	id = access_aquila_helm
	desc = "Aquila Helm"
	region = ACCESS_REGION_GENERAL

/var/const/access_solgov_crew = 80
/datum/access/solgov_crew
	id = access_solgov_crew
	desc = "SolGov Crew"
	region = ACCESS_REGION_GENERAL

/var/const/access_nanotrasen = 81
/datum/access/nanotrasen
	id = access_nanotrasen
	desc = "Corporate Personnel"
	region = ACCESS_REGION_RESEARCH

/var/const/access_robotics_engineering = 82 //two accesses so that you can give access to the lab without giving access to the borgs
/datum/access/robotics_engineering
	id = access_robotics_engineering
	desc = "Biomechanical Engineering"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_emergency_armory = 83
/datum/access/emergency_armory
	id = access_emergency_armory
	desc = "Emergency Armory"
	region = ACCESS_REGION_COMMAND

/var/const/access_liaison = 84
/datum/access/liaison
	id = access_liaison
	desc = "Corporate Liaison"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO and RD cannot enter

/var/const/access_representative = 85
/datum/access/representative
	id = access_representative
	desc = "SolGov Representative"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO cannot enter

/var/const/access_sec_guard = 86
/datum/access/sec_guard
	id = access_sec_guard
	desc = "Security Guard"
	region = ACCESS_REGION_RESEARCH

/var/const/access_gun = 87
/datum/access/gun
	id = access_gun
	desc = "Gunnery"
	region = ACCESS_REGION_COMMAND

/var/const/access_expedition_shuttle = 88
/datum/access/exploration_shuttle
	id = access_expedition_shuttle
	desc = "Charon"
	region = ACCESS_REGION_GENERAL

/var/const/access_guppy = 89
/datum/access/guppy
	id = access_guppy
	desc = "General Utility Pod"
	region = ACCESS_REGION_GENERAL

/var/const/access_seneng = 90
/datum/access/seneng
	id = access_seneng
	desc = "Senior Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_senmed = 91
/datum/access/senmed
	id = access_senmed
	desc = "Physician"
	region = ACCESS_REGION_MEDBAY

/var/const/access_senadv = 92
/datum/access/senadv
	id = access_senadv
	desc = "Senior Enlisted Advisor"
	region = ACCESS_REGION_COMMAND

/var/const/access_explorer = 93
/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

/var/const/access_pathfinder = 94
/datum/access/pathfinder
	id = access_pathfinder
	desc = "Pathfinder"
	region = ACCESS_REGION_GENERAL

/var/const/access_pilot = 95
/datum/access/pilot
	id = access_pilot
	desc = "Pilot"
	region = ACCESS_REGION_GENERAL

/var/const/access_commissary = 96
/datum/access/commissary
	id = access_commissary
	desc = "Commissary"
	region = ACCESS_REGION_GENERAL

/************
* SEV Torch *
************/

/datum/access/robotics
	region = ACCESS_REGION_ENGINEERING

/datum/access/network
	region = ACCESS_REGION_COMMAND

/*************
* NRV Petrov *
*************/
/var/const/access_petrov = 200
/datum/access/petrov
	id = access_petrov
	desc = "Petrov"
	region = ACCESS_REGION_NT

/var/const/access_petrov_helm = 201
/datum/access/petrov_helm
	id = access_petrov_helm
	desc = "Petrov Helm"
	region = ACCESS_REGION_NT

/var/const/access_petrov_analysis = 202
/datum/access/petrov_analysis
	id = access_petrov_analysis
	desc = "Petrov Analysis Lab"
	region = ACCESS_REGION_NT

/var/const/access_petrov_phoron = 203
/datum/access/petrov_phoron
	id = access_petrov_phoron
	desc = "Petrov Phoron Sublimation Lab"
	region = ACCESS_REGION_NT

/var/const/access_petrov_toxins = 204
/datum/access/petrov_toxins
	id = access_petrov_toxins
	desc = "Petrov Toxins Lab"
	region = ACCESS_REGION_NT

/var/const/access_petrov_chemistry = 205
/datum/access/petrov_chemistry
	id = access_petrov_chemistry
	desc = "Petrov Chemistry Lab"
	region = ACCESS_REGION_NT

/var/const/access_petrov_rd = 206
/datum/access/petrov_rd
	id = access_petrov_rd
	desc = "Petrov Research Director's Office"
	region = ACCESS_REGION_NT

/var/const/access_petrov_security = 207
/datum/access/petrov_security
	id = access_petrov_security
	desc = "Petrov Security Office"
	region = ACCESS_REGION_NT

/var/const/access_petrov_maint = 208
/datum/access/petrov_maint
	id = access_petrov_maint
	desc = "Petrov Maintenance"
	region = ACCESS_REGION_NT

/*************
* NRV Petrov *
*************/