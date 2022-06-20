GLOBAL_LIST_EMPTY(skills)

/decl/hierarchy/skill
	var/ID = "none"                        // ID of this skill. Needs to be unique.
	name = "None"                          // Name of the skill. This is what the player sees.
	hierarchy_type = /decl/hierarchy/skill // Don't mess with this without changing how Initialize works.
	var/desc = "Placeholder skill"         // Generic description of this skill.

   	// Names for different skill values, in order from 1 up.
	var/levels = list( 		"Inexperto"			= "Inexperto Descripcion",
							"Basico"				= "Basico Descripcion",
							"Entrenado"			= "Entrenado Descripcion",
							"Experto"		= "Experto Descripcion",
							"Maestro"		= "Maestro Descripcion")
	var/difficulty = SKILL_AVERAGE         //Used to compute how expensive the skill is
	var/default_max = SKILL_ADEPT          //Makes the skill capped at this value in selection unless overriden at job level.
	var/prerequisites                      // A list of skill prerequisites, if needed.

/decl/hierarchy/skill/proc/get_cost(var/level)
	switch(level)
		if(SKILL_BASIC, SKILL_ADEPT)
			return difficulty
		if(SKILL_EXPERT, SKILL_PROF)
			return 2*difficulty
		else
			return 0

/decl/hierarchy/skill/proc/update_special_effects(mob/mob, level)

/decl/hierarchy/skill/Initialize()
	. = ..()
	if(is_hidden_category())
		if(!GLOB.skills.len)
			for(var/decl/hierarchy/skill/C in children)
				GLOB.skills += C.get_descendents()
		else
			CRASH("Warning: multiple instances of /decl/hierarchy/skill have been created!")

/decl/hierarchy/skill/dd_SortValue()
	return ID

/decl/hierarchy/skill/organizational
	name = "Organizativas"
	ID	 = "1"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/decl/hierarchy/skill/general
	name = "Generales"
	ID	 = "2"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/decl/hierarchy/skill/service
	name = "Servicios"
	ID	 = "service"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX

/decl/hierarchy/skill/security
	name = "Seguridad"
	ID	 = "security"

/decl/hierarchy/skill/engineering
	name = "Ingenieria"
	ID	 = "engineering"

/decl/hierarchy/skill/research
	name = "Investigacion"
	ID	 = "research"

/decl/hierarchy/skill/medical
	name = "Medicas"
	ID	 = "medical"
	difficulty = SKILL_HARD

// ONLY SKILL DEFINITIONS BELOW THIS LINE
// Category: Organizational

/decl/hierarchy/skill/organizational/bureaucracy
	ID = "bureaucracy"
	name = "burocracia"
	desc = "Su capacidad para escribir y completar documentos, navegar organizaciones complejas, comprender las leyes y reglamentos."
	levels = list( "Inexperto"			= "Por lo general, puede completar el papeleo basico, aunque con algunos errores. Tiene un conocimiento vago de la ley, obtenido principalmente de las noticias y la experiencia personal.",
						"Basico"				= "Esta familiarizado con el papeleo necesario para hacer su trabajo y puede manejarlo bien. Tiene cierta comprension de la ley que se aplica a usted y a quienes lo rodean.",
						"Entrenado"			= "Puede navegar por la mayoria de los documentos que se le presenten, incluso si no esta familiarizado con ellos. Tiene un buen conocimiento practico de la ley y de cualquier regulacion o procedimiento relevante para usted.",
						"Experto"		= "Con su experiencia, puede crear facilmente papeleo para cualquier eventualidad y escribir informes que sean claros y comprensibles. Tiene un excelente conocimiento de la ley, que posiblemente incluya capacitacion legal formal.",
						"Maestro"		= "Puede hacer que el papeleo baile a su gusto y navegar por las estructuras burocraticas más bizantinas con facilidad y familiaridad. Sus informes son obras de literatura. Su conocimiento de la ley es amplio e intimo, y puede estar certificado para ejercer la abogacia.")

/decl/hierarchy/skill/organizational/finance
	ID = "finance"
	name = "Finanzas"
	desc = "Su capacidad para administrar el dinero y las inversiones."
	levels = list( "Inexperto"			= "Su comprension del dinero comienza y termina con las finanzas personales. Si bien puedes realizar transacciones basicas, te pierdes en los detalles y, en ocasiones, puedes encontrarte estafado.<br>- Obtienes algo de dinero inicial. Su cantidad aumenta con el nivel.<br>- Puedes usar el verbo \"Appraise\" para ver el valor de diferentes objetos.",
						"Basico"				= "Tiene una comprension limitada de las transacciones financieras y, en general, podra mantener registros precisos. Tiene poca experiencia en inversiones y administrar grandes sumas de dinero probablemente no le vaya bien.",
						"Entrenado"			= "Es bueno para administrar cuentas, mantener registros y organizar transacciones. Tiene cierta familiaridad con las hipotecas, los seguros, las acciones y los bonos, pero puede quedarse perplejo cuando se enfrenta a dispositivos financieros mas complicados.",
						"Experto"		= "Con su experiencia, esta familiarizado con cualquier entidad financiera con la que se pueda encontrar y es un astuto juez de valor. La mayoria de las veces, las inversiones que haga daran buenos resultados.",
						"Maestro"		= "Tiene un excelente conocimiento de las finanzas, a menudo hara inversiones brillantes y tiene una idea instintiva de la economia interestelar. Los instrumentos financieros son armas en sus manos. Es probable que tenga experiencia profesional en la industria financiera.")

// Category: General

