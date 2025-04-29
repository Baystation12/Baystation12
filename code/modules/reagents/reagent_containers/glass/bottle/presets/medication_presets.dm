/obj/item/reagent_containers/glass/bottle/adrenaline
	name = "\improper Adrenaline bottle"
	desc = "A small bottle. Contains adrenaline - used to restart the heart."
	preset_reagent = /datum/reagent/adrenaline

/obj/item/reagent_containers/glass/bottle/alkysine
	name = "\improper Alkysine bottle"
	desc = "A small bottle. Contains alkysine - used to treat brain damage."
	preset_reagent = /datum/reagent/alkysine

/obj/item/reagent_containers/glass/bottle/antidexafen
	name = "\improper Antidexafen bottle"
	desc = "A small bottle. Contains antidexafen - an immunity booster for treating infections."
	preset_reagent = /datum/reagent/antidexafen

/obj/item/reagent_containers/glass/bottle/arithrazine
	name = "\improper Arithrazine bottle"
	desc = "A small bottle. Contains arithrazine - used for treating severe radiation damage."
	preset_reagent = /datum/reagent/arithrazine

/obj/item/reagent_containers/glass/bottle/bicaridine
	name = "\improper Bicaridine bottle"
	desc = "A small bottle. Contains bicaridine - used to treat brute damage."
	preset_reagent = /datum/reagent/bicaridine

/obj/item/reagent_containers/glass/bottle/citalopram
	name = "\improper Citalopram bottle"
	desc = "A small bottle. Contains citalopram - a mild antidepressant."
	preset_reagent = /datum/reagent/citalopram

/obj/item/reagent_containers/glass/bottle/clonexadone
	name = "\improper Clonexadone bottle"
	desc = "A small bottle. Contains clonexadone - used in cryogenic healing."
	preset_reagent = /datum/reagent/clonexadone

/obj/item/reagent_containers/glass/bottle/cryoxadone
	name = "\improper Cryoxadone bottle"
	desc = "A small bottle. Contains cryoxadone - used in cryogenic healing."
	preset_reagent = /datum/reagent/cryoxadone

/obj/item/reagent_containers/glass/bottle/cryomix
	name = "\improper Cryomix bottle"
	desc = "A small bottle. Contains a mixture of cryoxadone, clonexadone and nanite fluid - used in cryogenic healing."
	icon_state = "bottle-4"

/obj/item/reagent_containers/glass/bottle/cryomix/New()
	..()
	reagents.add_reagent(/datum/reagent/cryoxadone, 20)
	reagents.add_reagent(/datum/reagent/clonexadone, 20)
	reagents.add_reagent(/datum/reagent/nanitefluid, 20)
	update_icon()

/obj/item/reagent_containers/glass/bottle/dermaline
	name = "\improper Dermaline bottle"
	desc = "A small bottle. Contains dermaline - used to treat severe burn damage."
	preset_reagent = /datum/reagent/dermaline

/obj/item/reagent_containers/glass/bottle/dexalin
	name = "\improper Dexalin bottle"
	desc = "A small bottle. Contains dexalin - used to treat oxygen deprivation."
	preset_reagent = /datum/reagent/dexalin

/obj/item/reagent_containers/glass/bottle/dexalinplus
	name = "\improper Dexalin Plus bottle"
	desc = "A small bottle. Contains dexalin plus - used to treat oxygen deprivation more efficiently than dexalin."
	preset_reagent = /datum/reagent/dexalinp

/obj/item/reagent_containers/glass/bottle/dylovene
	name = "\improper Dylovene bottle"
	desc = "A small bottle. Contains dylovene - an anti-toxin."
	preset_reagent = /datum/reagent/dylovene

/obj/item/reagent_containers/glass/bottle/ethylredoxrazine
	name = "\improper Ethylredoxrazine bottle"
	desc = "A small bottle. Contains ethylredoxrazine - used to treat alcohol poisoning, diziness, sleepiness, and stuttering."
	preset_reagent = /datum/reagent/ethylredoxrazine

/obj/item/reagent_containers/glass/bottle/hyronalin
	name = "\improper Hyronalin bottle"
	desc = "A small bottle. Contains hyronalin - used to treat radiation poisoning."
	preset_reagent = /datum/reagent/hyronalin

/obj/item/reagent_containers/glass/bottle/imidazoline
	name = "\improper Imidazoline bottle"
	desc = "A small bottle. Contains imidazoline - used to treat eye damage."
	preset_reagent = /datum/reagent/imidazoline

/obj/item/reagent_containers/glass/bottle/immunobooster
	name = "\improper Immunobooster bottle"
	desc = "A small bottle. Contains immunobooster - used to treat damaged immune systems."
	preset_reagent = /datum/reagent/immunobooster

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "\improper Inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	preset_reagent = /datum/reagent/inaprovaline

/obj/item/reagent_containers/glass/bottle/kelotane
	name = "\improper Kelotane bottle"
	desc = "A small bottle. Contains kelotane - used to treat burns."
	preset_reagent = /datum/reagent/kelotane

