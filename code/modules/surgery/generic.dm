//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	generic surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/
	can_infect = 1

/datum/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.is_stump())
		return 0
	if (affected.robotic >= ORGAN_ROBOT)
		return 0
	return 1

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as both cutting and bleeder clamping surgery steps
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/cut_with_laser
	allowed_tools = list(
	/obj/item/weapon/scalpel/laser3 = 95, \
	/obj/item/weapon/scalpel/laser2 = 85, \
	/obj/item/weapon/scalpel/laser1 = 75, \
	/obj/item/weapon/melee/energy/sword = 5
	)
	priority = 2
	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",50, affecting = affected)
	..()

/datum/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>",)
	//Could be cleaner ...
	affected.open = 1

	affected.createwound(CUT, 1)
	affected.clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 7.5)
	affected.createwound(BURN, 12.5)

//////////////////////////////////////////////////////////////////
//	laser scalpel surgery step
//	acts as the cutting, bleeder clamping, and retractor surgery steps
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/incision_manager
	allowed_tools = list(
	/obj/item/weapon/scalpel/manager = 100
	)
	priority = 2
	min_duration = 80
	max_duration = 120

/datum/surgery_step/generic/incision_manager/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/generic/incision_manager/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
	"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!",50, affecting = affected)
	..()

/datum/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(BP_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)
	affected.clamp()
	affected.open = 2

/datum/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 20)
	affected.createwound(BURN, 15)

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/cut_open
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/material/knife = 75,	\
	/obj/item/weapon/material/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the incision on [target]'s [affected.name] with \the [tool].", \
	"You start the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",40, affecting = affected)
	..()

/datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has made an incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made an incision on [target]'s [affected.name] with \the [tool].</span>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(BP_HEART))
		affected.status |= ORGAN_BLEEDING
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 50, 1)

	affected.createwound(CUT, 1)

/datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>")
	affected.createwound(CUT, 10)

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

/datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && (affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!",40, affecting = affected)
	..()

/datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You clamp bleeders in [target]'s [affected.name] with \the [tool].</span>")
	affected.clamp()
	spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 50, 1)

/datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='warning'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",)
	affected.createwound(CUT, 10)

//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/retract_skin
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_CHEST)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!",40,affecting = affected)
	..()

/datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<span class='notice'>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</span>"
	var/self_msg = "<span class='notice'>You keep the incision open on [target]'s [affected.name] with \the [tool].</span>"
	if (target_zone == BP_CHEST)
		msg = "<span class='notice'>[user] keeps the ribcage open on [target]'s torso with \the [tool].</span>"
		self_msg = "<span class='notice'>You keep the ribcage open on [target]'s torso with \the [tool].</span>"
	if (target_zone == BP_GROIN)
		msg = "<span class='notice'>[user] keeps the incision open on [target]'s lower abdomen with \the [tool].</span>"
		self_msg = "<span class='notice'>You keep the incision open on [target]'s lower abdomen with \the [tool].</span>"
	user.visible_message(msg, self_msg)
	affected.open = 2

/datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<span class='warning'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
	var/self_msg = "<span class='warning'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
	if (target_zone == BP_CHEST)
		msg = "<span class='warning'>[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
		self_msg = "<span class='warning'>Your hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
	if (target_zone == BP_GROIN)
		msg = "<span class='warning'>[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</span>"
		self_msg = "<span class='warning'>Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</span>"
	user.visible_message(msg, self_msg)
	target.apply_damage(12, BRUTE, affected, damage_flags=DAM_SHARP)

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE

	if(affected.is_stump()) // Copypasting some stuff here to avoid having to modify ..() for a single surgery
		return (!isslime(target) && target_zone != BP_EYES && affected.robotic < ORGAN_ROBOT && (affected.status & ORGAN_ARTERY_CUT))
	else
		return (..() && affected.open)


/datum/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to cauterize \the [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cauterize \the [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!",40,affecting = affected)
	..()

/datum/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] cauterizes \the [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You cauterize \the [target]'s [affected.name] with \the [tool].</span>")
	affected.open = 0
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING
	if(affected.is_stump())
		affected.status &= ~ORGAN_ARTERY_CUT

/datum/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(3, BURN, affected)

//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/generic/amputate
	allowed_tools = list(
	/obj/item/weapon/circular_saw = 100, \
	/obj/item/weapon/material/hatchet = 75
	)

	min_duration = 110
	max_duration = 160

/datum/surgery_step/generic/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	return !affected.cannot_amputate

/datum/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!",100,affecting = affected)
	..()

/datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].</span>", \
	"<span class='notice'>You amputate [target]'s [affected.name] with \the [tool].</span>")
	affected.droplimb(1,DROPLIMB_EDGE)

/datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 30)
	affected.fracture()