/decl/hierarchy/skill/general/EVA
	ID = "EVA"
	name = "Actividad extra-vehicular"
	desc = "Esta habilidad describe su habilidad y conocimiento de los trajes espaciales y el trabajo en el vacío."
	levels = list( "Inexperto"			= "Tienes un entrenamiento basico de seguridad comun a las personas que trabajan en el espacio: sabes como ponerte y sellar tus partes internas, y probablemente puedas ponerte un traje espacial si realmente lo necesitas, aunque seras torpe en eso. Todavia eres propenso a cometer errores que pueden dejarte tratando de respirar vacio.<br>- Puedes quitarte los trajes EVA. Su velocidad aumenta con el nivel.<br>- Siempre te derribaras cuando ingreses al area de gravedad desde el espacio. Esta posibilidad disminuye con el nivel.<br>- Es probable que se resbale. Esta posibilidad disminuye con el nivel.",
						"Basico"				= "Ha tenido un entrenamiento basico completo en operaciones de EVA y es poco probable que cometa errores de principiante. Sin embargo, tiene poca experiencia trabajando en el vacio.",
						"Entrenado"			= "Puede usar comodamente un traje espacial y hacerlo regularmente en el transcurso de su trabajo. Revisar sus partes internas es una segunda naturaleza para usted, y no entra en panico en una emergencia.<br>- Puede operar mochilas propulsoras por completo.",
						"Experto"		= "Puedes usar todo tipo de trajes espaciales, incluidas las versiones especializadas. Tu experiencia en EVA evitan que te desorientes en el espacio y tienes experiencia en el uso de un jetpack para moverte. <br>- Ya no te resbalar.",
						"Maestro"		= "Estas tan a gusto en el vacio como en la atmosfera. Probablemente haces tu trabajo casi en su totalidad con EVA.<br>- Ya no puedes volver a resbalarte.<br>- Obtienes velocidad adicional en gravedad cero.")

/decl/hierarchy/skill/general/EVA/mech
	ID = "Exotraje"
	name = "Operacion exotraje"
	desc = "Le permite operar exotrajes bien."
	levels = list("Inexperto" = "No esta familiarizado con los controles del exotraje y, si intenta usarlos, es probable que cometa errores.",
		"Entrenado" = "Eres experto en el funcionamiento y la seguridad de los exotrajes, y puedes usarlos sin penalizaciones.")
	prerequisites = list(SKILL_EVA = SKILL_ADEPT)
	default_max = SKILL_BASIC
	difficulty = SKILL_AVERAGE

/decl/hierarchy/skill/general/pilot
	ID = "pilot"
	name = "Pilotaje"
	desc = "Describe su experiencia y comprension del pilotaje de naves espaciales, desde capsulas pequeñas y de corto alcance hasta naves del volumen de una corbeta."
	levels = list( "Inexperto"			= "Sabes lo que es una nave espacial y es posible que tengas una comprension abstracta de las diferencias entre varias naves. Si su departamento esta involucrado en el uso de naves espaciales, sabe aproximadamente cuales son sus capacidades. Es posible que puedas pilotar una nave espacial en un videojuego. Si tuviera que tomar el timon de una embarcacion menor, es posible que pueda moverla con la guia adecuada.<br>- El tiempo de viaje entre transiciones disminuye con el nivel.<br>- Puede volar barcos, pero su movimiento puede ser aleatorio. <br>- La velocidad de tu nave contra las carpas aumentara con el nivel.",
						"Basico"				= "Puede pilotar una nave menor de corto alcance de manera segura, pero las naves mas grandes estan fuera de su area de especializacion. De ninguna manera eres un experto y probablemente no tengas mucho entrenamiento. Las habilidades de este nivel son tipicas de la tripulacion de cubierta.<br>- Puede operar lanzaderas sin errores.<br>- Puede evitar completamente meteoritos a baja velocidad mientras usa lanzaderas como el GUP.",
						"Entrenado"			= "Eres un piloto entrenado y puedes operar con seguridad cualquier cosa, desde una embarcacion menor hasta una corbeta. Puedes pasar largos periodos de tiempo pilotando una nave espacial, y estas versado en las habilidades de las diferentes naves y lo que las hace funcionar. Puede realizar el mantenimiento basico en embarcaciones menores y realizar la mayoria de las maniobras basicas. Puedes usar naves espaciales armadas. Puede realizar calculos basicos relacionados con el pilotaje. Las habilidades de este nivel son tipicas de los pilotos mas nuevos. Probablemente hayas recibido entrenamiento formal de pilotaje.<br>- Puedes operar naves grandes sin errores.<br>- Puedes evitar meteoritos en su mayoria a baja velocidad usando cualquier transbordador.",
						"Experto"		= "Eres un piloto experimentado y puedes tomar el timon de forma segura en muchos tipos de embarcaciones. Probablemente podria vivir en una nave espacial, y esta muy bien versado en practicamente todo lo relacionado con las naves espaciales. No solo puede volar una nave, sino que tambien puede realizar maniobras dificiles y hacer la mayoria de los calculos relacionados con el pilotaje de una nave espacial. Puedes mantener un barco. Las habilidades de este nivel son tipicas de pilotos muy experimentados. Has recibido entrenamiento formal de pilotaje.<br>- Puedes esquivar meteoritos a velocidad normal mientras usas diminutas lanzaderas.",
						"Maestro"		= "No solo eres un piloto excepcional, sino que dominas funciones perifericas como la navegacion estelar y el trazado de saltos en el espacio azul. Tienes experiencia realizando maniobras complejas, manejando escuadrones de naves menores y operando en ambientes hostiles.<br>- Puedes evitar meteoritos en su mayoria a velocidad normal usando cualquier transbordador.<br>- Menos meteoritos golpearan el barco mientras pasa a traves de campos de meteoritos .")
	difficulty = SKILL_AVERAGE
	default_max = SKILL_ADEPT

/decl/hierarchy/skill/general/hauling
	ID = "hauling"
	name = "Atletismo"
	desc = "Tu habilidad para realizar tareas que requieren gran fuerza, destreza o resistencia."
	levels = list( "Inexperto"			= "No esta acostumbrado al trabajo manual, se cansa con facilidad y es probable que no este en buena forma. El trabajo pesado prolongado puede ser peligroso para usted.<br>- Puede tirar de objetos pero empezar a generar Lactate despues de agotarte. Tu fuerza aumenta con el nivel.<br>- Puedes lanzar objetos. Su velocidad, distancia de lanzamiento y fuerza aumentan con el nivel.<br>- Puedes correr, la tasa de consumo de resistencia se reduce con cada nivel. <br>- Puedes saltar haciendo clic en un objetivo distante con la intención de agarrarlo, el rango de salto aumenta y las posibilidades de caerte se reducen con cada nivel.",
						"Basico"				= "Estas familiarizado con el trabajo manual y estas en una forma fisica razonable. Las tareas que requieren una gran destreza o fuerza aun pueden eludirte.<br>- Puedes lanzar objetos \"enormes\" o mobs de volumen normal sin debilitarse.",
						"Entrenado"			= "Tienes suficiente fuerza y destreza para tareas mas extenuantes y puedes realizar trabajo fisico durante periodos mas largos sin cansarte.",
						"Experto"		= "Es probable que tengas experiencia con trabajos pesados en condiciones físicas exigentes y estes en excelente forma. Es posible que visite el gimnasio con frecuencia.",
						"Maestro"		= "Estas en excelente forma. Esta bien adaptado para realizar trabajos fisicos pesados y es posible que haya solicitado PT adicional.")

