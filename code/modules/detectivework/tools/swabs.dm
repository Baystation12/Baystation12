/obj/item/swabber
	name = "swab kit"
	desc = "A kit full of sterilized cotton swabs and vials used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab"

/obj/item/swabber/attack()
	return 0

// This is pretty nasty but is a damn sight easier than trying to make swabs a stack item.
/obj/item/swabber/afterattack(var/atom/A, var/mob/user, var/proximity, var/params)
	if(proximity)
		var/obj/item/forensics/swab/swab = new(user)
		var/resolved = swab.resolve_attackby(A, user, params)
		if(!resolved && A && !QDELETED(A))
			swab.afterattack(A, user, TRUE, params)
		if(swab.is_used())
			swab.dropInto(user.loc)
		else
			qdel(swab)

/obj/item/forensics/swab
	name = "swab"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon_state = "swab"
	var/list/gunshot_residue_sample
	var/list/dna
	var/list/trace_dna
	var/used

/obj/item/forensics/swab/proc/is_used()
	return used

/obj/item/forensics/swab/attack(var/mob/living/M, var/mob/user)

	if(!ishuman(M))
		return ..()

	if(is_used())
		return

	var/mob/living/carbon/human/H = M
	var/sample_type

	if(H.wear_mask)
		to_chat(user, "<span class='warning'>\The [H] is wearing a mask.</span>")
		return

	if(!H.dna || !H.dna.unique_enzymes)
		to_chat(user, "<span class='warning'>They don't seem to have DNA!</span>")
		return

	if(user != H && (H.a_intent != I_HELP && !H.lying && !H.incapacitated(INCAPACITATION_DEFAULT)))
		user.visible_message("<span class='danger'>\The [user] tries to take a swab sample from \the [H], but they move away.</span>")
		return

	if(user.zone_sel.selecting == BP_MOUTH)
		if(!H.organs_by_name[BP_HEAD])
			to_chat(user, "<span class='warning'>They don't have a head.</span>")
			return
		if(!H.check_has_mouth())
			to_chat(user, "<span class='warning'>They don't have a mouth.</span>")
			return
		user.visible_message("[user] swabs \the [H]'s mouth for a saliva sample.")
		dna = list(H.dna.unique_enzymes)
		sample_type = "DNA"

	else
		var/zone = user.zone_sel.selecting
		if(!H.has_organ(zone))
			to_chat(user, "<span class='warning'>They don't have that part!</span>")
			return
		var/obj/item/organ/external/O = H.get_organ(zone)
		if(!O.gunshot_residue)
			return
		var/obj/C = H.get_covering_equipped_item_by_zone(zone)
		if(C)
			afterattack(C, user, 1) //Lazy but this would work
			return
		user.visible_message("[user] swabs [H]'s [O.name] for a sample.")
		sample_type = "gunshot_residue"
		gunshot_residue_sample = O.gunshot_residue.Copy()

	if(sample_type)
		set_used(sample_type, H)
		return
	return 1

/obj/item/forensics/swab/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity || istype(A, /obj/machinery/dnaforensics))
		return

	if(is_used())
		to_chat(user, "<span class='warning'>This swab has already been used.</span>")
		return

	add_fingerprint(user)

	var/list/choices = list()
	if(A.blood_DNA)
		choices |= "Blood"
	if(istype(A, /obj/item))
		choices |= "DNA traces"
	if(istype(A, /obj/item/clothing))
		choices |= "Gunshot Residue"

	var/choice
	if(!choices.len)
		to_chat(user, "<span class='warning'>There is no evidence on \the [A].</span>")
		return
	else if(choices.len == 1)
		choice = choices[1]
	else
		choice = input("What kind of evidence are you looking for?","Evidence Collection") as null|anything in choices

	if(!choice)
		return

	var/sample_type
	if(choice == "Blood")
		if(!A.blood_DNA || !A.blood_DNA.len)
			to_chat(user, "<span class='warning'>There is no blood on \the [A].</span>")
			return
		dna = A.blood_DNA.Copy()
		sample_type = "blood"

	else if(choice == "Gunshot Residue")
		var/obj/item/clothing/B = A
		if(!istype(B) || !B.gunshot_residue)
			to_chat(user, "<span class='warning'>There is no residue on \the [A].</span>")
			return
		gunshot_residue_sample = B.gunshot_residue.Copy()
		sample_type = "residue"

	else if(choice == "DNA traces")
		var/obj/item/I = A
		if(!istype(I) || !I.trace_DNA)
			to_chat(user, "<span class='warning'>There is no non-blood DNA on \the [A].</span>")
			return
		trace_dna = I.trace_DNA.Copy()
		sample_type = "trace DNA"

	if(sample_type)
		user.visible_message("\The [user] swabs \the [A] for a sample.", "You swab \the [A] for a sample.")
		set_used(sample_type, A)

/obj/item/forensics/swab/proc/set_used(var/sample_str, var/atom/source)
	SetName("[initial(name)] ([sample_str] - [source])")
	desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_str] from [source].'."
	icon_state = "swab_used"
	used = 1
