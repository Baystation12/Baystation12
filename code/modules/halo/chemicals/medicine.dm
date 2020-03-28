#define BIOFOAM_COST_STOPBLEED 0.5
#define BIOFOAM_COST_MENDBONE 1.5
#define BIOFOAM_COST_MENDINTERNAL 1
#define BIOFOAM_COST_MENDEXTERNAL 0.75
#define BIOFOAM_COST_FIXWOUNDS 0.25
#define BIOFOAM_COST_REMOVESHRAP 2

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
	metabolism = 1 //Biofoam is used quickly, and it uses more the more it does.
	overdose = 10 //Very careful with biofoam, don't want expansion into your lungs, do we now?
	scannable = 1
	flags = AFFECTS_DEAD

/datum/reagent/biofoam/proc/check_and_consume_cost(var/cost)
	if(volume >= cost)
		holder.remove_reagent("biofoam",cost)
		return 1
	else
		return 0

/datum/reagent/biofoam/proc/check_and_stop_bleeding(var/obj/item/organ/external/o)
	if(o.status & ORGAN_BLEEDING || o.status & ORGAN_ARTERY_CUT && istype(o) && check_and_consume_cost(BIOFOAM_COST_STOPBLEED))
		o.status &= ~ORGAN_ARTERY_CUT
		o.status &= ~ORGAN_BLEEDING
		o.clamp_organ()
		o.update_damages()
		to_chat(o.owner,"<span class = 'notice'>You feel the biofoam stop the bleeding in your [o.name]</span>")

/datum/reagent/biofoam/proc/mend_external(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/o in H.organs)
		check_and_stop_bleeding(o)
		if(o.brute_dam + o.burn_dam >= o.min_bruised_damage && check_and_consume_cost(BIOFOAM_COST_MENDEXTERNAL))
			o.heal_damage(o.min_bruised_damage,o.min_bruised_damage)
			to_chat(H,"<span class = 'notice'>You feel your [o.name] knitting itself back together</span>")
		if(o.status & ORGAN_BROKEN && check_and_consume_cost(BIOFOAM_COST_MENDBONE))
			o.mend_fracture()
			H.next_pain_time = world.time //Overrides the next pain timer
			H.custom_pain("<span class = 'userdanger'>You feel the bones in your [o.name] being pushed into place.</span>",10)

/datum/reagent/biofoam/proc/mend_internal(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/I in H.internal_organs)
		check_and_stop_bleeding(I)
		if(I.damage >= I.min_bruised_damage && check_and_consume_cost(BIOFOAM_COST_MENDINTERNAL))
			I.damage -= I.min_bruised_damage
			to_chat(H,"<span class = 'notice'>You feel your [I.name] knitting itself back together</span>")

/datum/reagent/biofoam/proc/fix_wounds(var/mob/living/carbon/human/H)
	for(var/obj/item/organ/external/o in H.organs)
		for(var/wounds in o.wounds)
			var/datum/wound/W = wounds
			if(W.bleed_timer > 0 && check_and_consume_cost(BIOFOAM_COST_FIXWOUNDS))
				W.bleed_timer = 0
				to_chat(o.owner,"<span class = 'notice'>You feel the bleeding in your [o.name] slow, then stop.</span>")
				W.bandaged = 1
				W.salved = 1
				o.update_damages()

/datum/reagent/biofoam/proc/remove_embedded(var/mob/living/carbon/human/M)
	for(var/obj/item/organ/external/o in M.bad_external_organs)
		for(var/datum/wound/w in o.wounds)
			for(var/obj/embedded in w.embedded_objects)
				if(!check_and_consume_cost(BIOFOAM_COST_REMOVESHRAP))
					continue
				o.implants -= selection

				w.embedded_objects -= embedded //Removing the embedded item from the wound
				M.embedded -= embedded
				M.pinned -= embedded
				if(M.pinned.len == 0)
					M.anchored = 0
				M.contents -= embedded
				embedded.forceMove(get_turf(M))//And placing it on the ground below
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

/datum/reagent/hyperzine_concentrated
	name = "Concentrated Hyperzine"
	description = "A long-lasting, powerful muscle stimulant. A concentrated version of Hyperzine, forgoing safety to provide a considerable boost the the user's speed and reaction time."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = 5 //Should be administered in low doses at the time it's needed, not held in system

/datum/reagent/hyperzine_concentrated/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(H.internal_organs_by_name[BP_LIVER])
		var/obj/item/organ/user_liver = H.internal_organs_by_name[BP_LIVER]
		user_liver.take_damage(1,1)
	H.adjustToxLoss(1)
	if(prob(10))
		H.emote(pick("twitch", "blink_r", "shiver"))
	H.add_chemical_effect(CE_SPEEDBOOST, 1)
	H.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/hyperzine_concentrated/affect_blood/overdose(var/mob/living/carbon/human/H)
	holder.remove_reagent("hyperzine_concentrated",volume)
	H.adjustToxLoss(50)
	. = ..()
/datum/reagent/cryoprethaline
	name = "Cryoprethaline"
	description = "A cellular ice crystal formation inhibitor. Protects from the extreme cold of cryostasis"
	taste_description = "lemon-lime"
	reagent_state = LIQUID
	color = "#DCD9CD"
	overdose = 5 //Extremely toxic
	scannable = 1

/datum/reagent/cryoprethaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/human))
		M.add_chemical_effect(CE_CRYO, 3)

/datum/reagent/cryoprethaline/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/human))
		M.adjustFireLoss(removed)
		if(prob(5))
			to_chat(M,"<span class='userdanger'>Your skin feels like it's on fire!</span>")

/datum/reagent/cryoprethaline/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/human))
		M.adjustToxLoss(5 * removed)
		M.emote("vomit")

/datum/reagent/cryoprethaline/overdose(var/mob/living/carbon/M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/L = H.internal_organs_by_name[BP_LUNGS]
		if(L)
			if(prob(90))
				L.take_damage(2)
				if(prob(15))
					H.emote("cough")
		H.adjustToxLoss(5)

/datum/reagent/hexaline
	name = "Hexaline Glycol"
	description = "A slighly less toxic, but less effective, cryoprotectant."
	taste_description = "sweetness"
	reagent_state = LIQUID
	color = "#DCD9CD"
	overdose = 5 //Same overdose as cryoprethaline, but does less harm
	scannable = 1

/datum/reagent/hexaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/human))
		M.add_chemical_effect(CE_CRYO, 1)

/datum/reagent/hexaline/overdose(var/mob/living/carbon/M)
	if(istype(M, /mob/living/carbon/human))
		M.adjustToxLoss(1)

/datum/reagent/ketoprofen
	name = "Ketoprofen"
	description = "An anti-pyretic and painkiller"
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#C8A5DC"
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE

/datum/reagent/ketoprofen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 40)
	M.add_chemical_effect(CE_CRYO, -1)

	var/target = 310 //Target body temperature
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.body_temperature)
			target = H.species.body_temperature //Target the species optimal body temperature - if one exists

	if(M.bodytemperature > target)
		M.bodytemperature = max(target, M.bodytemperature - (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //A bit better than leporazine