/decl/hierarchy/skill/general/computer
	ID = "computer"
	name = "Ingenieria informatica"
	desc = "Describe su comprension de las computadoras, el software y la comunicación. No es un requisito para usar computadoras, pero definitivamente ayuda. Se usa en telecomunicaciones y programacion de computadoras e IA."
	levels = list( "Inexperto"			= "Sabes usar las computadoras y los dispositivos de comunicacion con los que creciste. Puedes usar una consola de computadora, una radio de mano o montada en la pared y tus auriculares, asi como tu PDA Sabes lo que es una IA, pero puedes verlos como \"personas hechas de silicio\" o \"solo maquinas\", sabes que tienen que obedecer sus leyes, pero no sabes mucho acerca de como o por que funcionan.",
						"Basico"				= "Conoces los conceptos basicos de la programacion, pero no eres muy bueno en eso y no podrias hacerlo profesionalmente. Tienes una idea bastante buena de lo que hace funcionar a las IA. Entiendes como se almacena la información en una computadora , y puede solucionar problemas informaticos sencillos. Tiene conocimientos de informatica, pero sigue cometiendo errores. Si intentara subvertir la IA, podria cometer errores al redactar sus nuevas leyes.<br>- El programa de descifrado de acceso antagonista ha una posibilidad de evitar disparar alarmas y trabajar de manera mas efectiva. Esto aumenta con el nivel.",
						"Entrenado"			= "En este nivel, probablemente este trabajando con computadoras todos los dias. Comprende y puede reparar la red de telecomunicaciones. Su comprension de la programacion y la psicologia de la IA le permite solucionar problemas con las IA o los cyborgs, o crear problemas, si asi lo desea. Puede programar computadoras e IA y cambiar sus leyes de manera efectiva.<br>- Puede operar completamente los programas Monitor de red, Administracion de correo electronico y Administracion de IA",
						"Experto"		= "Tienes mucha de experiencia con redes informaticas, sistemas de IA, telecomunicaciones y tareas de administracion de sistemas. Conoces a la perfeccion los sistemas que se utilizan a diario y puedes diagnosticar problemas complejos.<br>- El programa antagonista dos ofrece informacion adicional nodos atacantes falsos en el registro del sistema.<br>- Puede usar la línea de comando en computadoras modulares (escriba \"man\" para obtener una lista).",
						"Maestro"		= "La gente probablemente este empezando a preguntarse si usted mismo podria ser una computadora. El codigo de computadora es su primer idioma; se relaciona con las IA tan facilmente (probablemente mas facilmente que) con los organicos. Podria construir una red de telecomunicaciones desde cero.")

// Category: Service

/decl/hierarchy/skill/service/botany
	ID = "botany"
	name = "Botanica"
	desc = "Describe que tan bueno es un personaje para cultivar y mantener plantas."
	levels = list( "Inexperto"			= "No sabes casi nada acerca de las plantas. Si bien puedes intentar plantar, desyerbar o cosechar, es muy probable que mates la planta en su lugar.",
						"Basico"				= "Has hecho algo de jardineria. Puedes regar, desyerbar, fertilizar, plantar, cosechar, puedes reconocer y tratar las plagas. Puede que seas un jardinero aficionado.<br>- Puedes plantar malas hierbas y plantas normales.<br>- Puedes diferenciar las malas hierbas y las plagas entre si.",
						"Entrenado"			= "Eres experto en botanica y puedes cultivar plantas para la produccion de alimentos u oxigeno. Tus plantas generalmente sobreviviran y prosperaran. Conoces los conceptos basicos de la manipulacion de genes de plantas.<br>- Puedes plantar y desherbar plantas exoticas de manera segura .<br>- Puedes operar maquinas de xenoflora. La degradacion de la muestra disminuye con el nivel de habilidad.",
						"Experto"		= "Eres botanico o agricultor, capaz de administrar granjas hidroponicas de una instalacion o realizar investigaciones botanicas. Eres experto en crear hibridos personalizados y cepas modificadas.",
						"Maestro"		= "Eres un botanico especializado. Puedes cuidar incluso las plantas mas exóticas, fragiles o peligrosas. Puedes usar maquinaria de manipulación genetica con precision y, a menudo, puedes evitar la degradacion de las muestras")

/decl/hierarchy/skill/service/cooking
	ID = "cooking"
	name = "Cocina"
	desc = "Describe la habilidad de un personaje para preparar comidas y otros bienes consumibles. Esto incluye mezclar bebidas alcoholicas."
	levels = list( "Inexperto"			= "Apenas sabes nada de cocina y te limitas a las maquinas expendedoras cuando puedes. El microondas es un dispositivo de magia negra para ti, y lo evitas cuando es posible.",
						"Basico"				= "Puedes preparar comidas sencillas y cocinar para tu familia. Cosas como espaguetis, queso a la parrilla o simples bebidas mezcladas son tu comida habitual.<br>- Puedes usar la licuadora de forma segura.",
						"Entrenado"			= "Puedes preparar la mayoria de las comidas siguiendo las instrucciones y, por lo general, salen bien. Tienes algo de experiencia en hospedaje, catering y/o servicio de bar.<br>- Puedes operar completamente los dispensadores de bebidas.",
						"Experto"		= "Puedes cocinar de forma profesional, manteniendo a todo un equipo alimentado facilmente. Tu comida es sabrosa y no tienes problemas con los platos dificiles o complicados. Se puede confiar en ti para preparar casi cualquier bebida que se sirva comunmente.",
						"Maestro"		= "No solo eres bueno cocinando y mezclando bebidas, sino que tambien puedes manejar un personal de cocina y atender eventos especiales. Puedes preparar con seguridad comidas y bebidas exoticas que serian venenosas si se prepararan incorrectamente")

