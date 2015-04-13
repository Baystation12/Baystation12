/mob/living/carbon/human/proc/create_stack()
	set waitfor=0
	sleep(10)
	internal_organs_by_name["stack"] = new /obj/item/organ/internal/stack(src,1)
	src << "<span class='notice'>You feel a faint sense of vertigo as your neural lace boots.</span>"

/obj/item/organ/internal/stack
	name = "neural lace"
	parent_organ = BP_HEAD
	icon_state = "brain-prosthetic"
	organ_tag = "stack"
	parent_organ = "head"
	status = ORGAN_ROBOT
	vital = 1

	var/invasive
	var/default_language
	var/list/languages = list()
	var/datum/mind/backup

/obj/item/organ/internal/stack/emp_act()
	return

/obj/item/organ/internal/stack/vox
	name = "cortical stack"
	invasive = 1

/obj/item/organ/internal/stack/proc/do_backup()
	if(owner && owner.stat != DEAD && !is_broken() && owner.mind)
		languages = owner.languages.Copy()
		backup = owner.mind
		default_language = owner.default_language

/obj/item/organ/internal/stack/process()
	do_backup()
	..()

/obj/item/organ/internal/stack/proc/backup_inviable()
	return 	(!istype(backup) || backup == owner.mind || (backup.current && backup.current.stat != DEAD))

/obj/item/organ/internal/stack/replaced()
	..()
	if(owner && backup_inviable())
		var/current_owner = owner
		var/response = input("Your neural backup has been placed into a new body. Do you wish to return to life?", "Resleeving") as anything in list("Yes", "No")
		if(src && response == "Yes" && owner == current_owner)
			overwrite()
	sleep(-1)
	do_backup()

/obj/item/organ/internal/stack/removed()
	if(invasive)
		var/obj/item/organ/external/head = owner.get_organ(parent_organ)
		owner.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [owner]'s [head.name] as it is torn loose!</span>")
		head.take_damage(rand(15,20))
		for(var/obj/item/organ/O in head.contents)
			O.take_damage(rand(30,70))
	..()

/obj/item/organ/internal/stack/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		owner.visible_message("<span class='danger'>\The [owner] spasms violently!</span>")
		if(prob(66))
			owner << "<span class='danger'>You fight off the invading tendrils of another mind, holding onto your own body!</span>"
			return
		owner.ghostize() // Remove the previous owner to avoid their client getting reset.
	owner.dna.real_name = backup.name
	owner.real_name = owner.dna.real_name
	owner.name = owner.real_name
	backup.active = 1
	backup.transfer_to(owner)
	if(default_language) owner.default_language = default_language
	owner.languages = languages.Copy()
	owner << "<span class='notice'>Consciousness slowly creeps over you as your new body awakens.</span>"
	do_backup()
