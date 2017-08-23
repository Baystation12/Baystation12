/obj/item/weapon/pack/cardemon
	name = "\improper Cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"

/obj/item/weapon/pack/cardemon/New()
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
	P.desc = "How to Play: each card has 3 stats (health, damage, speed) and an Element. Each player draws and plays two cards. The card with the highest speed attacks first and the owner chooses its target. Cards with 0 health are discarded. Once every card has attacked or been discarded the round ends. Draw cards until 2 are out each round. Cards do double damage to the element following them in this list: ire > spaghetti > metal > money > meat > brain > ire."
	cards += P