/hook/startup/proc/createDatacore()
	GLOB.data_core = new /datum/datacore()
	return 1

/datum/data/record
	var/name = "record"
	var/size = 5
	var/archived = FALSE // Only used by digital warrants so far. Hopefully does also find use for other records in future.
	var/list/fields = list()

/datum/datacore
	var/name = "datacore"
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()


/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/list/heads = new()
	var/list/spt = new()
	var/list/sec = new()
	var/list/eng = new()
	var/list/med = new()
	var/list/sci = new()
	var/list/car = new()
	var/list/civ = new()
	var/list/bot = new()
	var/list/misc = new()
	var/list/srv = new()
	var/list/sup = new()
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
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = make_list_rank(t.fields["real_rank"])
		mil_ranks[name] = ""

		if(using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(t.fields["mil_branch"])
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(t.fields["mil_branch"], t.fields["mil_rank"])

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
			isactive[name] = t.fields["p_stat"]

			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line
		var/department = 0
		if(real_rank in command_positions)
			heads[name] = rank
			department = 1
		if(real_rank in support_positions)
			spt[name] = rank
			department = 1
		if(real_rank in security_positions)
			sec[name] = rank
			department = 1
		if(real_rank in engineering_positions)
			eng[name] = rank
			department = 1
		if(real_rank in medical_positions)
			med[name] = rank
			department = 1
		if(real_rank in science_positions)
			sci[name] = rank
			department = 1
		if(real_rank in cargo_positions)
			car[name] = rank
			department = 1
		if(real_rank in civilian_positions)
			civ[name] = rank
			department = 1
		if(real_rank in service_positions)
			srv[name] = rank
			department = 1
		if(real_rank in supply_positions)
			sup[name] = rank
			department = 1
		if(!department && !(name in heads))
			misc[name] = rank

	// Synthetics don't have actual records, so we will pull them from here.
	for(var/mob/living/silicon/ai/ai in GLOB.mob_list)
		bot[ai.name] = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in GLOB.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[robot.name] = "[robot.modtype] [robot.braintype]"


	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads of Staff</th></tr>"
		for(name in heads)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[heads[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(spt.len > 0)
		dat += "<tr><th colspan=3>Command Support</th></tr>"
		for(name in spt)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[spt[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(name in sec)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sec[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[eng[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[med[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Research</th></tr>"
		for(name in sci)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sci[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sup.len > 0)
		dat += "<tr><th colspan=3>Supply</th></tr>"
		for(name in sup)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sup[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(srv.len > 0)
		dat += "<tr><th colspan=3>Service</th></tr>"
		for(name in srv)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[srv[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(car.len > 0)
		dat += "<tr><th colspan=3>Cargo</th></tr>"
		for(name in car)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[car[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(name in civ)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[civ[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[bot[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// misc guys
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[misc[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even


	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest()
	spawn()
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			manifest_inject(H)
		return

/datum/datacore/proc/manifest_modify(var/name, var/assignment)
	ResetPDAManifest()
	var/datum/data/record/foundrecord
	var/real_title = assignment

	for(var/datum/data/record/t in GLOB.data_core.general)
		if (t)
			if(t.fields["name"] == name)
				foundrecord = t
				break

	var/list/all_jobs = get_job_datums()

	for(var/datum/job/J in all_jobs)
		var/list/alttitles = get_alternate_titles(J.title)
		if(!J)	continue
		if(assignment in alttitles)
			real_title = J.title
			break

	if(foundrecord)
		foundrecord.fields["rank"] = assignment
		foundrecord.fields["real_rank"] = real_title

/datum/datacore/proc/manifest_inject(var/mob/living/carbon/human/H)
	if(H.mind && !player_is_antag(H.mind, only_offstation_roles = 1) && job_master.ShouldCreateRecords(H.mind.assigned_role))

		var/id = generate_record_id()
		//General Record
		var/datum/data/record/G = CreateGeneralRecord(H, id)

		//Medical Record
		var/datum/data/record/M = CreateMedicalRecord(H.real_name, id)
		M.fields["b_type"]		= H.b_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		if(H.med_record && !jobban_isbanned(H, "Records"))
			M.fields["notes"] = H.med_record

		//Security Record
		var/datum/data/record/S = CreateSecurityRecord(H.real_name, id)
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			S.fields["notes"] = H.sec_record

		//Locked Record
		var/datum/data/record/L = new()
		L.fields = G.fields.Copy()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")
		L.fields["b_type"]		= H.b_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["enzymes"]		= H.dna.SE // Used in respawning
		L.fields["identity"]	= H.dna.UI // "
		L.fields["image"]		= L.fields["photo_front"]	//This is god-awful
		if(H.exploit_record && !jobban_isbanned(H, "Records"))
			L.fields["exploit_record"] = H.exploit_record
		else
			L.fields["exploit_record"] = "No additional information acquired."
		locked += L
	return

/proc/generate_record_id()
	return add_zero(num2hex(rand(1, 65535)), 4)	//no point generating higher numbers because of the limitations of num2hex

/datum/datacore/proc/CreateGeneralRecord(var/mob/living/carbon/human/H, var/id)
	ResetPDAManifest()
	var/icon/front
	var/icon/side
	if(H)
		front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/carbon/human/dummy = new()
		front = getFlatIcon(dummy, SOUTH, always_use_defdir = 1)
		side = getFlatIcon(dummy, WEST, always_use_defdir = 1)
		qdel(dummy)

	if(!id) id = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	var/datum/data/record/G = new /datum/data/record()
	G.name = "Employee Record #[id]"
	G.fields["id"] = id
	G.fields["name"] = H ? H.real_name : "New Record"
	G.fields["rank"] = H ? GetAssignment(H) : "Unassigned"
	G.fields["real_rank"] = H ? H.mind.assigned_role : "Unassigned"
	G.fields["sex"] =  H ? gender2text(H.gender) : "Unknown"
	G.fields["age"] = H ? H.age :"Unknown"
	G.fields["fingerprint"] = H ? md5(H.dna.uni_identity) : "Unknown"
	G.fields["p_stat"] = "Active"
	G.fields["m_stat"] = "Stable"
	G.fields["species"] = H ? H.get_species() : SPECIES_HUMAN
	G.fields["home_system"]	= H ? H.home_system : "Unknown"
	G.fields["citizenship"]	= H ? H.citizenship : "Unknown"
	G.fields["faction"]		= H ? H.personal_faction : "Unknown"
	G.fields["religion"]	= H ? H.religion : "Unknown"
	G.fields["photo_front"]	= front
	G.fields["photo_side"]	= side
	G.fields["notes"] = "No notes found."
	if(H && H.gen_record && !jobban_isbanned(H, "Records"))
		G.fields["notes"] = H.gen_record
	G.fields["mil_branch"] = H ? H.char_branch && H.char_branch.name : null
	G.fields["mil_rank"] = H ? H.char_rank && H.char_rank.name : null
	G.fields["connections"] =  list()
	general += G

	return G

/datum/datacore/proc/CreateSecurityRecord(var/name, var/id)
	ResetPDAManifest()
	var/datum/data/record/R = new /datum/data/record()
	R.name = "Security Record #[id]"
	R.fields["name"] = name
	R.fields["id"] = id
	R.fields["criminal"]	= "None"
	R.fields["mi_crim"]		= "None"
	R.fields["mi_crim_d"]	= "No minor crime convictions."
	R.fields["ma_crim"]		= "None"
	R.fields["ma_crim_d"]	= "No major crime convictions."
	R.fields["notes"]		= "No notes."
	R.fields["notes"] = "No notes."
	GLOB.data_core.security += R

	return R

/datum/datacore/proc/CreateMedicalRecord(var/name, var/id)
	ResetPDAManifest()
	var/datum/data/record/M = new()
	M.name = "Medical Record #[id]"
	M.fields["id"]			= id
	M.fields["name"]		= name
	M.fields["b_type"]		= "AB+"
	M.fields["b_dna"]		= md5(name)
	M.fields["id_gender"]	= "Unknown"
	M.fields["mi_dis"]		= "None"
	M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
	M.fields["ma_dis"]		= "None"
	M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
	M.fields["alg"]			= "None"
	M.fields["alg_d"]		= "No allergies have been detected in this patient."
	M.fields["cdi"]			= "None"
	M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
	M.fields["notes"] = "No notes found."
	GLOB.data_core.medical += M

	return M

/datum/datacore/proc/ResetPDAManifest()
	if(PDA_Manifest.len)
		PDA_Manifest.Cut()

/proc/find_general_record(field, value)
	return find_record(field, value, GLOB.data_core.general)

/proc/find_medical_record(field, value)
	return find_record(field, value, GLOB.data_core.medical)

/proc/find_security_record(field, value)
	return find_record(field, value, GLOB.data_core.security)

/proc/find_record(field, value, list/L)
	for(var/datum/data/record/R in L)
		if(R.fields[field] == value)
			return R

/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(H.mind.role_alt_title)
		return H.mind.role_alt_title
	else if(H.mind.assigned_role)
		return H.mind.assigned_role
	else if(H.job)
		return H.job
	else
		return "Unassigned"
