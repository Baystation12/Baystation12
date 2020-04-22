
/datum/faction/npc/khoros_desert_raiders
	name = "Khoros Desert Raiders"
	enemy_factions = list("UNSC","ONI")
	gear_supply_type = /decl/hierarchy/supply_pack/khoros
	blurb = "Deserts are a vast and empty place. The rich don't understand the appeals of living in a place so lifeless, \
		and the poor fear a land so hospitable, cruel and indifferent. Many are lost in deserts, forgotten to the vast \
		sands of time, only those who leave their marks on the land are ever remembered, atleast more so then simple \
		skeletal remains. In such a cruel land, only the strongest can survive, and the weak will perish. Such philosophy \
		embodies the Khoros Desert Raiders, who chose to operate outside the walls of Talista's capital and instead make \
		their home on the moon's many mountains. Raids are constant, and most who venture outside of the safe walls never \
		return. And for what purpose? Many claim they need the supplies, but in reality, they do it to prove their strength, \
		and to satisfy their passion for battle. Justifying their violent tendencies like a simple hobby, they are resolute \
		in proving their strength and satisfying their desire for war. Despite the might of the UNSC, they dare not step \
		under the shadow of the mountains or head out to rescue a dammed trading convoy. After all, only the strong can rule \
		over the weak. "
	defender_mob_types = list(/mob/living/simple_animal/hostile/innie/green = 1,\
		/mob/living/simple_animal/hostile/innie/medium/green = 2,\
		/mob/living/simple_animal/hostile/innie/heavy/green = 1)

/datum/faction/npc/khoros_desert_raiders/New()
	. = ..()
	leader_name = "Warlord [leader_name]"

/datum/faction/npc/khoros_desert_raiders/generate_rep_rewards(var/player_reputation = 0)
	. = ..()

	var/rep_required = 9999999
	if(player_reputation < rep_required)
		locked_rep_rewards.Add(list(list(
		"name" = "Warband Requisition Decree",
			"cost" = "1000 Reputation",
			"rep" = rep_required,
			"type" = "ability"
		)))
	else
		unlocked_rep_rewards.Add(list(list(
		"name" = "Warband Requisition Decree",
			"cost" = "1000 Reputation",
			"rep" = rep_required,
			"type" = "ability"
		)))
