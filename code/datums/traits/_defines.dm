// Helpers for shorter trait code
///Check if mob currently has a trait set; also works for traits with associated_list set.
#define HAS_TRAIT(MOB, TRAIT) MOB.HasTrait(TRAIT)
///Checks for minimum severity level with associated trait. Does not work for traits that have an metaoptions set.
#define HAS_TRAIT_LEVEL(MOB, TRAIT, LEVEL) (M.GetTraitLevel(TRAIT) >= LEVEL)
///Gets severity level with associated trait. Does not work for traits that have an metaoptions set.
#define GET_TRAIT_LEVEL(MOB, TRAIT) M.GetTraitLevel(TRAIT)
#define IS_METABOLICALLY_INERT(MOB) HAS_TRAIT(MOB, /singleton/trait/general/metabolically_inert) // This define exists only due to how common this check is
#define METABOLIC_INERTNESS(MOB) GET_TRAIT_LEVEL(MOB, /singleton/trait/general/metabolically_inert) // See above
