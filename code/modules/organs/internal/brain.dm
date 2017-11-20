/obj/item/organ/internal/brain
	name = "brain"
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
	relative_size = 60

	var/can_use_mmi = TRUE
	var/mob/living/carbon/brain/brainmob = null
	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1

/obj/item/organ/internal/brain/robotize()
	replace_self_with(/obj/item/organ/internal/posibrain)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/mmi_holder)

/obj/item/organ/internal/brain/getToxLoss()
	return 0

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

/obj/item/organ/internal/brain/New(var/mob/living/carbon/holder)
	..()
	max_damage = 200
	if(species)
		max_damage = species.total_health
	min_bruised_damage = max_damage*0.25
	min_broken_damage = max_damage*0.75

	damage_threshold_value = round(max_damage / damage_threshold_count)
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
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


/obj/item/organ/internal/brain/proc/get_current_damage_threshold()
	return round(damage / damage_threshold_value)

/obj/item/organ/internal/brain/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/brain/Process()

	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			spawn()
				alert(owner, "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")
			healed_threshold = 0

		if(damage < (max_damage / 4))
			healed_threshold = 1

		if(owner.paralysis < 1) // Skip it if we're already down.

			if((owner.disabilities & EPILEPSY) && prob(1))
				to_chat(owner, "<span class='warning'>You have a seizure!</span>")
				owner.visible_message("<span class='danger'>\The [owner] starts having a seizure!</span>")
				owner.Paralyse(10)
				owner.make_jittery(1000)
			else if((owner.disabilities & TOURETTES) && prob(10))
				owner.Stun(10)
				switch(rand(1, 3))
					if(1)
						owner.emote("twitch")
					if(2 to 3)
						owner.say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				owner.make_jittery(100)
			else if((owner.disabilities & NERVOUS) && prob(10))
				owner.stuttering = max(10, owner.stuttering)

			if(owner.stat == CONSCIOUS)
				if(damage > 0 && prob(1))
					owner.custom_pain("Your head feels numb and painful.",10)
				if(is_bruised() && prob(1) && owner.eye_blurry <= 0)
					to_chat(owner, "<span class='warning'>It becomes hard to see for some reason.</span>")
					owner.eye_blurry = 10
				if(is_broken() && prob(1) && owner.get_active_hand())
					to_chat(owner, "<span class='danger'>Your hand won't respond properly, and you drop what you are holding!</span>")
					owner.drop_item()
				if((damage >= (max_damage * 0.75)))
					if(!owner.lying)
						to_chat(owner, "<span class='danger'>You black out!</span>")
					owner.Paralyse(10)

		// Brain damage from low oxygenation or lack of blood.
		if(owner.should_have_organ(BP_HEART))

			// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
			var/blood_volume = owner.get_blood_oxygenation()

			if(owner.is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
				owner.Paralyse(3)
			var/can_heal = damage && (damage % damage_threshold_value || owner.chem_effects[CE_BRAIN_REGEN] || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))
			var/damprob
			//Effects of bloodloss
			switch(blood_volume)

				if(BLOOD_VOLUME_SAFE to INFINITY)
					if(can_heal && damage < max_damage)
						damage--
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(1))
						to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woozy","faint")]...</span>")
					damprob = owner.chem_effects[CE_STABLE] ? 30 : 60
					if(!past_damage_threshold(2) && prob(damprob))
						take_damage(1)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 40 : 80
					if(!past_damage_threshold(4) && prob(damprob))
						take_damage(1)
					if(!owner.paralysis && prob(10))
						owner.Paralyse(rand(1,3))
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 60 : 100
					if(!past_damage_threshold(6) && prob(damprob))
						take_damage(1)
					if(!owner.paralysis && prob(15))
						owner.Paralyse(3,5)
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
					owner.eye_blurry = max(owner.eye_blurry,6)
					damprob = owner.chem_effects[CE_STABLE] ? 80 : 100
					if(prob(damprob))
						take_damage(1)
	..()
