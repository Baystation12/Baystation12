//The following is a list of defs and blacklist to be used (or not) for the Sierra loadout.
/datum/map/sierra
	loadout_blacklist = list(
		/datum/gear/union_card,
		/datum/gear/suit/labcoat_corp,
		/datum/gear/suit/medcoat,
		/datum/gear/uniform/corp_exec,
		/datum/gear/uniform/corp_overalls,
		/datum/gear/uniform/corp_flight,
		/datum/gear/uniform/corp_exec_jacket,
	)

//For all exploration crew
#define EXPLORATION_ROLES list(\
	/datum/job/exploration_leader, \
	/datum/job/explorer, \
	/datum/job/explorer_pilot, \
	/datum/job/explorer_medic, \
	/datum/job/explorer_engineer \
)

//For jobs that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list(\
	/datum/job/iaa, \
	/datum/job/rd, \
	/datum/job/senior_scientist, \
	/datum/job/scientist, \
	/datum/job/scientist_assistant, \
	/datum/job/psychiatrist, \
	/datum/job/assistant, \
	/datum/job/bartender, \
	/datum/job/submap/merchant, \
	/datum/job/detective \
)

//For civilian jobs that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list(\
	/datum/job/assistant, \
	/datum/job/mining, \
	/datum/job/scientist_assistant, \
	/datum/job/psychiatrist, \
	/datum/job/bartender, \
	/datum/job/submap/merchant, \
	/datum/job/scientist, \
	/datum/job/senior_scientist, \
	/datum/job/detective \
)

//For civilian jobs that may have a strict uniform.
#define SEMIANDFORMAL_ROLES list(\
	/datum/job/assistant, \
	/datum/job/mining, \
	/datum/job/scientist_assistant, \
	/datum/job/psychiatrist, \
	/datum/job/bartender, \
	/datum/job/submap/merchant, \
	/datum/job/iaa, \
	/datum/job/rd, \
	/datum/job/senior_scientist, \
	/datum/job/scientist, \
	/datum/job/detective \
)

//For NanoTrasen employees
#define NANOTRASEN_ROLES list(\
	/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, \
	/datum/job/iaa, \
	/datum/job/senior_engineer, /datum/job/engineer, /datum/job/infsys, /datum/job/roboticist, /datum/job/engineer_trainee, \
	/datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/security_assistant, \
	/datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_trainee,/datum/job/chemist, \
	/datum/job/psychiatrist, \
	/datum/job/qm, /datum/job/cargo_tech, /datum/job/cargo_assistant,\
	/datum/job/chief_steward, /datum/job/janitor, /datum/job/cook, /datum/job/bartender, /datum/job/steward, \
	/datum/job/senior_scientist, /datum/job/scientist, /datum/job/mining,\
	/datum/job/scientist_assistant \
)

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list(\
	/datum/job/assistant, \
	/datum/job/bartender \
)

//For members of the command department
#define COMMAND_ROLES list(\
	/datum/job/captain, \
	/datum/job/hop, \
	/datum/job/rd,\
	/datum/job/cmo, \
	/datum/job/chief_engineer,\
	/datum/job/hos \
)

//For members of the medical department
#define MEDICAL_ROLES list(\
	/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor,\
	/datum/job/doctor_trainee, /datum/job/explorer_medic,\
	/datum/job/psychiatrist, /datum/job/chemist, /datum/job/roboticist \
)

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list(\
	/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor,\
	/datum/job/doctor_trainee, /datum/job/chemist, /datum/job/psychiatrist,\
	/datum/job/chemist, /datum/job/explorer_medic, /datum/job/roboticist,\
	/datum/job/rd, /datum/job/senior_scientist, /datum/job/scientist, /datum/job/scientist_assistant \
)

//For members of the engineering department
#define ENGINEERING_ROLES list(\
	/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/infsys,\
	 /datum/job/roboticist, /datum/job/engineer_trainee, /datum/job/explorer_engineer \
)

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list(\
	/datum/job/senior_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm,\
	/datum/job/cargo_tech, /datum/job/cargo_assistant,/datum/job/mining,\
	/datum/job/scientist_assistant,    /datum/job/rd,\
	/datum/job/senior_scientist, /datum/job/scientist, /datum/job/chief_engineer, /datum/job/infsys,\
	/datum/job/engineer_trainee, /datum/job/explorer_engineer \
)

//For members of the security department
#define SECURITY_ROLES list(\
	/datum/job/hos, \
	/datum/job/warden, \
	/datum/job/detective, \
	/datum/job/officer, \
	/datum/job/security_assistant \
)

//For members of the supply department
#define SUPPLY_ROLES list(\
	/datum/job/qm, \
	/datum/job/cargo_tech, \
	/datum/job/cargo_assistant \
)

//For members of the service department
#define SERVICE_ROLES list(\
	/datum/job/chief_steward, \
	/datum/job/janitor, \
	/datum/job/cook, \
	/datum/job/bartender, \
	/datum/job/steward \
)

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list(\
	/datum/job/rd, /datum/job/iaa, /datum/job/scientist,\
	/datum/job/scientist_assistant, /datum/job/assistant,\
	/datum/job/senior_scientist, /datum/job/roboticist \
)

//For jobs that spawn with weapons in their lockers
#define ARMED_ROLES list(\
	/datum/job/captain, /datum/job/hop, /datum/job/hos,\
	/datum/job/officer, /datum/job/warden, /datum/job/detective, /datum/job/security_assistant \
)

//For jobs that spawn with armor in their lockers
#define ARMORED_ROLES list(\
	/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo,\
	/datum/job/chief_engineer, /datum/job/hos, /datum/job/qm,\
	/datum/job/warden, /datum/job/detective, /datum/job/officer, \
)

#define CONTRACT_ROLES list(\
	/datum/job/explorer, /datum/job/explorer_pilot, /datum/job/explorer_medic, /datum/job/explorer_engineer, \
	/datum/job/engineer, /datum/job/engineer_trainee, \
	/datum/job/officer, /datum/job/detective, \
	/datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_trainee,/datum/job/chemist, /datum/job/psychiatrist, \
	/datum/job/cargo_tech,  /datum/job/cargo_assistant, /datum/job/mining, \
	/datum/job/janitor, /datum/job/cook, /datum/job/bartender, /datum/job/steward, /datum/job/infsys,\
	/datum/job/scientist, /datum/job/roboticist, /datum/job/scientist_assistant \
)

#define CIVILIAN_ROLES list(\
	/datum/job/detective, \
	/datum/job/psychiatrist, \
	/datum/job/cargo_assistant, \
	/datum/job/janitor, \
	/datum/job/cook, \
	/datum/job/bartender,\
	/datum/job/steward,\
	/datum/job/assistant\
)
