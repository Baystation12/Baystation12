// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest(monochrome, OOC)
	var/list/dept_data = list(
		list("names" = list(), "header" = "Heads of Staff", "flag" = COM, "color" = MANIFEST_COLOR_COMMAND),
		list("names" = list(), "header" = "Command Support", "flag" = SPT, "color" = MANIFEST_COLOR_SUPPORT),
		list("names" = list(), "header" = "Research", "flag" = SCI, "color" = MANIFEST_COLOR_SCIENCE),
		list("names" = list(), "header" = "Security", "flag" = SEC, "color" = MANIFEST_COLOR_SECURITY),
		list("names" = list(), "header" = "Medical", "flag" = MED, "color" = MANIFEST_COLOR_MEDICAL),
		list("names" = list(), "header" = "Engineering", "flag" = ENG, "color" = MANIFEST_COLOR_ENGINEER),
		list("names" = list(), "header" = "Supply", "flag" = SUP, "color" = MANIFEST_COLOR_SUPPLY),
		list("names" = list(), "header" = "Exploration", "flag" = EXP, "color" = MANIFEST_COLOR_EXPLORER),
		list("names" = list(), "header" = "Service", "flag" = SRV, "color" = MANIFEST_COLOR_SERVICE),
		list("names" = list(), "header" = "Civilian", "flag" = CIV, "color" = MANIFEST_COLOR_CIVILIAN),
		list("names" = list(), "header" = "Miscellaneous", "flag" = MSC, "color" = MANIFEST_COLOR_MISC),
		list("names" = list(), "header" = "Silicon", "color" = MANIFEST_COLOR_SILICON),
	)
	var/list/misc //Special departments for easier access
	var/list/bot
	for(var/list/department in dept_data)
		if(department["flag"] == MSC)
			misc = department["names"]
		if(isnull(department["flag"]))
			bot = department["names"]

	var/list/isactive = new()
	var/list/mil_ranks = list() // HTML to prepend to name
	var/dat = {"
	<head><meta charset='utf-8'><style>
		.manifest {border-collapse:collapse;width:100%;}
		.manifest td, th {border:1px solid [monochrome?"black":"black; background-color:#272727; color:white"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #40628a; color:white"]}
		.manifest tr.head th { background-color: #013D3B; }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #373737; color:white"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th>[OOC ? "" : "<th>Activity</th>"]</tr>
	"}
	// sort mobs
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		var/status = CR.get_status()
		if (OOC && status == "Stored")
			continue
		var/name = CR.get_formal_name()
		var/rank = CR.get_job()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = GLOB.mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = GLOB.mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		isactive[name] = status

		var/datum/job/job = SSjobs.get_by_title(rank)
		var/found_place = 0
		if(job)
			for(var/list/department in dept_data)
				var/list/names = department["names"]
				if(job.department_flag & department["flag"])
					names[name] = rank
					found_place = 1
		if(!found_place)
			misc[name] = rank

	// Synthetics don't have actual records, so we will pull them from here.
	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		bot[ai.name] = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[robot.name] = "[robot.modtype] [robot.braintype]"

	for(var/list/department in dept_data)
		var/list/names = department["names"]
		if(length(names) > 0)
			var/columns = OOC ? 2 : 3
			dat += "<tr><th colspan=[columns] style=background-color:[department["color"]]>[department["header"]]</th></tr>"
			for(var/name in names)
				var/status_cell = OOC ? "" : "<td>[isactive[name]]</td>"
				dat += "<tr class='candystripe'><td>[mil_ranks[name]][name]</td><td>[names[name]]</td>[status_cell]</tr>"

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/proc/silicon_nano_crew_manifest(list/filter)
	var/list/filtered_entries = list()

	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		filtered_entries.Add(list(list(
			"name" = ai.name,
			"rank" = "Artificial Intelligence",
			"status" = ""
		)))
	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		if(robot.module && robot.module.hide_on_manifest)
			continue
		filtered_entries.Add(list(list(
			"name" = robot.name,
			"rank" = "[robot.modtype] [robot.braintype]",
			"status" = ""
		)))
	return filtered_entries

/proc/filtered_nano_crew_manifest(list/filter, blacklist = FALSE)
	RETURN_TYPE(/list)
	var/list/filtered_entries = list()
	for(var/datum/computer_file/report/crew_record/CR in department_crew_manifest(filter, blacklist))
		if (CR.get_status() == "Stored")
			continue

		filtered_entries.Add(list(list(
			"name" = CR.get_name(),
			"rank" = CR.get_job(),
			"status" = CR.get_status(),
			"branch" = CR.get_branch(),
			"milrank" = CR.get_rank()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(
		"heads" = filtered_nano_crew_manifest(SSjobs.titles_by_department(COM)),
		"spt" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(SPT)),
		"sci" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(SCI)),
		"sec" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(SEC)),
		"eng" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(ENG)),
		"med" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(MED)),
		"sup" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(SUP)),
		"exp" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(EXP)),
		"srv" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(SRV)),
		"bot" =   silicon_nano_crew_manifest(SSjobs.titles_by_department(MSC)),
		"civ" =   filtered_nano_crew_manifest(SSjobs.titles_by_department(CIV))
		)

/proc/flat_nano_crew_manifest()
	RETURN_TYPE(/list)
	. = list()
	. += filtered_nano_crew_manifest(null, TRUE)
	. += silicon_nano_crew_manifest(SSjobs.titles_by_department(MSC))
