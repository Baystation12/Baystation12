/**
	clothing flags
	A field for collecting single behavior toggles into
*/

/// Flag this clothing item as attachable; for collapsing accessories into clothing at some point
#define CLOTHING_IS_COMPONENT 0x1

/// Flag this clothing item as being forensically identifiable
#define CLOTHING_HAS_FIBERS 0x2

#define CLOTHING_FLAGS_DEFAULT (CLOTHING_HAS_FIBERS)
#define CLOTHING_FLAGS_DEFAULT_FIBERLESS (EMPTY_BITFIELD)
#define CLOTHING_FLAGS_ACCESSORY_DEFAULT (CLOTHING_IS_COMPONENT|CLOTHING_HAS_FIBERS)
#define CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS (CLOTHING_IS_COMPONENT)

/obj/item/clothing/var/clothing_flags = CLOTHING_FLAGS_DEFAULT
/obj/item/clothing/accessory/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT
