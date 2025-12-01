/* this is a playing card deck based off of the Rider-Waite Tarot Deck.
*/

/obj/item/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"

/obj/item/deck/tarot/New()
	..()

	var/datum/playingcard/new_card
	for(var/name in list("The Fool","The Magician","The High Priestess","The Empress","The Emperor","The Hierophant","The Lovers","The Chariot","Strength","The Hermit","Wheel of Fortune","Justice","The Hanged Man","Death","Temperance","The Devil","The Tower","The Star","The Moon","The Sun","Judgement","The World"))
		new_card = new()
		new_card.name = "[name]"
		new_card.card_icon = "tarot_major"
		new_card.back_icon = "card_back_tarot"
		new_card.desc = "Some sort of major tarot card."
		cards += new_card
	for(var/suit in list("wands","pentacles","cups","swords"))


		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
			new_card = new()
			new_card.name = "[number] of [suit]"
			new_card.card_icon = "tarot_[suit]"
			new_card.back_icon = "card_back_tarot"
			new_card.desc = "A Rider-Waite tarot card."
			cards += new_card

/obj/item/deck/tarot/attack_self(mob/user as mob)
	var/list/newcards = list()
	while(length(cards))
		var/datum/playingcard/shuffled_card = pick(cards)
		shuffled_card.name = replacetext(shuffled_card.name," reversed","")
		if(prob(50))
			shuffled_card.name += " reversed"
		newcards += shuffled_card
		cards -= shuffled_card
	cards = newcards
	user.visible_message("\The [user] shuffles [src].")
