/decl/cultural_info/faction/scg
	name = FACTION_SOL_CENTRAL
	description = "The Sol Central Government, commonly referred to as SolGov or the SCG, is a federal republic \
	composed of numerous human member states spanning many systems.\
	Based in the Sol System and with most seats of Government on Olympus, Mars,\
	the SCG governs the majority of human space. Currently engaged in a Cold War with the Terran Colonial Confederation \
	Its primary governing bodies are the Assemblies which are led by an Assembly-elected secretary general. \
	Member states have a great degree of freedom in their actions, though the SCG manages sapient rights, \
	domestic security, economic policy, and diplomacy for humanity as a whole. The SCG's population is diverse \
	including many non-humans (though they are not citizens) and encompassing a wide range of systems, territories \
	habitats, and celestial bodies. However, it is large, cumbersome, divided and slow to respond to issues due to \
	its massive bureaucracy and the distance between worlds. Through its member states, the SCG governs as one of the \
	most advanced and powerful civilisations in the known galaxy."
	language = LANGUAGE_SOL_COMMON

/decl/cultural_info/faction/scg/fleet
	name = FACTION_FLEET
	description = "The SCG DF Fleet, commonly referred to as the Fleet, is the SCG's primary component of the Defence Forces. \
	It consists of a huge assortment of vessels of varying sizes broken up into a number of smaller \"Fleets\" each with their \
	own areas of responsibility. The Fleet is the oldest component of the DF, and has long been the backbone of the SCG. \
	The Fleet, being the large, sprawling organisation it is, is made up of thousands and thousands of men and women \
	(and more recently, a number of Sol IPC's) spread across a variety of duties, tasks and postings. \
	The oldest component of the Defence Forces, the Fleet considers itself the pinnacle of Human military accomplishment. \
	It is well funded, but seen as complacent and bloated. Until recently the Fleet have not had a serious enemy to deal with, \
	but is generally respected by the populace due to their work keeping away pirates, putting down insurrections, destroying \
	smugglers and taking potshots at the ocassional Vox. Currently undergoing major \
	overhauls to improve efficiency and capabilities, publicly to counter encroachment by the Terran Colonial Confederation."

/decl/cultural_info/faction/torchco
	name = FACTION_CORPORATE
	description = "The Expeditionary Corps Organisation is a government-owned, publically traded limited liability company assembled from the corporate \
	backers who asssisted in funding the Torch project when it opened five years ago. Major players include NanoTrasen, Xynergy and \
	Hephaestus Industries, as well as dozens of others. The Expeditionary Corps Organisation reports its earnings and operation plans directly to a board of \
	directors, made up of corporate representatives and members of Expeditionary Corps command and the Committee for the Economy. \
	While on the surface the Expeditionary Corps Organisation appears to have noble goals, it is in reality a compromise between the noble ideals of pioneering \
	science, and the corporate desire to make a quick buck off whatever is found. Rumours also abound about shady practices, hidden \
	protocols, and xenoartifacts being 'lost' in transit, but nothing has been conclusively proven as of yet, and SCG doubtless is \
	reluctant to harpoon their own project."
	economic_power = 1.2
	subversive_potential = 35
	language = LANGUAGE_SOL_COMMON

/decl/cultural_info/faction/tcc
	name = FACTION_TERRAN_CONFED
	description = "The Terran Colonial Confederation, commonly referred to as the TCC, is a regional power in human space,\
	bordered by the Sol Central Government towards the galactic centre. The capital of the Confederation is the city of Ameranth on the planet of Terra \
	in the Gilgamesh system. Externally heavily militant and isolationist, the TCC, internally, is heavily libertarian, with \
	a strong focus on independent planetary government with the TCC itself only handling defence, foreign relations and some intergalactic trade. \
	Increasingly anti non-human, the TCC is in a cold war with the Sol Central Government following  the Gaia Conflict, a large \
	scale conflict between the SCG and TCC that saw a great deal of death and destruction. In Sol space \"Terrans\" as they are known are \
	heavily mistrusted and in some instances, met with downright hostility. Today the TCC continues to be an economic powerhouse following \
	a period of steady economic recovery, with most of its exports being manufactured goods, primarily armaments."
	economic_power = 0.9
	subversive_potential = 50
	language = LANGUAGE_INDEPENDENT

/decl/cultural_info/faction/remote
	name = FACTION_EXPEDITIONARY
	description = "The Expeditionary Corps, commonly referred to as the EC and made up of 'expeds', is a non-military, uniformed \
	organisation of the Sol Central Government, reporting to the Committee for Diplomatic Relations. It is governed by similar regulations \
	to the Fleet but has its own customs, regulations, and traditions that at times put it at odds with the Defence Forces. It is \
	generally considered to be laxer than the Fleet, though they are considered to be very capable in their areas of expertise. \
	It consists of uniformed personnel (enlisted and commissioned officers) and corporate contractors hired on a per mission basis. \
	The primary purpose of the Expeditionary Corps is the exploration of uncharted space and worlds, mineralogy surveys and \
	Xenoarchaeological studies and, most importantly, the discovery of new alien life. The Expeditionary Corps is \
	often considered a motivated, starry-eyed organisation that genuinely strives to be the best it can."
	language = LANGUAGE_GALCOM
	secondary_langs = list(LANGUAGE_SOL_COMMON)

