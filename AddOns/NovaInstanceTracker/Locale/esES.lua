local L = LibStub("AceLocale-3.0"):NewLocale("NovaInstanceTracker", "esES");
if (not L) then
	return;
end

L["noTimer"] = "Sin temporizador"; --No timer
L["noCurrentTimer"] = "Sin temporizador activo"; --No current timer
L["noActiveTimers"] = "Sin temporizadores activos";	--No active timers
L["second"] = "segundo"; --Second (singular).
L["seconds"] = "segundos"; --Seconds (plural).
L["minute"] = "minuto"; --Minute (singular).
L["minutes"] = "minutos"; --Minutes (plural).
L["hour"] = "hora"; --Hour (singular).
L["hours"] = "horas"; --Hours (plural).
L["day"] = "día"; --Day (singular).
L["days"] = "días"; --Days (plural).
L["secondMedium"] = "sec"; --Second (singular).
L["secondsMedium"] = "secs"; --Seconds (plural).
L["minuteMedium"] = "min"; --Minute (singular).
L["minutesMedium"] = "mins"; --Minutes (plural).
L["hourMedium"] = "hora"; --Hour (singular).
L["hoursMedium"] = "horas"; --Hours (plural).
L["dayMedium"] = "día"; --Day (singular).
L["daysMedium"] = "días"; --Days (plural).
L["secondShort"] = "s"; --Used in short timers like 1m30s (single letter only, usually the first letter of seconds).
L["minuteShort"] = "m"; --Used in short timers like 1m30s (single letter only, usually the first letter of minutes).
L["hourShort"] = "h"; --Used in short timers like 1h30m (single letter only, usually the first letter of hours).
L["dayShort"] = "d"; --Used in short timers like 1d8h (single letter only, usually the first letter of days).
L["startsIn"] = "Empieza en %s"; --"Starts in 1hour".
L["endsIn"] = "Acaba en %s"; --"Ends in 1hour".
L["versionOutOfDate"] = "Nova Instance Tracker está desactualizado, por favor actualiza en https://www.curseforge.com/wow/addons/nova-instance-tracker";
L["Options"] = "Opciones";
L["Reset Data"] = "Reiniciar datos"; --A button to Reset data.

L["Error"] = "Error";
L["delete"] = "Borrar";
L["confirmInstanceDeletion"] = "Confirmar borrado de Instancia";
L["confirmCharacterDeletion"] = "Confirmar borrado de Personaje";

-------------
---Config---
-------------
--There are 2 types of strings here, the names end in Title or Desc L["exampleTitle"] and L["exampleDesc"].
--Title must not be any longer than 21 characters (maybe less for chinese characters because they are larger).
--Desc can be any length.

---General Options---
L["generalHeaderDesc"] = "Opciones Generales";

L["chatColorTitle"] = "Color Msg Chat";
L["chatColorDesc"] = "De qué color deberían ser los msgs en el chat?";

L["resetColorsTitle"] = "Reiniciar Colores";
L["resetColorsDesc"] = "Reiniciar Colores a predeterminados.";

L["timeStampFormatTitle"] = "Formato de tiempo";
L["timeStampFormatDesc"] = "Establece que formato de tiempo se usa, 12 horas (1:23pm) o 24 horas (13:23).";

L["timeStampZoneTitle"] = "Hora Local / Hora del Servidor";
L["timeStampZoneDesc"] = "Usar la hora Local o la del Servidor para los sellos de tiempo?";

L["minimapButtonTitle"] = "Mostrar botón en el Minimapa";
L["minimapButtonDesc"] = "Mostrar el botón de NIT en el Minimapa?";

---Sounds---
L["soundsHeaderDesc"] = "Sonidos";

L["soundsTextDesc"] = "Establecer sonido a \"None\" para deshabilitar.";

L["disableAllSoundsTitle"] = "Deshabilitar Todos los sonidos";
L["disableAllSoundsDesc"] = "Deshabilita todos los sonidos de este Addon.";

