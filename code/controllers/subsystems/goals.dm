SUBSYSTEM_DEF(goals)
	name = "Goals"
	init_order = SS_INIT_GOALS
	wait = 1 SECOND

	/// A list of available personal ambition goals.
	var/static/list/datum/goal/global_personal_goals = list(
		/datum/goal/achievement/specific_object/food,
		/datum/goal/achievement/specific_object/drink,
		/datum/goal/achievement/specific_object/pet,
		/datum/goal/achievement/fistfight,
		/datum/goal/achievement/graffiti,
		/datum/goal/achievement/newshound,
		/datum/goal/achievement/givehug,
		/datum/goal/achievement/gethug,
		/datum/goal/movement/walk,
		/datum/goal/movement/walk/eva,
		/datum/goal/clean,
		/datum/goal/money,
		/datum/goal/weights,
		/datum/goal/punchingbag
	)

	/// A (flag = instance) map of departments.
	var/static/list/departments = list()

	/// A (ref = instance) map of personal ambition goals.
	var/static/list/ambitions = list()

	/// A list of goals pending initialization.
	var/static/list/datum/goal/pending_goals = list()


/datum/controller/subsystem/goals/Initialize(start_uptime)
	var/list/all_depts
	if (length(GLOB.using_map.departments))
		all_depts = GLOB.using_map.departments
	else
		all_depts = subtypesof(/datum/department)
	for (var/datum/department/department as anything in all_depts)
		var/flag = initial(department.flag)
		if (flag)
			departments["[flag]"] = new department
	for (var/flag in departments)
		var/datum/department/department = departments[flag]
		department.Initialize()


/datum/controller/subsystem/goals/fire(resumed, no_mc_tick)
	for (var/datum/goal/goal as anything in pending_goals)
		if (goal.try_initialize())
			pending_goals -= goal
	if (!length(pending_goals))
		suspend()


/datum/controller/subsystem/goals/proc/update_department_goal(flag, type, progress)
	var/datum/department/department = departments["[flag]"]
	if (department)
		department.update_progress(type, progress)


/datum/controller/subsystem/goals/proc/get_roundend_summary()
	var/list/result = list()
	for (var/flag in departments)
		var/datum/department/department = departments[flag]
		result += "<b>[department.name] had the following shift goals:</b>"
		result += department.summarize_goals(show_success = TRUE)
	if (length(result))
		return "<br>[jointext(result, "<br>")]"
	return "<br><b>There were no departmental goals this round.</b>"
