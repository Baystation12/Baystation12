// A simple macro for generating getter/setter methods. These should be preferred, as any change to the record structure
// will result in compilation error, therefore making it easier to reveal potential issues that may arise.
#define GETTER_SETTER(X, Y) /datum/computer_file/crew_record/proc/Get##X(){return fields[Y];} /datum/computer_file/crew_record/proc/Set##X(var/newValue){fields[Y] = newValue;}

GLOBAL_LIST_EMPTY(all_crew_records)
GLOBAL_LIST_INIT(blood_types, list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+"))
GLOBAL_LIST_INIT(physical_statuses, list("Active", "Disabled", "SSD", "Deceased"))
GLOBAL_VAR_INIT(default_physical_status, "Active")
GLOBAL_LIST_INIT(security_statuses, list("None", "Released", "Parolled", "Incarcerated", "Arrest"))
GLOBAL_VAR_INIT(default_security_status, "None")

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


/proc/CreateModularRecord(var/mob/living/carbon/human/H)
	var/datum/computer_file/crew_record/CR = new/datum/computer_file/crew_record()
	CR.load_from_mob(H)
	GLOB.all_crew_records.Add(CR)

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