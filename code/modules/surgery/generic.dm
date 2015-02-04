//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic/
	can_infect = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (isslime(target))
			return 0
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		if (target_zone == "head" && target.species && (target.species.flags & IS_SYNTHETIC))
			return 1
		if (affected.status & ORGAN_ROBOT)
			return 0
		return 1

/datum/surgery_step/generic/cut_open
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		 \
	/obj/item/weapon/kitchenknife = 75,	 \
	/obj/item/weapon/shard = 50, 		 \
	/obj/item/weapon/circular_saw = 100, \
	/obj/item/weapon/weldingtool = 100
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		//user.visible_message(
		//	"[user] starts cutting into [target]'s [affected] with \the [tool].", \
		//	"You start cutting into [target]'s [affected] with \the [tool].")
		//target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		//user.visible_message("<span class='notice'>[user] has cut on through the [tissue_cut_string] of [target]'s [affected] with \the [tool].</span>", \
		//"<span class='notice'>You have cut through the [tissue_cut_string] of [target]'s [affected] with \the [tool].</span>",)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips, cutting open [target]'s [affected] in the wrong place with \the [tool]!</span>", \
		"<span class='danger'>Your hand slips, slicing open [target]'s [affected] in the wrong place with \the [tool]!</span>")
		affected.take_damage(10, 0, 1, 1)


/datum/surgery_step/generic/retract
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		//user.visible_message("[user] starts to pry open \the [target]'s [affected] with \the [tool].", \
		//"You start to pry open \the [target]'s [affected] with \the [tool].")
		//target.custom_pain("It feels like your [affected] is on fire!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		//user.visible_message("<span class='notice'>[user] pries open the [tissue_cut_string] of [target]'s [affected] with \the [tool].</span>", \
		//"<span class='notice'>You have pried open the [tissue_cut_string] of [target]'s [affected] with \the [tool].</span>",)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected] with \the [tool]!</span>", \
		"<span class='danger'>Your hand slips, tearing the edges of the incision on [target]'s [affected] with \the [tool]!</span>")
		affected.take_damage(12, 0, 1, 1)

/datum/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected.is_open() && (affected.status & ORGAN_BLEEDING)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts clamping bleeders in [target]'s [affected] with \the [tool].", \
		"You start clamping bleeders in [target]'s [affected] with \the [tool].")
		target.custom_pain("The pain in your [affected] is maddening!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] clamps bleeders in [target]'s [affected] with \the [tool].",	\
		"\blue You clamp bleeders in [target]'s [affected] with \the [tool].")
		spread_germs_to_organ(affected, user)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected] with \the [tool]!",	\
		"\red Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected] with \the [tool]!",)
		affected.take_damage(10, 0, 1, 1)

/datum/surgery_step/generic/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected.is_open() && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s [affected] with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s [affected] with \the [tool].")
		target.custom_pain("Your [affected] is being burned!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s [affected] with \the [tool].</span>", \
		"<span class='notice'>You cauterize the incision on [target]'s [affected] with \the [tool].</span>")
		//affected.is_open() = 0
		affected.germ_level = 0
		affected.status &= ~ORGAN_BLEEDING

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, leaving a small burn on [target]'s [affected] with \the [tool]!", \
		"\red Your hand slips, leaving a small burn on [target]'s [affected] with \the [tool]!")
		target.apply_damage(3, BURN, affected)

/*
	Fix rigid layers

	/obj/item/weapon/bonegel
	/obj/item/weapon/bonesetter
	/obj/item/weapon/bonegel

	Success:
		affected.status &= ~ORGAN_BROKEN
		affected.status &= ~ORGAN_SPLINTED
		affected.stage = 0
		affected.perma_injury = 0

	Cockup:
		affected.fracture()
		h.createwound(BRUISE, 10)
		h.disfigured = 1
*/