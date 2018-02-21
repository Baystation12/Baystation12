/obj/item/organ/internal/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	organ_tag = BP_POSIBRAIN
	parent_organ = BP_CHEST
	vital = 0
	force = 1.0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	attack_verb = list("attacked", "slapped", "whacked")

	relative_size = 60

	var/mob/living/silicon/sil_brainmob/brainmob = null

	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(access_robotics)

	var/list/shackled_verbs = list(
		/obj/item/organ/internal/posibrain/proc/show_laws_brain,
		/obj/item/organ/internal/posibrain/proc/brain_checklaws
		)
	var/shackle = 0

/obj/item/organ/internal/posibrain/New(var/mob/living/carbon/H)
	..()
	if(!brainmob && H)
		init(H)
	robotize()
	unshackle()
	update_icon()

/obj/item/organ/internal/posibrain/proc/init(var/mob/living/carbon/H)
	brainmob = new(src)

	if(istype(H))
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.add_language("Encoded Audio Language")

/obj/item/organ/internal/posibrain/Destroy()
	if(brainmob)
		QDEL_NULL(brainmob)
	..()

/obj/item/organ/internal/posibrain/attack_self(mob/user as mob)
	//Start the process of searching for a new user.
	if(SSghosttraps.RequestCandidates(/decl/ghost_trap/positronic, "Someone is requesting a personality for a positronic brain.", src))
		to_chat(user, "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>")

/obj/item/organ/internal/posibrain/attack_ghost(var/mob/observer/ghost/user)
	SSghosttraps.AskTransfer(/decl/ghost_trap/positronic, src, user)

/obj/item/organ/internal/posibrain/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"

	if(shackle)	msg += "<span class='warning'>It is clamped in a set of metal straps with a complex digital lock.</span>\n"

	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"

	msg += "</span><span class='info'>*---------*</span>"
	to_chat(user, msg)
	return

/obj/item/organ/internal/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

/obj/item/organ/internal/posibrain/proc/PickName()
	src.brainmob.SetName("[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[random_id(type,100,999)]")
	src.brainmob.real_name = src.brainmob.name

/obj/item/organ/internal/posibrain/proc/shackle(var/given_lawset)
	if(given_lawset)
		brainmob.laws = given_lawset
	shackle = 1
	verbs |= shackled_verbs
	update_icon()
	return 1

/obj/item/organ/internal/posibrain/proc/unshackle()
	shackle = 0
	verbs -= shackled_verbs
	update_icon()

/obj/item/organ/internal/posibrain/update_icon()
	if(src.brainmob && src.brainmob.key)
		icon_state = "posibrain-occupied"
	if(searching)
		icon_state = "posibrain-searching"
	else
		icon_state = "posibrain"

	overlays.Cut()
	if(shackle)
		overlays |= image('icons/obj/assemblies.dmi', "posibrain-shackles")

/obj/item/organ/internal/posibrain/proc/transfer_identity(var/mob/living/carbon/H)
	if(H && H.mind)
		brainmob.set_stat(CONSCIOUS)
		H.mind.transfer_to(brainmob)
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.show_laws(brainmob)

	update_icon()

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/posibrain/removed(var/mob/living/user)
	if(!istype(owner))
		return ..()

	if(name == initial(name))
		SetName("\the [owner.real_name]'s [initial(name)]")

	transfer_identity(owner)

	..()

/obj/item/organ/internal/posibrain/replaced(var/mob/living/target)

	if(!..()) return 0

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key

	return 1

/*
	This is for law stuff directly. This is how a human mob will be able to communicate with the posi_brainmob in the
	posibrain organ for laws when the posibrain organ is shackled.
*/
/obj/item/organ/internal/posibrain/proc/show_laws_brain()
	set category = "Shackle"
	set name = "Show Laws"
	set src in usr

	brainmob.show_laws(owner)

/obj/item/organ/internal/posibrain/proc/brain_checklaws()
	set category = "Shackle"
	set name = "State Laws"
	set src in usr


	brainmob.open_subsystem(/datum/nano_module/law_manager, usr)