// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest(var/monochrome, var/OOC)
	var/list/dept_data = list(
		list("names" = list(), "header" = "Heads of Staff", "flag" = COM),
		list("names" = list(), "header" = "Command Support", "flag" = SPT),
		list("names" = list(), "header" = "Research", "flag" = SCI),
		list("names" = list(), "header" = "Security", "flag" = SEC),
		list("names" = list(), "header" = "Medical", "flag" = MED),
		list("names" = list(), "header" = "Engineering", "flag" = ENG),
		list("names" = list(), "header" = "Supply", "flag" = SUP),
		list("names" = list(), "header" = "Exploration", "flag" = EXP),
		list("names" = list(), "header" = "Service", "flag" = SRV),
		list("names" = list(), "header" = "Civilian", "flag" = CIV),
		list("names" = list(), "header" = "Miscellaneous", "flag" = MSC),
		list("names" = list(), "header" = "Silicon")
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
	<head><style>
		.manifest {border-collapse:collapse;width:100%;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628a":"#48C"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	// sort mobs
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		var/name = CR.get_formal_name()
		var/rank = CR.get_job()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = GLOB.mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = GLOB.mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				var/mob_real_name = M.real_name
				if(sanitize(mob_real_name) == CR.get_name() && M.client && M.client.inactivity <= 10 MINUTES)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = CR.get_status()

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
		if(names.len > 0)
			dat += "<tr><th colspan=3>[department["header"]]</th></tr>"
			for(var/name in names)
				dat += "<tr class='candystripe'><td>[mil_ranks[name]][name]</td><td>[names[name]]</td><td>[isactive[name]]</td></tr>"

	dat += "</table>"
	dat = replacetext_char(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext_char(dat, "\t", "")
	return dat

/proc/silicon_nano_crew_manifest(var/list/filter)
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

/proc/filtered_nano_crew_manifest(var/list/filter, var/blacklist = FALSE)
	var/list/filtered_entries = list()
	for(var/datum/computer_file/report/crew_record/CR in department_crew_manifest(filter, blacklist))
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
	. = list()
	. += filtered_nano_crew_manifest(null, TRUE)
	. += silicon_nano_crew_manifest(SSjobs.titles_by_department(MSC))