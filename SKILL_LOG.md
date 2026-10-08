# SKILL_LOG.md — Bitácora de Skills BreatheCode API

> Bitácora de diseño, conversaciones y resultados de prueba de cada skill construida para interactuar con la API de 4Geeks Academy (BreatheCode).

---

## Historial de Skills

- [Skill 1: Autenticación](#skill-1-autenticación)
- [Skill 2: Obtener mis Proyectos](#skill-2-obtener-mis-proyectos)
- [Skill 3: Mis Trabajos Pendientes](#skill-3-mis-trabajos-pendientes)
- [Skill 4: Resumen de Progreso](#skill-4-resumen-de-progreso)
- [Skill 5: Propuesta Pendiente](#skill-5-propuesta-pendiente)
- [Skill 6: Propuesta Pendiente](#skill-6-propuesta-pendiente)

---

## Skill 7: Eventos y Clases en Vivo (A)

### Prompt original
> "A — Eventos y Clases en Vivo"

### Descripción
Skill que consulta eventos generales de 4Geeks Academy (charlas, webinars, open houses) y las clases en vivo programadas para el cohorte activo.

**Endpoints utilizados:**
- `GET /v1/events/me` — Eventos disponibles para el estudiante
- `GET /v1/events/me/event/liveclass` — Clases en vivo del cohorte

**Archivos creados:**
- `/root/.openclaw/workspace/skills/eventos-clases/SKILL.md`

### Prueba de funcionamiento

```bash
$ breathecode_api GET "/v1/events/me"
```
**Resultado:** ✅ 2 eventos activos encontrados. Ambos son "Miedos, Mitos y Realidades" (versiones España y LATAM), activos, con enlace Google Meet, para el 14-oct-2026.

```bash
$ breathecode_api GET "/v1/events/me/event/liveclass"
```
**Resultado:** ✅ 56 clases totales, 31 clases futuras (sin contar feriados). Próxima clase: 2026-10-09 para latam-aie-pt-5.

---

## Skill 8: Certificados (C)

### Prompt original
> "C — Certificados"

### Descripción
Skill que consulta los certificados emitidos al estudiante, mostrando especialidad, academia, cohorte, fechas y URLs de descarga.

**Endpoints utilizados:**
- `GET /v1/certificate/me` — Certificados del estudiante autenticado

**Archivos creados:**
- `/root/.openclaw/workspace/skills/certificados/SKILL.md`

### Nota técnica
- `/v1/certificate/me` funciona **sin** header `Academy` (solo token).
- `/v1/certificate/` requiere permiso `read_certificate` que el rol estudiante no tiene → 403.

### Prueba de funcionamiento

```bash
$ breathecode_api GET "/v1/certificate/me"
```
**Resultado:** ✅ 1 certificado:
- **Especialidad:** Basic personal assistants with Openclaw
- **Academia:** 4Geeks Latam
- **Instructor:** Héctor Chocobar Torrejón
- **Emitido:** 2026-08-29
- **PDF:** certificate.4geeks.com/pdf/f555924d7b92ffc82627890998c739c8ec888748

---

## Conversaciones Previas (Fundación)

### 2026-10-08 — Descubrimiento de la API

**Contexto:** Fer proporcionó la URL base `https://breathecode.herokuapp.com` y credenciales de login. Se exploraron los endpoints existentes.

**Acciones:**
- Se descubrió que la API tiene Swagger UI en `/swagger/` y ReDoc en `/redoc/`
- Se encontró el repositorio fuente `breatheco-de/apiv2` en GitHub
- Se extrajo el archivo `breathecode/urls.py` que reveló la estructura completa de la API:
  - `/v1/auth/` — Autenticación
  - `/v1/admissions/` — Cohortes, academias, sílabos
  - `/v1/assignment/` — Tareas y proyectos
  - `/v1/events/` — Eventos
  - `/v1/mentorship/` — Mentorías
  - `/v1/certificate/` — Certificados
  - `/v1/media/` — Multimedia
  - `/v1/registry/` — Assets (contenido educativo)
  - `/v1/feedback/` — Encuestas y reviews
  - `/v1/messaging/` (alias `/v1/notify/`) — Notificaciones
  - `/v1/payments/` — Pagos y planes
  - `/v1/freelance/` — Freelance
  - `/v1/monitoring/` — Monitoreo
  - `/v1/provisioning/` — Aprovisionamiento
  - `/v1/commission/` — Comisiones
  - `/v1/talent/` — Desarrollo de talento

**Resultado:** Se generó el archivo `breathecode-api-endpoints.docx` con el mapa completo de ~350 endpoints.

### 2026-10-08 — Configuración de Token y Credenciales

**Contexto:** Fer indicó que el token debía guardarse en `.env` bajo `TOKEN_4GEEKS`.

**Problema identificado:** El token expira cada ~7 días. Sin credenciales no se puede refrescar automáticamente.

**Solución adoptada:**
- `TOKEN_4GEEKS` → `/root/.openclaw/workspace/.env` (token actual)
- `EMAIL_4GEEKS` + `PASSWORD_4GEEKS` → `/root/.openclaw/workspace/.env.credentials` (archivo local, chmod 600, ignorado por git)
- Mecanismo: antes de cada consulta, validar token; si expiró, hacer login y refrescar

**Autorización:** Fer autorizó explícitamente guardar email y password en `.env.credentials`.

### 2026-10-08 — Descubrimiento de Academy ID y Cohort ID

**Contexto:** Fer preguntó si el `academy_id` se obtenía de `profile_academy[0]`.

**Hallazgo:** Los endpoints `/v1/admissions/user/me` y `/v1/auth/user/me` NO tienen campo `profile_academy`. Los datos relevantes están en:
- `roles[]` → lista de academias donde el usuario tiene rol (ids: 2, 6, 7)
- `cohorts[]` → lista de cohortes del estudiante

**Datos del estudiante:**
- `user_id: 557`
- `first_name: Fermin`, `last_name: Moreno`
- `email: ferminjmoreno@gmail.com`
- `github: ferminjmoreno`

**Academias:**
| academy_id | Nombre | Slug | Timezone |
|---|---|---|---|
| 2 | 4Geeks Caracas | caracas-venezuela | America/Caracas |
| 6 | 4Geeks Madrid | madrid-spain | Europe/Madrid |
| 7 | 4Geeks Latam | online | America/New_York |

**Cohorte activo actual:**
- `cohort_id: 1809`
- `slug: latam-aie-pt-5`
- `stage: STARTED` (el único cohorte con stage STARTED)
- `educational_status: ACTIVE`
- `academy_id: 7` (4Geeks Latam)

---

## Skill 1: Autenticación

### Prompt original
> "Quiero darte la habilidad de conectarte a mi cuenta de 4Geeks usando mi token de estudiante, sin que tenga que desarrollar código de mi parte."

### Prompt natural (traducción a diseño)
> "Crea una skill que gestione automáticamente la autenticación contra la API de BreatheCode: login con email+password, almacenamiento seguro del token, validación de expiración, y refresco automático cuando el token esté vencido. Debe permitir que otras skills hagan llamadas autenticadas sin repetir lógica."

### Descripción
Skill de infraestructura que proporciona autenticación automática contra la API de BreatheCode (`https://breathecode.herokuapp.com`).

**Endpoints utilizados:**
- `POST /v1/auth/login/` — Obtener token (email + password)
- `GET /v1/auth/user/me/` — Validar que el token es activo

**Variables de entorno:**
- `TOKEN_4GEEKS` — Token JWT actual (en `.env`)
- `EMAIL_4GEEKS` — Email del estudiante (en `.env.credentials`)
- `PASSWORD_4GEEKS` — Contraseña del estudiante (en `.env.credentials`)

### Archivos creados
- `/root/.openclaw/workspace/.env` — Token activo
- `/root/.openclaw/workspace/.env.credentials` — Credenciales (protegido)
- `/root/.openclaw/workspace/lib/breathecode.sh` — Biblioteca de funciones

### Prueba de funcionamiento

```bash
# Login exitoso
$ curl -s -X POST "https://breathecode.herokuapp.com/v1/auth/login/" \
  -H "Content-Type: application/json" \
  -d '{"email":"ferminjmoreno@gmail.com","password":"***"}'

# Respuesta:
{
    "token": "916eb1…2cff",
    "user_id": 557,
    "email": "ferminjmoreno@gmail.com",
    "expires_at": "2026-10-15T03:27:23.336094Z"
}

# Validación de token activo
$ curl -s -X GET "https://breathecode.herokuapp.com/v1/auth/user/me" \
  -H "Authorization: Token 916eb1…2cff"

# Respuesta: datos completos del usuario (id, email, profile, roles, permissions, settings)
```

**Resultado: ✅ Operativo.** Token generado, guardado en `.env`, expira el 2026-10-15. Renovación automática implementada.

---

## Skill 2: Obtener mis Proyectos

### Prompt original
> "Skill de obtener mis proyectos"

### Prompt natural (traducción a diseño)
> "Crea una skill que consulte los proyectos finales (final projects) del estudiante autenticado en 4Geeks. Debe listar todos los proyectos asociados al cohorte activo, mostrando título, descripción, estado, fecha de entrega y URL del repositorio si existe."

### Descripción
Skill que obtiene los proyectos finales del estudiante desde el módulo de assignments.

**Endpoints utilizados:**
- `GET /v1/assignment/user/me/final_project` — Listar proyectos finales del estudiante

### Archivos creados
- `/root/.openclaw/workspace/skills/mis-proyectos/SKILL.md` — Definición de la skill

### Prueba de funcionamiento

```bash
$ . /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api GET "/v1/assignment/user/me/final_project" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Total: {len(d)} proyectos')"
```

**Resultado: ✅ Operativo.** El endpoint responde correctamente con una lista. Actualmente el estudiante tiene **0 proyectos finales** (lista vacía). La skill está lista para cuando tenga proyectos creados.

---

## Skill 3: Mis Trabajos Pendientes

### Prompt original
> "Skill de mis trabajos pendientes"

### Prompt natural (traducción a diseño)
> "Crea una skill que consulte las tareas (assignments) pendientes del estudiante en su cohorte activo. Debe mostrar tareas no entregadas, entregadas pero no revisadas, y las fechas límite correspondientes."

### Descripción
Skill que lista las tareas/assignments pendientes del estudiante.

**Endpoints utilizados:**
- `GET /v1/assignment/user/me/task` — Tareas del estudiante
- `GET /v1/assignment/academy/task` — Tareas (visión academia, con filtros)

### Archivos creados
- `/root/.openclaw/workspace/skills/trabajos-pendientes/SKILL.md`

### Prueba de funcionamiento

```bash
$ . /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api GET "/v1/assignment/user/me/task" | python3 -c "
import sys, json
d = json.load(sys.stdin)
total = len(d)
pendientes = len([t for t in d if t.get('task_status') == 'PENDING'])
entregados = len([t for t in d if t.get('task_status') == 'DELIVERED'])
aprobados = len([t for t in d if t.get('task_status') == 'APPROVED'])
print(f'Total: {total} | PENDING: {pendientes} | DELIVERED: {entregados} | APPROVED: {aprobados}')
"
```

**Resultado de prueba:**
- Total tareas: **244**
- PENDING: **120**
- DELIVERED: **0**
- APPROVED: **0**

**Resultado: ✅ Operativo.** 244 tareas obtenidas, 120 pendientes de entrega.

---

## Skill 4: Resumen de Progreso

### Prompt original
> "Skill de obtener mi resumen de progreso"

### Prompt natural (traducción a diseño)
> "Crea una skill que consolide el progreso académico del estudiante: porcentaje del bootcamp completado, módulos cursados, tareas entregadas vs pendientes, proyectos finalizados, certificaciones obtenidas, y estado general del cohorte."

### Descripción
Skill que genera un resumen consolidado del progreso del estudiante en su cohorte activo.

**Endpoints utilizados:**
- `GET /v1/admissions/user/me` — Datos del usuario y cohortes
- `GET /v1/assignment/user/me/task` — Tareas (para ratio entregado/pendiente)
- `GET /v1/assignment/user/me/final_project` — Proyectos finales
- `GET /v1/registry/me/completion` — Progreso de completitud
- `GET /v1/certificate/` — Certificados (requiere Academy header)

### Archivos creados
- `/root/.openclaw/workspace/skills/resumen-progreso/SKILL.md`

### Prueba de funcionamiento

```bash
$ . /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api GET "/v1/admissions/user/me"        # ✅ Responde
$ breathecode_api GET "/v1/assignment/user/me/task"   # ✅ Responde (244 tareas)
$ breathecode_api GET "/v1/assignment/user/me/final_project"  # ✅ Responde (0 proyectos)
$ breathecode_api POST "/v1/registry/me/completion"   # ⚠️ Requiere créditos (402)
```

**Resultado de prueba:**
- `/v1/admissions/user/me` ✅ — Datos del estudiante y cohortes
- `/v1/assignment/user/me/task` ✅ — 244 tareas
- `/v1/assignment/user/me/final_project` ✅ — 0 proyectos
- `/v1/registry/me/completion` ⚠️ — HTTP 402 (sin créditos para rigobot-api-test-completion)

**Resultado: ✅ Operativo** para los datos disponibles. El progreso de completitud requiere endpoint alternativo o que Fer tenga los créditos adecuados.

---

## Skill 5-6: Propuestas Skills Adicionales

### Candidatas a elegir (propuestas por Neo)

Fer pidió proponer 2 skills adicionales. Aquí están las 4 candidatas:

| # | Skill | Descripción | Endpoints |
|---|---|---|---|
| A | **🗓️ Eventos y Clases en Vivo** | Ver próximos eventos, clases en vivo programadas, unirse, check-in, feed iCal para Google Calendar | `/v1/events/me`, `/v1/events/academy/event`, `/v1/events/me/event/liveclass`, `/v1/ical/student/me` |
| B | **🧠 Mentorías** | Ver mentores disponibles, historial de sesiones agendadas, facturación de mentorías | `/v1/mentorship/user/me/session`, `/v1/mentorship/public/mentor`, `/v1/mentorship/user/me/bill` |
| C | **📜 Certificados** | Obtener y verificar certificados propios | `/v1/certificate/` (con header `Academy: 7`) |
| D | **📋 Feedback y Encuestas** | Ver encuestas pendientes de responder, historial de reviews, plataformas de review | `/v1/feedback/user/me/survey`, `/v1/feedback/academy/survey`, `/v1/feedback/review_platform` |

Elige 2 y las construyo.

---

## Notas Técnicas Generales

### Headers requeridos
- `Authorization: Token <token>` — Todas las llamadas autenticadas
- `Academy: <id>` — Algunos endpoints (certificate, media) requieren este header adicional
- `Accept: application/json` — Forzar respuesta JSON

### Token
- Vida útil: **~7 días** desde generación
- Renovación automática via `POST /v1/auth/login/`
- Guardado en `.env`, credenciales en `.env.credentials`

### Estudiante
- `user_id: 557`
- `cohort_id: 1809` (latam-aie-pt-5, stage STARTED)
- `academy_id: 7` (4Geeks Latam / online)
- `role: student`