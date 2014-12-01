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
			if("head")
				// Induce blurriness
				target.visible_message("<span class='danger'>[target] stares blankly for a few moments.</span>", "<span class='danger'>You see stars.</span>")
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
					target.visible_message("<span class='danger'>[pick("[target] was sent flying backward a few metres!", "[target] staggers back from the impact!")]</span>")
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
	attack_verb = list("bite") // 'x has biteed y', needs work.
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 3
	sharp = 0
	edge = 0

/datum/unarmed_attack/bite/eye_tooth
	attack_verb = list("bite") // 'x has biteed y', needs work.
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
	attack_verb = list("punch")
	attack_noun = list("fist")
	damage = 3

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/datum/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.display_name

	if(!skill)	skill = 1

	if(target == user)
		user.visible_message("\red <B>[user] [pick(attack_verb)]ed \himself in the [organ]!</B>")
		return 0

	if(!target.lying)
		switch(zone)
			if("head")
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)  user.visible_message("\red <B>[user] slapped [target] across \his cheek!</B>")
					if(3 to 4)	user.visible_message("\red <B>[user] struck [target] in the head[pick("", " with a closed fist")]!</B>")
					if(5)		user.visible_message("\red <B>[user] gave [target] a resounding slap to the face!</B>")
			if("chest", "l_arm", "r_arm", "l_hand", "r_hand")
				// -- UPPER BODY -- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("\red <B>[user] slapped [target]'s [organ]!</B>")
					if(3 to 4)	user.visible_message("\red <B>[user] [findtext(zone, "hand")?"[pick(attack_verb)]ed":pick("[pick(attack_verb)]ed", "shoulders")] [target] in \his [organ]!</B>")
					if(5)		user.visible_message("\red <B>[user] rammed \his [pick(attack_noun)] into [target]'s [organ]!</B>")
			if("groin", "l_leg", "r_leg")
				// -- LOWER BODY -- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("\red <B>[user] gave [target] a light kick to the [organ]!</B>")
					if(3 to 4)	user.visible_message("\red <B>[user] [pick("kicked", "kneed")] [target] in \his [organ]!</B>")
					if(5)		user.visible_message("\red <B>[user] landed a strong kick against [target]'s [organ]!</B>")
			if("l_foot", "r_foot")
				// ----- FEET ----- //
				switch(attack_damage)
					if(1 to 4)	user.visible_message("\red <B>[user] kicked [target] in \his [organ]!</B>")
					if(5)		user.visible_message("\red <B>[user] stomped down hard on [target]'s [organ]!")
	else if (user.loc != target.loc)
		user.visible_message("\red <B>[user] [pick("stomped down hard on", "kicked against", "gave a strong kick against", "rams their foot into")] [target]'s [organ]!</B>")
	else
		user.visible_message("\red <B>[user] [pick("punched", "threw a punch", "struck", "slapped", "rammed their [pick(attack_noun)] into")] [target]'s [organ]!</B>")


/datum/unarmed_attack/diona
	attack_verb = list("lash", "bludgeon")
	attack_noun = list("tendril")
	damage = 5

/datum/unarmed_attack/claws
	attack_verb = list("scratch", "claw", "goug")
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
		user.visible_message("\red <B>[user] [pick(attack_verb)]ed \himself in the [affecting.display_name]!</B>")
		return 0

	switch(zone)
		if("head")
			// ----- HEAD ----- //
			switch(damage)
				if(1 to 2)	user.visible_message("\red <B>[user] scratched [target] across \his cheek!</B>")
				if(3 to 4) 	user.visible_message("\red <B>[user] [pick(attack_verb)]ed [pick("", "the side of")][target] [pick("head", "neck")][pick("", " with spread [pick(attack_noun)]")]!</B>")
				if(5)		user.visible_message("\red <B>[user] [pick(attack_verb)]ed [target] across \his face!</B>")
		if("chest", "l_arm", "r_arm", "l_hand", "r_hand", "groin", "l_leg", "r_leg", "l_foot", "r_foot")
			// ----- BODY ----- //
			switch(damage)
				if(1 to 2)	user.visible_message("\red <B>[user] scratched [target]'s [affecting.display_name]!</B>")
				if(3 to 4)	user.visible_message("\red <B>[user] [pick(attack_verb)]ed [pick("", "the side of")][target]'s [affecting.display_name]!</B>")
				if(5)		user.visible_message("\red <B>[user] digs \his [pick(attack_noun)] deep into [target]'s [affecting.display_name]!</B>")

/datum/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = 1

/datum/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15
	shredding = 1