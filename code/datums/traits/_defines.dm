// Helpers for shorter trait code
#define HAS_TRAIT(MOB, TRAIT) MOB.HasTrait(TRAIT)
#define HAS_TRAIT_LEVEL(MOB, TRAIT, LEVEL) (M.GetTraitLevel(TRAIT) >= LEVEL)
#define GET_TRAIT_LEVEL(MOB, TRAIT) M.GetTraitLevel(TRAIT)
#define IS_METABOLICALLY_INERT(MOB) HAS_TRAIT(MOB, /singleton/trait/general/metabolically_inert) // This define exists only due to how common this check is
#define METABOLIC_INERTNESS(MOB) GET_TRAIT_LEVEL(MOB, /singleton/trait/general/metabolically_inert) // See above
