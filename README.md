# Yandex_DNS
Bash скрипт предназначен для автоматического изменения ip адреса на вашем домене делегированного в сервис Yandex DNS
Получить необходимый токен нужно поссылке https://pddimp.yandex.ru/get_token.xml?domain_name=domen.ru , где domen.ru

Далее нужно найти id вашей dns записи.
Сделать это можно по ссылке https://pddimp.yandex.ru/nsapi/get_domain_records.xml?token=XXXXXX&domain=domen.ru заменив XXXX - на ваш выше полученный токен и domen.ru на ваш домен.

Поставте необходимые значения в скрипт (токен, домен) и запустите его. Можно добавить его в автозагрузку

Скрипт является модифицированной версией скрипта Петра Аникина, https://anikin.pw/all/besplatny-analog-dyndns-i-no-ip-ispolzuya-yandeks-dns/
