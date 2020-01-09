#define ASCENT_COLONY_SHIP_NAME "\improper Ascent seedship"

#include "ascent_areas.dm"
#include "ascent_jobs.dm"
#include "ascent_shuttles.dm"

// Map template data.
/datum/map_template/ruin/away_site/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	id = "awaysite_ascent_seedship"
	description = "A small Ascent colony ship."
	suffixes = list("ascent/ascent-1.dmm")
	cost = 0.5
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/ascent, 
		/datum/shuttle/autodock/overmap/ascent/two
	)

// Overmap objects.
/obj/effect/overmap/visitable/ship/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	desc = "Wake signature indicates a small to medium sized vessel of unknown design."
	vessel_mass = 6500
	fore_dir = WEST
	max_speed = 1/(1 SECOND)
	hide_from_reports = TRUE
	initial_restricted_waypoints = list(
		"Trichoptera" = list("nav_hangar_ascent_one"),
		"Lepidoptera" = list("nav_hangar_ascent_two")
	)

/obj/effect/submap_landmark/joinable_submap/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	archetype = /decl/submap_archetype/ascent_seedship
	submap_datum_type = /datum/submap/ascent

/obj/effect/submap_landmark/joinable_submap/ascent_seedship/Initialize(mapload)
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
