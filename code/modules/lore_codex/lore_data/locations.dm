/datum/lore/codex/category/locations
	name = "Important Locations and Colonies"
	data = "There are several locations of interest that you may come across when travelling the stars."
	children = list(
		/datum/lore/codex/page/sol,
		/datum/lore/codex/page/earth,
		/datum/lore/codex/page/luna,
		/datum/lore/codex/page/mars,
		/datum/lore/codex/page/venus,
		/datum/lore/codex/page/pluto,
		/datum/lore/codex/page/mirania,
		/datum/lore/codex/page/gaia,
		/datum/lore/codex/page/ahdomai,
		/datum/lore/codex/page/moghes,
		/datum/lore/codex/page/qerrbalak
		)

/datum/lore/codex/page/sol/add_content()
	name = "Sol"
	keywords += list("Sol","Star")
	data = "Sol is the center of Humanity, where we came from, and where many of us call home. It is a G-Type Main Sequence Star with the seat of Sol Gov \
	[quick_link("Mars")], and the ancestrial birthplace of Humanity, [quick_link("Earth")] revolving around it.\
	<br><br>\
	Sol has other notable locations such as [quick_link("Venus")] and [quick_link("Pluto")]. Some minor locations exist such as [quick_link("Luna")]."

/datum/lore/codex/page/earth/add_content()
	name = "Earth"
	keywords += list("Earth","Sol","Planet")
	data = "Once the home of all Humanity, Earth is not the same as it was centuries ago. Administrative Districts cover its surface rather than nation states, \
	and much of what was once built has been lost to time. The planet's resources are dedicated almost entirely to restoring Earth to its former, natural glory. The population sits roughly \
	at three billion, and though a member of [quick_link("Sol Gov")] it exists in a custom position in the Assemblies that other member states do not get. You can read more on this \
	in such books as <i>Keeman Eller's Earth in the 26th Century.</i> and <i>Tarn Beely's Earth: The Cradle of Humanity.</i>"

/datum/lore/codex/page/mars/add_content()
	name = "Mars"
	keywords += list("Mars","Sol","Planet")
	data = "The first man stepping on Mars in 2052, it is the oldest terraformed colony in existence. Much of its early history was shaped by development, and war. \
	The Colony Conflicts were led by the Ares Confederation, and there are still extremist factions on Mars that think Mars should be its own sovereign colony, rather than the hub for \
	the federal government. \
	<br><br>\
	On Mars is the capital of [quick_link("Sol Gov")], Olympus, which makes it hard to find where Mars ends and Sol Gov begins. Mars itself is broken up into administrative \
	districts controlled by Governors and Small Assemblies. Even further, city states dominate these districts, most of which are controlled by powerful economic oligarchs. The \
	city states also have undercities, great underground complexes made of diverse tunnel systems. UV lights and vitamin D shops keep the undercity populations healthy, and \
	most do not care that they often do not see the light of day. Some stay down there for their whole lifes, creating a very different sort of human experience to that on most other planets. \
	<br><br>\
	The demographic of Mars has changed considerably over the centuries, splitting into many diverse groups such as the Tunnelers, Delphin, Tharseese, Charusian \
	The Monsians, the Hellshen, Classical Aresians, and many more. These diverse groups make up the Martian population, and some are responsible for many of the atrocities that have happened \
	on Mars in the last few centuries, such as the Ascraesen Genocides amid the Colony Conflicts and beyond. \
	You can read more about Mars in <i>The Red Crown</i> by Tenner Elliot."


/datum/lore/codex/page/venus/add_content()
	name = "Venus"
	keywords += list("Venus","Sol","Planet")
	data = "Venus is a planet of stark contrast. Shining cities, towers, resorts, clubs, and hydroponic farms in the Habitable Zone, to the mines and refineries on \
	the surface; Venus spans the entire spectrum between the grimy and the glorious. The culture of Venus is rather decadent and rich, with the focus on tourism and entertainment. \
	Those who actually live there have developed a culture of contrasting elitism; the wealthy live in the Zone, while the Surfacers operate the mines and factories below, which \
	are often in sweatshop like working conditions."


