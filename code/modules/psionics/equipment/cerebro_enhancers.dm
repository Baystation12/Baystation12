//Psi-boosting item (antag only)
/obj/item/clothing/head/helmet/space/psi_amp
	name = "cerebro-energetic enhancer"
	desc = "A matte-black, eyeless cerebro-energetic enhancement helmet. It uses highly sophisticated, and illegal, techniques to drill into your brain and install psi-infected AIs into the fluid cavities between your lobes."
	action_button_name = "Install Boosters"
	icon_state = "cerebro"

	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)

	var/operating = FALSE
	var/list/boosted_faculties
	var/boosted_rank = PSI_RANK_PARAMOUNT
	var/unboosted_rank = PSI_RANK_MASTER
	var/max_boosted_faculties = 3
	var/boosted_psipower = 120

/obj/item/clothing/head/helmet/space/psi_amp/lesser
	name = "psionic amplifier"
	desc = "A crown-of-thorns cerebro-energetic enhancer that interfaces directly with the brain, isolating and strengthening psionic signals. It kind of looks like a tiara having sex with an industrial robot."
	icon_state = "amp"
	flags_inv = 0
	body_parts_covered = 0

	max_boosted_faculties = 1
	boosted_rank = PSI_RANK_MASTER
	unboosted_rank = PSI_RANK_OPERANT
	boosted_psipower = 50

/obj/item/clothing/head/helmet/space/psi_amp/Initialize()
	. = ..()
	verbs += /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate

/obj/item/clothing/head/helmet/space/psi_amp/attack_self(var/mob/user)

	if(operating)
		return

	if(!canremove)
		deintegrate()
		return

	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.head == src)
		integrate()
		return

	var/choice = input("Select a brainboard to install or remove.","Psionic Amplifier") as null|anything in SSpsi.faculties_by_name
	if(!choice)
		return

	var/removed
	var/slots_left = max_boosted_faculties - LAZYLEN(boosted_faculties)
	var/decl/psionic_faculty/faculty = SSpsi.get_faculty(choice)
	if(faculty.id in boosted_faculties)
		LAZYREMOVE(boosted_faculties, faculty.id)
		removed = TRUE
	else
		if(slots_left <= 0)
			to_chat(user, SPAN_WARNING("There are no slots left to install brainboards into."))
			return
		LAZYADD(boosted_faculties, faculty.id)
	UNSETEMPTY(boosted_faculties)

	slots_left = max_boosted_faculties - LAZYLEN(boosted_faculties)
	to_chat(user, SPAN_NOTICE("You [removed ? "remove" : "install"] the [choice] brainboard [removed ? "from" : "in"] \the [src]. There [slots_left!=1 ? "are" : "is"] [slots_left] slot\s left."))

/obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate()

	set name = "Remove Psi-Amp"
	set desc = "Enhance your brainpower."
	set category = "Abilities"
	set src in usr

	if(operating)
		return

	if(canremove)
		return

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.head != src)
		canremove = TRUE
		return

	to_chat(H, SPAN_WARNING("You feel a strange tugging sensation as \the [src] begins removing the slave-minds from your brain..."))
	playsound(H, 'sound/weapons/circsawhit.ogg', 50, 1, -1)
	operating = TRUE

	sleep(80)

	if(H.psi) 
		H.psi.reset()

	to_chat(H, SPAN_NOTICE("\The [src] chimes quietly as it finishes removing the slave-minds from your brain."))

	canremove = TRUE
	operating = FALSE

	verbs -= /obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate
	verbs |= /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate

	action_button_name = "Integrate Psionic Amplifier"
	H.update_action_buttons()

	set_light(0)

/obj/item/clothing/head/helmet/space/psi_amp/Move()
	var/lastloc = loc
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = lastloc
		if(istype(H) && H.psi)
			H.psi.reset()
		H = loc
		if(!istype(H) || H.head != src)
			canremove = TRUE

/obj/item/clothing/head/helmet/space/psi_amp/proc/integrate()

	set name = "Integrate Psionic Amplifier"
	set desc = "Enhance your brainpower."
	set category = "Abilities"
	set src in usr

	if(operating)
		return

	if(!canremove)
		return

	if(LAZYLEN(boosted_faculties) < max_boosted_faculties)
		to_chat(usr, SPAN_NOTICE("You still have [max_boosted_faculties - LAZYLEN(boosted_faculties)] facult[LAZYLEN(boosted_faculties) == 1 ? "y" : "ies"] to select. Use \the [src] in-hand to select them."))
		return

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.head != src)
		to_chat(usr, SPAN_WARNING("\The [src] must be worn on your head in order to be activated."))
		return

	canremove = FALSE
	operating = TRUE
	to_chat(H, SPAN_WARNING("You feel a series of sharp pinpricks as \the [src] anaesthetises your scalp before drilling down into your brain."))
	playsound(H, 'sound/weapons/circsawhit.ogg', 50, 1, -1)

	sleep(80)

	for(var/faculty in list(PSI_COERCION, PSI_PSYCHOKINESIS, PSI_REDACTION, PSI_ENERGISTICS))
		if(faculty in boosted_faculties)
			H.set_psi_rank(faculty, boosted_rank, take_larger = TRUE, temporary = TRUE)
		else
			H.set_psi_rank(faculty, unboosted_rank, take_larger = TRUE, temporary = TRUE)
	if(H.psi)
		H.psi.max_stamina = boosted_psipower
		H.psi.stamina = H.psi.max_stamina
		H.psi.update(force = TRUE)

	to_chat(H, SPAN_NOTICE("You experience a brief but powerful wave of deja vu as \the [src] finishes modifying your brain."))
	verbs |= /obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate
	verbs -= /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate
	operating = FALSE
	action_button_name = "Remove Psionic Amplifier"
	H.update_action_buttons()

	set_light(0.5, 0.1, 3, 2, l_color = "#880000")
