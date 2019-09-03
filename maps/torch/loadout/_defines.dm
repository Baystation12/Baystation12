//The following is a list of defs to be used for the Torch loadout.

//For all SolGov personnel, representative included
#define SOLGOV_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/ds13seniormedofficer, /datum/job/ds13chiefofengines, /datum/job/ds13chiefsecurityofficer, /datum/job/ds13bensign,   /datum/job/ds13expendableengineer, /datum/job/ds13seniorsecurityofficer,  /datum/job/ds13securityofficer, /datum/job/ds13medsurgeon, /datum/job/ds13meddoctor, /datum/job/ds13supplyofficer, /datum/job/ds13cargojockey,  /datum/job/ds13linecook)

//For EC/Fleet/Marines
#define MILITARY_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/ds13seniormedofficer, /datum/job/ds13chiefofengines, /datum/job/ds13chiefsecurityofficer, /datum/job/ds13bensign,   /datum/job/ds13expendableengineer, /datum/job/ds13seniorsecurityofficer,  /datum/job/ds13securityofficer, /datum/job/ds13medsurgeon, /datum/job/ds13meddoctor, /datum/job/ds13supplyofficer, /datum/job/ds13cargojockey,  /datum/job/ds13linecook)

//For EC/Fleet/Marine Officers
#define MILITARY_OFFICER_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/ds13seniormedofficer, /datum/job/ds13chiefofengines, /datum/job/ds13chiefsecurityofficer, /datum/job/ds13bensign, /datum/job/ds13medsurgeon, /datum/job/ds13supplyofficer, )

//For EC/Fleet/Marine Enlisted
#define MILITARY_ENLISTED_ROLES list(  /datum/job/ds13expendableengineer, /datum/job/ds13seniorsecurityofficer,  /datum/job/ds13securityofficer, /datum/job/ds13medsurgeon, /datum/job/ds13meddoctor, /datum/job/ds13supplyofficer, /datum/job/ds13cargojockey,  /datum/job/ds13linecook,   /datum/job/ds13securityofficer)

//For all civilians or off-duty personnel, regardless of formality of dress or job.
#define NON_MILITARY_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, , /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant,  /datum/job/assistant, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/ds13meddoctor_contractor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/ds13bartender, /datum/job/merchant,/datum/job/stowaway)

//For jobs that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list(/datum/job/liaison, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/psychiatrist,  /datum/job/assistant, /datum/job/ds13bartender, /datum/job/merchant, /datum/job/stowaway, /datum/job/guard, /datum/job/detective)

//For civilian jobs that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list(/datum/job/assistant,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/psychiatrist, /datum/job/ds13bartender, /datum/job/merchant, , /datum/job/stowaway, /datum/job/scientist, /datum/job/senior_scientist, /datum/job/detective)

//For civilian jobs that may have a strict uniform.
#define SEMIANDFORMAL_ROLES list(/datum/job/assistant,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/psychiatrist, /datum/job/ds13bartender, /datum/job/merchant, , /datum/job/liaison, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/stowaway, /datum/job/detective)

//For NanoTrasen employees
#define NANOTRASEN_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, , /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant)

//For contractors
#define CONTRACTOR_ROLES list(/datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/ds13meddoctor_contractor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/ds13bartender, /datum/job/ds13linecook,   /datum/job/guard)

//For corporate or government representatives
#define REPRESENTATIVE_ROLES list( /datum/job/liaison)

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list(/datum/job/assistant, /datum/job/ds13bartender, /datum/job/merchant, /datum/job/stowaway)

//For members of the command department
#define COMMAND_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/rd, /datum/job/ds13seniormedofficer, /datum/job/ds13chiefofengines, /datum/job/ds13chiefsecurityofficer, /datum/job/ds13bensign, /datum/job/sea)

//For members of the medical department
#define MEDICAL_ROLES list(/datum/job/ds13seniormedofficer, /datum/job/ds13medsurgeon, /datum/job/ds13meddoctor, /datum/job/ds13meddoctor_contractor, /datum/job/psychiatrist, /datum/job/chemist, /datum/job/roboticist, )

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list(/datum/job/ds13seniormedofficer, /datum/job/ds13medsurgeon, /datum/job/ds13meddoctor, /datum/job/ds13meddoctor_contractor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/roboticist, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant, )

//For members of the engineering department
#define ENGINEERING_ROLES list(/datum/job/ds13chiefofengines,  /datum/job/ds13expendableengineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/engineer_trainee)

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list( /datum/job/ds13expendableengineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/ds13supplyofficer, /datum/job/ds13cargojockey, /datum/job/cargo_contractor,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/merchant, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/ds13chiefofengines,  /datum/job/engineer_trainee)

//For members of the security department
#define SECURITY_ROLES list(/datum/job/ds13chiefsecurityofficer, /datum/job/ds13seniorsecurityofficer,  /datum/job/ds13securityofficer)

//For members of the supply department
#define SUPPLY_ROLES list(/datum/job/ds13supplyofficer, /datum/job/ds13cargojockey, /datum/job/cargo_contractor)

//For members of the service department
#define SERVICE_ROLES list( /datum/job/ds13linecook,  /datum/job/ds13bartender)

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant, /datum/job/assistant, , /datum/job/senior_scientist, /datum/job/roboticist)

//For jobs that spawn with weapons in their lockers
#define ARMED_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/ds13chiefsecurityofficer,  /datum/job/ds13securityofficer, /datum/job/ds13seniorsecurityofficer,  /datum/job/guard, /datum/job/merchant)

//For jobs that spawn with armor in their lockers
#define ARMORED_ROLES list(/datum/job/ds13captain, /datum/job/ds13flieutenant, /datum/job/rd, /datum/job/ds13seniormedofficer, /datum/job/ds13chiefofengines, /datum/job/ds13chiefsecurityofficer, /datum/job/ds13supplyofficer,  /datum/job/ds13bensign, /datum/job/ds13securityofficer, /datum/job/ds13seniorsecurityofficer,  /datum/job/guard, /datum/job/merchant)

#define UNIFORMED_BRANCHES list(/datum/mil_branch/expeditionary_corps, /datum/mil_branch/fleet)

#define CIVILIAN_BRANCHES list(/datum/mil_branch/civilian)
