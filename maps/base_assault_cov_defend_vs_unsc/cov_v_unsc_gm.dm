
/datum/game_mode/base_assault/cov_unsc
	name = "Base Assault (Covenant vs UNSC)"
	config_tag = "base_assault_cov_unsc"
	defenders = "The Covenant"
	attackers = " The UNSC"

/datum/game_mode/base_assault/cov_unsc/get_defender_loss_status()
	var/obj/effect/overmap/base = GLOB.COVENANT.get_flagship()
	if(!base || isnull(base.loc) || base.superstructure_failing > 0)
		return 11
	return 0

/datum/game_mode/base_assault/cov_unsc/get_attacker_loss_status()
	var/obj/effect/overmap/base = GLOB.UNSC.get_base()
	if(!base || isnull(base.loc) || base.superstructure_failing > 0)
		return 1
	return 0
