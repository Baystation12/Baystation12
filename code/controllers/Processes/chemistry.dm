var/datum/controller/process/chemistry/chemistryProcess

/datum/controller/process/chemistry
	var/tmp/datum/updateQueue/updateQueueInstance
	var/list/active_holders
	var/list/chemical_reactions
	var/list/chemical_reagents

/datum/controller/process/chemistry/setup()
	name = "chemistry"
	schedule_interval = 20 // every 2 seconds
	updateQueueInstance = new
	chemistryProcess = src
	active_holders = list()
	chemical_reactions = chemical_reactions_list
	chemical_reagents = chemical_reagents_list

/datum/controller/process/chemistry/getStatName()
	return ..()+"([active_holders.len])"

/datum/controller/process/chemistry/doWork()
	for(var/datum/reagents/holder in active_holders)
		if(!holder.process_reactions())
			active_holders -= holder
		scheck()

/datum/controller/process/chemistry/proc/mark_for_update(var/datum/reagents/holder)
	if(holder in active_holders) 
		return

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
	if(holder.process_reactions())
		active_holders += holder
