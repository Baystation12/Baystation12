/obj/item/clothing/accessory/storage/black_drop_pouches
	name = "black drop pouches"
	gender = PLURAL
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "eros_thigh_black"
	slots = 5

/obj/item/clothing/accessory/storage/brown_drop_pouches
	name = "brown drop pouches"
	gender = PLURAL
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "eros_thigh_brown"
	slots = 5

/obj/item/clothing/accessory/storage/white_drop_pouches
	name = "white drop pouches"
	gender = PLURAL
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "eros_thigh_white"
	slots = 5

/obj/item/clothing/accessory/collar/collar_blk
	name = "silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_blk"
	item_state = "eros_collar_blk"

/obj/item/clothing/accessory/collar/collar_gld
	name = "golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_gld"
	item_state = "eros_collar_gld"

/obj/item/clothing/accessory/collar/collar_bell
	name = "bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_bell"
	item_state = "eros_collar_bell"


/obj/item/clothing/accessory/collar/collar_spike
	name = "spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_spik"
	item_state = "eros_collar_spik"

/obj/item/clothing/accessory/collar/collar_pink
	name = "pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_pnk"
	item_state = "eros_collar_pnk"

/obj/item/clothing/accessory/collar/collar_steel
	name = "steel collar"
	desc = "A durable industrial collar, show your pet how much they mean to YOU!"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_steel"
	item_state = "eros_collar_steel"

/obj/item/clothing/accessory/collar/horde
	name = "locust necklace"
	desc = "A heavy peice of jewely, it's medalion constructed of dense gold and onyx, the immense chain connected to it appears to be made of a crude iron. This doesn't seem made for the average human...or any human for that matter."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_horde"
	item_state = "eros_horde"

/obj/item/clothing/accessory/collar/collar_greychurch
	name = "lying cross necklace"
	desc = "Your not sure why, but this necklace fills with dread and sorrow. Perhaps if you wear it the pain will go away..."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_greycollar"
	item_state = "eros_greycollar"

/obj/item/clothing/accessory/collar/collar_iron
	name = "iron collar"
	desc = "A chunky iron restrait, looks like something from a medievil dungeon, a lengthy chain leads down a ways from it's clasp...why would anyone willingly wear this?"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_iron"
	item_state = "eros_collar_iron"

/obj/item/clothing/accessory/collar/collar_holo
	name = "holo-collar"
	desc = "An expensive holo-collar for the modern day pet."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_holo"
	item_state = "eros_collar_holo"

/obj/item/clothing/accessory/collar/collar_holo/attack_self(mob/user as mob)
	user << "<span class='notice'>[name]'s interface is projected onto your hand.</span>"

	var/str = copytext(reject_bad_text(input(user,"Tag text?","Set tag","")),1,MAX_NAME_LEN)

	if(!str || !length(str))
		user << "<span class='notice'>[name]'s tag set to be blank.</span>"
		name = initial(name)
		desc = initial(desc)
	else
		user << "<span class='notice'>You set the [name]'s tag to '[str]'.</span>"
		name = initial(name) + " ([str])"
		desc = initial(desc) + " The tag says \"[str]\"."

/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon_state = "eros_scarf"
	item_state = "eros_scarf"

/obj/item/clothing/accessory/scarf/red
	name = "red scarf"
	icon_state = "eros_redscarf"
	item_state = "eros_redscarf"

/obj/item/clothing/accessory/scarf/green
	name = "green scarf"
	icon_state = "eros_greenscarf"
	item_state = "eros_greenscarf"

/obj/item/clothing/accessory/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "eros_darkbluescarf"
	item_state = "eros_darkbluescarf"

/obj/item/clothing/accessory/scarf/purple
	name = "purple scarf"
	icon_state = "eros_purplescarf"
	item_state = "eros_purplescarf"

/obj/item/clothing/accessory/scarf/yellow
	name = "yellow scarf"
	icon_state = "eros_yellowscarf"
	item_state = "eros_yellowscarf"

/obj/item/clothing/accessory/scarf/orange
	name = "orange scarf"
	icon_state = "eros_orangescarf"
	item_state = "eros_orangescarf"

