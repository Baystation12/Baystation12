// A simple macro for generating getter/setter methods. These should be preferred, as any change to the record structure
// will result in compilation error, therefore making it easier to reveal potential issues that may arise.
#define GETTER_SETTER(X, Y) /datum/computer_file/crew_record/proc/Get##X(){return fields[Y];} /datum/computer_file/crew_record/proc/Set##X(var/newValue){fields[Y] = newValue;}

GLOBAL_LIST_EMPTY(all_crew_records)
GLOBAL_LIST_INIT(blood_types, list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+"))
GLOBAL_LIST_INIT(physical_statuses, list("Active", "Disabled", "SSD", "Deceased"))
GLOBAL_VAR_INIT(default_physical_status, "Active")
GLOBAL_LIST_INIT(security_statuses, list("None", "Released", "Parolled", "Incarcerated", "Arrest"))
GLOBAL_VAR_INIT(default_security_status, "None")
GLOBAL_VAR_INIT(arrest_security_status, "Arrest")

// Kept as a computer file for possible future expansion into servers.
/datum/computer_file/crew_record
	filetype = "CDB"
	size = 2

	// String fields that can be held by this record.
	// Try to avoid manipulating the fields_ variables directly - use getters/setters below instead.
	var/icon/photo_front = null
	var/icon/photo_side = null
	var/list/fields = list()	// Fields of this record

/datum/computer_file/crew_record/New()
	..()
	load_from_mob(null)

/datum/computer_file/crew_record/Destroy()
	. = ..()
	GLOB.all_crew_records.Remove(src)

/datum/computer_file/crew_record/proc/load_from_mob(var/mob/living/carbon/human/H)
	if(istype(H))
		photo_front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/carbon/human/dummy = new()
		photo_front = getFlatIcon(dummy, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(dummy, WEST, always_use_defdir = 1)
		qdel(dummy)

	// Generic record
	SetName(H ? H.real_name : "Unset")
	SetPosition(H ? GetAssignment(H) : "Unset")
	SetSex(H ? gender2text(H.gender) : "Unset")
	SetAge(H ? H.age : 30)
	SetStatus(GLOB.default_physical_status)
	SetSpecies(H ? H.get_species() : SPECIES_HUMAN)
	SetBranch(H ? (H.char_branch && H.char_branch.name) : "None")
	SetRank(H ? (H.char_rank && H.char_rank.name) : "None")

	// Medical record
	SetBloodtype(H ? H.b_type : "Unset")
	SetMedRecord((H && H.med_record && !jobban_isbanned(H, "Records") ? H.med_record : "No record supplied"))

	// Security record
	SetCriminalStatus(GLOB.default_security_status)
	SetDna(H ? H.dna.unique_enzymes : "")
	SetFingerprint(H ? md5(H.dna.uni_identity) : "")
	SetSecRecord((H && H.sec_record && !jobban_isbanned(H, "Records") ? H.sec_record : "No record supplied"))

	// Employment record
	SetEmplRecord((H && H.gen_record && !jobban_isbanned(H, "Records") ? H.gen_record : "No record supplied"))
	SetHomeSystem(H ? H.home_system : "Unset")
	SetCitizenship(H ? H.citizenship : "Unset")
	SetFaction(H ? H.personal_faction : "Unset")
	SetReligion(H ? H.religion : "Unset")

	// Antag record
	SetAntagRecord((H && H.exploit_record && !jobban_isbanned(H, "Records") ? H.exploit_record : "No record supplied"))

// Returns independent copy of this file.
/datum/computer_file/crew_record/clone(var/rename = 0)
	var/datum/computer_file/crew_record/temp = ..()
	return temp

// Global methods
// Used by character creation to create a record for new arrivals.
/proc/CreateModularRecord(var/mob/living/carbon/human/H)
	var/datum/computer_file/crew_record/CR = new/datum/computer_file/crew_record()
	CR.load_from_mob(H)
	GLOB.all_crew_records.Add(CR)
	return CR

// Gets crew records filtered by set of positions
/proc/department_crew_manifest(var/list/filter_positions, var/blacklist = FALSE)
	var/list/matches = list()
	for(var/datum/computer_file/crew_record/CR in GLOB.all_crew_records)
		var/rank = CR.GetPosition()
		if(blacklist)
			if(!(rank in filter_positions))
				matches.Add(CR)
		else
			if(rank in filter_positions)
				matches.Add(CR)
	return matches

// Simple record to HTML (for paper purposes) conversion.
// Not visually that nice, but it gets the work done, feel free to tweak it visually
/proc/record_to_html(var/datum/computer_file/crew_record/CR, var/access_med, var/access_empl, var/access_sec)
	var/dat = "<H2>RECORD DATABASE DATA DUMP</H2><i>Generated on: [stationdate2text()] [stationtime2text()]</i><br>******************************<br>"
	dat += "<table><tr><th>Field<th>Content"
	dat += "<tr><td>Name<td>[CR.GetName()]"
	dat += "<tr><td>Position<td>[CR.GetPosition()]"
	dat += "<tr><td>Sex<td>[CR.GetSex()]"
	dat += "<tr><td>Age<td>[CR.GetAge()]"
	dat += "<tr><td>Status<td>[CR.GetStatus()]"
	dat += "<tr><td>Species<td>[CR.GetSpecies()]"
	dat += "<tr><td>Branch<td>[CR.GetBranch()]"
	dat += "<tr><td>Rank<td>[CR.GetRank()]"
	if(access_med)
		dat += "<tr><td>Blood Type<td>[CR.GetBloodtype()]"
		dat += "<tr><td>Details (Medical)<td>[pencode2html(CR.GetMedRecord())]"
	if(access_empl)
		dat += "<tr><td>Home System<td>[CR.GetHomeSystem()]"
		dat += "<tr><td>Citizenship<td>[CR.GetCitizenship()]"
		dat += "<tr><td>Faction<td>[CR.GetFaction()]"
		dat += "<tr><td>Religion<td>[CR.GetReligion()]"
		dat += "<tr><td>Details (Employment)<td>[pencode2html(CR.GetEmplRecord())]"
	if(access_sec)
		dat += "<tr><td>Criminal Status<td>[CR.GetCriminalStatus()]"
		dat += "<tr><td>DNA Hash<td>[CR.GetDna()]"
		dat += "<tr><td>Fingerprint Hash<td>[CR.GetFingerprint()]"
		dat += "<tr><td>Details (Security)<td>[pencode2html(CR.GetSecRecord())]"
	dat += "</table><br>******************************"
	return dat

// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest(var/monochrome, var/OOC)
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
	for(var/datum/computer_file/crew_record/CR in GLOB.all_crew_records)
		var/name = CR.GetName()
		var/rank = CR.GetPosition()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.GetBranch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.GetBranch(), CR.GetRank())

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
			isactive[name] = CR.GetStatus()

			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line
		var/department = 0
		if(rank in GLOB.command_positions)
			heads[name] = rank
			department = 1
		if(rank in GLOB.support_positions)
			spt[name] = rank
			department = 1
		if(rank in GLOB.security_positions)
			sec[name] = rank
			department = 1
		if(rank in GLOB.engineering_positions)
			eng[name] = rank
			department = 1
		if(rank in GLOB.medical_positions)
			med[name] = rank
			department = 1
		if(rank in GLOB.science_positions)
			sci[name] = rank
			department = 1
		if(rank in GLOB.cargo_positions)
			car[name] = rank
			department = 1
		if(rank in GLOB.civilian_positions)
			civ[name] = rank
			department = 1
		if(rank in GLOB.service_positions)
			srv[name] = rank
			department = 1
		if(rank in GLOB.supply_positions)
			sup[name] = rank
			department = 1
		if(!department && !(name in heads))
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
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(var/name in sec)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sec[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(var/name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[eng[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(var/name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[med[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Research</th></tr>"
		for(var/name in sci)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sci[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(sup.len > 0)
		dat += "<tr><th colspan=3>Supply</th></tr>"
		for(var/name in sup)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[sup[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(srv.len > 0)
		dat += "<tr><th colspan=3>Service</th></tr>"
		for(var/name in srv)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[srv[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(car.len > 0)
		dat += "<tr><th colspan=3>Cargo</th></tr>"
		for(var/name in car)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[car[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(var/name in civ)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[civ[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(var/name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[mil_ranks[name]][name]</td><td>[bot[name]]</td><td>[isactive[name]]</td></tr>"
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
			"name" = CR.GetName(),
			"rank" = CR.GetRank(),
			"status" = CR.GetStatus(),
			"branch" = CR.GetBranch(),
			"rank" = CR.GetRank()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(\
		"heads" = filtered_nano_crew_manifest(GLOB.command_positions),\
		"spt" = filtered_nano_crew_manifest(GLOB.support_positions),\
		"sec" = filtered_nano_crew_manifest(GLOB.security_positions),\
		"eng" = filtered_nano_crew_manifest(GLOB.engineering_positions),\
		"med" = filtered_nano_crew_manifest(GLOB.medical_positions),\
		"sci" = filtered_nano_crew_manifest(GLOB.science_positions),\
		"car" = filtered_nano_crew_manifest(GLOB.cargo_positions),\
		"sup" = filtered_nano_crew_manifest(GLOB.supply_positions),\
		"srv" = filtered_nano_crew_manifest(GLOB.service_positions),\
		"civ" = filtered_nano_crew_manifest(GLOB.civilian_positions),\
		"bot" = silicon_nano_crew_manifest(GLOB.cargo_positions),\
		"misc" = filtered_nano_crew_manifest(GLOB.cargo_positions)\
		)

/proc/get_crewmember_record(var/name)
	for(var/datum/computer_file/crew_record/CR in GLOB.all_crew_records)
		if(CR.GetName() == name)
			return CR
	return null

/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(!H)
		return "Unassigned"
	if(!H.mind)
		return H.job
	if(!H.mind.role_alt_title)
		return H.mind.role_alt_title
	return H.mind.assigned_role

// Getters/Setters below.

// GENERIC RECORDS
GETTER_SETTER(Name, "name")				// Results in GetName() and SetName(var/newname) methods.
GETTER_SETTER(Position, "position")
GETTER_SETTER(Sex, "sex")
GETTER_SETTER(Age, "age")
GETTER_SETTER(Status, "status")
GETTER_SETTER(Species, "species")
GETTER_SETTER(Branch, "branch")
GETTER_SETTER(Rank, "rank")

// MEDICAL RECORDS
GETTER_SETTER(Bloodtype, "bloodtype")
GETTER_SETTER(MedRecord, "medRecord")

// SECURITY RECORDS
GETTER_SETTER(CriminalStatus, "criminalStatus")
GETTER_SETTER(SecRecord, "secRecord")
GETTER_SETTER(Dna, "dna")
GETTER_SETTER(Fingerprint, "fingerprint")

// EMPLOYMENT RECORDS
GETTER_SETTER(EmplRecord, "emplRecord")
GETTER_SETTER(HomeSystem, "homeSystem")
GETTER_SETTER(Citizenship, "citizenship")
GETTER_SETTER(Faction, "faction")
GETTER_SETTER(Religion, "religion")

// ANTAG RECORDS
GETTER_SETTER(AntagRecord, "antagRecord")

#undef GETTER_SETTER