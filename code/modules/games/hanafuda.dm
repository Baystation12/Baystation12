/datum/playingcard/hanafuda
	var/suit = 0
	var/subject = "crane"
	desc = "A hanafuda card."
	back_icon = "hanafuda_back"

/datum/playingcard/hanafuda/hand_interaction(obj/item/hand/self_hand, obj/item/hand/other_hand, mob/living/user)
	if (length(self_hand.cards) == 1 && length(other_hand.cards) > 1 && !self_hand.concealed && !other_hand.concealed)
		var/list/matches = list()
		for(var/datum/playingcard/hanafuda/match_card in other_hand.cards)
			if(match_card.suit == suit)
				matches += match_card
		if(!length(matches))
			to_chat(user, "There were no matching cards.")
		var/list/matched = input(user, "Which card do you wish to match with?") as null|anything in matches
		if(matched)
			self_hand.cards += matched
			other_hand.cards -= matched
			self_hand.update_icon()
			if(length(other_hand.cards))
				other_hand.update_icon()
			else
				qdel(other_hand)
			return TRUE
	..()

/obj/item/deck/hanafuda
	name = "deck of hanafuda cards"
	desc = "A set of playing cards that uses various flowers as suits."
	icon_state = "deck_hanafuda"

/obj/item/deck/hanafuda/New()
	..()

	var/list/suits = list("Pine", "Plum blossom", "Cherry blossom", "Wisteria", "Iris", "Peony", "Bush clover", "Susuki grass", "Chrysanthemum", "Maple", "Willow", "Paulownia")
	var/list/subjects = list(
		"crane", "poetry ribbon", "", "",
		"bush warbler", "poetry ribbon", "", "",
		"curtain", "poetry ribbon", "", "",
		"cuckoo", "ribbon", "", "",
		"bridge", "ribbon", "", "",
		"butterflies", "blue ribbon", "", "",
		"boar", "ribbon", "", "",
		"full moon", "geese", "", "",
		"sake cup", "blue ribbon", "", "",
		"deer", "blue ribbon", "", "",
		"rain man", "swallow", "ribbon", "",
		"phoenix", "", "", ""
	)
	var/datum/playingcard/hanafuda/new_card
	for(var/i=0 to 47)
		var/suit = floor(i/4)
		var/subject = subjects[i+1]
		new_card = new()
		new_card.name = "[suits[suit+1]]"
		if(subject)
			new_card.name += ", [subject]"
		new_card.card_icon = "hanafuda_[suit]_[i%4]"
		new_card.suit = suit
		new_card.subject = subject
		cards += new_card