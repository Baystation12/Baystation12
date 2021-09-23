 //////////////////////////////////////////////////////////////////
//	facial reconstruction surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/fix_face
	name = "Repair face"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 10,
		/obj/item/material/kitchen/utensil/fork = 75
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_RETRACTED
	strict_access_requirement = TRUE

/decl/surgery_step/fix_face/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone == BP_HEAD)
		var/obj/item/organ/external/affected = ..()
		if(affected && (affected.status & ORGAN_DISFIGURED))
			return affected

/decl/surgery_step/fix_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts repairing damage to \the [target]'s face with \the [tool].", \
	"You start repairing damage to \the [target]'s face with \the [tool].")
	..()

/decl/surgery_step/fix_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] repairs \the [target]'s face with \the [tool].</span>",	\
	"<span class='notice'>You repair \the [target]'s face with \the [tool].</span>")
	var/obj/item/organ/external/head/h = target.get_organ(target_zone)
	if(h)
		h.status &= ~ORGAN_DISFIGURED

/decl/surgery_step/fix_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing skin on [target]'s face with \the [tool]!</span>")
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	Plastic Surgery
//////////////////////////////////////////////////////////////////

/decl/surgery_step/plastic_surgery
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_RETRACTED
	strict_access_requirement = TRUE
	var/required_stage = 0

/decl/surgery_step/plastic_surgery/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone == BP_HEAD)
		var/obj/item/organ/external/affected = ..()
		if(affected && affected.stage == required_stage)
			return affected

/decl/surgery_step/plastic_surgery/prepare_face
	name = "Prepare Face"
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/material/shard = 50
	)
	min_duration = 100
	max_duration = 120
	can_infect = 1
	shock_level = 20

/decl/surgery_step/plastic_surgery/prepare_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts peeling back the skin around \the [target]'s face with \the [tool]."),
		SPAN_NOTICE("You start peeling back the skin around \the [target]'s face with \the [tool].")
	)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.stage == 0)
		affected.stage = 1
	..()

/decl/surgery_step/plastic_surgery/prepare_face/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes peeling back the skin around \the [target]'s face with \the [tool]."),
		SPAN_NOTICE("You finish peeling back the skin around \the [target]'s face with \the [tool].")
	)

/decl/surgery_step/plastic_surgery/prepare_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, tearing skin on \the [target]'s face with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing skin on \the [target]'s face with \the [tool]!")
	)
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

/decl/surgery_step/plastic_surgery/reform_face
	name = "Reform Face"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 10,
		/obj/item/material/kitchen/utensil/fork = 75
	)
	min_duration = 100
	max_duration = 120
	can_infect = 1
	shock_level = 20
	required_stage = 1

/decl/surgery_step/plastic_surgery/reform_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts molding \the [target]'s face with \the [tool]."),
		SPAN_NOTICE("You start molding \the [target]'s face with \the [tool].")
	)
	..()

/decl/surgery_step/plastic_surgery/reform_face/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes molding \the [target]'s face with \the [tool]."),
		SPAN_NOTICE("You finish molding \the [target]'s face with \the [tool].")
	)
	if(!target.fake_name)
		var/new_name = sanitizeSafe(input(user, "Select a new name for \the [target].") as text|null, MAX_NAME_LEN)
		if(new_name && user.Adjacent(target))
			user.visible_message(
				SPAN_NOTICE("\The [user] molds \the [target]'s face into the spitting image of [new_name]!"),
				SPAN_NOTICE("You mold \the [target]'s face into the spitting image of [new_name]!")
			)
			target.fake_name=new_name
			target.name=new_name

	else
		target.fake_name=null
		user.visible_message(
			SPAN_NOTICE("\The [user] returns \the [target]'s face back to normal!"),
			SPAN_NOTICE("You return \the [target]'s face back to normal!")
		)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.stage=0

/decl/surgery_step/plastic_surgery/reform_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("\The [user]'s hand slips, tearing skin on \the [target]'s face with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing skin on \the [target]'s face with \the [tool]!")
	)
	var/obj/item/organ/external/head/h = target.get_organ(target_zone)
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)
	if(h)
		h.status &= ~ORGAN_DISFIGURED
