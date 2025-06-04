1. Клонирование гит репозитория 
https://github.com/babyfox1/TouchstoneViewer.git
cd TouchstoneViewer

2. Сборка проекта
cmake -B build -S . -DCMAKE_VERBOSE_MAKEFILE=ON
cmake --build build

3. Запуск
После успешной сборки файл будет лежать в build\Release\
его можно запустить двойным щелчком
