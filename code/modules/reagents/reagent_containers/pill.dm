////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	randpixel = 7
	possible_transfer_amounts = null
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

/obj/item/weapon/reagent_containers/pill/New()
	..()
	if(!icon_state)
		icon_state = "pill[rand(1, 20)]"

/obj/item/weapon/reagent_containers/pill/attack(mob/M as mob, mob/user as mob, def_zone)
	//TODO: replace with standard_feed_mob() call.

	if(M == user)
		if(!M.can_eat(src))
			return

		to_chat(M, "<span class='notice'>You swallow \the [src].</span>")
		M.drop_from_inventory(src) //icon update
		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return 1

	else if(istype(M, /mob/living/carbon/human))
		if(!M.can_force_feed(user, src))
			return

		user.visible_message("<span class='warning'>[user] attempts to force [M] to swallow \the [src].</span>")

		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!do_mob(user, M))
			return

		user.drop_from_inventory(src) //icon update
		user.visible_message("<span class='warning'>[user] forces [M] to swallow \the [src].</span>")

		var/contained = reagentlist()
		admin_attack_log(user, M, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")

		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		qdel(src)

		return 1

	return 0

/obj/item/weapon/reagent_containers/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty. Can't dissolve \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You dissolve \the [src] in [target].</span>")

		admin_attacker_log(user, "spiked \a [target] with a pill. Reagents: [reagentlist()]")
		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)

		qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/weapon/reagent_containers/pill/tricordrazine
	name = "tricordrazine pill"
	desc = "Treats a wide range of minor injuries."
	icon_state = "pill14"

/obj/item/weapon/reagent_containers/pill/tricordrazine/New()
	..()
	reagents.add_reagent("tricordrazine", 15)

/obj/item/weapon/reagent_containers/pill/antitox
	name = "dylovene pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"

/obj/item/weapon/reagent_containers/pill/antitox/New()
	..()
	reagents.add_reagent("anti_toxin", 25)

/obj/item/weapon/reagent_containers/pill/charcoal
	name = "activated charcoal pill"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/charcoal/New()
	..()
	reagents.add_reagent("charcoal", 30)

/obj/item/weapon/reagent_containers/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"

/obj/item/weapon/reagent_containers/pill/tox/New()
	..()
	reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	name = "cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"

/obj/item/weapon/reagent_containers/pill/cyanide/New()
	..()
	reagents.add_reagent("cyanide", 50)

/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"

/obj/item/weapon/reagent_containers/pill/adminordrazine/New()
	..()
	reagents.add_reagent("adminordrazine", 50)

/obj/item/weapon/reagent_containers/pill/stox
	name = "sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/stox/New()
	..()
	reagents.add_reagent("stoxin", 15)

/obj/item/weapon/reagent_containers/pill/kelotane
	name = "kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"

/obj/item/weapon/reagent_containers/pill/kelotane/New()
	..()
	reagents.add_reagent("kelotane", 15)

/obj/item/weapon/reagent_containers/pill/paracetamol
	name = "paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/paracetamol/New()
	..()
	reagents.add_reagent("paracetamol", 15)

/obj/item/weapon/reagent_containers/pill/tramadol
	name = "tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
/obj/item/weapon/reagent_containers/pill/tramadol/New()
	..()
	reagents.add_reagent("tramadol", 15)

/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"

/obj/item/weapon/reagent_containers/pill/inaprovaline/New()
	..()
	reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/pill/chloromydride
	name = "chloromydride pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"

/obj/item/weapon/reagent_containers/pill/chloromydride/New()
	..()
	reagents.add_reagent("chloromydride", 15)

/obj/item/weapon/reagent_containers/pill/dexalin
	name = "pexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"

/obj/item/weapon/reagent_containers/pill/dexalin/New()
	..()
	reagents.add_reagent("dexalin", 15)

/obj/item/weapon/reagent_containers/pill/dexalin_plus
	name = "dexalin plus pill"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/dexalin_plus/New()
	..()
	reagents.add_reagent("dexalinp", 5)

/obj/item/weapon/reagent_containers/pill/dermaline
	name = "dermaline pill"
	desc = "Used to treat burn wounds."
	icon_state = "pill12"

/obj/item/weapon/reagent_containers/pill/dermaline/New()
	..()
	reagents.add_reagent("dermaline", 10)

/obj/item/weapon/reagent_containers/pill/bicaridine
	name = "bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/bicaridine/New()
	..()
	reagents.add_reagent("bicaridine", 10)

/obj/item/weapon/reagent_containers/pill/metorapan
	name = "metorapan pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/metorapan/New()
	..()
	reagents.add_reagent("metorapan", 15)

/obj/item/weapon/reagent_containers/pill/happy
	name = "happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/happy/New()
	..()
	reagents.add_reagent("space_drugs", 15)
	reagents.add_reagent("sugar", 15)

/obj/item/weapon/reagent_containers/pill/zoom
	name = "zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/zoom/New()
	..()
	reagents.add_reagent("impedrezene", 10)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)

/obj/item/weapon/reagent_containers/pill/spaceacillin
	name = "spaceacillin pill"
	desc = "Contains antiviral agents."
	icon_state = "pill19"

/obj/item/weapon/reagent_containers/pill/spaceacillin/New()
	..()
	reagents.add_reagent("spaceacillin", 15)

/obj/item/weapon/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill9"

/obj/item/weapon/reagent_containers/pill/diet/New()
	..()
	reagents.add_reagent("lipozine", 2)

/obj/item/weapon/reagent_containers/pill/hyronalin
	name = "hyronalin pill"
	desc = "Contains anti-radiation agents."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/hyronalin/New()
	..()
	reagents.add_reagent("hyronalin", 15)

//Baycode specific Psychiatry pills.
/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/methylphenidate/New()
	..()
	reagents.add_reagent("methylphenidate", 15)

/obj/item/weapon/reagent_containers/pill/citalopram
	name = "citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"

/obj/item/weapon/reagent_containers/pill/citalopram/New()
	..()
	reagents.add_reagent("citalopram", 15)

/obj/item/weapon/reagent_containers/pill/paroxetine
	name = "paroxetine pill"
	desc = "Before you swallow a bullet: try swallowing this!"
	icon_state = "pill20"

/obj/item/weapon/reagent_containers/pill/paroxetine/New()
	..()
	reagents.add_reagent("paroxetine", 10)