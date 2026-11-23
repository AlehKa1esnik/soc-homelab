# Сбор журналов (Wazuh 4.14.10)

[← Назад к описанию](../README.md)

| Агент | Машина | Источники |
|---|---|---|
| 000 | lab-wazuh (сам менеджер) | journald |
| 001 | lab-lnx01 | journald (SSH, sudo, PAM, учётки), **auditd** (`audit.log`), nginx access/error, dpkg, SCA (CIS Ubuntu 24.04) |
| 002 | lab-ws01 | Application, Security, System, **Sysmon** (15.22 + конфигурация sysmon-modular), PowerShell/Operational (4104), FIM реестра автозапуска, SCA |
| 003 | lab-dc01 | то же, что у WS01, — контроллер домена: 4768/4769/4771 и изменения AD |

Каналы Sysmon и PowerShell/Operational агент Windows по умолчанию не читает — они добавлены в его конфиг: [configs/windows/](../configs/windows/).

## auditd на lab-lnx01

Запуск команд людьми (`execve` с `auid ≥ 1000` — видно, кто вошёл, даже после `sudo`); запись в `/etc/passwd`, `/etc/shadow`, `/etc/sudoers`, `/etc/sudoers.d/`, `/etc/ssh/sshd_config`, конфиг агента Wazuh; смена атрибутов `sudoers`, `sshd_config` и конфига агента.

Правила — [configs/lab-lnx01/lab.rules](../configs/lab-lnx01/lab.rules).

## Порты lab-wazuh

| Порт | Служба | Доступен |
|---|---|---|
| 443/TCP | Панель Wazuh | сеть стенда |
| 1514/TCP | События от агентов | сеть стенда |
| 1515/TCP | Регистрация агентов (по паролю) | сеть стенда |
| 9200/TCP | Indexer (OpenSearch) | только 127.0.0.1 |
| 55000/TCP | REST API менеджера | только 127.0.0.1 |
| 22/TCP | SSH | только по ключу |