L["extraSoundOptionsTitle"] = "Opciones de sonido extra";
L["extraSoundOptionsDesc"] = "Habilita esto para mostrar todos los sonidos de todos tus Addons a la vez en las listas desplegables aquí.";

L["notesHeaderDesc"] = "Algunas notas:";
L["notesDesc"] = "Este Addon hace que sea más fácil averiguar cuándo puedes acceder a más instancias, pero el sistema de bloqueo de Blizzard a veces tiene errores y puede bloquearse antes de alcanzar el límite correcto. A veces solo puedes acceder 4 por hora, pero también a veces 6 por hora.";

L["logHeaderDesc"] = "Ventana de Log";

L["openInstanceLogFrameTitle"] = "Abrir Log de Instancia";

L["logSizeTitle"] = "Cuantas Instancias se muestran en Log";
L["logSizeDesc"] = "Cuantas Instancias quieres que se muestren en el Log? Muestra un máximo de 300, muestra 100 por defecto (puedes abrir el Log con /NIT).";

L["enteredMsgTitle"] = "Msg de entrada a Instancia";
L["enteredMsgDesc"] = "Esto muestra un msg a tu ventana de chat principal cuando entras en una Instancia con un icono X para borrar la nueva Instancia de la base de datos si lo necesitas.";

L["instanceResetMsgTitle"] = "Group Instance Reset";
L["instanceResetMsgDesc"] = "Esto mostrará un msg a tu grupo o banda cuando las Instancias sean reiniciadas si eres el lider del grupo. Ejemplo: \"Cueva de los Lamentos se ha reiniciado.\"";

L["showMoneyTradedChatTitle"] = "Oro Comerciado en Chat";
L["showMoneyTradedChatDesc"] = "Mostrar en el comercio cuando das o recibes oro de alguien en la ventana de chat? (Ayuda a no perder de vista a quién le has pagado o recibido oro en los grupos de boost).";

L["instanceStatsHeaderDesc"] = "Salida de estadísticas de fin de mazmorra";

L["instanceStatsTextDesc"] = "Selecciona aquí que estadísticas se muestran al chat de tu grupo o tu ventana de chat cuando sales de mazmorra.";

L["instanceStatsOutputTitle"] = "Mostrar Estadísticas";
L["instanceStatsOutputDesc"] = "Mostrar estadísticas sobre la mazmorra cuando sales?";
			
L["instanceStatsOutputWhereTitle"] = "Donde Mostrar Estadísticas";
L["instanceStatsOutputWhereDesc"] = "Dónde quieres mostrar las estadísticas, en un chat para tí o en el chat de grupo?";

L["instanceStatsOutputMobCountTitle"] = "Mostrar recuento de Mob";
L["instanceStatsOutputMobCountDesc"] = "Mostrar cuantos mobs han sido asesinados dentro de la mazmorra?";

L["instanceStatsOutputXPTitle"] = "Mostrar XP";
L["instanceStatsOutputXPDesc"] = "Mostrar cuanta experiencia fue adquirida dentro de la mazmorra?";

L["instanceStatsOutputAverageXPTitle"] = "Mostrar Promedio XP";
L["instanceStatsOutputAverageXPDesc"] = "Mostrar promedio de XP por asesinato dentro de la mazmorra?";

L["instanceStatsOutputTimeTitle"] = "Mostrar Tiempo";
L["instanceStatsOutputTimeDesc"] = "Mostrar cuanto tiempo has empleado dentro de la mazmorra?";

L["instanceStatsOutputGoldTitle"] = "Mostrar Raw Gold";
L["instanceStatsOutputGoldDesc"] = "Mostrar cuanto raw gold fue despojado de los mobs dentro de la mazmorra?";

L["instanceStatsOutputAverageGroupLevelDesc"] = "Mostrar el promedio de nivel del grupo dentro de la mazmorra?";
L["instanceStatsOutputAverageGroupLevelTitle"] = "Mostrar Promedio de Nivel";

L["showAltsLogTitle"] = "Mostrar Alters";
L["showAltsLogDesc"] = "Mostrar alters en el Log de Instancia?";

