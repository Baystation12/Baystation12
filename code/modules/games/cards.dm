/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/desc = "A regular old playing card."

/datum/playingcard/proc/card_image(concealed, deck_icon)
	return image(deck_icon, concealed ? back_icon : card_icon)

/datum/playingcard/proc/hand_interaction(obj/item/hand/self_hand, obj/item/hand/other_hand, mob/living/user)
	return FALSE

/datum/playingcard/custom
	var/use_custom_front = TRUE
	var/use_custom_back = TRUE

/datum/playingcard/custom/card_image(concealed, deck_icon)
	if(concealed)
		return image((use_custom_back ? CUSTOM_ITEM_OBJ : deck_icon), "[back_icon]")
	else
		return image((use_custom_front ? CUSTOM_ITEM_OBJ : deck_icon), "[card_icon]")

/obj/item/deck
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()

/obj/item/deck/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(islist(citem.additional_data["extra_cards"]))
		for(var/card_singleton in citem.additional_data["extra_cards"])
			if(islist(card_singleton))
				var/datum/playingcard/custom/custom_card = new()
				if(!isnull(card_singleton["name"]))
					custom_card.name = card_singleton["name"]
				if(!isnull(card_singleton["card_icon"]))
					custom_card.card_icon = card_singleton["card_icon"]
				if(!isnull(card_singleton["back_icon"]))
					custom_card.back_icon = card_singleton["back_icon"]
				if(!isnull(card_singleton["desc"]))
					custom_card.desc = card_singleton["desc"]
				if(!isnull(card_singleton["use_custom_front"]))
					custom_card.use_custom_front = card_singleton["use_custom_front"]
				if(!isnull(card_singleton["use_custom_back"]))
					custom_card.use_custom_back = card_singleton["use_custom_back"]
				cards += custom_card

/obj/item/deck/holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder"

/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"

/obj/item/deck/cards/New()
	..()

	var/datum/playingcard/new_card
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
			new_card = new()
			new_card.name = "[number] of [suit]"
			new_card.card_icon = "[colour]num"
			new_card.back_icon = "card_back"
			cards += new_card

		for(var/number in list("jack","queen","king"))
			new_card = new()
			new_card.name = "[number] of [suit]"
			new_card.card_icon = "[colour]col"
			new_card.back_icon = "card_back"
			cards += new_card


	for(var/i = 0,i<2,i++)
		new_card = new()
		new_card.name = "joker"
		new_card.card_icon = "joker"
		cards += new_card

/obj/item/deck/use_tool(obj/item/used_obj, mob/living/user, list/click_params)
	if(istype(used_obj,/obj/item/hand))
		var/obj/item/hand/used_hand = used_obj
		for(var/datum/playingcard/moved_card in used_hand.cards)
			cards += moved_card
		qdel(used_obj)
		to_chat(user, "You place your cards on the bottom of \the [src].")
		return TRUE
	return ..()

/// Attack handler to deal cards, as an alterantive to the deal/draw verbs
/obj/item/deck/use_before(atom/target, mob/living/user, click_parameters)
	if (!(isobj(target)))
		return FALSE
	if (!length(cards) && (user.a_intent == I_HELP || user.a_intent == I_DISARM))
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return FALSE
	if (istype(target, /obj/item/deck))
		var/obj/item/deck/other_deck = target
		var/datum/playingcard/drawn_card = cards[1]
		other_deck.cards += drawn_card
		cards -= drawn_card
		other_deck.update_icon()
		visible_message(SPAN_NOTICE("[user] puts a card on top of \the [target]."), SPAN_NOTICE("You put a card on top of \the [target]."))
		return TRUE
	else if (istype(target, /obj/item/hand))
		var/obj/item/hand/target_hand = target
		var/datum/playingcard/drawn_card = cards[1]
		target_hand.cards += drawn_card
		cards -= drawn_card
		target_hand.update_icon(user.dir)
		visible_message(SPAN_NOTICE("[user] deals a card face [target_hand.concealed ? "down" : "up"]."), SPAN_NOTICE("You deal a card face [target_hand.concealed ? "down" : "up"]"))
		return TRUE
	else if (user.a_intent == I_GRAB || user.a_intent == I_HURT)
		// target isn't a deck or hand, create a new hand
		var/obj/item/hand/hand = new(target.loc)
		var/concealed = user.a_intent != I_HURT
		hand.cards += cards[1]
		cards -= cards[1]
		hand.concealed = concealed
		hand.pixel_x = text2num(click_parameters[MOUSE_ICON_X]) - 16
		hand.pixel_y = text2num(click_parameters[MOUSE_ICON_Y]) - 16
		hand.update_icon(user.dir)
		visible_message(SPAN_NOTICE("[user] deals a card face [concealed ? "down" : "up"]."), SPAN_NOTICE("You deal a card face [concealed ? "down" : "up"]."))
		return TRUE
	return FALSE

/obj/item/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!istype(usr,/mob/living/carbon))
		return

	var/mob/living/carbon/user = usr

	if(!length(cards))
		to_chat(usr, "There are no cards in the deck.")
		return

	var/obj/item/hand/held_hand = user.IsHolding(/obj/item/hand)
	if (!held_hand)
		held_hand = new(get_turf(src))
		user.put_in_hands(held_hand)

	if(!held_hand || !user) return

	var/datum/playingcard/drawn_card = cards[1]
	held_hand.cards += drawn_card
	cards -= drawn_card
	held_hand.update_icon()
	user.visible_message("\The [user] draws a card.")
	to_chat(user, "It's \the [drawn_card].")

/obj/item/deck/verb/deal_card()

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!length(cards))
		to_chat(usr, "There are no cards in the deck.")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/dealt = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !dealt) return

	deal_at(usr, dealt)

