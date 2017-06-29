//Procedures in this file: Robotic surgery steps, organ removal, replacement. MMI insertion, synthetic organ repair.
//////////////////////////////////////////////////////////////////
//						ROBOTIC SURGERY							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic robotic surgery step datum
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/
	can_infect = 0
/datum/surgery_step/robotics/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!istype(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.status & ORGAN_CUT_AWAY)
		return 0
	if (affected.robotic < ORGAN_ROBOT)
		return 0
	return 1

//////////////////////////////////////////////////////////////////
//	 unscrew robotic limb hatch surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/unscrew_hatch
	allowed_tools = list(
		/obj/item/weapon/screwdriver = 100,
		/obj/item/weapon/coin = 50,
		/obj/item/weapon/material/kitchen/utensil/knife = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/unscrew_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.hatch == 0 && target_zone != BP_MOUTH

/datum/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
	"You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>",)
	affected.hatch = 1

/datum/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to unscrew [target]'s [affected.name].</span>", \
	"<span class='warning'>Your [tool] slips, failing to unscrew [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	open robotic limb surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/open_hatch
	allowed_tools = list(
		/obj/item/weapon/retractor = 100,
		/obj/item/weapon/crowbar = 100,
		/obj/item/weapon/material/kitchen/utensil = 50
	)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/robotics/open_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.hatch == 1

/datum/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
	"You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
	 "<span class='notice'>You open the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>")
	affected.hatch = 3

/datum/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool] slips, failing to open the hatch on [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	close robotic limb surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/close_hatch
	allowed_tools = list(
		/obj/item/weapon/retractor = 100,
		/obj/item/weapon/crowbar = 100,
		/obj/item/weapon/material/kitchen/utensil = 50
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/robotics/close_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.hatch && target_zone != BP_MOUTH

/datum/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to close and secure the hatch on [target]'s [affected.name] with \the [tool]." , \
	"You begin to close and secure the hatch on [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] closes and secures the hatch on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You close and secure the hatch on [target]'s [affected.name] with \the [tool].</span>")
	affected.hatch = 0
	affected.germ_level = 0

/datum/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>")

//////////////////////////////////////////////////////////////////
//	robotic limb brute damage repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/repair_brute
	allowed_tools = list(
		/obj/item/weapon/weldingtool = 100,
		/obj/item/weapon/pickaxe/plasmacutter = 50
	)

	min_duration = 50
	max_duration = 60

/datum/surgery_step/robotics/repair_brute/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(istype(tool,/obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/welder = tool
			if(!welder.isOn() || !welder.remove_fuel(1,user))
				return 0
		return affected && affected.hatch == 3 && (affected.disfigured || affected.brute_dam > 0) && target_zone != BP_MOUTH

/datum/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
	"You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool].")
	..()

/datum/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] finishes patching damage to [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You finish patching damage to [target]'s [affected.name] with \the [tool].</span>")
	affected.heal_damage(rand(30,50),0,1,1)
	affected.disfigured = 0

/datum/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>",
	"<span class='warning'>Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>")
	target.apply_damage(rand(5,10), BURN, affected)

//////////////////////////////////////////////////////////////////
//	robotic limb burn damage repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/repair_burn
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100
	)

	min_duration = 50
	max_duration = 60

/datum/surgery_step/robotics/repair_burn/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/stack/cable_coil/C = tool
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/limb_can_operate = ((affected && affected.hatch >= SURGERY_ENCASED) && (affected.disfigured || affected.burn_dam > 0) && target_zone != BP_MOUTH)
		if(limb_can_operate)
			if(istype(C))
				if(!C.get_amount() >= 3)
					to_chat(user, "<span class='danger'>You need three or more cable pieces to repair this damage.</span>")
					return SURGERY_FAILURE
				C.use(3)
				return 1
		return SURGERY_FAILURE

		if(!limb_can_operate)
			return 0

		if(istype(C))
			if(!C.can_use(10))
				to_chat(user, "<span class='danger'>You need ten or more cable pieces to repair this damage.</span>")//usage amount made more consistent with regular cable repair

				return SURGERY_FAILURE
			C.use(10)
		return 1

/datum/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] begins to splice new cabling into [target]'s [affected.name]." , \
	"You begin to splice new cabling into [target]'s [affected.name].")
	..()

/datum/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] finishes splicing cable into [target]'s [affected.name].</span>", \
	"<span class='notice'>You finishes splicing new cable into [target]'s [affected.name].</span>")
	affected.heal_damage(0,rand(30,50),1,1)
	affected.disfigured = 0

/datum/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user] causes a short circuit in [target]'s [affected.name]!</span>",
	"<span class='warning'>You cause a short circuit in [target]'s [affected.name]!</span>")
	target.apply_damage(rand(5,10), BURN, affected)

