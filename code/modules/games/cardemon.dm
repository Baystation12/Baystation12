/obj/item/weapon/pack/cardemon
	name = "\improper Cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"

/obj/item/weapon/pack/cardemon/SetupCards()
	var/datum/playingcard/P
	var/i
	for(i=0; i<6; i++)
		var/element = pick("ire","spaghetti","meat","metal","money","brain")
		var/stats = list("HP"=rand(1,15),"DP"=rand(1,15),"SP"=rand(1,15))
		var/rarity
		if(prob(10))
			if(prob(5))
				if(prob(5))
					rarity = "Plasteel"
				else
					rarity = "Platinum"
			else
				rarity = "Silver"

		var/nam = pick("Death","Life","Plant","Leaf","Air","Earth","Fire","Water","Killer","Holy", "God", "Ordinary","Demon","Angel", "Phoron", "Mad", "Insane", "Metal", "Steel", "Secret")
		var/nam2 = pick("Carp", "Corgi", "Cat", "Mouse", "Octopus", "Lizard", "Monkey", "Plant", "Duck", "Demon", "Spider", "Bird", "Shark", "Rock")

		P = new()
		P.name = "[nam] [nam2] [stats["HP"]]/[stats["DP"]]/[stats["SP"]]"
		P.card_icon = "card_cardemon"
		if(rarity)
			P.name = "[rarity] [P.name]"
			P.card_icon += "_[rarity]"
		P.back_icon = "card_back_cardemon"
		P.desc = "Wow! A Cardemon card. Its element is: [element]. Its stats are: [stats["HP"]] HP, [stats["DP"]] DP, [stats["SP"]] SP"
		cards += P
	P = new()
	P.name = "Cardemon Instructions"
	P.card_icon = "card_cardemon_instructional"
	P.back_icon = "card_back_cardemon"
	P.desc = "How To Play Cardemon: every card has 3 stats and an Element. The first stat is Health, second is Damage, third is Speed. Each player plays two cards, and they attack in order of card speed on whichever target the owner selects. Discard cards with no health left over. Once every card has moved or died, a round has finished; you can replace fallen cards with new ones from your hand between rounds. Finally, elements: they do half damage to the one before it, and do double damage to the one after it: ire > spaghetti > metal > money > meat > brain > ire."
	cards += P