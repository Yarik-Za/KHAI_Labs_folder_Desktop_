@echo off

REM Определяем текущую дату и время
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set "year=%datetime:~0,4%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"
set "hour=%datetime:~8,2%"
set "minute=%datetime:~10,2%"
set "second=%datetime:~12,2%"
set "current_datetime=%year%-%month%-%day% %hour%:%minute%:%second%"

REM Абсолютный путь к папке для бекапа
set "backup_folder=C:\Users\Yarik\Desktop\✈️ ХАІ 💻"

REM Переходим в папку бекапа
cd /d "%backup_folder%"

REM Добавляем все файлы в Git
git add .

REM Создаем сообщение коммита с датой и временем бекапа
set "commit_message=Backup folder - %current_datetime%"

REM Коммитим изменения
git commit -m "%commit_message%"

REM Отправляем изменения на удаленный репозиторий (замените origin и main на ваши настройки)
git push origin main