/datum/lore/codex/page/pluto/add_content()
	name = "Pluto"
	keywords += list("Pluto","Sol","Planet")
	data = "Though a Democratic Republic, you could say that most of the colony is controlled by different criminal factions. Most politicians are in someone's pocket, \
	and the largest political party, The New Right, are often noted as supporting the [quick_link("Terran Confederacy")]. \
	Between the 26th Century and the degradation of Pluto in the preceding centuries, not much occurred on the small world. Life got worse, crime rates rose, and the small world \
	fell further and further into the hole that was created by greedy corporations.\
	<br><br>\
	There was a revival effort in the 26th Century to update Pluto, give it a fresh coat of paint so to speak. Development projects, humanitarian aid, and all sorts of policing \
	of the current cities were spread across Pluto in hopes to make it less of the ugly child and more acceptable to the Sol standard. To this day, most of the planet is still \
	considered under development."

/datum/lore/codex/page/luna/add_content()
	name = "Luna"
	keywords += list("Luna","Sol","Moon")
	data = "Luna, the Moon of Earth, is a nation that was founded as a collective effort of a very large group of very rich people who all sought to claim their own piece of the moon, and the \
	modern Lunar political system reflects this history. Most of Luna is controlled by [quick_link("TSC")]s as it has been since at least the mid 23rd Century."

/datum/lore/codex/page/mirania/add_content()
	name = "The Republic of Mirania"
	keywords += list("Mirania","Planet")
	data = "An extremist military Junta independent from both [quick_link("Sol Gov")] and the [quick_link("Terran Confederacy")]. Mirania seceded from Sol Gov after a military coup\
	organized by nationalists replaced the previous government with the current Junta. Mirania blames Sol for most if not all of its problems, and is incredibly xenophobic to all\
	Xenobiological life, not even counting them in the Census."

/datum/lore/codex/page/gaia/add_content()
	name = "Demilitarized Zone of Gaia"
	keywords += list("Gaia", "Terran War","Planet")
	data = "Once a bustling agriworld with a population of nearly two billion, much of Gaia has been replaced with barren lands and barricades between the [quick_link("Sol Gov")]\
	and [quick_link("Terran Confederacy")] zones of the planet. In some places it's hard to tell there even was a war, but you need look little further to see areas still off\
	limits to civilians because of the landmines left over from the war, and the military mobilization alongside the borders of the DMZ create an air of tension for the colonists\
	still there."

/datum/lore/codex/page/ahdomai/add_content()
	name = "Ahdomai"
	keywords += list("Ahdomai","Planet","Tajara")
	data = "The [quick_link("Tajara")] home planet. It is the smaller of its twin-planet alignment, the large being the planet S'iranjir. Its atmosphere is not dissimilar to that of Earth.\
	 Its geography is largely mountainous, with a number of tundras, frozen plains, semi-frozen lakes, and icy seas."

/datum/lore/codex/page/moghes/add_content()
	name = "Moghes Hegemony"
	keywords += list("Moghes","Planet","Unathi")
	data = "The planet Moghes is home of the [quick_link("Unathi")], and is dominated primarily by deserts and deep crags that go far into the ground filled with tall jungle trees or blistering, \
	 irradiated hellholes as a result of an ancient nuclear disaster. Evidence of this previous, older race manifests itself in the form of ruins that dot themselves across the \
	 surface. Traces of swamp-land and jungles exist showing that at one time, Moghes was a lush world filled with a thriving ecosystem. The planet is smaller than \
	 Earth, and it's only sun is close enough to make it uncomfortable for non-natives. It has a single moon. Despite the doomsday event that burned away most of the\
	 plant life and water on the planet, Moghes is still home to a diverse and brutal ecosystem that strives, above all else, for survival."

/datum/lore/codex/page/qerrbalak/add_content()
	name = "Qerrbalak"
	keywords += list("Qerrbalak","Planet","Skrell")
	data = "[quick_link("Skrell")] come from the world of Qerrbalak, a planet with a humid atmosphere, featuring plenty of swamps and jungles. The world is filled with Skrellian cities which often sit on stilts.\
	Qerr'balak's landmass can be separated in three distinct entities : Two continents, separated by the Qo'rria Sea, make up for most of the habitable soil, while a large \
	archipelago of isles spreads on Qerr'xia, the single ocean of the planet. Qorr'gloa is a small, swampy continent on which the skrellian civilization first rose. While many\
	skrellian cities have been built on its coasts, the inner lands are mostly occupied by the aggressive and very territorial Ka'merr. The largest continent, Xi'Krri'oal, have \
	been colonized by the Skrell early in their history, and makes up for most of the Qerrbalak population today. While it is still very humid, its size allowed for more various\
	climates than on Qorr'gloa, ranging from the constantly snowy territories at its extreme south to more temperate, earth-like areas in the inner lands."