/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/desc = "regular old playing card."

/obj/item/weapon/deck
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()

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

/obj/item/weapon/deck/attackby(obj/O as obj, mob/user as mob)
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
	H.throw_at(get_step(target,target.dir),10,1,H)

/obj/item/weapon/hand/attackby(obj/O as obj, mob/user as mob)
	if(cards.len == 1 && istype(O, /obj/item/weapon/pen))
		var/datum/playingcard/P = cards[1]
		if(P.name != "Blank Card")
			to_chat(user,"You cannot write on that card.")
			return
		var/cardtext = sanitize(input(user, "What do you wish to write on the card?", "Card Editing") as text|null, MAX_PAPER_MESSAGE_LEN)
		if(!cardtext)
			return
		P.name = cardtext
		// SNOWFLAKE FOR CAG, REMOVE IF OTHER CARDS ARE ADDED THAT USE THIS.
		P.card_icon = "cag_white_card"
		update_icon()
	else if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		user.drop_from_inventory(src)
		qdel(src)
		H.update_icon()
		return
	..()

/obj/item/weapon/hand/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		user.drop_from_inventory(src)
		qdel(src)
		H.update_icon()
		return
	..()

/obj/item/weapon/deck/attack_self(var/mob/user as mob)

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

/obj/item/weapon/pack/
	name = "card pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEM_SIZE_TINY
	var/list/cards = list()


/obj/item/weapon/pack/attack_self(var/mob/user as mob)
	user.visible_message("[user] rips open \the [src]!")
	var/obj/item/weapon/hand/H = new()

	H.cards += cards
	cards.Cut();
	user.drop_item()
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
	var/list/cards = list()

/obj/item/weapon/hand/verb/discard()

	set category = "Object"
	set name = "Discard"
	set desc = "Place a card from your hand in front of you."

	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/discarding = input("Which card do you wish to put down?") as null|anything in to_discard

	if(!discarding || !to_discard[discarding] || !usr || !src) return

	var/datum/playingcard/card = to_discard[discarding]

	var/obj/item/weapon/hand/H = new(src.loc)
	H.cards += card
	cards -= card
	H.concealed = 0
	H.update_icon()
	src.update_icon()
	usr.visible_message("\The [usr] plays \the [discarding].")
	H.loc = get_step(usr,usr.dir)

	if(!cards.len)
		qdel(src)

/obj/item/weapon/hand/attack_self(var/mob/user as mob)
	concealed = !concealed
	update_icon()
	user.visible_message("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/weapon/hand/examine(mob/user)
	. = ..(user)
	if((!concealed || src.loc == user) && cards.len)
		to_chat(user, "It contains: ")
		for(var/datum/playingcard/P in cards)
			to_chat(user, "The [P.name].")

/obj/item/weapon/hand/update_icon(var/direction = 0)

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
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
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
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
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

/obj/item/weapon/hand/dropped(mob/user as mob)
	..()
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/weapon/hand/pickup(mob/user as mob)
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
