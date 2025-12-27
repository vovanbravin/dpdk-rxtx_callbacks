# dpdk-rxtx_callbacks

### Зависимости внутри контейнера:
* build-essential # Компиляторы GCC, make  
* meson # Система сборки  
* ninja-build # Ускоритель сборки  
* python3 # Для скриптов DPDK  
* python3-pyelftools # Обработка ELF файлов  
* libnuma-dev # Поддержка NUMA  
* pkg-config # Конфигурация пакетов  
* iproute2 # Управление сетью  
* iputils-arping # Генерация трафика  
* wget # Загрузка DPDK  

## Сборка проекта

### 1. Клонирование репозитория
```bash
git clone <URL_репозитория>
cd dpdk-rxtx-callbacks
```
### 2. Сборка образа
```bash
docker build -t dpdk-rxtx-callbacks .
```

### 3. Подготовка директории для логов
```bash
mkdir -p logs
```
## Запуск проекта
```bash
docker run --rm --privileged \
  -v $(pwd)/logs:/logs \
  dpdk-rxtx-callbacks
```
## Ожидаемый результат
### 1. Выходной лог в консоль
После запуска контейнер автоматически:
* Настраивает hugepages
* Создает TAP интерфейсы tap0 и tap1
* Запускает DPDK приложение
* Генерирует сетевой трафик на 20 секунд
* Сохраняет логи в /logs/

### 2. Лог файл на хосте
В директории ./logs/ появится файл:
dpdk_test_{дата}_{время}.log

### 3. Содержимое лог файла
EAL: Detected CPU lcores: 8  
EAL: Detected NUMA nodes: 1  
EAL: Detected shared linkage of DPDK  
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket  
EAL: Selected IOVA mode 'PA'  
Port 0 MAC: 12:34:56:78:9a:bc  
Port 1 MAC: bc:9a:78:56:34:12  

Core 0 forwarding packets. [Ctrl+C to quit]  
Latency = 15 cycles  
Latency = 12 cycles  
Latency = 14 cycles  
Latency = 11 cycles  
Latency = 13 cycles  
