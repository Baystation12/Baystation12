/datum/trader/ship/gunshop
	name = "Gun Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Gun Shop"
	possible_origins = list("Rooty Tootie's Point-n-Shooties", "Bang-Bang Shop", "Wild Wild West Shop", "Keleshnikov", "Hunting Depot", "Big Game Hunters")
	speech = list(TRADER_HAIL_GENERIC    = "Hello, hello! I hope you have your permit. Oh, who are we kidding, you're welcome anyway!",
				TRADER_HAIL_DENY         = "Store policy dictates that you can fuck off.",

				TRADER_TRADE_COMPLETE    = "Thanks for buying your guns from ORIGIN!",
				TRADER_NO_BLACKLISTED   = "We may deal in guns, but that doesn't mean we'll trade for illegal goods...",
				TRADER_NO_GOODS    = "Cash for guns, thats the deal.",
				TRADER_NOT_ENOUGH  = "Guns are expensive! Give us more if you REALLY want it.",
				TRADER_HOW_MUCH          = "Well, I'd love to give this little beauty to you for VALUE.",

				TRADER_COMPLEMENT_FAILURE   = "If we were in the same room right now, I'd probably punch you.",
				TRADER_COMPLEMENT_SUCCESS = "Ha! Good one!",
				TRADER_INSULT_GOOD       = "I expected better from you. I suppose in that, I was wrong.",
				TRADER_INSULT_BAD        = "If I had my gun I'd shoot you!"
				)

	possible_trading_items = list(/obj/item/gun/projectile/pistol/holdout    = TRADER_ALL,
								/obj/item/gun/projectile/pistol/military/alt    = TRADER_ALL,
								/obj/item/gun/projectile/pistol/magnum_pistol= TRADER_ALL,
								/obj/item/gun/projectile/pistol/sec         = TRADER_ALL,
								/obj/item/gun/projectile/heavysniper/boltaction	= TRADER_ALL,
								/obj/item/gun/projectile/pistol/sec/MK      = TRADER_BLACKLIST,
								/obj/item/gun/projectile/shotgun/pump= TRADER_SUBTYPES_ONLY,
								/obj/item/ammo_magazine                     = TRADER_SUBTYPES_ONLY,
								/obj/item/ammo_magazine/pistol/empty         = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/mil_rifle/empty          = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/gyrojet/empty           = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/pistol/small/empty         = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/pistol/empty         = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/box/pistol/empty       = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/box/machinegun/empty      = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/machine_pistol/empty        = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/smg_top/empty        = TRADER_BLACKLIST,
								/obj/item/ammo_magazine/magnum/empty           = TRADER_BLACKLIST,
								/obj/item/clothing/accessory/storage/holster        = TRADER_ALL)

/datum/trader/ship/egunshop
	name = "Energy Gun Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "EGun Shop"
	possible_origins = list("The Emperor's Lasgun Shop", "Future Guns", "Solar Army", "Kiefer's Dependable Electric Arms", "Olympus Kingsport")
	speech = list(TRADER_HAIL_GENERIC    = "Welcome to the future of warfare! ORIGIN, your one-stop shop for energy weaponry!",
				TRADER_HAIL_DENY         = "I'm sorry, your communication channel has been blacklisted.",

				TRADER_TRADE_COMPLETE    = "Thank you, your purchase has been logged and you have automatically liked our Spacebook page.",
				TRADER_NO_BLACKLISTED   = "I'm sorry, is that a joke?",
				TRADER_NO_GOODS    = "We deal in cash.",
				TRADER_NOT_ENOUGH  = "State of the art weaponry costs more than that.",
				TRADER_HOW_MUCH          = "All our quality weapons are priceless, but I'd give that to you for VALUE.",

				TRADER_COMPLEMENT_FAILURE   = "If I was dumber I probably would have believed you.",
				TRADER_COMPLEMENT_SUCCESS = "Yes, I am very smart.",
				TRADER_INSULT_GOOD       = "Energy weapons are TWICE the gun kinetic guns are!",
				TRADER_INSULT_BAD        = "That's... very mean. I won't think twice about blacklisting your channel, so stop."
				)

	possible_trading_items = list(/obj/item/gun/energy/taser                      = TRADER_THIS_TYPE,
								/obj/item/gun/energy/stunrevolver                 = TRADER_THIS_TYPE,
								/obj/item/gun/energy/xray                         = TRADER_THIS_TYPE,
								/obj/item/gun/energy/laser                        = TRADER_THIS_TYPE,
								/obj/item/gun/energy/gun                          = TRADER_THIS_TYPE,
								/obj/item/cell/crap                               = TRADER_THIS_TYPE,
								/obj/item/cell/standard                           = TRADER_THIS_TYPE,
								/obj/item/cell/high                               = TRADER_THIS_TYPE,
								/obj/item/cell/super                              = TRADER_THIS_TYPE,
								/obj/item/cell/hyper                              = TRADER_THIS_TYPE,
								/obj/item/clothing/accessory/storage/holster             = TRADER_ALL)

/datum/trader/dogan
	name = "Dogan"
	origin = "Dogan's Gun Beacon"
	speech = list(TRADER_HAIL_GENERIC    = "Hello! This is an automatic recording of me, Mr. Dogan! I hope you like the... GUNS... I've got in store for you today.",
				TRADER_HAIL_DENY         = "I formally welcome you to... NOT... visit our store!",

				TRADER_TRADE_COMPLETE    = "Thank you for... PURCHASING... that quality... ITEM... from me!",
				TRADER_NO_BLACKLISTED   = "Thank you for... that quality... ILLEGAL OFFER THAT I WILL REFUSE... from me!",
				TRADER_NO_GOODS    = "Thank you for... that quality... OFFER THAT ISN'T MONEY THAT I WILL REFUSE... from me!",
				TRADER_NOT_ENOUGH  = "Thank you for... that quality... OFFER THAT IS NOT ENOUGH... from me!",
				TRADER_HOW_MUCH          = "Thank you for... ASKING ME ABOUT MY PRICES... that quality... ITEM is worth VALUE... from me!",

				TRADER_COMPLEMENT_FAILURE   = "Thank you for... that quality... COMPLIMENT... from me!",
				TRADER_COMPLEMENT_SUCCESS = "Thank you for... that quality... COMPLIMENT... from me!",
				TRADER_INSULT_GOOD       = "Thank you for... that quality... INSULT... from me!",
				TRADER_INSULT_BAD        = "Thank you for... that quality... INSULT... from me!"
				)
	compliment_increase = 0
	insult_drop = 0

	possible_trading_items = list(/obj/item/gun/projectile/pirate                = TRADER_THIS_TYPE,
								/obj/item/gun/projectile/pistol/sec/MK                  = TRADER_THIS_TYPE,
								/obj/item/gun/projectile/heavysniper/ant         = TRADER_THIS_TYPE,
								/obj/item/gun/energy/laser/dogan                 = TRADER_THIS_TYPE,
								/obj/item/gun/projectile/automatic/machine_pistol/usi  = TRADER_THIS_TYPE,
								/obj/item/clothing/accessory/storage/holster                    = TRADER_ALL)