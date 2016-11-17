//Glass 'costs' are based both on  glass(vol)=571.122621(ln vol)-1734.24483,
//                             and glass(vol)=(50/7)vol+(1000/7),
//and put on a 1:5 log-lin weighted average. -Alice

/obj/item/weapon/reagent_containers/food/drinks/glass2/square
	name = "highball glass"
	base_name = "glass"
	base_icon = "square"
	matter = list("glass" = 350)
	filling_states = "20;40;60;80;100"
	volume = 30
	possible_transfer_amounts = "5;10;15;30"
	rim_pos = "y=23;x_left=13;x_right=20"

/obj/item/weapon/reagent_containers/food/drinks/glass2/rocks
	name = "rocks glass"
	base_name = "glass"
	base_icon = "rocks"
	matter = list("glass" = 250)
	filling_states = "25;50;75;100"
	volume = 20
	possible_transfer_amounts = "5;10;20"
	rim_pos = "y=21;x_left=10;x_right=23"

/obj/item/weapon/reagent_containers/food/drinks/glass2/shake
	name = "milkshake glass"
	base_name = "glass"
	base_icon = "shake"
	matter = list("glass" = 375) //Stemware
	filling_states = "25;50;75;100"
	volume = 30
	possible_transfer_amounts = "5;10;15;30"
	rim_pos = "y=25;x_left=13;x_right=21"

/obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail
	name = "cocktail glass"
	base_name = "glass"
	base_icon = "cocktail"
	matter = list("glass" = 250) //Stemware
	filling_states = "33;66;100"
	volume = 15
	possible_transfer_amounts = "5;10;15"
	rim_pos = "y=22;x_left=13;x_right=21"

/obj/item/weapon/reagent_containers/food/drinks/glass2/shot
	name = "shot glass"
	base_name = "shot"
	base_icon = "shot"
	matter = list("glass" = 100)
	filling_states = "33;66;100"
	volume = 5
	possible_transfer_amounts = "1;2;5"
	rim_pos = "y=17;x_left=13;x_right=21"

/obj/item/weapon/reagent_containers/food/drinks/glass2/pint
	name = "pint glass"
	base_name = "pint"
	base_icon = "pint"
	matter = list("glass" = 600) //Fat tunc
	filling_states = "16;33;50;66;83;100"
	volume = 60
	possible_transfer_amounts = "5;10;15;30;60"
	rim_pos = "y=25;x_left=12;x_right=21"

/obj/item/weapon/reagent_containers/food/drinks/glass2/mug
	name = "glass mug"
	base_name = "mug"
	base_icon = "mug"
	matter = list("glass" = 475) //Handle
	filling_states = "25;50;75;100"
	volume = 40
	possible_transfer_amounts = "5;10;20;40"
	rim_pos = "y=22;x_left=12;x_right=20"

/obj/item/weapon/reagent_containers/food/drinks/glass2/wine
	name = "wine glass"
	base_name = "glass"
	base_icon = "wine"
	matter = list("glass" = 350) //Stemware
	filling_states = "20;40;60;80;100"
	volume = 25
	possible_transfer_amounts = "5;10;15;25"
	rim_pos = "y=25;x_left=12;x_right=21"
