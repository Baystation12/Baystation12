/datum/surgery/eye_surgery
	name = "eye surgery"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/fix_eyes, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	location = "eyes"


//fix eyes
/datum/surgery_step/fix_eyes
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/screwdriver = 45, /obj/item/weapon/pen = 25)
	time = 64

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to fix [target]'s eyes.</span>")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] successfully fixes [target]'s eyes!</span>")
	target.sdisabilities &= ~BLIND
	target.disabilities &= ~NEARSIGHTED
	target.eye_blurry = 35	//this will fix itself slowly.
	target.eye_stat = 0

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(getbrain(target))
		user.visible_message("<span class='warning'>[user] accidentally stabs [target] right in the brain!</span>")
		target.adjustBrainLoss(100)
	else
		user.visible_message("<span class='warning'>[user] accidentally stabs [target] right in the brain! Or would have, if [target] had a brain.</span>")