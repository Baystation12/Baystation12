//The base type is suitable for generic buffs not needing special treatment.
/datum/skill_buff
	var/list/buffs              //Format: list(skill_path = amount)
	var/limit                   //How many buffs of this type a skillset can have. null = no limit
	var/datum/skillset/skillset //The skillset to which this buff belongs.

/datum/skill_buff/New(buff)
	buffs = buff
	..()

/datum/skill_buff/Destroy()
	if(skillset)
		LAZYREMOVE(skillset.skill_buffs, src)
		skillset = null
	. = ..()

//Clamps the buff amounts so that the target stays between SKILL_MIN and SKILL_MAX in all skills.
/datum/skill_buff/proc/tailor_buff(mob/target)
	if(!buffs)
		return
	var/list/temp_buffs = buffs.Copy()
	for(var/skill_type in temp_buffs)
		var/has_now = target.get_skill_value(skill_type)
		var/current_buff = buffs[skill_type]
		var/new_buff = Clamp(has_now + current_buff, SKILL_MIN, SKILL_MAX) - has_now
		new_buff ? (buffs[skill_type] = new_buff) : (buffs -= skill_type)
	return length(buffs)

/datum/skill_buff/proc/can_buff(mob/target)
	if(!length(buffs) || !istype(target))
		return //what are we even buffing?
	if(target.too_many_buffs(type))
		return
	return 1

/datum/skill_buff/proc/remove()
	var/datum/skillset/my_skillset = skillset
	qdel(src)
	if(my_skillset)
		my_skillset.on_levels_change()

/datum/skill_buff/proc/recalculate(to_buff)
	//Here buff alreafy exists so only question is validity of new input
	if(!length(to_buff))
		return
	var/temp = buffs.Copy()
	buffs = to_buff
	//attempt to clamp
	var/datum/skillset/my_skillset = skillset
	if(my_skillset)
		if(tailor_buff(my_skillset.owner))
			my_skillset.on_levels_change()
		else buffs = temp //Return to old values. Something passed didn't make sense.

//returns a list of buffs of the given type.
/mob/proc/fetch_buffs_of_type(buff_type, subtypes = 1)
	. = list()
	for(var/datum/skill_buff/buff in skillset.skill_buffs)
		if(subtypes && istype(buff, buff_type))
			. += buff
		else if(!subtypes && (buff.type == buff_type))
			. += buff

/mob/proc/buff_skill(to_buff, duration, buff_type = /datum/skill_buff)
	var/datum/skill_buff/buff = new buff_type(to_buff)
	if(!buff.can_buff(src))
		return
	if(!buff.tailor_buff(src))
		return //Turns out there's nothing to buff.
	LAZYADD(skillset.skill_buffs, buff)
	buff.skillset = skillset
	skillset.on_levels_change()
	if(duration)
		addtimer(CALLBACK(buff, /datum/skill_buff/proc/remove), duration)
	return buff

//Takes a buff type or datum; typing is false here.
/mob/proc/too_many_buffs(datum/skill_buff/buff_type)
	var/limit = initial(buff_type.limit)
	if(limit && (length(fetch_buffs_of_type(buff_type, 0)) >= limit))
		return 1