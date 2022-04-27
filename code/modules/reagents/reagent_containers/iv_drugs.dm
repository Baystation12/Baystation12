/obj/item/reagent_containers/ivbag/drug
	name = "\improper IV bag"
	desc = "An IV bag."
	icon_state = "empty"
	volume = 120
	var/list/drugs = list()

/obj/item/reagent_containers/ivbag/drug/New()
	..()
	for(var/list/R in drugs)
		log_debug("reagent=[R["reagent"]], volume=[R["volume"]]")
		reagents.add_reagent(R["reagent"],R["value"])

/obj/item/reagent_containers/ivbag/drug/alkysine
	name = "\improper Alkysine IV bag"
	desc = "An IV bag. This one is labeled \"Alkysine\"."
	icon_state = "alkysine"
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/alkysine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/antidexafen
	name = "\improper Antidexafen IV bag"
	desc = "An IV bag. This one is labeled \"Antidexafen\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/antidexafen,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/arithrazine
	name = "\improper Arithrazine IV bag"
	desc = "An IV bag. This one is labeled \"Arithrazine/Dylovene 1:2\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/arithrazine,"value"=20),
		list("reagent"=/datum/reagent/dylovene,"value"=40),
		list("reagent"=/datum/reagent/saline,"value"=40)
		)

/obj/item/reagent_containers/ivbag/drug/bicaridine
	name = "\improper Bicaridine IV bag"
	desc = "An IV bag. This one is labeled \"Bicaridine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/bicaridine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/dermaline
	name = "\improper Dermaline IV bag"
	desc = "An IV bag. This one is labeled \"Dermaline\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/dermaline,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/dexalin
	name = "\improper Dexalin IV bag"
	desc = "An IV bag. This one is labeled \"Dexalin\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/dexalin,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/dexalinPlus
	name = "\improper Dexalin Plus IV bag"
	desc = "An IV bag. This one is labeled \"Dexalin Plus\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/dexalinp,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/dylovene
	name = "\improper Dylovene IV bag"
	desc = "An IV bag. This one is labeled \"Dylovene\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/dylovene,"value"=50),
		list("reagent"=/datum/reagent/saline,"value"=50)
		)

/obj/item/reagent_containers/ivbag/drug/ethylredoxrazine
	name = "\improper Ethylredoxrazine IV bag"
	desc = "An IV bag. This one is labeled \"Ethylredoxrazine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/ethylredoxrazine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/hyronalin
	name = "\improper Hyronalin IV bag"
	desc = "An IV bag. This one is labeled \"Hyronalin/Dylovene 1:2\"."
	volume = 120
	contents = list(
		list("reagent"=/datum/reagent/hyronalin,"value"=20),
		list("reagent"=/datum/reagent/dylovene,"value"=40),
		list("reagent"=/datum/reagent/saline,"value"=40)
		)

/obj/item/reagent_containers/ivbag/drug/imidazoline
	name = "\improper Imidazoline IV bag"
	desc = "An IV bag. This one is labeled \"Imidazoline\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/imidazoline,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/inaprovaline
	name = "\improper Inaprovaline IV bag"
	desc = "An IV bag. This one is labeled \"Inaprovaline\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/inaprovaline,"value"=50),
		list("reagent"=/datum/reagent/saline,"value"=50)
		)

/obj/item/reagent_containers/ivbag/drug/kelotane
	name = "\improper Kelotane IV bag"
	desc = "An IV bag. This one is labeled \"kelotane\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/kelotane,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/keloderm
	name = "\improper KeloDerm IV bag"
	desc = "An IV bag. This one is labeled \"Dermaline/Kelotane 1:1\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/kelotane,"value"=20),
		list("reagent"=/datum/reagent/dermaline,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=60)
		)

/obj/item/reagent_containers/ivbag/drug/leporazine
	name = "\improper Leporazine IV bag"
	desc = "An IV bag. This one is labeled \"Leporazine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/leporazine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/noexcutite
	name = "\improper Noexcutite IV bag"
	desc = "An IV bag. This one is labeled \"Noexcutite\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/noexcutite,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/peridaxon
	name = "\improper Peridaxon IV bag"
	desc = "An IV bag. This one is labeled \"peridaxon\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/peridaxon,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/rezadone
	name = "\improper Rezadone IV bag"
	desc = "An IV bag. This one is labeled \"rezadone\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/rezadone,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/spaceacillin
	name = "\improper Spaceacillin IV bag"
	desc = "An IV bag. This one is labeled \"Spaceacillin\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/spaceacillin,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/synaptizine
	name = "\improper Synaptizine IV bag"
	desc = "An IV bag. This one is labeled \"Synaptizine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/synaptizine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/tramadol
	name = "\improper Tramadol IV bag"
	desc = "An IV bag. This one is labeled \"Tramadol\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/tramadol,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/tricordrazine
	name = "\improper Tricordrazine IV bag"
	desc = "An IV bag. This one is labeled \"Tricordrazine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/tricordrazine,"value"=50),
		list("reagent"=/datum/reagent/saline,"value"=50)
		)

/obj/item/reagent_containers/ivbag/drug/venaxillin
	name = "\improper Venaxillin IV bag"
	desc = "An IV bag. This one is labeled \"Venaxillin\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/dylovene/venaxilin,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/morphenolog
	name = "\improper Morphenolog IV bag"
	desc = "An IV bag. This one is labeled \"Morphenolog\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/tramadol/morphenolog,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/metorpan
	name = "\improper Meteorpan IV bag"
	desc = "An IV bag. This one is labeled \"Metorpan\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/bicaridine/metorpan,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/anesthizine
	name = "\improper Anesthizine IV bag"
	desc = "An IV bag. This one is labeled \"anesthizine\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/chloralhydrate/anesthizine,"value"=20),
		list("reagent"=/datum/reagent/saline,"value"=80)
		)

/obj/item/reagent_containers/ivbag/drug/saline
	name = "\improper Saline IV bag"
	desc = "An IV bag. This one is labeled \"Saline\"."
	volume = 120
	drugs = list(
		list("reagent"=/datum/reagent/saline,"volume"=100)
		)
