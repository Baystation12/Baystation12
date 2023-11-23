//Procedures in this file: Robotic surgery steps, organ removal, replacement. MMI insertion, synthetic organ repair, robone repair
//////////////////////////////////////////////////////////////////
//						ROBOTIC SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic robotic surgery step datum
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics
	can_infect = 0
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP

/singleton/surgery_step/robotics/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC

/singleton/surgery_step/robotics/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && !(affected.status & ORGAN_CUT_AWAY))
		return affected

/singleton/surgery_step/robotics/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(!user.skill_check(SKILL_DEVICES, SKILL_TRAINED))
		. -= 30
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 20
	if(user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. += 35
	if(user.skill_check(SKILL_DEVICES, SKILL_MASTER))
		. += 30

//////////////////////////////////////////////////////////////////
//	 unscrew robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/unscrew_hatch
	name = "Unscrew maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 60,
		/obj/item/swapper/power_drill = 100,
		/obj/item/material/coin = 30,
		/obj/item/material/knife = 40
	)
	min_duration = 50
	max_duration = 90

/singleton/surgery_step/robotics/unscrew_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_CLOSED)
		return affected

/singleton/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	playsound(target.loc, 'sound/items/Screwdriver.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has opened the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool]."),)
	affected.hatch_state = HATCH_UNSCREWED

/singleton/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("\The [user]'s [tool.name] slips, failing to unscrew \the [target]'s [affected.name]."), \
	SPAN_WARNING("Your [tool.name] slips, failing to unscrew [target]'s [affected.name]."))

//////////////////////////////////////////////////////////////////
//	 screw robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/screw_hatch
	name = "Secure maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 60,
		/obj/item/swapper/power_drill = 100,
		/obj/item/material/coin = 30,
		/obj/item/material/knife = 40
	)
	min_duration = 50
	max_duration = 90

/singleton/surgery_step/robotics/screw_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_UNSCREWED)
		return affected

/singleton/surgery_step/robotics/screw_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to screw down the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to screw down the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	playsound(target.loc, 'sound/items/Screwdriver.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/screw_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has screwed down the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You have screwed down the maintenance hatch on [target]'s [affected.name] with \the [tool]."),)
	affected.hatch_state = HATCH_CLOSED

/singleton/surgery_step/robotics/screw_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to screw down [target]'s [affected.name]."), \
	SPAN_WARNING("Your [tool] slips, failing to screw down [target]'s [affected.name]."))

//////////////////////////////////////////////////////////////////
//	open robotic limb surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/open_hatch
	name = "Open maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 40,
		/obj/item/crowbar = 60,
		/obj/item/swapper/jaws_of_life = 80,
		/obj/item/material/kitchen/utensil = 30
	)

	min_duration = 30
	max_duration = 40

/singleton/surgery_step/robotics/open_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_UNSCREWED)
		return affected

/singleton/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
	"You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	playsound(target.loc, 'sound/items/Crowbar.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You open the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	affected.hatch_state = HATCH_OPENED

/singleton/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool] slips, failing to open the hatch on [target]'s [affected.name]."))

//////////////////////////////////////////////////////////////////
//	close robotic limb surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/close_hatch
	name = "Close maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 40,
		/obj/item/crowbar = 60,
		/obj/item/swapper/jaws_of_life = 80,
		/obj/item/material/kitchen/utensil = 30
	)

	min_duration = 70
	max_duration = 100

/singleton/surgery_step/robotics/close_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED)
		return affected

/singleton/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to close the hatch on [target]'s [affected.name] with \the [tool]." , \
	"You begin to close the hatch on [target]'s [affected.name] with \the [tool].")
	playsound(target.loc, 'sound/items/Crowbar.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] closes the hatch on [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You close the hatch on [target]'s [affected.name] with \the [tool]."))
	affected.hatch_state = HATCH_UNSCREWED
	affected.germ_level = 0

/singleton/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."))

//////////////////////////////////////////////////////////////////
//	robotic limb brute damage repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_brute
	name = "Repair damage to prosthetic"
	allowed_tools = list(
		/obj/item/weldingtool = 35,
		/obj/item/weldingtool/electric = 50,
		/obj/item/gun/energy/plasmacutter = 25,
		/obj/item/psychic_power/psiblade/master = 100
	)

	min_duration = 70
	max_duration = 90

/singleton/surgery_step/robotics/repair_brute/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_BASIC))
		. += 5
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 10

