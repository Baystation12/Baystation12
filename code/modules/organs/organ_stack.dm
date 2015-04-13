#define STACK_TICK_TIME 6000 // Ten minutes.

/obj/item/organ/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	organ_tag = "stack"
	parent_organ = "head"
	robotic = 2
	status = ORGAN_ROBOT
	var/backup_key
	var/backup_time = 0
	var/datum/mind/backup

/obj/item/organ/stack/process()

	if(world.time < (backup_time + STACK_TICK_TIME))
		return

	if(owner && owner.stat != 2 && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind
		if(owner.ckey) backup_key = owner.ckey

/obj/item/organ/stack/replaced()

	..()

	if(!backup || !backup_key || !owner)
		return

	var/datum/mind/clonemind
	clonemind = locate(backup)

	if(!istype(clonemind) || (clonemind.current && clonemind.current.stat != DEAD))
		return 0

	if(clonemind.active)
		for(var/mob/dead/observer/G in player_list)
			if(G.ckey == backup_key)
				if(G.can_reenter_corpse)
					break
				else
					return 0

	if(owner.mind && owner.ckey) //Someone is already in this body!
		owner.visible_message("<span class='danger'>\The [owner] spasms violently!</span>")
		if(prob(66))
			owner << "<span class='danger'>You fight off the invading tendrils of another mind, holding onto your own body!</span>"
			process() //Overwrite the stored mind on the stack.
			return

	owner.dna.real_name = clonemind.name
	owner.real_name = owner.dna.real_name
	owner.name = owner.real_name
	clonemind.transfer_to(owner)
	owner.ckey = backup_key
	owner << "<span class='notice'>Consciousness slowly creeps over you as your new body begins to awaken.</span>"

/obj/item/organ/stack/vox
	name = "alien cortical stack"

/obj/item/organ/stack/vox/removed()

	var/mob/living/carbon/human/H = owner
	..()
	if(H)
		var/obj/item/organ/external/head = H.get_organ("head")
		if(!head) //???
			return
		H.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [H]'s brain and flesh as it is torn loose!</span>")
		head.take_damage(rand(60,80))
		for(var/obj/item/organ/O in head.contents)
			O.take_damage(rand(20,30))