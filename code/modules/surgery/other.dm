//Procedures in this file: Internal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 Tendon fix surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/fix_tendon
	priority = 2
	allowed_tools = list(
	/obj/item/weapon/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75,	\
	/obj/item/weapon/tape_roll = 50
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90
	shock_level = 40
	delicate = 1

/datum/surgery_step/fix_tendon/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.status & ORGAN_TENDON_CUT) && affected.how_open() >= SURGERY_RETRACTED

/datum/surgery_step/fix_tendon/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool]." , \
	"You start reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!",100,affecting = affected)
	..()

/datum/surgery_step/fix_tendon/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool].</span>")
	affected.status &= ~ORGAN_TENDON_CUT
	affected.update_damages()

/datum/surgery_step/fix_tendon/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	affected.take_damage(5, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 IB fix surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/fix_vein
	priority = 3
	allowed_tools = list(
	/obj/item/weapon/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75,	\
	/obj/item/weapon/tape_roll = 50
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90
	shock_level = 40
	delicate = 1

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.status & ORGAN_ARTERY_CUT) && affected.how_open() >= SURGERY_RETRACTED

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts patching the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool]." , \
	"You start patching the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!",100,affecting = affected)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has patched the [affected.artery_name] in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have patched the [affected.artery_name] in [target]'s [affected.name] with \the [tool].</span>")
	affected.status &= ~ORGAN_ARTERY_CUT
	affected.update_damages()

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	affected.take_damage(5, used_weapon = tool)


//////////////////////////////////////////////////////////////////
//	 Hardsuit removal surgery step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/hardsuit
	allowed_tools = list(
		/obj/item/weapon/weldingtool = 80,
		/obj/item/weapon/circular_saw = 60,
		/obj/item/weapon/gun/energy/plasmacutter = 30
		)

	priority = 3
	can_infect = 0
	blood_level = 0
	core_skill = SKILL_EVA

	min_duration = 120
	max_duration = 180

/datum/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	if(isWelder(tool))
		var/obj/item/weapon/weldingtool/welder = tool
		if(!welder.isOn() || !welder.remove_fuel(1,user))
			return 0
	return (target_zone == BP_CHEST) && istype(target.back, /obj/item/weapon/rig) && !(target.back.canremove)

/datum/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." , \
	"You start cutting through the support systems of [target]'s [target.back] with \the [tool].")
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	var/obj/item/weapon/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message("<span class='notice'>[user] has cut through the support systems of [target]'s [rig] with \the [tool].</span>", \
		"<span class='notice'>You have cut through the support systems of [target]'s [rig] with \the [tool].</span>")

/datum/surgery_step/hardsuit/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='danger'>[user]'s [tool] can't quite seem to get through the metal...</span>", \
	"<span class='danger'>Your [tool] can't quite seem to get through the metal. It's weakening, though - try again.</span>")


//////////////////////////////////////////////////////////////////
//	 Disinfection step
//////////////////////////////////////////////////////////////////
/datum/surgery_step/sterilize
	priority = 2
	allowed_tools = list(
		/obj/item/weapon/reagent_containers/spray = 100,
		/obj/item/weapon/reagent_containers/dropper = 100,
		/obj/item/weapon/reagent_containers/glass/bottle = 90,
		/obj/item/weapon/reagent_containers/food/drinks/flask = 90,
		/obj/item/weapon/reagent_containers/glass/beaker = 75,
		/obj/item/weapon/reagent_containers/food/drinks/bottle = 75,
		/obj/item/weapon/reagent_containers/food/drinks/glass2 = 75,
		/obj/item/weapon/reagent_containers/glass/bucket = 50
	)

	can_infect = 0
	blood_level = 0

	min_duration = 50
	max_duration = 60

/datum/surgery_step/sterilize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!istype(affected))
		return 0
	if(affected.is_disinfected())
		return 0
	var/obj/item/weapon/reagent_containers/container = tool
	if(!istype(container))
		return 0
	if(!container.is_open_container())
		return 0
	var/datum/reagent/ethanol/booze = locate() in container.reagents.reagent_list
	if(istype(booze) && booze.strength >= 40)
		to_chat(user, "<span class='warning'>[booze] is too weak, you need something of higher proof for this...</span>")
		return 0
	if(!istype(booze) && !container.reagents.has_reagent(/datum/reagent/sterilizine))
		return 0
	return 1

/datum/surgery_step/sterilize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts pouring [tool]'s contents on \the [target]'s [affected.name]." , \
	"You start pouring [tool]'s contents on \the [target]'s [affected.name].")
	target.custom_pain("Your [affected.name] is on fire!",50,affecting = affected)
	..()

/datum/surgery_step/sterilize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/weapon/reagent_containers))
		return

	var/obj/item/weapon/reagent_containers/container = tool

	var/amount = container.amount_per_transfer_from_this
	var/temp_holder = new/obj()
	var/datum/reagents/temp_reagents = new(amount, temp_holder)
	container.reagents.trans_to_holder(temp_reagents, amount)

	var/trans = temp_reagents.trans_to_mob(target, temp_reagents.total_volume, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		user.visible_message("<span class='notice'>[user] rubs [target]'s [affected.name] down with \the [tool]'s contents</span>.", \
			"<span class='notice'>You rub [target]'s [affected.name] down with \the [tool]'s contents.</span>")
	affected.disinfect()
	qdel(temp_reagents)
	qdel(temp_holder)

/datum/surgery_step/sterilize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/weapon/reagent_containers))
		return

	var/obj/item/weapon/reagent_containers/container = tool

	container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message("<span class='warning'>[user]'s hand slips, spilling \the [tool]'s contents over the [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, spilling \the [tool]'s contents over the [target]'s [affected.name]!</span>")
	affected.disinfect()

