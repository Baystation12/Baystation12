/datum/skill_buff/augment


/obj/item/organ/internal/augment/boost
	var/list/buffs //Which abilities does this impact?
	var/buffpath = /datum/skill_buff/augment
	var/active = 0 //mostly to control if we should remove buffs when we go


/obj/item/organ/internal/augment/boost/onInstall()
	if(buffs.len)
		active = owner.buff_skill(buffs, 0, buffpath)

/obj/item/organ/internal/augment/boost/onRemove()
	if(!active)
		return
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	if(B.len)
		B[1].remove()
