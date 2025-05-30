# 🎭 Eventura Tarija 🇧🇴

> Plataforma móvil para descubrir, compartir y asistir a eventos culturales en la ciudad de Tarija, Bolivia.

<p align="center">
  <img src="assets/logo_carnaval.png" alt="Logo del proyecto" width="180"/>
</p>

---

## 📖 Tabla de contenidos

- [📖 Introducción](#📖-introducción)
- [📌 Sobre el proyecto](#📌-sobre-el-proyecto)
- [🎯 Propósito del proyecto](#🎯-propósito-del-proyecto)
- [🛠️ Tecnologías](#️🛠️-tecnologías)
- [🧪 Entorno de desarrollo](#🧪-entorno-de-desarrollo)
- [📁 Estructura de archivos](#📁-estructura-de-archivos)
- [🤝 Contribuciones](#🤝-contribuciones)
- [📬 Contacto](#📬-contacto)
- [📄 Licencia](#📄-licencia)

---

## 📖 Introducción

**Eventos Culturales Tarija** es una aplicación móvil que conecta a los ciudadanos con el mundo cultural de Tarija. Ya sea teatro, música, danza o ferias, esta plataforma facilita la exploración de eventos en tiempo real.

---

## 📌 Sobre el proyecto

Este proyecto nació con la intención de ofrecer a la comunidad tarijeña una herramienta útil para acceder fácilmente a actividades culturales. Además, permite a artistas y organizadores promocionar sus eventos.

---

## 🎯 Propósito del proyecto

- Visibilizar la actividad cultural de Tarija
- Facilitar la planificación y asistencia a eventos
- Fomentar la participación ciudadana
- Apoyar a artistas y gestores culturales locales

---

## 🛠️ Tecnologías

- **Flutter**: Framework para aplicaciones móviles multiplataforma
- **Firebase**:
  - Firestore (base de datos en tiempo real)
  - Firebase Auth (autenticación)
  - Firebase Hosting
- **Google Maps SDK**: Para mostrar ubicaciones de eventos
- **Google Calendar API**: Para integración de eventos en el calendario del usuario

---

## 🧪 Entorno de desarrollo

- IDE : **Visual Studio Code**
- Flutter SDK versión: `>=3.7.2`
- Dependencias principales:
  - `firebase_core`
  - `cloud_firestore`
  - `firebase_auth`
  - `google_maps_flutter`
  - `googleapis/calendar`

> Se recomienda usar un emulador Android o dispositivo físico para pruebas de mapas y autenticación.

---

## 📁 Estructura de archivos

```bash
/lib
  ├── main.dart                # Punto de entrada
  ├── screens/                # Pantallas de la app
  ├── widgets/                # Componentes reutilizables
  ├── models/                 # Modelos de datos (Evento, Usuario)
  ├── services/               # Servicios (Firebase, Google Calendar)
  └── utils/                  # Funciones y constantes auxiliares

/assets
  └── logo_carnaval.png                # Logo del proyecto

firebase.json                 # Configuración de Firebase
pubspec.yaml                 # Dependencias del proyecto
