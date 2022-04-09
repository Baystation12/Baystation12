//Procedures in this file: Robotic surgery steps, organ removal, replacement. MMI insertion, synthetic organ repair.
//////////////////////////////////////////////////////////////////
//						ROBOTIC SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic robotic surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics
	can_infect = 0
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP

decl/surgery_step/robotics/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC

/decl/surgery_step/robotics/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && !(affected.status & ORGAN_CUT_AWAY))
		return affected

/decl/surgery_step/robotics/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	//Compensating for anatomy skill req in base proc
	. += 10
	if(!user.skill_check(SKILL_DEVICES, SKILL_ADEPT))
		. -= 20
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += 10
	if(user.skill_check(SKILL_DEVICES, SKILL_PROF))
		. += 20

//////////////////////////////////////////////////////////////////
//	 unscrew robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/unscrew_hatch
	name = "Unscrew maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 100,
		/obj/item/material/coin = 50,
		/obj/item/material/knife = 50
	)
	min_duration = 90
	max_duration = 110

/decl/surgery_step/robotics/unscrew_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_CLOSED)
		return affected

/decl/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/decl/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>",)
	affected.hatch_state = HATCH_UNSCREWED

/decl/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>\The [user]'s [tool.name] slips, failing to unscrew \the [target]'s [affected.name].</span>", \
	"<span class='warning'>Your [tool.name] slips, failing to unscrew [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	 screw robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/screw_hatch
	name = "Secure maintenance hatch"
	allowed_tools = list(
		/obj/item/screwdriver = 100,
		/obj/item/material/coin = 50,
		/obj/item/material/knife = 50
	)
	min_duration = 90
	max_duration = 110

/decl/surgery_step/robotics/screw_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_UNSCREWED)
		return affected

/decl/surgery_step/robotics/screw_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to screw down the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to screw down the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/decl/surgery_step/robotics/screw_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has screwed down the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have screwed down the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>",)
	affected.hatch_state = HATCH_CLOSED

/decl/surgery_step/robotics/screw_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to screw down [target]'s [affected.name].</span>", \
	"<span class='warning'>Your [tool] slips, failing to screw down [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	open robotic limb surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/open_hatch
	name = "Open maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 100,
		/obj/item/material/kitchen/utensil = 50
	)

	min_duration = 30
	max_duration = 40

/decl/surgery_step/robotics/open_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_UNSCREWED)
		return affected

/decl/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
	"You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/decl/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
	 "<span class='notice'>You open the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>")
	affected.hatch_state = HATCH_OPENED

/decl/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool] slips, failing to open the hatch on [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	close robotic limb surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/close_hatch
	name = "Close maintenance hatch"
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 100,
		/obj/item/material/kitchen/utensil = 50
	)

	min_duration = 70
	max_duration = 100

/decl/surgery_step/robotics/close_hatch/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED)
		return affected

/decl/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to close the hatch on [target]'s [affected.name] with \the [tool]." , \
	"You begin to close the hatch on [target]'s [affected.name] with \the [tool].")
	..()

/decl/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] closes the hatch on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You close the hatch on [target]'s [affected.name] with \the [tool].</span>")
	affected.hatch_state = HATCH_UNSCREWED
	affected.germ_level = 0

/decl/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	robotic limb brute damage repair surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/repair_brute
	name = "Repair damage to prosthetic"
	allowed_tools = list(
		/obj/item/weldingtool = 100,
		/obj/item/gun/energy/plasmacutter = 50,
		/obj/item/psychic_power/psiblade/master = 100
	)

	min_duration = 50
	max_duration = 60

/decl/surgery_step/robotics/repair_brute/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_CONSTRUCTION, SKILL_BASIC))
		. += 10

/decl/surgery_step/robotics/repair_brute/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
			if(!welder.isOn() || !welder.remove_fuel(1,user))
				return FALSE
		if(istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = tool
			if(!cutter.slice(user))
				return FALSE
		return TRUE
	return FALSE

/decl/surgery_step/robotics/repair_brute/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && ((affected.status & ORGAN_DISFIGURED) || affected.brute_dam > 0))
		return affected

/decl/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
	"You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool].")
	..()

