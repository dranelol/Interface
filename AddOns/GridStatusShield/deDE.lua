local L = LibStub("AceLocale-3.0"):NewLocale("GridStatusShield", "deDE")

if not L then return end
L["[aA]bsorbs.- (%d+) .-damage"] = "[Aa]bsorbiert.- (%d+) .-[sS]chaden"
L["Aegis detection tolerance"] = "Aegis Erkennungs-Toleranz"
L["Color for shield amount below the low shield threshold."] = "Farbe für Schilde deren verbleibende Stärke unter der \"Niedriges Schild\" Schranke liegen."
L["Color for shield amount below the medium shield threshold."] = "Farbe für Schilde deren verbleibende Stäke unter der \"Mittleres Schild\" Schranke liegen."
L["Increase this parameter if your Divine Aegis isn't not correctly detected. But can also lead to miss detection the higher the value is."] = "Erhöhe diesen Wert falls deine Göttliche Aegis nicht korrekt erkannt wird. Je größer der Wert desto größer allerdings auch die Chance auf Fehlerkennungen."
L["Low shield color"] = "Niedriges schild Farbe"
L["Low shield threshold"] = "Niedriges Schild Schranke"
L["Medium shield color"] = "Mittleres Schild Farbe"
L["Medium shield threshold"] = "Mittleres Schild Schranke"
L["Shield left"] = "Verbleibender Schild"
L["The threshold below which a shield is considered low."] = "Die Schranke unter welcher Schilde als niedrig eingestuft werden."
L["The threshold below which a shield is considered medium."] = "Die Schranke unter welcher Schilde als mittel eingestuft werden."
L["Use combat log"] = "Nutze Kampflog"
L["Uses the combat log to detect shields. This can be faster but is also be more inaccurate."] = "Benutze das Kampflog um Schilde zu erkennen. Dies kann schneller sein ist aber auch ungenauer."