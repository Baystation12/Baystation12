/obj/item/clothing/under/pj/red
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	item_color = "red_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/pj/blue
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	item_color = "blue_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/captain_fly
	name = "rogue captains uniform"
	desc = "For the man who doesn't care because he's still free."
	icon_state = "captain_fly"
	item_state = "captain_fly"
	item_color = "captain_fly"

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon_state = "scratch"
	item_state = "scratch"
	item_color = "scratch"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	item_color = "sl_suit"

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	item_color = "waiter"

/obj/item/clothing/under/rank/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state = "b_suit"
	item_color = "mailman"

/obj/item/clothing/under/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state = "sexyclown"
	item_color = "sexyclown"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/vice
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state = "gy_suit"
	item_color = "vice"


/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Ensign.\""
	name = "\improper NanoTrasen Navy Uniform"
	icon_state = "officer"
	item_state = "g_suit"
	item_color = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Lieutenant Commander.\""
	name = "\improper NanoTrasen Officers Uniform"
	icon_state = "officer"
	item_state = "g_suit"
	item_color = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\""
	name = "\improper NanoTrasen Captains Uniform"
	icon_state = "centcom"
	item_state = "dg_suit"
	item_color = "centcom"
	displays_id = 0

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state = "bl_suit"
	item_color = "ert_uniform"

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	item_color = "syndicate"
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"
	item_color = "owl"

/obj/item/clothing/under/johnny
	name = "johnny~~ jumpsuit"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_color = "johnny"

/obj/item/clothing/under/rainbow
	name = "rainbow"
	desc = "rainbow"
	icon_state = "rainbow"
	item_state = "rainbow"
	item_color = "rainbow"

/obj/item/clothing/under/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	item_color = "cloud"

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state = "psysuit"
	item_color = "psysuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gentlesuit
	name = "Gentlemans Suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state = "gentlesuit"
	item_color = "gentlesuit"

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	item_color = "green_suit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	item_color = "teal_suit"

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	item_color = "black_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon_state = "really_black_suit"
	item_state = "bl_suit"
	item_color = "black_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state = "black_suit_fem"
	item_color = "black_suit_fem"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	item_color = "red_suit"

/obj/item/clothing/under/blackskirt
	name = "black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	item_color = "blackskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	item_color = "schoolgirl"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	item_color = "overalls"

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	item_color = "pirate"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "soviet"
	item_color = "soviet"

/obj/item/clothing/under/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state = "redcoat"
	item_color = "redcoat"

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid"
	icon_state = "kilt"
	item_state = "kilt"
	item_color = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state = "sexymime"
	item_color = "sexymime"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "gladiator"
	item_color = "gladiator"
	body_parts_covered = LOWER_TORSO

//dress
/obj/item/clothing/under/dress/
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/dress_fire
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon_state = "dress_fire"
	item_color = "dress_fire"

/obj/item/clothing/under/dress/dress_green
	name = "green dress"
	desc = "A simple, tight fitting green dress."
	icon_state = "dress_green"
	item_color = "dress_green"

/obj/item/clothing/under/dress/dress_orange
	name = "orange dress"
	desc = "A fancy orange gown for those who like to show leg."
	icon_state = "dress_orange"
	item_color = "dress_orange"

/obj/item/clothing/under/dress/dress_pink
	name = "pink dress"
	desc = "A simple, tight fitting pink dress."
	icon_state = "dress_pink"
	item_color = "dress_pink"

/obj/item/clothing/under/dress/dress_yellow
	name = "yellow dress"
	desc = "A flirty, little yellow dress."
	icon_state = "dress_yellow"
	item_color = "dress_yellow"

/obj/item/clothing/under/dress/dress_saloon
	name = "saloon girl dress"
	desc = "A old western inspired gown for the girl who likes to drink."
	icon_state = "dress_saloon"
	item_color = "dress_saloon"


/obj/item/clothing/under/dress/dress_cap
	name = "captain's dress uniform"
	desc = "Feminine fashion for the style concious captain."
	icon_state = "dress_cap"
	item_color = "dress_cap"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style concious HoP."
	icon_state = "dress_hop"
	item_color = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon_state = "huresource"
	item_color = "huresource"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/plaid_blue
	name = "blue plaid skirt"
	desc = "A preppy blue skirt with a white blouse."
	icon_state = "plaid_blue"
	item_color = "plaid_blue"

/obj/item/clothing/under/dress/plaid_red
	name = "red plaid skirt"
	desc = "A preppy red skirt with a white blouse."
	icon_state = "plaid_red"
	item_color = "plaid_red"

/obj/item/clothing/under/dress/plaid_purple
	name = "blue purple skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_purple"
	item_color = "plaid_purple"

//wedding stuff
/obj/item/clothing/under/wedding/
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/wedding/bride_orange
	name = "orange wedding dress"
	desc = "A big and puffy orange dress."
	icon_state = "bride_orange"
	item_color = "bride_orange"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_purple
	name = "purple wedding dress"
	desc = "A big and puffy purple dress."
	icon_state = "bride_purple"
	item_color = "bride_purple"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_blue
	name = "blue wedding dress"
	desc = "A big and puffy blue dress."
	icon_state = "bride_blue"
	item_color = "bride_blue"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_red
	name = "red wedding dress"
	desc = "A big and puffy red dress."
	icon_state = "bride_red"
	item_color = "bride_red"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_white
	name = "silky wedding dress"
	desc = "A white wedding gown made from the finest silk."
	icon_state = "bride_white"
	item_color = "bride_white"
	flags_inv = HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	item_state = "sundress"
	item_color = "sundress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress_white
	name = "white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon_state = "sundress_white"
	item_state = "sundress_white"
	item_color = "sundress_white"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon_state = "captain_formal"
	item_state = "by_suit"
	item_color = "captain_formal"

/obj/item/clothing/under/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_male"
	item_state = "r_suit"
	item_color = "hos_formal_male"

/obj/item/clothing/under/hosformalfem
	name = "head of security's formal uniform"
	desc = "A female head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_fem"
	item_state = "r_suit"
	item_color = "hos_formal_fem"

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	item_color = "assistant_formal"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state = "charcoal_suit"
	item_color = "charcoal_suit"

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state = "navy_suit"
	item_color = "navy_suit"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state = "burgundy_suit"
	item_color = "burgundy_suit"

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state = "checkered_suit"
	item_color = "checkered_suit"

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit with a yellow tie. Smart, but casual."
	icon_state = "tan_suit"
	item_state = "tan_suit"
	item_color = "tan_suit"

/obj/item/clothing/under/serviceoveralls
	name = "Workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic_s"
	item_state = "mechanic_s"
	item_color = "mechanic_s"

/obj/item/clothing/under/cheongsam
	name = "White Cheongsam"
	desc = "It is a white cheongsam dress."
	icon_state = "mai_yang"
	item_state = "mai_yang"
	item_color = "mai_yang"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
