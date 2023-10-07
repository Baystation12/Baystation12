//Procedures in this file: internal organ surgery, removal, transplants
//////////////////////////////////////////////////////////////////
//						INTERNAL ORGANS							//
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal
	can_infect = 1
	blood_level = 1
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

//////////////////////////////////////////////////////////////////
//	Organ mending surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/fix_organ
	name = "Repair internal organ"
	allowed_tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = 100,
		/obj/item/stack/medical/bruise_pack = 40,
		/obj/item/tape_roll = 20
	)
	min_duration = 70
	max_duration = 90
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP

/singleton/surgery_step/internal/fix_organ/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		for(var/obj/item/organ/internal/I in affected.internal_organs)
			if(I.damage > 0)
				if(I.surface_accessible || (affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
					return affected

/singleton/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts treating damage within \the [target]'s [affected.name] with [tool_name].", \
	"You start treating damage within \the [target]'s [affected.name] with [tool_name]." )
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I) && (!(I.status & ORGAN_DEAD) || I.can_recover()) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
			"You start treating damage to [target]'s [I.name] with [tool_name]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",100,affecting = affected)
	playsound(target.loc, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			if(I.status & ORGAN_DEAD && I.can_recover())
				user.visible_message(SPAN_NOTICE("\The [user] treats damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further.") )
			else
				user.visible_message(SPAN_NOTICE("[user] treats damage to [target]'s [I.name] with [tool_name]."), \
				SPAN_NOTICE("You treat damage to [target]'s [I.name] with [tool_name].") )
			I.surgical_fix(user)
	user.visible_message("\The [user] finishes treating damage within \the [target]'s [affected.name] with [tool_name].", \
	"You finish treating damage within \the [target]'s [affected.name] with [tool_name]." )

/singleton/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"))
	var/dam_amt = 2
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)
	else
		dam_amt = 5
		target.adjustToxLoss(10)
		affected.take_external_damage(dam_amt, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			I.take_internal_damage(dam_amt)

//////////////////////////////////////////////////////////////////
//	 Organ detatchment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/detatch_organ
	name = "Detach organ"
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/material/shard = 50
	)
	min_duration = 90
	max_duration = 110
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/internal/detatch_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/attached_organs = list()
	for (var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if (I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Detach \the [I.name]"
			attached_organs[I.organ_tag] = radial_button
	if (!length(attached_organs))
		to_chat(user, SPAN_WARNING("You can't find any organs to separate."))
		return FALSE
	if (length(attached_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		return attached_organs[1]
	var/choice = show_radial_menu(user, tool, attached_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if (choice && user.use_sanity_check(target, tool))
		return choice
	return FALSE

/singleton/surgery_step/internal/detatch_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to separate [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].", \
	"You start to separate [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]." )
	target.custom_pain("Someone's ripping out your [LAZYACCESS(target.surgeries_in_progress, target_zone)]!",100)
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/detatch_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has separated [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].") , \
	SPAN_NOTICE("You have separated [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	if(I && istype(I))
		I.cut_away(user)

/singleton/surgery_step/internal/detatch_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(rand(30,50), 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ removal surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/remove_organ
	name = "Remove internal organ"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/material/knife = 75,
		/obj/item/swapper/jaws_of_life = 50,
		/obj/item/material/kitchen/utensil/fork = 20
	)
	min_duration = 60
	max_duration = 80

/singleton/surgery_step/internal/remove_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected)
		return FALSE
	var/list/removable_organs = list()
	for (var/obj/item/organ/internal/I in affected.implants)
		if (~I.status & ORGAN_CUT_AWAY)
			continue
		var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
		radial_button.name = "Remove \the [I.name]"
		removable_organs[I] = radial_button
	if (!length(removable_organs))
		to_chat(user, SPAN_WARNING("You can't find any removable organs."))
		return FALSE
	if (length(removable_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		return removable_organs[1]
	var/choice = show_radial_menu(user, tool, removable_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if (choice && user.use_sanity_check(target, tool))
		return choice
	return FALSE

/singleton/surgery_step/internal/remove_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	var/target_zone = user.zone_sel.selecting
	var/obj/item/organ/internal/O = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(BP_IS_ROBOTIC(O))
		if(BP_IS_ROBOTIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/singleton/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\The [user] starts removing [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].", \
	"You start removing \the [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is living hell!",100,affecting = affected)
	playsound(target.loc, 'sound/items/hemostat.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("\The [user] has removed \the [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]."), \
	SPAN_NOTICE("You have removed \the [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]."))

	// Extract the organ!
	var/obj/item/organ/O = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(O) && istype(affected))
		affected.implants -= O
		O.dropInto(target.loc)
		if(!BP_IS_ROBOTIC(affected))
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			playsound(target.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(istype(O, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/brain = O
		brain.transfer_and_delete()

	// Just in case somehow the organ we're extracting from an organic is an MMI
	if(istype(O, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/brain = O
		brain.transfer_and_delete()

/singleton/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(20, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ inserting surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/replace_organ
	name = "Replace internal organ"
	allowed_tools = list(
		/obj/item/organ/internal = 100
	)
	min_duration = 60
	max_duration = 80
	var/robotic_surgery = FALSE

/singleton/surgery_step/internal/replace_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	var/obj/item/organ/internal/O = tool
	var/obj/item/organ/external/affected = target.get_organ(user.zone_sel.selecting)
	if(BP_IS_ROBOTIC(O) || istype(O, /obj/item/organ/internal/augment))
		if(BP_IS_ROBOTIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/singleton/surgery_step/internal/replace_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/internal/O = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if ((O.status & ORGAN_CONFIGURE) && O.surgery_configure(user, target, affected, tool, src))
		return

	if(istype(O) && istype(affected))
		if(BP_IS_CRYSTAL(O) && !BP_IS_CRYSTAL(affected))
			to_chat(user, SPAN_WARNING("You cannot install a crystalline organ into a non-crystalline bodypart."))
		else if(!BP_IS_CRYSTAL(O) && BP_IS_CRYSTAL(affected))
			to_chat(user, SPAN_WARNING("You cannot install a non-crystalline organ into a crystalline bodypart."))
		else if(BP_IS_ROBOTIC(affected) && !BP_IS_ROBOTIC(O))
			to_chat(user, SPAN_WARNING("You cannot install a naked organ into a robotic body."))
		else if(!target.species)
			CRASH("Target ([target]) of surgery [type] has no species!")
		else
			var/o_is = (O.gender == PLURAL) ? "are" : "is"
			var/o_a =  (O.gender == PLURAL) ? "" : "a "
			if(O.organ_tag == BP_POSIBRAIN && !target.species.has_organ[BP_POSIBRAIN])
				to_chat(user, SPAN_WARNING("There's no place in [target] to fit \the [O.organ_tag]."))
			else if(O.damage > (O.max_damage * 0.75))
				to_chat(user, SPAN_WARNING("\The [O.name] [o_is] in no state to be transplanted."))
			else if(O.w_class > affected.cavity_max_w_class)
				to_chat(user, SPAN_WARNING("\The [O.name] [o_is] too big for [affected.cavity_name] cavity!"))
			else
				var/obj/item/organ/internal/I = target.internal_organs_by_name[O.organ_tag]
				if(I && (I.parent_organ == affected.organ_tag))
					to_chat(user, SPAN_WARNING("\The [target] already has [o_a][O.name]."))
				else
					. = TRUE

/singleton/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts [robotic_surgery ? "reinstalling" : "transplanting"] \the [tool] into [target]'s [affected.name].", \
	"You start [robotic_surgery ? "reinstalling" : "transplanting"] \the [tool] into [target]'s [affected.name].")
	target.custom_pain("Someone's rooting around in your [affected.name]!",100,affecting = affected)
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("\The [user] has [robotic_surgery ? "reinstalled" : "transplanted"] \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have [robotic_surgery ? "reinstalled" : "transplanted"] \the [tool] into [target]'s [affected.name]."))
	var/obj/item/organ/O = tool
	if(istype(O) && user.unEquip(O, target))
		affected.implants |= O //move the organ into the patient. The organ is properly reattached in the next step
		if(!(O.status & ORGAN_CUT_AWAY))
			log_debug("[user] ([user.ckey]) replaced organ [O], which didn't have ORGAN_CUT_AWAY set, in [target] ([target.ckey])")
			O.status |= ORGAN_CUT_AWAY

		playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)

/singleton/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [tool]!"))
	var/obj/item/organ/internal/I = tool
	if(istype(I))
		I.take_internal_damage(rand(3,5))

//////////////////////////////////////////////////////////////////
//	 Organ attachment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/attach_organ
	name = "Attach internal organ"
	allowed_tools = list(
		/obj/item/FixOVein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/tape_roll = 50
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/internal/attach_organ/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	var/target_zone = user.zone_sel.selecting
	var/obj/item/organ/internal/O = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(BP_IS_ROBOTIC(O))
		if(BP_IS_ROBOTIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/singleton/surgery_step/internal/attach_organ/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/list/attachable_organs
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.implants)
		if(I && (I.status & ORGAN_CUT_AWAY))
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Attach \the [I.name]"
			LAZYSET(attachable_organs, I, radial_button)

	if(!LAZYLEN(attachable_organs))
		return FALSE

	var/obj/item/organ/organ_to_replace
	if (length(attachable_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		organ_to_replace = attachable_organs[1]
	else
		organ_to_replace = show_radial_menu(user, tool, attachable_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))

	if(!organ_to_replace || !user.use_sanity_check(target, tool))
		return FALSE

	if(organ_to_replace.parent_organ != affected.organ_tag)
		to_chat(user, SPAN_WARNING("You can't find anywhere to attach \the [organ_to_replace] to!"))
		return FALSE

	if(istype(organ_to_replace, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/A = organ_to_replace
		if(!(A.augment_flags & AUGMENT_BIOLOGICAL))
			to_chat(user, SPAN_WARNING("\The [A] cannot function within a non-robotic limb."))
			return FALSE

	if(BP_IS_ROBOTIC(organ_to_replace) && target.species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
		user.visible_message(SPAN_NOTICE("[target]'s biology has rejected the attempts to attach \the [organ_to_replace]."))
		return FALSE

	var/obj/item/organ/internal/I = target.internal_organs_by_name[organ_to_replace.organ_tag]
	if(I && (I.parent_organ == affected.organ_tag))
		to_chat(user, SPAN_WARNING("\The [target] already has \a [organ_to_replace]."))
		return FALSE
	return organ_to_replace

/singleton/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].", \
	"You start reattaching [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].")
	target.custom_pain("Someone's digging needles into your [LAZYACCESS(target.surgeries_in_progress, target_zone)]!",100)
	playsound(target.loc, 'sound/items/fixovein.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/I = LAZYACCESS(target.surgeries_in_progress, target_zone)

	user.visible_message(SPAN_NOTICE("[user] has reattached [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].") , \
	SPAN_NOTICE("You have reattached [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]."))

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(I) && I.parent_organ == target_zone && affected && (I in affected.implants))
		I.status &= ~ORGAN_CUT_AWAY //apply fixovein
		affected.implants -= I
		I.replaced(target, affected)

	if(istype(I, /obj/item/organ/internal/eyes))
		var/obj/item/organ/internal/eyes/E = I
		if(!E.is_broken())
			I.owner.eye_blind = 0
			target.disabilities &= ~BLINDED
		if(!E.is_bruised())
			I.owner.eye_blurry = 0

/singleton/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(20, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Peridaxon necrosis treatment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/internal/treat_necrosis
	name = "Treat necrosis"
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 75,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 50,
		/obj/item/reagent_containers/glass/bucket = 50,
	)

	can_infect = 0
	blood_level = 0

	min_duration = 50
	max_duration = 60

/singleton/surgery_step/internal/treat_necrosis/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/reagent_containers/container = tool
	if(!istype(container) || !container.reagents.has_reagent(/datum/reagent/peridaxon) || !..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/list/obj/item/organ/internal/dead_organs = list()
	for(var/obj/item/organ/internal/I in target.internal_organs)
		if(I && !(I.status & ORGAN_CUT_AWAY) && (I.status & ORGAN_DEAD) && I.parent_organ == affected.organ_tag && !BP_IS_ROBOTIC(I))
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Regenerate \the [I.name]"
			LAZYSET(dead_organs, I, radial_button)
	if(!length(dead_organs))
		return FALSE
	if (length(dead_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		return dead_organs[1]
	var/obj/item/organ/internal/organ_to_fix = show_radial_menu(user, tool, dead_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if(!organ_to_fix || !user.use_sanity_check(target, tool))
		return FALSE
	if(!organ_to_fix.can_recover())
		to_chat(user, SPAN_WARNING("The [organ_to_fix.name] is necrotic and can't be saved, it will need to be replaced."))
		return FALSE
	if(organ_to_fix.damage >= organ_to_fix.max_damage)
		to_chat(user, SPAN_WARNING("The [organ_to_fix.name] needs to be repaired before it is regenerated."))
		return FALSE
	return organ_to_fix

/singleton/surgery_step/internal/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts applying medication to the affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]." , \
	"You start applying medication to the affected tissue in [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].")
	target.custom_pain("Something in your [LAZYACCESS(target.surgeries_in_progress, target_zone)] is causing you a lot of pain!",50, affecting = LAZYACCESS(target.surgeries_in_progress, target_zone))
	playsound(target.loc, 'sound/items/fixovein.ogg', 50, TRUE)
	..()

/singleton/surgery_step/internal/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/affected = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/reagent_containers/container = tool

	var/amount = container.amount_per_transfer_from_this
	var/datum/reagents/temp_reagents = new(amount, GLOB.temp_reagents_holder)
	container.reagents.trans_to_holder(temp_reagents, amount)

	var/rejuvenate = temp_reagents.has_reagent(/datum/reagent/peridaxon)

	var/trans = temp_reagents.trans_to_mob(target, temp_reagents.total_volume, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)

		if(rejuvenate)
			affected.status &= ~ORGAN_DEAD
			affected.owner.update_body(1)

		user.visible_message("[SPAN_NOTICE("[user] applies [trans] unit\s of the solution to affected tissue in [target]'s [affected.name]")].", \
			SPAN_NOTICE("You apply [trans] unit\s of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."))
	qdel(temp_reagents)

/singleton/surgery_step/internal/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!") , \
	SPAN_WARNING("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"))

	//no damage or anything, just wastes medicine
