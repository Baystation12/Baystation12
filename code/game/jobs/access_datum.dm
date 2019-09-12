/datum/access
	var/id = 0
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/dd_SortValue()
	return "[access_type][desc]"

/*****************
* Department General Access *
*****************/
//One per department
/var/const/access_maint_tunnels = 1
/datum/access/maint_tunnels
	id = access_maint_tunnels
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_security = 2
/datum/access/security
	id = access_security
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_medical = 3
/datum/access/medical
	id = access_medical
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/var/const/access_research = 4
/datum/access/science
	id = access_research
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/var/const/access_engineering = 5
/datum/access/engineering
	id = access_engineering
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

//Bar, kitchen, hydro, janitor
/var/const/access_service = 6
/datum/access/servjce
	id = access_service
	desc = "Service"
	region = ACCESS_REGION_GENERAL

/var/const/access_cargo = 7
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/**********************
* Secure Areas Access *
***********************/
/var/const/access_armory = 10
/datum/access/armory
	id = access_armory
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/var/const/access_bridge = 11
/datum/access/bridge
	id = access_bridge
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/var/const/access_chemistry = 12
/datum/access/chemistry
	id = access_chemistry
	desc = "Chemistry Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_surgery = 13
/datum/access/surgery
	id = access_surgery
	desc = "Operating Theatre"
	region = ACCESS_REGION_MEDBAY

/var/const/access_tech_storage =14
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_external_airlocks = 15
/datum/access/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING




/**********************
* Per Role Accesses	  *
***********************/
//For private offices, generally heads of staff only
/var/const/access_captain = 100
/datum/access/captain
	id = access_captain
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/var/const/access_rd = 101
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH





















/var/const/access_cmo = 40
/datum/access/cmo
	id = access_cmo
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND



/var/const/access_mining = 48
/datum/access/mining
	id = access_mining
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY


/var/const/access_ce = 56
/datum/access/ce
	id = access_ce
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_hop = 57
/datum/access/hop
	id = access_hop
	desc = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

/var/const/access_hos = 58
/datum/access/hos
	id = access_hos
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_RC_announce = 59 //Request console announcements
/datum/access/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/var/const/access_keycard_auth = 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

