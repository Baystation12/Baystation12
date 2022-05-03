/obj/item/organ/internal/augment/boost
	icon_state = "booster"
	augment_slots = AUGMENT_HEAD

	/// Unique ID for collecting the right effect in skill handling
	var/id

	/// Which abilities does this impact?
	var/list/buffs = list()

	/// If organ is damaged, should we reduce anything?
	var/list/injury_debuffs = list()

	/// Only subtypes of /datum/skill_buff/augment
	var/buffpath = /datum/skill_buff/augment

	/// Mostly to control if we should remove buffs when we go
	var/active = FALSE

	/// If we applied a debuff
	var/debuffing = FALSE


/obj/item/organ/internal/augment/boost/Initialize()
	. = ..()
	id = "[/obj/item/organ/internal/augment/boost]_[sequential_id(/obj/item/organ/internal/augment/boost)]"


/obj/item/organ/internal/augment/boost/onInstall()
	if (buffs.len)
		var/datum/skill_buff/augment/A
		A = owner.buff_skill(buffs, 0, buffpath)
		if (A && istype(A))
			active = TRUE
			A.id = id


/obj/item/organ/internal/augment/boost/onRemove()
	debuffing = FALSE
	if (!active)
		return
	for (var/datum/skill_buff/augment/D as anything in owner.fetch_buffs_of_type(buffpath, 0))
		if (D.id != id)
			continue
		D.remove()
		return


/obj/item/organ/internal/augment/boost/proc/debuff()
	if (!length(injury_debuffs))
		return FALSE
	for (var/datum/skill_buff/augment/D as anything in owner.fetch_buffs_of_type(buffpath, 0))
		if (D.id != id)
			continue
		D.recalculate(injury_debuffs)
		debuffing = TRUE
		return TRUE
	return FALSE


/obj/item/organ/internal/augment/boost/proc/buff()
	if (!length(buffs))
		return FALSE
	for (var/datum/skill_buff/augment/D as anything in owner.fetch_buffs_of_type(buffpath, 0))
		if (D.id != id)
			continue
		D.recalculate(buffs)
		debuffing = FALSE
		return TRUE
	return FALSE


/obj/item/organ/internal/augment/boost/Process()
	..()
	if (!owner)
		return
	if (!debuffing)
		if (is_broken())
			debuff()
	else if (!is_broken())
		buff()


/datum/skill_buff/augment
	var/id
