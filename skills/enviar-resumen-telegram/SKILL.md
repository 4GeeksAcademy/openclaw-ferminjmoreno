---
name: enviar-resumen-telegram
description: "Sintetizar fuentes autorizadas y entregar un resumen a un chat de Telegram con verificación de entrega."
---

# Enviar resumen por Telegram

Cuando el usuario pida preparar, hacer o enviar un resumen, reporte o
actualización a Telegram. No enviar si el usuario solo pidió preparar.

Actívala ante peticiones como «envía mi resumen por Telegram», «manda el
reporte diario» o «prepara el resumen para Telegram».

No la uses para responder conversaciones en nombre del usuario, difundir
contenido a varios chats ni acceder a fuentes no autorizadas.

## Input del usuario

| Dato | Obligatorio | Formato | Fuente o valor por defecto |
|---|---|---|---|
| Contenido o fuentes | Sí | Texto, archivos, URLs o herramientas autorizadas | Usuario |
| Período cubierto | Sí | Fechas o intervalo inequívoco | Usuario; «hoy» se resuelve con zona horaria de `USER.md` |
| Destinatario | Sí para enviar | Alias o `chat_id` | `TOOLS.md`; preguntar si falta o hay varios |
| Tipo de resumen | No | Diario, proyecto, reuniones o personalizado | Diario |
| Secciones | No | Lista de encabezados | Logros, pendientes, bloqueos, próximos pasos |
| Longitud | No | Breve, media o límite de caracteres | Breve, máx. 3500 caracteres |
| Tono | No | Directo, formal o personalizado | `SOUL.md` y `USER.md` |

Antes de preguntar, consulta únicamente el contexto pertinente:

- `AGENTS.md` → permisos para leer fuentes y realizar envíos externos
- `IDENTITY.md` → firma o identidad si Fer la ha configurado
- `SOUL.md` → tono, privacidad y límites de representación
- `USER.md` → nombre, zona horaria, idioma y preferencias
- `TOOLS.md` → alias de Telegram, chats autorizados, integración disponible

No infieras un destinatario a partir de conversaciones anteriores. No
incluyas secretos, credenciales ni fuentes no autorizadas.

Si falta contenido, período o destinatario, pregunta solo por lo necesario.
Si el usuario pide únicamente preparar el resumen, el destinatario no es
obligatorio y no debes enviar nada.

## Cómo enviar

Usar la API de Telegram (`curl` a `api.telegram.org`). El token de bot está
en `openclaw.json` → `channels.telegram.botToken`.

El `chat_id` puede venir de:
- `TOOLS.md` si tiene un alias configurado
- El usuario da el número directamente
- El username/nombre del chat (resolverlo con `getUpdates` o `getChat`)

## Formato del resumen

- Tono: profesional pero conversacional (guiarse por `SOUL.md`)
- Máximo recomendado: **3500 caracteres** (límite Telegram: 4096)
- Secciones sugeridas: logros, pendientes, bloqueos, próximos pasos
- Incluir período y fecha del resumen
- Omitir secciones vacías excepto bloqueos cuando convenga

## Flujo

1. **Determinar intención** — ¿preparar o enviar? No conviertas un borrador
   en envío.
2. **Verificar fuentes** — comprueba que son accesibles y están autorizadas.
   Termina con lista de fuentes faltantes si no puedes leerlas.
3. **Sintetizar** — solo hechos del período solicitado. No inventes avances,
   responsables ni fechas.
4. **Limitar longitud** — mantén bajo 3500 caracteres. Si no cabe, prepara
   partes numeradas y avisa.
5. **Resolver destinatario** — mediante alias exacto de `TOOLS.md` o
   `chat_id` dado por el usuario. Si hay ambigüedad, pregunta.
6. **Vista previa** — muestra y pide confirmación antes de enviar. Omite
   este paso solo si hay autorización explícita en `AGENTS.md`/`USER.md`
   para ese resumen periódico y destinatario.
7. **Deduplicar** — construye clave: destinatario + tipo + período. Si ya se
   envió, infórmalo y no repitas.
8. **Enviar** — una sola vez vía Telegram. Conserva `chat_id` y
   `message_id`.
9. **Confirmar** — responde con destinatario, período y `message_id`.

## Output exitoso

```
Resumen — 27 sep 2026
Enviado a: startbot (chat_id: 6715028138)
message_id: 149
```

## Manejo de errores

- Si **falta el destinatario**: preguntar antes de enviar.
- Si **Telegram rechaza el mensaje**: conservar el borrador, explicar el
  error. No declarar que se envió.
- Si **no hay integración de Telegram**: avisar y entregar borrador en el
  chat actual.
- Si **el resumen ya fue enviado**: informar y no repetir.
- Si **el estado del envío es incierto**: no reintentar automáticamente.

## Notas

- No inferir el destinatario de conversaciones anteriores.
- No incluir secretos, contraseñas ni fuentes no autorizadas.
- Respetar el máximo de 4096 caracteres de Telegram.