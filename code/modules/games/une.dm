#define REDCARD	"#ff0000"
#define YELLOWCARD	"#f9d009"
#define GREENCARD	"#00cc00"
#define BLUECARD	"#0000ff"
#define BLACKCARD	"#000000"

/obj/item/deck/cards/une
	name = "deck of une cards"
	desc = "A deck of une playing cards. The non-violent interspecies mediator of disputes."
	icon = 'icons/obj/une_cards.dmi'
	icon_state = "deck_full"

/obj/item/deck/cards/une/Initialize()
	. = ..()
	for(var/i = 0 to 9)
		cards += new/obj/item/hand/une(src, src, "Red [i]", "[i]", REDCARD)
		cards += new/obj/item/hand/une(src, src, "Yellow [i]", "[i]", YELLOWCARD)
		cards += new/obj/item/hand/une(src, src, "Green [i]", "[i]", GREENCARD)
		cards += new/obj/item/hand/une(src, src, "Blue [i]", "[i]", BLUECARD)
	for(var/i = 1 to 9)//Second full set without a 0 card this time.
		cards += new/obj/item/hand/une(src, src, "Red [i]", "[i]", REDCARD)
		cards += new/obj/item/hand/une(src, src, "Yellow [i]", "[i]", YELLOWCARD)
		cards += new/obj/item/hand/une(src, src, "Green [i]", "[i]", GREENCARD)
		cards += new/obj/item/hand/une(src, src, "Blue [i]", "[i]", BLUECARD)
	for(var/i = 0 to 3)//Black is just a placeholder and not actually used in the coloring.
		cards += new/obj/item/hand/une(src, src, "Wild", "wild", BLACKCARD)
		cards += new/obj/item/hand/une(src, src, "Draw 4", "draw4", BLACKCARD)
	for(var/i = 1 to 8)
		var/cardcolor = "Red"
		var/hexcolor = REDCARD
		switch(i)
			if(1,2)
				cardcolor = "Red"
				hexcolor = REDCARD
			if(3,4)
				cardcolor = "Yellow"
				hexcolor = YELLOWCARD
			if(5,6)
				cardcolor = "Green"
				hexcolor = GREENCARD
			if(7,8)
				cardcolor = "Blue"
				hexcolor = BLUECARD
		cards += new/obj/item/hand/une(src, src, "[cardcolor] Skip", "skip", hexcolor)
		cards += new/obj/item/hand/une(src, src, "[cardcolor] Reverse", "reverse",  hexcolor)
		cards += new/obj/item/hand/une(src, src, "[cardcolor] Draw 2", "draw2", hexcolor)


/obj/item/hand/une
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/une_cards.dmi'
	icon_state = "unecard_down"
	var/image/unecardimg

/obj/item/hand/une/Initialize(mapload, cardsource, newcardname, truecardname, cardhexcolor)
	unecardimg = image('icons/obj/une_cards.dmi', truecardname)
	if (cardhexcolor != BLACKCARD)
		unecardimg.color = cardhexcolor
	return ..()

/obj/item/hand/une/on_update_icon()
	overlays.Cut()
	if(concealed)
		icon_state = "unecard_down"
		pixel_x = -5
	else
		icon_state = "unecard_up"
		overlays += unecardimg
		pixel_x = 5


#undef REDCARD
#undef YELLOWCARD
#undef GREENCARD
#undef BLUECARD