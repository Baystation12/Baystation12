// Internal surgeries.
/datum/surgery_step/internal
	priority = 2
	can_infect = 1
	blood_level = 1

/datum/surgery_step/internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2)

//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/fix_organ
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100,		\
	/obj/item/stack/medical/bruise_pack = 20
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected)
			return
		var/is_organ_damaged = 0
		for(var/obj/item/organ/I in affected.internal_organs)
			if(I.damage > 0)
				is_organ_damaged = 1
				break
		return ..() && is_organ_damaged

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/tool_name = "\the [tool]"
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			tool_name = "regenerative membrane"
		else if (istype(tool, /obj/item/stack/medical/bruise_pack))
			tool_name = "the bandaid"

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		for(var/obj/item/organ/I in affected.internal_organs)
			if(I && I.damage > 0)
				if(I.robotic < 2)
					user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
					"You start treating damage to [target]'s [I.name] with [tool_name]." )

		target.custom_pain("The pain in your [affected.name] is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/tool_name = "\the [tool]"
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			tool_name = "regenerative membrane"
		if (istype(tool, /obj/item/stack/medical/bruise_pack))
			tool_name = "the bandaid"

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		for(var/obj/item/organ/I in affected.internal_organs)
			if(I && I.damage > 0)
				if(I.robotic < 2)
					user.visible_message("<span class='notice'>[user] treats damage to [target]'s [I.name] with [tool_name].</span>", \
					"<span class='notice'>You treat damage to [target]'s [I.name] with [tool_name].</span>" )
					I.damage = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='warning'>[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>")
		var/dam_amt = 2

		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			target.adjustToxLoss(5)

		else if (istype(tool, /obj/item/stack/medical/bruise_pack))
			dam_amt = 5
			target.adjustToxLoss(10)
			affected.createwound(CUT, 5)

		for(var/obj/item/organ/I in affected.internal_organs)
			if(I && I.damage > 0)
				I.take_damage(dam_amt,0)

/datum/surgery_step/internal/detatch_organ

	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/material/knife = 75,	\
	/obj/item/weapon/material/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!..())
			return 0

		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		if(!(affected && !(affected.robotic >= ORGAN_ROBOT)))
			return 0

		target.op_stage.current_organ = null

		var/list/attached_organs = list()
		for(var/organ in target.internal_organs_by_name)
			var/obj/item/organ/I = target.internal_organs_by_name[organ]
			if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
				attached_organs |= organ

		var/organ_to_remove = input(user, "Which organ do you want to separate?") as null|anything in attached_organs
		if(!organ_to_remove)
			return 0

		target.op_stage.current_organ = organ_to_remove

		return ..() && organ_to_remove

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to separate [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start to separate [target]'s [target.op_stage.current_organ] with \the [tool]." )
		target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has separated [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have separated [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

		var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
		if(I && istype(I))
			I.cut_away(user)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, rand(30,50), 1)

/datum/surgery_step/internal/remove_organ

	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/weapon/wirecutters = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 20
	)

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!..())
			return 0

		target.op_stage.current_organ = null

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected)
			return 0

		var/list/removable_organs = list()
		for(var/obj/item/organ/I in affected.implants)
			if(I.status & ORGAN_CUT_AWAY)
				removable_organs |= I

		var/organ_to_remove = input(user, "Which organ do you want to remove?") as null|anything in removable_organs
		if(!organ_to_remove)
			return 0

		target.op_stage.current_organ = organ_to_remove
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts removing [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start removing [target]'s [target.op_stage.current_organ] with \the [tool].")
		target.custom_pain("The pain in your [affected.name] is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has removed [target]'s [target.op_stage.current_organ] with \the [tool].</span>", \
		"<span class='notice'>You have removed [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

		// Extract the organ!
		var/obj/item/organ/O = target.op_stage.current_organ
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(istype(O) && istype(affected))
			affected.implants -= O
			O.dropInto(target.loc)
			target.op_stage.current_organ = null
			playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(BRUISE, 20)

/datum/surgery_step/internal/replace_organ
	allowed_tools = list(
	/obj/item/organ = 100
	)

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		var/obj/item/organ/O = tool
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected) return
		var/organ_compatible
		var/organ_missing

		if(!istype(O))
			return 0

		if((affected.robotic >= ORGAN_ROBOT) && !(O.robotic >= ORGAN_ROBOT))
			user << "<span class='danger'>You cannot install a naked organ into a robotic body.</span>"
			return SURGERY_FAILURE

		if(!target.species)
			CRASH("Target ([target]) of surgery [src.type] has no species!")
			return SURGERY_FAILURE

		var/o_is = (O.gender == PLURAL) ? "are" : "is"
		var/o_a =  (O.gender == PLURAL) ? "" : "a "
		var/o_do = (O.gender == PLURAL) ? "don't" : "doesn't"

		if(O.organ_tag == "limb")
			return 0
		else if(target.species.has_organ[O.organ_tag])

			if(O.damage > (O.max_damage * 0.75))
				user << "<span class='warning'>\The [O.organ_tag] [o_is] in no state to be transplanted.</span>"
				return SURGERY_FAILURE

			if(!target.internal_organs_by_name[O.organ_tag])
				organ_missing = 1
			else
				user << "<span class='warning'>\The [target] already has [o_a][O.organ_tag].</span>"
				return SURGERY_FAILURE

			if(O && affected.limb_name == O.parent_organ)
				organ_compatible = 1
			else
				user << "<span class='warning'>\The [O.organ_tag] [o_do] normally go in \the [affected.name].</span>"
				return SURGERY_FAILURE

		else if(istype(O, /obj/item/organ/stack))

			if(!target.internal_organs_by_name[O.organ_tag])
				organ_missing = 1
			else
				user << "<span class='warning'>\The [target] already has [o_a][O.organ_tag].</span>"
				return SURGERY_FAILURE

			if(O && affected.limb_name == O.parent_organ)
				organ_compatible = 1
			else
				user << "<span class='warning'>\The [O.organ_tag] [o_do] normally go in \the [affected.name].</span>"
				return SURGERY_FAILURE
		else
			user << "<span class='warning'>You're pretty sure [target.species.name_plural] don't normally have [o_a][O.organ_tag].</span>"
			return SURGERY_FAILURE

		return ..() && organ_missing && organ_compatible

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts transplanting \the [tool] into [target]'s [affected.name].", \
		"You start transplanting \the [tool] into [target]'s [affected.name].")
		target.custom_pain("Someone's rooting around in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has transplanted \the [tool] into [target]'s [affected.name].</span>", \
		"<span class='notice'>You have transplanted \the [tool] into [target]'s [affected.name].</span>")
		var/obj/item/organ/O = tool
		if(istype(O))
			user.remove_from_mob(O)
			O.forceMove(target)
			affected.implants |= O //move the organ into the patient. The organ is properly reattached in the next step
			playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, damaging \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging \the [tool]!</span>")
		var/obj/item/organ/I = tool
		if(istype(I))
			I.take_damage(rand(3,5),0)

/datum/surgery_step/internal/attach_organ
	allowed_tools = list(
	/obj/item/weapon/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 100
	max_duration = 120

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!..())
			return 0

		target.op_stage.current_organ = null

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected || affected.robotic >= ORGAN_ROBOT)
			// robotic attachment handled via screwdriver
			return 0

		var/list/attachable_organs = list()
		for(var/obj/item/organ/I in affected.implants)
			if(I && (I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
				attachable_organs |= I

		var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in attachable_organs
		if(!organ_to_replace)
			return 0

		target.op_stage.current_organ = organ_to_replace
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
		target.custom_pain("Someone's digging needles into your [target.op_stage.current_organ]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

		var/obj/item/organ/I = target.op_stage.current_organ
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(istype(I) && I.parent_organ == target_zone && affected && (I in affected.implants))
			I.status &= ~ORGAN_CUT_AWAY //apply fixovein
			affected.implants -= I
			I.replaced(target, affected)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(BRUISE, 20)

//////////////////////////////////////////////////////////////////
//						HEART SURGERY							//
//////////////////////////////////////////////////////////////////
// To be finished after some tests.
// /datum/surgery_step/ribcage/heart/cut
//	allowed_tools = list(
//	/obj/item/weapon/scalpel = 100,		\
//	/obj/item/weapon/material/knife = 75,	\
//	/obj/item/weapon/material/shard = 50, 		\
//	)

//	min_duration = 30
//	max_duration = 40

//	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
//		return ..() && target.op_stage.ribcage == 2