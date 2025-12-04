/obj/item/clothing/accessory/prayer_beads
	name = "prayer beads"
	desc = "A string of beads used by various religions to count prayers."
	icon = 'icons/obj/clothing/religious.dmi'
	icon_state = "beads"
	overlay_state = "beads"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK


/obj/item/clothing/accessory/prayer_beads/attack_self(mob/living/carbon/human/user)
	if (!ishuman(user))
		return
	user.visible_message("\The [user] begins to count through the beads of \the [src]...", "You begin to count through the beads of \the [src]...")
	if (do_after(user, 5 SECONDS, src, do_flags = DO_PUBLIC_UNIQUE))
		user.visible_message("\The [user] finishes counting through the beads of \the [src].", "You finish counting through the beads of \the [src].")

/obj/item/clothing/accessory/prayer_beads/rosary
	name = "rosary"
	desc = "A string of beads with a cross attached to it. It is used by Christians to count prayers."
	icon_state = "rosary"
	overlay_state = "rosary"

/obj/item/clothing/accessory/crucifix
	name = "crucifix"
	desc = "A small cross on a piece of string. Commonly associated with the Christian faith, it is a primary symbol of this religion."
	icon = 'icons/obj/clothing/religious.dmi'
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/crucifix/gold
	name = "gold crucifix"
	desc = "A small, gold cross on a piece of string. Commonly associated with the Christian faith, it is the primary symbol of this religion."
	icon_state = "golden_crucifix"
	item_state = "golden_crucifix"

/obj/item/clothing/accessory/crucifix/gold/saint_peter
	name = "gold Saint Peter crucifix"
	desc = "A small, gold cross on a piece of string. Being inverted and thus upside down marks it as the cross of Saint Peter, a historic Christian symbol \
	which has been re-purposed as a satanic symbol since the 21st century as well."
	icon_state = "golden_crucifix_ud"
	item_state = "golden_crucifix_ud"

/obj/item/clothing/accessory/crucifix/silver
	name = "silver crucifix"
	desc = "A small, silver cross on a piece of string. Commonly associated with the Christian faith, it the primary symbol of this religion."
	icon_state = "silver_crucifix"
	item_state = "silver_crucifix"

/obj/item/clothing/accessory/crucifix/silver/saint_peter
	name = "silver Saint Peter crucifix"
	desc = "A small, silver cross on a piece of string. Being inverted and thus upside down marks it as the cross of Saint Peter, a historic Christian symbol \
	which has been re-purposed as a satanic symbol since the 21st century as well."
	icon_state = "silver_crucifix_ud"
	item_state = "silver_crucifix_ud"

/obj/item/clothing/accessory/scapular
	name = "scapular"
	desc = "A Christian garment suspended from the shoulders. As an object of popular piety, \
	it serves to remind the wearers of their commitment to live a Christian life."
	icon = 'icons/obj/clothing/religious.dmi'
	icon_state = "scapular"
	item_state = "scapular"

/obj/item/clothing/accessory/tallit
	name = "tallit"
	desc = "A tallit is a fringed garment worn as a prayer shawl by religious Jews. \
	The tallit has special twined and knotted fringes known as tzitzit attached to its four corners."
	icon = 'icons/obj/clothing/religious.dmi'
	item_state = "tallit"
	icon_state = "tallit"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/clergy_collar
	name = "clergy collar"
	desc = "A white clergy collar worn by Christian clergy."
	icon_state = "clergy_collar"

/obj/item/clothing/under/cassock
	name = "clergy cassock"
	desc = "It's a black cassock, often worn by Catholic clergy."
	icon_state = "clergy_cassock"
	worn_state = "clergy_cassock"
