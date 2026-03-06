Дана інструкція містить кроки для розгортання та перевірки коректності роботи `todoapp` у кластері Kubernetes.

## 1. Розгортання (Deployment)

Для автоматичного розгортання всіх ресурсів (Namespace, PV, PVC, ConfigMap, Secret, Service, Deployment) виконайте скрипт ініціалізації:

```bash
# Надання прав на виконання (якщо потрібно)
chmod +x bootstrap.sh

# Запуск розгортання
./bootstrap.sh
```

---

## 2. Валідація змін

Після завершення роботи скрипта виконайте наступні перевірки:

### 2.1. Перевірка статусу додатка

Переконайтеся, що всі поди розгорнуті в неймспейсі `todoapp` та мають статус `Running`:

```bash
kubectl get pods -n todoapp
```

### 2.2. Перевірка монтування ConfigMap

Згідно з вимогами, дані ConfigMap мають бути змонтовані як файли у папку `/app/configs` у режимі "тільки для читання":

```bash
# Отримання списку файлів у папці конфігів
kubectl exec -it <назва_поду> -n todoapp -- ls -l /app/configs
```

*Ви маєте побачити файли, назви яких відповідають ключам у вашому `configMap.yml`.*

### 2.3. Перевірка монтування Secret

Секретні дані мають бути доступні у вигляді файлів у папці `/app/secrets`:

```bash
# Перевірка наявності файлів секретів
kubectl exec -it <назва_поду> -n todoapp -- ls -l /app/secrets

# Перевірка вмісту секрету (наприклад, SECRET_KEY)
kubectl exec -it <назва_поду> -n todoapp -- cat /app/secrets/SECRET_KEY
```

### 2.4. Перевірка PersistentVolume (PV/PVC)

Перевірте, що PersistentVolumeClaim успішно підключено до папки `/app/data`:

```bash
# Перевірка монтування тому
kubectl exec -it <назва_поду> -n todoapp -- df -h | grep /app/data

# Тестовий запис на диск (дані мають зберегтися навіть після видалення поду)
kubectl exec -it <назва_поду> -n todoapp -- touch /app/data/test_file.txt
```

### 2.5. Перевірка змінних оточення

Перевірте, що змінні оточення `PYTHONUNBUFFERED` та `SECRET_KEY` також встановлені в контейнері:

```bash
kubectl exec -it <назва_поду> -n todoapp -- printenv | grep -E 'PYTHONUNBUFFERED|SECRET_KEY'
```

---

## Додаткова інформація

* **Namespace:** `todoapp`
* **Конфігурації:** монтуються у `/app/configs` (Read-only)
* **Секрети:** монтуються у `/app/secrets` (Read-only)
* **Сховище:** монтується у `/app/data`
