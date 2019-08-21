#define MANTIDIFY(_thing, _name, _desc) \
##_thing/ascent/name = _name; \
##_thing/ascent/desc = "Some kind of strange alien " + _desc + " technology."; \
##_thing/ascent/color = COLOR_PURPLE;

#define ALL_ASCENT_SPECIES list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_NABBER, SPECIES_MONARCH_QUEEN, SPECIES_MONARCH_WORKER)
