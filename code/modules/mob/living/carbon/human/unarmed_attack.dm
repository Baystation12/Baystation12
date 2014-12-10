//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user)
	if(user.restrained())
		return 0

	// Check if they have a functioning hand.
	var/datum/organ/external/E = user.organs_by_name["l_hand"]
	if(E && !(E.status & ORGAN_DESTROYED))
		return 1

	E = user.organs_by_name["r_hand"]
	if(E && !(E.status & ORGAN_DESTROYED))
		return 1

	return 0

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)

	var/stun_chance = rand(0, 100)

	// Reduce effective damage to normalize stun chance across species.
	attack_damage = min(1,attack_damage - damage)

	if(attack_damage >= 5 && armour < 2 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if("head", "mouth", "eyes")
				// Induce blurriness
				target.visible_message("<span class='danger'>[target] looks dazed.</span>", "<span class='danger'>You see stars.</span>")
				target.apply_effect(attack_damage*2, EYE_BLUR, armour)
			if("l_arm", "l_hand")
				if (target.l_hand)
					// Disarm left hand
					target.visible_message("<span class='danger'>[src] [pick("dropped", "let go off")] \the [target.l_hand][pick("", " with a scream")]!</span>")
					target.drop_l_hand()
			if("r_arm", "r_hand")
				if (target.r_hand)
					// Disarm right hand
					target.visible_message("<span class='danger'>[src] [pick("dropped", "let go off")] \the [target.r_hand][pick("", " with a scream")]!</span>")
					target.drop_r_hand()
			if("chest")
				if(!target.lying)
					target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
					var/turf/T = step(src, get_dir(get_turf(user), get_turf(target)))
					if(T.density) // This will need to be expanded to check for structures etc.
						target.visible_message("<span class='danger'>[target] slams into [T]!</span>")
					else
						target.loc = T
					target.apply_effect(attack_damage * 0.4, WEAKEN, armour)
			if("groin")
				target.visible_message("<span class='warning'>[target] looks like \he is in pain!</span>", "<span class='warning'>[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>")
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if("l_leg", "l_foot", "r_leg", "r_foot")
				if(!target.lying)
					target.visible_message("<span class='warning'>[src] gives way slightly.</span>")
					target.apply_effect(attack_damage*3, AGONY, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage) * 5 >= 100 && armour < 2) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message("<span class='danger'>[pick("slumps", "falls", "drops")] down to the ground!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been weakened!</span>")
		target.apply_effect(3, WEAKEN, armour)

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/datum/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] [pick(attack_verb)] [target] in the [affecting.display_name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/bite
	attack_verb = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0

/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user)
	if (user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return 0
	return 1

/datum/unarmed_attack/punch
	attack_verb = list("punched")
	attack_noun = list("fist")
	damage = 0

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/datum/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.display_name

	if(!skill)	skill = 1
	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [organ]!</span>")
		return 0

	if(!target.lying)
		switch(zone)
			if("head", "mouth", "eyes")
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)  user.visible_message("<span class='danger'>[user] slapped [target] across \his cheek!</span>")
					if(3 to 4)	user.visible_message("<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>")
					if(5)		user.visible_message("<span class='danger'>[user] gave [target] a resounding slap to the face!</span>")
			if("chest", "l_arm", "r_arm", "l_hand", "r_hand")
				// -- UPPER BODY -- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] slapped [target]'s [organ]!</span>")
					if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
					if(5)		user.visible_message("<span class='danger'>[user] slammed \his [pick(attack_noun)] into [target]'s [organ]!</span>")
			if("groin", "l_leg", "r_leg")
				// -- LOWER BODY -- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] gave [target] a light kick to the [organ]!</span>")
					if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick("kicked", "kneed")] [target] in \his [organ]!</span>")
					if(5)		user.visible_message("<span class='danger'>[user] landed a strong kick against [target]'s [organ]!</span>")
			if("l_foot", "r_foot")
				// ----- FEET ----- //
				switch(attack_damage)
					if(1 to 4)	user.visible_message("<span class='danger'>[user] kicked [target] in \his [organ]!</span>")
					if(5)		user.visible_message("<span class='danger'>[user] stomped down hard on [target]'s [organ]!</span>")
	else if (user.loc != target.loc)
		user.visible_message("<span class='danger'>[user] [pick("stomped down hard on", "kicked against", "gave a strong kick against", "slammed their foot into")] [target]'s [organ]!</span>")
	else
		user.visible_message("<span class='danger'>[user] [pick("punched", "threw a punch", "struck", "slapped", "rammed their [pick(attack_noun)] into")] [target]'s [organ]!</span>")


/datum/unarmed_attack/diona
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	damage = 5

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/datum/organ/external/affecting = target.get_organ(zone)

	if(!skill)	skill = 1
	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.display_name]!</span>")
		return 0

	switch(zone)
		if("head", "mouth", "eyes")
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target] across \his cheek!</span>")
				if(3 to 4) 	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick("head", "neck")] [pick("", "", "", "with spread [pick(attack_noun)]")]!</span>")
				if(5)		user.visible_message("<span class='danger'>[pick("[user] [pick(attack_verb)] [target] across \his face!", "[user] rakes \his [pick(attack_noun)] across [target]'s face!")]</span>")
		if("chest", "l_arm", "r_arm", "l_hand", "r_hand", "groin", "l_leg", "r_leg", "l_foot", "r_foot")
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target]'s [affecting.display_name]!</span>")
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.display_name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears \his [pick(attack_noun)] deep into [target]'s [affecting.display_name]!</span>")

/datum/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = 1

/datum/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15
	shredding = 1
