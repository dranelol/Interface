-- Version : French (by Arthur Caranta) 
-- Last Update : 14/10/2007
if ( GetLocale() == "esES" ) then
LootFilter.Locale = {
		-- weird looking keys for quality because we need to sort on them
		qualities= {
			["QUaGris"]= 0,
			["QUbBlanco"]= 1,
			["QUcVerde"]= 2,
			["QUdAzul"]= 3,
			["QUeMorado"]= 4,
			["QUfNaranja"]= 5,
			["QUgRojo"]= 6,
			["QUhTan"] = 7,
			["QUhMisi\195\179n"]= -1 
		},
		types = {
        ["Armadura"] = "Armadura",
		["Consumible"] = "Consumible",
		["Contenedor"] = "Contenedor",
		["Gema"] = "Gema",
		["Llave"] = "Llave",
		["Miscel\195\161nea"] = "Miscel\195\161nea",
		["Proyectil"] = "Proyectil",
		["Misi\195\179n"] = "Misi\195\179n",
		["Carcaj"] = "Carcaj",		
		["Receta"] = "Receta",
		["Objeto comerciable"] = "Objeto comerciable",
		["Armas"] = "Armas",
		},
		radioButtonsText= {
			["QUaGris"]= "Pobre (Gris)",
			["QUbBlanco"]= "Com\195\186n (Blanco)",
			["QUcVerde"]= "No com\195\186n  (Verde)",
			["QUdAzul"]= "Raro (Azul)",
			["QUeMorado"]= "Epico (Morado)",
			["QUfNaranja"]= "Legendario (Naranja)",
			["QUgRojo"]= "Artefacto (Rojo)",
			["QUhTan"] = "Heirloom (Tan)",
			["QUhMisi\195\179n"]= "Misi\195\179n",

			-- Armadura
			["TYArmaduraMiscel\195\161neo"]= "Miscel\195\161neo",
			["TYArmaduraTela"]= "Tela",
			["TYArmaduraCuero"]= "Cuero",
			["TYArmaduraMalla"]= "Malla",
			["TYArmaduraPlacas"]= "Placas",
			["TYArmaduraEscudos"]= "Escudos",
			["TYArmaduraTratados"]= "Tratados",
			["TYArmaduraIdolos"]= "Idolos",
			["TYArmaduraT\195\179tems"]= "T\195\179tems",
			
			-- Consumible
			["TYConsumibleComida y bebida"]= "Comida y bebida",
			["TYConsumiblePoci\195\179n"]= "Poci\195\179n",
			["TYConsumibleElixir"]= "Elixir",
			["TYConsumibleFrasco"]= "Frasco",
			["TYConsumibleVenda"]= "Venda",
			["TYConsumibleMejora de objetos"]= "Mejora de objetos",
			["TYConsumiblePergamino"]= "Pergamino",
			["TYConsumibleOtros"]= "Otros",
			["TYConsumibleConsumible"]= "Consumible",
			
			-- Contenedor
			["TYContenedorBolsa"]= "Bolsa",
			["TYContenedorBolsa de encantamiento"]= "Bolsa de encantamiento",
			["TYContenedorBolsa de ingenier\195\173a"]= "Bolsa de ingenier\195\173a",
			["TYContenedorBolsa de gemas"]= "Bolsa de gemas",
			["TYContenedorBolsa de hierbas"]= "Bolsa de hierbas",
			["TYContenedorBolsa de miner\195\173a"]= "Bolsa de miner\195\173a",
			["TYContenedorBolsa de almas"]= "Bolsa de almas",
			["TYContenedorBolsa de peleter\195\173a"]= "Bolsa de peleter\195\173a",
			
			
			-- Miscel\195\161nea
			["TYMiscel\195\161neaChatarra"]= "Chatarra",
			["TYMiscel\195\161neaComponente"]= "Componente",
			["TYMiscel\195\161neaMascota"]= "Mascota",
			["TYMiscel\195\161neaVacaciones"]= "Vacaciones",
			["TYMiscel\195\161neaOtros"]= "Otros",
			
			-- Gema
			["TYGemaAzul"] = "Azul",
			["TYGemaVerde"] = "Verde",
			["TYGemaNaranja"] = "Naranja",
			["TYGemaMeta"] = "Meta",
			["TYGemaCentelleante"] = "Centelleante",
			["TYGemaMorado"] = "Morado",
			["TYGemaRojo"] = "Rojo",
			["TYGemaSimple"] = "Simple",
			["TYGemaAmarillo"] = "Amarillo",
			
			
			-- Llave
			["TYLlaveLlave"]= "Llave",
			
			-- Proyectil
			["TYProyectilFlecha"]= "Flecha",
			["TYProyectilBala"]= "Bala",
			
			-- Misi\195\179n
			["TYMisi\195\179nMisi\195\179n"]= "Misi\195\179n",
			
			-- Carcaj
			["TYCarcajBolsa de munici\195\179n"]= "Bolsa de munici\195\179n",
			["TYCarcajCarcaj"]= "Carcaj",				
			
			-- Receta
			["TYRecetaAlqu\195\173mia"]= "Alqu\195\173mia",
			["TYRecetaHerrer\195\173a"]= "Herrer\195\173a",
			["TYRecetaLibro"]= "Libro",
			["TYRecetaCocina"]= "Cocina",
			["TYRecetaEncantamiento"]= "Encantamiento",
			["TYRecetaIngenier\195\173a"]= "Ingenier\195\173a",
			["TYRecetaPrimeros aux\195\173lios"]= "Primeros aux\195\173lios",
			["TYRecetaPeleter\195\173a"]= "Peleter\195\173a",
			["TYRecetaSastrer\195\173a"]= "Sastrer\195\173a",
			
			-- Armas
			["TYArmasArcos"]= "Arcos",
			["TYArmasBallestas"]= "Ballestas",
			["TYArmasDagas"]= "Dagas",
			["TYArmasArmas de fuego"]= "Armas de fuego",
			["TYArmasCa\195\177as de pescar"]= "Ca\195\177as de pescar",
			["TYArmasArmas de pu\195\177o"]= "Armas de pu\195\177o",
			["TYArmasMiscel\195\161nea"]= "Miscel\195\161nea",
			["TYArmasHachas de una mano"]= "Hachas de una mano",
			["TYArmasMazas de una mano"]= "Mazas de una mano",
			["TYArmasEspadas de una mano"]= "Espadas de una mano",
			["TYArmasArmas de asta"]= "Armas de asta",
			["TYArmasBastones"]= "Bastones",
			["TYArmasArmas arrojadizas"]= "Armas arrojadizas",
			["TYArmasHachas de dos manos"]= "Hachas de dos manos",
			["TYArmasMazas de dos manos"]= "Mazas de dos manos",
			["TYArmasEspadas de dos manos"]= "Espadas de dos manos",
			["TYArmasVaritas"]= "Varitas",
					
			-- Objeto comerciable
			["TYObjeto comerciableElemental"] = "Elemental",
			["TYObjeto comerciableTela"] = "Tela",
			["TYObjeto comerciableCuero"] = "Cuero",
			["TYObjeto comerciableMetal y piedra"] = "Metal y piedra", 
			["TYObjeto comerciableCarne"] = "Carne",
			["TYObjeto comerciableHierbas"] = "Hierbas",
			["TYObjeto comerciableEncantamiento"] = "Encantamiento", 
			["TYObjeto comerciableJoyer\195\173a"] = "Joyer\195\173a",
			["TYObjeto comerciablePiezas"]= "Piezas",
			["TYObjeto comerciableInstrumentos"]= "Instrumentos",
			["TYObjeto comerciableExplosivos"]= "Explosivos",
			["TYObjeto comerciableOtros"]= "Otros",
			["TYObjeto comerciableObjeto comerciable"]= "Objeto comerciable",
			
			
		["OPEnable"]= "Permitir Filtrado de Saqueo",
		["OPCaching"]= "Permitir Cach\195\169 de Saqueo (mantener espacio vac\195\173o)",
		["OPTooltips"]= "Ense\195\177ar Pistas",
		["OPNotifyDelete"]= "Avisar al borrar",
		["OPNotifyKeep"]= "Avisar al mantener",
		["OPNotifyNoMatch"]= "Avisar cuando no coincide ning\195\186n criterio de filtrado",
		["OPNotifyOpen"]= "Avisar al abrir",
		["OPNotifyNew"]= "Avisar de nueva versi\195\179n",
		["OPValKeep"]= "Mantener obj. que valgan + de",
		["OPValDelete"]= "Borrar obj. que valgan - de",
		["OPOpenVendor"]= "Abrir al hablar a vendedor",
		["OPAutoSell"]= "Empezar a vender autom\195\161ticamente",
		["OPNoValue"]= "Mantener objetos sin valor (conocido)", 
		["OPMarketValue"]= "Usar precios de Auctioneer en vez de los de vendedor",
		["OPBag0"]= "Mochila",
		["OPBag1"]= "Bolsa 1",
		["OPBag2"]= "Bolsa 2",
		["OPBag3"]= "Bolsa 3",
		["OPBag4"]= "Bolsa 4",
		["TYVaritas"]= "Varitas"
	},
	LocText = {
		["LTTryopen"] = "intentando abrir",
		["LTNameMatched"] = "nombre coincide",
		["LTQualMatched"] = "calidad coincide",
		["LTQuest"] = "misi\195\179n",      -- Used to match Quest Item as Quality Value
		["LTQuestItem"] = "objeto de misi\195\179n",
		["LTTypeMatched"]= "tipo coincide",
		["LTKept"] = "se queda",
		["LTNoKnownValue"] = "el objeto no tiene valor conocido",
		["LTValueHighEnough"] = "el precio ES suficientemente alto",
		["LTValueNotHighEnough"] = "el precio NO es suficientemente alto",
		["LTNoMatchingCriteria"] = "no se encontraron criterios coincidentes",
		["LTWasSold"] = "se vendi\195\179",
		["LTWasDeleted"] = "se borr\195\179",
		["LTNewVersion1"] = "Nueva versi\195\179n",
		["LTNewVersion2"] = "de Loot Filter detectada. B\195\161jala de http://www.lootfilter.com .",
		["LTAddedCosQuest"] = "A\195\177adido por misi\195\179n",
		["LTDeleteItems"] = "BORRAR objetos",
		["LTSellItems"] = "VENDER objetos",
		["LTFinishedSC"] = "Fin de Venta/Limpieza.",
		["LTNoOtherCharacterToCopySettings"] = "Ahora mismo no tienes ning\195\186n otro personaje del que copiar la configuraci\195\179n.",
		["LTTotalValue"] = "Valor total",
		["LTSessionInfo"] = "Abajo hay precios de objetos guardados durante esta sesi\195\179n.",
		["LTSessionTotal"] = "Valor total",
		["LTSessionItemTotal"] = "N\195\186mero de objetos",
		["LTSessionAverage"] = "Media / objeto",
		["LTSessionValueHour"] = "Media / hora",
		["LTNoMatchingItems"] = "No se encontraron objetos coincidentes.",
		["LTItemLowestValue"] = "objeto tiene el valor mas bajo",
		["LTVendorWinClosedWhileSelling"] = "ventana de vendedor cerrada mientras se vend\195\173a.",
		["LTTimeOutItemNotFound"] = "Se acab\195\179 el tiempo. Uno o mas de los objetos de la lista no se encontr\195\179.",
    },
		LocTooltip = {
		["LToolTip1"] = "Cualquier objeto listado aqu\195\173 no coincide con ninguna propiedad para mantenerlo. Puedes decidir vender o borrarlos autom\195\161ticamente. Utiliza May\195\186sculas-clic para a\195\177adir objeto a la lista de MANTENER.",
		["LToolTip2"] = "Selecciona esto si no te importa si el objeto tiene esta caracter\195\173stica.",
		["LToolTip3"] = "Selecciona esto si quieres MANTENER el objeto con esta caracter\195\173stica.",
		["LToolTip4"] = "Selecciona esto si quieres BORRAR el objeto con esta caracter\195\173stica.",
		["LToolTip5"] = "Los objetos que coinciden con esta lista se MANTIENEN.\n\nEscribe un nombre nuevo en una nueva l\195\173nea. Puedes a\195\177adir comentarios a un nombre con ';'. Puedes usar patrones usando primero ('#') para comparar con partes del nombre. Ejemplos:\n#(.*)Poci\195\179n$ ; Coincidir\195\161 con nombres acabados en poci\195\179n\n#(.*)Pergamino(.*) ; Coincidira con nombres que contengan 'pergamino'\nUtiliza '##' al principio para que compare con las pistas o tooltips.",
		["LToolTip6"] = "Los objetos que coinciden con esta lista se BORRAN.\n\nEscribe un nombre nuevo en una nueva l\195\173nea. Puedes a\195\177adir comentarios a un nombre con ';'. Puedes usar patrones usando primero ('#') para comparar con partes del nombre. Ejemplos:\n#(.*)Poci\195\179n$ ; Coincidir\195\161 con nombres acabados en poci\195\179n\n#(.*)Pergamino(.*) ; Coincidira con nombres que contengan 'pergamino'\nUtiliza '##' al principio para que compare con las pistas o tooltips.",
		["LToolTip7"] = "Los objetos que valen menos de esto se BORRAN.\n\nEl precio se escribe en oro. 0.1 en oro es 10 en plata.",
		["LToolTip8"] = "Los objetos que valen mas que esto se MANTIENEN.\n\nEl precio se escribe en oro. 0.1 en oro es 10 en plata.",
		["LToolTip9"] = "Escribe cuantos huecos vacios quieres mantener. Loot Filter remplazara objetos de menos valor por objetos de mayor valor si hay menos huecos libres de los indicados.",
		["LToolTip10"] = "Estos objetos no coinciden con ninguna caracter\195\173stica para mantenerlos. Puedes decidir vender o borrar estos objetos autom\195\161ticamente. Con Mayus-clic a\195\177ades un objeto a la lista MANTENER.",
        ["LToolTip11"] = "Items that match a name listed here are automatically opened. Using this on scrolls and such will not work, and generate an error.\n\nEnter a new name on a new line. You can add comments after a name using ';'. You can use patterns by prefixing the pattern with a hash ('#') to match parts of a name. Some example of patterns are:\n#(.*)Clam$ ; Match names ending in 'Clam'\n#(.*)Clam(.*) ; Match names containing 'Clam'",
		["LToolTip12"] = "Selecciona como quieres calcular el valor de los objetos (valor * n\195\186mero_de_objetos). N\195\186mero_de_objetos puede ser un solo objeto, la cantidad actual o la cantidad m\195\161xima apilable."
		},
	};
	
	--- Interface (xml) localization