/obj/item/deck/proc/deal_at(mob/user, mob/target)
	var/obj/item/hand/new_hand = new(get_step(user, user.dir))

	new_hand.cards += cards[1]
	cards -= cards[1]
	new_hand.concealed = 1
	new_hand.update_icon()
	if(user==target)
		var/datum/pronouns/pronouns = user.choose_from_pronouns()
		user.visible_message("\The [user] deals a card to [pronouns.self].")
	else
		user.visible_message("\The [user] deals a card to \the [target].")
	new_hand.throw_at(get_step(target,target.dir),10,1,user)

/obj/item/hand/use_tool(obj/item/used_obj, mob/living/user, list/click_params)
	if(istype(used_obj,/obj/item/hand))
		var/obj/item/hand/used_hand = used_obj
		for (var/datum/playingcard/card in used_hand.cards)
			if(card.hand_interaction(used_hand, src, user))
				return TRUE
		for(var/datum/playingcard/moved_card in cards)
			used_hand.cards += moved_card
			cards -= moved_card
		qdel(src)
		used_hand.update_icon()
		return TRUE
	return ..()

/obj/item/deck/attack_self(mob/user)

	cards = shuffle(cards)
	user.visible_message("\The [user] shuffles [src].")

/obj/item/deck/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!length(cards))
		to_chat(usr, "There are no cards in the deck.")
		return

	deal_at(usr, over)

/obj/item/pack
	name = "card pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEM_SIZE_TINY
	var/list/cards = list()

/obj/item/pack/Initialize()
	. = ..()
	SetupCards()

/obj/item/pack/proc/SetupCards()
	return

/obj/item/pack/attack_self(mob/user)
	user.visible_message("[user] rips open \the [src]!")
	var/obj/item/hand/new_hand = new()

	new_hand.cards += cards
	cards.Cut()
	qdel(src)

	new_hand.update_icon()
	user.put_in_active_hand(new_hand)

/obj/item/hand
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY

	var/concealed = 0
	var/list/datum/playingcard/cards = list()

/obj/item/hand/attack_self(mob/user)
	concealed = !concealed
	update_icon()
	user.visible_message("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/hand/attack_hand(mob/user)
	if(loc == user)
		// build the list of cards in the hand
		var/list/to_discard = list()
		for(var/datum/playingcard/held_card in cards)
			to_discard[held_card.name] = held_card
		var/discarding = null
		//don't prompt if only 1 card
		if(length(to_discard) == 1)
			discarding = to_discard[1]
		else
			discarding = input(user, "Which card do you wish to take?") as null|anything in to_discard
		if(!discarding || !to_discard[discarding] || !CanPhysicallyInteract(user)) return

		var/datum/playingcard/card = to_discard[discarding]
		var/obj/item/hand/new_hand = new(loc)
		new_hand.cards += card
		cards -= card
		new_hand.concealed = 0
		new_hand.update_icon()
		update_icon()

		if(!length(cards))
			qdel(src)

		user.put_in_hands(new_hand)
	else
		. = ..()

/obj/item/hand/examine(mob/user)
	. = ..()
	if((!concealed || loc == user) && length(cards))
		to_chat(user, "It contains: ")
		for(var/datum/playingcard/visible_card in cards)
			to_chat(user, "\The [visible_card.name].")

/obj/item/hand/on_update_icon(direction = 0)
	if(!length(cards))
		qdel(src)
		return
	else if(length(cards) > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else if(concealed)
		name = "single playing card"
		desc = "An unknown playing card, concealed."
	else
		var/datum/playingcard/single_card = cards[1]
		name = "[single_card.name]"
		desc = "[single_card.desc]"

	ClearOverlays()

	if(length(cards) == 1)
		var/datum/playingcard/single_card = cards[1]
		var/image/card_image = single_card.card_image(concealed, icon)
		card_image.pixel_x += (-5+rand(10))
		card_image.pixel_y += (-5+rand(10))
		AddOverlays(card_image)
		return

	var/offset = floor(20/length(cards))
	var/matrix/hand_matrix = matrix()
	hand_matrix.Update(
		rotation = (direction & (EAST|WEST)) ? 90 : 0,
		offset_x = (direction == EAST) ? -2 : (direction == WEST) ? 3 : 0,
		offset_y = direction == SOUTH ? 4 : 0
	)
	var/i = 0
	for(var/datum/playingcard/visible_card in cards)
		var/image/card_image = visible_card.card_image(concealed, icon)
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				card_image.pixel_x = 8-(offset*i)
			if(WEST)
				card_image.pixel_y = -6+(offset*i)
			if(EAST)
				card_image.pixel_y = 8-(offset*i)
			else
				card_image.pixel_x = -7+(offset*i)
		card_image.SetTransform(others = hand_matrix)
		AddOverlays(card_image)
		i++

/obj/item/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table, loc))
		update_icon(user.dir)
	else
		update_icon()

/obj/item/hand/pickup(mob/user)
	update_icon()

/*** A special thing that steals a card from a deck, probably lost in maint somewhere. ***/
/obj/item/hand/missing_card
	name = "missing playing card"

/obj/item/hand/missing_card/Initialize()
	. = ..()
	var/list/deck_list = list()
	for(var/obj/item/deck/placed_deck in world)
		if(isturf(placed_deck.loc))		//Decks hiding in inventories are safe. Respect the sanctity of loadout items.
			deck_list += placed_deck

	if(length(deck_list))
		var/obj/item/deck/the_deck = pick(deck_list)
		var/datum/playingcard/the_card = length(the_deck.cards) ? pick(the_deck.cards) : null

		if(the_card)
			cards += the_card
			the_deck.cards -= the_card
			concealed = pick(0,1)	//Maybe up, maybe down.
	update_icon()	//Automatically qdels if no card can be found.
