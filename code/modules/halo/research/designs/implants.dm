


/* IMPLANTER */

/datum/research_design/implanter
	name = "Implanter device"
	desc = "A tool for inserting different kinds of implants into a person."
	product_type = /obj/item/weapon/implanter
	required_materials = list("plasteel" = 5, "steel" = 10, "glass" = 5)
	build_type = PROTOLATHE
	complexity = 4



/* SS13 */

/datum/research_design/implant_chem
	name = "Chemical implant"
	product_type = /obj/item/weapon/implant/chem
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	required_objs = list(/obj/item/weapon/reagent_containers/syringe = "empty syringe")
	build_type = PROTOLATHE
	complexity = 15

/datum/research_design/implant_compressed
	name = "Compressed matter implant"
	product_type = /obj/item/weapon/implant/compressed
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	build_type = PROTOLATHE
	complexity = 15

/datum/research_design/implant_adrenaline
	name = "Adrenaline implant"
	product_type = /obj/item/weapon/implant/adrenalin
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	required_reagents = list(/datum/reagent/adrenaline = 10)
	required_objs = list(/obj/item/weapon/reagent_containers/syringe = "empty syringe")
	build_type = PROTOLATHE
	complexity = 15

/datum/research_design/implant_explosive
	name = "Explosive implant"
	product_type = /obj/item/weapon/implant/explosive
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	required_reagents = list(/datum/reagent/nitroglycerin = 10, /datum/reagent/toxin/plasticide = 10)
	required_objs = list(/obj/item/device/assembly/igniter)
	build_type = PROTOLATHE
	complexity = 15



/* SANGHEILI */

/datum/research_design/implant_sangheili
	name = "Sangheili language implant"
	product_type = /obj/item/weapon/implantcase/language_sangheili
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	required_objs = list(/obj/item/dumb_ai_chip = "dumb AI chip")
	build_type = PROTOLATHE
	complexity = 20

/obj/item/weapon/implantcase/language_sangheili
	name = "glass case - 'Sangheili language'"
	imp = /obj/item/weapon/implant/language_sangheili

/obj/item/weapon/implant/language_sangheili
	name = "Sangheili language"
	desc = "Allows understanding Sangheili, but not speaking."

/obj/item/weapon/implant/language_sangheili/implanted(var/mob/source)
	source.languages_understand |= "Sangheili"

/obj/item/weapon/implant/language_sangheili/meltdown()
	imp_in.languages_understand -= "Sangheili"
	. = ..()

/obj/item/weapon/implant/language_sangheili/removed()
	imp_in.languages_understand -= "Sangheili"
	. = ..()



/* ENGLISH */

/datum/research_design/implant_english
	name = "English language implant"
	name = "Allows the recipient to understand English, but not speak it."
	product_type = /obj/item/weapon/implantcase/language_english
	required_materials = list("osmium-carbide plasteel" = 1, "glass" = 5, "plastic" = 5, "gold" = 1)
	required_objs = list(/obj/item/dumb_ai_chip = "dumb AI chip")
	build_type = PROTOLATHE
	complexity = 20

/obj/item/weapon/implantcase/language_english
	name = "glass case - 'English language'"
	imp = /obj/item/weapon/implant/language_english

/obj/item/weapon/implant/language_english
	name = "English language"
	desc = "Allows understanding English, but not speaking."

/obj/item/weapon/implant/language_english/implanted(var/mob/source)
	. = ..()
	imp_in.languages_understand |= LANGUAGE_GALCOM

/obj/item/weapon/implant/language_english/meltdown()
	imp_in.languages_understand -= LANGUAGE_GALCOM
	. = ..()

/obj/item/weapon/implant/language_english/removed()
	imp_in.languages_understand -= LANGUAGE_GALCOM
	. = ..()
