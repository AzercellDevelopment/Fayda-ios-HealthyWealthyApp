# HealthyWealthyApp
This app has been created by Fayda team for Azercell Hackathon 2022

### Notes
- Bizdə bir məsələ var hansı ki, app-də Merchant GO bölməsində hər hansı bir aktivitini başlatdıqdan sonra, həmin aktivitinin bitirilməsi 2 cür olur
1) User tərəfindən icrada olan aktivitini cancel etmək
2) Partnyorların vasitəsi ilə aktivitinin tamamlanması (bunun üçün biz tərəfdən servislər yazılıb, ancaq partnyor tərəfindən `/api/v1/merchant/complete` servisinə request
göndərilməli. Bunun üçün istifadəçi ancaq appdə olan barcodu təqdim etməyi kifayətdir. 

- İstifadəçi Barkodu partnyora göstərir
- Partnyor həmin servisə sorğu yollayıb userCode-ni əldə edir
- VƏ həmin user kodu istifadə edərək sözü gedən servisi çağırır.

### USER CREDENTİALS FOR TESTİNG (YOU CAN REGISTER, TOO)

Email: ayxan28@inbox.ru
Password: ayxan123
