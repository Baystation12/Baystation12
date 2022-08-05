//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	generic surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic
	can_infect = 1
	shock_level = 10
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP

/decl/surgery_step/generic/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone != BP_EYES) //there are specific steps for eye surgery
		. = ..()

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as both cutting and bleeder clamping surgery steps
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/cut_with_laser
	name = "Make laser incision"
	allowed_tools = list(
		/obj/item/scalpel/laser3 = 95,
		/obj/item/scalpel/laser2 = 85,
		/obj/item/scalpel/laser1 = 75,
		/obj/item/melee/energy/sword = 5
	)
	min_duration = 90
	max_duration = 110

/decl/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",50, affecting = affected)
	..()

/decl/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>",)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1)
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)

/decl/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(15, 5, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as the cutting, bleeder clamping, and retractor surgery steps
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/managed
	name = "Make managed incision"
	allowed_tools = list(
		/obj/item/scalpel/manager = 100
	)
	min_duration = 80
	max_duration = 120

/decl/surgery_step/generic/managed/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
	"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!",50, affecting = affected)
	..()

/decl/surgery_step/generic/managed/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>",)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1) // incision
	affected.clamp_organ() // clamp
	affected.open_incision() // retract

/decl/surgery_step/generic/managed/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(20, 15, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/cut_open
	name = "Make incision"
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/material/knife = 75,
		/obj/item/broken_bottle = 50,
		/obj/item/material/shard = 50
	)
	min_duration = 90
	max_duration = 110
	var/fail_string = "slicing open"
	var/access_string = "an incision"

/decl/surgery_step/generic/cut_open/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access."))
			return FALSE

/decl/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts [access_string] on [target]'s [affected.name] with \the [tool].", \
	"You start [access_string] on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",40, affecting = affected)
	..()

/decl/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has made [access_string] on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made [access_string] on [target]'s [affected.name] with \the [tool].</span>",)
	affected.createwound(INJURY_TYPE_CUT, affected.min_broken_damage/2, 1)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

/decl/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!</span>")
	affected.take_external_damage(10, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

/decl/surgery_step/generic/cut_open/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_FORENSICS, SKILL_ADEPT))
		. += 40
		if(target.stat == DEAD)
			. += 40

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/clamp_bleeders
	name = "Clamp bleeders"
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 20
	)
	min_duration = 40
	max_duration = 60
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE

/decl/surgery_step/generic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && !affected.clamped())
		return affected

/decl/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!",40, affecting = affected)
	..()

/decl/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You clamp bleeders in [target]'s [affected.name] with \the [tool].</span>")
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)

/decl/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='warning'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",)
	affected.take_external_damage(10, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/retract_skin
	name = "Widen incision"
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 75,
		/obj/item/material/knife = 50,
		/obj/item/material/kitchen/utensil/fork = 50
	)
	min_duration = 30
	max_duration = 40
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NO_STUMP | SURGERY_NEEDS_INCISION
	strict_access_requirement = TRUE

/decl/surgery_step/generic/retract_skin/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(affected.how_open() >= SURGERY_RETRACTED)
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access, a larger incision isn't needed."))
		else
			. = TRUE

/decl/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool].",	\
	"You start to pry open the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!",40,affecting = affected)
	..()

/decl/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You keep the incision open on [target]'s [affected.name] with \the [tool].</span>")
	affected.open_incision()

/decl/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='warning'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(12, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/cauterize
	name = "Cauterize incision"
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/smokable/cigarette = 75,
		/obj/item/flame/lighter = 50,
		/obj/item/weldingtool = 25
	)
	min_duration = 70
	max_duration = 100
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL
	var/cauterize_term = "cauterize"
	var/post_cauterize_term = "cauterized"

/decl/surgery_step/generic/cauterize/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		if(affected.is_stump())
			if(affected.status & ORGAN_ARTERY_CUT)
				. = TRUE
			else
				to_chat(user, SPAN_WARNING("There is no bleeding to repair within this stump."))
		else if(!affected.get_incision(1))
			to_chat(user, SPAN_WARNING("There are no incisions on [target]'s [affected.name] that can be closed cleanly with \the [tool]!"))
		else
			. = TRUE

/decl/surgery_step/generic/cauterize/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		if(affected.is_stump())
			if(affected.status & ORGAN_ARTERY_CUT)
				return affected
		else if(affected.how_open())
			return affected

/decl/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message("[user] is beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!",40,affecting = affected)
	..()

/decl/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message("<span class='notice'>[user] [post_cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].</span>")
	if(istype(W))
		W.close()
		affected.update_wounds()
	if(affected.is_stump())
		affected.status &= ~ORGAN_ARTERY_CUT
	if(affected.clamped())
		affected.remove_clamps()

/decl/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(0, 3, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/amputate
	name = "Amputate limb"
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/material/hatchet = 75
	)
	min_duration = 110
	max_duration = 160
	surgery_candidate_flags = 0

/decl/surgery_step/generic/amputate/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (affected.limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && !affected.how_open())
		return affected

/decl/surgery_step/generic/amputate/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	var/target_zone = user.zone_sel.selecting
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(BP_IS_ROBOTIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	else
		return ..()

/decl/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	"<FONT size=3>You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].</FONT>")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!",100,affecting = affected)
	..()

/decl/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].</span>", \
	"<span class='notice'>You amputate [target]'s [affected.name] with \the [tool].</span>")
	affected.droplimb(1,DROPLIMB_EDGE)

/decl/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(30, 0, (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE), used_weapon = tool)
	affected.fracture()
