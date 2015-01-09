//Procedures in this file: Robotic limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/limb/
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0
		if (!(affected.status & ORGAN_DESTROYED))
			return 0
		if (affected.parent)
			if (affected.parent.status & ORGAN_DESTROYED)
				return 0
		return 1

/datum/surgery_step/limb/cut
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return !(affected.status & ORGAN_CUT_AWAY)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts cutting away flesh where [target]'s [affected] used to be with \the [tool].", \
		"You start cutting away flesh where [target]'s [affected] used to be with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] cuts away flesh where [target]'s [affected] used to be with \the [tool].",	\
		"\blue You cut away flesh where [target]'s [affected] used to be with \the [tool].")
		affected.status |= ORGAN_CUT_AWAY

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, cutting [target]'s [affected] open!", \
			"\red Your hand slips, cutting [target]'s [affected] open!")
			affected.take_damage(10,0,1,1)

// TODO: convert this to
/datum/surgery_step/limb/mend
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/kitchen/utensil/fork = 50)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected.status & ORGAN_CUT_AWAY && affected.is_open() < 3 && !(affected.status & ORGAN_ATTACHABLE)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to reposition flesh and nerve endings where where [target]'s [affected] used to be with [tool].", \
		"You start repositioning flesh and nerve endings where [target]'s [affected] used to be with [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] has finished repositioning flesh and nerve endings where [target]'s [affected] used to be with [tool].",	\
		"\blue You have finished repositioning flesh and nerve endings where [target]'s [affected] used to be with [tool].")

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, tearing flesh on [target]'s [affected]!", \
			"\red Your hand slips, tearing flesh on [target]'s [affected]!")
			target.apply_damage(10, BRUTE, affected, sharp=1)


/datum/surgery_step/limb/prepare
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 60
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected.is_open() == 3

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts adjusting the area around [target]'s [affected] with \the [tool].", \
		"You start adjusting the area around [target]'s [affected] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] has finished adjusting the area around [target]'s [affected] with \the [tool].",	\
		"\blue You have finished adjusting the area around [target]'s [affected] with \the [tool].")
		affected.status |= ORGAN_ATTACHABLE
		affected.amputated = 1
		affected.setAmputatedTree()
		//affected.is_open() = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected.parent)
			affected = affected.parent
			user.visible_message("\red [user]'s hand slips, searing [target]'s [affected]!", \
			"\red Your hand slips, searing [target]'s [affected]!")
			target.apply_damage(10, BURN, affected)


/datum/surgery_step/limb/attach
	/*
	Reattachment:
		/obj/item/weapon/retractor
		/obj/item/weapon/biosealant
		/obj/item/weapon/hemostat
		/obj/item/weapon/cautery

	On completion:
		affected.status = 0
		affected.amputated = 0
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()
		for(var/obj/item/organ/internal/replacing_organ in tool)
			replacing_organ.loc = get_turf(tool)
			replacing_organ.replaced(target,affected)
			del(replacing_organ) //Just in case.
		del(tool)
	*/

/datum/surgery_step/limb/attach_robotic
	allowed_tools = list(
		/obj/item/organ = 100
		)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			// Check if part is right for this slot.
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected.status & ORGAN_ATTACHABLE

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts attaching \the [tool] where [target]'s [affected] used to be.", \
		"You start attaching \the [tool] where [target]'s [affected] used to be.")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] has attached \the [tool] where [target]'s [affected] used to be.",	\
		"\blue You have attached \the [tool] where [target]'s [affected] used to be.")

		var/obj/item/organ/external/new_limb = tool
		new_limb.replaced()
		// Prosthetic heads.
		if(new_limb.status & ORGAN_ROBOT)
			affected.roboticize()
			//affected.sabotaged = L.sabotaged
		// Brain transfer.
		var/mob/living/carbon/brain/B = locate() in tool
		if(istype(B) && B.mind)
			B.mind.transfer_to(target)
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()
		del(tool)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, damaging connectors on [target]'s [affected]!", \
		"\red Your hand slips, damaging connectors on [target]'s [affected]!")
		target.apply_damage(10, BRUTE, affected, sharp=1)

/datum/surgery_step/limb/amputate
	allowed_tools = list(
	/obj/item/weapon/circular_saw = 100, \
	/obj/item/weapon/hatchet = 75
	)

	min_duration = 110
	max_duration = 160

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0

		//If all layers are cut and retracted we can amputate.
		//for(var/datum/tissue_layer/tissue_layer in affected.tissue_layers)
		//	if(!tissue_layer.is_open())
		//		return 0

		return target_zone != "chest"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to amputate [target]'s [affected] with \the [tool]." , \
		"You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].")
		target.custom_pain("Your [affected.amputation_point] is being ripped apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] amputates [target]'s [affected] with \the [tool].", \
		"\blue You amputate [target]'s [affected] with \the [tool].")
		affected.droplimb()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, sawing through the bone in [target]'s [affected] with \the [tool]!", \
		"\red Your hand slips, sawwing through the bone in [target]'s [affected] with \the [tool]!")
		affected.take_damage(30,0,1,1)
		affected.fracture()