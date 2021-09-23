/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	closet_appearance = /decl/closet_appearance/wardrobe

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/red

/obj/structure/closet/wardrobe/red/New()
	..()
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/under/rank/security2(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/pink


/obj/structure/closet/wardrobe/pink/New()
	..()
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/black/New()
	..()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/chaplain_black/New()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/clothing/under/wedding/bride_white(src)
	new /obj/item/storage/backpack/cultpack (src)
	new /obj/item/storage/candle_box(src)
	new /obj/item/storage/candle_box(src)
	new /obj/item/deck/tarot(src)

/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/green/New()
	..()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/xenos/New()
	..()
	new /obj/item/clothing/suit/unathi/mantle(src)
	new /obj/item/clothing/suit/unathi/robe(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)

/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	closet_appearance = /decl/closet_appearance/wardrobe/orange

/obj/structure/closet/wardrobe/orange/New()
	..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/radio/headset(src)

/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/yellow/New()
	..()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	..()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

/obj/structure/closet/wardrobe/engineering_yellow/New()
	..()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/shoes/workboots(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)

/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/white/New()
	..()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)

/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/pjs/New()
	..()
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/science_white/New()
	..()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/robotics_black/New()
	..()
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/gloves/thick(src)

/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/chemistry_white/New()
	..()
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(src)

/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/genetics_white/New()
	..()
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/virology_white/New()
	..()
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)

/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/medic_white/New()
	..()
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical/scrubs/blue(src)
	new /obj/item/clothing/under/rank/medical/scrubs/green(src)
	new /obj/item/clothing/under/rank/medical/scrubs/purple(src)
	new /obj/item/clothing/under/rank/medical/scrubs/black(src)
	new /obj/item/clothing/under/rank/medical/scrubs/navyblue(src)
	new /obj/item/clothing/head/surgery/navyblue(src)
	new /obj/item/clothing/head/surgery/purple(src)
	new /obj/item/clothing/head/surgery/blue(src)
	new /obj/item/clothing/head/surgery/green(src)
	new /obj/item/clothing/head/surgery/black(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)

/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/grey

/obj/structure/closet/wardrobe/grey/New()
	..()
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/mixed/New()
	..()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/dress/plaid_blue(src)
	new /obj/item/clothing/under/dress/plaid_red(src)
	new /obj/item/clothing/under/dress/plaid_purple(src)
	new /obj/item/clothing/shoes/blue(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/purple(src)
	new /obj/item/clothing/shoes/red(src)
	new /obj/item/clothing/shoes/leather(src)
	new /obj/item/clothing/accessory/toggleable/hawaii/random(src)

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	closet_appearance = /decl/closet_appearance/tactical

/obj/structure/closet/wardrobe/tactical/New()
	..()
	new /obj/item/clothing/under/tactical(src)
	new /obj/item/clothing/suit/storage/vest/tactical(src)
	new /obj/item/clothing/head/helmet/tactical(src)
	new /obj/item/clothing/mask/balaclava/tactical(src)
	new /obj/item/clothing/glasses/tacgoggles(src)
	new /obj/item/storage/belt/holster/security/tactical(src)
	new /obj/item/clothing/shoes/tactical(src)
	new /obj/item/clothing/gloves/tactical(src)

/obj/structure/closet/wardrobe/suit
	name = "formal clothing locker"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/wardrobe/suit/New()
	..()
	new /obj/item/clothing/under/suit_jacket/charcoal(src)
	new /obj/item/clothing/under/suit_jacket/navy(src)
	new /obj/item/clothing/under/suit_jacket/burgundy(src)
	new /obj/item/clothing/under/suit_jacket/checkered(src)
	new /obj/item/clothing/under/suit_jacket/tan(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/suit_jacket(src)
	new /obj/item/clothing/under/suit_jacket/female(src)
	new /obj/item/clothing/under/suit_jacket/really_black(src)
	new /obj/item/clothing/under/suit_jacket/red(src)
	new /obj/item/clothing/under/scratch(src)
	new /obj/item/clothing/under/rank/internalaffairs/plain(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/under/assistantformal(src)
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/suit/storage/toggle/suit/blue(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/storage/toggle/suit/purple(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/laceup(src)

/obj/structure/closet/wardrobe/lawyer_black
	name = "internal affairs wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/wardrobe/lawyer_black/New()
	..()
	new /obj/item/clothing/under/rank/internalaffairs(src)
	new /obj/item/clothing/under/rank/internalaffairs(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/suit/storage/toggle/suit/black(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/storage/briefcase(src)
	new /obj/item/storage/briefcase(src)
