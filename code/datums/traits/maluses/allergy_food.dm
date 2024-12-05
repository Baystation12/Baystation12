/singleton/trait/malus/allergy_food
	name = "Food Allergy"
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	///Used to select which reagent mob is allergic to.
	metaoptions = list(
		ALLERGEN_ALCOHOL,
		ALLERGEN_CITRUS,
		ALLERGEN_EGG,
		ALLERGEN_FRUIT,
		ALLERGEN_LACTOSE,
		ALLEGERN_MEAT,
		ALLERGEN_MEAT_POULTRY,
		ALLERGEN_MEAT_RED,
		ALLERGEN_NUTS,
		ALLERGEN_PLANTS,
		ALLERGEN_RICE,
		ALLERGEN_SESAME,
		ALLERGEN_SHELLFISH,
		ALLERGEN_SOY,
		ALLERGEN_WHEAT
	)
	addprompt = "Select food group to make mob allergic to."
	remprompt = "Select food group to remove allergy to."
	selectable = TRUE