//////////////////////////////////////////////////////////////////
//	 artificial organ repair surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/fix_organ_robotic //For artificial organs
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,		\
	/obj/item/weapon/bonegel = 30, 		\
	/obj/item/weapon/screwdriver = 70,	\
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/robotics/fix_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	var/is_organ_damaged = 0
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I.damage > 0 && (I.robotic >= ORGAN_ROBOT))
			is_organ_damaged = 1
			break
	return affected.hatch == 3 && is_organ_damaged

/datum/surgery_step/robotics/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			if(I.robotic >= ORGAN_ROBOT)
				user.visible_message("[user] starts mending the damage to [target]'s [I.name]'s mechanisms.", \
				"You start mending the damage to [target]'s [I.name]'s mechanisms." )
	..()

/datum/surgery_step/robotics/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/I in affected.internal_organs)

		if(I && I.damage > 0)
			if(I.robotic >= ORGAN_ROBOT)
				user.visible_message("<span class='notice'>[user] repairs [target]'s [I.name] with [tool].</span>", \
				"<span class='notice'>You repair [target]'s [I.name] with [tool].</span>" )
				I.damage = 0

/datum/surgery_step/robotics/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<span class='warning'>[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>")

	target.adjustToxLoss(5)
	affected.createwound(CUT, 5)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I)
			I.take_damage(rand(3,5),0)

//////////////////////////////////////////////////////////////////
//	robotic organ detachment surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/detatch_organ_robotic

	allowed_tools = list(
	/obj/item/device/multitool = 100
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/detatch_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if(!..())
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.hatch < 3)
		return 0

	target.op_stage.current_organ = null

	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			attached_organs |= organ

	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(!organ_to_remove)
		return 0

	target.op_stage.current_organ = organ_to_remove

	return 1

/datum/surgery_step/robotics/detatch_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to decouple [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start to decouple [target]'s [target.op_stage.current_organ] with \the [tool]." )
	..()

/datum/surgery_step/robotics/detatch_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has decoupled [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
	"<span class='notice'>You have decoupled [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

	var/obj/item/organ/internal/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.cut_away(user)

/datum/surgery_step/robotics/detatch_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
	"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

//////////////////////////////////////////////////////////////////
//	robotic organ transplant finalization surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/attach_organ_robotic
	allowed_tools = list(
		/obj/item/weapon/screwdriver = 100,
	)

	min_duration = 100
	max_duration = 120

/datum/surgery_step/robotics/attach_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && (affected.robotic >= ORGAN_ROBOT)))
		return 0
	if(affected.hatch < 3)
		return 0

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/obj/item/organ/I in affected.implants)
		if ((I.status & ORGAN_CUT_AWAY) && (I.robotic >= ORGAN_ROBOT) && (I.parent_organ == target_zone))
			removable_organs |= I.organ_tag

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return 0

	target.op_stage.current_organ = organ_to_replace
	return ..()

/datum/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
	"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
	..()

/datum/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
	"<span class='notice'>You have reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for (var/obj/item/organ/I in affected.implants)
		if (I.organ_tag == target.op_stage.current_organ)
			I.status &= ~ORGAN_CUT_AWAY
			affected.implants -= I
			I.replaced(target, affected)
			break

/datum/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
	"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

//////////////////////////////////////////////////////////////////
//	mmi installation surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/robotics/install_mmi
	allowed_tools = list(
	/obj/item/device/mmi = 100
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/robotics/install_mmi/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if(target_zone != BP_HEAD)
		return

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && affected.hatch == 3))
		return 0

	if(!istype(M))
		return 0

	if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
		to_chat(user, "<span class='danger'>That brain is not usable.</span>")
		return SURGERY_FAILURE

	if(!(affected.robotic >= ORGAN_ROBOT))
		to_chat(user, "<span class='danger'>You cannot install a computer brain into a meat torso.</span>")
		return SURGERY_FAILURE

	if(!target.should_have_organ(BP_BRAIN))
		to_chat(user, "<span class='danger'>You're pretty sure [target.species.name_plural] don't normally have a brain.</span>")
		return SURGERY_FAILURE

	if(!isnull(target.internal_organs[BP_BRAIN]))
		to_chat(user, "<span class='danger'>Your subject already has a brain.</span>")
		return SURGERY_FAILURE

	return 1

/datum/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
	"You start installing \the [tool] into [target]'s [affected.name].")
	..()

/datum/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has installed \the [tool] into [target]'s [affected.name].</span>", \
	"<span class='notice'>You have installed \the [tool] into [target]'s [affected.name].</span>")

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/internal/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	user.drop_from_inventory(tool)
	tool.forceMove(holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/datum/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips.</span>", \
	"<span class='warning'>Your hand slips.</span>")
