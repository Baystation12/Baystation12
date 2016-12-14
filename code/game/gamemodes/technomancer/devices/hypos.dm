/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector
	name = "empty hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/New()
	..()
	reagents.remove_reagent("inaprovaline", 5)
	update_icon()
	return

/datum/technomancer/consumable/hypo_brute
	name = "Trauma Hypo"
	desc = "A extended capacity hypo which can treat blunt trauma."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute

/datum/technomancer/consumable/hypo_burn
	name = "Burn Hypo"
	desc = "A extended capacity hypo which can treat severe burns."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn

/datum/technomancer/consumable/hypo_tox
	name = "Toxin Hypo"
	desc = "A extended capacity hypo which can treat various toxins."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin

/datum/technomancer/consumable/hypo_oxy
	name = "Oxy Hypo"
	desc = "A extended capacity hypo which can treat oxygen deprivation."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy

/datum/technomancer/consumable/hypo_purity
	name = "Purity Hypo"
	desc = "A extended capacity hypo which can remove various inpurities in the system such as viruses, infections, \
	radiation, and genetic problems."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity

/datum/technomancer/consumable/hypo_pain
	name = "Pain Hypo"
	desc = "A extended capacity hypo which contains potent painkillers."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain

/datum/technomancer/consumable/hypo_organ
	name = "Organ Hypo"
	desc = "A extended capacity hypo which is designed to fix internal organ problems."
	cost = 50
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ

/datum/technomancer/consumable/hypo_combat
	name = "Combat Hypo"
	desc = "A extended capacity hypo containing a dangerous cocktail of various combat stims."
	cost = 75
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat


/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute
	name = "trauma hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on victims of \
	moderate blunt trauma."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute/New()
	..()
	reagents.add_reagent("bicaridine", 15)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn
	name = "burn hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on burn victims, \
	featuring an optimized chemical mixture to allow for rapid healing."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn/New()
	..()
	reagents.add_reagent("kelotane", 7.5)
	reagents.add_reagent("dermaline", 7.5)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin
	name = "toxin hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract toxins."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy
	name = "oxy hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract oxygen \
	deprivation."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy/New()
	..()
	reagents.add_reagent("dexalinp", 10)
	reagents.add_reagent("tricordrazine", 5) //Dex+ ODs above 10, so we add tricord to pad it out somewhat.
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity
	name = "purity hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This varient excels at \
	resolving viruses, infections, radiation, and genetic maladies."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity/New()
	..()
	reagents.add_reagent("spaceacillin", 9)
	reagents.add_reagent("arithrazine", 5)
	reagents.add_reagent("ryetalyn", 1)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain
	name = "pain hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one contains potent painkillers."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain/New()
	..()
	reagents.add_reagent("tramadol", 15)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ
	name = "organ hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  Organ damage is resolved by this varient."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ/New()
	..()
	reagents.add_reagent("alkysine", 1)
	reagents.add_reagent("imidazoline", 1)
	reagents.add_reagent("peridaxon", 13)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat
	name = "combat hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This is a more dangerous and potentially \
	addictive hypo compared to others, as it contains a potent cocktail of various chemicals to optimize the recipient's combat \
	ability."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat/New()
	..()
	reagents.add_reagent("bicaridine", 3)
	reagents.add_reagent("kelotane", 1.5)
	reagents.add_reagent("dermaline", 1.5)
	reagents.add_reagent("oxycodone", 3)
	reagents.add_reagent("hyperzine", 3)
	reagents.add_reagent("tricordrazine", 3)
	update_icon()
	return