/singleton/surgery_step/robotics/repair_brute/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(!affected.brute_dam)
			to_chat(user, SPAN_WARNING("There is no damage to repair."))
			return FALSE
		if(BP_IS_BRITTLE(affected))
			to_chat(user, SPAN_WARNING("\The [target]'s [affected.name] is too brittle to be repaired normally."))
			return FALSE
		if(isWelder(tool))
			var/obj/item/weldingtool/welder = tool
			if(!welder.remove_fuel(1,user))
				return FALSE
		if(istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = tool
			if(!cutter.slice(user))
				return FALSE
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/repair_brute/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && ((affected.status & ORGAN_DISFIGURED) || affected.brute_dam > 0))
		return affected

/singleton/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
	"You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool].")
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] finishes patching damage to [target]'s [affected.name] with \the [tool]."), \
	SPAN_NOTICE("You finish patching damage to [target]'s [affected.name] with \the [tool]."))
	affected.heal_damage(rand(30,50),0,1,1)
	affected.status &= ~ORGAN_DISFIGURED

/singleton/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."),
	SPAN_WARNING("Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."))
	target.apply_damage(rand(5,10), DAMAGE_BURN, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb brittleness repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_brittle
	name = "Reinforce prosthetic"
	allowed_tools = list(/obj/item/stack/nanopaste = 50)
	min_duration = 50
	max_duration = 60

/singleton/surgery_step/robotics/repair_brittle/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
		. += 10
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 15

/singleton/surgery_step/robotics/repair_brittle/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && BP_IS_BRITTLE(affected) && affected.hatch_state == HATCH_OPENED)
		return affected

/singleton/surgery_step/robotics/repair_brittle/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to repair the brittle metal inside \the [target]'s [affected.name]." , \
	"You begin to repair the brittle metal inside \the [target]'s [affected.name].")
	playsound(target.loc, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/repair_brittle/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] finishes repairing the brittle interior of \the [target]'s [affected.name]."), \
	SPAN_NOTICE("You finish repairing the brittle interior of \the [target]'s [affected.name]."))
	affected.status &= ~ORGAN_BRITTLE

/singleton/surgery_step/robotics/repair_brittle/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user] causes some of \the [target]'s [affected.name] to crumble!"),
	SPAN_WARNING("You cause some of \the [target]'s [affected.name] to crumble!"))
	target.apply_damage(rand(5,10), DAMAGE_BRUTE, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb burn damage repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/repair_burn
	name = "Repair burns on prosthetic"
	allowed_tools = list(
		/obj/item/stack/cable_coil = 50
	)
	min_duration = 70
	max_duration = 90

/singleton/surgery_step/robotics/repair_burn/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()

	if(user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += 5
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
		. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED))
		. -= 10

/singleton/surgery_step/robotics/repair_burn/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(!affected.burn_dam)
			to_chat(user, SPAN_WARNING("There is no damage to repair."))
			return FALSE
		if(BP_IS_BRITTLE(affected))
			to_chat(user, SPAN_WARNING("\The [target]'s [affected.name] is too brittle for this kind of repair."))
		else
			var/obj/item/stack/cable_coil/C = tool
			if(istype(C))
				if(!C.use(3))
					to_chat(user, SPAN_WARNING("You need three or more cable pieces to repair this damage."))
				else
					return TRUE
	return FALSE

/singleton/surgery_step/robotics/repair_burn/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && ((affected.status & ORGAN_DISFIGURED) || affected.burn_dam > 0))
		return affected

/singleton/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to splice new cabling into [target]'s [affected.name]." , \
	"You begin to splice new cabling into [target]'s [affected.name].")
	playsound(target.loc, 'sound/items/Deconstruct.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] finishes splicing cable into [target]'s [affected.name]."), \
	SPAN_NOTICE("You finishes splicing new cable into [target]'s [affected.name]."))
	affected.heal_damage(0,rand(30,50),1,1)
	affected.status &= ~ORGAN_DISFIGURED

/singleton/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user] causes a short circuit in [target]'s [affected.name]!"),
	SPAN_WARNING("You cause a short circuit in [target]'s [affected.name]!"))
	target.apply_damage(rand(5,10), DAMAGE_BURN, affected)

//////////////////////////////////////////////////////////////////
//	 artificial organ repair surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/fix_organ_robotic //For artificial organs
	name = "Repair prosthetic organ"
	allowed_tools = list(
		/obj/item/stack/nanopaste = 60,
		/obj/item/bonegel = 20,
		/obj/item/screwdriver = 30,
		/obj/item/swapper/power_drill = 50,
	)
	min_duration = 80
	max_duration = 110
	surgery_candidate_flags = SURGERY_NO_STUMP

