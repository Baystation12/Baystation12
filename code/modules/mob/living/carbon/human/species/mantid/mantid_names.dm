GLOBAL_LIST_INIT(gyne_names, list())

//Thanks to:
// - https://en.wikipedia.org/wiki/List_of_landforms
// - https://en.wikipedia.org/wiki/Outline_of_classical_architecture

GLOBAL_LIST_INIT(gyne_geoforms, list(
	"abime",			"abyss",			"ait", 			"anabranch", 	"arc", 				"arch", 			"archipelago", 	"arete", 			\
	"arroyo",			"atoll",			"ayre", 		"badlands", 	"bar", 				"barchan", 			"barrier", 		"basin",  			\
	"bay",				"bayou",			"beach", 		"bight", 		"blowhole",			"blowout", 			"bluff", 		"bornhardt", 		\
	"braid",			"nest",				"calanque",		"caldera", 		"canyon"	, 		"cape", 			"cave", 		"cenote", 			\
	"channel", 			"cirque", 			"cliff", 		"coast", 		"col", 				"colony", 			"cone", 		"confluence", 		\
	"corrie", 			"cove", 			"crater", 		"crevasse", 	"cryovolcano", 		"cuesta", 			"cusps", 		"yardang",			\
	"dale",				"dam", 				"defile", 		"dell", 		"delta", 			"diatreme",			"dike", 		"divide",  			\
	"doab", 			"doline", 			"dome", 		"draw", 		"dreikanter", 		"drumlin", 			"dune", 		"ejecta",  			\
	"erg", 				"escarpment", 		"esker", 		"estuary", 		"fan", 				"fault", 			"field", 		"firth",  			\
	"fissure", 			"fjard", 			"fjord", 		"flat", 		"flatiron", 		"floodplain", 		"foibe", 		"foreland",  		\
	"geyser", 			"glacier", 			"glen", 		"gorge", 		"graben", 			"gulf", 			"gully", 		"guyot",  			\
	"headland",			"hill", 			"hogback", 		"hoodoo", 		"horn", 			"horst", 			"inlet", 		"interfluve",  		\
	"island",			"islet", 			"isthmus", 		"kame", 		"karst", 			"karst", 			"kettle", 		"kipuka",  			\
	"knoll", 			"lagoon", 			"lake", 		"lavaka", 		"levee",			"loess",			"maar", 		"machair",  		\
	"malpa?s", 			"mamelon", 			"marsh", 		"meander", 		"mesa", 			"mogote", 			"monadnock", 	"moraine",  		\
	"moulin", 			"nunatak", 			"oasis", 		"outwash", 		"pediment", 		"pediplain", 		"peneplain", 	"peninsula", 		\
	"pingo", 			"pit"	, 			"plain", 		"plateau", 		"plug", 			"polje",			"pond", 		"potrero",  		\
	"pseudocrater",		"quarry", 			"rapid", 		"ravine", 		"reef", 			"ria", 				"ridge", 		"riffle",  			\
	"river", 			"sandhill", 		"sandur", 		"scarp", 		"scowle", 			"scree", 			"seamount", 	"shelf",  			\
	"shelter", 			"shield", 			"shoal", 		"shore", 		"sinkhole", 		"sound", 			"spine", 		"spit",  			\
	"spring",			"spur", 			"strait", 		"strandflat", 	"strath", 			"stratovolcano", 	"stream", 		"subglacier", 		\
	"summit", 			"supervolcano",		"surge", 		"swamp",	 	"table", 			"tepui", 			"terrace", 		"terracette", 		\
	"thalweg", 			"tidepool",			"tombolo",		"tor", 			"towhead",			"tube", 			"tunnel", 		"turlough", 		\
	"tuya",				"uvala", 			"vale", 		"valley",	 	"vent", 			"ventifact", 		"volcano", 		"wadi", 			\
	"waterfall", 		"watershed"
))

GLOBAL_LIST_INIT(gyne_architecture, list(
	"barrel",			"annular",			"aynali",		"baroque",		"catalan",			"cavetto",			"catenary",		"cloister",			\
	"corbel",			"cross",			"cycloidal",	"cylindrical",	"diamond",			"domical",			"fan",			"lierne",			\
	"muqarnas",			"net",				"nubian",		"ogee",			"ogival",			"parabolic",		"hyperbolic",	"volute",		\
	"quadripartite",	"rampant",			"rear",			"rib",			"sail",				"sexpartite",		"shell",		"stalactite",		\
	"stellar",			"stilted",			"surbased",		"surmounted",	"timbrel",			"tierceron",		"tripartite",	"tunnel",			\
	"grid",				"acroterion ",		"aedicule",		"apollarium",	"aegis",			"apse",				"arch",			"architrave",		\
	"archivolt",		"amphiprostyle",	"atlas",		"bracket",		"capital",			"caryatid",			"cella",		"colonnade",		\
	"column",			"cornice",			"crepidoma",	"crocket",		"cupola",			"decastyle",		"dome",			"eisodos",			\
	"entablature",		"epistyle ",		"euthynteria",	"exedra",		"finial",			"frieze",			"gutta",		"imbrex",			\
	"tegula",			"keystone",			"metope",		"naos",			"nave",				"opisthodomos",		"orthostates",	"pediment",			\
	"peristyle",		"pilaster",			"plinth",		"portico",		"pronaos",			"prostyle",			"quoin",		"stoa",				\
	"suspensura",		"term ",			"tracery",		"triglyph",		"sima",				"stylobate", 		"unitary",		"sovereign",		\
	"grand",			"supreme",			"rampant",		"isolated",		"standalone",		"seminal",			"pedagogical",	"locus",			\
	"figurative",		"abstract",			"aesthetic",	"grandiose",	"kantian",			"pure",				"conserved",	"brutalist",		\
	"extemporary",		"theological",		"theoretical",	"centurion",	"militant",			"eusocial",			"prominent",	"empirical",		\
	"key",				"civic",			"analytic",		"formal",		"atonal",			"tonal",			"synchronized",	"asynchronous",		\
	"harmonic",			"discordant",		"upraised",		"sunken", 		"life",				"order",			"chaos",		"systemic",			\
	"system",			"machine",			"mechanical",	"digital",		"electrical",		"electronic",		"somatic",		"cognitive",		\
	"mobile",			"immobile",			"motile",		"immotile",		"environmental",	"contextual",		"stratified",	"integrated",		\
	"ethical",			"micro",			"macro",		"genetic",		"intrinsic",		"extrinsic",		"academic",		"literary",			\
	"artisan",			"absolute",			"absolutist",	"autonomous",	"collectivist",		"bicameral",		"colonialist",	"federal",			\
	"imperial",			"independant",		"managed",		"multilateral",	"neutral",			"nonaligned",		"parastatal"
))

// Procs.
/datum/species/mantid/get_random_name(var/gender)
	return "[rand(10000,99999)] [GLOB.gyne_names.len ? pick(GLOB.gyne_names) : create_gyne_name()]"

/datum/species/mantid/gyne/get_random_name(var/gender)
	return "[rand(1,99)] [create_gyne_name()]"

/proc/create_gyne_name()
	var/gynename = "[capitalize(pick(GLOB.gyne_architecture))] [capitalize(pick(GLOB.gyne_geoforms))]"
	GLOB.gyne_names += gynename
	return gynename