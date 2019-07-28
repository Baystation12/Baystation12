/datum/mind
	var/list/memories

/mob/proc/StoreMemory(var/memory, var/options)
	if(!mind)
		return "There is no mind to store a memory in."
	. = mind.StoreMemory(memory, options)

/datum/mind/proc/StoreMemory(var/memory, var/options)
	var/decl/memory_options/MO = decls_repository.get_decl(options || /decl/memory_options/default)
	return MO.Create(src, memory)

/datum/mind/proc/ClearMemories(var/list/tags)
	for(var/mem in memories)
		var/datum/memory/M = mem
		// If no tags were supplied OR if there is any union between the given tags and memory tags
		//  then remove the memory
		if(!length(tags) || length(tags & M.tags))
			LAZYREMOVE(memories, M)

/datum/mind/proc/CopyMemories(var/datum/mind/target)
	if(!istype(target))
		return

	var/new_tags = target.MemoryTags()
	for(var/mem in memories)
		var/datum/memory/M = mem
		M.Copy(target, new_tags)

/datum/mind/proc/MemoryTags()
	. = list()
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(antag.is_antagonist(src))
			. += antag_type

/datum/mind/proc/ShowMemory(var/mob/recipient)
	var/list/output = list()
	var/last_owner_name
	// We pretend that memories are stored in some semblance of an order
	for(var/mem in memories)
		var/datum/memory/M = mem
		var/owner_name = M.OwnerName()
		if(owner_name != last_owner_name)
			output += "<B>[current.real_name]'s Memories</B><HR>"
			last_owner_name = owner_name
		output += "[M.memory] <a href='?src=\ref[src];remove_memory=\ref[M]'>\[Remove\]</a>"

	if(objectives.len > 0)
		output += "<HR><B>Objectives:</B>"

		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++

	if(SSgoals.ambitions[src])
		var/datum/goal/ambition/ambition = SSgoals.ambitions[src]
		output += "<HR><B>Ambitions:</B> [ambition.summarize()]"

	recipient << browse(jointext(output, "<BR>"),"window=memory")

/***********
* Memories *
***********/
/datum/memory
	var/memory // Sanitized strings expected. Remember to unsanitize if adding editing
	var/list/tags
	var/weakref/owner
	var/_owner_name

/datum/memory/New(var/weakref/owner, var/memory, var/tags)
	..()
	src.owner = owner
	src.memory = memory
	src.tags = tags
	OwnerName()

/datum/memory/Destroy()
	owner = null
	return ..()

/datum/memory/proc/OwnerName()
	if(owner)
		var/mob/owner_mob = owner.resolve()
		if(owner_mob)
			_owner_name = owner_mob.real_name
		else
			owner = null
	return _owner_name


/datum/memory/proc/Copy(var/datum/mind/target, var/new_tags)
	var/datum/memory/new_memory = new/datum/memory(owner, memory, new_tags)
	new_memory._owner_name = new_memory._owner_name || _owner_name
	new_memory.owner = null // Copied memories are detached from their previous owners
	LAZYADD(target.memories, new_memory)

/datum/memory/user

/datum/memory/system/New()
	..()
	tags = null // System memories never have tags

/*****************
* Memory Options *
*****************/

// General memory handling
/decl/memory_options
	var/memory_type = /datum/memory

/decl/memory_options/proc/Validate(var/datum/mind/target)
	if(!target.current)
		return "Mind is detached from mob."

/decl/memory_options/proc/MemoryTags(var/datum/mind/target)
	return

/decl/memory_options/proc/Log(var/memory)
	log_and_message_admins("created a memory: [memory]")

/decl/memory_options/proc/Create(var/datum/mind/target, var/memory)
	var/error = Validate(target)
	if(error)
		return error

	var/owner = weakref(target.current)
	var/tags = MemoryTags(target)
	var/new_memory = new memory_type(owner, memory, tags)
	LAZYADD(target.memories, new_memory)
	Log(memory)

// Default memory handling
/decl/memory_options/default
	memory_type = /datum/memory/user
	var/const/memory_limit = 32

/decl/memory_options/default/MemoryTags(var/datum/mind/target)
	return target.MemoryTags()

/decl/memory_options/default/Validate(var/datum/mind/target)
	if((. = ..()))
		return

	var/relevant_memories = 0
	for(var/mem in target.memories)
		var/datum/memory/M = mem
		if(M.type == memory_type)
			relevant_memories++

	if(relevant_memories > memory_limit)
		return "Memory limit reached. A maximum of [memory_limit] user added memories allowed."

// System memory handling
/decl/memory_options/system
	memory_type = /datum/memory/system

/decl/memory_options/system/Log()
	return

/********
* Verbs *
********/

/mob/verb/ShowMemories()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.ShowMemory(src)
	else
		to_chat(src, SPAN_WARNING("There is no mind to retrieve stored memories from."))

/mob/verb/AddMemory(var/msg as text)
	set name = "Add Note"
	set category = "IC"

	msg = sanitize(msg)
	if(msg)
		var/error = StoreMemory(msg)
		if(error)
			to_chat(src, SPAN_WARNING(error))
		else
			to_chat(src, SPAN_NOTICE("Note added - View it with the 'Notes' verb"))