/obj/item/reagent_containers/glass/bottle/keloderm
	name = "\improper KeloDerm bottle"
	desc = "A small bottle. Contains a mixture of kelotane and dermaline - used to treat burns."
	icon_state = "bottle-4"

/obj/item/reagent_containers/glass/bottle/keloderm/New()
	..()
	reagents.add_reagent(/datum/reagent/kelotane, 30)
	reagents.add_reagent(/datum/reagent/dermaline, 30)
	update_icon()

/obj/item/reagent_containers/glass/bottle/leporazine
	name = "\improper Leporazine bottle"
	desc = "A small bottle. Contains leporazine - used to stabilize body temperature."
	preset_reagent = /datum/reagent/leporazine

/obj/item/reagent_containers/glass/bottle/methylphenidate
	name = "\improper Methylphenidate bottle"
	desc = "A small bottle. Contains methylphenidate - used to treat ADHD."
	preset_reagent = /datum/reagent/methylphenidate

/obj/item/reagent_containers/glass/bottle/nanitefluid
	name = "\improper Nanite Fluid bottle"
	desc = "A small bottle. Contains nanite fluid - used to repair prosthetic limbs."
	preset_reagent = /datum/reagent/nanitefluid

/obj/item/reagent_containers/glass/bottle/noexcutite
	name = "\improper Noexcutite bottle"
	desc = "A small bottle. Contains noexcutite - used to treat convulsions."
	preset_reagent = /datum/reagent/noexcutite

/obj/item/reagent_containers/glass/bottle/oxycodone
	name = "\improper Oxycodone bottle"
	desc = "A small bottle. Contains oxycodone - a powerful painkiller."
	preset_reagent = /datum/reagent/tramadol/oxycodone

/obj/item/reagent_containers/glass/bottle/paracetamol
	name = "\improper Paracetamol bottle"
	desc = "A small bottle. Contains paracetamol - a mild painkiller."
	preset_reagent = /datum/reagent/paracetamol

/obj/item/reagent_containers/glass/bottle/paratram
	name = "\improper ParaTram bottle"
	desc = "A small bottle. Contains a mixture of paracetamol and tramadol - a strong painkiller."
	icon_state = "bottle-4"

/obj/item/reagent_containers/glass/bottle/paratram/New()
	..()
	reagents.add_reagent(/datum/reagent/paracetamol, 15)
	reagents.add_reagent(/datum/reagent/tramadol, 45)
	update_icon()

/obj/item/reagent_containers/glass/bottle/paraoxytram
	name = "\improper ParaOxyTram bottle"
	desc = "A small bottle. Contains a mixture of paracetamol, oxycodone and tramadol - a very strong painkiller."
	icon_state = "bottle-4"

/obj/item/reagent_containers/glass/bottle/paratram/New()
	..()
	reagents.add_reagent(/datum/reagent/paracetamol, 15)
	reagents.add_reagent(/datum/reagent/tramadol, 30)
	reagents.add_reagent(/datum/reagent/tramadol/oxycodone, 15)
	update_icon()

/obj/item/reagent_containers/glass/bottle/paroxetine
	name = "\improper Paroxetine bottle"
	desc = "A small bottle. Contains paroxetine - a strong antidepressant."
	preset_reagent = /datum/reagent/paroxetine

/obj/item/reagent_containers/glass/bottle/peridaxon
	name = "\improper Peridaxon bottle"
	desc = "A small bottle. Contains peridaxon - used to treat organ damage."
	preset_reagent = /datum/reagent/peridaxon

/obj/item/reagent_containers/glass/bottle/rezadone
	name = "\improper Rezadone bottle"
	desc = "A small bottle. Contains rezadone - used to treat severe organ damage."
	preset_reagent = /datum/reagent/rezadone

/obj/item/reagent_containers/glass/bottle/ryetalyn
	name = "\improper Ryetalyn bottle"
	desc = "A small bottle. Contains ryetalyn - used to treat genetic defects."
	preset_reagent = /datum/reagent/ryetalyn

/obj/item/reagent_containers/glass/bottle/spaceacillin
	name = "\improper Spaceacillin bottle"
	desc = "A small bottle. Contains spaceacillin - used to treat infections."
	preset_reagent = /datum/reagent/spaceacillin

/obj/item/reagent_containers/glass/bottle/synaptizine
	name = "\improper Synaptizine bottle"
	desc = "A small bottle. Contains synaptizine - used to treat hallucinations and paralysis."
	preset_reagent = /datum/reagent/synaptizine

/obj/item/reagent_containers/glass/bottle/tramadol
	name = "\improper Tramadol bottle"
	desc = "A small bottle. Contains tramadol - a moderate painkiller."
	preset_reagent = /datum/reagent/tramadol

/obj/item/reagent_containers/glass/bottle/tricordrazine
	name = "\improper Tricordrazine bottle"
	desc = "A small bottle. Contains tricordrazine - used to treat both brute and burn damage."
	preset_reagent = /datum/reagent/tricordrazine

/obj/item/reagent_containers/glass/bottle/venaxilin
	name = "\improper Venaxilin bottle"
	desc = "A small bottle. Contains venaxilin - used to neutralize venom in the bloodstream."
	preset_reagent = /datum/reagent/dylovene/venaxilin
