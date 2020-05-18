//Procedures in this file: Slime surgery, core extraction.
//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic slime surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime

/decl/surgery_step/slime/is_valid_target(mob/living/carbon/slime/target)
	return isslime(target)

/decl/surgery_step/slime/assess_bodypart(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return TRUE

/decl/surgery_step/slime/assess_surgery_candidate(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return isslime(target) && target.stat == DEAD

/decl/surgery_step/slime/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return list(SKILL_SCIENCE = SKILL_ADEPT)

//////////////////////////////////////////////////////////////////
//	slime flesh cutting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/cut_flesh
	name = "Make incision in slime"
	allowed_tools = list(
		/obj/item/weapon/scalpel = 100,
		/obj/item/weapon/material/knife = 75,
		/obj/item/weapon/material/shard = 50
	)
	min_duration = 5
	max_duration = 2 SECONDS

/decl/surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 0

/decl/surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
	"You start cutting through [target]'s flesh with \the [tool].")

/decl/surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cuts through [target]'s flesh with \the [tool].</span>",	\
	"<span class='notice'>You cut through [target]'s flesh with \the [tool], revealing its silky innards.</span>")
	target.core_removal_stage = 1

/decl/surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s flesh with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing [target]'s flesh with \the [tool]!</span>")

//////////////////////////////////////////////////////////////////
//	slime innards cutting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/cut_innards
	name = "Dissect innards"
	allowed_tools = list(
		/obj/item/weapon/scalpel = 100,
		/obj/item/weapon/material/knife = 75,
		/obj/item/weapon/material/shard = 50
	)
	min_duration = 5
	max_duration = 2 SECONDS

/decl/surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 1

/decl/surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
	"You start cutting [target]'s silky innards apart with \the [tool].")

/decl/surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cuts [target]'s innards apart with \the [tool], exposing the cores.</span>",	\
	"<span class='notice'>You cut [target]'s innards apart with \the [tool], exposing the cores.</span>")
	target.core_removal_stage = 2

/decl/surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s innards with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing [target]'s innards with \the [tool]!</span>")

//////////////////////////////////////////////////////////////////
//	slime core removal surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/saw_core
	name = "Remove slime core"
	allowed_tools = list(
		/obj/item/weapon/scalpel/manager = 100,
		/obj/item/weapon/circular_saw = 100,
		/obj/item/weapon/material/knife = 75,
		/obj/item/weapon/material/hatchet = 75
	)
	min_duration = 1 SECOND
	max_duration = 3 SECONDS

/decl/surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

/decl/surgery_step/slime/saw_core/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting out one of [target]'s cores with \the [tool].", \
	"You start cutting out one of [target]'s cores with \the [tool].")

/decl/surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message("<span class='notice'>[user] cuts out one of [target]'s cores with \the [tool].</span>",,	\
	"<span class='notice'>You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left.</span>")
	if(target.cores >= 0)
		var/coreType = target.GetCoreType()
		new coreType(target.loc)
	if(target.cores <= 0)
		target.icon_state = "[target.colour] baby slime dead-nocore"

/decl/surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, causing \him to miss the core!</span>", \
	"<span class='warning'>Your hand slips, causing you to miss the core!</span>")
