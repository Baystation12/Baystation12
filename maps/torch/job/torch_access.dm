/************
* SEV Torch *
************/
var/global/const/access_hangar = "ACCESS_TORCH_HANGAR" //73
/datum/access/hangar
	id = access_hangar
	desc = "Hangar Deck"
	region = ACCESS_REGION_GENERAL

var/global/const/access_guppy_helm = "ACCESS_TORCH_GUP_HELM" //76
/datum/access/guppy_helm
	id = access_guppy_helm
	desc = "General Utility Pod Helm"
	region = ACCESS_REGION_GENERAL

var/global/const/access_expedition_shuttle_helm = "ACCESS_EXPLO_HELM" //77
/datum/access/exploration_shuttle_helm
	id = access_expedition_shuttle_helm
	desc = "Charon Helm"
	region = ACCESS_REGION_GENERAL

var/global/const/access_aquila = "ACCESS_TORCH_AQUILA" //78
/datum/access/aquila
	id = access_aquila
	desc = "Aquila"
	region = ACCESS_REGION_GENERAL

var/global/const/access_aquila_helm = "ACCESS_TORCH_AQUILA_HELM" //79
/datum/access/aquila_helm
	id = access_aquila_helm
	desc = "Aquila Helm"
	region = ACCESS_REGION_GENERAL

var/global/const/access_solgov_crew = "ACCESS_TORCH_CREW" //80
/datum/access/solgov_crew
	id = access_solgov_crew
	desc = "SolGov Crew"
	region = ACCESS_REGION_GENERAL

var/global/const/access_nanotrasen = "ACCESS_TORCH_CORP" //81
/datum/access/nanotrasen
	id = access_nanotrasen
	desc = "Corporate Personnel"
	region = ACCESS_REGION_SERVICE

var/global/const/access_emergency_armory = "ACCESS_TORCH_ARMORY" //83
/datum/access/emergency_armory
	id = access_emergency_armory
	desc = "Emergency Armory"
	region = ACCESS_REGION_COMMAND

var/global/const/access_liaison = "ACCESS_TORCH_CORPORATE_LIAISON" //84
/datum/access/liaison
	id = access_liaison
	desc = "Corporate Liaison"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO and RD cannot enter

var/global/const/access_representative = "ACCESS_TORCH_REPRESENTATIVE" //85
/datum/access/representative
	id = access_representative
	desc = "SolGov Representative"
	region = ACCESS_REGION_COMMAND
	access_type = ACCESS_TYPE_NONE //Ruler of their own domain, CO cannot enter

var/global/const/access_sec_guard = "ACCESS_TORCH_SECURITY_GUARD" //86
/datum/access/sec_guard
	id = access_sec_guard
	desc = "Corporate Security"
	region = ACCESS_REGION_SERVICE

var/global/const/access_gun = "ACCESS_TORCH_CANNON" //87
/datum/access/gun
	id = access_gun
	desc = "Gunnery"
	region = ACCESS_REGION_COMMAND

var/global/const/access_expedition_shuttle = "ACCESS_TORCH_EXPLO" //88
/datum/access/exploration_shuttle
	id = access_expedition_shuttle
	desc = "Charon"
	region = ACCESS_REGION_GENERAL

var/global/const/access_guppy = "ACCESS_TORCH_GUP" //89
/datum/access/guppy
	id = access_guppy
	desc = "General Utility Pod"
	region = ACCESS_REGION_GENERAL

var/global/const/access_seneng = "ACCESS_TORCH_SENIOR_ENG" //90
/datum/access/seneng
	id = access_seneng
	desc = "Senior Engineer"
	region = ACCESS_REGION_ENGINEERING

var/global/const/access_senmed = "ACCESS_TORCH_SENIOR_MED" //91
/datum/access/senmed
	id = access_senmed
	desc = "Physician"
	region = ACCESS_REGION_MEDBAY

var/global/const/access_senadv = "ACCESS_TORCH_SENIOR_ADVISOR" //92
/datum/access/senadv
	id = access_senadv
	desc = "Senior Enlisted Advisor"
	region = ACCESS_REGION_COMMAND

var/global/const/access_explorer = "ACCESS_TORCH_EXPLORER" //93
/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

var/global/const/access_pathfinder = "ACCESS_TORCH_PATHFINDER" //94
/datum/access/pathfinder
	id = access_pathfinder
	desc = "Pathfinder"
	region = ACCESS_REGION_GENERAL

var/global/const/access_pilot = "ACCESS_TORCH_PILOT" //95
/datum/access/pilot
	id = access_pilot
	desc = "Pilot"
	region = ACCESS_REGION_GENERAL

//proxima code
/var/const/access_exploration_guard = "ACCESS_TORCH_EXPLORATION_GUARD"
/datum/access/access_exploration_guard
	id = access_exploration_guard
	desc = "Exploration Guard"
	region = ACCESS_REGION_GENERAL
//proxima code end


/var/const/access_commissary = "ACCESS_TORCH_SHOP" //96
/datum/access/commissary
	id = access_commissary
	desc = "Commissary"
	region = ACCESS_REGION_GENERAL

/var/const/access_research_security = "ACCESS_RESEARCH_SECURITY" //97
/datum/access/rnd_guard
	id = access_research_security
	desc = "Research Checkpoint"
	region = ACCESS_REGION_RESEARCH

