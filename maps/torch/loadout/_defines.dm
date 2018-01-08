//The following is a list of defs to be used for the Torch loadout.

//For all SolGov personnel, representative included
#define SOLGOV_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/bridgeofficer, /datum/job/sea, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/qm, /datum/job/cargo_tech, /datum/job/janitor, /datum/job/chef, /datum/job/crew, /datum/job/representative, /datum/job/solgov_pilot, /datum/job/pathfinder, /datum/job/explorer)

//For EC/Fleet/Marines
#define MILITARY_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/bridgeofficer, /datum/job/sea, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/qm, /datum/job/cargo_tech, /datum/job/janitor, /datum/job/chef, /datum/job/crew, /datum/job/solgov_pilot, /datum/job/pathfinder, /datum/job/explorer)

//For EC/Fleet/Marine Officers
#define MILITARY_OFFICER_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/bridgeofficer, /datum/job/senior_doctor, /datum/job/qm, /datum/job/solgov_pilot, /datum/job/pathfinder)

//For EC/Fleet/Marine Enlisted
#define MILITARY_ENLISTED_ROLES list(/datum/job/sea, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/qm, /datum/job/cargo_tech, /datum/job/janitor, /datum/job/chef, /datum/job/crew, /datum/job/explorer)

//For all civilians or off-duty personnel, regardless of formality of dress or job.
#define NON_MILITARY_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, /datum/job/nt_pilot, /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant, /datum/job/representative, /datum/job/assistant, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/doctor_contractor, /datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/bartender, /datum/job/merchant,/datum/job/stowaway)

//For jobs that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list(/datum/job/liaison, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/psychiatrist, /datum/job/representative, /datum/job/assistant, /datum/job/bartender, /datum/job/merchant, /datum/job/stowaway, /datum/job/guard, /datum/job/detective)

//For civilian jobs that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list(/datum/job/assistant,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/psychiatrist, /datum/job/bartender, /datum/job/merchant, /datum/job/nt_pilot, /datum/job/stowaway, /datum/job/scientist, /datum/job/senior_scientist, /datum/job/detective)

//For civilian jobs that may have a strict uniform.
#define SEMIANDFORMAL_ROLES list(/datum/job/assistant,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/psychiatrist, /datum/job/bartender, /datum/job/merchant, /datum/job/nt_pilot, /datum/job/liaison, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/representative, /datum/job/stowaway, /datum/job/detective)

//For NanoTrasen employees
#define NANOTRASEN_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, /datum/job/nt_pilot, /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant)

//For contractors
#define CONTRACTOR_ROLES list(/datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/doctor_contractor, /datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/bartender, /datum/job/chef, /datum/job/janitor)

//For corporate or government representatives
#define REPRESENTATIVE_ROLES list(/datum/job/representative, /datum/job/liaison)

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list(/datum/job/assistant, /datum/job/bartender, /datum/job/merchant, "Off-Duty",/datum/job/stowaway)

//For members of the command department
#define COMMAND_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/bridgeofficer, /datum/job/sea)

//For members of the medical department
#define MEDICAL_ROLES list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/psychiatrist)

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/psychiatrist, /datum/job/roboticist, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant)

//For members of the engineering department
#define ENGINEERING_ROLES list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist)

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list(/datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech, /datum/job/cargo_contractor,/datum/job/mining, /datum/job/scientist_assistant, /datum/job/merchant, /datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/chief_engineer, /datum/job/janitor)

//For members of the security department
#define SECURITY_ROLES list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

//For members of the supply department
#define SUPPLY_ROLES list(/datum/job/qm, /datum/job/cargo_tech, /datum/job/cargo_contractor)

//For members of the service department
#define SERVICE_ROLES list(/datum/job/janitor, /datum/job/chef, /datum/job/crew, /datum/job/bartender)

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list(/datum/job/rd, /datum/job/liaison, /datum/job/scientist,/datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant, /datum/job/assistant, /datum/job/nt_pilot, /datum/job/senior_scientist, /datum/job/roboticist)

//For jobs that spawn with weapons in their lockers
#define ARMED_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/sea, /datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/guard, /datum/job/merchant)

//For jobs that spawn with armor in their lockers
#define ARMORED_ROLES list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/qm, /datum/job/sea, /datum/job/bridgeofficer, /datum/job/solgov_pilot, /datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/guard, /datum/job/merchant)
