#include "ascent_areas.dm"
#include "ascent_jobs.dm"
#include "ascent_props.dm"
#include "ascent_shuttles.dm"

// Map template data.
/datum/map_template/ruin/exoplanet/ascent_caulship
	name = "Ascent Caulship"
	id = "awaysite_ascent_caulship"
	description = "A small Ascent civilian ship."
	suffixes = list("ascent_caulship/ascent-1.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ascent)
	cost = 0.5
	spawn_weight = 0.33
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS | TEMPLATE_FLAG_ALLOW_DUPLICATES
	area_usage_test_exempted_areas = list(/area/ship/ascent_caulship)
	ruin_tags = RUIN_ALIEN|RUIN_HABITAT

/obj/effect/submap_landmark/joinable_submap/ascent_caulship
	name = "Ascent Caulship"
	archetype = /decl/submap_archetype/ascent_caulship
	submap_datum_type = /datum/submap/ascent

/obj/effect/submap_landmark/joinable_submap/ascent_caulship/Initialize(mapload)
	var/list/all_elements = list(
		"Hydrogen",      "Helium",     "Lithium",     "Beryllium",    "Carbon",       "Nitrogen",      "Oxygen",
		"Fluorine",      "Neon",       "Sodium",      "Magnesium",    "Silicon",      "Phosphorus",    "Sulfur",
		"Chlorine",      "Argon",      "Potassium",   "Calcium",      "Scandium",     "Titanium",      "Chromium",
		"Manganese",     "Iron",       "Cobalt",      "Nickel",       "Zinc",         "Gallium",       "Germanium",
		"Arsenic",       "Selenium",   "Bromine",     "Krypton",      "Rubidium",     "Strontium",     "Zirconium",
		"Molybdenum",    "Technetium", "Ruthenium",   "Rhodium",      "Palladium",    "Silver",        "Cadmium",
		"Indium",        "Tin",        "Antimony",    "Tellurium",    "Iodine",       "Xenon",         "Caesium",
		"Barium",        "Lanthanum",  "Cerium",      "Praseodymium", "Neodymium",    "Promethium",    "Samarium",
		"Gadolinium",    "Dysprosium", "Holmium",     "Erbium",       "Ytterbium",    "Hafnium",       "Tantalum",
		"Tungsten",      "Rhenium",    "Osmium",      "Iridium",      "Gold",         "Mercury",       "Lead",
		"Bismuth",       "Polonium",   "Astatine",    "Radon",        "Francium",     "Radium",        "Actinium",
		"Thorium",       "Uranium",    "Plutonium",   "Americium",    "Curium",       "Berkelium",     "Californium",
		"Einsteinium",   "Fermium",    "Mendelevium", "Nobelium",     "Lawrencium",   "Rutherfordium", "Dubnium",
		"Seaborgium",    "Bohrium",    "Hassium",     "Meitnerium",   "Darmstadtium", "Roentgenium",   "Copernicium",
		"Nihonium",      "Flerovium",  "Moscovium",   "Livermorium",  "Tennessine",   "Oganesson"
	)
	name = "[pick(all_elements)]-[rand(10,99)]-[rand(10,99)]"
	. = ..()
