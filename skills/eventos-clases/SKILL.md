# Skill: Eventos y Clases en Vivo

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`

## Descripción

Consulta eventos generales de 4Geeks Academy (charlas, webinars, open houses) y las clases en vivo programadas para tu cohorte activo. Muestra fecha, hora, enlace de reunión, descripción y estado.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| GET | `/v1/events/me` | Eventos disponibles para el estudiante (charlas, webinars) |
| GET | `/v1/events/me/event/liveclass` | Clases en vivo del cohorte activo |

## Campos clave

### Eventos (`/v1/events/me`)
| Campo | Descripción |
|---|---|
| `id` | ID del evento |
| `title` | Título del evento |
| `starting_at` | Fecha/hora de inicio (ISO 8601) |
| `ending_at` | Fecha/hora de fin |
| `description` | Descripción del evento |
| `live_stream_url` | Enlace a la reunión (Google Meet, etc.) |
| `status` | `ACTIVE`, `DRAFT`, `CANCELLED` |
| `event_type.name` | Tipo de evento (Coding with AI, etc.) |
| `tags` | Etiquetas del evento |
| `is_public` | Si es público o interno |
| `host_user` | Datos del organizador (nombre, avatar, bio) |
| `banner` | URL del banner/imagen del evento |
| `recording_url` | URL de la grabación (si está disponible) |

### Clases en vivo (`/v1/events/me/event/liveclass`)

| Campo | Descripción |
|---|---|
| `id` | ID de la clase |
| `starting_at` | Fecha/hora de inicio |
| `ending_at` | Fecha/hora de fin |
| `remote_meeting_url` | Enlace a la clase (Google Meet) |
| `cohort.slug` | Slug del cohorte |
| `cohort.name` | Nombre del cohorte |
| `is_holiday` | Si es un día festivo (sin clase) |
| `is_skipped` | Si la clase fue saltada |
| `started_at` | Cuándo empezó realmente (null si no ha empezado) |
| `ended_at` | Cuándo terminó realmente |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Próximos eventos disponibles
breathecode_api_json GET "/v1/events/me"

# Próximas clases en vivo del cohorte
breathecode_api_json GET "/v1/events/me/event/liveclass"
```

## Ejemplos prácticos

### Ver próximos eventos (ordenados por fecha)

```bash
source /root/.openclaw/workspace/lib/breathecode.sh
breathecode_api GET "/v1/events/me" | python3 -c "
import sys, json
from datetime import datetime

events = json.load(sys.stdin)
ahora = datetime.now().strftime('%Y-%m-%d')

# Filtrar eventos activos
activos = [e for e in events if e.get('status') == 'ACTIVE']

# Ordenar por fecha de inicio
activos.sort(key=lambda e: e.get('starting_at', ''))

print(f'📅 Próximos eventos ({len(activos)} activos):')
for e in activos:
    inicio = e.get('starting_at','')[:16].replace('T', ' ')
    print(f'  • {inicio} — {e[\"title\"]}')
    if e.get('live_stream_url'):
        print(f'    Enlace: {e[\"live_stream_url\"]}')
    if e.get('description'):
        print(f'    {e[\"description\"][:100]}...')
    print()
"
```

### Ver próximas clases en vivo

```bash
source /root/.openclaw/workspace/lib/breathecode.sh
breathecode_api GET "/v1/events/me/event/liveclass" | python3 -c "
import sys, json
from datetime import datetime

clases = json.load(sys.stdin)
hoy = datetime.now()

print(f'📚 Próximas clases en vivo:')
for c in clases:
    inicio = c.get('starting_at','')
    if not inicio or inicio < hoy.strftime('%Y-%m-%d'):
        continue
    if c.get('is_holiday') or c.get('is_skipped'):
        continue
    inicio_fmt = inicio[:16].replace('T', ' ')
    fin = c.get('ending_at','')[:16].replace('T', ' ')
    print(f'  • {inicio_fmt} → {fin}')
    print(f'    Cohorte: {c[\"cohort\"][\"name\"]}')
    print(f'    Enlace: {c[\"remote_meeting_url\"]}')
    print()
"
```

## Filtros útiles

| Situación | Comando |
|---|---|
| Solo eventos activos | `.status == 'ACTIVE'` |
| Eventos con enlace | `.live_stream_url != null` |
| Clases de los próximos 7 días | `.starting_at` entre hoy y hoy+7d |
| Clases no realizadas (futuras) | `.started_at == null` |
| Solo clases donde hay clase (no feriado) | `.is_holiday == false` |

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh

# Eventos disponibles
$ breathecode_api GET "/v1/events/me" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'{len(d)} eventos encontrados')"

# Clases en vivo
$ breathecode_api GET "/v1/events/me/event/liveclass" | python3 -c "import sys,json; d=json.load(sys.stdin); futuras=[c for c in d if c.get('starting_at','')>'2026-10-08']; print(f'{len(futuras)} clases futuras de {len(d)} totales')"
```

**Resultado:** ✅ Pendiente de prueba final