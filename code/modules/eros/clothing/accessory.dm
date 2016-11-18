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
	name = "Silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_blk"
	item_state = "eros_collar_blk"

/obj/item/clothing/accessory/collar/collar_gld
	name = "Golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_gld"
	item_state = "eros_collar_gld"

/obj/item/clothing/accessory/collar/collar_bell
	name = "Bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_bell"
	item_state = "eros_collar_bell"


/obj/item/clothing/accessory/collar/collar_spike
	name = "Spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_spik"
	item_state = "eros_collar_spik"

/obj/item/clothing/accessory/collar/collar_pink
	name = "Pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_pnk"
	item_state = "eros_collar_pnk"

/obj/item/clothing/accessory/collar/collar_steel
	name = "Steel collar"
	desc = "A durable industrial collar, show your pet how much they mean to YOU!"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_steel"
	item_state = "eros_collar_steel"

/obj/item/clothing/accessory/collar/horde
	name = "Locust Necklace"
	desc = "A heavy peice of jewely, it's medalion constructed of dense gold and onyx, the immense chain connected to it appears to be made of a crude iron. This doesn't seem made for the average human...or any human for that matter."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_horde"
	item_state = "eros_horde"

/obj/item/clothing/accessory/collar/collar_GreyChurch
	name = "Lying Cross Necklace"
	desc = "Your not sure why, but this necklace fills with dread and sorrow.Perhaps if you wear it the pain will go away..."
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_greycollar"
	item_state = "eros_greycollar"

/obj/item/clothing/accessory/collar/collar_iron
	name = "Iron Collar"
	desc = "A chunky iron restrait, looks like something from a medievil dungeon, a lengthy chain leads down a ways from it's clasp...why would anyone willingly wear this?"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon_state = "eros_collar_iron"
	item_state = "eros_collar_iron"

/obj/item/clothing/accessory/collar/collar_holo
	name = "Holo-collar"
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
	name = "Arm Warmers"
	desc = "A set of cozy sleeves for your arms, cute and functional."
	slot_flags = SLOT_TIE | SLOT_GLOVES
	icon_state = "eros_armwarmers"
	item_state = "eros_armwarmers"

/obj/item/clothing/accessory/warmers/legwarmers
	name = "Leg Warmers"
	desc = "A set of cozy sleeves for your legs, cute and functional."
	slot_flags = SLOT_TIE | SLOT_FEET
	icon_state = "eros_legwarmers"
	item_state = "eros_legwarmers"
