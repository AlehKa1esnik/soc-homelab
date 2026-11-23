# Аудит Windows (GPO `LAB-Audit`)

[← Назад к описанию](../README.md)

GPO `LAB-Audit` привязана к OU `Domain Controllers` и `Lab`, то есть действует на контроллер домена и на компьютеры в OU `Lab`.

- 4688 — создание процесса **с командной строкой**.
- PowerShell: Script Block Logging (4104) и Module Logging для всех модулей (4103).
- Журнал Security — 512 МБ.
- Расширенная политика аудита (S — успех, F — отказ):

| Категория | Подкатегории |
|---|---|
| Account Logon | Credential Validation S/F, Kerberos Authentication Service S/F, Kerberos Service Ticket Operations S/F |
| Account Management | Computer Account Mgmt S, Security Group Mgmt S, User Account Mgmt S/F, Other Account Mgmt Events S |
| Detailed Tracking | Process Creation S |
| DS Access | Directory Service Access S/F, Directory Service Changes S |
| Logon/Logoff | Logon S/F, Logoff S, Account Lockout S/F, Special Logon S, Other Logon/Logoff Events S/F |
| Object Access | Other Object Access Events S/F |
| Policy Change | Audit Policy Change S/F, Authentication Policy Change S |
| System | Security State Change S, Security System Extension S, System Integrity S/F, Other System Events S/F |

Включено «Audit: Force audit policy subcategory settings».

**Урок:** расширенная политика из GPO применяется целиком — незаданные подкатегории выключаются, поэтому `auditpol` сравнивается до и после.
