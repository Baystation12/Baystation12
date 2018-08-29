/proc/convert_gas_id_to_html_symbol(var/gas)
	if(gas == "hydrogen")
		return "H<sub>2</sub>"
	if(gas == "helium")
		return "He"
	if(gas == "chlorine")
		return "Cl"
	if(gas == "nitrogen")
		return "N<sub>2</sub>"
	if(gas == "oxygen")
		return "O<sub>2</sub>"
	if(gas == "sleeping_agent")
		return "N<sub>2</sub>O"
	if(gas == "phoron")
		return "Ph"
	if(gas == "carbon_dioxide")
		return "CO<sub>2</sub>"
	if(gas == "methyl_bromide")
		return "CH<sub>3</sub>Br"
	if(gas == "carbon_monoxide")
		return "CO"
	if(gas == "methane")
		return "CH<sub>4</sub>"
	if(gas == "deuterium")
		return "D"
	if(gas == "tritium")
		return "T"
	if(gas == "argon")
		return "Ar"
	if(gas == "krypton")
		return "Kr"
	if(gas == "neon")
		return "Ne"
	if(gas == "xenon")
		return "Xe"
	if(gas == "nitrodioxide")
		return "NO<sub>2</sub>"
	if(gas == "nitricoxide")
		return "NO"
	if(gas == "watervapor")
		return "H<sub>2</sub>O"
	if(gas == "sulfurdioxide")
		return "SO<sub>2</sub>"
	if(gas == "ammonia")
		return "NH<sub>3"
	else
		return "X"

/proc/convert_gas_id_to_text_symbol(var/gas)
	if(gas == "hydrogen")
		return "H2"
	if(gas == "helium")
		return "He"
	if(gas == "chlorine")
		return "Cl"
	if(gas == "nitrogen")
		return "N2"
	if(gas == "oxygen")
		return "O2"
	if(gas == "sleeping_agent")
		return "N2O"
	if(gas == "phoron")
		return "Ph"
	if(gas == "carbon_dioxide")
		return "CO2"
	if(gas == "methyl_bromide")
		return "CH3Br"
	if(gas == "carbon_monoxide")
		return "CO"
	if(gas == "methane")
		return "CH4"
	if(gas == "deuterium")
		return "D"
	if(gas == "tritium")
		return "T"
	if(gas == "argon")
		return "Ar"
	if(gas == "krypton")
		return "Kr"
	if(gas == "neon")
		return "Ne"
	if(gas == "xenon")
		return "Xe"
	if(gas == "nitrodioxide")
		return "NO2"
	if(gas == "nitricoxide")
		return "NO"
	if(gas == "watervapor")
		return "H2O"
	if(gas == "sulfurdioxide")
		return "SO2"
	if(gas == "ammonia")
		return "NH3"
	else
		return "X"