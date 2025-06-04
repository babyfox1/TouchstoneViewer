# 1. Клонирование репозитория
git clone https://github.com/babyfox1/TouchstoneViewer.git
cd TouchstoneViewer

# 2. Создание build-директории и генерация CMake-файлов
cmake -B build

# 3. Сборка проекта (в build-директории)
cmake --build build --target touchviewer

# 4. Запуск приложения
./build/source/app/touchviewer (На Linux)
