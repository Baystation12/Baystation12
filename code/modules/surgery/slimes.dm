//Procedures in this file: Slime surgery, core extraction.
//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic slime surgery step datum
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/slime

/singleton/surgery_step/slime/is_valid_target(mob/living/carbon/slime/target)
	return isslime(target)

/singleton/surgery_step/slime/assess_bodypart(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return TRUE

/singleton/surgery_step/slime/assess_surgery_candidate(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return isslime(target) && target.stat == DEAD

/singleton/surgery_step/slime/get_skill_reqs(mob/living/user, mob/living/carbon/human/target, obj/item/tool)
	return list(SKILL_SCIENCE = SKILL_TRAINED)

//////////////////////////////////////////////////////////////////
//	slime flesh cutting surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/slime/cut_flesh
	name = "Make incision in slime"
	allowed_tools = list(
		/obj/item/scalpel/basic = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50
	)
	min_duration = 5
	max_duration = 2 SECONDS

/singleton/surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 0

/singleton/surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
	"You start cutting through [target]'s flesh with \the [tool].")
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)

/singleton/surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] cuts through [target]'s flesh with \the [tool]."),	\
	SPAN_NOTICE("You cut through [target]'s flesh with \the [tool], revealing its silky innards."))
	target.core_removal_stage = 1

/singleton/surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing [target]'s flesh with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, tearing [target]'s flesh with \the [tool]!"))

//////////////////////////////////////////////////////////////////
//	slime innards cutting surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/slime/cut_innards
	name = "Dissect innards"
	allowed_tools = list(
		/obj/item/scalpel/basic = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50
	)
	min_duration = 5
	max_duration = 2 SECONDS

/singleton/surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 1

/singleton/surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
	"You start cutting [target]'s silky innards apart with \the [tool].")
	playsound(target.loc, 'sound/items/scalpel.ogg', 50, TRUE)

/singleton/surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] cuts [target]'s innards apart with \the [tool], exposing the cores."),	\
	SPAN_NOTICE("You cut [target]'s innards apart with \the [tool], exposing the cores."))
	target.core_removal_stage = 2

/singleton/surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing [target]'s innards with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, tearing [target]'s innards with \the [tool]!"))

//////////////////////////////////////////////////////////////////
//	slime flesh & innards laser cutting surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/slime/cut_laser
	name = "Make laser incision in slime"
	allowed_tools = list(
		/obj/item/scalpel/laser = 100,
		/obj/item/scalpel/ims = 100
	)
	min_duration = 1 SECOND
	max_duration = 2 SECONDS

/singleton/surgery_step/slime/cut_laser/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage < 2

/singleton/surgery_step/slime/cut_laser/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts slicing through to the [target]'s silky innards apart with \the [tool].", \
	"You start slicing through to the [target]'s silky innards apart with \the [tool].")
	playsound(target.loc, 'sound/items/cautery.ogg', 50, TRUE)

/singleton/surgery_step/slime/cut_laser/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] slices [target]'s innards apart with \the [tool], exposing the cores."),	\
	SPAN_NOTICE("You slice [target]'s innards apart with \the [tool], exposing the cores."))
	target.core_removal_stage = 2

/singleton/surgery_step/slime/cut_laser/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing [target]'s innards with \the [tool]!"), \
	SPAN_WARNING("Your hand slips, searing [target]'s innards with \the [tool]!"))

//////////////////////////////////////////////////////////////////
//	slime core removal surgery step
//////////////////////////////////////////////////////////////////
/singleton/surgery_step/slime/saw_core
	name = "Remove slime core"
	allowed_tools = list(
		/obj/item/scalpel/ims = 100,
		/obj/item/circular_saw = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/hatchet = 75
	)
	min_duration = 1 SECOND
	max_duration = 3 SECONDS

/singleton/surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

/singleton/surgery_step/slime/saw_core/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting out one of [target]'s cores with \the [tool].", \
	"You start cutting out one of [target]'s cores with \the [tool].")
	playsound(target.loc, 'sound/items/circularsaw.ogg', 50, TRUE)

/singleton/surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message(SPAN_NOTICE("[user] cuts out one of [target]'s cores with \the [tool]."),,	\
	SPAN_NOTICE("You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left."))
	if(target.cores >= 0)
		var/coreType = target.GetCoreType()
		new coreType(target.loc)
	if(target.cores <= 0)
		target.icon_state = "[target.colour] baby slime dead-nocore"

/singleton/surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	user.visible_message(SPAN_WARNING("[user]'s hand slips, causing [pronouns.him] to miss the core!"), \
	SPAN_WARNING("Your hand slips, causing you to miss the core!"))
