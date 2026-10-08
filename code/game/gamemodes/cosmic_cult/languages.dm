/datum/language/malign_global
	name = LANGUAGE_MALIGN_GLOBAL
	desc = "Strange, disconcerting whispers that carry the plans of those who can understand it far and wide."
	speech_verb = "cantillates"
	ask_verb = "cantillates"
	exclaim_verb = "cantillates"
	colour = "malign"
	key = "e"
	flags = RESTRICTED | AUDIBLE_HIVEMIND
	shorthand = "MUR"
	hidden_from_codex = TRUE
	machine_understands = FALSE
	syllables = list(
		"kha","khe","khi","kho","tha","the","thi","tho","pha","phe","phi","pho",
		"ka", "ke", "ko", "ky", "ta", "te", "ti", "to", "pa", "pe", "po", "py",
		"da", "de", "di", "do", "ga", "ge", "go", "ba", "bi", "mē", "nē", "tē",
		"la", "le", "li", "lo", "ly", "ra", "re", "ri", "ro", "ma", "me", "mo",
		"na", "ne", "ni", "no", "sa", "se", "si", "so", "xa", "xe", "zo", "psy",
		"kai","thei","leu","dou","noi","tau","phai","kleo","rhō","lō", "thō","kō",
		"pro","kra","kri","tri","tro","phro","khro","kle","stra","sthe","glo","mne",
		"tos","tos","los","nos","ros","kos","mos","ton","lon","non","ron","dēs",
		"tēs","nēs","rōn","tōr","tēr","phōn","kleis","gos","ios","a",  "e",  "o"
	)
	space_chance = 25

/datum/language/malign_global/malign_local
	name = LANGUAGE_MALIGN_LOCAL
	desc = "Scream into the void. The void hears nothing."
	key = "m"
	flags = RESTRICTED
	partial_understanding = list(
		LANGUAGE_MALIGN_GLOBAL = 50
	)
