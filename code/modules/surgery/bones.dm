//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/decl/surgery_step/bone
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_ENCASEMENT
	var/required_stage = 0

/decl/surgery_step/bone/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (affected.status & ORGAN_BROKEN) && affected.stage == required_stage)
		return affected

//////////////////////////////////////////////////////////////////
//	bone gelling surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/bone/glue
	name = "Begin bone repair"
	allowed_tools = list(
		/obj/item/weapon/bonegel = 100,
		/obj/item/weapon/tape_roll = 75
	)
	can_infect = 1
	blood_level = 1
	min_duration = 50
	max_duration = 60
	shock_level = 20

/decl/surgery_step/bone/glue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in \the [target]'s [affected.name]"
	if (affected.stage == 0)
		user.visible_message("\The [user] starts applying \the [tool] to [bone]." , \
		"You start applying \the [tool] to [bone].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",50, affecting = affected)
	..()

/decl/surgery_step/bone/glue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in \the [target]'s [affected.name]"
	user.visible_message("<span class='notice'>[user] applies some [tool.name] to [bone]</span>", \
		"<span class='notice'>You apply some [tool.name] to [bone].</span>")
	if(affected.stage == 0)
		affected.stage = 1
	affected.status &= ~ORGAN_BRITTLE

/decl/surgery_step/bone/glue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")


//////////////////////////////////////////////////////////////////
//	bone setting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/bone/set_bone
	name = "Set bone"
	allowed_tools = list(
		/obj/item/weapon/bonesetter = 100,
		/obj/item/weapon/wrench = 75
	)
	min_duration = 60
	max_duration = 70
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT
	required_stage = 1

/decl/surgery_step/bone/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in \the [target]'s [affected.name]"
	if(affected.encased == "skull")
		user.visible_message("[user] is beginning to piece [bone] back together with \the [tool]." , \
			"You are beginning to piece [bone] back together with \the [tool].")
	else
		user.visible_message("[user] is beginning to set [bone] in place with \the [tool]." , \
			"You are beginning to set [bone] in place with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!",50, affecting = affected)
	..()

/decl/surgery_step/bone/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s [affected.encased]" : "bones in \the [target]'s [affected.name]"
	if (affected.status & ORGAN_BROKEN)
		if(affected.encased == "skull")
			user.visible_message("<span class='notice'>\The [user] pieces [bone] back together with \the [tool].</span>", \
				"<span class='notice'>You piece [bone] back together with \the [tool].</span>")
		else
			user.visible_message("<span class='notice'>\The [user] sets [bone] in place with \the [tool].</span>", \
				"<span class='notice'>You set [bone] in place with \the [tool].</span>")
		affected.stage = 2
	else
		user.visible_message("<span class='notice'>\The [user] sets [bone]</span> <span class='warning'>in the WRONG place with \the [tool].</span>", \
			"<span class='notice'>You set [bone]</span> <span class='warning'>in the WRONG place with \the [tool].</span>")
		affected.fracture()

/decl/surgery_step/bone/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>\The [user]'s hand slips, damaging the [affected.encased ? affected.encased : "bones"] in \the [target]'s [affected.name] with \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, damaging the [affected.encased ? affected.encased : "bones"] in \the [target]'s [affected.name] with \the [tool]!</span>")
	affected.fracture()
	affected.take_external_damage(5, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	post setting bone-gelling surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/bone/finish
	name = "Finish bone repair"
	allowed_tools = list(
		/obj/item/weapon/bonegel = 100,
		/obj/item/weapon/tape_roll = 75
	)
	can_infect = 1
	blood_level = 1
	min_duration = 50
	max_duration = 60
	shock_level = 20
	required_stage = 2

/decl/surgery_step/bone/finish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s damaged [affected.encased]" : "damaged bones in \the [target]'s [affected.name]"
	user.visible_message("[user] starts to finish mending [bone] with \the [tool].", \
	"You start to finish mending [bone] with \the [tool].")
	..()

/decl/surgery_step/bone/finish/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/bone = affected.encased ? "\the [target]'s damaged [affected.encased]" : "damaged bones in [target]'s [affected.name]"
	user.visible_message("<span class='notice'>[user] has mended [bone] with \the [tool].</span>"  , \
		"<span class='notice'>You have mended [bone] with \the [tool].</span>" )
	affected.status &= ~ORGAN_BROKEN
	affected.stage = 0
	affected.update_wounds()

/decl/surgery_step/bone/finish/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")