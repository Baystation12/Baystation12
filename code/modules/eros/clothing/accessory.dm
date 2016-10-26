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