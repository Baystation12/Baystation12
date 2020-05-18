/datum/skill_buff/augment
	var/id

/obj/item/organ/internal/augment/boost
	var/list/buffs = list()//Which abilities does this impact?
	var/list/injury_debuffs = list()//If organ is damaged, should we reduce anything?
	var/buffpath = /datum/skill_buff/augment //if you use something else it should be a subtype or it will runtime
	var/active = 0 //mostly to control if we should remove buffs when we go
	var/debuffing = 0 //if we applied a debuff
	var/id //Unique Id assigned on new
	icon_state = "booster"
	allowed_organs = list(BP_AUGMENT_HEAD)

/obj/item/organ/internal/augment/boost/Initialize()
	. = ..()
	id = "[/obj/item/organ/internal/augment/boost]_[sequential_id(/obj/item/organ/internal/augment/boost)]"


/obj/item/organ/internal/augment/boost/onInstall()
	if(buffs.len)
		var/datum/skill_buff/augment/A
		A = owner.buff_skill(buffs, 0, buffpath)
		if(A && istype(A))
			active = 1
			A.id = id

/obj/item/organ/internal/augment/boost/onRemove()
	debuffing = 0
	if(!active)
		return
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	for(var/datum/skill_buff/augment/D in B)
		if(D.id == id)
			D.remove()
			return

//Procs to set the negative skills and positive ones (This is once the initial setup has been done)
/obj/item/organ/internal/augment/boost/proc/debuff()
	if(!injury_debuffs ||!injury_debuffs.len)
		return 0
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	for(var/datum/skill_buff/augment/D in B)
		if(D.id == id)
			D.recalculate(injury_debuffs)
			debuffing = 1
			return 1

/obj/item/organ/internal/augment/boost/proc/buff()
	if(!buffs || !buffs.len)
		return 0
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	for(var/datum/skill_buff/augment/D in B)
		if(D.id == id)
			D.recalculate(buffs)
			debuffing = 0
			return 1

/obj/item/organ/internal/augment/boost/Process()
	..()
	if(!owner)
		return
	if(is_broken() && !debuffing)
		debuff()
	else if(!is_broken() && debuffing)
		buff()