/obj/item/clothing/accessory/scarf/lightblue
	name = "light blue scarf"
	icon_state = "eros_lightbluescarf"
	item_state = "eros_lightbluescarf"

/obj/item/clothing/accessory/scarf/white
	name = "white scarf"
	icon_state = "eros_whitescarf"
	item_state = "eros_whitescarf"

/obj/item/clothing/accessory/scarf/black
	name = "black scarf"
	icon_state = "eros_blackscarf"
	item_state = "eros_blackscarf"

/obj/item/clothing/accessory/scarf/zebra
	name = "zebra scarf"
	icon_state = "eros_zebrascarf"
	item_state = "eros_zebrascarf"

/obj/item/clothing/accessory/scarf/christmas
	name = "christmas scarf"
	icon_state = "eros_christmasscarf"
	item_state = "eros_christmasscarf"

/obj/item/clothing/accessory/stripedredscarf
	name = "striped red scarf"
	icon_state = "eros_stripedredscarf"
	item_state = "eros_stripedredscarf"

/obj/item/clothing/accessory/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "eros_stripedgreenscarf"
	item_state = "eros_stripedgreenscarf"

/obj/item/clothing/accessory/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "eros_stripedbluescarf"
	item_state = "eros_stripedbluescarf"

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	icon_state = "eros_chaps"
	item_state = "eros_chaps"

/obj/item/clothing/accessory/chaps/black
	name = "brown chaps"
	icon_state = "eros_chaps_black"
	item_state = "eros_chaps_black"

/obj/item/clothing/accessory/warmers/armwarmers
	name = "arm warmers"
	desc = "A set of cozy sleeves for your arms, cute and functional."
	slot_flags = SLOT_TIE | SLOT_GLOVES
	icon_state = "eros_armwarmers"
	item_state = "eros_armwarmers"

/obj/item/clothing/accessory/warmers/legwarmers
	name = "leg warmers"
	desc = "A set of cozy sleeves for your legs, cute and functional."
	slot_flags = SLOT_TIE | SLOT_FEET
	icon_state = "eros_legwarmers"
	item_state = "eros_legwarmers"

/obj/item/clothing/accessory/collar/fakebling
	name = "bling"
	desc = "Whoa, that .. is actually just shiny plastic, on closer inspection"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "bling"
	item_state = "bling"

/obj/item/clothing/accessory/bling
	name = "legit bling"
	desc = "Whoa. That's solid gold."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "bling"
	item_state = "bling"

/obj/item/clothing/accessory/collar/talisman
	name = "primitive talisman"
	desc = "A leather band, with claws of some creature dangling off it."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "talisman"
	item_state = "talisman"

/obj/item/clothing/accessory/lawyerbadge
	name = "lawyer badge"
	desc = "People who are real lawyers like to go around showing their badges to people."
	icon_state = "lawyerbadge"
	item_state = "lawyerbadge"


// SHIRTS!


/obj/item/clothing/accessory/shirt
	desc = "A shirt."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	body_parts_covered = UPPER_TORSO
	show_genitals = 1

/obj/item/clothing/accessory/shirt/sweaterpink
	name = "pink sweater"
	desc = "This pink sweater was knit with care and nothing's as comfy."
	icon_state = "eros_sweater_pink"
	item_state = "eros_sweater_pink"

/obj/item/clothing/accessory/shirt/sweaterblue
	name = "blue sweater"
	desc = "This blue sweater was knit with care and nothing's as comfy."
	icon_state = "eros_sweater_blue"
	item_state = "eros_sweater_blue"

/obj/item/clothing/accessory/shirt/sweaterblueheart
	name = "blue heart sweater"
	desc = "This blue sweater was knit with care and nothing's as comfy. It has a cute heart on it."
	icon_state = "eros_sweater_blueheart"
	item_state = "eros_sweater_blueheart"

/obj/item/clothing/accessory/shirt/sweatermint
	name = "mint sweater"
	desc = "This mint green sweater was knit with care and nothing's as comfy."
	icon_state = "eros_sweater_mint"
	item_state = "eros_sweater_mint"

