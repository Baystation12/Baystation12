/mob/living/carbon/human/proc/create_stack()
	internal_organs_by_name[BP_STACK] = new /obj/item/organ/internal/stack(src,1)
	to_chat(src, "<span class='notice'>You feel a faint sense of vertigo as your neural lace boots.</span>")

/obj/item/organ/internal/stack
	name = "neural lace"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	status = ORGAN_ROBOTIC
	vital = 1
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	relative_size = 10

	var/ownerckey
	var/invasive
	var/default_language
	var/list/languages = list()
	var/datum/mind/backup
	var/prompting = FALSE // Are we waiting for a user prompt?

/obj/item/organ/internal/stack/examine(var/mob/user)
	. = ..(user)
	if(istype(backup)) // Do we have a backup?
		if(user.skill_check(SKILL_DEVICES, SKILL_EXPERT)) // Can we even tell what the blinking means?
			if(find_dead_player(ownerckey, 1)) // Is the player still around and dead?
				to_chat(user, "<span class='notice'>The light on [src] is blinking rapidly. Someone might have a second chance.</span>")
			else
				to_chat(user, "The light on [src] is blinking slowly. Maybe wait a while...")
		else
			to_chat(user, "The light on [src] is blinking, but you don't know what it means.")
	else
		to_chat(user, "The light on [src] is off. " + (user.skill_check(SKILL_DEVICES, SKILL_EXPERT) ? "It doesn't have a backup." : "Wonder what that means."))

/obj/item/organ/internal/stack/emp_act()
	return

/obj/item/organ/internal/stack/getToxLoss()
	return 0

/obj/item/organ/internal/stack/proc/do_backup()
	if(owner && owner.stat != DEAD && !is_broken() && owner.mind)
		languages = owner.languages.Copy()
		backup = owner.mind
		default_language = owner.default_language
		if(owner.ckey)
			ownerckey = owner.ckey

/obj/item/organ/internal/stack/New()
	..()
	do_backup()
	robotize()

/obj/item/organ/internal/stack/proc/backup_inviable()
	return 	(!istype(backup) || backup == owner.mind || (backup.current && backup.current.stat != DEAD))

/obj/item/organ/internal/stack/replaced()
	if(!..()) return 0
	if(prompting) // Don't spam the player with twenty dialogs because someone doesn't know what they're doing or panicking.
		return 0
	if(owner && !backup_inviable())
		var/current_owner = owner
		prompting = TRUE
		var/response = alert(find_dead_player(ownerckey, 1), "Your neural backup has been placed into a new body. Do you wish to return to life as the mind of [backup.name]?", "Resleeving", "Yes", "No")
		prompting = FALSE
		if(src && response == "Yes" && owner == current_owner)
			overwrite()
	sleep(-1)
	do_backup()

	return 1

/obj/item/organ/internal/stack/removed()
	do_backup()
	..()

/obj/item/organ/internal/stack/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		if(owner.mind == backup) // Oh, it's the same mind in the backup. Someone must've spammed the 'Start Procedure' button in a panic.
			return
		owner.visible_message("<span class='danger'>\The [owner] spasms violently!</span>")
		if(prob(66))
			to_chat(owner, "<span class='danger'>You fight off the invading tendrils of another mind, holding onto your own body!</span>")
			return
		owner.ghostize() // Remove the previous owner to avoid their client getting reset.
	//owner.dna.real_name = backup.name
	//owner.real_name = owner.dna.real_name
	//owner.SetName(owner.real_name)
	//The above three lines were commented out for
	backup.active = 1
	backup.transfer_to(owner)
	if(default_language) owner.default_language = default_language
	owner.languages = languages.Copy()
	to_chat(owner, "<span class='notice'>Consciousness slowly creeps over you as your new body awakens.</span>")
