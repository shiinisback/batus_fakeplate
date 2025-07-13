# batus_fakeplate

Multilingual fake plate system for FiveM with configurable SQL support.

---

## Türkçe

### Özellikler
- oxmysql, ghmattimysql ve mysql-async desteği
- QBCore tabanlı
- ox_inventory ve qb-inventory uyumluluğu
- qb-target ve ox-target destekli etkileşimler
- Çoklu dil desteği (TR, EN, FR, DE, ES, IT, PT, RU, AR, JA, ZH, NL)

### Kurulum
1. Script dosyalarını `resources` klasörüne koyun.
2. `server.cfg` dosyanıza `ensure batus_fakeplate` ekleyin.
3. `config.lua` dosyasındaki ayarları kendi sunucunuza göre düzenleyin.
4. Items klasöründeki PNG’leri kendi envanter scriptinize göre aktarın. Ardından, Lua dosyasının içindeki kodu kendi envanter sisteminize göre yerleştirin.
5. Sunucuyu yeniden başlatın.

---

## English

**batus_fakeplate**: A multilingual fake plate system for your FiveM server with configurable SQL providers.

### Features
- Supports oxmysql, ghmattimysql, and mysql-async
- Built on QBCore framework
- Compatible with ox_inventory and qb-inventory
- Interactions with qb-target and ox-target support
- Multi-language support (TR, EN, FR, DE, ES, IT, PT, RU, AR, JA, ZH, NL)

### Installation
1. Place the script files inside your `resources` folder.
2. Add `ensure batus_fakeplate` to your `server.cfg`.
3. Configure your database and other settings in `config.lua`.
4. Import the PNG files from the items folder into your inventory script, then adapt and integrate the code inside the Lua file to fit your inventory system.
5. Restart your server.

---

## License

MIT License

---

## Author

batusdev
