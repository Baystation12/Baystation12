/datum/ailment/head
	category = /datum/ailment/head
	applies_to_organ = list(BP_HEAD)

/datum/ailment/head/headache
	name = "headache"
	treated_by_reagent_type = /datum/reagent/paracetamol
	treated_by_reagent_dosage = 1
	medication_treatment_message = "Your headache grudgingly fades away."

/datum/ailment/head/headache/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your [organ.name] pulses with a sudden headache."))
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 5)
		E.add_pain(5)

/datum/ailment/head/tinnitus
	name = "tinnitus"
	treated_by_reagent_type = /datum/reagent/bicaridine
	treated_by_reagent_dosage = 1
	medication_treatment_message = "The high-pitched ringing in your ears slowly fades to nothing."

/datum/ailment/head/tinnitus/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your ears ring with an irritating, high-pitched tone."))
	organ.owner.ear_deaf = max(organ.owner.ear_deaf,15)	//This feels fucked

/datum/ailment/head/sore_throat
	name = "sore throat"
	treated_by_reagent_type = /datum/reagent/menthol
	treated_by_reagent_dosage = 1
	medication_treatment_message = "You swallow, finding that your sore throat is rapidly recovering."
	diagnosis_string = "$USER_HIS$ throat is red and inflamed."

/datum/ailment/head/sore_throat/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("You swallow painfully past your sore throat."))

/datum/ailment/head/sneezing
	name = "sneezing"
	treated_by_reagent_type = /datum/reagent/synaptizine	//Original chemical was space cleaner, replace if you have a better solution
	treated_by_reagent_dosage = 1
	medication_treatment_message = "The itching in your sinuses fades away."
	diagnosis_string = "$USER_HIS$ sinuses are inflamed and running."

/datum/ailment/head/sneezing/can_apply_to(obj/item/organ/_organ)
	. = ..()
	if(. && (!_organ.owner || !_organ.owner.usable_emotes["sneeze"]))
		return FALSE

/datum/ailment/head/sneezing/on_ailment_event()
	if(organ.owner.usable_emotes["sneeze"])
		organ.owner.emote("sneeze")
	organ.owner.setClickCooldown(3)

/datum/ailment/sprain
	name = "sprained limb"
	applies_to_organ = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	treated_by_item_type = /obj/item/stack/medical/bruise_pack
	third_person_treatement_message = "$USER$ wraps $TARGET$'s sprained $ORGAN$ in $ITEM$."
	self_treatement_message = "$USER$ wraps $USER_HIS$ sprained $ORGAN$ in $ITEM$."
	diagnosis_string = "$USER_HIS$ $ORGAN$ is visibly swollen."

/datum/ailment/sprain/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your sprained [organ.name] aches distractingly."))
	organ.owner.setClickCooldown(3)
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 3)
		E.add_pain(3)

/datum/ailment/rash
	name = "rash"
	treated_by_item_type = /obj/item/stack/medical/ointment
	third_person_treatement_message = "$USER$ salves $TARGET$'s rash-stricken $ORGAN$ with $ITEM$."
	self_treatement_message = "$USER$ salves $USER_HIS$ rash-stricken $ORGAN$ with $ITEM$."
	diagnosis_string = "$USER_HIS$ $ORGAN$ is covered in a bumpy red rash."

/datum/ailment/rash/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("A bright red rash on your [organ.name] itches distractingly."))
	organ.owner.setClickCooldown(3)

/datum/ailment/coughing
	name = "coughing"
	specific_organ_subtype = /obj/item/organ/internal/lungs
	applies_to_organ = list(BP_LUNGS)
	treated_by_reagent_type = /datum/reagent/water
	medication_treatment_message = "The tickling in your throat fades away."
	diagnosis_string = "$USER_HIS$ throat is red and inflamed."

/datum/ailment/coughing/can_apply_to(obj/item/organ/_organ)
	. = ..()
	if(. && (!_organ.owner || !_organ.owner.usable_emotes["cough"]))
		return FALSE

/datum/ailment/coughing/on_ailment_event()
	if(organ.owner.usable_emotes["cough"])
		organ.owner.emote("cough")
	organ.owner.setClickCooldown(3)

/datum/ailment/sore_joint
	name = "sore joint"
	treated_by_reagent_type = /datum/reagent/paracetamol
	medication_treatment_message = "The dull pulse of pain in your $ORGAN$ fades away."
	diagnosis_string = "$USER_HIS$ $ORGAN$ is visibly swollen."

/datum/ailment/sore_joint/on_ailment_event()
	var/obj/item/organ/external/E = organ
	to_chat(organ.owner, SPAN_DANGER("Your [istype(E) ? E.joint : organ.name] aches uncomfortably."))
	organ.owner.setClickCooldown(3)
	if(istype(E) && E.pain < 3)
		E.add_pain(3)

/datum/ailment/sore_joint/can_apply_to(obj/item/organ/_organ)
	var/obj/item/organ/external/E = _organ
	. = ..() && !isnull(E.joint) && E.dislocated > -1

/datum/ailment/sore_back
	name = "sore back"
	applies_to_organ = list(BP_CHEST)
	treated_by_reagent_type = /datum/reagent/paracetamol
	medication_treatment_message = "You straighten, finding that your back is no longer hurting."

/datum/ailment/sore_back/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your back spasms painfully, causing you to hunch for a moment."))
	organ.owner.setClickCooldown(3)

/datum/ailment/stomach_ache
	name = "stomach ache"
	specific_organ_subtype = /obj/item/organ/internal/stomach
	applies_to_organ = list(BP_STOMACH)
	treated_by_reagent_type = /datum/reagent/carbon
	medication_treatment_message = "The nausea in your $ORGAN$ slowly fades away."

/datum/ailment/stomach_ache/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your stomach roils unpleasantly."))
	organ.owner.setClickCooldown(3)

/datum/ailment/cramps
	name = "cramps"
	treated_by_reagent_type = /datum/reagent/paracetamol
	medication_treatment_message = "The painful cramping in your $ORGAN$ relaxes."

/datum/ailment/cramps/on_ailment_event()
	to_chat(organ.owner, SPAN_DANGER("Your [organ.name] suddenly clenches in a painful cramp."))
	organ.owner.setClickCooldown(3)
	var/obj/item/organ/external/E = organ
	if(istype(E) && E.pain < 3)
		E.add_pain(3)