/decl/cultural_info/faction/remote/nanotrasen
	name = FACTION_NANOTRASEN
	description = "The NanoTrasen Corporation, commonly referred to as NT, is one of the great megacorporations of the modern day.\
	Currently headquartered in New Amsterdam on Luna and headed by CEO Jackson Trasen It deals in research of the most advanced sciences, \
	such as genetics, blue space, and - recently - the uses of phoron, as well as mass consumer manufacturing on a truly galactic scale. \
	They also have a sizeable asset protection and security branch with which they secure both investments and occasionally new acquisitions \
	- a distressing rival to some minor star systems, and a powerful administrative branch sitting atop it all, directing their company's actions. \
	NanoTrasen is characterized by its aggression and questionable ethics, which, combined with the high emphasis they put on new, untested and dangerous \
	technology, means their installations are often considered unsafe and hazardous."
	economic_power = 1.2
	subversive_potential = 15

/decl/cultural_info/faction/remote/xynergy
	name = FACTION_XYNERGY
	description = "Xynergy is a privately held company known for their work with xenobiological organisms. They develop and \
	produce products such as the netgun and dociler used for capturing or taming xenofauna. In addition, they are the largest \
	fisher of space faring animals such as space carp and pike. They recently gained media presence by discovering and \
	training the giant armoured serpentids."
	economic_power = 1.1
	subversive_potential = 15

/decl/cultural_info/faction/remote/hephaestus
	name = FACTION_HEPHAESTUS
	description = "Hephaestus Industries, known simply as Hephaestus, is one of the largest corporations in existence today. \
	The leading manufacturer of military grade personal weapons, assault vehicles, defence systems and security measures, \
	Hephaestus has a somewhat controversial reputation as a result of blatant war profiteering, compounded by their attempts to \
	exploit Unathi equipment and assets for their own gains. In spite of this, Hephaestus maintains a reputation for the quality and \
	reliability of its equipment as well as its general affordability. Internally, Hephaestus is a desirable employer as a result of its \
	many employee benefits and focus on employee development, though many dread being transferred to one of the 'remote' branches."
	economic_power = 1.2
	subversive_potential = 15
	language = LANGUAGE_SOL_COMMON
	secondary_langs = list(LANGUAGE_SIGN, LANGUAGE_GALCOM)

/decl/cultural_info/faction/free
	name = FACTION_FREETRADE
	description = "The Free Trade Union, commonly referred to as the FTU, is is an employee-owned conglomerate of tens of thousands of \
	various traders and merchants from all over SCG space and beyond. Colloquially known as the 'fifth megacorp', they control a sizeable fleet \
	of trading ships which are form the backbone of their trading force along with a large contingent of combat capable vessels that cruise the shipping lanes, \
	keeping FTU members free from pirates. The FTU has a large amount of economic power across Sol space and operates large trade hubs and stations near most \
	Gateway installations and planets. Somewhat unscrupulous, FTU stations and merchants are known for \
	selling a great many restricted items and supplying all manner of goods indiscriminately."
	economic_power = 1.3
	subversive_potential = 15
	language = LANGUAGE_SPACER

/decl/cultural_info/faction/pcrc
	name = FACTION_PCRC
	description = "Proxima Centauri Risk Control, often known as PCRC, is one of the largest suppliers of private security in Sol Space. \
	PCRC handles numerous government, private and corporate contracts and provides a variety of services ranging from private law enforcement, \
	security, close protection, asset protection, search and rescue and peacekeeping and escort duties. A relatively quiet and new company, \
	it has quickly established itself as a reliable and effective provider of security solutions. This has often put it at odds with its main \
	competitor, SAARE."
	subversive_potential = 15
	language = LANGUAGE_SPACER
	secondary_langs = list(LANGUAGE_GALCOM, LANGUAGE_SOL_COMMON)

/decl/cultural_info/faction/dais
	name = FACTION_DAIS
	description = "Deimos Advanced Information Systems (DAIS) is a large corporation specializing in information technology such as computer hardware \
	and software, telecommunications equipment, and networking equipment based on Mars. It is the number one supplier of computer technology in The Sol Central \
	 Government, its systems used by most consumers and businesses within SolGov. DAIS is actually older than the Sol Central Government and is one of the very \
	few corporate members of the Solar Assembly. DAIS is also a major investor in the Torch project, and is on the Expeditionary Corps Organization board of directors. \
	Currently DAIS is invested in bluespace computing research and artificial intelligence research. Despite recent intrusions by NanoTrasen into their sector with NTNet \
	and related products, they still remain the market leader in computer technologies."
	economic_power = 1.1
	subversive_potential = 15
	language = LANGUAGE_SOL_COMMON

/decl/cultural_info/faction/other
	name = FACTION_OTHER
	description = "You belong to one of the many other factions that operate in the galaxy. Numerous, too numerous to list, these factions represent a variety of interests, purposes, intents and goals."
	subversive_potential = 25
	language = LANGUAGE_GALCOM
