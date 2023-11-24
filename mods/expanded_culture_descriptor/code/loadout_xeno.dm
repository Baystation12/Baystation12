/datum/gear/passport/unathi/New()
	..()
	whitelisted += list(SPECIES_YEOSA)
	var/list/passports = list()
	passports["independent clans registration document"] = /obj/item/passport/xeno/unathi/independent
	passports["Moghes Hegemony registration document"] = /obj/item/passport/xeno/unathi/hegemony
	passports["Ssen-Uuma Convent registration document"] = /obj/item/passport/xeno/unathi/convent
	passports["Rah'Zakeh League registration document"] = /obj/item/passport/xeno/unathi/league
	passports["Tersten Republic identity document"] = /obj/item/passport/xeno/unathi/tersten
	gear_tweaks += new/datum/gear_tweak/path(passports)