// Category: Security

/decl/hierarchy/skill/security/combat
	ID = "combat"
	name = "Combate cuerpo a cuerpo"
	desc = "Esta habilidad describe tu entrenamiento en el combate cuerpo a cuerpo o en el uso de armas cuerpo a cuerpo. Si bien la experiencia en esta area es rara en la era de las armas de fuego, todavia existen expertos entre los atletas."
	levels = list( "Inexperto"			= "Puedes lanzar un golpe o una patada, pero te hara perder el equilibrio. No tienes experiencia y probablemente nunca hayas estado en una pelea cuerpo a cuerpo seria. En un pelea, podrias entrar en panico y correr, agarrar lo que sea que este cerca y golpearlo a ciegas, o (si el otro tipo es tan principiante como tu) hacer el ridiculo.<br>- Puedes desarmar, agarrar y golpear. Su probabilidad de exito depende de la diferencia de habilidad de los luchadores.<br>- La probabilidad de caerse cuando es tacleado se reduce con el nivel.",
						"Basico"				= "O tienes algo de experiencia en peleas a golpes o tienes algun entrenamiento en un arte marcial. Puedes manejarte solo si es realmente necesario, y si eres un oficial de seguridad, puedes manejar un baston aturdidor al menos lo suficientemente bien suficiente para ponerle las esposas a un criminal.",
						"Entrenado"			= "Has tenido entrenamiento de combate cuerpo a cuerpo y puedes derrotar facilmente a oponentes inexpertos. Puede que el combate cuerpo a cuerpo no sea tu especialidad y no te involucras en el más de lo necesario, pero sabes como manejarte en una pelea .<br>- Puedes parar con armas. Esto aumenta con el nivel.<br>- Puedes hacer maniobras de agarre (inmovilizar, dislocar).<br>- Puedes agarrar objetivos cuando saltas sobre ellos y no caerte, si tu especie es capaz de hacerlo.",
						"Experto"		= "Eres bueno en el combate cuerpo a cuerpo. Te has entrenado explicitamente en un arte marcial o como combatiente cuerpo a cuerpo como parte de una unidad militar o policial. Puedes usar las armas de manera competente y puedes pensar estrategicamente y rapidamente en un cuerpo a cuerpo. Estas en buena forma y pasas tiempo entrenando.",
						"Maestro"		= "Te especializas en combate cuerpo a cuerpo. Estas bien alterado en un arte marcial practico y estas en buena forma. Pasa mucho tiempo practicando. Puedes enfrentarte a casi cualquier persona, usar sobre cualquier arma, y por lo general ganar venta. Puede ser un atleta profesional o un miembro de las fuerzas especiales.")

/decl/hierarchy/skill/security/combat/get_cost(var/level)
	switch(level)
		if(SKILL_BASIC)
			return difficulty
		if(SKILL_ADEPT, SKILL_EXPERT)
			return 2*difficulty
		if(SKILL_PROF)
			return 4*difficulty
		else
			return 0

/decl/hierarchy/skill/security/weapons
	ID = "weapons"
	name = "Pericia en armas"
	desc = "Esta habilidad describe tu experiencia y conocimiento de las armas. Un nivel bajo en esta habilidad implica el conocimiento de armas simples, por ejemplo, flashes. Un nivel alto en esta habilidad implica el conocimiento de armas complejas, como granadas no configuradas, escudos antidisturbios, rifles de pulso o bombas. Un nivel bajo-medio en esta habilidad es tipico de los oficiales de seguridad, un alto nivel de esta habilidad es tipico de los agentes especiales y soldados"
	levels = list( "Inexperto"			= "Sabes como reconocer un arma cuando la ves. Puedes apuntar un arma y dispararla, aunque los resultados varian enormemente. Puede que olvides la seguridad, no puedes controlar bien el retroceso explosivo , y no tienes reflejos entrenados para pelear con armas.<br>- Podrias disparar tu arma al azar.",
						"Basico"				= "Sabes manejar armas de manera segura y te sientes comodo usando armas simples. Tu punteria es decente y, por lo general, se puede confiar en que no haras nada estupido con un arma con la que estes familiarizado, pero tu entrenamiento no lo es. Todavia no es automatico y tu pericia se degradara en situaciones de alto estres.<br>- Puedes usar armas de fuego. Su precisien y alcance dependen de tu nivel de habilidad.",
						"Entrenado"			= "Has tenido un extenso entrenamiento con armas, o has usado armas en combate. Tu punteria es mejor ahora. Estas familiarizado con la mayoria de los tipos de armas y puedes usarlas en caso de apuro. Tienes una comprension de las tacticas y puedes mantener la calma bajo fuego. Es posible que tengas experiencia militar o policial y probablemente lleves un arma en el trabajo.<br>-Tienes la oportunidad de poner en peligro automaticamente un arma cuando disparas con la intencion de lastimar.",
						"Experto"		= "Has usado armas de fuego y otras armas a distancia en situaciones de mucho estres, y tus habilidades se han vuelto automaticas. Tu punteria es buena.<br>- Automaticamente pondras en peligro un arma cuando la dispares con intencion de lastimar.< br>-Puedes realizar recargas tacticas y de velocidad. El tiempo necesario disminuye con el nivel.",
						"Maestro"		= "Eres un tirador excepcional con una variedad de armas, desde simples hasta exoticas. Usas un arma con tanta naturalidad como si fuera parte de tu propio cuerpo. Puedes ser un francotirador o un operador de fuerzas especiales de algun tipo. .<br>- Obtienes precision adicional para los rifles de francotirador.<br>- Expulsas automaticamente los proyectiles de las armas de fuego de cerrojo.")

/decl/hierarchy/skill/security/weapons/get_cost(var/level)
	switch(level)
		if(SKILL_BASIC)
			return difficulty
		if(SKILL_ADEPT)
			return 2*difficulty
		if(SKILL_EXPERT)
			return 3*difficulty
		if(SKILL_PROF)
			return 4*difficulty
		else
			return 0

