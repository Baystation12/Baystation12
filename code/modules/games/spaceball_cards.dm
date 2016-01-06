/obj/item/weapon/pack/spaceball
	name = "\improper Spaceball booster pack"
	desc = "Officially licensed to take your money."
	icon_state = "card_pack_spaceball"

/obj/item/weapon/pack/spaceball/New()
	var/datum/playingcard/P
	var/i
	var/year = 554 + text2num(time2text(world.timeofday, "YYYY"))
	for(i=0;i<5;i++)
		P = new()
		if(prob(1))
			P.name = "Spaceball Jones, [year] Brickburn Galaxy Trekers"
			P.card_icon = "spaceball_jones"
		else
			var/language_type = pick(/datum/language/human,/datum/language/diona,/datum/language/tajaran,/datum/language/unathi)
			var/datum/language/L = new language_type()
			var/team = pick("Brickburn Galaxy Trekers","Mars Rovers", "Qerrbalak Saints", "Moghes Rockets", "Ahdomai Lightening")
			P.name = "[L.get_random_name(pick(MALE,FEMALE))], [year - rand(0,50)] [team]"
			P.card_icon = "spaceball_standard"
		P.back_icon = "card_back_spaceball"

		cards += P