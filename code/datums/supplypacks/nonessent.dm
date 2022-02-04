/decl/hierarchy/supply_pack/nonessent
	name = "Non-essentials"

/decl/hierarchy/supply_pack/nonessent/painters
	name = "Art - Painting Supplies"
	contains = list(/obj/item/device/paint_sprayer = 2,
					/obj/item/device/cable_painter = 2)
	cost = 10
	containername = "painting supplies crate"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/nonessent/artscrafts
	name = "Art - Arts and Crafts supplies"
	contains = list(/obj/item/storage/fancy/crayons,
	/obj/item/device/camera,
	/obj/item/device/camera_film = 2,
	/obj/item/storage/photo_album,
	/obj/item/stack/package_wrap/twenty_five,
	/obj/item/reagent_containers/glass/paint/red,
	/obj/item/reagent_containers/glass/paint/green,
	/obj/item/reagent_containers/glass/paint/blue,
	/obj/item/reagent_containers/glass/paint/yellow,
	/obj/item/reagent_containers/glass/paint/purple,
	/obj/item/reagent_containers/glass/paint/black,
	/obj/item/reagent_containers/glass/paint/white,
	/obj/item/contraband/poster,
	/obj/item/wrapping_paper = 3)
	cost = 10
	containername = "arts and Crafts crate"


/decl/hierarchy/supply_pack/nonessent/card_packs
	num_contained = 5
	contains = list(/obj/item/pack/cardemon,
					/obj/item/pack/spaceball,
					/obj/item/deck/holder)
	name = "Rec - Trading Cards"
	cost = 20
	containername = "trading cards crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/lasertag
	name = "Rec - Lasertag equipment"
	contains = list(/obj/item/gun/energy/lasertag/red = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/gun/energy/lasertag/blue = 3,
					/obj/item/clothing/suit/bluetag = 3)
	cost = 20
	containertype = /obj/structure/closet
	containername = "lasertag Closet"

/decl/hierarchy/supply_pack/nonessent/instruments
	name = "Rec - Musical Instruments"
	contains = list(/obj/item/device/synthesized_instrument/synthesizer,
					/obj/item/device/synthesized_instrument/guitar/multi,
					/obj/item/device/synthesized_instrument/guitar,
					/obj/item/device/synthesized_instrument/trumpet)
	cost = 40
	containername = "musical instrument crate"


/decl/hierarchy/supply_pack/nonessent/llamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/lava,
					/obj/item/device/flashlight/lamp/lava/red,
					/obj/item/device/flashlight/lamp/lava/orange,
					/obj/item/device/flashlight/lamp/lava/yellow,
					/obj/item/device/flashlight/lamp/lava/green,
					/obj/item/device/flashlight/lamp/lava/cyan,
					/obj/item/device/flashlight/lamp/lava/blue,
					/obj/item/device/flashlight/lamp/lava/purple,
					/obj/item/device/flashlight/lamp/lava/pink)
	name = "Deco - Lava lamps"
	cost = 10
	containername = "lava lamp crate"
	supply_method = /decl/supply_method/randomized


/decl/hierarchy/supply_pack/nonessent/wizard
	name = "Costume - Wizard"
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	cost = 20
	containername = "wizard costume crate"

/decl/hierarchy/supply_pack/nonessent/costume
	num_contained = 2
	contains = list(/obj/item/clothing/suit/pirate,
					/obj/item/clothing/suit/judgerobe,
					/obj/item/clothing/accessory/waistcoat/black,
					/obj/item/clothing/suit/hastur,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/suit/imperium_monk,
					/obj/item/clothing/suit/ianshirt,
					/obj/item/clothing/under/gimmick/rank/captain/suit,
					/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/under/rank/mailman,
					/obj/item/clothing/under/dress/dress_saloon,
					/obj/item/clothing/accessory/suspenders,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
					/obj/item/clothing/under/schoolgirl,
					/obj/item/clothing/under/owl,
					/obj/item/clothing/under/waiter,
					/obj/item/clothing/under/gladiator,
					/obj/item/clothing/under/soviet,
					/obj/item/clothing/under/scratch,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/clothing/suit/chef,
					/obj/item/clothing/suit/apron/overalls,
					/obj/item/clothing/under/redcoat,
					/obj/item/clothing/under/kilt,
					/obj/item/clothing/under/savage_hunter,
					/obj/item/clothing/under/savage_hunter/female,
					/obj/item/clothing/under/wetsuit)
	name = "Costume - Random"
	cost = 10
	containername = "actor costumes crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/formal_wear
	contains = list(/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/that,
					/obj/item/clothing/suit/storage/toggle/suit/blue,
					/obj/item/clothing/suit/storage/toggle/suit/purple,
					/obj/item/clothing/under/suit_jacket,
					/obj/item/clothing/under/suit_jacket/female,
					/obj/item/clothing/under/suit_jacket/really_black,
					/obj/item/clothing/under/suit_jacket/red,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/accessory/waistcoat/black)
	name = "Costume - Formalwear"
	cost = 30
	containertype = /obj/structure/closet
	containername = "formalwear for the best occasions."


/decl/hierarchy/supply_pack/nonessent/hats
	num_contained = 4
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Costume - Collectible hats!"
	cost = 200
	containername = "\improper Collectable hats crate! Brought to you by Bass.inc!"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/witch
	name = "Costume - Witch"
	contains = list(/obj/item/clothing/suit/wizrobe/marisa/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/marisa/fake,
					/obj/item/staff/broom)
	cost = 20
	containername = "witch costume crate"
	containertype = /obj/structure/closet

