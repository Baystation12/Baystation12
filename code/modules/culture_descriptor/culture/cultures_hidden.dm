/decl/cultural_info/culture/hidden
	description = "This is a hidden cultural detail. If you can see this, please report it on the tracker."
	hidden = TRUE
	hidden_from_codex = TRUE

/decl/cultural_info/culture/hidden/alium
	name = CULTURE_ALIUM
	language = LANGUAGE_ALIUM
	secondary_langs = null

/decl/cultural_info/culture/hidden/shadow
	name =             CULTURE_STARLIGHT
	language =         LANGUAGE_CULT
	additional_langs = list(LANGUAGE_CULT_GLOBAL)

/decl/cultural_info/culture/hidden/cultist
	name =   CULTURE_CULTIST
	language = LANGUAGE_CULT

/decl/cultural_info/culture/hidden/cultist/get_random_name()
	return "[pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")] [pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")]"

/decl/cultural_info/culture/hidden/monkey
	name = CULTURE_MONKEY
	language = LANGUAGE_PRIMITIVE

/decl/cultural_info/culture/hidden/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/decl/cultural_info/culture/hidden/monkey/farwa
	name =   CULTURE_FARWA

/decl/cultural_info/culture/hidden/monkey/neara
	name =   CULTURE_NEARA

/decl/cultural_info/culture/hidden/monkey/stok
	name =   CULTURE_STOK
