---
name: programar-reunion
description: "Crear eventos de calendario validando datos, obteniendo aprobación y generando un evento verificable."
---

# Programar reunión

Cuando el usuario pida agendar, programar o crear una reunión/evento/cita. No
inventar datos faltantes — siempre preguntar antes de crear.

Actívala ante peticiones como «agenda una reunión», «crea una cita» o
«programa una llamada».

No la uses para consultar la agenda sin crear eventos, cancelar citas
existentes ni enviar invitaciones fuera de Calendar.

## Input del usuario

| Dato | Obligatorio | Formato | Fuente o valor por defecto |
|---|---|---|---|
| Título | Sí | Texto breve | Usuario |
| Fecha y hora de inicio | Sí | Fecha y hora inequívocas | Usuario |
| Duración o finalización | Sí | Minutos o fecha/hora | Usuario |
| Participantes | No | Lista de nombres y correos | Usuario |
| Zona horaria | Sí | Identificador IANA | `USER.md`; preguntar si está vacía |
| Calendario de destino | No | Nombre o ID | `TOOLS.md`; usar el principal si está declarado |
| Descripción | No | Texto | Usuario |
| Videollamada | No | Sí/No o proveedor | No crear salvo petición explícita |

Antes de preguntar, consulta únicamente el contexto pertinente:

- `AGENTS.md` → permisos, confirmaciones y límites operativos
- `IDENTITY.md` → nombre y tono del agente para la respuesta
- `SOUL.md` → estilo, privacidad y criterio de actuación
- `USER.md` → nombre, zona horaria y preferencias horarias declaradas
- `TOOLS.md` → cuenta, calendario e integraciones disponibles

Nunca supongas participantes, correos, fecha, hora, zona horaria ni calendario
de destino. No guardes tokens, credenciales ni enlaces privados en la skill o
en archivos versionados.

Si falta un dato obligatorio, pregunta solamente por los datos faltantes y no
crees el evento.

## Flujo

1. **Verificar herramienta** — comprueba que existe un Calendar con permisos
   de lectura y escritura. Termina con un borrador si no está disponible.
2. **Reunir datos** — título, inicio, duración/fin, zona horaria,
   participantes, descripción. Convierte fechas relativas a ISO-8601.
3. **Validar** — si algo obligatorio falta, preguntar. Si hay ambigüedad
   temporal, resolver antes de seguir.
4. **Consultar conflictos** — cuando sea posible, informa conflictos de
   horario sin cambiar la fecha por tu cuenta.
5. **Vista previa** — construye: título, inicio, fin, zona, participantes,
   calendario y videollamada. Muestra y pide confirmación.
6. **Verificar duplicado** — busca un evento equivalente en el mismo
   calendario e intervalo. Si existe, muestra el evento encontrado y no crees
   otro.
7. **Crear** — una sola vez con la herramienta disponible.
8. **Verificar** — vuelve a consultar el evento por su ID y compara campos
   con la vista previa.
9. **Confirmar** — responde con el formato definido.

## Output exitoso

Confirmación en el chat:

```
Reunión creada
Título: Revisión del proyecto
Fecha: 28 sep 2026, 10:00 America/Caracas
Duración: 45 min
Participantes: ana@ejemplo.com
ID: <id del evento>
```

## Manejo de errores

- Si **no hay calendario disponible** (Zapier caído, sin auth): entregar
  borrador y explicar por qué.
- Si el calendario **no confirma la creación**: no declarar éxito. Explicar
  error y conservar el borrador. No reintentar automáticamente.
- Si el usuario rechaza la vista previa: preguntar qué cambiar.
- Si **ya existe un evento equivalente**: devolver el existente sin crear
  otro.

## Notas

- No inventar participantes, correos, fechas ni zonas horarias.
- No asumir que el calendario está disponible — verificarlo.
- La zona horaria por defecto viene de `USER.md`.