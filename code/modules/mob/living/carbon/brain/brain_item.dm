/obj/item/organ/brain
	name = "brain"
	desc = "A piece of juicy meat found in a persons head."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "biotech=3"
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null


/obj/item/organ/brain/New()
	..()
	//Shifting the brain "mob" over to the brain object so it's easier to keep track of. --NEO
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud


/obj/item/organ/brain/proc/transfer_identity(mob/living/carbon/H)
	name = "[H]'s brain"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob << "<span class='notice'>You feel slightly disoriented. That's normal when you're just a brain.</span>"


/obj/item/organ/brain/examine() // -- TLE
	set src in oview(12)
	if(!usr)	return
	usr << "This is \icon[src] \an [name]."

	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		usr << "You can feel the small spark of life still left in this one."
	else
		usr << "This one seems particularly lifeless. Perhaps it will regain some of its luster later.."


/obj/item/organ/brain/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M, /mob))
		return

	add_fingerprint(user)

	if(user.zone_sel.selecting != "head")
		return ..()

	var/mob/living/carbon/human/H = M
	if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		user << "<span class='notice'>You're going to need to remove their head cover first.</span>"
		return

//since these people will be dead M != usr

	if(!getbrain(M))
		user.drop_item()
		for(var/mob/O in viewers(M, null))
			if(O == (user || M))
				continue
			if(M == user)
				O << "<span class='notice'>[user] inserts [src] into \his head!</span>"
			else
				O << "<span class='notice'>[M] has [src] inserted into \his head by [user].</span>"

		if(M != user)
			M << "<span class='notice'>[user] inserts [src] into your head!</span>"
			user << "<span class='notice'>You insert [src] into [M]'s head!</span>"
		else
			user << "<span class='notice'>You insert [src] into your head!</span>"	//LOL

		//this might actually be outdated since barring badminnery, a debrain'd body will have any client sucked out to the brain's internal mob. Leaving it anyway to be safe. --NEO
		if(M.key)
			M.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(M)
		else
			M.key = brainmob.key

		M.internal_organs += src
		loc = null

	else
		..()
	return