/decl/hierarchy/supply_pack/nonessent/costume_hats
	name = "Costume - Regular hats"
	contains = list(/obj/item/clothing/head/redcoat,
					/obj/item/clothing/head/mailman,
					/obj/item/clothing/head/plaguedoctorhat,
					/obj/item/clothing/head/pirate,
					/obj/item/clothing/head/hasturhood,
					/obj/item/clothing/head/powdered_wig,
					/obj/item/clothing/head/hairflower,
					/obj/item/clothing/head/hairflower/yellow,
					/obj/item/clothing/head/hairflower/blue,
					/obj/item/clothing/head/hairflower/pink,
					/obj/item/clothing/mask/gas/owl_mask,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/head/helmet/gladiator,
					/obj/item/clothing/head/ushanka,
					/obj/item/clothing/mask/spirit)
	cost = 10
	containername = "actor hats crate"
	containertype = /obj/structure/closet
	num_contained = 2
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/dresses
	name = "Costume - Womens formal dress locker"
	contains = list(/obj/item/clothing/under/wedding/bride_orange,
					/obj/item/clothing/under/wedding/bride_purple,
					/obj/item/clothing/under/wedding/bride_blue,
					/obj/item/clothing/under/wedding/bride_red,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/clothing/under/sundress,
					/obj/item/clothing/under/dress/dress_green,
					/obj/item/clothing/under/dress/dress_pink,
					/obj/item/clothing/under/dress/dress_orange,
					/obj/item/clothing/under/dress/dress_yellow,
					/obj/item/clothing/under/dress/dress_saloon)
	cost = 15
	containername = "pretty dress locker"
	containertype = /obj/structure/closet
	num_contained = 1
	supply_method = /decl/supply_method/randomized



/decl/hierarchy/supply_pack/nonessent/officetoys
	name = "Deco - Office toys"
	contains = list(/obj/item/toy/desk/newtoncradle,
					/obj/item/toy/desk/fan,
					/obj/item/toy/desk/officetoy,
					/obj/item/toy/desk/dippingbird)
	cost = 15
	containername = "office toys crate"

/decl/hierarchy/supply_pack/nonessent/holoplants
	name = "Deco - Holoplants"
	contains = list(/obj/structure/holoplant = 5)
	cost = 40
	containername = "holoplants crate"
	containertype = /obj/structure/largecrate

/decl/hierarchy/supply_pack/nonessent/chaplaingear
	name = "Costume - Chaplain"
	contains = list(/obj/item/clothing/under/rank/chaplain,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/head/nun_hood,
					/obj/item/clothing/suit/chaplain_hoodie,
					/obj/item/clothing/head/chaplain_hood,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/under/wedding/bride_white,
//					/obj/item/storage/backpack/cultpack,
					/obj/item/storage/candle_box = 3)
	cost = 10
	containername = "chaplain equipment crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod
	num_contained = 1
	name = "Mod - \"Firestarter\" exosuit modkit"
	contains = list(/obj/item/device/kit/paint/flames_red)
	cost = 50
	containername = "heavy exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod/chrome
	name = "Mod - \"Burning Chrome\" exosuit modkit"
	contains = list(/obj/item/device/kit/paint/flames_blue)

/decl/hierarchy/supply_pack/nonessent/exosuit_mod/military
	name = "Mod - \"Guerilla\" exosuit modkit"
	contains = list(/obj/item/device/kit/paint/camouflage)

/decl/hierarchy/supply_pack/nonessent/exosuit_mod/alpine
	name = "Mod - \"Alpine\" exosuit modkit"
	contains = list(/obj/item/device/kit/paint/camouflage/forest)

/decl/hierarchy/supply_pack/nonessent/aromatherapy
	name = "Rec - Aromatherapy"
	contains = list(
		/obj/item/paper/aromatherapy_disclaimer,
		/obj/item/storage/candle_box/scented = 3,
		/obj/item/storage/candle_box/incense = 6,
		/obj/item/flame/lighter/random)
	cost = 15
	containername = "aromatherapy crate"

/decl/hierarchy/supply_pack/nonessent/pins
	name = "Costume - Pride Pin Crate"
	contains = list(
		/obj/item/clothing/accessory/pride_pin/transgender = 2,
		/obj/item/clothing/accessory/pride_pin/lesbian = 2,
		/obj/item/clothing/accessory/pride_pin/bisexual = 2,
		/obj/item/clothing/accessory/pride_pin/gay = 2,
		/obj/item/clothing/accessory/pride_pin/pansexual = 2,
		/obj/item/clothing/accessory/pride_pin/nonbinary = 2,
		/obj/item/clothing/accessory/pride_pin/asexual = 2,
		/obj/item/clothing/accessory/pride_pin/intersex = 2
	)
	cost = 20
	containername = "pin crate"

/decl/hierarchy/supply_pack/nonessent/pronounbadges
	name = "Costume - Pronoun Badge Crate"
	contains = list(
		/obj/item/clothing/accessory/pronouns/they = 2,
		/obj/item/clothing/accessory/pronouns/hehim = 2,
		/obj/item/clothing/accessory/pronouns/sheher = 2,
		/obj/item/clothing/accessory/pronouns/hethey = 2,
		/obj/item/clothing/accessory/pronouns/shethey = 2,
		/obj/item/clothing/accessory/pronouns/heshe = 2,
		/obj/item/clothing/accessory/pronouns/ask = 2
	)
	cost = 20
	containername = "pronoun badge crate"
