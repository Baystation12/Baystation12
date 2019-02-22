// Noises made when hit while typing.
GLOBAL_LIST_INIT(hit_appends, list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF"))

// Some scary sounds.
GLOBAL_LIST_INIT(scarySounds, list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
))

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
GLOBAL_LIST_EMPTY(tagger_locations)

GLOBAL_LIST_INIT(station_prefixes, list("", "Imperium", "Heretical", "Cuban",
	"Psychic", "Elegant", "Common", "Uncommon", "Rare", "Unique",
	"Houseruled", "Religious", "Atheist", "Traditional", "Houseruled",
	"Mad", "Super", "Ultra", "Secret", "Top Secret", "Deep", "Death",
	"Zybourne", "Central", "Main", "Government", "Uoi", "Fat",
	"Automated", "Experimental", "Augmented"))

GLOBAL_LIST_INIT(station_names, list("", "Stanford", "Dorf", "Alium",
	"Prefix", "Clowning", "Aegis", "Ishimura", "Scaredy", "Death-World",
	"Mime", "Honk", "Rogue", "MacRagge", "Ultrameens", "Safety", "Paranoia",
	"Explosive", "Neckbear", "Donk", "Muppet", "North", "West", "East",
	"South", "Slant-ways", "Widdershins", "Rimward", "Expensive",
	"Procreatory", "Imperial", "Unidentified", "Immoral", "Carp", "Ork",
	"Pete", "Control", "Nettle", "Aspie", "Class", "Crab", "Fist",
	"Corrogated","Skeleton","Race", "Fatguy", "Gentleman", "Capitalist",
	"Communist", "Bear", "Beard", "Derp", "Space", "Spess", "Star", "Moon",
	"System", "Mining", "Neckbeard", "Research", "Supply", "Military",
	"Orbital", "Battle", "Science", "Asteroid", "Home", "Production",
	"Transport", "Delivery", "Extraplanetary", "Orbital", "Correctional",
	"Robot", "Hats", "Pizza"))

GLOBAL_LIST_INIT(station_suffixes, list("Station", "Frontier",
	"Suffix", "Death-trap", "Space-hulk", "Lab", "Hazard","Spess Junk",
	"Fishery", "No-Moon", "Tomb", "Crypt", "Hut", "Monkey", "Bomb",
	"Trade Post", "Fortress", "Village", "Town", "City", "Edition", "Hive",
	"Complex", "Base", "Facility", "Depot", "Outpost", "Installation",
	"Drydock", "Observatory", "Array", "Relay", "Monitor", "Platform",
	"Construct", "Hangar", "Prison", "Center", "Port", "Waystation",
	"Factory", "Waypoint", "Stopover", "Hub", "HQ", "Office", "Object",
	"Fortification", "Colony", "Planet-Cracker", "Roost", "Fat Camp",
	"Airstrip"))

GLOBAL_LIST_INIT(greek_letters, list("Alpha", "Beta", "Gamma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi",
	"Chi", "Psi", "Omega"))

GLOBAL_LIST_INIT(phonetic_alphabet, list("Alpha", "Bravo", "Charlie",
	"Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet",
	"Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec",
	"Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu"))

GLOBAL_LIST_INIT(numbers_as_words, list("One", "Two", "Three", "Four",
	"Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
	"Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
	"Eighteen", "Nineteen"))

GLOBAL_LIST_INIT(music_tracks, list(
	"Beyond" = /music_track/ambispace,
	"Clouds of Fire" = /music_track/clouds_of_fire,
	"Stage Three" = /music_track/dilbert,
	"Asteroids" = /music_track/df_theme,
	"Floating" = /music_track/floating,
	"Endless Space" = /music_track/endless_space,
	"Fleet Party Theme" = /music_track/one_loop,
	"Scratch" = /music_track/level3_mod,
	"Absconditus" = /music_track/absconditus,
	"lasers rip apart the bulkhead" = /music_track/lasers,
	"Maschine Klash" = /music_track/digit_one,
	"Comet Halley" = /music_track/comet_haley,
	"Please Come Back Any Time" = /music_track/elevator,
	"Human" = /music_track/human,
	"Memories of Lysendraa" = /music_track/lysendraa,
	"Marhaba" = /music_track/marhaba,
	"Space Oddity" = /music_track/space_oddity,
	"THUNDERDOME" = /music_track/thunderdome,
	"Torch: A Light in the Darkness" = /music_track/torch,
	"Treacherous Voyage" = /music_track/treacherous_voyage,
	"Wake" = /music_track/wake,
	"phoron will make us rich" = /music_track/pwmur,
	"every light is blinking at once" = /music_track/elibao,
	"In Orbit" = /music_track/inorbit,
	"Martian Cowboy" = /music_track/martiancowboy,
	"Monument" = /music_track/monument,
	"As Far As It Gets" = /music_track/asfarasitgets,
	"80s All Over Again" = /music_track/eighties,
	"Wild Encounters" = /music_track/wildencounters,
	"Torn" = /music_track/torn,
	"Nebula" = /music_track/nebula
))

/proc/setup_music_tracks(var/list/tracks)
	. = list()
	var/track_list = LAZYLEN(tracks) ? tracks : GLOB.music_tracks
	for(var/track_name in track_list)
		var/track_path = track_list[track_name]
		. += new/datum/track(track_name, track_path)

GLOBAL_LIST_INIT(possible_cable_colours, SetupCableColors())

/proc/SetupCableColors()
	. = list()

	var/invalid_cable_coils = list(
		/obj/item/stack/cable_coil/single,
		/obj/item/stack/cable_coil/cut,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/cable_coil/fabricator,
		/obj/item/stack/cable_coil/random
	)

	var/special_name_mappings = list(/obj/item/stack/cable_coil = "Red")

	for(var/coil_type in (typesof(/obj/item/stack/cable_coil) - invalid_cable_coils))
		var/name = special_name_mappings[coil_type] || capitalize(copytext_after_last("[coil_type]", "/"))

		var/obj/item/stack/cable_coil/C = coil_type
		var/color = initial(C.color)

		.[name] = color
	. = sortAssoc(.)
