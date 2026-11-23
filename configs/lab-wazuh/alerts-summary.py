#!/usr/bin/env python3
"""Сводка алертов Wazuh по агентам и правилам начиная с заданного времени (UTC).

Запуск на lab-wazuh:
    sudo python3 alerts-summary.py 2026-11-14T18:47

Источник — /var/ossec/logs/alerts/alerts.json (одна JSON-запись на строку).
Сравнивается поле timestamp алерта — это время обработки на менеджере,
а не время самого события.
"""
import json, sys, collections

if len(sys.argv) != 2:
    sys.exit(__doc__)

start = sys.argv[1]
c = collections.Counter()
with open('/var/ossec/logs/alerts/alerts.json') as f:
    for line in f:
        a = json.loads(line)
        if a['timestamp'] >= start:
            r = a['rule']
            c[(a['agent']['name'], r['id'], r['level'], r['description'])] += 1

for (ag, rid, lvl, d), n in sorted(c.items()):
    print(f"{n:5} {ag:10} {rid:>6} L{lvl:<2} {d}")
