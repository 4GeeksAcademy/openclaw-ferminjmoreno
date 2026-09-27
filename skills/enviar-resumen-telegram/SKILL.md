---
name: enviar-resumen-telegram
description: "Prepara o envía un resumen por Telegram: reúne fuentes autorizadas, redacta un mensaje breve, confirma el destino y verifica el envío."
---

# Enviar resumen por Telegram

## 1. ¿Qué hace esta skill?

Cuando el usuario solicita preparar o enviar un resumen, sintetiza las fuentes autorizadas y entrega un único mensaje verificable al chat de Telegram indicado.

Actívala ante peticiones como «envía mi resumen por Telegram», «manda el reporte diario» o «prepara el resumen para Telegram».

No la uses para responder conversaciones en nombre del usuario, difundir contenido a varios chats ni acceder a fuentes que el usuario no haya autorizado.

## 2. ¿Qué input necesita el agente?

| Dato | Obligatorio | Formato | Fuente o valor por defecto |
|---|---|---|---|
| Contenido o fuentes | Sí | Texto, archivos, URLs o herramientas autorizadas | Usuario |
| Periodo cubierto | Sí | Fechas o intervalo inequívoco | Usuario; puede ser «hoy» con zona configurada |
| Destinatario | Sí para enviar | Alias o `chat_id` | `TOOLS.md`; preguntar si falta o hay varios |
| Tipo de resumen | No | Diario, proyecto, reuniones o personalizado | Diario |
| Secciones | No | Lista de encabezados | Logros, pendientes, bloqueos y próximos pasos |
| Longitud | No | Breve, media o límite de caracteres | Breve, máximo 3500 caracteres |
| Tono | No | Directo, formal o personalizado | `SOUL.md` y `USER.md` |

Antes de preguntar, consulta únicamente el contexto pertinente:

- `AGENTS.md`: permisos para leer fuentes y realizar envíos externos.
- `IDENTITY.md`: firma o identidad, solo si el usuario la ha configurado y solicitado.
- `SOUL.md`: tono, privacidad y límites de representación.
- `USER.md`: nombre, zona horaria, idioma y preferencias del resumen.
- `TOOLS.md`: alias de Telegram, chats permitidos e integración disponible.

No infieras un destinatario a partir de una conversación reciente. No incluyas secretos, credenciales, datos privados irrelevantes ni información de una fuente no autorizada.

Si falta contenido, periodo o destinatario, pregunta solo por lo necesario. Si el usuario pide únicamente preparar el resumen, el destinatario no es obligatorio y no debes enviar nada.

## 3. ¿Cómo es un buen output?

El mensaje debe ser legible en Telegram y usar esta estructura cuando las secciones tengan contenido:

```text
Resumen — <periodo>

Logros
- <resultado concreto>

Pendientes
- <acción y responsable, si se conoce>

Bloqueos
- <bloqueo o "Ninguno informado">

Próximos pasos
- <acción concreta>
```

Para una preparación sin envío, devuelve la vista previa en el chat actual. Para un envío, el destino es el chat de Telegram confirmado y la respuesta debe incluir destinatario, periodo y `message_id` devuelto por Telegram.

La ejecución funciona cuando la API o herramienta de mensajería confirma el `chat_id` y el `message_id`, y el contenido confirmado coincide con el enviado.

No declares éxito si solo preparaste el texto, si falta la integración o si Telegram no confirmó el mensaje. Indica claramente «borrador no enviado» o el error recibido.

## Procedimiento

1. Determina si el usuario pidió preparar o enviar. No conviertas una petición de borrador en un envío.
2. Comprueba que las fuentes solicitadas son accesibles y están autorizadas. Termina con una lista de fuentes faltantes si no puedes leerlas.
3. Reúne solo hechos comprendidos en el periodo solicitado y conserva referencias internas suficientes para comprobarlos.
4. Redacta el resumen sin inventar avances, responsables ni fechas. Omite secciones vacías, excepto bloqueos cuando convenga confirmar que no se informaron.
5. Mantén el mensaje por debajo de 3500 caracteres. Si no cabe, prepara varias partes numeradas y avisa antes del envío.
6. Resuelve el destinatario mediante el alias exacto de `TOOLS.md` o un `chat_id` dado por el usuario. Si hay ambigüedad, pregunta.
7. Muestra la vista previa y solicita confirmación antes de enviar. Omite esta confirmación solo si `AGENTS.md` o `USER.md` autoriza explícitamente ese resumen periódico y ese destinatario.
8. Construye una clave de deduplicación con destinatario, tipo de resumen y periodo. Comprueba si ya se envió antes de continuar.
9. Envía una sola vez mediante la herramienta de Telegram disponible y conserva el identificador de respuesta.
10. Devuelve la confirmación definida. Si el estado del envío es incierto, no reintentes automáticamente.

## Casos de aceptación

| Caso | Entrada | Resultado esperado |
|---|---|---|
| Normal | Fuentes, periodo y chat válidos | Envía una vez y devuelve `message_id` |
| Solo borrador | Fuentes y periodo, sin orden de envío | Muestra la vista previa y no usa Telegram |
| Incompleto | Falta el destinatario para un envío | Pregunta por él y no envía |
| Duplicado | El mismo resumen ya fue enviado | Informa el envío existente y no repite |
| Fallo externo | Telegram rechaza el mensaje | Informa el error y conserva el borrador |