/decl/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] finishes patching damage to [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You finish patching damage to [target]'s [affected.name] with \the [tool].</span>")
	affected.heal_damage(rand(30,50),0,1,1)
	affected.status &= ~ORGAN_DISFIGURED

/decl/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>")
	target.apply_damage(rand(5,10), BURN, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb brittleness repair surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/repair_brittle
	name = "Reinforce prosthetic"
	allowed_tools = list(/obj/item/stack/nanopaste = 100)
	min_duration = 50
	max_duration = 60

/decl/surgery_step/robotics/repair_brittle/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += 10

/decl/surgery_step/robotics/repair_brittle/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && BP_IS_BRITTLE(affected) && affected.hatch_state == HATCH_OPENED)
		return affected

/decl/surgery_step/robotics/repair_brittle/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to repair the brittle metal inside \the [target]'s [affected.name]." , \
	"You begin to repair the brittle metal inside \the [target]'s [affected.name].")
	..()

/decl/surgery_step/robotics/repair_brittle/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] finishes repairing the brittle interior of \the [target]'s [affected.name].</span>", \
	"<span class='notice'>You finish repairing the brittle interior of \the [target]'s [affected.name].</span>")
	affected.status &= ~ORGAN_BRITTLE

/decl/surgery_step/robotics/repair_brittle/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user] causes some of \the [target]'s [affected.name] to crumble!</span>",
	"<span class='warning'>You cause some of \the [target]'s [affected.name] to crumble!</span>")
	target.apply_damage(rand(5,10), BRUTE, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb burn damage repair surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/repair_burn
	name = "Repair burns on prosthetic"
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100
	)
	min_duration = 50
	max_duration = 60

/decl/surgery_step/robotics/repair_burn/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()

	if(user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		. += 10

/decl/surgery_step/robotics/repair_burn/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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

/decl/surgery_step/robotics/repair_burn/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.hatch_state == HATCH_OPENED && ((affected.status & ORGAN_DISFIGURED) || affected.burn_dam > 0))
		return affected

/decl/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to splice new cabling into [target]'s [affected.name]." , \
	"You begin to splice new cabling into [target]'s [affected.name].")
	..()

/decl/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] finishes splicing cable into [target]'s [affected.name].</span>", \
	"<span class='notice'>You finishes splicing new cable into [target]'s [affected.name].</span>")
	affected.heal_damage(0,rand(30,50),1,1)
	affected.status &= ~ORGAN_DISFIGURED

/decl/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user] causes a short circuit in [target]'s [affected.name]!</span>",
	"<span class='warning'>You cause a short circuit in [target]'s [affected.name]!</span>")
	target.apply_damage(rand(5,10), BURN, affected)

//////////////////////////////////////////////////////////////////
//	 artificial organ repair surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/fix_organ_robotic //For artificial organs
	name = "Repair prosthetic organ"
	allowed_tools = list(
		/obj/item/stack/nanopaste = 100,
		/obj/item/bonegel = 30,
		/obj/item/screwdriver = 70,
	)
	min_duration = 70
	max_duration = 90
	surgery_candidate_flags = SURGERY_NO_STUMP

/decl/surgery_step/robotics/fix_organ_robotic/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if(target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC 
	else
		return SURGERY_SKILLS_ROBOTIC_ON_MEAT 

/decl/surgery_step/robotics/fix_organ_robotic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		for(var/obj/item/organ/internal/I in affected.internal_organs)
			if(BP_IS_ROBOTIC(I) && !BP_IS_CRYSTAL(I) && I.damage > 0)
				if(I.surface_accessible)
					return affected
				if(affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED) || affected.hatch_state == HATCH_OPENED)
					return affected

/decl/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message("[user] starts mending the damage to [target]'s [I.name]'s mechanisms.", \
				"You start mending the damage to [target]'s [I.name]'s mechanisms." )
	..()

/decl/surgery_step/robotics/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(BP_IS_ROBOTIC(I))
				user.visible_message("<span class='notice'>[user] repairs [target]'s [I.name] with [tool].</span>", \
				"<span class='notice'>You repair [target]'s [I.name] with [tool].</span>" )
				I.damage = 0

/decl/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>")
	target.adjustToxLoss(5)
	affected.createwound(CUT, 5)
	for(var/internal in affected.internal_organs)
		var/obj/item/organ/internal/I = internal
		if(I)
			I.take_internal_damage(rand(3,5))

