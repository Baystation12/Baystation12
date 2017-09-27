/datum/lore/codex/category/military
	name = "Sol Gov Military"
	data = "The basics about the Sol Gov Defense Forces and the Expeditionary Corps"
	children = list(
		/datum/lore/codex/page/fleet,
		/datum/lore/codex/page/army,
		/datum/lore/codex/page/marines,
		/datum/lore/codex/page/ec
		)

/datum/lore/codex/page/fleet/add_content()
	name = "Sol Gov Fleet"
	keywords += list("Fleet")
	data = "The Fleet is the backbone of the SGDF. It maintains border sovereignty while also combatting piracy and insurgents. It is the most commonly seen branch, and in recent \
	years has built up significantly, more strictly patrolling borders and trade lanes in the wake of the Gaia Conflict. There are Five Fleets, the first being for Reserves and \
	the other four in action along [quick_link("Sol Gov")]'s border."

/datum/lore/codex/page/army/add_content()
	name = "Sol Gov Army"
	keywords += list("Army")
	data = "The SolGov Army is a standing force primarily made up of reserves, equipped for traditional ground warfare, as well as planetside naval operations. Currently it \
	maintains a small force due to warfare predominantly taking place in space."

/datum/lore/codex/page/marines/add_content()
	name = "Sol Gov Marines"
	keywords += list("Marines")
	data = "The Marine Corps, now a separate branch from the [quick_link("Fleet")], operates in tandem with the Fleet. It maintains security on Fleet vessels and acts as a quick \
	response force to crises within [quick_link("Sol Gov")] borders."

/datum/lore/codex/page/ec/add_content()
	name = "Sol Gov Expeditionary Corps"
	keywords += list("Expeditionary", "EC")
	data = "The Expeditionary Corps is a non-military, uniformed organization of [quick_link("Sol Gov")], reporting to the Committee for Diplomatic Relations. It is governed by some military laws,\
	 but has its own customs, regulations, and traditions that at times put it at odd with the Defense Forces. It's considered generally to be more lax than service in the [quick_link("Fleet")], \
	 but don't let that make you think they don't know what they're doing. Things like saluting and strict enforcement of the SCMJ are going to be alien to many of the older EC \
	 personnel, although they have used naval ranks since their inception. The focus of expeditionary personnel is on science and exploration instead of military objectives. \
	 Corpsmen are often highly specialized for the roles they take on their missions, and they are known for their experimentality and ability to improvise. Some in the Defense \
	 Forces look at the EC as a lesser organization."