---
name: programar-reunion
description: "Agenda o programa una reunión: valida los datos, pide confirmación, crea el evento en Calendar y verifica el resultado."
---

# Programar reunión

## 1. ¿Qué hace esta skill?

Cuando el usuario solicita agendar o programar una reunión, valida la información, obtiene aprobación y crea un único evento verificable en Calendar.

Actívala ante peticiones como «agenda una reunión», «crea una cita» o «programa una llamada».

No la uses para consultar la agenda sin crear eventos, cancelar citas existentes ni enviar invitaciones fuera de Calendar.

## 2. ¿Qué input necesita el agente?

| Dato | Obligatorio | Formato | Fuente o valor por defecto |
|---|---|---|---|
| Título | Sí | Texto breve | Usuario |
| Fecha y hora de inicio | Sí | Fecha y hora inequívocas | Usuario |
| Duración o finalización | Sí | Minutos o fecha y hora | Usuario |
| Participantes | No | Lista de nombres y correos | Usuario |
| Zona horaria | Sí | Identificador IANA | `USER.md`; preguntar si está vacía |
| Calendario de destino | No | Nombre o identificador | `TOOLS.md`; usar el principal solo si está declarado |
| Descripción | No | Texto | Usuario |
| Videollamada | No | Sí/No o proveedor | No crear salvo petición explícita |

Antes de preguntar, consulta únicamente el contexto pertinente:

- `AGENTS.md`: permisos, confirmaciones y límites operativos.
- `IDENTITY.md`: nombre y tono del agente para la respuesta.
- `SOUL.md`: estilo, privacidad y criterio de actuación.
- `USER.md`: nombre, zona horaria y preferencias horarias declaradas.
- `TOOLS.md`: cuenta, calendario e integración disponibles.

Nunca supongas participantes, correos, fecha, hora, zona horaria ni calendario de destino. No guardes tokens, credenciales ni enlaces privados en la skill o en archivos versionados.

Si falta un dato obligatorio, pregunta solamente por los datos faltantes y no crees el evento.

## 3. ¿Cómo es un buen output?

El resultado principal es un evento creado en Calendar. La respuesta al usuario debe incluir:

```text
Reunión creada
Título: <título>
Fecha: <fecha y hora con zona horaria>
Duración: <duración>
Participantes: <lista o "sin invitados">
Evento: <URL o identificador>
```

La ejecución funciona cuando Calendar devuelve un identificador y una consulta posterior confirma que título, horario, zona y participantes coinciden con la vista previa aprobada.

No declares éxito si solo generaste texto, si la herramienta no está configurada o si Calendar no confirmó el evento. En esos casos entrega un borrador y explica el dato o integración que falta.

## Procedimiento

1. Comprueba que existe una herramienta de Calendar con permisos de lectura y escritura. Termina con un borrador si no está disponible.
2. Reúne las entradas obligatorias y convierte el horario a la zona indicada. Termina cuando no haya fechas relativas ambiguas.
3. Consulta conflictos del usuario y, cuando sea posible, de los participantes. Informa los conflictos sin cambiar el horario por tu cuenta.
4. Construye una vista previa con título, inicio, final, zona, participantes, calendario y videollamada.
5. Solicita confirmación antes de crear el evento o invitar a terceros. Omite esta confirmación solo si `AGENTS.md` o `USER.md` contiene una autorización previa, explícita y aplicable.
6. Busca un evento equivalente en el mismo calendario e intervalo. Si existe, muestra el evento encontrado y no crees otro.
7. Crea el evento una sola vez con la herramienta disponible.
8. Vuelve a consultar el evento por su identificador y compara sus campos con la vista previa.
9. Devuelve la confirmación en el formato definido. Si la creación fue incierta, informa el error y no reintentes automáticamente.

## Casos de aceptación

| Caso | Entrada | Resultado esperado |
|---|---|---|
| Normal | Título, horario, duración y zona válidos | Crea, verifica y devuelve ID o URL |
| Incompleto | Falta la zona horaria | Pregunta por ella y no crea el evento |
| Duplicado | Ya existe un evento equivalente | Devuelve el existente y no crea otro |
| Fallo externo | Calendar rechaza la solicitud | Informa el error, no declara éxito ni reintenta |
