---@type l10n
local l10n = QuestieLoader:ImportModule("l10n")

local genericsLocales = {
    ["Objects"] = {
        ["ptBR"] = "Objetos",
        ["ruRU"] = "Объекты",
        ["deDE"] = "Objekte",
        ["koKR"] = "목표",
        ["esMX"] = "Objetos",
        ["enUS"] = true,
        ["zhCN"] = "目标",
        ["zhTW"] = "目標",
        ["esES"] = "Objetos",
        ["frFR"] = "Objets",
    },
    ["Objective"] = {
        ["ptBR"] = "Objetivo",
        ["ruRU"] = "Цели",
        ["deDE"] = "Questziele",
        ["koKR"] = "목표",
        ["esMX"] = "Objetivo",
        ["enUS"] = true,
        ["zhCN"] = "目标",
        ["zhTW"] = "任務目標",
        ["esES"] = "Objetivo",
        ["frFR"] = "Objectif",
    },
    ["Objectives"] = {
        ["ptBR"] = "Objetivos",
        ["ruRU"] = "Цели заданий",
        ["deDE"] = "Questziele",
        ["koKR"] = "목표",
        ["esMX"] = "Objetivos",
        ["enUS"] = true,
        ["zhCN"] = "目标",
        ["zhTW"] = "任務目標",
        ["esES"] = "Objetivos",
        ["frFR"] = "Objectifs",
    },
    ["Quests"] = {
        ["ptBR"] = "Missões",
        ["ruRU"] = "Задания",
        ["deDE"] = "Quests",
        ["koKR"] = "퀘스트",
        ["esMX"] = "Misiones",
        ["enUS"] = true,
        ["zhCN"] = "任务",
        ["zhTW"] = "任務",
        ["esES"] = "Misiones",
        ["frFR"] = "Quêtes",
    },
    ["Show Questie"] = {
        ["ptBR"] = "Mostrar Questie",
        ["ruRU"] = "Показать Questie",
        ["deDE"] = "Zeige Questie",
        ["koKR"] = "Questie 표시",
        ["esMX"] = "Mostrar Questie",
        ["enUS"] = true,
        ["zhCN"] = "显示Questie",
        ["zhTW"] = "顯示任務圖示",
        ["esES"] = "Mostrar Questie",
        ["frFR"] = "Afficher Questie",
    },
    ["Hide Questie"] = {
        ["ptBR"] = "Ocultar Questie",
        ["ruRU"] = "Скрыть Questie",
        ["deDE"] = "Verstecke Questie",
        ["koKR"] = "Questie 숨기기",
        ["esMX"] = "Ocultar Questie",
        ["enUS"] = true,
        ["zhCN"] = "隐藏Questie",
        ["zhTW"] = "隱藏任務圖示",
        ["esES"] = "Ocultar Questie",
        ["frFR"] = "Masquer Questie",
    },
    ["Reload UI"] = {
        ["ptBR"] = "Recarregar interface",
        ["ruRU"] = "Перезагрузка",
        ["deDE"] = "Interface neu laden",
        ["koKR"] = "Reload UI",
        ["esMX"] = "Recargar IU",
        ["enUS"] = true,
        ["zhCN"] = "重载UI",
        ["zhTW"] = "重新載入介面",
        ["esES"] = "Recargar IU",
        ["frFR"] = "Recharger l'interface",
    },
    ["Yes"] = {
        ["ptBR"] = "Sim",
        ["ruRU"] = "Да",
        ["deDE"] = "Ja",
        ["koKR"] = "예",
        ["esMX"] = "Sí",
        ["enUS"] = true,
        ["zhCN"] = "是",
        ["zhTW"] = "是",
        ["esES"] = "Sí",
        ["frFR"] = "Oui",
    },
    ["No"] = {
        ["ptBR"] = "Não",
        ["ruRU"] = "Нет",
        ["deDE"] = "Nein",
        ["koKR"] = "아니오",
        ["esMX"] = "No",
        ["enUS"] = true,
        ["zhCN"] = "否",
        ["zhTW"] = "否",
        ["esES"] = "No",
        ["frFR"] = "Non",
    },
    ["Cancel"] = {
        ["ptBR"] = "Cancelar",
        ["ruRU"] = "Отмена",
        ["deDE"] = "Abbrechen",
        ["koKR"] = "취소",
        ["esMX"] = "Cancelar",
        ["enUS"] = true,
        ["zhCN"] = "取消",
        ["zhTW"] = "取消",
        ["esES"] = "Cancelar",
        ["frFR"] = "Annuler",
    },
    ["Don't show again"] = {
        ["ptBR"] = "Não mostrar novamente",
        ["ruRU"] = "Не отображать снова",
        ["deDE"] = "Nicht erneut zeigen",
        ["koKR"] = "다시 보이지 않기",
        ["zhCN"] = "不在显示",
        ["enUS"] = true,
        ["zhTW"] = "不再顯示",
        ["frFR"] = "Ne plus afficher",
        ["esES"] = "No volver a mostrar",
        ["esMX"] = "No volver a mostrar",
    },
    ["Auto"] = {
        ["ptBR"] = "Automático",
        ["ruRU"] = "Авто",
        ["deDE"] = "Automatisch",
        ["koKR"] = "자동",
        ["esMX"] = "Automático",
        ["enUS"] = true,
        ["zhCN"] = "自动",
        ["zhTW"] = "自動",
        ["esES"] = "Automático",
        ["frFR"] = "Automatique",
    },
    ["Manual"] = {
        ["ptBR"] = "Manual",
        ["ruRU"] = "Вручную",
        ["deDE"] = "Handbuch",
        ["koKR"] = "수동",
        ["esMX"] = "Manual",
        ["enUS"] = true,
        ["zhCN"] = "手动的",
        ["zhTW"] = "手動",
        ["esES"] = "Manual",
        ["frFR"] = "Manual",
    },
    ["Enabled"] = {
        ["ptBR"] = "Ativado",
        ["ruRU"] = "Включено",
        ["frFR"] = "Activé",
        ["koKR"] = "활성화",
        ["zhCN"] = "已启用",
        ["enUS"] = true,
        ["zhTW"] = "已啟用",
        ["deDE"] = "Aktiviert",
        ["esES"] = "Habilitado",
        ["esMX"] = "Habilitado",
    },
    ["Disabled"] = {
        ["ptBR"] = "Desativado",
        ["ruRU"] = "Отключено",
        ["deDE"] = "Deaktiviert",
        ["koKR"] = "비활성화",
        ["esMX"] = "Deshabilitado",
        ["enUS"] = true,
        ["zhCN"] = "停用",
        ["zhTW"] = "已停用",
        ["esES"] = "Deshabilitado",
        ["frFR"] = "Désactivé",
    },
    ["WARNING!"] = {
        ["ptBR"] = "ATENÇÃO!",
        ["ruRU"] = "ВНИМАНИЕ!",
        ["deDE"] = "WARNUNG!",
        ["koKR"] = "경고!",
        ["esMX"] = "¡ADVERTENCIA!",
        ["enUS"] = true,
        ["zhCN"] = "警告！",
        ["zhTW"] = "警告!",
        ["esES"] = "¡ADVERTENCIA!",
        ["frFR"] = "ATTENTION !",
    },
    ["xp"] = {
        ["ptBR"] = "xp",
        ["ruRU"] = " опыта",
        ["deDE"] = "xp",
        ["koKR"] = "경험치",
        ["esMX"] = "exp",
        ["enUS"] = true,
        ["zhCN"] = "经验",
        ["zhTW"] = "經驗值",
        ["esES"] = "exp",
        ["frFR"] = "exp",
    },
    ["Alliance"] = {
        ["ptBR"] = "Aliança",
        ["ruRU"] = "Альянс",
        ["deDE"] = "Allianz",
        ["koKR"] = "얼라이언스",
        ["esMX"] = "Alianza",
        ["enUS"] = true,
        ["zhCN"] = "联盟",
        ["zhTW"] = "聯盟",
        ["esES"] = "Alianza",
        ["frFR"] = "Alliance",
    },
    ["Horde"] = {
        ["ptBR"] = "Horda",
        ["ruRU"] = "Орда",
        ["deDE"] = "Horde",
        ["koKR"] = "호드",
        ["esMX"] = "Horda",
        ["enUS"] = true,
        ["zhCN"] = "部落",
        ["zhTW"] = "部落",
        ["esES"] = "Horda",
        ["frFR"] = "Horde",
    },
    ["Quest ID"] = {
        ["ptBR"] = "ID da missão",
        ["ruRU"] = "ID задания",
        ["deDE"] = "Quest ID",
        ["koKR"] = "퀘스트 ID",
        ["esMX"] = "ID de Misión",
        ["enUS"] = true,
        ["zhCN"] = "任务 ID",
        ["zhTW"] = "任務 ID",
        ["esES"] = "ID de Misión",
        ["frFR"] = "ID de la quête",
    },
    ["Quest Level"] = {
        ["ptBR"] = "Nível da missão",
        ["ruRU"] = "Уровень задания",
        ["deDE"] = "Quest-Level",
        ["koKR"] = "퀘스트 레벨",
        ["esMX"] = "Nivel de Misión",
        ["enUS"] = true,
        ["zhCN"] = "任务等级",
        ["zhTW"] = "任務等級",
        ["esES"] = "Nivel de Misión",
        ["frFR"] = "Niveau de la Quête",
    },
    ["Quest Details"] = {
        ["ptBR"] = "Detalhes da missão",
        ["ruRU"] = "Подробности задания",
        ["deDE"] = "Quest-Details",
        ["koKR"] = "퀘스트 Detail",
        ["esMX"] = "Detalles de Misión",
        ["enUS"] = true,
        ["zhCN"] = "任务详细信息",
        ["zhTW"] = "任務詳細資訊",
        ["esES"] = "Detalles de Misión",
        ["frFR"] = "Détails de la Quête",
    },
    ["NPC Details"] = {
        ["ptBR"] = "Detalhes do NPC",
        ["ruRU"] = "Подробности о NPC",
        ["deDE"] = "NPC-Details",
        ["koKR"] = "NPC Detail",
        ["esMX"] = "Detalles del PNJ",
        ["enUS"] = true,
        ["zhCN"] = "NPC 详细信息",
        ["zhTW"] = "NPC 詳細資訊",
        ["esES"] = "Detalles del PNJ",
        ["frFR"] = "Détails du PNJ",
    },
    ["Object Details"] = {
        ["ptBR"] = "Detalhes do objeto",
        ["ruRU"] = "Подробности объекта",
        ["deDE"] = "Objektdetails",
        ["koKR"] = "목표 Detail",
        ["esMX"] = "Detalles del objeto",
        ["enUS"] = true,
        ["zhCN"] = "目标详细信息",
        ["zhTW"] = "目標詳細資訊",
        ["esES"] = "Detalles del objeto",
        ["frFR"] = "Détails de l'objet",
    },
    ["Item Details"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Подробности о предмете",
        ["deDE"] = "Item-Details",
        ["koKR"] = "아이템 상세정보",
        ["esMX"] = "Detalles de objeto",
        ["enUS"] = true,
        ["zhCN"] = "物品的详细信息",
        ["zhTW"] = "物品詳細資訊",
        ["esES"] = "Detalles de objeto",
        ["frFR"] = "Détails de l’objet",
    },
    ["Required Level"] = {
        ["ptBR"] = "Nível necessário",
        ["ruRU"] = "Требуемый уровень",
        ["deDE"] = "Benötigtes Level",
        ["koKR"] = "필요 레벨",
        ["esMX"] = "Nivel Requerido",
        ["enUS"] = true,
        ["zhCN"] = "需要等级",
        ["zhTW"] = "需要等級",
        ["esES"] = "Nivel Requerido",
        ["frFR"] = "Niveau requis",
    },
    ["Required Race"] = {
        ["ptBR"] = "Raça necessária",
        ["ruRU"] = "Требуемая раса",
        ["deDE"] = "Benötigtes Volk",
        ["koKR"] = "필요 종족",
        ["esMX"] = "Raza Requerida",
        ["enUS"] = true,
        ["zhCN"] = "需要种族",
        ["zhTW"] = "需要種族",
        ["esES"] = "Raza Requerida",
        ["frFR"] = "Race requise",
    },
    ["Treasure Map"] = {
        ["ptBR"] = "Mapa do Tesouro",
        ["ruRU"] = "Поиск кладов",
        ["deDE"] = "Schatzkarte",
        ["koKR"] = "보물 지도",
        ["esMX"] = "Mapa de tesoro",
        ["enUS"] = true,
        ["frFR"] = "Carte au trésor",
        ["esES"] = "Mapa de tesoro",
        ["zhTW"] = "藏寶圖",
        ["zhCN"] = "藏宝图",
    },
    ["Special"] = {
        ["ptBR"] = "Especial",
        ["ruRU"] = "Особые",
        ["deDE"] = "Spezial",
        ["koKR"] = "특수",
        ["esMX"] = "Especial",
        ["enUS"] = true,
        ["frFR"] = "Spécial",
        ["esES"] = "Especial",
        ["zhTW"] = "特殊",
        ["zhCN"] = "特殊",
    },
    ["Epic"] = {
        ["ptBR"] = "Épico",
        ["ruRU"] = "Эпические",
        ["deDE"] = "Episch",
        ["koKR"] = "대규모",
        ["esMX"] = "Épica",
        ["enUS"] = true,
        ["frFR"] = "Épique",
        ["esES"] = "Épica",
        ["zhTW"] = "史詩",
        ["zhCN"] = "史诗",
    },
    ["Legendary"] = {
        ["ptBR"] = "Lendário",
        ["ruRU"] = "Легенды",
        ["deDE"] = "Legendär",
        ["koKR"] = "전설",
        ["esMX"] = "Legendaria",
        ["enUS"] = true,
        ["frFR"] = "Légendaire",
        ["esES"] = "Legendaria",
        ["zhTW"] = "傳說",
        ["zhCN"] = "传说",
    },
    ["Reputation"] = {
        ["ptBR"] = "Reputação",
        ["ruRU"] = "Репутация",
        ["deDE"] = "Ruf",
        ["koKR"] = "평판",
        ["esMX"] = "Reputación",
        ["enUS"] = true,
        ["frFR"] = "Réputation",
        ["esES"] = "Reputación",
        ["zhTW"] = "聲望",
        ["zhCN"] = "声望",
    },
    ["Group"] = {
        ["ptBR"] = "Grupo",
        ["ruRU"] = "Группа",
        ["deDE"] = "Gruppe",
        ["koKR"] = "그룹",
        ["esMX"] = "Grupo",
        ["enUS"] = true,
        ["zhCN"] = "队伍",
        ["zhTW"] = "隊伍",
        ["esES"] = "Grupo",
        ["frFR"] = "Groupe",
    },
    ["Party"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Группа",
        ["deDE"] = true,
        ["koKR"] = "파티",
        ["esMX"] = "Grupo",
        ["enUS"] = true,
        ["zhCN"] = "队伍",
        ["zhTW"] = "小隊",
        ["esES"] = "Grupo",
        ["frFR"] = "Groupe",
    },
    ["Raid"] = {
        ["ptBR"] = "Raide",
        ["ruRU"] = "Рейд",
        ["deDE"] = "Schlachtzug",
        ["koKR"] = "레이드",
        ["esMX"] = "Banda",
        ["enUS"] = true,
        ["zhCN"] = "团队",
        ["zhTW"] = "團隊",
        ["esES"] = "Banda",
        ["frFR"] = "Raid",
    },
    ["Vendors"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Продавцы",
        ["deDE"] = "Händler",
        ["koKR"] = "상인",
        ["esMX"] = "Vendedores",
        ["enUS"] = true,
        ["zhCN"] = "供应商",
        ["zhTW"] = "商人",
        ["esES"] = "Vendedores",
        ["frFR"] = "Vendeurs",
    },
    ["Achievements"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Достижения",
        ["deDE"] = "Erfolge",
        ["koKR"] = "업적",
        ["esMX"] = "Logros",
        ["enUS"] = true,
        ["zhCN"] = "成就",
        ["zhTW"] = "成就",
        ["esES"] = "Logros",
        ["frFR"] = "Hauts faits",
    },
    ["Dismiss"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Закрыть",
        ["deDE"] = "Schließen",
        ["koKR"] = "해산",
        ["esMX"] = "Cerrar",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = "解散",
        ["esES"] = "Cerrar",
        ["frFR"] = false,
    },
	["Doable"] = {
        ["ptBR"] = false,
        ["ruRU"] = false,
        ["deDE"] = false,
        ["koKR"] = "수행 가능",
        ["esMX"] = "Realizable",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = "可行",
        ["esES"] = "Realizable",
        ["frFR"] = false,
    },
	["Questie"] = {
        ["ptBR"] = true,
        ["ruRU"] = true,
        ["deDE"] = true,
        ["koKR"] = true,
        ["esMX"] = true,
        ["enUS"] = true,
        ["zhCN"] = true,
        ["zhTW"] = "任務-位置",
        ["esES"] = true,
        ["frFR"] = true,
    },
	["Questie Title"] = {
        ["ptBR"] = "Questie",
        ["ruRU"] = "Questie",
        ["deDE"] = "Questie",
        ["koKR"] = "Questie",
        ["esMX"] = "Questie",
        ["enUS"] = "Questie",
        ["zhCN"] = "Questie",
        ["zhTW"] = "任務位置提示",
        ["esES"] = "Questie",
        ["frFR"] = "Questie",
    }
}

for k, v in pairs(genericsLocales) do
    l10n.translations[k] = v
end