//////////////////////////////////////////////////////////////////
//	robotic organ detachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/detatch_organ_robotic
	name = "Decouple prosthetic organ"
	allowed_tools = list(
		/obj/item/device/multitool = 100
	)
	min_duration = 90
	max_duration = 110
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/robotics/detatch_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/attached_organs
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && !BP_IS_CRYSTAL(I) && I.parent_organ == target_zone)
			LAZYADD(attached_organs, organ)
	if(!LAZYLEN(attached_organs))
		to_chat(user, SPAN_WARNING("There are no appropriate internal components to decouple."))
		return FALSE
	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(organ_to_remove)
		return organ_to_remove

/decl/surgery_step/robotics/detatch_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to decouple [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].", \
	"You start to decouple [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool]." )
	..()

/decl/surgery_step/robotics/detatch_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has decoupled [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].</span>" , \
	"<span class='notice'>You have decoupled [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].</span>")

	var/obj/item/organ/internal/I = target.internal_organs_by_name[LAZYACCESS(target.surgeries_in_progress, target_zone)]
	if(I && istype(I))
		I.cut_away(user)

/decl/surgery_step/robotics/detatch_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
	"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

//////////////////////////////////////////////////////////////////
//	robotic organ transplant finalization surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/attach_organ_robotic
	name = "Reattach prosthetic organ"
	allowed_tools = list(
		/obj/item/screwdriver = 100,
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/robotics/attach_organ_robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/removable_organs = list()
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/I in affected.implants)
		if ((I.status & ORGAN_CUT_AWAY) && BP_IS_ROBOTIC(I) && !BP_IS_CRYSTAL(I) && (I.parent_organ == target_zone))
			removable_organs |= I.organ_tag
	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return FALSE
	var/obj/item/organ/internal/augment/A = organ_to_replace
	if(istype(A))
		if(!(A.augment_flags & AUGMENT_MECHANICAL))
			to_chat(user, SPAN_WARNING("\the [A] cannot function within a robotic limb"))
			return FALSE
	return organ_to_replace

/decl/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].", \
	"You start reattaching [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].")
	..()

/decl/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has reattached [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].</span>" , \
	"<span class='notice'>You have reattached [target]'s [LAZYACCESS(target.surgeries_in_progress, target_zone)] with \the [tool].</span>")

	var/current_organ = LAZYACCESS(target.surgeries_in_progress, target_zone)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for (var/obj/item/organ/I in affected.implants)
		if (I.organ_tag == current_organ)
			I.status &= ~ORGAN_CUT_AWAY
			affected.implants -= I
			I.replaced(target, affected)
			break

/decl/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
	"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

//////////////////////////////////////////////////////////////////
//	mmi installation surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/robotics/install_mmi
	name = "Install MMI"
	allowed_tools = list(
		/obj/item/device/mmi = 100
	)
	min_duration = 60
	max_duration = 80
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/robotics/install_mmi/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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

/decl/surgery_step/robotics/install_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && target_zone == BP_HEAD)
		return affected

/decl/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
	"You start installing \the [tool] into [target]'s [affected.name].")
	..()

/decl/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!user.unEquip(tool))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has installed \the [tool] into [target]'s [affected.name].</span>", \
	"<span class='notice'>You have installed \the [tool] into [target]'s [affected.name].</span>")

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/internal/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	tool.forceMove(holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/decl/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips.</span>", \
	"<span class='warning'>Your hand slips.</span>")

/decl/surgery_step/internal/remove_organ/robotic
	name = "Remove robotic component"
	can_infect = 0
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/internal/replace_organ/robotic
	name = "Replace robotic component"
	can_infect = 0
	robotic_surgery = TRUE
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_FLESH | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/remove_mmi
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

/decl/surgery_step/remove_mmi/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return SURGERY_SKILLS_ROBOTIC

/decl/surgery_step/remove_mmi/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (locate(/obj/item/device/mmi) in affected.implants))
		return affected

/decl/surgery_step/remove_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message( \
	"\The [user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",1,affecting = affected)
	..()

/decl/surgery_step/remove_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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

/decl/surgery_step/remove_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message( \
	SPAN_WARNING("\The [user]'s hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, damaging \the [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(3, 0, used_weapon = tool)
