//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/ribcage
	priority = 2
	can_infect = 1
	blood_level = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return target_zone == "chest"

/datum/surgery_step/ribcage/saw_ribcage
	allowed_tools = list(
	/obj/item/weapon/circular_saw = 100, \
	/obj/item/weapon/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!istype(target))
			return
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return ..() && target.op_stage.ribcage == 0 && affected.open >= 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] begins to cut through [target]'s ribcage with \the [tool].", \
		"You begin to cut through [target]'s ribcage with \the [tool].")
		target.custom_pain("Something hurts horribly in your chest!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\blue [user] has cut [target]'s ribcage open with \the [tool].",		\
		"\blue You have cut [target]'s ribcage open with \the [tool].")
		target.op_stage.ribcage = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\red [user]'s hand slips, cracking [target]'s ribcage with \the [tool]!" , \
		"\red Your hand slips, cracking [target]'s ribcage with \the [tool]!" )
		var/datum/organ/external/affected = target.get_organ(target_zone)
		affected.createwound(CUT, 20)
		affected.fracture()


/datum/surgery_step/ribcage/retract_ribcage
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/kitchen/utensil/fork = 20
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.ribcage == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "[user] starts to force open the ribcage in [target]'s torso with \the [tool]."
		var/self_msg = "You start to force open the ribcage in [target]'s torso with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your chest!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "\blue [user] forces open [target]'s ribcage with \the [tool]."
		var/self_msg = "\blue You force open [target]'s ribcage with \the [tool]."
		user.visible_message(msg, self_msg)
		target.op_stage.ribcage = 2

		// Whoops!
		if(prob(10))
			var/datum/organ/external/affected = target.get_organ(target_zone)
			affected.fracture()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "\red [user]'s hand slips, breaking [target]'s ribcage!"
		var/self_msg = "\red Your hand slips, breaking [target]'s ribcage!"
		user.visible_message(msg, self_msg)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		affected.createwound(BRUISE, 20)
		affected.fracture()

/datum/surgery_step/ribcage/close_ribcage
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/kitchen/utensil/fork = 20
	)


	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.ribcage == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "[user] starts bending [target]'s ribcage back into place with \the [tool]."
		var/self_msg = "You start bending [target]'s ribcage back into place with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your chest!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "\blue [user] bends [target]'s ribcage back into place with \the [tool]."
		var/self_msg = "\blue You bend [target]'s ribcage back into place with \the [tool]."
		user.visible_message(msg, self_msg)

		target.op_stage.ribcage = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "\red [user]'s hand slips, bending [target]'s ribs the wrong way!"
		var/self_msg = "\red Your hand slips, bending [target]'s ribs the wrong way!"
		user.visible_message(msg, self_msg)
		var/datum/organ/external/chest/affected = target.get_organ("chest")
		affected.createwound(BRUISE, 20)
		affected.fracture()
		if (prob(40))
			user.visible_message("\red A rib pierces the lung!")
			target.rupture_lung()

/datum/surgery_step/ribcage/mend_ribcage
	allowed_tools = list(
	/obj/item/weapon/bonegel = 100,	\
	/obj/item/weapon/screwdriver = 75
	)

	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.ribcage == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "[user] starts applying \the [tool] to [target]'s ribcage."
		var/self_msg = "You start applying \the [tool] to [target]'s ribcage."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your chest!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "\blue [user] applied \the [tool] to [target]'s ribcage."
		var/self_msg = "\blue You applied \the [tool] to [target]'s ribcage."
		user.visible_message(msg, self_msg)

		target.op_stage.ribcage = 0

//////////////////////////////////////////////////////////////////
//					ALIEN EMBRYO SURGERY						//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/ribcage/remove_embryo
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/weapon/wirecutters = 75,	\
	/obj/item/weapon/kitchen/utensil/fork = 20
	)
	blood_level = 2

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/embryo = 0
		for(var/obj/item/alien_embryo/A in target)
			embryo = 1
			break
		return ..() && embryo && target.op_stage.ribcage == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/msg = "[user] starts to pull something out from [target]'s ribcage with \the [tool]."
		var/self_msg = "You start to pull something out from [target]'s ribcage with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your chest!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("\red [user] rips the larva out of [target]'s ribcage!",
							 "You rip the larva out of [target]'s ribcage!")

		for(var/obj/item/alien_embryo/A in target)
			A.loc = A.loc.loc


