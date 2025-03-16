workspace {
    model {
        // Роли пользователей
        user = person "User" "Пользователь, который отправляет и получает сообщения."

        // Внешние системы
        database = softwareSystem "Database" "Хранилище данных для пользователей, чатов и сообщений." {
            description "Реляционная база данных PostgreSQL для хранения информации."
        }

        authService = softwareSystem "Authentication Service" "Внешний сервис для аутентификации пользователей." {
            description "Сервис, отвечающий за управление пользователями и их авторизацию."
        }

        // Основная система
        slackLikeSystem = softwareSystem "Slack-Like Messaging System" "Система для обмена сообщениями между пользователями." {
            description "Основная система, которая предоставляет API для работы с пользователями, чатами и сообщениями."

            // Контейнеры
            apiGateway = container "API Gateway" "Точка входа для всех запросов." "FastAPI"
            userService = container "User Service" "Сервис для управления пользователями." "FastAPI"
            chatService = container "Chat Service" "Сервис для управления чатами." "FastAPI"
            messageService = container "Message Service" "Сервис для управления сообщениями." "FastAPI"
        }

        // Взаимодействия
        user -> slackLikeSystem "Использует для отправки и получения сообщений."
        slackLikeSystem -> database "Чтение и запись данных."
        slackLikeSystem -> authService "Проверка аутентификации пользователя."

        apiGateway -> userService "Запросы на управление пользователями."
        apiGateway -> chatService "Запросы на управление чатами."
        apiGateway -> messageService "Запросы на управление сообщениями."
        userService -> database "Чтение и запись данных пользователей."
        chatService -> database "Чтение и запись данных чатов."
        messageService -> database "Чтение и запись данных сообщений."

        // Взаимодействие между пользователем и API Gateway
        user -> apiGateway "Отправляет сообщение в групповой чат."
    }

    views {
        // Диаграмма контекста системы
        systemContext slackLikeSystem "SystemContext" "Диаграмма контекста системы." {
            include *
            autoLayout
        }

        // Диаграмма контейнеров
        container slackLikeSystem "Container" "Диаграмма контейнеров системы." {
            include *
            autoLayout
        }

        // Диаграмма динамики для отправки сообщения в групповой чат
        dynamic slackLikeSystem "Dynamic" "Диаграмма динамики для отправки сообщения в групповой чат." {
            autoLayout lr
            user -> apiGateway "Отправляет сообщение в групповой чат."
            apiGateway -> chatService "Проверяет, существует ли чат и есть ли пользователь в чате."
            chatService -> database "Проверяет данные чата."
            apiGateway -> messageService "Отправляет сообщение в чат."
            messageService -> database "Сохраняет сообщение в базе данных."
        }
    }

}