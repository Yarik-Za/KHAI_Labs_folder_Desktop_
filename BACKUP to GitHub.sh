#!/bin/bash

# Определяем текущую дату и время
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

# Абсолютный путь к папке для бекапа
backup_folder="/Users/Yarik/Desktop/✈️ ХАІ 💻"

# Переходим в папку бекапа
cd "$backup_folder"

# Добавляем все файлы в Git
git add .

# Проверяем есть ли локальные изменения
if git diff --cached --exit-code; then
    # Нет локальных изменений
    echo "No local changes to commit."
else
    # Есть локальные изменения
    # Создаем сообщение коммита с датой и временем бекапа
    commit_message="Backup folder - $current_datetime"
    
    # Коммитим изменения
    git commit -m "$commit_message"
    
    # Пушим изменения на удаленный репозиторий (замените origin и main на ваши настройки)
    git push origin main
fi

# Пытаемся выполнить pull независимо от того, были ли локальные изменения или нет
# Это может быть полезным, чтобы получить последние изменения из удаленной ветки
git pull origin main

