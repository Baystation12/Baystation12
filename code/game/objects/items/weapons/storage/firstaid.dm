/obj/item/storage/firstaid
	abstract_type = /obj/item/storage/firstaid
	name = "base first-aid kit"
	icon = 'icons/obj/medical.dmi'
	icon_state = "fak-basic"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	matter = list(MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 300, MATERIAL_ALUMINIUM = 200)
	origin_tech = list(TECH_MATERIAL = 2)
	use_sound = 'sound/effects/storage/briefcase.ogg'
	allow_slow_dump = TRUE


/obj/item/storage/firstaid/empty
	name = "empty first-aid kit"
	desc = "It's an emergency medical kit for people who like wish soup."


/obj/item/storage/firstaid/regular
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antidexafen,
		/obj/item/storage/pill_bottle/paracetamol,
		/obj/item/stack/medical/splint
	)


/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "fak-trauma-1"
	item_state = "firstaid-brute"
	startswith = list(
		/obj/item/storage/med_pouch/trauma = 4
	)


/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "fak-burns-1"
	item_state = "firstaid-ointment"
	startswith = list(
		/obj/item/storage/med_pouch/burn = 4
	)


/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "fak-toxin-1"
	item_state = "firstaid-toxin"
	startswith = list(
		/obj/item/storage/med_pouch/toxin = 4
	)



/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "fak-oxygen-1"
	item_state = "firstaid-o2"
	startswith = list(
		/obj/item/storage/med_pouch/oxyloss = 4
	)


/obj/item/storage/firstaid/radiation
	name = "radiation first-aid kit"
	desc = "It's an emergency medical kit for when you try to hug the reactor."
	icon_state = "fak-radiation-1"
	item_state = "firstaid-ointment"
	startswith = list(
		/obj/item/storage/med_pouch/radiation = 4
	)


/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "fak-advanced"
	item_state = "firstaid-advanced"
	startswith = list(
		/obj/item/storage/pill_bottle/assorted,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint
	)


/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "fak-combat"
	item_state = "firstaid-combat"
	startswith = list(
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/stack/medical/splint
	)


/obj/item/storage/firstaid/stab
	name = "stabilisation first aid"
	desc = "Stocked with medical pouches."
	icon_state = "fak-multi"
	item_state = "firstaid-advanced"
	startswith = list(
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation
	)


/obj/item/storage/firstaid/sleekstab
	name = "Slimline stabilisation kit"
	desc = "A sleek and expensive looking medical kit."
	icon_state = "fak-multi"
	item_state = "firstaid-advanced"
	w_class = ITEM_SIZE_SMALL
	storage_slots = 7
	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/coagulant,
		/obj/item/reagent_containers/hypospray/autoinjector/pain,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
		/obj/item/reagent_containers/hypospray/autoinjector/dexalin_plus,
		/obj/item/reagent_containers/hypospray/autoinjector/detox
	)


/obj/item/storage/firstaid/light
	name = "light first-aid kit"
	desc = "It's a small emergency medical kit."
	use_sound = 'sound/effects/storage/pillbottle.ogg'
	icon_state = "fak-light"
	matter = list(MATERIAL_PLASTIC = 600)
	storage_slots = 5
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	startswith = list(
		/obj/item/clothing/gloves/latex/nitrile,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
		/obj/item/stack/medical/bruise_pack
	)
	contents_allowed = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack
	)


/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon_state = "surgery"
	item_state = "firstaid-surgery"
	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null
	w_class = ITEM_SIZE_LARGE
	contents_allowed = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
	)
	startswith = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel/basic,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack
	)


/obj/item/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant, self-refrigerating device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/medical.dmi'
	icon_state = "freezer"
	item_state = "firstaid-brute"
	foldable = null
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	allow_quick_gather = TRUE
	temperature = -16 CELSIUS
	matter = list(MATERIAL_PLASTIC = 350)
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2)
	contents_allowed = list(
		/obj/item/organ,
		/obj/item/reagent_containers
	)


/obj/item/storage/box/freezer/ProcessAtomTemperature()
	return PROCESS_KILL
