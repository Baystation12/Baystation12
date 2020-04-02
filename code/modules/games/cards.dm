/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/desc = "A regular old playing card."

/datum/playingcard/proc/card_image(concealed, deck_icon)
	return image(deck_icon, concealed ? back_icon : card_icon)

/datum/playingcard/custom
	var/use_custom_front = TRUE
	var/use_custom_back = TRUE

/datum/playingcard/custom/card_image(concealed, deck_icon)
	if(concealed)
		return image((src.use_custom_back ? CUSTOM_ITEM_OBJ : deck_icon), "[back_icon]")
	else
		return image((src.use_custom_front ? CUSTOM_ITEM_OBJ : deck_icon), "[card_icon]")

/obj/item/weapon/deck
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()

/obj/item/weapon/deck/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	if(islist(citem.additional_data["extra_cards"]))
		for(var/card_decl in citem.additional_data["extra_cards"])
			if(islist(card_decl))
				var/datum/playingcard/custom/P = new()
				if(!isnull(card_decl["name"]))
					P.name = card_decl["name"]
				if(!isnull(card_decl["card_icon"]))
					P.card_icon = card_decl["card_icon"]
				if(!isnull(card_decl["back_icon"]))
					P.back_icon = card_decl["back_icon"]
				if(!isnull(card_decl["desc"]))
					P.desc = card_decl["desc"]
				if(!isnull(card_decl["use_custom_front"]))
					P.use_custom_front = card_decl["use_custom_front"]
				if(!isnull(card_decl["use_custom_back"]))
					P.use_custom_back = card_decl["use_custom_back"]
				cards += P

/obj/item/weapon/deck/holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder"

/obj/item/weapon/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"

/obj/item/weapon/deck/cards/New()
	..()

	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]num"
			P.back_icon = "card_back"
			cards += P

		for(var/number in list("jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P


	for(var/i = 0,i<2,i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

/obj/item/weapon/deck/attackby(obj/O, mob/user)
	if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		for(var/datum/playingcard/P in H.cards)
			cards += P
		qdel(O)
		to_chat(user, "You place your cards on the bottom of \the [src].")
		return
	..()

/obj/item/weapon/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!istype(usr,/mob/living/carbon))
		return

	var/mob/living/carbon/user = usr

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	var/obj/item/weapon/hand/H
	if(user.l_hand && istype(user.l_hand,/obj/item/weapon/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/weapon/hand))
		H = user.r_hand
	else
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user) return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.update_icon()
	user.visible_message("\The [user] draws a card.")
	to_chat(user, "It's the [P].")

/obj/item/weapon/deck/verb/deal_card()

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !M) return

	deal_at(usr, M)

/obj/item/weapon/deck/proc/deal_at(mob/user, mob/target)
	var/obj/item/weapon/hand/H = new(get_step(user, user.dir))

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = 1
	H.update_icon()
	if(user==target)
		user.visible_message("\The [user] deals a card to \himself.")
	else
		user.visible_message("\The [user] deals a card to \the [target].")
	H.throw_at(get_step(target,target.dir),10,1,user)

/obj/item/weapon/hand/attackby(obj/O, mob/user)
	if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		qdel(src)
		H.update_icon()
		return
	..()

/obj/item/weapon/deck/attack_self(var/mob/user)

	cards = shuffle(cards)
	user.visible_message("\The [user] shuffles [src].")

/obj/item/weapon/deck/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!cards.len)
		to_chat(usr, "There are no cards in the deck.")
		return

	deal_at(usr, over)

/obj/item/weapon/pack
	name = "card pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEM_SIZE_TINY
	var/list/cards = list()

/obj/item/weapon/pack/Initialize()
	. = ..()
	SetupCards()

/obj/item/weapon/pack/proc/SetupCards()
	return

/obj/item/weapon/pack/attack_self(var/mob/user)
	user.visible_message("[user] rips open \the [src]!")
	var/obj/item/weapon/hand/H = new()

	H.cards += cards
	cards.Cut();
	qdel(src)

	H.update_icon()
	user.put_in_active_hand(H)

/obj/item/weapon/hand
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY

	var/concealed = 0
	var/list/datum/playingcard/cards = list()

/obj/item/weapon/hand/attack_self(var/mob/user)
	concealed = !concealed
	update_icon()
	user.visible_message("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/weapon/hand/attack_hand(mob/user)
	if(src.loc == user)
		// build the list of cards in the hand
		var/list/to_discard = list()
		for(var/datum/playingcard/P in cards)
			to_discard[P.name] = P
		var/discarding = null
		//don't prompt if only 1 card
		if(to_discard.len == 1)
			discarding = to_discard[1]
		else
			discarding = input(user, "Which card do you wish to take?") as null|anything in to_discard
		if(!discarding || !to_discard[discarding] || !CanPhysicallyInteract(user)) return

		var/datum/playingcard/card = to_discard[discarding]
		var/obj/item/weapon/hand/new_hand = new(src.loc)
		new_hand.cards += card
		cards -= card
		new_hand.concealed = 0
		new_hand.update_icon()
		src.update_icon()

		if(!cards.len)
			qdel(src)

		user.put_in_hands(new_hand)
	else
		. = ..()

/obj/item/weapon/hand/examine(mob/user)
	. = ..()
	if((!concealed || src.loc == user) && cards.len)
		to_chat(user, "It contains: ")
		for(var/datum/playingcard/P in cards)
			to_chat(user, "The [P.name].")

/obj/item/weapon/hand/on_update_icon(var/direction = 0)
	if(!cards.len)
		qdel(src)
		return
	else if(cards.len > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else if(concealed)
		name = "single playing card"
		desc = "An unknown playing card, concealed."
	else
		var/datum/playingcard/P = cards[1]
		name = "[P.name]"
		desc = "[P.desc]"

	overlays.Cut()

	if(cards.len == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = P.card_image(concealed, src.icon)
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		overlays += I
		return

	var/offset = Floor(20/cards.len)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = P.card_image(concealed, src.icon)
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		overlays += I
		i++

/obj/item/weapon/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/weapon/hand/pickup(mob/user)
	src.update_icon()

/*** A special thing that steals a card from a deck, probably lost in maint somewhere. ***/
/obj/item/weapon/hand/missing_card
	name = "missing playing card"

/obj/item/weapon/hand/missing_card/Initialize()
	. = ..()
	var/list/deck_list = list()
	for(var/obj/item/weapon/deck/D in world)
		if(isturf(D.loc))		//Decks hiding in inventories are safe. Respect the sanctity of loadout items.
			deck_list += D

	if(deck_list.len)
		var/obj/item/weapon/deck/the_deck = pick(deck_list)
		var/datum/playingcard/the_card = length(the_deck.cards) ? pick(the_deck.cards) : null

		if(the_card)
			cards += the_card
			the_deck.cards -= the_card
			concealed = pick(0,1)	//Maybe up, maybe down.
	update_icon()	//Automatically qdels if no card can be found.
