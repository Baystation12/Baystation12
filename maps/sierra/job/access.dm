/**************
 * NSV sierra *
 **************/
var/global/const/access_hangar = "ACCESS_HANGAR"
/datum/access/hangar
	id = access_hangar
	desc = "Hangar Deck"
	region = ACCESS_REGION_GENERAL

var/global/const/access_petrov = "ACCESS_PETROV"
/datum/access/petrov
	id = access_petrov
	desc = "Petrov"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_helm = "ACCESS_PETROV_HELM"
/datum/access/petrov_helm
	id = access_petrov_helm
	desc = "Petrov Helm"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_guppy_helm = "ACCESS_GUPPY_HELM"
/datum/access/guppy_helm
	id = access_guppy_helm
	desc = "General Utility Pod Helm"
	region = ACCESS_REGION_SUPPLY

var/global/const/access_expedition_shuttle_helm = "ACCESS_EXPEDITION_SHUTTLE_HELM"
/datum/access/exploration_shuttle_helm
	id = access_expedition_shuttle_helm
	desc = "Charon Helm"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_iaa = "ACCESS_IAA"
/datum/access/iaa
	id = access_iaa
	desc = "Internal Affairs Agent"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE // Ruler of their own domain, Captain and RD cannot enter

var/global/const/access_gun = "ACCESS_GUN"
/datum/access/gun
	id = access_gun
	desc = "BSA Cannon"
	region = ACCESS_REGION_COMMAND

var/global/const/access_expedition_shuttle = "ACCESS_EXPEDITION_SHUTTLE"
/datum/access/exploration_shuttle
	id = access_expedition_shuttle
	desc = "Charon"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_guppy = "ACCESS_GUPPY"
/datum/access/guppy
	id = access_guppy
	desc = "General Utility Pod"
	region = ACCESS_REGION_SUPPLY

var/global/const/access_seneng = "ACCESS_SENENG"
/datum/access/seneng
	id = access_seneng
	desc = "Senior Engineer"
	region = ACCESS_REGION_ENGINEERING

var/global/const/access_senmed = "ACCESS_SENMED"
/datum/access/senmed
	id = access_senmed
	desc = "Physician"
	region = ACCESS_REGION_MEDBAY

var/global/const/access_guard = "ACCESS_GUARD"
/datum/access/guard
	id = access_guard
	desc = "Guard Equipment"
	region = ACCESS_REGION_SECURITY

var/global/const/access_explorer = "ACCESS_EXPLORER"
/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_el = "ACCESS_EL"
/datum/access/el
	id = access_el
	desc = "Exploration Leader"
	region = ACCESS_REGION_COMMAND

var/global/const/access_seceva = "ACCESS_SECEVA"
/datum/access/seceva
	id = access_seceva
	desc = "Security EVA"
	region = ACCESS_REGION_SECURITY

var/global/const/access_commissary = "ACCESS_COMMISSARY"
/datum/access/commissary
	id = access_commissary
	desc = "Commissary"
	region = ACCESS_REGION_GENERAL
var/global/const/access_warden = "ACCESS_WARDEN"
/datum/access/warden
	id = access_warden
	desc = "Warden"
	region = ACCESS_REGION_SECURITY

var/global/const/access_actor = "ACCESS_ACTOR"
/datum/access/actor
	id = access_actor
	desc = "Actor"
	region = ACCESS_REGION_GENERAL

var/global/const/access_field_eng = "ACCESS_FIELD_ENG"
/datum/access/field_eng
	id = access_field_eng
	desc = "Field Engineer"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_field_med = "ACCESS_FIELD_MED"
/datum/access/field_med
	id = access_field_med
	desc = "Field Medic"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_bar = "ACCESS_BAR"
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

var/global/const/access_chief_steward = "ACCESS_SIERRA_CHIEF_STEWARD"
/datum/access/chief_steward
	id = access_chief_steward
	desc = "Chief Steward"
	region = ACCESS_REGION_GENERAL

/datum/access/network
	region = ACCESS_REGION_COMMAND
