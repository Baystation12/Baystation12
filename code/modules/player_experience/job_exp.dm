/*----------------------------------------------------------------------------------------------------*/
/* For job_exp saving (check /datum/controller/subsystem/statistics and proc/update_player_exp for details) */
/*----------------------------------------------------------------------------------------------------*/
GLOBAL_LIST_INIT(command_positions, list(
	"Captain",
	"Head of Personnel",
	"Research Director",
	"Chief Medical Officer",
	"Chief Engineer",
	"Head of Security",
	"Internal Affairs Agent",
	"Adjutant"
))

GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Senior Engineer",
	"Engineer",
	"Engineer Trainee",
	"Information Technician",
	"Field Engineer"
))

GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Surgeon",
	"Doctor",
	"Intern",
	"Chemist",
	"Counselor",
	"Field Medic"
))

GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Senior Researcher",
	"Scientist",
	"Roboticist",
	"Research Assistant"
))

GLOBAL_LIST_INIT(supply_positions, list(
	"Quartermaster",
	"Prospector",
	"Cargo Technician",
	"Cargo Assistant"
))

GLOBAL_LIST_INIT(service_positions, list(
	"Head of Personnel",
	"Chaplain",
	"Janitor",
	"Chef",
	"Bartender",
	"Actor"
))

GLOBAL_LIST_INIT(exploration_positions, list(
	"Exploration Leader",
	"Explorer",
	"Expeditionary Pilot",
	"Field Medic",
	"Field Engineer"
))


GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Criminal Investigator",
	"Security Guard",
	"Security Cadet"
))

GLOBAL_LIST_INIT(silicon_positions, list(
	"AI",
	"pAI",
	"Robot"
))

GLOBAL_LIST_INIT(civilian_positions, list(
	"Crewman"
))

GLOBAL_LIST_INIT(submap_positions, get_submap_position_titles())


// We hardcoded this list, because of two reasons:
// 1. The way it should be saved in Database (list2params)
// 2. Jobs can't 100% accuratly divided into groups
GLOBAL_LIST_INIT(job_exp_type_to_job_titles, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_CREW = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | service_positions | exploration_positions | security_positions | silicon_positions | civilian_positions, // crew positions
	EXP_TYPE_GHOST = list(), // dead people, observers
	EXP_TYPE_COMMAND = command_positions,
	EXP_TYPE_ENGINEERING = engineering_positions,
	EXP_TYPE_MEDICAL = medical_positions,
	EXP_TYPE_SCIENCE = science_positions,
	EXP_TYPE_SUPPLY = supply_positions,
	EXP_TYPE_SERVICE = service_positions,
	EXP_TYPE_EXPLORATION = exploration_positions,
	EXP_TYPE_SECURITY = security_positions,
	EXP_TYPE_SILICON = silicon_positions,
	EXP_TYPE_CIVILIAN = civilian_positions,
	EXP_TYPE_SUBMAP = submap_positions, // submap roles like merchants, vox, patrole ship, etc
	EXP_TYPE_SPECIAL = list(), // antags, ERT, etc
))

/**
 * Get all submap role titles
 */
/proc/get_submap_position_titles()
	var/list/submap_role_paths = typesof(/datum/job/submap)
	var/list/submap_role_titles = list()
	for (var/datum/job/path as anything in submap_role_paths)
		var/initial_title = initial(path.title)
		if(initial_title)
			submap_role_titles |= (initial_title)

	return submap_role_titles
