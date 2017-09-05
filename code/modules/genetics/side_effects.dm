/datum/genetics/side_effect
	var/name // name of the side effect, to use as a header in the manual
	var/symptom // description of the symptom of the side effect
	var/treatment // description of the treatment of the side effect
	var/effect // description of what happens when not treated
	var/duration = 0 // delay between start() and finish()

	proc/start(mob/living/carbon/human/H)
		// start the side effect, this should give some cue as to what's happening,
		// such as gasping. These cues need to be unique among side-effects.

	proc/finish(mob/living/carbon/human/H)
		// Finish the side-effect. This should first check whether the cure has been
		// applied, and if not, cause bad things to happen.

/datum/genetics/side_effect/genetic_burn
	name = "Genetic Burn"
	symptom = "Subject's skin turns unusualy red."
	treatment = "Inject small dose of dexalin."
	effect = "Subject's skin burns."
	duration = 10*30

	start(mob/living/carbon/human/H)
		H.visible_message("<B>\The [H]</B> starts turning very red...")

	finish(mob/living/carbon/human/H)
		if(!H.reagents.has_reagent(/datum/reagent/dexalin))
			for(var/organ_name in BP_ALL_LIMBS)
				var/obj/item/organ/external/E = H.get_organ(organ_name)
				E.take_damage(0, 5, 0)

/datum/genetics/side_effect/bone_snap
	name = "Bone Snap"
	symptom = "Subject's limbs tremble notably."
	treatment = "Inject small dose of bicaridine."
	effect = "Subject's bone breaks."
	duration = 10*60

	start(mob/living/carbon/human/H)
		H.visible_message("<B>\The [H]</B>'s limbs start shivering uncontrollably.")

	finish(mob/living/carbon/human/H)
		if(!H.reagents.has_reagent(/datum/reagent/bicaridine))
			var/organ_name = pick(BP_ALL_LIMBS)
			var/obj/item/organ/external/E = H.get_organ(organ_name)
			E.take_damage(20, 0, 0)
			E.fracture()

/datum/genetics/side_effect/confuse
	name = "Confuse"
	symptom = "Subject starts drooling uncontrollably."
	treatment = "Inject small dose of dylovene."
	effect = "Subject becomes confused."
	duration = 10*30

	start(mob/living/carbon/human/H)
		H.visible_message("<B>\The [H]</B> drools.")

	finish(mob/living/carbon/human/H)
		if(!H.reagents.has_reagent(/datum/reagent/dylovene))
			H.confused += 100

proc/trigger_side_effect(mob/living/carbon/human/H)
	spawn
		if(!istype(H)) return
		var/tp = pick(typesof(/datum/genetics/side_effect) - /datum/genetics/side_effect)
		var/datum/genetics/side_effect/S = new tp

		S.start(H)
		spawn(20)
			if(!istype(H)) return
			H.Weaken(rand(0, S.duration / 50))
		sleep(S.duration)

		if(!istype(H)) return
		H.SetWeakened(0)
		S.finish(H)
