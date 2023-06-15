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

/obj/item/storage/box/syndie_kit/shuriken
	startswith = list(
		/obj/item/material/star/ninja,
		/obj/item/material/star/ninja,
		/obj/item/material/star/ninja,
		/obj/item/material/star/ninja,
		/obj/item/material/star/ninja,
		/obj/item/material/star/ninja,
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
		/obj/item/gun/launcher/syringe/disguised = 1,
		/obj/item/syringe_cartridge = 4,
		/obj/item/reagent_containers/syringe = 4
	)

/obj/item/storage/box/syndie_kit/cigarette
	name = "tricky smokes"
	desc = "Smokes so good, you'd think it was a trick!"
	startswith = list(
		/obj/item/flame/lighter/zippo = 1,
		/obj/item/storage/fancy/smokable/antag/fire = 2,
		/obj/item/storage/fancy/smokable/antag/smoke = 2,
		/obj/item/storage/fancy/smokable/antag/mindbreaker = 1,
		/obj/item/storage/fancy/smokable/antag/tricordrazine = 1
	)


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
/obj/item/storage/box/syndie_kit/corpse_cube
	startswith = list(
		/obj/item/device/dna_sampler,
		/obj/item/reagent_containers/food/snacks/corpse_cube
	)
