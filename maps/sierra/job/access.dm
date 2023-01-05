/************
* NSV sierra *
************/
/var/const/access_hangar = "ACCESS_HANGAR" //73
/datum/access/hangar
	id = access_hangar
	desc = "Hangar Deck"
	region = ACCESS_REGION_GENERAL

/var/const/access_petrov = "ACCESS_PETROV"//74
/datum/access/petrov
	id = access_petrov
	desc = "Petrov"
	region = ACCESS_REGION_RESEARCH

/var/const/access_petrov_helm = "ACCESS_PETROV_HELM"//75
/datum/access/petrov_helm
	id = access_petrov_helm
	desc = "Petrov Helm"
	region = ACCESS_REGION_RESEARCH

/var/const/access_guppy_helm = "ACCESS_GUPPY_HELM"//76
/datum/access/guppy_helm
	id = access_guppy_helm
	desc = "General Utility Pod Helm"
	region = ACCESS_REGION_SUPPLY

/var/const/access_expedition_shuttle_helm = "ACCESS_EXPEDITION_SHUTTLE_HELM"//77
/datum/access/exploration_shuttle_helm
	id = access_expedition_shuttle_helm
	desc = "Charon Helm"
	region = ACCESS_REGION_RESEARCH

/var/const/access_iaa = "ACCESS_IAA"//78
/datum/access/iaa
	id = access_iaa
	desc = "Internal Affairs Agent"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, Captain and RD cannot enter

/var/const/access_gun = "ACCESS_GUN"//87
/datum/access/gun
	id = access_gun
	desc = "BSA Cannon"
	region = ACCESS_REGION_COMMAND

/var/const/access_expedition_shuttle = "ACCESS_EXPEDITION_SHUTTLE"//88
/datum/access/exploration_shuttle
	id = access_expedition_shuttle
	desc = "Charon"
	region = ACCESS_REGION_RESEARCH

/var/const/access_guppy = "ACCESS_GUPPY"//89
/datum/access/guppy
	id = access_guppy
	desc = "General Utility Pod"
	region = ACCESS_REGION_SUPPLY

/var/const/access_seneng = "ACCESS_SENENG"//90
/datum/access/seneng
	id = access_seneng
	desc = "Senior Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_senmed = "ACCESS_SENMED"//91
/datum/access/senmed
	id = access_senmed
	desc = "Physician"
	region = ACCESS_REGION_MEDBAY

/var/const/access_guard = "ACCESS_GUARD"//92
/datum/access/guard
	id = access_guard
	desc = "Guard Equipment"
	region = ACCESS_REGION_SECURITY

/var/const/access_explorer = "ACCESS_EXPLORER"//93
/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_RESEARCH

/var/const/access_el = "ACCESS_EL"//94
/datum/access/el
	id = access_el
	desc = "Exploration Leader"
	region = ACCESS_REGION_COMMAND

/var/const/access_seceva = "ACCESS_SECEVA"//95
/datum/access/seceva
	id = access_seceva
	desc = "Security EVA"
	region = ACCESS_REGION_SECURITY

/var/const/access_commissary = "ACCESS_COMMISSARY"//96
/datum/access/commissary
	id = access_commissary
	desc = "Commissary"
	region = ACCESS_REGION_GENERAL

/var/const/access_warden = "ACCESS_WARDEN"//97
/datum/access/warden
	id = access_warden
	desc = "Warden"
	region = ACCESS_REGION_SECURITY

/var/const/access_actor = "ACCESS_ACTOR"//98
/datum/access/actor
	id = access_actor
	desc = "Actor"
	region = ACCESS_REGION_GENERAL

/var/const/access_field_eng = "ACCESS_FIELD_ENG"//99
/datum/access/field_eng
	id = access_field_eng
	desc = "Field Engineer"
	region = ACCESS_REGION_RESEARCH

/var/const/access_field_med = "ACCESS_FIELD_MED"//100
/datum/access/field_med
	id = access_field_med
	desc = "Field Medic"
	region = ACCESS_REGION_RESEARCH

/************
* NSV sierra *
************/
/*
/datum/access/security
	desc = "Security"

/datum/access/sec_doors
	desc = "Security Entrance"
*/
/datum/access/network
	region = ACCESS_REGION_COMMAND
