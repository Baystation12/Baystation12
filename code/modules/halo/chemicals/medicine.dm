
#define BIOFOAM_PROB_REMOVE_EMBEDDED 30
#define BIOFOAM_PROB_OVERDOSE_DAMAGING 35
#define BIOFOAM_PROB_OVERDOSE_WARNING 50

/datum/reagent/triadrenaline
	name = "Tri-Adrenaline"
	description = "An extremely powerful synthetic stimulant. Capable of restarting a human heart."
	reagent_state = LIQUID
	color = "#00BFFF" //Same as inaprovaline because why not!
	metabolism = 0.2
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = AFFECTS_DEAD

/datum/reagent/triadrenaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustOxyLoss(-300 * removed)
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		//Ports and simplifies defib code
		if(H.stat != DEAD)
			if(H.ssd_check())
				to_chat(find_dead_player(H.ckey, 1), "Return to your body to be revived!")
				sleep(100)

			H.resuscitate()
			holder.remove_reagent("triadrenaline", dose)
			//log_and_message_admins("Tri-adrenaline used to revive [key_name(H)]")

/datum/reagent/triadrenaline/overdose(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/heart/O = H.internal_organs_by_name["heart"]
	if(O && prob(15))
		O.damage += 300 //Your heart exploded poor you
		holder.remove_reagent("triadrenaline", dose/2)
		to_chat(H,"You feel a sudden stabbing pain in your chest")
	else if(prob(25))
		to_chat(H,"You feel your heart thundering in your chest")
		O.pulse = PULSE_2FAST //This can actually cause heart damage now

/datum/reagent/biofoam
	name = "Bio-Foam"
	description = "A regenerative foaming agent which is capable of fixing bones and stopping bleeding"
	reagent_state = LIQUID
	color = "#edd9c0"
	metabolism = 1 //Biofoam is used very quickly
	overdose = 10 //Very careful with biofoam, don't want expansion into your lungs, do we now?
	scannable = 1
	flags = AFFECTS_DEAD

/datum/reagent/biofoam/proc/check_and_stop_bleeding(var/obj/item/organ/external/o)
	if(o.status & ORGAN_BLEEDING)
		if(istype(o))
			o.clamp()
			o.update_damages()
			to_chat(o.owner,"<span class = 'notice'>You feel the biofoam stop the bleeding in your [o.name]</span>")

/datum/reagent/biofoam/proc/mend_external(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/o in H.organs)
		if(o.brute_dam + o.burn_dam >= o.min_bruised_damage)
			o.brute_dam -= o.min_bruised_damage
			o.burn_dam -= o.min_bruised_damage
			if(prob(20))
				to_chat(H,"<span class = 'notice'>You feel your [o.name] knitting itself back together</span>")
		if(o.status & ORGAN_BROKEN)
			o.status &= ~ORGAN_BROKEN
			H.next_pain_time = world.time //Overrides the next pain timer
			H.custom_pain("<span class = 'userdanger'>You feel the bones in your [o.name] being pushed into place.</span>",10)
			check_and_stop_bleeding(o)

/datum/reagent/biofoam/proc/mend_internal(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/I in H.internal_organs)
		check_and_stop_bleeding(I)
		if(I.damage >= I.min_bruised_damage)
			I.damage -= I.min_bruised_damage
			if(prob(20))
				to_chat(H,"<span class = 'notice'>You feel your [I.name] knitting itself back together</span>")

/datum/reagent/biofoam/proc/fix_wounds(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/o in H.organs)
		for(var/wounds in o.wounds)
			var/datum/wound/W = wounds
			if(W.bleed_timer > 0)
				W.bleed_timer = 0
				to_chat(o.owner,"<span class = 'notice'>You feel the bleeding in your [o.name] slow, then stop.</span>")
				W.bandaged = 1
				W.salved = 1
				o.update_damages()

/datum/reagent/biofoam/proc/remove_embedded(var/mob/living/carbon/human/M)
	for(var/obj/item/organ/external/o in M.bad_external_organs)
		for(var/datum/wound/w in o.wounds)
			for(var/obj/embedded in w.embedded_objects)
				if(!prob(BIOFOAM_PROB_REMOVE_EMBEDDED))
					continue
				w.embedded_objects -= embedded //Removing the embedded item from the wound
				embedded.loc = M.loc //And placing it on the ground below
				to_chat(M,"<span class = 'notice'>The [embedded.name] is pushed out of the [w.desc] in your [o.name].</span>")



/datum/reagent/biofoam/affect_blood(var/mob/living/carbon/M,var/alien,var/removed) //Biofoam stops internal and external bleeding, heals organs and fixes bones.
	if(istype(M,/mob/living/carbon/human))
		M.custom_pain("You feel a searing pain in your veins",3)
		remove_embedded(M)
		fix_wounds(M)
		mend_external(M)
		mend_internal(M)
		spawn(5)
			M.add_chemical_effect(CE_PAINKILLER, 5)

/datum/reagent/biofoam/overdose(var/mob/living/carbon/M)
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(prob(BIOFOAM_PROB_OVERDOSE_DAMAGING))
			for(var/o in H.internal_organs)
				var/obj/item/organ/O = o
				var/dam = rand((O.min_bruised_damage*0.5) ,(O.min_broken_damage*1.5))
				O.damage += dam
				if(dam < O.min_broken_damage)
					dam = 0
				else
					dam = 1
				to_chat(M,"<span class ='userdanger'>You feel [dam ? "your [O.name] collapse" : "immense pressure on your [O.name]" ].</span>")
			holder.remove_reagent("biofoam",volume)
		else if (prob(BIOFOAM_PROB_OVERDOSE_WARNING))
			var/obj/item/organ/O = pick(H.internal_organs)
			to_chat(M,"<span class ='danger'>You feel your [O.name] being crushed.</span>")

/datum/reagent/hyperzine_concentrated
	name = "Concentrated Hyperzine"
	description = "A long-lasting, powerful muscle stimulant. A concentrated version of Hyperzine, forgoing safety to provide a considerable boost the the user's speed and reaction time."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/hyperzine_concentrated/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(H.internal_organs_by_name[BP_LIVER])
		var/obj/item/organ/user_liver = H.internal_organs_by_name[BP_LIVER]
		user_liver.take_damage(1,1)
	H.adjustToxLoss(2)
	if(prob(5))
		H.emote(pick("twitch", "blink_r", "shiver"))
	H.add_chemical_effect(CE_SPEEDBOOST, 1)
	H.add_chemical_effect(CE_PULSE, 2)
