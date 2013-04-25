/datum/surgery/brain_removal
	name = "brain removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/extract_brain, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	location = "head"


//extract brain
/datum/surgery_step/extract_brain
	implements = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/crowbar = 55)
	time = 64
	var/obj/item/organ/brain/B = null

/datum/surgery_step/extract_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	B = getbrain(target)
	if(B)
		user.visible_message("<span class='notice'>[user] begins to extract [target]'s brain.</span>")
	else
		user.visible_message("<span class='notice'>[user] looks for an brain in [target].</span>")

/datum/surgery_step/extract_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(B)
		user.visible_message("<span class='notice'>[user] successfully removes [target]'s brain!</span>")
		B.loc = get_turf(target)
		B.transfer_identity(target)
		target.internal_organs -= B
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [target.name] ([target.ckey]) INTENT: [uppertext(user.a_intent)])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		log_attack("<font color='red'>[user.name] ([user.ckey]) debrained [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)])</font>")
	else
		user.visible_message("<span class='notice'>[user] can't find an brain in [target]!</span>")