/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "A leather-backed badge, with gold trimmings."
	icon_state = "detectivebadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY
	var/badge_string = "Detective"
	var/stored_name


/obj/item/clothing/accessory/badge/get_lore_info()
	. = ..()
	. += "<br>Denotes affiliation to <l>[badge_string]</l>."


/obj/item/clothing/accessory/badge/proc/set_name(new_name)
	stored_name = new_name


/obj/item/clothing/accessory/badge/proc/set_desc(mob/living/carbon/human/H)


/obj/item/clothing/accessory/badge/CanUseTopic(user)
	if (user in view(get_turf(src)))
		return STATUS_INTERACTIVE


/obj/item/clothing/accessory/badge/OnTopic(mob/user, list/href_list)
	if (href_list["look_at_me"])
		if (istype(user))
			user.examinate(src)
			return TOPIC_HANDLED


/obj/item/clothing/accessory/badge/get_examine_line()
	. = ..()
	. += "  <a href='?src=\ref[src];look_at_me=1'>\[View\]</a>"


/obj/item/clothing/accessory/badge/examine(user)
	. = ..()
	if (stored_name)
		to_chat(user,"It reads: [stored_name], [badge_string].")


/obj/item/clothing/accessory/badge/attack_self(mob/user)
	if (!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		set_desc(user)
		return
	if (isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")


/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if (isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting \the [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting \the [src] into their face insistently.</span>")
		if (stored_name)
			to_chat(M, "<span class='warning'>It reads: [stored_name], [badge_string].</span>")


/obj/item/clothing/accessory/badge/investigator
	name = "private investigator's badge"
	badge_string = "Private Investigator"


/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of security."
	color = COLOR_PALE_BLUE_GRAY
	icon_state = "holobadge"
	item_state = "holobadge"
	badge_string = "Security"
	var/badge_access = access_security
	var/badge_number
	var/emagged


/obj/item/clothing/accessory/badge/holo/NT
	name = "corporate holobadge"
	desc = "This glowing green badge marks the holder as a member of corporate security."
	icon_state = "ntholobadge"
	color = null
	badge_string = "Corporate Security"
	badge_access = access_research


/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE


/obj/item/clothing/accessory/badge/holo/NT/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE


/obj/item/clothing/accessory/badge/holo/set_name(new_name)
	..()
	badge_number = random_id(type, 1000, 9999)
	name = "[name] ([badge_number])"


/obj/item/clothing/accessory/badge/holo/examine(user)
	. = ..()
	if (badge_number)
		to_chat(user,"The badge number is [badge_number].")


/obj/item/clothing/accessory/badge/holo/attack_self(mob/user)
	if (!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()


/obj/item/clothing/accessory/badge/holo/emag_act(remaining_charges, mob/user)
	if (emagged)
		to_chat(user, SPAN_DANGER("\The [src] is already cracked."))
		return NO_EMAG_ACT
	emagged = TRUE
	to_chat(user, SPAN_DANGER("You crack the security checks on \the [src]."))
	return 1


/obj/item/clothing/accessory/badge/holo/attackby(obj/item/O, mob/user)
	if (istype(O, /obj/item/card/id) || istype(O, /obj/item/modular_computer))
		var/obj/item/card/id/id_card = O.GetIdCard()
		if (!id_card)
			return
		if ((badge_access in id_card.access) || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(id_card.registered_name)
			set_desc(user)
		else
			to_chat(user, "[src] rejects your ID, and flashes 'Insufficient access!'")
		return
	..()


/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box containing security holobadges."
	startswith = list(
		/obj/item/clothing/accessory/badge/holo = 4,
		/obj/item/clothing/accessory/badge/holo/cord = 2
	)


/obj/item/storage/box/holobadgeNT
	name = "corporate holobadge box"
	desc = "A box containing corporate security holobadges."
	startswith = list(
		/obj/item/clothing/accessory/badge/holo/NT = 4,
		/obj/item/clothing/accessory/badge/holo/NT/cord = 2
	)


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
	name = "corporate badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a corporate executive."
	icon_state = "ntbadge"
	badge_string = "Corporate Executive Body"

// SolFedPolice //
// ============ //

/obj/item/clothing/accessory/badge/director_agent //Proxima
	name = "\improper SFP Director's badge"
	desc = "A synthleather holographic badge bearing the crest of the Sol Federal Police."
	icon_state = "intelbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/deputy_agent //Proxima
	name = "\improper SFP Deputy Director's badge"
	desc = "A synthleather holographic badge bearing the crest of the Sol Federal Police."
	icon_state = "intelbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/curator_agent //Proxima
	name = "\improper SFP Supervisory Agent's badge"
	desc = "A synthleather holographic badge bearing the crest of the Sol Federal Police."
	icon_state = "intelbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/inspector_agent //Proxima
	name = "\improper SFP Agent Inspector's badge"
	desc = "A synthleather holographic badge bearing the crest of the Sol Federal Police."
	icon_state = "intelbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/senior_agent //Proxima
	name = "\improper SFP Senior Agent's badge"
	desc = "A leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "agentbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/agent
	name = "\improper SFP Agent's badge"
	desc = "A leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "agentbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/duty_agent //Proxima
	name = "\improper SFP Duty Agent's badge"
	desc = "A leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "agentbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/junior_agent //Proxima
	name = "\improper SFP Junior Agent's badge"
	desc = "A blue leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "trackerbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/tracker
	name = "\improper Tracker's badge"
	desc = "A blue leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "trackerbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS


/obj/item/clothing/accessory/badge/press
	name = "press badge"
	desc = "A leather-backed plastic badge displaying that the owner is certified press personnel."
	icon_state = "pressbadge"
	badge_string = "Journalist"

/obj/item/clothing/accessory/badge/tags/skrell
	name = "\improper Skrellian holobadge"
	desc = "A high tech Skrellian holobadge, designed to project information about the owner."
	icon_state = "skrell_badge"
	badge_string = null


/obj/item/clothing/accessory/badge/tags/skrell/set_desc(mob/living/carbon/human/H)
	if (!istype(H))
		return
	desc = "Blood type: [H.b_type]"

/obj/item/clothing/accessory/badge/tags/skrell/verb/set_sdtf()
	set name = "Set SDTF Name"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/badge/tags/skrell/B = src
	if (!istype(B))
		B = locate() in src
		if (!B)
			return
	if (usr.get_active_hand() != B)
		to_chat(usr, SPAN_WARNING("You must be holding \the [src] to modify it."))
		return
	var/value = input(usr, "Input your SDTF.", "SDTF Holobadge") as null | text
	if (isnull(value))
		return
	if (usr.stat || usr.get_active_hand() != B)
		to_chat(usr, SPAN_WARNING("You keep holding \the [src] to modify it."))
		return
	badge_string = sanitize(value, MAX_NAME_LEN)
	set_name(usr.real_name)
	set_desc(usr)
	verbs -= /obj/item/clothing/accessory/badge/tags/skrell/verb/set_sdtf
