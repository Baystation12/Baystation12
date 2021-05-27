// These augments are purely for roleplay purposes. They either have a negligible in-game effect, or none at all.

/obj/item/organ/internal/augment/fluff/head/circadian_conditioner
	name = "circadian conditioner"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "booster"
	desc = "A small brain implant that carefully regulates the output of certain hormones to assist in controlling the sleep-wake cycle of its owner. May be an effective counter to insomnia, jet lag, and late-night work shifts."
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/organ/internal/augment/fluff/head/codex_access
	name = "\improper Codex access chip"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "booster"
	desc = "A neuro-memetic implant or retinal chip used to grant realtime access to the Codex - a distributed encyclopedia of sorts, with editorial offices based in Venusian orbit - either via a server connection or local backups of relevant information."
	origin_tech = list(TECH_DATA = 2, TECH_DATA = 2)

/obj/item/organ/internal/augment/fluff/head/neurostimulator_implant
	name = "neurostimulator implant"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "booster"
	desc = "An expensive implant attached to the brain's cortex, this network of signal relays sees mixed success as a treatment to lessen the impact of neurological problems such as Parkinson's disease, epilepsy, and paralysis. It can't prevent or heal brain damage on its own, and simply serves to make the life of its owner easier."
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/organ/internal/augment/fluff/head/pain_assistant
	name = "pain assistant"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "booster"
	desc = "This brain implant blocks the impulses of certain nerves - usually tailored between individuals - and is used to lessen chronic pain from worn joints, headaches, and so on. It does nothing for pain that it isn't specifically tuned to handle, and is ineffective against anything stronger than a tummyache."
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/organ/internal/augment/fluff/head/genetic_backup
	name = "genetic backup"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "booster"
	desc = "This implant is a compact and resilient solid-state drive. It does nothing on its own, but contains the complete DNA sequence of its owner - whether it be to aid in medical treatment, serve for research purposes, or even be used as a template for vat-grown humans in the future."
	// This is deliberately kept available for full body prosthetic users; some FBPs may want to maintain a genetic backup of themselves for sentimental reasons
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/item/organ/internal/augment/fluff/head/data_chip
	name = "data chip"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cell"
	desc = "These durable chips can contain nonspecific data for a variety of potential uses, such as record lookups, work portfolios, authentication codes, contact information, and more. They're useful for carrying information without needing extraneous hardware, and some even see use as high-tech dog tags for private security firms or mercenary coalitions."
	origin_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)


// The augments below this line fit in the chest slot, rather than the head slot. We differentiate them in type to let people pick them independently in loadouts
/obj/item/organ/internal/augment/fluff/chest/ups_battery
	name = "UPS battery"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cell"
	desc = "A UPS - or uninterruptible power supply - hooked into your brain or motherboard. It provides no protection from power loss on its own, but provides enough surge protection and emergency power to (hopefully) preserve your personality matrix in the event of a critical failure."
	augment_flags = AUGMENTATION_MECHANIC
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2)


/obj/item/organ/internal/augment/fluff/chest/skeletal_bracing
	name = "skeletal bracing"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "Mechanical hinges and springs made from titanium or some other bio-compatible metal reinforce your joints, generally making strenuous activity less painful for you and allowing you to carry weight that would normally be unbearable. It provides no increase on strength on its own, unless you have weak bones to begin with."
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2)
	discoverable = TRUE // Physical objects around the joints

/obj/item/organ/internal/augment/fluff/chest/ultraviolet_shielding
	name = "ultraviolet shielding"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "Some parts of your epidermis have been replaced with a bio-engineered substitute that's resistant to harmful solar radiation - a common factor in the lives of spacers or inhabitants of planets with a weak magnetosphere."
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	augment_flags = AUGMENTATION_ORGANIC
	discoverable = TRUE // Skin would feel abnormal - maybe smooth/stiff or etc

/obj/item/organ/internal/augment/fluff/chest/recycler_suite
	name = "recycler suite"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "In extreme environments where natural resources are limited or even nonexistent, it may be prudent to recycle nutrients and fluids the body would usually discard. This system reclaims any usable material in the digestive tract that would otherwise be lost to waste."
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	discoverable = TRUE // Intrusive - pipes and tubes etc. exist that wouldn't otherwise be there