/decl/hierarchy/skill/security/forensics
	ID = "forensics"
	name = "Forense"
	desc = "Describe su habilidad para realizar examenes forenses e identificar evidencia vital. No cubre habilidades analiticas y, como tal, no es el unico indicador de su habilidad de investigacion. Tenga en cuenta que para realizar una autopsia, tambien se requiere la habilidad de cirugia."
	levels = list( "Inexperto"			= "Sabes que los detectives resuelven crimenes. Puede que tengas alguna idea de que es malo contaminar la escena del crimen, pero no tienes muy claros los detalles.",
						"Basico"				= "Sabes como evitar contaminar la escena del crimen. Sabes como embolsar las pruebas sin contaminarlas indebidamente.",
						"Entrenado"			= "Esta capacitado para recolectar evidencia forense: fibras, huellas dactilares, las obras. Sabe como se realizan las autopsias y podria haber ayudado a realizar una.<br>- Puede detectar huellas dactilares mas facilmente.<br>- Ya no contaminas las pruebas.",
						"Experto"		= "Eres patologo o detective. Has visto muchos casos raros y has pasado mucho tiempo armando piezas de rompecabezas forenses, por lo que ahora eres mas rapido.<br>- Puedes observe detalles adicionales al examinar, como fibras, huellas parciales y residuos de disparos.",
						"Maestro"		= "Eres un gran nombre en la ciencia forense. Puede que seas un investigador que resolvio un caso famoso o que publicaste articulos sobre nuevos metodos forenses. De cualquier manera, si hay un rastro forense, lo encontraras, punto.<br>- Puedes notar rastros de sangre limpiada.")


/decl/hierarchy/skill/security/forensics/get_cost(var/level)
	switch(level)
		if(SKILL_BASIC, SKILL_ADEPT, SKILL_EXPERT)
			return difficulty * 2
		if(SKILL_PROF)
			return 3 * difficulty
		else
			return 0

// Category: Engineering

/decl/hierarchy/skill/engineering/construction
	ID = "construction"
	name = "Construccion"
	desc = "Tu habilidad para construir varios edificios, como paredes, pisos, mesas, etc. Ten en cuenta que construir dispositivos como APC también requiere la habilidad Electronica. Un nivel bajo de esta habilidad es tipico de los conserjes, un nivel alto de esta La habilidad es tipica de los ingenieros."
	levels = list( "Inexperto"			= "Puedes romper muebles, desmontar sillas y mesas, abrirte paso a golpes a traves de una ventana, abrir una caja o forzar una esclusa de aire sin energia electrica. Puedes reconocer y usar herramientas manuales basicas y barreras inflables, aunque no muy bien.<br>- Puedes intentar construir elementos por encima de tu nivel de habilidad, la probabilidad de exito aumenta con el nivel.",
						"Basico"				= "Puedes desmantelar o construir una pared o una ventana, redecorar una habitacion, reemplazar las baldosas del piso y las alfombras. Puedes usar un soldador de manera segura sin quemarte los ojos, y usar herramientas manuales es una segunda naturaleza para ti.<br> - Puedes construir articulos de acero, madera y plastico.<br>- Puedes examinar ciertas placas de circuito para aprender mas sobre las maquinas que se usan para construir.",
						"Entrenado"			= "Puedes construir, reparar o desmantelar la mayoria de las cosas, pero ocasionalmente cometeras errores y las cosas no saldran como esperabas.<br>- Puedes construir objetos de bronce, oro, osmio, plastiacero, platino , vidrio reforzado, arenisca, plata, deuterio, hidrogeno metalico, phoron, vidrio de phoron, tritio y uranio.<br>- Puede construir muebles.<br>- Puede construir objetos simples como lamparas, armas rudimentarias y marcos montados en la pared.<br>- Puede usar el cortador de plasma de manera segura para desconstruir estructuras.<br>- Puede examinar las maquinas para obtener mas información sobre ellas.<br>- Puede examinar las placas de circuitos de las maquinas para ver una lista de las piezas necesarias para construir esa maquina.",
						"Experto"		= "Sabes como sellar una brecha, reconstruir tuberias rotas y reparar destrosos mayores. Conoces los conceptos basicos de la ingenieria estructural.<br>- Puedes construir articulos de plastiacero de carburo de osmio, titanio, diamante y hacer complejos objetos tales como marcos de maquinas y armas.",
						"Maestro"		= "Eres un trabajador de la construccion o un ingeniero. Podrias practicamente reconstruir la instalacion o el barco desde cero, con los suministros, y eres eficiente y habil para reparar destrosos.")
	difficulty = SKILL_EASY

/decl/hierarchy/skill/engineering/electrical
	ID = "electrical"
	name = "Ingenieria Electrica"
	desc = "Esta habilidad describe su conocimiento de la electronica y la fisica subyacente. Un nivel bajo de esta habilidad implica que sabe como planear el cableado y configurar las redes electricas, un alto nivel de esta habilidad se requiere para trabajar con dispositivos electronicos complejos como circuitos o robots."
	levels = list( "Inexperto"			= "Usted sabe que los cables electricos son peligrosos y recibir descargas electricas es malo; puede ver e informar fallas electricas como cables rotos o APC que funcionan mal. Puede cambiar una bombilla y sabe como reemplace una bateria o cargar el equipo que usa normalmente.<br>- Cada vez que abre el panel de pirateria, los cables se aleatorizan.<br>- Cada vez que pulsa un cable, existe la posibilidad de pulsar uno diferente.< br>- Cada vez que cortas un cable, existe la posibilidad de que cortes o repares cables adicionales.<br>- Puedes conectar mal los dispositivos de activacion remota.",
						"Basico"				= "Puedes hacer cableado basico; puedes tender cables para paneles solares o el motor. Puedes reparar cables rotos y construir equipos electricos simples como lamparas o APC. Conoces los conceptos basicos de los circuitos y entiendes como protegerte de descarga electrica. Probablemente puedas piratear una maquina expendedora.<br>- Cada vez que abres el panel de piratería, es posible que se dupliquen algunos cables.",
						"Entrenado"			= "Puede reparar y construir equipos electricos y hacerlo con regularidad. Puede solucionar problemas de un sistema electrico y monitorear la red electrica de la instalacion. Probablemente pueda piratear una esclusa de aire.<br>- Puede piratear maquinas de manera segura.",
						"Experto"		= "Puede reparar, construir y diagnosticar cualquier dispositivo electrico con facilidad. Conoce los APC, las unidades SMES y el software de monitoreo, y desarma o piratea la mayoria de los objetos.<br>- Puede colocar el control remoto de manera segura dispositivos de activacion.<br>- Puedes examinar uno o dos cables en el panel de pirateria.",
						"Maestro"		= "Eres ingeniero electrico o equivalente. Puedes planear, actualizar y modificar equipos electricos y eres bueno para maximizar la eficiencia de tu red electrica. Puedes piratear cualquier cosa en la instalacion. Puedes lidiar con cortes de energia. y problemas electricos facil y eficientemente.<br>- Puede examinar la mayoria de los cables en el panel de hacking.")

