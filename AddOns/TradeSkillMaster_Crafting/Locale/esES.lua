-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Crafting - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_crafting.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Crafting Locale - esES
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Crafting/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Crafting", "esES")
if not L then return end

L["All"] = "Todo"
L["Are you sure you want to reset all material prices to the default value?"] = "¿Estás seguro que quieres restaurar todos los precios de material al valor por defecto?" -- Needs review
L["Ask Later"] = "Preguntar después" -- Needs review
L["Auction House"] = "Casa de Subastas "
L["Available Sources"] = "Fuentes disponibles" -- Needs review
L["Buy Vendor Items"] = "Comprar objetos al vendedor" -- Needs review
L["Characters (Bags/Bank/AH/Mail) to Ignore:"] = "Personajes (Bolsas/Banco/Subasta/Correo) para Ignorar:" -- Needs review
L["Clear Filters"] = "Borrar Filtros" -- Needs review
L["Clear Queue"] = "Borrar Cola"
L["Click Start Gathering"] = "Clic para empezar a recolectar" -- Needs review
L["Collect Mail"] = "Recoger correo" -- Needs review
L["Cost"] = "Coste" -- Needs review
L["Could not get link for profession."] = "No se puede obtener el enlace para la profesión" -- Needs review
L["Crafting Cost"] = "Coste de Fabricación" -- Needs review
L["Crafting Material Cost"] = "Coste de Materiales de Fabricación" -- Needs review
L["Crafting operations contain settings for restocking the items in a group. Type the name of the new operation into the box below and hit 'enter' to create a new Crafting operation."] = "Las operaciones de fabricación contienen opciones para reponer los objetos en un grupo. Escribe el nombre de la nueva operación en la caja de abajo y pulsa 'intro' para crear una nueva operación de fabricación." -- Needs review
L["Crafting will not queue any items affected by this operation with a profit below this value. As an example, a min profit of 'max(10g, 10% crafting)' would ensure atleast a 10g and 10% profit."] = "La fabricación no encolará ningún objeto afectado por esta operación con un beneficio por debajo de este valor. Como ejemplo, un min beneficio de 'max(10g, 10% crafting)' aseguraría al menos 10g y 10% del beneficio." -- Needs review
L["Craft Next"] = "Fabricar Siguiente" -- Needs review
L["Craft Price Method"] = "Método de precio para Fabricar" -- Needs review
L["Craft Queue"] = "Cola de fabricación" -- Needs review
L["Create Profession Groups"] = "Crear Grupos de Profesión" -- Needs review
L["Custom Price"] = "Precio personalizado" -- Needs review
L["Custom Price for this item."] = "Precio personalizado para este objeto." -- Needs review
L["Custom Price per Item"] = "Precio personalizado por objeto" -- Needs review
L["Default Craft Price Method"] = "Método de precio para fabricación por defecto" -- Needs review
L["Default Material Cost Method"] = "Método de coste por material por defecto" -- Needs review
L["Default Price"] = "Precio por defecto" -- Needs review
L["Default Price Settings"] = "Opciones de Precio por defecto" -- Needs review
L["Enchant Vellum"] = "Vitela de encantamiento" -- Needs review
L["Error creating operation. Operation with name '%s' already exists."] = "Error creando la operación. La operación con el nombre '%s' ya existe." -- Needs review
L[ [=[Estimated Cost: %s
Estimated Profit: %s]=] ] = [=[Coste estimado: %s
Beneficio estimado: %s]=] -- Needs review
L["Exclude Crafts with a Cooldown from Craft Cost"] = "Excluir productos con un tiempo de reutilización del coste de fabricación" -- Needs review
L["Filters >>"] = "Filtros >>" -- Needs review
L["First select a crafter"] = "Primero selecciona un fabricante" -- Needs review
L["Gather"] = "Recolección" -- Needs review
L["Gather All Professions by Default if Only One Crafter"] = "Recolecciona todas las profesiones por defecto si solo hay un fabricante" -- Needs review
L["Gathering"] = "Recolección" -- Needs review
L["Gathering Crafting Mats"] = "Recolecciona Materiales de fabricación" -- Needs review
L["Gather Items"] = "Recolecciona objetos" -- Needs review
L["General"] = "General" -- Needs review
L["General Settings"] = "Opciones Generales" -- Needs review
L["Give the new operation a name. A descriptive name will help you find this operation later."] = "Dar a la nueva operación un nombre. Un nombre descriptivo será de ayuda para encontrar la operación más tarde." -- Needs review
L["Guilds (Guild Banks) to Ignore:"] = "Hermandad (Banco de Hermandad) para ignorar:" -- Needs review
L["Here you can view and adjust how Crafting is calculating the price for this material."] = "Aquí puedes ver y ajustar como la fabricación está calculandose por el precio de este material." -- Needs review
L["<< Hide Queue"] = "<< Ocultar cola" -- Needs review
L["If checked, Crafting will never try and craft inks as intermediate crafts."] = "Si está seleccionado, la fabricación nunca será intentada y fabricadas tanto las tintas como las fabricaciones intermedias." -- Needs review
L["If checked, if there is more than one way to craft the item then the craft cost will exclude any craft with a daily cooldown when calculating the lowest craft cost."] = "Si está seleccionada, si hay más de una manera de fabricar el objeto entonces los costes de fabricación serán excluidos de cualquier fabricación con un tiempo de reutilización diario cuando se esté calculando el coste de fabricación menor." -- Needs review
L["If checked, if there is only one crafter for the craft queue clicking gather will gather for all professions for that crafter"] = "Si está seleccionado, si sólo hay un fabricante para la cola de fabricación haciendo clic se recolectará para todas las profesiones para ese fabricante." -- Needs review
L["If checked, the crafting cost of items will be shown in the tooltip for the item."] = "Si se selecciona, el coste de fabricación de los objetos será mostrado en los cuadros de ayuda del objeto." -- Needs review
L["If checked, the material cost of items will be shown in the tooltip for the item."] = "Si está seleccionado, el coste de material de los objetos será mostrado en el cuadro de ayuda de el objeto." -- Needs review
L["If checked, when the TSM_Crafting frame is shown (when you open a profession), the default profession UI will also be shown."] = "Si está seleccionado, cuando la ventana TSM_Crafting será mostrado (cuando tu abre una profesión), por defecto la UI de profesión también debe ser mostrado." -- Needs review
L["Inventory Settings"] = "Opciones de Inventario"
L["Item Name"] = "Nombre de Objeto" -- Needs review
L["Items will only be added to the queue if the number being added is greater than this number. This is useful if you don't want to bother with crafting singles for example."] = "Los objetos sólo serán añadidos a la cola si el número introducido es mayor que este número. Esto es útil si no quieres preocuparte por fabricar individualmente por ejemplo." -- Needs review
L["Item Value"] = "Valor de objeto" -- Needs review
L["Left-Click|r to add this craft to the queue."] = "Clic izquierdo|r para añadir esta fabricación a la cola." -- Needs review
L["Link"] = "Enlace" -- Needs review
L["Mailing Craft Mats to %s"] = "Materiales de fabricación enviados a %s" -- Needs review
L["Mail Items"] = "Enviar objetos" -- Needs review
L["Mat Cost"] = "Coste de Material" -- Needs review
L["Material Cost Options"] = "Opciones de Coste de Material" -- Needs review
L["Material Name"] = "Nombre de Material" -- Needs review
L["Materials:"] = "Materiales:" -- Needs review
L["Mat Price"] = "Precio de material" -- Needs review
L["Max Restock Quantity"] = "Max Restock"
L["Minimum Profit"] = "Beneficio Mínimo" -- Needs review
L["Min Restock Quantity"] = "Min Restock"
L["Name"] = "Nombre"
L["Need"] = "Necesitas "
L["Needed Mats at Current Source"] = "Materiales necesario en la fuente actual" -- Needs review
L["Never Queue Inks as Sub-Craftings"] = "Nunca encolar tintas como Subfabricaciones" -- Needs review
L["New Operation"] = "Nueva operación" -- Needs review
L["<None>"] = "<Ninguno>" -- Needs review
L["No Thanks"] = "No gracias" -- Needs review
L["Nothing To Gather"] = "Nada que recolectar" -- Needs review
L["Nothing to Mail"] = "Nada que enviar" -- Needs review
L["Now select your profession(s)"] = "Ahora selecciona tu(s) profesión(es)" -- Needs review
L["Number Owned"] = "Número en propiedad" -- Needs review
L["Opens the Crafting window to the first profession."] = "Abre la ventana de fabricación de la primera profesión" -- Needs review
L["Operation Name"] = "Nombre de Operación" -- Needs review
L["Operations"] = "Operaciones" -- Needs review
L["Options"] = "Opciones" -- Needs review
L["Override Default Craft Price Method"] = "Sobreescribir el Método de Precio de Fabricación por defecto" -- Needs review
L["Percent to subtract from buyout when calculating profits (5% will compensate for AH cut)."] = "Porcentaje para sustraer de la compra cuando se calculan beneficios (5% compensará el impuesto de la casa de subastas)." -- Needs review
L["Please switch to the Shopping Tab to perform the gathering search."] = "Por favor cambia a la Pestaña de Compras para realizar la búsqueda de recolección." -- Needs review
L["Price:"] = "Precio:" -- Needs review
L["Price Settings"] = "Opciones de Precio:"
L["Price Source Filter"] = "Filtro de fuente de precio" -- Needs review
L["Profession data not found for %s on %s. Logging into this player and opening the profression may solve this issue."] = "Datos de profesión no se encuentran para %s en %s. Logueando en el personaje y abriendo la profesión puede resolverse este problema." -- Needs review
L["Profession Filter"] = "Filtro de profesión" -- Needs review
L["Professions"] = "Profesiones" -- Needs review
L["Professions Used In"] = "Profesiones en uso" -- Needs review
L["Profit"] = "Beneficio"
L["Profit Deduction"] = "Beneficio deducido" -- Needs review
L["Profit (Total Profit):"] = "Beneficio (Beneficio Total):" -- Needs review
L["Queue"] = "Cola" -- Needs review
L["Relationships"] = "Relaciones" -- Needs review
L["Reset All Custom Prices to Default"] = "Restaura Todos los precios personalizados por defecto" -- Needs review
L["Reset all Custom Prices to Default Price Source."] = "Restaura Todos los precioes personalizado por defecto de la fuente de precios" -- Needs review
L["Resets the material price for this item to the defualt value."] = "Restaura el precio de material para este objeto al valor por defecto." -- Needs review
L["Reset to Default"] = "Restaura por defecto" -- Needs review
L["Restocking to a max of %d (min of %d) with a min profit."] = "Restaurando al max de %d (min de %d) con un mín beneficio." -- Needs review
L["Restocking to a max of %d (min of %d) with no min profit."] = "Restaurando al max d %d (min de %d) sin beneficio mín." -- Needs review
L["Restock Quantity Settings"] = "Restaura las opciones de cantidad" -- Needs review
L["Restock Selected Groups"] = "Restaura los grupos seleccionados" -- Needs review
L["Restock Settings"] = "Restaura opciones" -- Needs review
L["Right-Click|r to subtract this craft from the queue."] = "Clic derecho|r para extraer esta fabricación de la cola." -- Needs review
L["%s Avail"] = "%s Utilidad" -- Needs review
L["Search"] = "Buscar" -- Needs review
L["Search for Mats"] = "Buscar materiales" -- Needs review
L["Select Crafter"] = "Seleccionar fabricante" -- Needs review
L["Select one of your characters' professions to browse."] = "Selecionar uno de las profesiones de tus personajes para explorar." -- Needs review
L["Set Minimum Profit"] = "Selecciona beneficio mínimo" -- Needs review
L["Shift-Left-Click|r to queue all you can craft."] = "Mayúsculas-Clic izquierdo|r para encolar todo lo que puedes fabricar" -- Needs review
L["Shift-Right-Click|r to remove all from queue."] = "Mayúsculas-Clic derecho|r para borrar todas las colas." -- Needs review
L["Show Crafting Cost in Tooltip"] = "Mostrar el Coste de fabricación en el cuadro de ayuda" -- Needs review
L["Show Default Profession Frame"] = "Mostrar la ventana de profesiones por defecto" -- Needs review
L["Show Material Cost in Tooltip"] = "Mostrar coste de material en el cuadro de ayuda." -- Needs review
L["Show Queue >>"] = "Mostrar cola >>" -- Needs review
L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' es una operación no válida! El Min de reposición de %d es mayor del máx de reposición de %d." -- Needs review
L["%s (%s profit)"] = "%s (%s beneficio)" -- Needs review
L["Stage %d"] = "Fase %d" -- Needs review
L["Start Gathering"] = "Empezar la recolección" -- Needs review
L["Stop Gathering"] = "Parar la recolección" -- Needs review
L["This is the default method Crafting will use for determining craft prices."] = "Este es el método de fabricación por defecto que será usado para determinar los precios de fabricación." -- Needs review
L["This is the default method Crafting will use for determining material cost."] = "Este es el método de fabricación por defecto que se usará para determinar los costes de material." -- Needs review
L["Total"] = "Total" -- Needs review
L["TSM Groups"] = "Grupos TSM" -- Needs review
L["Vendor"] = "Vendedor" -- Needs review
L["Visit Bank"] = "Visita el banco" -- Needs review
L["Visit Guild Bank"] = "Visita el banco de hermandad" -- Needs review
L["Visit Vendor"] = "Visita al vendedor" -- Needs review
L["Warning: The min restock quantity must be lower than the max restock quantity."] = "Advertencia: La cantidad mínima de reposición debe ser menor que la cantidad máxima de reposición." -- Needs review
L["When you click on the \"Restock Queue\" button enough of each craft will be queued so that you have this maximum number on hand. For example, if you have 2 of item X on hand and you set this to 4, 2 more will be added to the craft queue."] = "Cuando haces clic en el botón \"Restaurar cola\" lo suficiente de cada fabricación será encolado así que tienes el número máximo en el inventario. Por ejemplo, si tienes 2 del objeto X en el inventario y seleccionas este a 4, 2 más serán añadidos a la cola de fabricación." -- Needs review
L["Would you like to automatically create some TradeSkillMaster groups for this profession?"] = "¿Quieres crear automáticamente algún grupo TradeSkillMaster para esta profesión?" -- Needs review
L["You can click on one of the rows of the scrolling table below to view or adjust how the price of a material is calculated."] = "Puedes hacer clic en una de las filas la tabla despalazada de abajo para ver o ajustar como se ha calculado el precio de un material." -- Needs review