/obj/item/clothing/accessory/shirt/sweaternt
	name = "NT sweater"
	desc = "This sweater was knit with care and nothing's as comfy.It's NT themed."
	icon_state = "eros_sweater_nt"
	item_state = "eros_sweater_nt"

/obj/item/clothing/accessory/shirt/sweatersnow
	name = "snowman sweater"
	desc = "This sweater was knit with care and nothing's as comfy.It has a snowy scene with a snowman."
	icon_state = "eros_cjumper_blue"
	item_state = "eros_cjumper_blue"

/obj/item/clothing/accessory/shirt/sweatertree
	name = "christmas tree sweater"
	desc = "This sweater was knit with care and nothing's as comfy.It has a Christmas tree on it"
	icon_state = "eros_cjumper_red"
	item_state = "eros_cjumper_red"

/obj/item/clothing/accessory/shirt/sweaterreindeer
	name = "ugly holiday sweater"
	desc = "This sweater was knit with care and nothing's as comfy.It has a reindeer on it."
	icon_state = "eros_cjumper_green"
	item_state = "eros_cjumper_green"

/obj/item/clothing/accessory/shirt/singletwhite
	name = "white singlet"
	desc = "A white singlet."
	icon_state = "singlet_white"
	item_state = "singlet_white"

/obj/item/clothing/accessory/shirt/singletblack
	name = "black singlet"
	desc = "A black singlet."
	icon_state = "singlet_black"
	item_state = "singlet_black"

/obj/item/clothing/accessory/shirt/singlet
	name = "singlet"
	desc = "A singlet."
	icon_state = "singlet_white"
	item_state = "singlet_white"

/obj/item/clothing/accessory/shirt/whitelongsleeve
	name = "white longsleeve shirt"
	desc = "A white shirt with long sleeves. Great for any white collar worker."
	icon_state = "longsleeve_white"
	item_state = "longsleeve_white"

/obj/item/clothing/accessory/shirt/turtleneckblack
	name = "black turtleneck"
	desc = "A thick, black turtleneck shirt. For when the air gets a bit chilly."
	icon_state = "turtleneck_black"
	item_state = "turtleneck_black"

/obj/item/clothing/accessory/shirt/turtleneckwinter
	name = "winter turtleneck shirt"
	desc = "A thick, red turtleneck shirt with a wintery design. For when the air gets a bit nippy."
	icon_state = "turtleneck_winterred"
	item_state = "turtleneck_winterred"

/obj/item/clothing/accessory/shirt/longsleeve
	name = "longsleeve shirt"
	desc = "A shirt with long sleeves."
	icon_state = "longsleeve_white"
	item_state = "longsleeve_white"

/obj/item/clothing/accessory/shirt/chemisewhite
	name = "white chemise"
	desc = "A plain white chemise."
	icon_state = "chemise_white"
	item_state = "chemise_white"

/obj/item/clothing/accessory/shirt/chemise
	name = "chemise"
	desc = "A plain chemise."
	icon_state = "chemise_white"
	item_state = "chemise_white"

/obj/item/clothing/accessory/shirt/tshirtgrey
	name = "grey t-shirt"
	desc = "A plain grey t-shirt. A popular piece of human clothing."
	icon_state = "tshirt_grey"
	item_state = "tshirt_grey"

/obj/item/clothing/accessory/shirt/tshirtwhite
	name = "white t-shirt"
	desc = "A plain white t-shirt. A popular piece of human clothing."
	icon_state = "shirt_white"
	item_state = "shirt_white"

/obj/item/clothing/accessory/shirt/tshirtblack
	name = "black t-shirt"
	desc = "A plain black t-shirt. A popular piece of human clothing."
	icon_state = "shirt_black"
	item_state = "shirt_black"

/obj/item/clothing/accessory/shirt/tshirt
	name = "t-shirt"
	desc = "A plain t-shirt. A popular piece of human clothing."
	icon_state = "shirt_white"
	item_state = "shirt_white"