GLOBAL_LIST_EMPTY(all_crew_records)
GLOBAL_LIST_INIT(blood_types, list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+"))
GLOBAL_LIST_INIT(physical_statuses, list("Active", "Disabled", "SSD", "Deceased", "MIA"))
GLOBAL_VAR_INIT(default_physical_status, "Active")
GLOBAL_LIST_INIT(security_statuses, list("None", "Released", "Parolled", "Incarcerated", "Arrest"))
GLOBAL_VAR_INIT(default_security_status, "None")
GLOBAL_VAR_INIT(arrest_security_status, "Arrest")

// Kept as a computer file for possible future expansion into servers.
/datum/computer_file/report/crew_record
	filetype = "CDB"
	size = 2
	var/icon/photo_front = null
	var/icon/photo_side = null
	//More variables below.

/datum/computer_file/report/crew_record/New()
	..()
	load_from_mob(null)

/datum/computer_file/report/crew_record/Destroy()
	. = ..()
	GLOB.all_crew_records.Remove(src)

/datum/computer_file/report/crew_record/proc/load_from_mob(var/mob/living/carbon/human/H)
	if(istype(H))
		photo_front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/carbon/human/dummy = new()
		photo_front = getFlatIcon(dummy, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(dummy, WEST, always_use_defdir = 1)
		qdel(dummy)

	// Add honorifics, etc.
	var/formal_name = "Unset"
	if(H)
		formal_name = H.real_name
		if(H.client && H.client.prefs)
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSculture.get_culture(H.client.prefs.cultural_info[culturetag])
				if(H.char_rank && H.char_rank.name_short)
					formal_name = "[formal_name][culture.get_formal_name_suffix()]"
				else
					formal_name = "[culture.get_formal_name_prefix()][formal_name][culture.get_formal_name_suffix()]"

	// Generic record
	set_name(H ? H.real_name : "Unset")
	set_formal_name(formal_name)
	set_job(H ? GetAssignment(H) : "Unset")
	var/gender_term = "Unset"
	if(H)
		var/datum/gender/G = gender_datums[H.get_sex()]
		if(G)
			gender_term = gender2text(G.formal_term)
	set_sex(gender_term)
	set_age(H ? H.age : 30)
	set_status(GLOB.default_physical_status)
	set_species(H ? H.get_species() : SPECIES_HUMAN)
	set_branch(H ? (H.char_branch && H.char_branch.name) : "None")
	set_rank(H ? (H.char_rank && H.char_rank.name) : "None")
	set_public_record(H && H.public_record && !jobban_isbanned(H, "Records") ? html_decode(H.public_record) : "No record supplied")

	// Medical record
	set_bloodtype(H ? H.b_type : "Unset")
	set_medRecord((H && H.med_record && !jobban_isbanned(H, "Records") ? html_decode(H.med_record) : "No record supplied"))

	if(H)
		if(H.isSynthetic())
			var/organ_data = list("Fully synthetic body")
			for(var/obj/item/organ/internal/augment/A in H.internal_organs)
				organ_data += "installed augment - [A.name]"
			if (LAZYLEN(organ_data))
				set_implants(jointext(organ_data, "\[*\]"))
		else
			var/organ_data = list("\[*\]")
			for(var/obj/item/organ/external/E in H.organs)
				if(BP_IS_ROBOTIC(E))
					organ_data += "[E.model ? "[E.model] " : null][E.name] prosthetic"
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(BP_IS_ASSISTED(I))
					organ_data += I.get_mechanical_assisted_descriptor()
				else if (BP_IS_ROBOTIC(I))
					if (!istype(I, /obj/item/organ/internal/augment)) // Differentiate between augments and prosthetics
						organ_data += "robotic [I.name] prosthetic"
					else
						organ_data += "installed augment - [I.name]"
			set_implants(jointext(organ_data, "\[*\]"))

	// Security record
	set_criminalStatus(GLOB.default_security_status)
	set_dna(H ? H.dna.unique_enzymes : "")
	set_fingerprint(H ? md5(H.dna.uni_identity) : "")
	set_secRecord(H && H.sec_record && !jobban_isbanned(H, "Records") ? html_decode(H.sec_record) : "No record supplied")

	// Employment record
	var/employment_record = "No record supplied"
	if(H)
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			employment_record = html_decode(H.gen_record)
		if(H.client && H.client.prefs)
			var/list/qualifications
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSculture.get_culture(H.client.prefs.cultural_info[culturetag])
				var/extra_note = culture.get_qualifications()
				if(extra_note)
					LAZYADD(qualifications, extra_note)
			if(LAZYLEN(qualifications))
				employment_record = "[employment_record ? "[employment_record]\[br\]" : ""][jointext(qualifications, "\[br\]>")]"
	set_emplRecord(employment_record)

	// Misc cultural info.
	set_homeSystem(H ? html_decode(H.get_cultural_value(TAG_HOMEWORLD)) : "Unset")
	set_faction(H ? html_decode(H.get_cultural_value(TAG_FACTION)) : "Unset")
	set_religion(H ? html_decode(H.get_cultural_value(TAG_RELIGION)) : "Unset")

	if(H)
		var/skills = list()
		for(var/decl/hierarchy/skill/S in GLOB.skills)
			var/level = H.get_skill_value(S.type)
			if(level > SKILL_NONE)
				skills += "[S.name], [S.levels[level]]"

		set_skillset(jointext(skills,"\n"))

	// Antag record
	set_antagRecord(H && H.exploit_record && !jobban_isbanned(H, "Records") ? html_decode(H.exploit_record) : "")

// Global methods
// Used by character creation to create a record for new arrivals.
/proc/CreateModularRecord(var/mob/living/carbon/human/H)
	var/datum/computer_file/report/crew_record/CR = new/datum/computer_file/report/crew_record()
	GLOB.all_crew_records.Add(CR)
	CR.load_from_mob(H)
	return CR

// Gets crew records filtered by set of positions
/proc/department_crew_manifest(var/list/filter_positions, var/blacklist = FALSE)
	var/list/matches = list()
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		var/rank = CR.get_job()
		if(blacklist)
			if(!(rank in filter_positions))
				matches.Add(CR)
		else
			if(rank in filter_positions)
				matches.Add(CR)
	return matches

// Simple record to HTML (for paper purposes) conversion.
// Not visually that nice, but it gets the work done, feel free to tweak it visually
/proc/record_to_html(var/datum/computer_file/report/crew_record/CR, var/access)
	var/dat = "<tt><H2>RECORD DATABASE DATA DUMP</H2><i>Generated on: [stationdate2text()] [stationtime2text()]</i><br>******************************<br>"
	dat += "<table>"
	for(var/datum/report_field/F in CR.fields)
		if(F.verify_access(access))
			dat += "<tr><td><b>[F.display_name()]</b>"
			if(F.needs_big_box)
				dat += "<tr>"
			dat += "<td>[F.get_value()]"
	dat += "</tt>"
	return dat

/proc/get_crewmember_record(var/name)
	name = sanitize(name)
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		if(CR.get_name() == name)
			return CR
	return null

/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(!H)
		return "Unassigned"
	if(!H.mind)
		return H.job
	if(H.mind.role_alt_title)
		return H.mind.role_alt_title
	return H.mind.assigned_role

#define GETTER_SETTER(PATH, KEY) /datum/computer_file/report/crew_record/proc/get_##KEY(){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) return F.get_value()} \
/datum/computer_file/report/crew_record/proc/set_##KEY(given_value){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) F.set_value(given_value)}
#define SETUP_FIELD(NAME, KEY, PATH, ACCESS, ACCESS_EDIT) GETTER_SETTER(PATH, KEY); /datum/report_field/##PATH/##KEY;\
/datum/computer_file/report/crew_record/generate_fields(){..(); var/datum/report_field/##KEY = add_field(/datum/report_field/##PATH/##KEY, ##NAME);\
KEY.set_access(ACCESS, ACCESS_EDIT || ACCESS || access_bridge)}

// Fear not the preprocessor, for it is a friend. To add a field, use one of these, depending on value type and if you need special access to see it.
// It will also create getter/setter procs for record datum, named like /get_[key here]() /set_[key_here](value) e.g. get_name() set_name(value)
// Use getter setters to avoid errors caused by typoing the string key.
#define FIELD_SHORT(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, simple_text/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_LONG(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, pencode_text/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_NUM(NAME, KEY, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, number/crew_record, ACCESS, ACCESS_EDIT)
#define FIELD_LIST(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT) FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT)
#define FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT) SETUP_FIELD(NAME, KEY, options/crew_record, ACCESS, ACCESS_EDIT);\
/datum/report_field/options/crew_record/##KEY/get_options(){return OPTIONS}

// GENERIC RECORDS
FIELD_SHORT("Name", name, null, access_change_ids)
FIELD_SHORT("Formal Name", formal_name, null, access_change_ids)
FIELD_SHORT("Job", job, null, access_change_ids)
FIELD_LIST("Sex", sex, record_genders(), null, access_change_ids)
FIELD_NUM("Age", age, null, access_change_ids)
FIELD_LIST_EDIT("Status", status, GLOB.physical_statuses, null, access_medical)

FIELD_SHORT("Species",species, null, access_change_ids)
FIELD_LIST("Branch", branch, record_branches(), null, access_change_ids)
FIELD_LIST("Rank", rank, record_ranks(), null, access_change_ids)
FIELD_SHORT("Religion", religion, access_chapel_office, access_change_ids)

FIELD_LONG("General Notes (Public)", public_record, null, access_bridge)

// MEDICAL RECORDS
FIELD_LIST("Blood Type", bloodtype, GLOB.blood_types, access_medical, access_medical)
FIELD_LONG("Medical Record", medRecord, access_medical, access_medical)
FIELD_LONG("Known Implants", implants, access_medical, access_medical)

// SECURITY RECORDS
FIELD_LIST("Criminal Status", criminalStatus, GLOB.security_statuses, access_security, access_security)
FIELD_LONG("Security Record", secRecord, access_security, access_security)
FIELD_SHORT("DNA", dna, access_security, access_security)
FIELD_SHORT("Fingerprint", fingerprint, access_security, access_security)

// EMPLOYMENT RECORDS
FIELD_LONG("Employment Record", emplRecord, access_bridge, access_bridge)
FIELD_SHORT("Home System", homeSystem, access_bridge, access_change_ids)
FIELD_SHORT("Faction", faction, access_bridge, access_bridge)
FIELD_LONG("Qualifications", skillset, access_bridge, access_bridge)

// ANTAG RECORDS
FIELD_LONG("Exploitable Information", antagRecord, access_syndicate, access_syndicate)

//Options builderes
/datum/report_field/options/crew_record/rank/proc/record_ranks()
	var/datum/computer_file/report/crew_record/record = owner
	var/datum/mil_branch/branch = mil_branches.get_branch(record.get_branch())
	if(!branch)
		return
	. = list()
	. |= "Unset"
	for(var/rank in branch.ranks)
		var/datum/mil_rank/RA = branch.ranks[rank]
		. |= RA.name

/datum/report_field/options/crew_record/sex/proc/record_genders()
	. = list()
	. |= "Unset"
	for(var/thing in gender_datums)
		var/datum/gender/G = gender_datums[thing]
		. |= gender2text(G.formal_term)

/datum/report_field/options/crew_record/branch/proc/record_branches()
	. = list()
	. |= "Unset"
	for(var/B in mil_branches.branches)
		var/datum/mil_branch/BR = mil_branches.branches[B]
		. |= BR.name

#undef GETTER_SETTER
#undef SETUP_FIELD
#undef FIELD_SHORT
#undef FIELD_LONG
#undef FIELD_NUM
#undef FIELD_LIST
#undef FIELD_LIST_EDIT
