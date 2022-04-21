GLOBAL_LIST_INIT(psychic_ranks_to_strings, list("Latent", "Operant", "Masterclass", "Grandmasterclass", "Paramount"))

PROCESSING_SUBSYSTEM_DEF(psi)
	name = "Psychics"
	priority = SS_PRIORITY_PSYCHICS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND

	var/list/faculties_by_id =        list()
	var/list/faculties_by_name =      list()
	var/list/all_aura_images =        list()
	var/list/all_psi_complexes =      list()
	var/list/psi_dampeners =          list()
	var/list/psi_monitors =           list()
	var/list/armour_faculty_by_type = list()
	var/list/faculties_by_intent  = list()

/datum/controller/subsystem/processing/psi/proc/get_faculty(var/faculty)
	return faculties_by_name[faculty] || faculties_by_id[faculty]

/datum/controller/subsystem/processing/psi/Initialize(start_uptime)
	var/list/faculties = decls_repository.get_decls_of_subtype(/decl/psionic_faculty)
	for(var/ftype in faculties)
		var/decl/psionic_faculty/faculty = faculties[ftype]
		faculties_by_id[faculty.id] = faculty
		faculties_by_name[faculty.name] = faculty
		faculties_by_intent[faculty.associated_intent] = faculty.id

	var/list/powers = decls_repository.get_decls_of_subtype(/decl/psionic_power)
	for(var/ptype in powers)
		var/decl/psionic_power/power = powers[ptype]
		if(power.faculty)
			var/decl/psionic_faculty/faculty = get_faculty(power.faculty)
			if(faculty)
				faculty.powers |= power
