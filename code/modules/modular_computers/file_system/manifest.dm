// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest(var/monochrome, var/OOC)
	var/list/heads = new()
	var/list/spt = new()
	var/list/sec = new()
	var/list/eng = new()
	var/list/med = new()
	var/list/sci = new()
	var/list/civ = new()
	var/list/bot = new()
	var/list/misc = new()
	var/list/srv = new()
	var/list/sup = new()
	var/list/exp = new()
	var/list/isactive = new()
	var/list/mil_ranks = list() // HTML to prepend to name
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628A":"#48C"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	var/even = 0
	// sort mobs
	for(var/datum/computer_file/crew_record/CR in GLOB.all_crew_records)
		var/name = CR.get_name()
		var/rank = CR.get_job()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = CR.get_status()

			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line
		var/datum/job/job = job_master.occupations_by_title[rank]
		if(!job)
			misc[name] = rank
			continue

		var/department = 0
		if(job.department_flag & COM)
			heads[name] = rank
			department = 1
		if(job.department_flag & SPT)
			spt[name] = rank
			department = 1
		if(job.department_flag & SEC)
			sec[name] = rank
			department = 1
		if(job.department_flag & ENG)
			eng[name] = rank
			department = 1
		if(job.department_flag & MED)
			med[name] = rank
			department = 1
		if(job.department_flag & SCI)
			sci[name] = rank
			department = 1
		if(job.department_flag & EXP)
			exp[name] = rank
			department = 1
		if(job.department_flag & CIV)
			civ[name] = rank
			department = 1
		if(job.department_flag & SRV)
			srv[name] = rank
			department = 1
		if(job.department_flag & SUP)
			sup[name] = rank
			department = 1
		if((job.department_flag & MSC) || (!department && !(name in heads)))
			misc[name] = rank

	// Synthetics don't have actual records, so we will pull them from here.
	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		bot[ai.name] = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[robot.name] = "[robot.modtype] [robot.braintype]"


	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads of Staff</th></tr>"
		for(var/name in heads)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[heads[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(spt.len > 0)
		dat += "<tr><th colspan=3>Command Support</th></tr>"
		for(var/name in spt)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[spt[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Research</th></tr>"
		for(var/name in sci)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sci[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(var/name in sec)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sec[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(var/name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[med[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(var/name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[eng[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sup.len > 0)
		dat += "<tr><th colspan=3>Supply</th></tr>"
		for(var/name in sup)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sup[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(exp.len > 0)
		dat += "<tr><th colspan=3>Exploration</th></tr>"
		for(var/name in exp)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[exp[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(srv.len > 0)
		dat += "<tr><th colspan=3>Service</th></tr>"
		for(var/name in srv)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[srv[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(var/name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[bot[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(var/name in civ)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[civ[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// misc guys
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(var/name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[misc[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even


	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
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
	for(var/datum/computer_file/crew_record/CR in department_crew_manifest(filter, blacklist))
		filtered_entries.Add(list(list(
			"name" = CR.get_name(),
			"rank" = CR.get_job(),
			"status" = CR.get_status(),
			"branch" = CR.get_branch(),
			"milrank" = CR.get_rank()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(\
		"heads" = filtered_nano_crew_manifest(GLOB.command_positions),\
		"spt" = filtered_nano_crew_manifest(GLOB.support_positions),\
		"sci" = filtered_nano_crew_manifest(GLOB.science_positions),\
		"sec" = filtered_nano_crew_manifest(GLOB.security_positions),\
		"eng" = filtered_nano_crew_manifest(GLOB.engineering_positions),\
		"med" = filtered_nano_crew_manifest(GLOB.medical_positions),\
		"sup" = filtered_nano_crew_manifest(GLOB.supply_positions),\
		"exp" = filtered_nano_crew_manifest(GLOB.exploration_positions),\
		"srv" = filtered_nano_crew_manifest(GLOB.service_positions),\
		"bot" = silicon_nano_crew_manifest(GLOB.nonhuman_positions),\
		"civ" = filtered_nano_crew_manifest(GLOB.civilian_positions),\
		"misc" = filtered_nano_crew_manifest(GLOB.unsorted_positions)\
		)
