/decl/nuclear_reaction  //Nuclear reactions, simillar to fusion and you also can add them as much, as you want.
	var/substance = ""
	var/required_rads = 0
	var/heat_production = 0
	var/radiation = 0
	var/list/products = list()  // Just DO NOT forget, products must be = 1 in summary.





/decl/nuclear_reaction/U235_chain
	substance = "U235"
	required_rads = 5
	heat_production = 10
	radiation = 30
	products = list("radioactive waste" = 0.5, "nuclear waste" = 0.5)

/decl/nuclear_reaction/U235_decay
	substance = "U235"
	required_rads = 0
	heat_production = 1
	radiation = 3
	products = list("radioactive waste" = 0.05, "nuclear waste" = 0.95)

/decl/nuclear_reaction/radioactive_waste_decay
	substance = "radioactive waste"
	required_rads = 0
	heat_production = 1
	radiation = 2
	products = list("nuclear waste" = 1)

/decl/nuclear_reaction/Pu239_chain
	substance = "Pu239"
	required_rads = 7
	heat_production = 15
	radiation = 20
	products = list("radioactive waste" = 0.6, "nuclear waste" = 0.4)

/decl/nuclear_reaction/Pu239_Decay
	substance = "Pu239"
	required_rads = 0
	heat_production = 1
	radiation = 3
	products = list("radioactive waste" = 0.7, "nuclear waste" = 0.3)

/decl/nuclear_reaction/U238_breed
	substance = "U238"
	required_rads = 50
	heat_production = 5
	radiation = 2
	products = list("radioactive waste" = 0.25, "Pu239" = 0.05,  "nuclear waste" = 0.7 )

/decl/nuclear_reaction/Th232_breed
	substance = "Th232"
	required_rads = 10
	heat_production = 1
	radiation = 1
	products = list("Th233" = 0.5, "nuclear waste" = 0.5 )



/decl/nuclear_reaction/Th233_decay
	substance = "Th233"
	required_rads = 0
	heat_production = 1
	radiation = 1
	products = list("radioactive waste" = 0.5, "nuclear waste" = 0.5 )


/decl/nuclear_reaction/Th233_chain
	substance = "Th233"
	required_rads = 30
	heat_production = 5
	radiation = 15
	products = list("radioactive waste" = 0.3, "nuclear waste" = 0.6, "U235" = 0.1)

/decl/nuclear_reaction/Sr90_Decay
	substance = "Sr90"
	required_rads = 0
	heat_production = 5
	radiation = 1
	products = list("radioactive waste" = 0.1, "nuclear waste" = 0.9)
