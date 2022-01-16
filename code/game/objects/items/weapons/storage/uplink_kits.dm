/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box."
	icon_state = "box_of_doom"

//For uplink kits that provide bulkier items
/obj/item/storage/backpack/satchel/syndie_kit
	desc = "A sleek, sturdy satchel."
	icon_state = "satchel-norm"

//In case an uplink kit provides a lot of gear
/obj/item/storage/backpack/dufflebag/syndie_kit
	name = "black dufflebag"
	desc = "A sleek, sturdy dufflebag."
	icon_state = "duffle_syndie"

/obj/item/storage/box/syndie_kit/imp_freedom
	startswith = list(/obj/item/implanter/freedom)

/obj/item/storage/box/syndie_kit/imp_uplink
	startswith = list(/obj/item/implanter/uplink)

/obj/item/storage/box/syndie_kit/imp_compress
	startswith = list(/obj/item/implanter/compressed)

/obj/item/storage/box/syndie_kit/imp_explosive
	startswith = list(
		/obj/item/implanter/explosive,
		/obj/item/implantpad
		)

/obj/item/storage/box/syndie_kit/imp_imprinting
	startswith = list(
		/obj/item/implanter/imprinting,
		/obj/item/implantpad,
		/obj/item/reagent_containers/hypospray/autoinjector/mindbreaker
		)

// Space suit uplink kit
/obj/item/storage/backpack/satchel/syndie_kit/space
	//name = "\improper EVA gear pack"

	startswith = list(
		/obj/item/clothing/suit/space/void/merc,
		/obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/tank/oxygen_emergency_double,
		)

// Chameleon uplink kit
/obj/item/storage/backpack/chameleon/sydie_kit
	startswith = list(
		/obj/item/clothing/under/chameleon,
		/obj/item/clothing/suit/chameleon,
		/obj/item/clothing/shoes/chameleon,
		/obj/item/clothing/head/chameleon,
		/obj/item/clothing/mask/chameleon,
		/obj/item/storage/box/syndie_kit/chameleon,
		/obj/item/gun/energy/chameleon,
		)

/obj/item/storage/box/syndie_kit/chameleon
	startswith = list(
		/obj/item/clothing/gloves/chameleon,
		/obj/item/clothing/glasses/chameleon,
		/obj/item/device/radio/headset/chameleon,
		/obj/item/clothing/accessory/chameleon,
		/obj/item/clothing/accessory/chameleon,
		/obj/item/clothing/accessory/chameleon
		)

// Clerical uplink kit
/obj/item/storage/backpack/satchel/syndie_kit/clerical
	startswith = list(
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/hand_labeler,
		/obj/item/stamp/chameleon,
		/obj/item/pen/chameleon,
		/obj/item/device/destTagger,
		)

/obj/item/storage/box/syndie_kit/spy
	startswith = list(
		/obj/item/device/spy_bug = 6,
		/obj/item/device/spy_monitor
	)

/obj/item/storage/box/syndie_kit/silenced
	startswith = list(
		/obj/item/gun/projectile/pistol/holdout,
		/obj/item/silencer,
		/obj/item/ammo_magazine/pistol/small
	)

/obj/item/storage/backpack/satchel/syndie_kit/revolver
	startswith = list(
		/obj/item/gun/projectile/revolver,
		/obj/item/ammo_magazine/speedloader/magnum
	)

/obj/item/storage/box/syndie_kit/toxin
	startswith = list(
		/obj/item/reagent_containers/glass/beaker/vial/random/toxin,
		/obj/item/reagent_containers/syringe
	)

/obj/item/storage/box/syndie_kit/syringegun
	startswith = list(
		/obj/item/gun/launcher/syringe/disguised,
		/obj/item/syringe_cartridge = 4,
		/obj/item/reagent_containers/syringe = 4
	)

/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Smokes so good, you'd think it was a trick!"

/obj/item/storage/box/syndie_kit/cigarette/New()
	..()
	var/obj/item/storage/fancy/cigarettes/pack
	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/mindbreaker = 4))
	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list(/datum/reagent/tricordrazine = 4))
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/flame/lighter/zippo(src)

/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.max_storage_space)

//Rig Electrowarfare and Voice Synthesiser kit
/obj/item/storage/backpack/satchel/syndie_kit/ewar_voice
	startswith = list(
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		)

/obj/item/storage/secure/briefcase/heavysniper
	startswith = list(
		/obj/item/gun/projectile/heavysniper,
		/obj/item/storage/box/ammo/sniperammo
	)

/obj/item/storage/secure/briefcase/heavysniper/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/storage/secure/briefcase/money

	startswith = list(/obj/item/spacecash/bundle/c1000 = 10)

/obj/item/storage/backpack/satchel/syndie_kit/armor
	startswith = list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc
	)
