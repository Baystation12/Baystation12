/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first aid kit"
	desc = "An emergency medical kit for treating minor injuries."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE

/obj/item/weapon/storage/firstaid/fire
	name = "fire first aid kit"
	desc = "An emergency medical kit containing basic supplies for treating burns."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/weapon/reagent_containers/pill/spaceacillin = 2,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/fire/New()
	..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector = 2,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid kit"
	desc = "An emergency medical kit containing basic supplies for treating poisoning."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/pill/charcoal = 4,
		/obj/item/clothing/gloves/latex,
		)
/obj/item/weapon/storage/firstaid/toxin/New()
	..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/weapon/storage/firstaid/radiation
	name = "radiation first aid kit"
	desc = "An emergency medical kit containing basic supplies for treating radiation poisoning."
	icon_state = "radfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/device/geiger,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/pill/hyronalin = 4,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/radiation/New()
	..()
	icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "An emergency medical kit containing basic supplies for treating oxygen deprivation."
	icon_state = "o2"
	item_state = "firstaid-o2"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/pill/chloromydride = 4,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/adv
	name = "trauma first aid kit"
	desc = "An emergency medical kit containing basic supplies for treating traumas."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/splint,
		/obj/item/weapon/reagent_containers/pill/spaceacillin = 2,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains highly advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/weapon/storage/pill_bottle/tramadol,
		/obj/item/weapon/storage/pill_bottle/spaceacillin,
		/obj/item/weapon/storage/pill_bottle/charcoal,
		/obj/item/stack/medical/splint,
		/obj/item/weapon/reagent_containers/syringe/chloromydride = 2,
		/obj/item/weapon/reagent_containers/syringe/synaptizine,
		/obj/item/weapon/reagent_containers/syringe/peridaxon,
		/obj/item/weapon/reagent_containers/syringe/primordapine,
		/obj/item/weapon/reagent_containers/syringe/sarcohemalazapine,
		)

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."

	startswith = list(
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/cautery,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/retractor,
		/obj/item/weapon/scalpel,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/clothing/gloves/latex,
		)

/obj/item/weapon/storage/firstaid/surgery/New()
	..()
	make_exact_fit()

/obj/item/weapon/storage/firstaid/personal
	name = "advanced first aid kit"
	desc = "An emergency medical kit tailored for healthcare providers."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/device/healthanalyzer,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/splint,
		/obj/item/weapon/reagent_containers/glass/bottle/saline,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/syringe/chloromydride,
		)

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = null

/obj/item/weapon/storage/pill_bottle/antitox
	name = "bottle of dylovene pills"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/weapon/reagent_containers/pill/antitox = 7)

/obj/item/weapon/storage/pill_bottle/charcoal
	name = "bottle of activated charcoal pills"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/weapon/reagent_containers/pill/charcoal = 7)

/obj/item/weapon/storage/pill_bottle/bicaridine
	name = "bottle of bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."

	startswith = list(/obj/item/weapon/reagent_containers/pill/bicaridine = 7)

/obj/item/weapon/storage/pill_bottle/metorapan
	name = "bottle of metorapan pills"
	desc = "Contains pills used to stabilize the injured."

	startswith = list(/obj/item/weapon/reagent_containers/pill/metorapan = 7)

/obj/item/weapon/storage/pill_bottle/dexalin
	name = "bottle of dexalin pills"
	desc = "Contains pills used to treat cases of oxygen deprivation."

	startswith = list(/obj/item/weapon/reagent_containers/pill/dexalin = 7)

/obj/item/weapon/storage/pill_bottle/dexalin_plus
	name = "bottle of dexalin plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."

	startswith = list(/obj/item/weapon/reagent_containers/pill/dexalin_plus = 7)

/obj/item/weapon/storage/pill_bottle/dermaline
	name = "bottle of dermaline pills"
	desc = "Contains pills used to treat burn wounds."

	startswith = list(/obj/item/weapon/reagent_containers/pill/dermaline = 7)

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "bottle of inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

	startswith = list(/obj/item/weapon/reagent_containers/pill/inaprovaline = 7)

/obj/item/weapon/storage/pill_bottle/chloromydride
	name = "bottle of chloromydride pills"
	desc = "Contains pills used to stabilize patients."

	startswith = list(/obj/item/weapon/reagent_containers/pill/chloromydride = 7)

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

	startswith = list(/obj/item/weapon/reagent_containers/pill/kelotane = 7)

/obj/item/weapon/storage/pill_bottle/spaceacillin
	name = "bottle of spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

	startswith = list(/obj/item/weapon/reagent_containers/pill/spaceacillin = 7)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "bottle of tramadol pills"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/weapon/reagent_containers/pill/tramadol = 7)

/obj/item/weapon/storage/pill_bottle/paracetamol
	name = "bottle of paracetamol pills"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/weapon/reagent_containers/pill/paracetamol = 7)

//Baycode specific Psychiatry pills.
/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of citalopram pills"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."

	startswith = list(/obj/item/weapon/reagent_containers/pill/citalopram = 7)

/obj/item/weapon/storage/pill_bottle/methylphenidate
	name = "bottle of methylphenidate pills"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."

	startswith = list(/obj/item/weapon/reagent_containers/pill/methylphenidate = 7)

/obj/item/weapon/storage/pill_bottle/paroxetine
	name = "bottle of paroxetine pills"
	desc = "High-strength antidepressant. Only for use in severe depression. 10u dose per pill. <span class='warning'>WARNING: side-effects may include hallucinations.</span>"

	startswith = list(/obj/item/weapon/reagent_containers/pill/paroxetine = 7)
