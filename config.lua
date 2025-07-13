Config = {}

Config.Locale = "tr" -- Lang "tr", "en", "fr", "de", "es", "it", "pt", "ru", "ar", "ja", "zh", "nl"

Config.SQL = "oxmysql" --"oxmysql", "ghmattimysql", "mysql-async"

Config.SQLInfo = {
    vehiclesTable = "player_vehicles", -- Vehicles Table
    plateColumn = "plate", -- Plate Column
    fakePlateColumn = "fakeplate" -- Fake Plate Column
}

Config.Inventory = "ox" -- "ox", or "qb"

Config.Target = "qb" -- "ox" or "qb"

Config.Progress = "qbcore" --"qbcore" or "progressbar"

Config.Items = {
    FakePlate = "fakeplate", -- Fake Plate
    Lockpick = "advancedlockpick" -- Advanced Lock Pick
}
