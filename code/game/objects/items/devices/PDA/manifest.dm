/*
We can't just insert in HTML into the nanoUI so we need the raw data to play with.
Instead of creating this list over and over when someone leaves their PDA open to the page
we'll only update it when it changes.  The PDA_Manifest global list is zeroed out upon any change
using /datum/datacore/proc/manifest_inject( ), or manifest_insert( ). Synth despawns and
name updates also zero the list; although they are not in data_core, synths are on manifest.
*/

/var/global/list/PDA_Manifest = list()
/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "[prefix] ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/datum/datacore/proc/get_manifest_list()
	if(PDA_Manifest.len)
		return
	var/heads[0]
	var/spt[0]
	var/sec[0]
	var/eng[0]
	var/med[0]
	var/sci[0]
	var/car[0]
	var/sup[0]
	var/srv[0]
	var/civ[0]
	var/bot[0]
	var/misc[0]

	for(var/datum/data/record/t in data_core.general)
		var/name = sanitize(t.fields["name"])
		var/rank = sanitize(t.fields["rank"])
		var/real_rank = make_list_rank(t.fields["real_rank"])

		var/isactive = t.fields["p_stat"]
		var/department = 0
		var/depthead = 0 			// Department Heads will be placed at the top of their lists.

		var/mil_branch = null
		var/mil_rank = null

		if(using_map.flags & MAP_HAS_BRANCH && t.fields["mil_branch"] && t.fields["mil_branch"] != "None")
			var/datum/mil_branch/branch_datum = mil_branches.get_branch(t.fields["mil_branch"])
			if(branch_datum)
				mil_branch = list("full" = branch_datum.name, "short" = branch_datum.name_short)

		if(using_map.flags & MAP_HAS_RANK && t.fields["mil_rank"] && t.fields["mil_rank"] != "None")
			var/datum/mil_rank/mil_rank_datum = mil_branches.get_rank(t.fields["mil_branch"], t.fields["mil_rank"])
			if(mil_rank_datum)
				mil_rank = list("full" = mil_rank_datum.name, "short" = mil_rank_datum.name_short)


		if(real_rank in command_positions)
			heads[++heads.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			depthead = 1
			if(rank=="Captain" && heads.len != 1)
				heads.Swap(1,heads.len)

		if(real_rank in support_positions)
			spt[++spt.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && spt.len != 1)
				spt.Swap(1,spt.len)

		if(real_rank in security_positions)
			sec[++sec.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && sec.len != 1)
				sec.Swap(1,sec.len)

		if(real_rank in engineering_positions)
			eng[++eng.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && eng.len != 1)
				eng.Swap(1,eng.len)

		if(real_rank in medical_positions)
			med[++med.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && med.len != 1)
				med.Swap(1,med.len)

		if(real_rank in science_positions)
			sci[++sci.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && sci.len != 1)
				sci.Swap(1,sci.len)

		if(real_rank in cargo_positions)
			car[++car.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && car.len != 1)
				car.Swap(1,car.len)

		if(real_rank in supply_positions)
			sup[++sup.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && sup.len != 1)
				sup.Swap(1,sup.len)

		if(real_rank in service_positions)
			srv[++srv.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && srv.len != 1)
				srv.Swap(1,srv.len)

		if(real_rank in civilian_positions)
			civ[++civ.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)
			department = 1
			if(depthead && civ.len != 1)
				civ.Swap(1,civ.len)

		if(!department && !(name in heads))
			misc[++misc.len] = list("name" = name,
				"rank" = rank,
				"active" = isactive,
				"mil_branch" = mil_branch,
				"mil_rank" = mil_rank)


	// Silicons do not have records. See also /datum/datacore/proc/get_manifest
	for(var/mob/living/silicon/ai/ai in mob_list)
		bot[++bot.len] = list("name" = ai.name, "rank" = "Artificial Intelligence", "active" = null)

	for(var/mob/living/silicon/robot/robot in mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[++bot.len] = list("name" = robot.name, "rank" = "[robot.modtype] [robot.braintype]", "active" = null)


	PDA_Manifest = list(
		"heads" = heads,\
		"spt" = spt,\
		"sec" = sec,\
		"eng" = eng,\
		"med" = med,\
		"sci" = sci,\
		"car" = car,\
		"sup" = sup,\
		"srv" = srv,\
		"civ" = civ,\
		"bot" = bot,\
		"misc" = misc\
		)
	return