var/datum/controller/process/chemistry/chemistryProcess

/datum/controller/process/chemistry
	var/list/active_holders
	var/list/chemical_reactions
	var/list/chemical_reagents

/datum/controller/process/chemistry/setup()
	name = "chemistry"
	schedule_interval = 20 // every 2 seconds
	chemistryProcess = src
	active_holders = list()
	chemical_reactions = chemical_reactions_list
	chemical_reagents = chemical_reagents_list

/datum/controller/process/chemistry/statProcess()
	..()
	stat(null, "[active_holders.len] reagent holder\s")

/datum/controller/process/chemistry/doWork()
	for(last_object in active_holders)
		var/datum/reagents/holder = last_object
		if(!holder.process_reactions())
			active_holders -= holder
		SCHECK

/datum/controller/process/chemistry/proc/mark_for_update(var/datum/reagents/holder)
	if(holder in active_holders)
		return

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
	if(holder.process_reactions())
		active_holders += holder