L["timeStringTypeTitle"] = "Formato de Tiempo";
L["timeStringTypeDesc"] = "Que formato de tiempo quieres usar en el Log de Instancia?\n|cFFFFFF00Largo:|r 1 minute 30 seconds\n|cFFFFFF00Medio|r: 1 min 30 secs\n|cFFFFFF00Corto|r 1m30s";

L["showLockoutTimeTitle"] = "Mostrar Tiempo de Bloqueo";
L["showLockoutTimeDesc"] = "Esto mostrará el tiempo restante de bloqueo en el Log de Instancia para Instancias dentro de las últimas 24 horas, con esto desmarcado, mostrará la hora de entrada en su lugar como en versiones anteriores.";

L["colorsHeaderDesc"] = "Colores"

L["mergeColorTitle"] = "Color Fusión Instancias";
L["mergeColorDesc"] = "De que color debería ser el msg en el chat cuando la misma Instancia sea detectada como la última y los datos sean fusionados?";

L["detectSameInstanceTitle"] = "Detectar Misma Instancia";
L["detectSameInstanceDesc"] = "Autodetectar si reentras en la misma Instancia para que el Addon no las cuente como Instancias separadas?";

L["showStatsInRaidTitle"] = "Mostrar Estadísticas En Banda";
L["showStatsInRaidDesc"] = "Mostrar estadísticas cuando estás en Banda? Deshabilita esto para mostrar únicamente estadísticas al grupo cuando estás en un grupo de 5 jugadores (Esta opción solo funciona cuando tienes chat de grupo como tu Salida de Estadísticas).";

L["printRaidInsteadTitle"] = "Mostrar en Banda";
L["printRaidInsteadDesc"] = "Si tienes deshabilitada la opción de enviar Estadísticas al chat de Radi entonces esto lo mostrará en tu ventana de chat en su lugar para que aún puedas verlas.";

L["statsOnlyWhenActivityTitle"] = "Solo cuando hay Actividad";
L["statsOnlyWhenActivityDesc"] = "Mostrar estadísticas solo cuando haya ocurrido alguna actividad dentro de la mazmorra? Esto significa que solo si has matado algunos mobs, has ganado XP, has despojado algo de oro, etc. Esto hará que no muestre estadísticas vacías.";

L["show24HourOnlyTitle"] = "Mostrar Solo Últimas 24h";
L["show24HourOnlyDesc"] = "Mostrar únicamente las Instancias de las últimas 24 horas en el Log de Instancia?";

L["trimDataHeaderDesc"] = "Limpieza de Datos";

L["trimDataBelowLevelTitle"] = "Máximo Nivel para Eliminar";
L["trimDataBelowLevelDesc"] = "Selecciona el máximo nivel de personajes para eliminarlo de la base de datos, todos los personajes que estén en este nivel o por debajo serán eliminados.";

L["trimDataBelowLevelButtonTitle"] = "Eliminar Personajes";
L["trimDataBelowLevelButtonDesc"] = "Haz click en este botón para eliminar todos los personajes de la base de datos del Addon que estén en el nivel seleccionado o por debajo.";

L["trimDataTextDesc"] = "Eliminar múltiples personajes de la base de datos:";
L["trimDataText2Desc"] = "Eliminar un personaje de la base de datos:";

L["trimDataCharInputTitle"] = "Eliminar un Personaje";
L["trimDataCharInputDesc"] = "Escribe un personaje aquí para eliminarlo, en formato Nombre-Reino (Sensible a mayúsculas y minúsculas). Nota: Esto elimina los datos del recuento de bufos permanentemente.";

L["trimDataBelowLevelButtonConfirm"] = "Estás seguro de que quieres eliminar todos los personajes por debajo del nivel %s de la base de datos?";
L["trimDataCharInputConfirm"] = "Estás seguro de que quieres eliminar este personaje %s de la base de datos?";

