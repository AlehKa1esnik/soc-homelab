# Домен `lab.internal`

[← Назад к описанию](../README.md)

- NetBIOS-имя `LAB`, уровень домена и леса — Windows Server 2025.
- Имя `.internal` выбрано вместо `.local`: `.local` закреплён за mDNS (RFC 6762) и мешает Linux-клиентам; `.internal` зарезервирован ICANN для частного использования.
- DNS для всех машин — 10.10.10.10. Linux-машины в DNS не регистрируются сами — A-записи `lab-lnx01` и `lab-wazuh` добавлены вручную.
- Время: DC — источник (Stratum 1, без внешнего источника), Windows-клиенты — через домен, Linux — `systemd-timesyncd` с DC. Часовой пояс Windows — `Belarus Standard Time`, Linux — UTC.

## Структура

```
lab.internal
├── Domain Controllers
│   └── LAB-DC01
└── Lab
    ├── Users            i.ivanov (бухгалтерия), p.petrova (кадры), s.sidorov (ИТ)
    ├── Admins           adm.sidorov — член Domain Admins
    ├── ServiceAccounts  svc_sql — SPN MSSQLSvc/lab-lnx01.lab.internal:1433 (мишень для Kerberoasting)
    ├── Groups           GG_Accounting, GG_HR, GG_IT
    ├── Workstations     LAB-WS01  (сюда по умолчанию попадают новые компьютеры — redircmp)
    └── Servers
```

Политика аудита домена — в [windows-audit.md](windows-audit.md).
