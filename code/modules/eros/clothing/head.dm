/obj/item/clothing/head/pajamahat
	name = "blue pajama hat"
	desc = "Comfy enough to sleep in."
	icon_state = "eros_pajamahat_blue"

/obj/item/clothing/head/pajamahat/red
	name = "red pajama hat"
	icon_state = "eros_pajamahat_red"

/obj/item/clothing/head/maidhat
	name = "maid headband"
	desc = "Keeps hair out of the way for important... jobs."
	icon_state = "eros_maidhat"

/obj/item/clothing/head/boaterhat/striped
	name = "striped boater"
	desc = "A summery hat with two stripes."
	icon_state = "eros_boater"

/obj/item/clothing/head/pinkpin
	name = "pink hairpin"
	desc = "A cute pink hairpin."
	icon_state = "eros_pinpink"

/obj/item/clothing/head/cloverpin
	name = "lucky clover hairpin"
	desc = "Four leaves! Maybe you'll get lucky this shift."
	icon_state = "eros_pinclover"

/obj/item/clothing/head/butterflypin
	name = "butterfly hairpin"
	desc = "A delicate looking mass-produced plastic butterfly pin."
	icon_state = "eros_pinbutterfly"

/obj/item/clothing/head/magnetclips
	name = "magnet hairclips"
	desc = "Wearing these is a good excuse to be contrary, because they're positive and negative."
	icon_state = "eros_magnetclip"

/obj/item/clothing/head/hairribbon
	name = "white hair ribbon"
	desc = "It's a white ribbon, as pure as you surely aren't."
	icon_state = "eros_whiteribbon"

/obj/item/clothing/head/hairribbon/red
	name = "red hair ribbon"
	desc = "It's a red ribbon, for hair."
	icon_state = "eros_redribbon"

/obj/item/clothing/head/hairribbon/color
	name = "bow"
	desc = "It's a bow, for your head."
	icon_state = "bow_color"
	flags = GEAR_HAS_COLOR_SELECTION

/obj/item/clothing/head/froghat
	name = "froggie hat"
	desc = "A hat this adorable should probably be breaking laws."
	icon_state = "eros_froggie"

/obj/item/clothing/head/cowboy_hat/cowboy2
	name = "brown cowboy hat"
	icon_state = "eros_cowboyhat"
	item_state = "eros_cowboyhat"

/obj/item/clothing/head/cowboy_hat/cowboywide
	name = "wide-brimmed cowboy hat"
	icon_state = "brownhat"
	item_state = "brownhat"

/obj/item/clothing/head/cowboy_hat/black
	name = "black cowboy hat"
	desc = "Whoever wears this is probably pretty villainous."
	icon_state = "blackhat"
	item_state = "blackhat"

/obj/item/clothing/head/detectivenoir
	name = "detective noir hat"
	desc = "This hat makes you feel serious."
	icon_state = "eros_detective_noir"

/obj/item/clothing/head/lolitahat
	name = "lolita hat"
	icon_state = "eros_lolitahat"

/obj/item/clothing/head/techassist
	name = "technical assistant cap"
	icon_state = "eros_assistenghat"

/obj/item/clothing/head/soft/black
	name = "black cap"
	desc = "It's a peaked cap in a tasteful black color."
	icon_state = "blacksoft"
	item_state_slots = list(slot_r_hand_str = "blacksoft", slot_l_hand_str = "blacksoft")

/obj/item/clothing/head/santa
	name = "santa hat"
	desc = "It's a festive christmas hat, in red!"
	icon_state = "eros_santahatnorm"
	item_state_slots = list(slot_r_hand_str = "santahat", slot_l_hand_str = "santahat")

/obj/item/clothing/head/santa/green
	name = "green santa hat"
	desc = "It's a festive christmas hat, in green!"
	icon_state = "eros_santahatgreen"
	item_state_slots = list(slot_r_hand_str = "santahatgreen", slot_l_hand_str = "santahatgreen")

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon_state = "eros_beanie"

/obj/item/clothing/head/beanie_loose
	name = "loose beanie"
	desc = "A head-hugging brimless winter cap. This one is loose."
	icon_state = "eros_beanie_hang"

/obj/item/clothing/head/sombrero
	name = "sombrero"
	desc = "A wide-brimmed hat popularly worn in Mexico."
	icon_state = "eros_sombrero"

/obj/item/clothing/head/helmet/knight    //  No icon for grey helmet, so the parent is just for defining
	name = "knight helmet"
	desc = "A classic metal helmet."
	armor = list(melee = 41, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0, fire = 0, acid = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/helmet/knight/green
	name = "green knight helmet"
	desc = "A classic metal helmet. It has green decor."
	icon_state = "eros_knight_green"
	item_state = "eros_knight_green"

/obj/item/clothing/head/helmet/knight/blue
	name = "blue knight helmet"
	desc = "A classic metal helmet. It has blue decor."
	icon_state = "eros_knight_blue"
	item_state = "eros_knight_blue"

/obj/item/clothing/head/helmet/knight/red
	name = "red knight helmet"
	desc = "A classic metal helmet. It has red decor."
	icon_state = "eros_knight_red"
	item_state = "eros_knight_red"

/obj/item/clothing/head/helmet/knight/yellow
	name = "yellow knight helmet"
	desc = "A classic metal helmet. It has yellow decor."
	icon_state = "eros_knight_yellow"
	item_state = "eros_knight_yellow"

/obj/item/clothing/head/helmet/knight/templar
	name = "crusader helmet"
	desc = "Deus Vult."
	icon_state = "eros_knight_templar"
	item_state = "eros_knight_templar"