//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/ribcage/fix_chest_internal
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100,		\
	/obj/item/stack/medical/bruise_pack = 20,	\
	/obj/item/stack/medical/bruise_pack/tajaran = 70, 		\
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/is_chest_organ_damaged = 0
		var/datum/organ/external/chest/chest = target.get_organ("chest")
		for(var/datum/organ/internal/I in chest.internal_organs) if(I.damage > 0)
			is_chest_organ_damaged = 1
			break
		return ..() && is_chest_organ_damaged && target.op_stage.ribcage == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/tool_name = "\the [tool]"
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			tool_name = "regenerative membrane"
		if (istype(tool, /obj/item/stack/medical/bruise_pack))
			if (istype(tool, /obj/item/stack/medical/bruise_pack/tajaran))
				tool_name = "the poultice"
			else
				tool_name = "the bandaid"
		var/datum/organ/external/chest/chest = target.get_organ("chest")
		for(var/datum/organ/internal/I in chest.internal_organs)
			if(I && I.damage > 0)
				if(I.robotic < 2)
					user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
					"You start treating damage to [target]'s [I.name] with [tool_name]." )
				else
					user.visible_message("\blue [user] attempts to repair [target]'s mechanical [I.name] with [tool_name]...", \
					"\blue You attempt to repair [target]'s mechanical [I.name] with [tool_name]...")

		target.custom_pain("The pain in your chest is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/tool_name = "\the [tool]"
		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			tool_name = "regenerative membrane"
		if (istype(tool, /obj/item/stack/medical/bruise_pack))
			if (istype(tool, /obj/item/stack/medical/bruise_pack/tajaran))
				tool_name = "the poultice"
			else
				tool_name = "the bandaid"
		var/datum/organ/external/chest/chest = target.get_organ("chest")
		for(var/datum/organ/internal/I in chest.internal_organs)
			if(I && I.damage > 0)
				if(I.robotic < 2)
					user.visible_message("[user] treats damage to [target]'s [I.name] with [tool_name].", \
					"You treat damage to [target]'s [I.name] with [tool_name]." )
				else
					user.visible_message("\blue [user] pokes [target]'s mechanical [I.name] with [tool_name]...", \
					"\blue You poke [target]'s mechanical [I.name] with [tool_name]... \red For no effect, since it's robotic.")
				I.damage = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/chest/affected = target.get_organ("chest")
		user.visible_message("\red [user]'s hand slips, getting mess and tearing the inside of [target]'s chest with \the [tool]!", \
		"\red Your hand slips, getting mess and tearing the inside of [target]'s chest with \the [tool]!")
		var/dam_amt = 2

		if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
			target.adjustToxLoss(5)

		else if (istype(tool, /obj/item/stack/medical/bruise_pack))
			if (istype(tool, /obj/item/stack/medical/bruise_pack/tajaran))
				target.adjustToxLoss(7)
			else
				dam_amt = 5
				target.adjustToxLoss(10)
				affected.createwound(CUT, 5)

		for(var/datum/organ/internal/I in affected.internal_organs)
			if(I && I.damage > 0)
				I.take_damage(dam_amt,0)

/datum/surgery_step/ribcage/fix_chest_internal_robot //For artificial organs
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,		\
	/obj/item/weapon/bonegel = 30, 		\
	/obj/item/weapon/screwdriver = 70,	\
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/is_chest_organ_damaged = 0
		var/datum/organ/internal/heart/heart = target.internal_organs["heart"]
		var/datum/organ/external/chest/chest = target.get_organ("chest")
		for(var/datum/organ/internal/I in chest.internal_organs) if(I.damage > 0)
			is_chest_organ_damaged = 1
			break
		return ..() && is_chest_organ_damaged && heart.robotic == 2 && target.op_stage.ribcage == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/internal/heart/heart = target.internal_organs["heart"]

		if(heart.damage > 0)
			user.visible_message("[user] starts mending the mechanisms on [target]'s heart with \the [tool].", \
			"You start mending the mechanisms on [target]'s heart with \the [tool]." )
		target.custom_pain("The pain in your chest is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/internal/heart/heart = target.internal_organs["heart"]
		if(heart.damage > 0)
			user.visible_message("\blue [user] repairs [target]'s heart with \the [tool].", \
			"\blue You repair [target]'s heart with \the [tool]." )
			heart.damage = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/internal/heart/heart = target.internal_organs["heart"]
		user.visible_message("\red [user]'s hand slips, smearing [tool] in the incision in [target]'s heart, gumming it up!!" , \
		"\red Your hand slips, smearing [tool] in the incision in [target]'s heart, gumming it up!")
		heart.take_damage(5, 0)
		target.adjustToxLoss(5)

//////////////////////////////////////////////////////////////////
//						HEART SURGERY							//
//////////////////////////////////////////////////////////////////
// To be finished after some tests.
// /datum/surgery_step/ribcage/heart/cut
//	allowed_tools = list(
//	/obj/item/weapon/scalpel = 100,		\
//	/obj/item/weapon/kitchenknife = 75,	\
//	/obj/item/weapon/shard = 50, 		\
//	)

//	min_duration = 30
//	max_duration = 40

//	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
//		return ..() && target.op_stage.ribcage == 2