/decl/hierarchy/skill/engineering/atmos
	ID = "atmos"
	name = "Atmosfericos"
	desc = "Describe su conocimiento sobre tuberias, distribucion de aire y dinamica de gases."
	levels = list( "Inexperto"			= "Sabes que los monitores de aire parpadean en naranja cuando el aire es malo y en rojo cuando es mortal. Sabes que una puerta cortafuegos parpadeante significa peligro al otro lado. Sabes que algunos gases son venenosos , que la presion debe mantenerse en un rango seguro y que la mayoria de las criaturas necesitan oxigeno para vivir. Puede usar un extintor de incendios o desplegar una barrera inflable.<br>- RPD puede generar tuberias al azar, la probabilidad disminuye con los niveles. < br>- No puedes volver a comprimir tuberias con el RPD.",
						"Basico"				= "Sabes como leer un monitor de aire, como usar una bomba de aire, como analizar la atmosfera en un espacio y como ayudar a sellar una brecha. Puedes colocar tuberias y trabajar con tanques y botes de gasolina. Si trabaja con el motor, puede configurar el sistema de enfriamiento. Puede usar un extintor de incendios facilmente y colocar barreras inflables para permitir un acceso conveniente y una contencion hermetica de brechas.<br>- Puede volver a comprimir las tuberias con el RPD.",
						"Entrenado"			= "Puedes hacer funcionar el sistema atmosferico. Sabes como controlar la calidad del aire en toda la instalación, detectar problemas y solucionarlos. Estas capacitado para hacer frente a incendios, brechas y fugas de gas, y puedes tener exotraje o entrenamiento con equipo contra incendios.<br>- Puedes usar el RPD de forma segura.",
						"Experto"		= "Su experiencia atmosferica le permite encontrar, diagnosticar y reparar infracciones de manera eficiente. Puede administrar sistemas atmosfericos complejos sin temor a cometer errores y es competente con todos los equipos de monitoreo y bombeo a su disposicion.<br>- Puede dispensar una mayor selección de tuberias del RPD.",
						"Maestro"		= "Eres un especialista en atmosfera. Supervisas, modificas y optimizas el sistema atmosferico de la instalacion, y puedes hacer frente a emergencias de forma rapida y sencilla. Puedes modificar los sistemas atmosfericos para que hagan practicamente lo que quieras. Puedes manejan facilmente un incendio o una brecha, y son competentes para asegurar un area y rescatar a civiles, pero es igualmente probable que simplemente hayan evitado que suceda en primer lugar.")

/decl/hierarchy/skill/engineering/engines
	ID = "engines"
	name = "Motores"
	desc = "Describe su conocimiento de los diversos tipos de motores comunes en las estaciones espaciales, como PACMAN, singularidad, supermateria o motor RUST."
	levels = list( "Inexperto"			= "Sabes que \"delaminacion\" es algo malo y que debes alejarte de la singularidad. Sabe que el motor proporciona potencia, pero no tiene claro los detalles. Si intentara configurar el motor, necesitaria que alguien le explicara todos los detalles, e incluso entonces, probablemente cometeria errores mortales.<br>- Puede leer las lecturas del monitor SM con un error del 40 %. . Esto disminuye con el nivel.",
						"Basico"				= "Conoce los principios teoricos basicos del funcionamiento del motor. Puede intentar configurar el motor usted mismo, pero es probable que necesite ayuda y supervision; de lo contrario, es probable que cometa errores. Es totalmente capaz de ejecutar un generador tipo PACMAN.",
						"Entrenado"			= "Puedes configurar el motor y probablemente no lo estropees demasiado. Sabes como protegerte de la radiacion en la sala de maquinas. Puedes leer los monitores del motor y mantener el motor en marcha. El mal funcionamiento del motor puede dejarte perplejo, pero probablemente puedas averiguar como solucionarlo... esperemos que lo hagas lo suficientemente rapido para evitar destrosos graves.<br>- Puedes leer completamente las lecturas del monitor SM.",
						"Experto"		= "Tiene mucha experiencia con motores y puede configurarlos de manera rapida y confiable. Esta familiarizado con otros tipos de motores ademas del que trabaja.<br>- Puede examinar el SM directamente para comprobar su integridad.",
						"Maestro"		= "Tu motor es tu bebe y conoces cada detalle de su funcionamiento. Puedes optimizar el motor y probablemente tengas tu propia configuracion personalizada favorita. Podrias construir un motor desde cero. Cuando las cosas van mal, sabe exactamente lo que sucedio y como solucionar el problema. Puede manejar singularidades y supermateria de manera segura.<br>- Puede examinar el SM directamente para obtener un numero aproximado de su EER.")
	difficulty = SKILL_HARD

// Category: Research

/decl/hierarchy/skill/research/devices
	ID = "devices"
	name = "Dispositivos complejos"
	desc = "Describe la capacidad de ensamblar dispositivos complejos, como computadoras, circuitos, impresoras, robots o ensamblajes de tanques de gasolina (bombas). Tenga en cuenta que si un dispositivo requiere electronica o programacion, esas habilidades también se requieren ademas de esta habilidad."
	levels = list( "Inexperto"			= "Sabes como usar la tecnologia que estaba presente en cualquier sociedad en la que creciste. Sabes como saber cuando algo funciona mal, pero tienes que llamar al soporte tecnico para que lo arreglen.",
						"Basico"				= "Usas y reparas equipos de alta tecnologia en el curso de tu trabajo diario. Puedes solucionar problemas simples y sabes como usar una impresora de circuitos o un torno automatico. Puedes construir robots simples como cleanbots y medibots.",
						"Entrenado"			= "Puedes construir o reparar un exotraje o un chasis de cyborg, usar un protolathe y un analizador destructivo, y construir protesis. Puedes transferir de forma segura un MMI o un posibrain a un chasis de cyborg.<br>- Puedes unir miembros roboticos . Su velocidad aumenta con el nivel.<br>- Puedes realizar procedimientos ciberneticos si tienes la habilidad de Anatomia entrenada.",
						"Experto"		= "Tiene mucha experiencia en la construccion o ingenieria inversa de dispositivos complejos. Su uso de los tornos y los analizadores destructivos es eficiente y metodico. Puede crear artilugios a pedido y probablemente vender esos dispositivos con una ganancia.",
						"Maestro"		= "Eres inventor o investigador. Puedes crear, construir y modificar equipos que la mayoria de la gente ni siquiera sabe que existen. Estas en casa en el laboratorio y el taller, nunca has conocido un aparato que no pudieras desarmar, volver a armar y replicar.")

