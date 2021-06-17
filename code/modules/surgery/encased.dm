//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic ribcage surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/open_encased
	name = "Saw through bone"
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/material/knife = 50,
		/obj/item/material/hatchet = 75
	)
	can_infect = 1
	blood_level = 1
	min_duration = 50
	max_duration = 70
	shock_level = 60
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_RETRACTED
	strict_access_requirement = TRUE

/decl/surgery_step/open_encased/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.encased)
		return affected

/decl/surgery_step/open_encased/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to cut through [target]'s [affected.encased] with \the [tool].", \
	"You begin to cut through [target]'s [affected.encased] with \the [tool].")
	target.custom_pain("Something hurts horribly in your [affected.name]!",60, affecting = affected)
	..()

/decl/surgery_step/open_encased/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has cut [target]'s [affected.encased] open with \the [tool].</span>",		\
	"<span class='notice'>You have cut [target]'s [affected.encased] open with \the [tool].</span>")
	affected.fracture()

/decl/surgery_step/open_encased/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" , \
	"<span class='warning'>Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" )
	affected.take_external_damage(15, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)
	affected.fracture()