LFINT_BTN_GENERAL = "General" ;
LFINT_BTN_QUALITY = "Calidad";
LFINT_BTN_TYPE = "Tipo";
LFINT_BTN_NAME = "Nombre";
LFINT_BTN_VALUE = "Precio";
LFINT_BTN_CLEAN = "Limpieza";
LFINT_BTN_OPEN = "Abrir";
LFINT_BTN_COPY = "Copiar";
LFINT_BTN_CLOSE = "Cerrar";
LFINT_BTN_DELETEITEMS = "BORRAR objetos" ;
LFINT_BTN_YESSURE = "Si, estoy seguro" ;
LFINT_BTN_COPYSETTINGS = "Copiar configuraci\195\179n";
LFINT_BTN_DELETESETTINGS = "Delete settings";


	LFINT_TXT_MOREINFO = "|n|nIf you have any questions or suggestions please visit the website at http://www.lootfilter.com|nor send an e-mail to meter@lootfilter.com .";
	LFINT_TXT_SELECTBAGS = "Selecciona las bolsas en las que quieres usar Loot Filter.";
	LFINT_TXT_ITEMKEEP = "Objetos que quieres MANTENER.";
	LFINT_TXT_ITEMDELETE = "Objetos que quieres BORRAR.";
	LFINT_TXT_INSERTNEWNAME = "Escribe un nombre nuevo en una nueva l\195\173nea.";
	LFINT_TXT_INFORMANTNEED = "Si quieres filtrar objetos por precio necesitas un addon que admita el API GetSellValue (eg. Informant, ItemPriceTooltip)." ;
	LFINT_TXT_NUMFREEBAGSLOTS = "M\195\173nimo de huecos libres:" ;
	LFINT_TXT_SELLALLNOMATCH = "Usa esto para VENDER o BORRAR todos los objetos que no coinciden con criterios de MANTENER." ;
	LFINT_TXT_AUTOOPEN = "Objetos que quieres abrir y saquear autom\195\161ticamente (ej: conchas)." ;
	LFINT_TXT_SELECTCHARCOPY = "Selecciona el personaje del que quieres copiar la configuraci\195\179n." ;
	LFINT_TXT_COPYSUCCESS = "Configuracion copiada con \195\169xito." ;
	LFINT_TXT_SELECTTYPE = "Selecciona un subtipo: ";

LFINT_TXT_SIZETOCALCULATE = "Para calcular precio usar: ";
LFINT_TXT_SIZETOCALCULATE_TEXT1 = "un solo objeto";
LFINT_TXT_SIZETOCALCULATE_TEXT2 = "cantidad actual";
LFINT_TXT_SIZETOCALCULATE_TEXT3 = "cantidad m\195\161xima apilable";


BINDING_NAME_LFINT_TXT_TOGGLE = "Toggle window";
BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";

end