/decl/hierarchy/skill/research/science
	ID = "science"
	name = "Ciencia"
	desc = "Tu experiencia y conocimiento con metodos y procesos cientificos."
	levels = list( "Inexperto"			= "Sabes lo que es la ciencia y probablemente tengas una vaga idea del metodo cientifico de tus clases de ciencias de la escuela secundaria.",
						"Basico"				= "Te mantienes al día con los descubrimientos cientificos. Conoces un poco sobre la mayoria de los campos de investigacion. Has aprendido habilidades basicas de laboratorio. Puede que leas sobre ciencia como pasatiempo o que estes trabajando en un campo relacionado con la ciencia y has aprendido sobre ciencia de esa manera. Podrias planear un experimento simple.<br>- Puedes determinar la presencia de flora, fauna y una atmosfera al escanear exoplanetas.",
						"Entrenado"			= "Eres un cientifico, quizas un estudiante de posgrado o un investigador de posgrado. Puedes planear un experimento, analizar tus resultados, publicar tus datos e integrar lo que has aprendido con la investigacion de otros cientificos. Tus habilidades son confiables y sabes como encontrar la informacion que necesita cuando investigas un nuevo tema cientifico. Puede diseccionar xenofauna exotica sin muchos problemas.<br>- Puede determinar la composicion de una atmosfera al escanear exoplanetas.<br>- Puedes determinar la cantidad de estructuras artificiales al escanear exoplanetas.<br>- Puedes realizar con rxito cirugias en limos.",
						"Experto"		= "Eres un investigador junior. Puede formular sus propias preguntas, usar las herramientas disponibles para probar sus hipotesis e investigar fenomenos completamente nuevos. Es probable que tenga un historial de exito en la publicacion de sus conclusiones y la captacion de fondos.",
						"Maestro"		= "Usted es un investigador profesional y ha realizado varios descubrimientos nuevos en su campo. Sus experimentos estan bien planeados. Se le conoce como una autoridad en su especialidad y sus articulos aparecen a menudo en revistas prestigiosas. Puede ser coordinar los esfuerzos de investigacion de un equipo de cientificos, y probablemente sepa como hacer que sus hallazgos sean atractivos para los inversores.")

// Category: Medical

/decl/hierarchy/skill/medical/medical
	ID = "medical"
	name = "Medicina"
	desc = "Abarca una comprension del cuerpo humano y la medicina. En un nivel bajo, esta habilidad brinda una comprension basica de la aplicacion de tipos comunes de medicina y una comprension aproximada de dispositivos medicos como el analizador de salud. En un nivel alto, esta habilidad otorga el conocimiento exacto de todos los medicamentos disponibles en la instalacion, asi como la capacidad de utilizar dispositivos medicos complejos como el escaner corporal o el espectrometro de masas."
	levels = list( "Inexperto"			= "Conoce primeros auxilios, como aplicar un vendaje o ungüento a una lesion. Puede usar un autoinyector para uso civil, probablemente leyendo las instrucciones impresas en el. Puede saber cuando alguien esta gravemente herido y necesita un medico, puede ver si alguien tiene un hueso gravemente roto, si tiene problemas para respirar o si esta inconsciente. Es posible que tenga problemas para diferenciar entre inconsciente y muerto a distancia.<br>- Puede use suministros de primeros auxilios que se encuentran en kits y bolsas, incluidos los autoinyectores.",
						"Basico"				= "Ha tomado un curso de enfermeria o EMT. Puede detener el sangrado, hacer RCP, aplicar una ferula, tomar el pulso de alguien, aplicar tratamientos para traumatismos y quemaduras, y leer un escaner de salud portatil. Probablemente sepa que Dylovene ayuda envenenamiento y Dexalin ayuda a las personas con problemas respiratorios; puede usar una jeringa o comenzar una via intravenosa. Le han informado sobre los sintomas de emergencias comunes como un pulmon perforado, apendicitis, intoxicacion por alcohol o huesos rotos, y aunque no puede tratarlos, sabe que necesitan la atencion de un medico. Puede reconocer la mayoria de las emergencias como emergencias, estabilizar y transportar a un paciente de manera segura.<br>- Puede operar completamente desfibriladores, analizadores de salud, goteros intravenosos y jeringas.<br>- Puedes comprender la mayor parte de la lectura de un Body Scanner.",
						"Entrenado"			= "Eres un EMT experimentado, una enfermera experimentada o un medico residente. Sabes como tratar la mayoria de las enfermedades y lesiones, aunque las enfermedades exoticas y las lesiones inusuales aun pueden desconcertarte. Probablemente hayas comenzado a especializarte en algunas sub -campo de la medicina. En emergencias, puede pensar lo suficientemente rapido para mantener con vida a sus pacientes, e incluso cuando no puede tratar a un paciente, sabe como encontrar a alguien que pueda. Puede usar un escaner de cuerpo completo, y saber que algo anda mal con un paciente con un parasito alienigena o un barrenador cortical.<br>- Puede operar Sleepers y Body Scanners por completo.<br>- Puede aplicar ferulas sin fallar.<br>- Puede realizar pasos de cirugia simples si tener habilidad de anatomia experimentada.",
						"Experto"		= "Usted es un enfermero o paramedico supervisor, o un medico practicante. Sabe como usar todos los dispositivos medicos disponibles para tratar a un paciente. Su profundo conocimiento del cuerpo y los medicamentos le permitiran diagnosticar y llegar a un curso de tratamiento para la mayoria de las dolencias. Puede realizar un escaneo de cuerpo completo a fondo y encontrar informacion importante.<br>- Puede realizar todos los pasos de la cirugia de manera segura si tiene la habilidad de Anatomia experimentada.",
						"Maestro"		= "Eres un medico experimentado o un enfermero experto o EMT. Has visto casi todo lo que hay que ver cuando se trata de lesiones y enfermedades e incluso cuando se trata de algo que no has visto, puedes aplicar su amplia base de conocimientos para armar un tratamiento. En un apuro, puede hacer casi cualquier tarea relacionada con la medicina, pero su especialidad, cualquiera que sea, es donde realmente brilla.")