L["trimDataMsg2"] = "Eliminando todos los personajes por debajo del nivel %s.";
L["trimDataMsg3"] = "Eliminado: %s.";
L["trimDataMsg4"] = "Realizado, no se han encontrado personajes.";
L["trimDataMsg5"] = "Realizado, eliminados %s personajes.";
L["trimDataMsg6"] = "Por favor, escribe un nombre de personaje válido para eliminar de la base de datos.";
L["trimDataMsg7"] = "Este nombre de personaje %s no incluye el reino. Por favor escribe Nombre-Reino.";
L["trimDataMsg8"] = "Error eliminando %s de la base de datos, personaje no encontrado (el nombre es sensible a mayúsculas y minúsculas).";
L["trimDataMsg9"] = "Eliminado %s de la base de datos.";

L["instanceFrameSelectAltMsg"] = "Selecciona el personaje que se muestra si \"Show All Alts\" está desmarcado.\nO que Alter colorear si \"Show All Alts\" está marcado.";

L["enteredDungeon"] = "Nueva Instancia %s %s, click";
L["enteredDungeon2"] = "si esto no es una nueva Instancia.";
L["enteredRaid"] = "Nueva Instancia %s, esta banda no cuenta para el bloqueo.";
L["loggedInDungeon"] = "Has iniciado sesión dentro de %s %s, si esto no es una nueva Instancia haz click";
L["loggedInDungeon2"] = "para borrar esta Instancia de la base de datos.";
L["reloadDungeon"] = "Recarga de IU detectada %s, cargando datos de la última Instancia en lugar de crear nuevos.";
L["thisHour"] = "esta hora";
L["statsError"] = "Error al buscar estadísticas para la Instancia con ID %s.";
L["statsMobs"] = "Mobs:";
L["statsXP"] = "XP:";
L["statsAverageXP"] = "Promedio XP/Mob:";
L["statsRunsPerLevel"] = "Runs por nivel:";
L["statsRunsNextLevel"] = "Runs hasta el siguiente nivel:";
L["statsTime"] = "Tiempo:";
L["statsAverageGroupLevel"] = "Nivel Promedio de Grupo:";
L["statsGold"] = "Oro";
L["sameInstance"] = "Detectada misma ID de Instancia que la anterior %s, fusionando entradas en la base de datos.";
L["deleteInstance"] = "Instancia borrada hace [%s] %s (%s) de la base de datos.";
L["deleteInstanceError"] = "Error al borrar %s.";
L["countString"] = "Has entrado en %s Instancias en la última hora y en %s en las últimas 24h";
L["countStringColorized"] = "Has entrado en %s %s %s Instancias en la última hora y %s %s %s en las últimas 24h";
L["now"] = "ahora";
L["in"] = "en";
L["active24"] = "bloqueo de 24h activo";
L["nextInstanceAvailable"] = "Siguiente Instancia disponible";
L["gave"] = "Dado";
L["received"] = "Recibido";
L["to"] = "a";
L["from"] = "de";
L["playersStillInside"] = "se ha reiniciado (Los jugadores que siguen dentro pueden salir y entrar en la nueva).";
L["gold"] = "oro";
L["silver"] = "plata";
L["copper"] = "cobre";
L["newInstanceNow"] = "Ahora puedes entrar en una nueva Instancia";
L["thisHour"] = "esta hora";
L["thisHour24"] = "estas 24horas";
L["openInstanceFrame"] = "Abrir Marco de Instancia";
L["openYourChars"] = "Abrir tus Personajes";
L["openTradeLog"] = "Abrir Log de Comercio";
L["config"] = "Configuración";
L["thisChar"] = "Este personaje";
L["yourChars"] = "Tus Personajes";
L["instancesPastHour"] = "Instancias en la última hora.";
L["instancesPastHour24"] = "Instancias en las últimas 24h.";
L["leftOnLockout"] = "hasta el desbloqueo";
L["tradeLog"] = "Log de Comercio";
L["pastHour"] = "Última hora";
L["pastHour24"] = "Últimas 24 horas";
L["older"] = "Antiguo";
L["raid"] = "Banda";
L["alts"] = "Alters";
L["deleteEntry"] = "Borrar entrada";
L["lastHour"] = "Última hora";
L["lastHour24"] = "Últimas 24h";
L["entered"] = "Entrado";
L["ago"] = "atrás";
L["stillInDungeon"] = "Sigue dentro de la mazmorra";
L["leftOnLockout"] = "hasta el desbloqueo";
L["leftOnDailyLockout"] = "hasta el desbloqueo diario";
L["noLockout"] = "No hay bloqueo para esta Banda";
L["unknown"] = "Desconocido";
L["instance"] = "Instancia";
L["timeEntered"] = "Hora de Entrada";
L["timeLeft"] = "Hora de Salida";
L["timeInside"] = "Tiempo dentro";
L["mobCount"] = "Recuento de Mobs";
L["experience"] = "Experiencia";
L["experienceShort"] = "XP";
L["rawGoldMobs"] = "Raw Gold de Mobs";
L["enteredLevel"] = "Nivel de Entrada";
L["leftLevel"] = "Nivel de Salida";
L["averageGroupLevel"] = "Promedio de Nivel de Grupo";
L["currentLockouts"] = "bloqueos actuales";
L["repGains"] = "Ganancia de Reputación";
L["groupMembers"] = "Miembros de Grupo";
L["tradesWhileInside"] = "Comercios estando dentro";
L["noDataInstance"] = "No hay datos disponibles para esta Instancia.";
L["restedOnlyText"] = "Mostrar Solo Descansados";
L["restedOnlyTextTooltip"] = "Mostrar únicamente personajes con descanso de XP? Desmarca esto para mostrar todos los alters, incluso nivel máximo y alters sin descanso.";
L["deleteEntry"] = "Borrar entrada"; --Example: "Delete entry 5";
L["online"] = "Conectado";
L["maximum"] = "Máximo";
L["level"] = "Nivel";
L["rested"] = "Descansado";
L["realmGold"] = "Realm gold for";
L["total"] = "Total";
L["guild"] = "Hermandad";
L["resting"] = "Descansando";
L["notResting"] = "No Descansando";
L["rested"] = "Descansado";
L["restedBubbles"] = "Burbujas Descansadas";
L["restedState"] = "Estado Descansado";
L["bagSlots"] = "Huecos de Mochila";
L["durability"] = "Durabilidad";
L["items"] = "Objetos";
L["ammunition"] = "Munición";
L["petStatus"] = "Estado de Mascota";
L["name"] = "Nombre";
L["family"] = "Familia";
L["happiness"] = "Felicidad";
L["loyaltyRate"] = "Nivel de Lealtad";
L["petExperience"] = "XP de Mascota";
L["unspentTrainingPoints"] = "Puntos de instrucción sin usar";
L["professions"] = "Profesiones";
L["lastSeenPetDetails"] = "Última vista de Detalles de Mascota";
L["currentPet"] = "Mascota actual";
L["noPetSummoned"] = "No hay Mascota invocada";
L["lastSeenPetDetails"] = "Última vista de Detalles de Mascota";
L["noProfessions"] = "No se han encontrado profesiones.";
L["cooldowns"] = "Enfriamientos";
L["left"] = "restante"; -- This is left as in "time left";
L["ready"] = "Preparado.";
L["pvp"] = "PvP";
L["rank"] = "Rango";
L["lastWeek"] = "Última semana";
L["attunements"] = "Attunements";
L["currentRaidLockouts"] = "Bloqueos de Banda Actuales";
L["none"] = "None.";

L["instanceStatsOutputRunsPerLevelTitle"] = "Runs Por Nivel";
L["instanceStatsOutputRunsPerLevelDesc"] = "Mostrar cuantos Runs se necesitarán por nivel?";

L["instanceStatsOutputRunsNextLevelTitle"] = "Runs hasta el siguiente nivel";
L["instanceStatsOutputRunsNextLevelDesc"] = "Mostrar cuantos Runs más se necesitan hasta el próximo nivel?";