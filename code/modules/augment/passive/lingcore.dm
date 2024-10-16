/obj/item/organ/internal/augment/lingcore
	name = "bizarre mass"
	desc = "a twitching, pulsating mass that almost resembles a deformed embryo"
	icon_state = "lingcore"
	w_class = ITEM_SIZE_TINY
	augment_slots = AUGMENT_CHEST
	status = ORGAN_CONFIGURE
	augment_flags = AUGMENT_BIOLOGICAL
	var/ticks_remaining = 0;
	var/datum/mind/backup
	var/ownerckey
	var/default_language
	var/list/languages = list()

/obj/item/organ/internal/augment/lingcore/emp_act()
	..()
	return
/obj/item/organ/internal/augment/lingcore/getToxLoss()
	return 0
/obj/item/organ/internal/augment/lingcore/Process()
	..()
	if(istype(owner,/mob/living/carbon/human))
		var/mob/living/carbon/human/C = owner
		var/obj/item/organ/internal/brain/B = C.internal_organs_by_name[BP_BRAIN]
		if(B.germ_level != 0)
			B.germ_level = 0
/obj/item/organ/internal/augment/lingcore/onInstall()
	..()
	if(istype(owner,/mob/living/carbon) && (owner.mind) && (!owner.mind.changeling))
		overwrite()
		owner.make_changeling()
	if(owner.mind && owner.mind.changeling)
		do_backup()
/obj/item/organ/internal/augment/lingcore/onRemove()
	..()
	if(istype(owner,/mob/living/carbon) )
		owner.death(0)
		owner.Drain()
/obj/item/organ/internal/augment/lingcore/proc/do_backup()
	if(owner && owner.stat != DEAD && !is_broken() && owner.mind)
		languages = owner.languages.Copy()
		backup = owner.mind
		default_language = owner.default_language
		if(owner.ckey)
			ownerckey = owner.ckey
/obj/item/organ/internal/augment/lingcore/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		if(owner.mind == backup) // Oh, it's the same mind in the backup. Someone must've spammed the 'Start Procedure' button in a panic.
			return
		owner.visible_message(SPAN_DANGER("\The [owner] spasms and seizes!"))
		owner.ghostize()
	backup.active = 1
	backup.transfer_to(owner)
	if (default_language)
		owner.default_language = default_language
	owner.languages = languages.Copy()
	to_chat(owner, SPAN_NOTICE("Our tendrils extend throughout our new form, wrapping around nerve filaments. We awaken."))
