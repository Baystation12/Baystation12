/obj/item/weapon/forensics/swab
	name = "swab kit"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon_state = "swab"
	var/gsr = 0
	var/list/dna
	var/used

/obj/item/weapon/forensics/swab/proc/is_used()
	return used

/obj/item/weapon/forensics/swab/attack(var/mob/living/M, var/mob/user)

	if(!ishuman(M))
		return ..()

	if(is_used())
		return 0

	var/mob/living/carbon/human/H = M
	var/sample_type

	if(H.wear_mask)
		user << "<span class='warning'>\The [H] is wearing a mask.</span>"
		return 1

	if(!H.dna || !H.dna.unique_enzymes)
		user << "<span class='warning'>They don't seem to have DNA!</span>"
		return 1

	if(user != H && H.a_intent != "help" && !H.lying)
		user.visible_message("<span class='danger'>\The [user] tries to take a swab sample from \the [H], but they move away.</span>")
		return 1

	if(user.zone_sel.selecting == "mouth")
		if(!H.organs_by_name["head"])
			user << "<span class='warning'>They don't have a head.</span>"
			return 1
		if(!H.check_has_mouth())
			user << "<span class='warning'>They don't have a mouth.</span>"
			return 1
		user.visible_message("[user] swabs \the [H]'s mouth for a saliva sample.")
		dna = list(H.dna.unique_enzymes)
		sample_type = "DNA"

	else if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name["r_hand"]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name["l_hand"]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			user << "<span class='warning'>They don't have any hands.</span>"
			return 1
		user.visible_message("[user] swabs [H]'s palm for a sample.")
		sample_type = "GSR"
		gsr = H.gunshot_residue
	else
		return 0

	if(sample_type)
		used = 1
		name = "[initial(name)] ([sample_type] - [H])"
		desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_type] from [H].'."
		icon_state = "swab_used"
		return 1
	return 0

/obj/item/weapon/forensics/swab/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity || istype(A, /obj/item/weapon/forensics/slide))
		return

	if(is_used())
		user << "<span class='warning'>This swab has already been used.</span>"
		return

	add_fingerprint(user)

	var/list/choices = list()
	if(A.blood_DNA)
		choices |= "Blood"
	if(istype(A, /obj/item/clothing))
		choices |= "Gunshot Residue"

	var/choice
	if(!choices.len)
		user << "<span class='warning'>There is no evidence on \the [A].</span>"
		return
	else if(choices.len == 1)
		choice = choices[1]
	else
		choice = input("What kind of evidence are you looking for?","Evidence Collection") as null|anything in choices

	if(!choice)
		return

	var/sample_type
	if(choice == "Blood")
		if(!A.blood_DNA || !A.blood_DNA.len) return
		dna = A.blood_DNA.Copy()
		sample_type = "blood"
	else if(choice == "Gunshot Residue")
		var/obj/item/clothing/B = A
		if(!istype(B) || !B.gunshot_residue)
			user << "<span class='warning'>There is no residue on \the [A].</span>"
			return
		gsr = B.gunshot_residue
		sample_type = "residue"

	if(sample_type)
		user.visible_message("\The [user] swabs \the [A] for a sample.", "You swab \the [A] for a sample.")
		name = "[initial(name)] ([sample_type] - [A])"
		desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_type] from [A].'."
		icon_state = "swab_used"

