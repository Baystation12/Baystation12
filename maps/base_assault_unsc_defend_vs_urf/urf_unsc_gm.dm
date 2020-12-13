
/datum/game_mode/base_assault/unsc_urf
	name = "Base Assault (UNSC vs URF)"
	config_tag = "base_assault_unsc_urf"
	defenders = "The UNSC"
	attackers = " The URF"
	faction_balance = list(/datum/faction/insurrection,/datum/faction/unsc)

/datum/game_mode/base_assault/unsc_urf/get_attacker_loss_status()
	var/obj/effect/overmap/base = GLOB.INSURRECTION.get_flagship()
	if(!base || isnull(base.loc) || base.superstructure_failing > 0)
		return 1
	return 0