/datum/access/psychiatrist
	desc = "Mental Health"

/datum/access/hos
	desc = "Chief of Security"

/datum/access/hop
	desc = "Executive Officer"

/datum/access/qm
	desc = "Deck Chief"

var/global/const/access_torch_fax = "ACCESS_TORCH_FAX"
/datum/access/torch_fax
	id = access_torch_fax
	desc = "Fax Machines"
	region = ACCESS_REGION_COMMAND

/datum/access/robotics
	region = ACCESS_REGION_ENGINEERING

/datum/access/network
	region = ACCESS_REGION_COMMAND

/datum/access/network_admin
	region = ACCESS_REGION_COMMAND

/datum/access/chapel_office
	region = ACCESS_REGION_SERVICE

/datum/access/bar
	region = ACCESS_REGION_SERVICE

/datum/access/kitchen
	region = ACCESS_REGION_SERVICE

/datum/access/eva
	region = ACCESS_REGION_GENERAL

/datum/access/crematorium
	region = ACCESS_REGION_MEDBAY

/datum/access/janitor
	region = ACCESS_REGION_SERVICE

/datum/access/ai_upload
	desc = "Cyborg Upload"

/*************
* NRV Petrov *
*************/
var/global/const/access_petrov = "ACCESS_TORCH_PETROV" //200
/datum/access/petrov
	id = access_petrov
	desc = "Petrov"
	region = ACCESS_REGION_GENERAL

var/global/const/access_petrov_helm = "ACCESS_TORCH_PETROV_HELM" //201
/datum/access/petrov_helm
	id = access_petrov_helm
	desc = "Petrov Helm"
	region = ACCESS_REGION_GENERAL

var/global/const/access_petrov_analysis = "ACCESS_TORCH_PETROV_ANALYSIS" //202
/datum/access/petrov_analysis
	id = access_petrov_analysis
	desc = "Petrov Analysis Lab"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_phoron = "ACCESS_TORCH_PETROV_PHORON" //203
/datum/access/petrov_phoron
	id = access_petrov_phoron
	desc = "Petrov Phoron Sublimation Lab"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_toxins = "ACCESS_TORCH_PETROV_TOXINS" //204
/datum/access/petrov_toxins
	id = access_petrov_toxins
	desc = "Petrov Toxins Lab"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_chemistry = "ACCESS_TORCH_PETROV_CHEMISTRY" //205
/datum/access/petrov_chemistry
	id = access_petrov_chemistry
	desc = "Petrov Chemistry Lab"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_rd = "ACCESS_TORCH_PETROV_RD" //206
/datum/access/petrov_rd
	id = access_petrov_rd
	desc = "Petrov Chief Science Officer's Office"
	region = ACCESS_REGION_COMMAND

var/global/const/access_petrov_control = "ACCESS_TORCH_PETROV_CONTROL" //207
/datum/access/petrov_control
	id = access_petrov_control
	desc = "Petrov Control Room"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_petrov_maint = "ACCESS_TORCH_PETROV_MAINT" //208
/datum/access/petrov_maint
	id = access_petrov_maint
	desc = "Petrov Maintenance"
	region = ACCESS_REGION_GENERAL

var/global/const/access_torch_helm = "ACCESS_TORCH_HELM"
/datum/access/torch_helm
	id = access_torch_helm
	desc = "Torch Helm"
	region = ACCESS_REGION_COMMAND

// Torch Radio Access

var/global/const/access_radio_comm = "ACCESS_RADIO_COMM"
/datum/access/access_radio_comm
	id = access_radio_comm
	desc = "Command Radio"
	region = ACCESS_REGION_COMMAND

var/global/const/access_radio_eng = "ACCESS_RADIO_ENG"
/datum/access/access_radio_eng
	id = access_radio_eng
	desc = "Engineering Radio"
	region = ACCESS_REGION_ENGINEERING

var/global/const/access_radio_med = "ACCESS_RADIO_MED"
/datum/access/access_radio_med
	id = access_radio_med
	desc = "Medical Radio"
	region = ACCESS_REGION_MEDBAY

var/global/const/access_radio_sec = "ACCESS_RADIO_SEC"
/datum/access/access_radio_sec
	id = access_radio_sec
	desc = "Security Radio"
	region = ACCESS_REGION_SECURITY

var/global/const/access_radio_sci = "ACCESS_RADIO_SCI"
/datum/access/access_radio_sic
	id = access_radio_sci
	desc = "Science Radio"
	region = ACCESS_REGION_RESEARCH

var/global/const/access_radio_sup = "ACCESS_RADIO_SUP"
/datum/access/access_radio_sup
	id = access_radio_sup
	desc = "Supply Radio"
	region = ACCESS_REGION_SUPPLY

var/global/const/access_radio_serv = "ACCESS_RADIO_SERV"
/datum/access/access_radio_serv
	id = access_radio_serv
	desc = "Service Radio"
	region = ACCESS_REGION_SERVICE

var/global/const/access_radio_exp = "ACCESS_RADIO_EXP"
/datum/access/access_radio_exp
	id = access_radio_exp
	desc = "Exploration Radio"
	region = ACCESS_REGION_GENERAL
