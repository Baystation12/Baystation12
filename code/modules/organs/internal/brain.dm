/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null

/obj/item/organ/internal/brain/robotize()
	replace_self_with(/obj/item/organ/internal/mmi_holder/posibrain)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/mmi_holder)

/obj/item/organ/internal/brain/proc/replace_self_with(replace_path)
	var/mob/living/carbon/human/tmp_owner = owner
	qdel(src)
	if(tmp_owner)
		tmp_owner.internal_organs_by_name[organ_tag] = new replace_path(tmp_owner, 1)
		tmp_owner = null

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/internal/brain/robotize()
	. = ..()
	icon_state = "brain-prosthetic"

/obj/item/organ/internal/brain/New()
	..()
	health = config.default_brain_health
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	qdel_null(brainmob)
	. = ..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)

	if(!brainmob)
		brainmob = new(src)
		brainmob.name = H.real_name
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.timeofhostdeath = H.timeofdeath

	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user) // -- TLE
	. = ..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/brain/removed(var/mob/living/user)
	if(!istype(owner))
		return ..()

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(!..()) return 0

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key

	return 1

/obj/item/organ/internal/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"

/obj/item/organ/internal/brain/process()
	if(!owner || !owner.should_have_organ(BP_HEART))
		return

	// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
	var/blood_volume = owner.get_effective_blood_volume()
	if(!owner.internal_organs_by_name[BP_HEART])
		if(blood_volume > BLOOD_VOLUME_SURVIVE)
			blood_volume = BLOOD_VOLUME_SURVIVE
		owner.Paralyse(3)

	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(prob(1))
				to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woosey","faint")]</span>")
			if(owner.getOxyLoss() < 20)
				owner.adjustOxyLoss(3)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			owner.eye_blurry = max(owner.eye_blurry,6)
			if(owner.getOxyLoss() < 50)
				owner.adjustOxyLoss(10)
			owner.adjustOxyLoss(1)
			if(prob(15))
				owner.Paralyse(rand(1,3))
				to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woosey","faint")]</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			owner.adjustOxyLoss(5)
			if(owner.getToxLoss() < 15)
				owner.adjustToxLoss(3)
			if(prob(15))
				owner.Paralyse(3,5)
				to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woosey","faint")]</span>")
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
			owner.setOxyLoss(max(owner.getOxyLoss(), owner.maxHealth+10))
