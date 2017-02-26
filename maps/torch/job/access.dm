/************
* SEV Torch *
************/
/var/const/access_hangar = 73
/datum/access/hangar
	id = access_hangar
	desc = "Hangar Deck"
	region = ACCESS_REGION_GENERAL

/var/const/access_petrov = 74
/datum/access/petrov
	id = access_petrov
	desc = "Petrov"
	region = ACCESS_REGION_GENERAL

/var/const/access_petrov_helm = 75
/datum/access/petrov_helm
	id = access_petrov_helm
	desc = "Petrov Helm"
	region = ACCESS_REGION_GENERAL

/var/const/access_guppy_helm = 76
/datum/access/guppy_helm
	id = access_guppy_helm
	desc = "General Utility Pod Helm"
	region = ACCESS_REGION_GENERAL

/var/const/access_calypso_helm = 77
/datum/access/calypso_helm
	id = access_calypso_helm
	desc = "Calypso Helm"
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
	desc = "NanoTrasen Personnel"
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
	desc = "NanoTrasen Liaison"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO and RD cannot enter and access can't be added with computer.

/var/const/access_representative = 85
/datum/access/representative
	id = access_representative
	desc = "SolGov Representative"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO cannot enter and access can't be added with computer.

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

/var/const/access_calypso = 88
/datum/access/calypso
	id = access_calypso
	desc = "Calypso"
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

/************
* SEV Torch *
************/

/datum/access/robotics
	region = ACCESS_REGION_ENGINEERING

/datum/access/network
	region = ACCESS_REGION_COMMAND
