#!/bin/bash

# Определяем текущую дату и время
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

# Ваша папка для бекапа (указывается относительный путь)
backup_folder="./backup_folder"

# Переходим в папку бекапа
cd "$backup_folder"

# Добавляем все файлы в Git
git add .

# Создаем сообщение коммита с датой и временем бекапа
commit_message="Backup folder - $current_datetime"

# Коммитим изменения
git commit -m "$commit_message"

# Отправляем изменения на удаленный репозиторий (замените origin и master на ваши настройки)
git push origin master
