//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	 generic limb surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb
	can_infect = 0
	shock_level = 40
	delicate = 1

/decl/surgery_step/limb/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		return affected
	else
		var/list/organ_data = target.species.has_limbs["[target_zone]"]
		return !isnull(organ_data)

//////////////////////////////////////////////////////////////////
//	 limb attachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/attach
	name = "Replace limb"
	allowed_tools = list(/obj/item/organ/external = 100)
	min_duration = 50
	max_duration = 70

/decl/surgery_step/limb/attach/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/E = tool
	var/obj/item/organ/external/P = target.organs_by_name[E.parent_organ]
	var/obj/item/organ/external/T = target.organs_by_name[E.organ_tag]

	if ((E.status & ORGAN_CONFIGURE) && E.surgery_configure(user, target, P, tool, src))
		return

	if(!P || P.is_stump())
		to_chat(user, SPAN_WARNING("The [E.amputation_point] is missing!"))
	else if(T && T.is_stump())
		to_chat(user, SPAN_WARNING("You cannot attach \a [E] when there is a stump!"))
	else if(T)
		to_chat(user, SPAN_WARNING("There is already \a [E]!"))
	else if(BP_IS_ROBOTIC(P) && !BP_IS_ROBOTIC(E))
		to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a robotic body."))
	else if(BP_IS_CRYSTAL(P) && !BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a crystalline body."))
	else if(!BP_IS_CRYSTAL(P) && BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a crystalline part to a flesh body."))
	else
		. = TRUE

/decl/surgery_step/limb/attach/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/organ/external/tool)
	if(istype(tool) && BP_IS_ROBOTIC(tool))
		if(target.isSynthetic())
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	return ..()

/decl/surgery_step/limb/attach/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = tool
		var/obj/item/organ/external/P = target.organs_by_name[E.parent_organ]
		. = (P && !P.is_stump() && !(BP_IS_ROBOTIC(P) && !BP_IS_ROBOTIC(E)))

/decl/surgery_step/limb/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("[user] starts attaching [E.name] to [target]'s [E.amputation_point].", \
	"You start attaching [E.name] to [target]'s [E.amputation_point].")

/decl/surgery_step/limb/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!user.unEquip(tool))
		return
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='notice'>[user] has attached [target]'s [E.name] to the [E.amputation_point].</span>",	\
	"<span class='notice'>You have attached [target]'s [E.name] to the [E.amputation_point].</span>")
	E.replaced(target)
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/decl/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, DAMAGE_BRUTE, null, damage_flags=DAMAGE_FLAG_SHARP)

//////////////////////////////////////////////////////////////////
//	 limb connecting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/connect
	name = "Connect limb"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 20
	)
	can_infect = 1
	min_duration = 100
	max_duration = 120

/decl/surgery_step/limb/connect/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	var/obj/item/organ/external/E = target && target.get_organ(target_zone)
	if(istype(E) && BP_IS_ROBOTIC(E))
		if(target.isSynthetic())
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	return ..()

/decl/surgery_step/limb/connect/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		return E && !E.is_stump() && (E.status & ORGAN_CUT_AWAY)

/decl/surgery_step/limb/connect/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("[user] starts connecting tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
	"You start connecting tendons and muscle in [target]'s [E.amputation_point].")

/decl/surgery_step/limb/connect/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>",	\
	"<span class='notice'>You have connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>")
	E.status &= ~ORGAN_CUT_AWAY
	if(E.children)
		for(var/obj/item/organ/external/C in E.children)
			C.status &= ~ORGAN_CUT_AWAY
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/decl/surgery_step/limb/connect/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, DAMAGE_BRUTE, null, damage_flags=DAMAGE_FLAG_SHARP)

//////////////////////////////////////////////////////////////////
//	 robotic limb attachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/mechanize
	name = "Attach prosthetic limb"
	allowed_tools = list(/obj/item/robot_parts = 100)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/limb/mechanize/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	if(target.isSynthetic())
		return SURGERY_SKILLS_ROBOTIC
	else
		return SURGERY_SKILLS_ROBOTIC_ON_MEAT

/decl/surgery_step/limb/mechanize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/robot_parts/p = tool
		if (p.part)
			if (!(target_zone in p.part))
				return 0
		return isnull(target.get_organ(target_zone))

/decl/surgery_step/limb/mechanize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts attaching \the [tool] to [target].", \
	"You start attaching \the [tool] to [target].")

/decl/surgery_step/limb/mechanize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/robot_parts/L = tool
	user.visible_message("<span class='notice'>[user] has attached \the [tool] to [target].</span>",	\
	"<span class='notice'>You have attached \the [tool] to [target].</span>")

	if(L.part)
		for(var/part_name in L.part)
			if(!isnull(target.get_organ(part_name)))
				continue
			var/list/organ_data = target.species.has_limbs["[part_name]"]
			if(!organ_data)
				continue
			var/new_limb_type = organ_data["path"]
			var/obj/item/organ/external/new_limb = new new_limb_type(target)
			new_limb.robotize(L.model_info)
			if(L.sabotaged)
				new_limb.status |= ORGAN_SABOTAGED

	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

	qdel(tool)

/decl/surgery_step/limb/mechanize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s flesh!</span>", \
		"<span class='warning'> Your hand slips, damaging [target]'s flesh!</span>")
		target.apply_damage(10, DAMAGE_BRUTE, null, damage_flags=DAMAGE_FLAG_SHARP)
