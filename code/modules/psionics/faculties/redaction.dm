/decl/psionic_faculty/redaction
	id = PSI_REDACTION
	name = "Redaction"
	associated_intent = I_HELP
	armour_types = list("bio", "rad")

/decl/psionic_power/redaction
	faculty = PSI_REDACTION
	admin_log = FALSE

/decl/psionic_power/redaction/proc/check_dead(var/mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD || (target.status_flags & FAKEDEATH))
		return TRUE
	return FALSE

/decl/psionic_power/redaction/invoke(var/mob/living/user, var/mob/living/target)
	if(check_dead(target))
		return FALSE
	. = ..()

/decl/psionic_power/redaction/skinsight
	name =            "Skinsight"
	cost =            3
	cooldown =        30
	use_grab =        TRUE
	min_rank =        PSI_RANK_OPERANT
	suppress_parent_proc = TRUE
	use_description = "Grab a patient, target the chest, then switch to help intent and use the grab on them to perform a check for wounds and damage."

/decl/psionic_power/redaction/skinsight/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_CHEST)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_NOTICE("\The [user] rests a hand on \the [target]."))
		to_chat(user, medical_scan_results(target, TRUE, SKILL_MAX))
		return TRUE

/decl/psionic_power/redaction/mend
	name =            "Mend"
	cost =            7
	cooldown =        50
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	suppress_parent_proc = TRUE
	use_description = "Target a patient while on help intent at melee range to mend a variety of maladies, such as bleeding or broken bones. Higher ranks in this faculty allow you to mend a wider range of problems."

/decl/psionic_power/redaction/mend/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(user) || !istype(target))
		return FALSE
	. = ..()
	if(.)
		var/obj/item/organ/external/E = target.get_organ(user.zone_sel.selecting)

		if(!E)
			to_chat(user, SPAN_WARNING("They are missing that limb."))
			return FALSE

		if(BP_IS_ROBOTIC(E))
			to_chat(user, SPAN_WARNING("That limb is prosthetic."))
			return FALSE

		user.visible_message(SPAN_NOTICE("<i>\The [user] rests a hand on \the [target]'s [E.name]...</i>"))
		to_chat(target, SPAN_NOTICE("A healing warmth suffuses you."))

		var/redaction_rank = user.psi.get_rank(PSI_REDACTION)
		var/pk_rank = user.psi.get_rank(PSI_PSYCHOKINESIS)
		if(pk_rank >= PSI_RANK_LATENT && redaction_rank >= PSI_RANK_MASTER)
			var/removal_size = clamp(5-pk_rank, 0, 5)
			var/valid_objects = list()
			for(var/thing in E.implants)
				var/obj/imp = thing

				if(!imp)
					continue

				if(imp.w_class >= removal_size && !istype(imp, /obj/item/implant))
					valid_objects += imp
			if(LAZYLEN(valid_objects))
				var/removing = pick(valid_objects)
				target.remove_implant(removing, TRUE)
				to_chat(user, SPAN_NOTICE("You extend a tendril of psychokinetic-redactive power and carefully tease \the [removing] free of \the [E]."))
				return TRUE

		if(redaction_rank >= PSI_RANK_MASTER)
			if(E.status & ORGAN_ARTERY_CUT)
				to_chat(user, SPAN_NOTICE("You painstakingly mend the torn veins in \the [E], stemming the internal bleeding."))
				E.status &= ~ORGAN_ARTERY_CUT
				return TRUE
			if(E.status & ORGAN_TENDON_CUT)
				to_chat(user, SPAN_NOTICE("You interleave and repair the severed tendon in \the [E]."))
				E.status &= ~ORGAN_TENDON_CUT
				return TRUE

		if(E.is_stump())
			to_chat(user, SPAN_WARNING("There's nothing left to heal in this stump"))
			return FALSE

		if(E.status & ORGAN_BROKEN)
			to_chat(user, SPAN_NOTICE("You coax shattered bones to come together and fuse, mending the break."))
			E.status &= ~ORGAN_BROKEN
			E.stage = 0
			return TRUE

		for(var/datum/wound/W in E.wounds)
			if(W.bleeding())
				if(redaction_rank >= PSI_RANK_OPERANT || W.wound_damage() < 30)
					to_chat(user, SPAN_NOTICE("You knit together severed veins and broken flesh, stemming the bleeding."))
					W.bleed_timer = 0
					W.clamped = TRUE
					E.status &= ~ORGAN_BLEEDING
					return TRUE
				else
					to_chat(user, SPAN_NOTICE("This [W.desc] is beyond your power to heal."))

		if(redaction_rank >= PSI_RANK_GRANDMASTER)
			for(var/obj/item/organ/internal/I in E.internal_organs)
				if(!BP_IS_ROBOTIC(I) && !BP_IS_CRYSTAL(I) && I.damage > 0)
					to_chat(user, SPAN_NOTICE("You encourage the damaged tissue of \the [I] to repair itself."))
					var/heal_rate = redaction_rank
					I.damage = max(0, I.damage - rand(heal_rate,heal_rate*2))
					return TRUE

		to_chat(user, SPAN_NOTICE("You can find nothing within \the [target]'s [E.name] to mend."))
		return FALSE

