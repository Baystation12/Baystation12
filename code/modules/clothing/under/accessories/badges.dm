/*
	Badges are worn on the belt or neck, and can be used to show the user's credentials.
	The user' details can be imprinted on holobadges with the relevant ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "A leather-backed badge, with gold trimmings."
	icon_state = "detectivebadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	high_visibility = 1
	var/badge_string = "Detective"
	var/stored_name

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name

/obj/item/clothing/accessory/badge/proc/set_desc(var/mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/clothing/accessory/badge/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["look_at_me"])
		if(istype(user))
			user.examinate(src)
			return TOPIC_HANDLED

/obj/item/clothing/accessory/badge/get_examine_line()
	. = ..()
	. += "  <a href='?src=\ref[src];look_at_me=1'>\[View\]</a>"

/obj/item/clothing/accessory/badge/examine(user)
	..()
	if(stored_name)
		to_chat(user,"It reads: [stored_name], [badge_string].")

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		set_desc(user)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting \the [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting \the [src] into their face insistently.</span>")
		if(stored_name)
			to_chat(M, "<span class='warning'>It reads: [stored_name], [badge_string].</span>")

/obj/item/clothing/accessory/badge/PI
	name = "private investigator's badge"
	badge_string = "Private Investigator"

/*
 *Holobadges
 */
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of security."
	color = COLOR_PALE_BLUE_GRAY
	icon_state = "holobadge"
	item_state = "holobadge"
	badge_string = "Security"
	var/badge_access = access_security
	var/badge_number
	var/emagged //emag_act removes access requirements

/obj/item/clothing/accessory/badge/holo/NT
	name = "\improper NT holobadge"
	desc = "This glowing red badge marks the holder as a member of NanoTrasen corporate security."
	icon_state = "ntholobadge"
	color = COLOR_WHITE
	badge_string = "NanoTrasen Security"
	badge_access = access_research

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/NT/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/set_name(var/new_name)
	..()
	badge_number = random_id(type,1000,9999)
	name = "[name] ([badge_number])"

/obj/item/clothing/accessory/badge/holo/examine(user)
	..()
	if(badge_number)
		to_chat(user,"The badge number is [badge_number].")

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/modular_computer))

		var/obj/item/weapon/card/id/id_card = O.GetIdCard()

		if(!id_card)
			return

		if((badge_access in id_card.access) || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(id_card.registered_name)
			set_desc(user)
		else
			to_chat(user, "[src] rejects your ID, and flashes 'Insufficient access!'")
		return
	..()

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box containing security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo = 4,
					  /obj/item/clothing/accessory/badge/holo/cord = 2)

/obj/item/weapon/storage/box/holobadgeNT
	name = "\improper NT holobadge box"
	desc = "A box containing NanoTrasen security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo/NT = 4,
					  /obj/item/clothing/accessory/badge/holo/NT/cord = 2)

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. Looks crummy."
	icon_state = "badge_round"
	badge_string = "Unknown"

/obj/item/clothing/accessory/badge/defenseintel
	name = "\improper DIA investigator's badge"
	desc = "A leather-backed silver badge bearing the crest of the Defense Intelligence Agency."
	icon_state = "diabadge"
	badge_string = "Defense Intelligence Agency"

/obj/item/clothing/accessory/badge/interstellarintel
	name = "\improper OII agent's badge"
	desc = "A synthleather holographic badge bearing the crest of the Office of Interstellar Intelligence."
	icon_state = "intelbadge"
	badge_string = "Office of Interstellar Intelligence"

/obj/item/clothing/accessory/badge/nanotrasen
	name = "\improper NanoTrasen badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a NanoTrasen corporate executive."
	icon_state = "ntbadge"
	badge_string = "NanoTrasen Corporate"

/obj/item/clothing/accessory/badge/marshal
	name = "colonial marshal's badge"
	desc = "A leather-backed gold badge displaying the crest of the Colonial Marshals."
	icon_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = "Colonial Marshal Bureau"

/obj/item/clothing/accessory/badge/press
	name = "press badge"
	desc = "A leather-backed plastic badge displaying that the owner is certified press personnel."
	icon_state = "pressbadge"
	badge_string = "Journalist"
