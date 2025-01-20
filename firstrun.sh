#!/bin/bash

# Убедимся, что скрипт выполняется с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
   echo "Этот скрипт должен быть запущен с правами суперпользователя" >&2
   exit 1
fi

# Установка Git, если он еще не установлен
if ! command -v git &> /dev/null
then
    echo "Устанавливаем Git..."
    apt-get update
    apt-get install -y git
else
    echo "Git уже установлен."
fi

# Укажите путь, где вы хотите разместить репозиторий
REPO_PATH="~/bashutils"
REPO_URL="https://github.com/koldun11/bashutils.git"

# Клонируем репозиторий
if [ ! -d "$REPO_PATH" ]; then
    echo "Клонируем репозиторий..."
    git clone "$REPO_URL" "$REPO_PATH"
else
    echo "Репозиторий уже клонирован."
fi

# Переходим в каталог репозитория
cd "$REPO_PATH"

# Добавляем задачу в cron для ежедневного выполнения dailyjob.sh
CRON_JOB="0 */4 * * * cd /home/yarik/bashutils && ./dailyjob.sh && git pull origin main"

# Убедимся, что cron запись уникальна
(crontab -l ; echo "$CRON_JOB") | sort | uniq | crontab -

echo "Скрипт firstrun.sh выполнен. Ежедневная проверка обновлений настроена."
