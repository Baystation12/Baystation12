// Combat medical equipment
/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat
	name = "combat stabilization autoinjector"
	desc = "Contains a drug cocktail designed to help stabilized critically injured troops"
	band_color = COLOR_RED

	amount_per_transfer_from_this = 15
	volume = 15

	starts_with = list(/datum/reagent/biofoam = 5, /datum/reagent/inaprovaline = 5, /datum/reagent/ketoprofen = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/necrosis
	name = "tissue necrosis inhibitors"
	desc = "Contains drugs that inhibit organ necrosis"
	band_color = COLOR_PURPLE

	starts_with = list(/datum/reagent/peridaxon = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/antibiotic
	name = "antibiotics autoinjector"
	desc = "Contains a large dose of broad-spectrum antibiotics"
	band_color = COLOR_DARK_GRAY

	amount_per_transfer_from_this = 15
	volume = 15

	starts_with = list(/datum/reagent/spaceacillin = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/painkiller
	name = "oxycodone autoinjector"
	desc = "Contains a large dose of highly effective painkillers"
	band_color = COLOR_BLUE

	amount_per_transfer_from_this = 10
	volume = 10

	starts_with = list(/datum/reagent/oxycodone = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/otomax
	name = "otomax autoinjector"
	desc = "Contains chemicals that reduce ear damage"
	band_color = COLOR_YELLOW

	amount_per_transfer_from_this = 10
	volume = 10

	starts_with = list(/datum/reagent/otomax = 10)

/obj/item/stack/medical/compression
	name = "compression bandages"
	singular_name = "compression bandage"
	desc = "Special bandages designed to reduce the severity of arterial bleeding"
	amount = 8

	icon_state = "brutepack" //todo: change this?

/obj/item/stack/medical/compression/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		user.visible_message("<span class='notice'>[user] starts to bandage [M]'s [affecting.name].</span>", \
					             "<span class='notice'>You start to bandage [M]'s [affecting.name].</span>")

		if((affecting.status & ORGAN_ARTERY_CUT || affecting.status & ORGAN_BLEEDING) && !affecting.clamped())

			// Only clamp the bleeding; doesn't stop someone from eventually bleeding out
			if(do_after(user, 20, M))
				user.visible_message("<span class='notice'>[user] bandages [M]'s [affecting.name].</span>", \
					             "<span class='notice'>bandage [M]'s [affecting.name].</span>")
				affecting.clamp()
				use(1)
				affecting.update_damages()
		else
			to_chat(user, "<span class='warning'>You can't see how that'd help with [M]'s [affecting.name]'s injuries.</span>")
