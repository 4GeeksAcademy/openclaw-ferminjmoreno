# Skill: Resumen de Progreso

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`

## Descripción

Genera un resumen consolidado del progreso académico del estudiante en su cohorte activo: porcentaje del bootcamp completado, módulos cursados, ratio de tareas entregadas vs pendientes, proyectos finalizados y certificaciones obtenidas.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| GET | `/v1/admissions/user/me` | Datos del usuario y lista de cohortes |
| GET | `/v1/assignment/user/me/task` | Tareas (para calcular ratio entregado/pendiente) |
| GET | `/v1/assignment/user/me/final_project` | Proyectos finales |
| GET | `/v1/registry/me/completion` | Progreso de completitud de assets |
| GET | `/v1/certificate/` | Certificaciones (con header Academy) |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Obtener resumen completo
breathecode_api_json GET "/v1/admissions/user/me"
breathecode_api_json GET "/v1/assignment/user/me/task"
breathecode_api_json GET "/v1/assignment/user/me/final_project"
breathecode_api_json GET "/v1/registry/me/completion"
```

## Datos que consolida

| Dato | Fuente |
|---|---|
| Nombre, email, avatar | `/v1/admissions/user/me` |
| Cohorte activo y stage | `/v1/admissions/user/me → cohorts[]` |
| Total de tareas | `/v1/assignment/user/me/task → count` |
| Tareas entregadas vs pendientes | `/v1/assignment/user/me/task → status` |
| Proyectos finales y estado | `/v1/assignment/user/me/final_project` |
| Porcentaje de completitud | `/v1/registry/me/completion` |
| Certificaciones | `/v1/certificate/` |

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh

# Obtener data fuente
$ tasks=$(breathecode_api GET "/v1/assignment/user/me/task")
$ projects=$(breathecode_api GET "/v1/assignment/user/me/final_project")
$ profile=$(breathecode_api GET "/v1/admissions/user/me")
$ completion=$(breathecode_api GET "/v1/registry/me/completion")

# Consolidar
$ python3 -c "
import json
print('=== RESUMEN DE PROGRESO ===')
print(f'Tareas: ... pendientes, ... entregadas')
print(f'Proyectos: ...')
print(f'Completitud: ...%')
"
```

**Resultado:** ✅ Pendiente de prueba final