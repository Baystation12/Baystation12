/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"

/obj/item/clothing/ring/engagement/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src].</span>","<span class='warning'>You get down on one knee, presenting \the [src].</span>")

/obj/item/clothing/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon_state = "cti-grad"

/obj/item/clothing/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon_state = "mariner-grad"

/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/ring/reagent
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 4)

/obj/item/clothing/ring/reagent/New()
	..()
	create_reagents(15)

/obj/item/clothing/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)
		if(reagents.total_volume)
			if(H.reagents)
				to_chat(H, "<span class='danger'>You feel a prick as you slip on \the [src].</span>")
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_BLOOD)
				admin_inject_log(usr, H, src, contained_reagents, trans)
	return

//Sleepy Ring
/obj/item/clothing/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	icon_state = "material"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/clothing/ring/reagent/sleepy/New()
	..()
	reagents.add_reagent(/datum/reagent/chloralhydrate, 15) // Less than a sleepy-pen, but still enough to knock someone out

/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/ring/seal/secgen
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-secgen"

/obj/item/clothing/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-masonic"

/obj/item/clothing/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-signet"
	var/nameset = 0

/obj/item/clothing/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>The [src] has already been claimed!</span>")
		return

	to_chat(user, "<span class='notice'>You claim the [src] as your own!</span>")
	change_name(user)
	nameset = 1

/obj/item/clothing/ring/seal/signet/proc/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s signet ring"
	desc = "A signet ring belonging to [signet_name], for when you're too sophisticated to sign letters."

//Chameleon Signet Ring
/obj/item/clothing/ring/seal/signet/chameleon/attack_self(mob/user)
	var/signet_name = sanitize(input("Enter name. Leave blank to use your own.", "Name", signet_name)) || user
	to_chat(user, "<span class='notice'>The face of \the [src] shifts.</span>")
	change_name(signet_name)