/decl/hierarchy/skill/medical/anatomy
	ID = "anatomy"
	name = "Anatomia"
	desc = "Te da una vision detallada del cuerpo humano. Se requiere una gran habilidad en esto para realizar una cirugia. Esta habilidad tambien puede ayudar a examinar la biologia alienígena."
	levels = list( "Inexperto"			= "Sabes que son los organos, los huesos y demas, y sabes aproximadamente donde estan. Sabes que alguien que esta gravemente herido o enfermo puede necesitar cirugia.",
						"Basico"				= "Has tomado una clase de anatomia y has pasado al menos un tiempo hurgando en el interior de personas reales. Sabes donde esta cada cosa, mas o menos. Podrias ayudar en una cirugia, si tienes las habilidades medicas requeridas . Si tiene el conocimiento forense, podria realizar una autopsia. Si realmente tuviera que hacerlo, probablemente podria realizar una cirugia basica como una apendicectomia, pero aun no es un cirujano calificado y realmente no deberia, no a menos que sea una emergencia. Si eres xenobiologo, sabes como sacar nucleos de baba.",
						"Entrenado"			= "Tiene cierta formacion en anatomia. El diagnostico de huesos rotos, ligamentos lastimados, heridas de metralla y otros traumatismos es sencillo para usted. Puede entablillar extremidades con muchas posibilidades de exito, operar un desfibrilador de manera competente y realizar bien la RCP . La cirugia todavia esta fuera de tu entrenamiento.<br>- Puedes hacer cirugía (también requiere la habilidad de Medicina entrenada), pero es muy probable que falles en cada paso. Su velocidad aumenta con el nivel.<br>- Puedes realizar procedimientos ciberneticos si tienes la habilidad Dispositivos complejos entrenados.",
						"Experto"		= "Usted es un residente de cirugia o un medico experimentado. Puede reparar huesos rotos, reparar un pulmon lastimados, reparar un higado o extirpar un apendice sin problemas. Pero las cirugias complicadas, con un paciente inestable o la manipulación delicada de organos vitales como el corazon y el cerebro, estan al limite de tu capacidad y prefieres dejarlos en manos de cirujanos especializados. Puedes reconocer cuando la anatomia de alguien es notablemente inusual. Estas capacitado para trabajar con varias especies, pero probablemente eres mejor en cirugia en tu propia especie.<br>- Puedes hacer todos los pasos de la cirugia de manera segura, si tambien tienes la habilidad de Medicina experimentada.",
						"Maestro"		= "Usted es un cirujano experimentado. Puede manejar cualquier cosa que ruede, empuje o arrastren al quirofano, puede mantener a un paciente con vida y estable, incluso si no hay nadie que lo ayude. Puede manejar traumatismos graves o fallos multiorganicos, reparar traumatismo cerebrales y realizar cirugias cardiacas. A estas alturas, probablemente ya se haya especializado en un campo, donde puede haber hecho nuevas contribuciones a la tecnica quirurgica. Puede detectar incluso variaciones en la anatomia de un paciente. --incluso un changeling probablemente no pasaria desapercibido, siempre y cuando pudieras colocar uno en la mesa de operaciones.<br>- Se reduce la sancion por operar en superficies de operacion inadecuadas.")

/decl/hierarchy/skill/medical/chemistry
	ID = "chemistry"
	name = "Quimica"
	desc = "Experiencia con la mezcla de productos quimicos y comprension de cual sera el efecto. Esto no cubre la comprension del efecto de los productos quimicos en el cuerpo humano, por lo que tambien se requiere la habilidad medica para los quimicos medicos."
	levels = list( "Inexperto"			= "Sabes que los quimicos trabajan con quimicos; sabes que pueden hacer medicinas, venenos o quimicos utiles. Probablemente sepas que es un elemento y tengas una vaga idea de lo que es una reaccion quimica alguna clase de quimica en tus dias de escuela secundaria.",
						"Basico"				= "Puedes fabricar productos quimicos o medicamentos basicos, como limpiadores de espacios o antitoxinas. Tienes algun entrenamiento en seguridad y no volaras el laboratorio... probablemente.<br>- Puedes hacerlo con seguridad usa el molinillo industrial pero pierde algunos ingredientes. Su cantidad disminuye con el nivel de habilidad.",
						"Entrenado"			= "Puede medir con precision los reactivos, moler polvos y realizar reacciones quimicas. Es posible que aun pierda algun producto de vez en cuando, pero es poco probable que se ponga en peligro a usted mismo o a quienes lo rodean.<br>- Puede operar completamente el dispensador quimico.",
						"Experto"		= "Usted trabaja como quimico, o bien es medico con formacion en quimica. Si es investigador quimico, puede crear la mayoria de los productos quimicos utiles; si es farmaceutico, puede fabricar la mayoria de los medicamentos. En este etapa, estas trabajando sobre todo segun las reglas. Puedes convertir tus productos quimicos en armas haciendo granadas, bombas de humo y dispositivos similares.<br>- Puedes examinar los contenedores retenidos en busca de reactivos escaneables.",
						"Maestro"		= "Eres un especialista en quimica o productos farmaceuticos; eres un investigador medico o un quimico profesional. Puedes crear mezclas personalizadas y preparar facilmente incluso los medicamentos mas complicados. Entiendes como interactuan tus productos farmaceuticos con los cuerpos de tus pacientes. Tu creaciones son al menos una nueva innovacion quimica.<br>- Puede examinar los contenedores retenidos para ver todos sus reactivos.")
