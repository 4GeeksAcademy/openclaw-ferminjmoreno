# Diseño de habilidades

## Preguntas base

1. ¿Qué hace esta skill? Una frase.
2. ¿Qué input necesita el agente? ¿Qué le das, en qué formato y qué ya sabe a partir de los cinco archivos de configuración?
3. ¿Cómo es un buen output? Formato, destino y cómo sabrás que funcionó.

## Habilidad 1: Programar reunión

Archivo: [skills/programar-reunion/SKILL.md](skills/programar-reunion/SKILL.md)

### 1. ¿Qué hace esta skill?

Cuando el usuario solicita agendar o programar una reunión, valida la información, obtiene aprobación y crea un único evento verificable en Calendar.

### 2. ¿Qué input necesita el agente?

El usuario debe proporcionar:

- Título de la reunión.
- Fecha y hora de inicio.
- Duración o fecha y hora de finalización.
- Participantes, cuando quiera enviar invitaciones.
- Descripción y videollamada, cuando correspondan.

Los datos se pueden entregar en lenguaje natural, por ejemplo: «Agenda una revisión del proyecto mañana a las 10:00 durante 45 minutos con ana@ejemplo.com». El agente debe convertirlos a fecha, hora y duración inequívocas antes de actuar.

El agente ya puede consultar:

- `AGENTS.md`: permisos, confirmaciones y límites operativos.
- `IDENTITY.md`: nombre y tono del agente.
- `SOUL.md`: estilo, privacidad y criterio de actuación.
- `USER.md`: nombre, zona horaria y preferencias horarias configuradas.
- `TOOLS.md`: calendario, cuenta e integración disponibles.

No debe inventar participantes, correos, fecha, hora, zona horaria ni calendario. Si falta un dato obligatorio o un valor de configuración está vacío, debe preguntarlo antes de crear el evento.

### 3. ¿Cómo es un buen output?

- **Formato:** confirmación breve con título, fecha, zona horaria, duración, participantes y enlace o identificador.
- **Destino principal:** evento en Calendar.
- **Confirmación al usuario:** mensaje en el chat actual.
- **Evidencia de éxito:** Calendar devuelve un ID y una consulta posterior confirma que el evento coincide con la vista previa aprobada.
- **Fallo:** si Calendar no está configurado o no confirma la creación, debe entregar un borrador, explicar el problema y no declarar éxito.

Ejemplo:

```text
Reunión creada
Título: Revisión del proyecto
Fecha: 28 de septiembre de 2026, 10:00 America/Bogota
Duración: 45 minutos
Participantes: ana@ejemplo.com
Evento: <URL o identificador>
```

## Habilidad 2: Enviar resumen por Telegram

Archivo: [skills/enviar-resumen-telegram/SKILL.md](skills/enviar-resumen-telegram/SKILL.md)

### 1. ¿Qué hace esta skill?

Cuando el usuario solicita preparar o enviar un resumen, sintetiza las fuentes autorizadas y entrega un único mensaje verificable al chat de Telegram indicado.

### 2. ¿Qué input necesita el agente?

El usuario debe proporcionar:

- Contenido o fuentes autorizadas para resumir.
- Periodo que debe cubrir el resumen.
- Destinatario o alias de Telegram si desea enviarlo.
- Tipo de resumen, secciones, longitud o tono cuando quiera personalizarlos.

Los datos pueden entregarse como texto, archivos, URLs o referencias a herramientas autorizadas. Ejemplo: «Resume las notas de hoy y envíalas al chat Equipo en Telegram».

El agente ya puede consultar:

- `AGENTS.md`: permisos de lectura y autorización para acciones externas.
- `IDENTITY.md`: identidad o firma configurada.
- `SOUL.md`: tono, privacidad y límites de representación.
- `USER.md`: idioma, zona horaria y preferencias del resumen.
- `TOOLS.md`: alias de chats e integración de Telegram disponible.

No debe inferir el destinatario a partir de conversaciones anteriores ni incluir secretos o fuentes no autorizadas. Si el usuario pide solo preparar el resumen, no debe enviarlo.

### 3. ¿Cómo es un buen output?

- **Formato:** mensaje breve con logros, pendientes, bloqueos y próximos pasos; máximo recomendado de 3500 caracteres.
- **Destino principal:** chat de Telegram confirmado por el usuario.
- **Confirmación al usuario:** destinatario, periodo resumido y `message_id`.
- **Evidencia de éxito:** Telegram devuelve el `chat_id` y el `message_id`, y el contenido enviado coincide con la vista previa.
- **Fallo:** si falta el destinatario, la integración no existe o Telegram rechaza el mensaje, debe conservar el borrador y no declarar que fue enviado.

Ejemplo:

```text
Resumen — 27 de septiembre de 2026

Logros
- Se definieron las dos primeras habilidades del agente.

Pendientes
- Configurar y probar las integraciones de Calendar y Telegram.

Bloqueos
- OpenClaw y gog no están instalados en el contenedor actual.

Próximos pasos
- Validar las skills dentro del entorno donde se ejecutará OpenClaw.
```