/decl/psionic_power/redaction/cleanse
	name =            "Cleanse"
	cost =            9
	cooldown =        60
	use_melee =       TRUE
	min_rank =        PSI_RANK_GRANDMASTER
	suppress_parent_proc = TRUE
	use_description = "Target a patient while on help intent at melee range to cleanse radiation and genetic damage from a patient."

/decl/psionic_power/redaction/cleanse/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(user) || !istype(target))
		return FALSE
	. = ..()
	if(.)
		// No messages, as Mend procs them even if it fails to heal anything, and Cleanse is always checked after Mend.
		var/removing = rand(20,25)
		if(target.radiation)
			to_chat(user, SPAN_NOTICE("You repair some of the radiation-damaged tissue within \the [target]..."))
			if(target.radiation > removing)
				target.radiation -= removing
			else
				target.radiation = 0
			return TRUE
		if(target.getCloneLoss())
			to_chat(user, SPAN_NOTICE("You stitch together some of the mangled DNA within \the [target]..."))
			if(target.getCloneLoss() >= removing)
				target.adjustCloneLoss(-removing)
			else
				target.adjustCloneLoss(-(target.getCloneLoss()))
			return TRUE
		to_chat(user, SPAN_NOTICE("You can find no genetic damage or radiation to heal within \the [target]."))
		return FALSE

/decl/psionic_power/revive
	name =            "Revive"
	cost =            25
	cooldown =        80
	use_grab =        TRUE
	min_rank =        PSI_RANK_PARAMOUNT
	faculty =         PSI_REDACTION
	use_description = "Obtain a grab on a dead target, target the head, then select help intent and use the grab against them to attempt to bring them back to life. The process is lengthy and failure is punished harshly."
	admin_log = FALSE

/decl/psionic_power/revive/invoke(var/mob/living/user, var/mob/living/target)
	if(!isliving(target) || !istype(target) || user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(.)
		if(target.stat != DEAD && !(target.status_flags & FAKEDEATH))
			to_chat(user, SPAN_WARNING("This person is already alive!"))
			return TRUE

		if((world.time - target.timeofdeath) > 6000)
			to_chat(user, SPAN_WARNING("\The [target] has been dead for too long to revive."))
			return TRUE

		user.visible_message(SPAN_NOTICE("<i>\The [user] splays out their hands over \the [target]'s body...</i>"))
		if(!do_after(user, 100, target))
			user.psi.backblast(rand(10,25))
			return TRUE

		for(var/mob/observer/G in GLOB.dead_mob_list_)
			if(G.mind && G.mind.current == target && G.client)
				to_chat(G, SPAN_NOTICE("<font size = 3><b>Your body has been revived, <b>Re-Enter Corpse</b> to return to it.</b></font>"))
				break
		to_chat(target, SPAN_NOTICE("<font size = 3><b>Life floods back into your body!</b></font>"))
		target.visible_message(SPAN_NOTICE("\The [target] shudders violently!"))
		target.adjustOxyLoss(-rand(15,20))
		target.basic_revival()
		return TRUE
