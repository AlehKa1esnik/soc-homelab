# Конфигурации стенда

[← Назад к описанию](../README.md)

Секретов в этих файлах нет: только адреса, MAC и правила стенда. Пароль регистрации агентов Wazuh хранится на машинах в отдельном файле `authd.pass`, в репозиторий он не попадает (см. `.gitignore`).

| Файл | Куда на машине | Что делает |
|---|---|---|
| [libvirt/lab.xml](libvirt/lab.xml) | хост: `virsh net-define` | Изолированная сеть `lab` |
| [libvirt/lab-nat.xml](libvirt/lab-nat.xml) | хост: `virsh net-define` | Сеть `lab-nat`: NAT, DHCP, закреплённые адреса для карт «на горячую» |
| [libvirt/lab-net.zsh](libvirt/lab-net.zsh) | хост: `source` из `~/.zshrc` | Функции `lab-net-on <vm>` / `lab-net-off <vm>` |
| [linux-common/timesyncd-lab.conf](linux-common/timesyncd-lab.conf) | `/etc/systemd/timesyncd.conf.d/lab.conf` (lab-lnx01, lab-wazuh, lab-kali) | Время с контроллера домена |
| [lab-lnx01/60-lab.yaml](lab-lnx01/60-lab.yaml) | `/etc/netplan/60-lab.yaml` | Сеть: обе карты по MAC |
| [lab-lnx01/lab.rules](lab-lnx01/lab.rules) | `/etc/audit/rules.d/lab.rules` | Правила auditd |
| [lab-lnx01/ossec-localfile-auditd.xml](lab-lnx01/ossec-localfile-auditd.xml) | фрагмент `/var/ossec/etc/ossec.conf` | `audit.log` в агент Wazuh |
| [lab-wazuh/60-lab.yaml](lab-wazuh/60-lab.yaml) | `/etc/netplan/60-lab.yaml` | Сеть: обе карты по MAC |
| [lab-wazuh/10-lab-hardening.conf](lab-wazuh/10-lab-hardening.conf) | `/etc/ssh/sshd_config.d/10-lab-hardening.conf` | SSH только по ключу, вход root запрещён |
| [lab-wazuh/ism-alert-retention-policy.json](lab-wazuh/ism-alert-retention-policy.json) | Dev Tools в панели Wazuh | Удаление алертов старше 60 дней |
| [lab-wazuh/alerts-summary.py](lab-wazuh/alerts-summary.py) | lab-wazuh, запуск через `sudo python3` | Сводка алертов по агентам и правилам |
| [windows/ossec-localfile-sysmon-powershell.xml](windows/ossec-localfile-sysmon-powershell.xml) | фрагмент `ossec.conf` агента Windows | Каналы Sysmon и PowerShell 4104 |

## Как применить политику хранения алертов

В панели Wazuh: ☰ → Indexer management → Dev Tools.

```
PUT _plugins/_ism/policies/wazuh-alert-retention-policy
<тело из ism-alert-retention-policy.json>
```

`ism_template` действует только на новые индексы, к уже существующим политика подключается отдельно:

```
POST _plugins/_ism/add/wazuh-alerts-*
{ "policy_id": "wazuh-alert-retention-policy" }
```

## API менеджера только на 127.0.0.1

Строка в `/var/ossec/api/configuration/api.yaml`, затем `sudo systemctl restart wazuh-manager`:

```yaml
host: ['127.0.0.1']
```