/singleton/surgery_step/robotics/fix_organ_robotic/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if(target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC
	else
		return SURGERY_SKILLS_ROBOTIC_ON_MEAT

/singleton/surgery_step/robotics/fix_organ_robotic/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(!target.isSynthetic())
		if(user.skill_check(SKILL_ANATOMY, SKILL_EXPERIENCED))
			. += 30
		if(user.skill_check(SKILL_MEDICAL, SKILL_EXPERIENCED))
			. += 30

/singleton/surgery_step/robotics/fix_organ_robotic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		for(var/obj/item/organ/internal/I in affected.internal_organs)
			if(BP_IS_ROBOTIC(I) && !BP_IS_CRYSTAL(I) && I.damage > 0)
				if(I.surface_accessible)
					return affected
				if(affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED) || affected.hatch_state == HATCH_OPENED)
					return affected

/singleton/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message("[user] starts mending the damage to [target]'s [I.name]'s mechanisms.", \
				"You start mending the damage to [target]'s [I.name]'s mechanisms." )
	playsound(target.loc, 'sound/items/bonegel.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message(SPAN_NOTICE("[user] repairs [target]'s [I.name] with [tool]."), \
				SPAN_NOTICE("You repair [target]'s [I.name] with [tool].") )
				I.damage = 0

/singleton/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"))
	target.adjustToxLoss(5)
	affected.createwound(INJURY_TYPE_CUT, 5)
	for(var/internal in affected.internal_organs)
		var/obj/item/organ/internal/I = internal
		if(I)
			I.take_internal_damage(rand(3,5))

//////////////////////////////////////////////////////////////////
//	robotic organ detachment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/detatch_organ_robotic
	name = "Decouple prosthetic organ"
	allowed_tools = list(
		/obj/item/device/multitool = 70
	)
	min_duration = 90
	max_duration = 110
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/robotics/detatch_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/attached_organs
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && !BP_IS_CRYSTAL(I) && I.parent_organ == target_zone)
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Detach \the [I.name]"
			LAZYSET(attached_organs, I.organ_tag, radial_button)
	if(!LAZYLEN(attached_organs))
		to_chat(user, SPAN_WARNING("There are no appropriate internal components to decouple."))
		return FALSE
	if (length(attached_organs) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		return attached_organs[1]
	var/organ_to_remove = show_radial_menu(user, tool, attached_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if (organ_to_remove && user.use_sanity_check(target, tool))
		return organ_to_remove
	return FALSE

/singleton/surgery_step/robotics/detatch_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/removing = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	user.visible_message("[user] starts to decouple \the [removing] from \the [target]'s [affected.name] with \the [tool].", \
	"You start to decouple \the [removing] from \the [target]'s [affected.name] with \the [tool]." )
	playsound(target.loc, 'sound/items/Deconstruct.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/detatch_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/removing = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	user.visible_message(SPAN_NOTICE("[user] has decoupled \the [removing] from \the [target]'s [affected.name] with \the [tool].") , \
	SPAN_NOTICE("You have decoupled \the [removing] from \the [target]'s [affected.name] with \the [tool]."))

	var/obj/item/organ/internal/I = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	if(I && istype(I))
		I.cut_away(user)

/singleton/surgery_step/robotics/detatch_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
	SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

//////////////////////////////////////////////////////////////////
//	robotic organ transplant finalization surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/attach_organ_robotic
	name = "Reattach prosthetic organ"
	allowed_tools = list(
		/obj/item/screwdriver = 50,
		/obj/item/swapper/power_drill = 70,
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT


/singleton/surgery_step/robotics/attach_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/list/obj/item/organ/candidates = list()
	for (var/obj/item/organ/organ in affected.implants)
		if (~organ.status & ORGAN_CUT_AWAY)
			continue
		if (~organ.status & ORGAN_ROBOTIC)
			continue
		if (organ.status & ORGAN_CRYSTAL)
			continue
		if (organ.parent_organ != target_zone)
			continue
		if (organ.organ_tag in target.internal_organs_by_name)
			continue
		var/image/radial_button = image(icon = organ.icon, icon_state = organ.icon_state)
		radial_button.name = "Reattach \the [organ.name]"
		LAZYSET(candidates, organ, radial_button)
	if (length(candidates) == 1 && user.get_preference_value(/datum/client_preference/surgery_skip_radial))
		return candidates[1]
	var/obj/item/organ/selected = show_radial_menu(user, tool, candidates, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if (!selected || !user.use_sanity_check(target, tool))
		return FALSE
	if (istype(selected, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/augment = selected
		if (~augment.augment_flags & AUGMENT_MECHANICAL)
			to_chat(user, SPAN_WARNING("\The [augment] cannot function within a robotic limb."))
			return FALSE
	return selected


/singleton/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/affected = target.get_organ(target_zone)
	var/obj/attaching = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	user.visible_message("[user] begins reattaching \the [attaching] from \the [target]'s [affected.name] with \the [tool].", \
	"You start reattaching \the [attaching] from \the [target]'s [affected.name] with \the [tool].")
	playsound(target.loc, 'sound/items/Screwdriver.ogg', 15, 1)
	..()

/singleton/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/attaching = target.surgeries_in_progress?[target_zone]
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.implants -= attaching
	attaching.status &= ~ORGAN_CUT_AWAY
	attaching.replaced(target, affected)
	user.visible_message(
		SPAN_NOTICE("\The [user] has reattached \a [target]'s [attaching] with \a [tool]."),
		SPAN_NOTICE("You have reattached \the [target]'s [attaching] with \the [tool].")
	)


/singleton/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
	SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

//////////////////////////////////////////////////////////////////
//	mmi installation surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robotics/install_mmi
	name = "Install MMI"
	allowed_tools = list(
		/obj/item/device/mmi = 100
	)
	min_duration = 60
	max_duration = 80
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/robotics/install_mmi/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected && istype(M))
		if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
			to_chat(user, SPAN_WARNING("That brain is not usable."))
		else if(BP_IS_CRYSTAL(affected))
			to_chat(user, SPAN_WARNING("The crystalline interior of \the [affected] is incompatible with \the [M]."))
		else if(!target.isSynthetic())
			to_chat(user, SPAN_WARNING("You cannot install a computer brain into a meat body."))
		else if(!target.should_have_organ(BP_BRAIN))
			to_chat(user, SPAN_WARNING("You're pretty sure [target.species.name_plural] don't normally have a brain."))
		else if(target.internal_organs[BP_BRAIN])
			to_chat(user, SPAN_WARNING("Your subject already has a brain."))
		else
			return TRUE
	return FALSE

/singleton/surgery_step/robotics/install_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && target_zone == BP_HEAD)
		return affected

/singleton/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
	"You start installing \the [tool] into [target]'s [affected.name].")
	playsound(target.loc, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!user.unEquip(tool))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has installed \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have installed \the [tool] into [target]'s [affected.name]."))

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/internal/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	tool.forceMove(holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/singleton/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips."), \
	SPAN_WARNING("Your hand slips."))

/singleton/surgery_step/internal/remove_organ/robotic
	name = "Remove robotic component"
	can_infect = 0
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/internal/replace_organ/robotic
	name = "Replace robotic component"
	can_infect = 0
	robotic_surgery = TRUE
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/remove_mmi
	name = "Remove MMI"
	min_duration = 60
	max_duration = 80
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/material/kitchen/utensil/fork = 20
	)
	can_infect = 0
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/singleton/surgery_step/remove_mmi/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC

/singleton/surgery_step/remove_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (locate(/obj/item/device/mmi) in affected.implants))
		return affected

/singleton/surgery_step/remove_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message( \
	"\The [user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",1,affecting = affected)
	playsound(target.loc, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/remove_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		var/obj/item/device/mmi/mmi = locate() in affected.implants
		if(affected && mmi)
			user.visible_message( \
			SPAN_NOTICE("\The [user] removes \the [mmi] from \the [target]'s [affected.name] with \the [tool]."), \
			SPAN_NOTICE("You  remove \the [mmi] from \the [target]'s [affected.name] with \the [tool]."))
			target.remove_implant(mmi, TRUE, affected)
		else
			user.visible_message( \
			SPAN_NOTICE("\The [user] could not find anything inside [target]'s [affected.name]."), \
			SPAN_NOTICE("You could not find anything inside [target]'s [affected.name]."))

/singleton/surgery_step/remove_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message( \
	SPAN_WARNING("\The [user]'s hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(3, 0, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//					BROKEN PROSTHETIC SURGERY					//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/robone
	surgery_candidate_flags = SURGERY_NO_FLESH | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_ENCASEMENT
	var/required_stage = 0

/singleton/surgery_step/robone/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (affected.status & ORGAN_BROKEN) && affected.stage == required_stage)
		return affected

/singleton/surgery_step/robone/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if(target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC
	else
		return SURGERY_SKILLS_ROBOTIC_ON_MEAT

//////////////////////////////////////////////////////////////////
//	welding surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robone/weld
	name = "Begin structural support repair"
	allowed_tools = list(
		/obj/item/weldingtool = 50,
		/obj/item/tape_roll = 30,
		/obj/item/bonegel = 30
	)
	min_duration = 50
	max_duration = 60

/singleton/surgery_step/robone/weld/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if (affected.stage == 0)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts mending \the [prosthetic] with \the [tool]."),
			SPAN_NOTICE("You start mending \the [prosthetic] with \the [tool].")
		)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)
	..()

/singleton/surgery_step/robone/weld/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	user.visible_message(
		SPAN_INFO("\The [user] finishes mending \the [prosthetic] with \the [tool.name]"),
		SPAN_INFO("You finish mending \the [prosthetic] with \the [tool.name].")
	)
	if(affected.stage == 0)
		affected.stage = 1
	affected.status &= ~ORGAN_BRITTLE

/singleton/surgery_step/robone/weld/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, causing damage with \the [tool] in the open panel on [target]'s [affected.name]!"),
		SPAN_WARNING("Your hand slips, causing damage with \the [tool] in the open panel on [target]'s [affected.name]!")
	)
	affected.take_external_damage(5, 0, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	prosthetic realignment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robone/realign_support
	name = "Realign support"
	allowed_tools = list(
		/obj/item/swapper/power_drill = 100,
		/obj/item/wrench = 70,
		/obj/item/bonesetter = 50
	)
	min_duration = 60
	max_duration = 70
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_FLESH | SURGERY_NEEDS_ENCASEMENT
	required_stage = 1

/singleton/surgery_step/robone/realign_support/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if(affected.encased == "skull")
		user.visible_message(
			SPAN_NOTICE("\The [user] begins to piece \the [prosthetic] back together with \the [tool]."),
			SPAN_NOTICE("You begin to piece \the [prosthetic] back together with \the [tool].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] is beginning to twist \the [prosthetic] in place with \the [tool]."),
			SPAN_NOTICE("You are beginning to twist \the [prosthetic] in place with \the [tool].")
		)
	playsound(target.loc, 'sound/items/bonesetter.ogg', 50, TRUE)
	..()

/singleton/surgery_step/robone/realign_support/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	if (affected.status & ORGAN_BROKEN)
		if(affected.encased == "skull")
			user.visible_message(
				SPAN_INFO("\The [user] pieces \the [prosthetic] back together with \the [tool]."),
				SPAN_INFO("You piece \the [prosthetic] back together with \the [tool].")
			)
		else
			user.visible_message(
				SPAN_INFO("\The [user] twists \the [prosthetic] in place with \the [tool]."),
				SPAN_INFO("You twist \the [prosthetic] in place with \the [tool].")
			)
		affected.stage = 2
	else
		user.visible_message(
			SPAN_WARNING("\The [user] twists \the [prosthetic] in the WRONG place with \the [tool]!."),
			SPAN_WARNING("You twist \the [prosthetic] in the WRONG place with \the [tool]!.")
		)
		affected.fracture()

/singleton/surgery_step/robone/realign_support/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, damaging the [affected.encased ? affected.encased : "structural support"] in \the [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the [affected.encased ? affected.encased : "structural support"] in \the [target]'s [affected.name] with \the [tool]!")
	)
	affected.fracture()
	affected.take_external_damage(5, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	post realignment surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/robone/finish
	name = "Finish structural support repair"
	allowed_tools = list(
		/obj/item/weldingtool = 50,
		/obj/item/tape_roll = 30,
		/obj/item/bonegel = 30
	)
	min_duration = 50
	max_duration = 60
	required_stage = 2

/singleton/surgery_step/robone/finish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s damaged [affected.encased]" : "structural support in \the [target]'s [affected.name]"
	user.visible_message(
		SPAN_NOTICE("\the [user] starts to finish mending [prosthetic] with \the [tool]."),
		SPAN_NOTICE("You start to finish mending [prosthetic] with \the [tool].")
	)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)
	..()

/singleton/surgery_step/robone/finish/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/prosthetic = affected.encased ? "\the [target]'s damaged [affected.encased]" : "structural support in [target]'s [affected.name]"
	user.visible_message(
		SPAN_INFO("\The [user] has finished mending [prosthetic] with \the [tool]."),
		SPAN_INFO("You have finished mending [prosthetic] with \the [tool]." )
	)
	affected.status &= ~ORGAN_BROKEN
	affected.stage = 0
	affected.update_wounds()

/singleton/surgery_step/robone/finish/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, causing damage with \the [tool] in the open panel in [target]'s [affected.name]!"),
		SPAN_WARNING("Your hand slips, causing damage with \the [tool] in the open panel in [target]'s [affected.name]!")
	)
	affected.take_external_damage(5, 0, used_weapon = tool)
