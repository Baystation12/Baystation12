//A datum that performs antag-related skill selection functions.

/datum/antag_skill_setter
	var/nm_type                        //A nano_module with custom ui, if any.
	var/list/base_skill_list = list()  //Format: list(path = value).
	var/default_value = SKILL_DEFAULT  //If not in base_skill_list or added in another way, skill value will be this.

/datum/antag_skill_setter/proc/initialize_skills(datum/skillset/skillset)
	skillset.skill_list = base_skill_list.Copy()
	skillset.default_value = default_value
	QDEL_NULL_LIST(skillset.skill_buffs)
	if(nm_type)
		skillset.nm_type = nm_type
		QDEL_NULL(skillset.NM)
	skillset.on_antag_initialize()

//This is the generic antag skill setter, used for most antag types.
/datum/antag_skill_setter/generic
	nm_type = /datum/nano_module/skill_ui/antag
	default_value = SKILL_BASIC

/datum/antag_skill_setter/generic/initialize_skills(datum/skillset/skillset)
	..()
	skillset.open_ui()

//This will obtain skills from the job selection before giving additional buffs.
/datum/antag_skill_setter/station
	nm_type = /datum/nano_module/skill_ui/antag/station

/datum/antag_skill_setter/station/initialize_skills(datum/skillset/skillset)
	..()
	if(skillset.owner)
		var/client/my_client = skillset.owner.client
		if(my_client && skillset.owner.mind)
			var/datum/job/job = SSjobs.get_by_title(skillset.owner.mind.assigned_role)
			skillset.obtain_from_client(job, my_client, 1)
	skillset.open_ui()

//This will obtain skills from the job selection before giving additional buffs.
/datum/antag_skill_setter/station/offstation
	nm_type = /datum/nano_module/skill_ui/antag/station/offstation

//Placeholder for ai; defaults to experienced in everything like usual.
/datum/antag_skill_setter/ai