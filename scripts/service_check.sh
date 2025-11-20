#!/bin/bash

# 1. Прочитать файл со списком сервисов

# 2. Подготовить переменные для подсчёта статуса
running=0
stopped=0

# 3. Цикл который проходит по каждому сервису
while read service; do

    # 3.1 Получить текущую дату/время
    date_var=$(date +"%Y-%m-%d %H:%M:%S")

    # 3.2 Проверить — сервис работает или нет
    if systemctl is-active --quiet "$service"; then
        # 3.2.1 Увеличить счётчик running
         running=$((running + 1))

        # 3.2.2 Записать в лог "OK"
         echo "$date_var | $service | OK" >> /var/log/service_check.log
     else
        # 3.2.3 Увеличить счётчик stopped
         stopped=$((stopped + 1))
        # 3.2.4 Записать в лог "DOWN"
         echo "$date_var | $service | DOWN" >> /var/log/service_check.log
     fi

done < services.txt

# 4. Вывести пользователю количество работающих и упавших сервисов
 echo "Running: $running, Stopped: $stopped"
# 5. Выставить exit code:
  if [ "$stopped" -eq 0 ]; then
    exit 0
else
    exit 1
fi

