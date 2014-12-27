//DIONA ORGANS.
/obj/item/organ/internal/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	body_part = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/internal/diona/removed(var/mob/living/target,var/mob/living/user)

	..()
	var/mob/living/carbon/human/H = target
	if(!istype(target))
		del(src)

	if(!H.internal_organs.len)
		H.death()

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = seed_types["diona"]
	if(!diona)
		del(src)

	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/alien/diona/D = new(get_turf(src))
		diona.request_player(D)
		del(src)

/obj/item/organ/internal/diona/process_internal()
	return

/obj/item/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = "chest"

/obj/item/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = "head"

/obj/item/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = "groin"

/obj/item/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = "groin"

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/internal/diona/nutrients
	name = "nutrient vessel"
	body_part = "nutrient vessel"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/nutrients/removed()
	return

/obj/item/organ/internal/diona/node
	name = "receptor node"
	body_part = "receptor node"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/node/removed()
	return

//CORTICAL BORER ORGANS.
/obj/item/organ/internal/borer
	name = "cortical borer"
	parent_organ = "head"
	vital = 1

/obj/item/organ/internal/borer/process_internal()

	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	for(var/chem in list("tricordrazine","tramadol","hyperzine","alkysine"))
		if(owner.reagents.get_reagent_amount(chem) < 3)
			owner.reagents.add_reagent(chem, 5)

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/mob/living/carbon/human/H = owner
		if(!istype(H))
			return

		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
		blood_splatter(H,B,1)
		var/obj/effect/decal/cleanable/blood/splatter/goo = locate() in get_turf(owner)
		if(goo)
			goo.name = "husk ichor"
			goo.desc = "It's thick and stinks of decay."
			goo.basecolor = "#412464"
			goo.update_icon()

/obj/item/organ/internal/borer
	name = "cortical borer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borer"
	body_part = "brain"
	desc = "A disgusting space slug."
	vital = 1

/obj/item/organ/internal/borer/removed(var/mob/living/target,var/mob/living/user)

	..()

	var/mob/living/simple_animal/borer/B = target.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = target.ckey

	spawn(0)
		del(src)

//XENOMORPH ORGANS
/obj/item/organ/internal/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	icon_state = "xgibdown1"
	body_part = "plasma vessel"
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xenos/eggsac
	name = "egg sac"
	icon_state = "xgibmid1"
	body_part = "egg sac"

/obj/item/organ/internal/xenos/acidgland
	name = "acid gland"
	icon_state = "xgibtorso"
	body_part = "acid gland"

/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	icon_state = "xgibmid2"
	body_part = "hive node"

/obj/item/organ/internal/xenos/resinspinner
	name = "hive node"
	icon_state = "xgibmid2"
	body_part = "resin spinner"

//VOX ORGANS.

/obj/item/organ/internal/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	body_part = "stack"
	robotic = 2
	prosthetic_name = null
	prosthetic_icon = null
	parent_organ = "head"
	vital = 1
	var/backup_time = 0
	var/datum/mind/backup

/obj/item/organ/internal/stack/process_internal()
	if(owner && owner.stat != 2 && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind

/obj/item/organ/internal/stack/vox
	name = "vox cortical stack"