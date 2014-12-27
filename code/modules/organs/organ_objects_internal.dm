/obj/item/organ/internal
	name = "organ"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"

	var/datum/organ/internal/organ_data       // Stores info when removed.
	var/organ_type = /datum/organ/internal    // Used to spawn the relevant organ data when produced via a machine or spawn().
	var/prosthetic_icon                       // Icon for robotic organ.
	var/dead_icon                             // Icon used when the organ dies.

/obj/item/organ/internal/attack_self(mob/user as mob)

	// Convert it to an edible form, yum yum.
	if(!robotic && user.a_intent == "help" && user.zone_sel.selecting == "mouth")
		bitten(user)
		return

/obj/item/organ/internal/New()
	..()
	create_reagents(5)
	spawn(1)
		if(!organ_data)
			organ_data = new /datum/organ/internal()
		if(robotic)
			organ_data.robotic = robotic

// Brain is defined in brain_item.dm.
/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	prosthetic_name = "circulatory pump"
	prosthetic_icon = "heart-prosthetic"
	part = "heart"
	fresh = 6 // Juicy.
	dead_icon = "heart-off"

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	prosthetic_name = "gas exchange system"
	prosthetic_icon = "lungs-prosthetic"
	part = "lungs"

/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	prosthetic_name = "prosthetic kidneys"
	prosthetic_icon = "kidneys-prosthetic"
	part = "kidneys"

/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	prosthetic_name = "visual prosthesis"
	prosthetic_icon = "eyes-prosthetic"
	part = "eyes"

	var/eye_colour

/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	prosthetic_name = "toxin filter"
	prosthetic_icon = "liver-prosthetic"
	part = "liver"

/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	part = "appendix"

/obj/item/organ/internal/appendix
	name = "appendix"

/obj/item/organ/internal/proc/removed(var/mob/living/carbon/human/target,var/mob/living/user)

	if(!istype(target) || !organ_data)
		return

	target.internal_organs_by_name[part] = null
	target.internal_organs_by_name -= part
	target.internal_organs -= organ_data

	var/datum/organ/external/affected = target.get_organ(organ_data.parent_organ)
	affected.internal_organs -= organ_data

	loc = target.loc
	organ_data.rejecting = null
	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood || !organ_blood.data["blood_DNA"])
		target.vessel.trans_to(src, 5, 1, 1)

	if(target && user && organ_data.vital)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		target.death()

/obj/item/organ/internal/appendix/removed(var/mob/living/target,var/mob/living/user)

	..()

	var/inflamed = 0
	for(var/datum/disease/appendicitis/appendicitis in target.viruses)
		inflamed = 1
		appendicitis.cure()
		target.resistances += appendicitis

	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

/obj/item/organ/internal/die()
	..()
	if(dead_icon) icon_state = dead_icon

/obj/item/organ/internal/eyes/removed(var/mob/living/target,var/mob/living/user)

	if(!eye_colour)
		eye_colour = list(0,0,0)

	..() //Make sure target is set so we can steal their eye colour for later.
	var/mob/living/carbon/human/H = target
	if(istype(H))
		eye_colour = list(
			H.r_eyes ? H.r_eyes : 0,
			H.g_eyes ? H.g_eyes : 0,
			H.b_eyes ? H.b_eyes : 0
			)

		// Leave bloody red pits behind!
		H.r_eyes = 128
		H.g_eyes = 0
		H.b_eyes = 0
		H.update_body()

/obj/item/organ/internal/proc/replaced(var/mob/living/carbon/human/target,var/datum/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!transplant_blood)
		organ_data.transplant_data = list()
		organ_data.transplant_data["species"] =    target.species.name
		organ_data.transplant_data["blood_type"] = target.dna.b_type
		organ_data.transplant_data["blood_DNA"] =  target.dna.unique_enzymes
	else
		organ_data.transplant_data = list()
		organ_data.transplant_data["species"] =    transplant_blood.data["species"]
		organ_data.transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		organ_data.transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	organ_data.organ_holder = null
	organ_data.owner = target
	target.internal_organs |= organ_data
	affected.internal_organs |= organ_data
	target.internal_organs_by_name[part] = organ_data
	organ_data.status |= ORGAN_CUT_AWAY

	del(src)

/obj/item/organ/internal/eyes/replaced(var/mob/living/carbon/human/target)

	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.r_eyes = eye_colour[1]
		target.g_eyes = eye_colour[2]
		target.b_eyes = eye_colour[3]
		target.update_body()
	..()

/obj/item/organ/internal/proc/bitten(mob/user)

	if(robotic)
		return

	user << "\blue You take an experimental bite out of \the [src]."
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)


	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon_state = dead_icon ? dead_icon : icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints) O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden) O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast) O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	del(src)