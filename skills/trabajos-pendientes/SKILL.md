# Skill: Trabajos Pendientes

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`

## Descripción

Lista y filtra las tareas (*assignments*) pendientes del estudiante en su cohorte activo. Muestra tareas no entregadas, entregadas pero no revisadas, y fechas límite.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| GET | `/v1/assignment/user/me/task` | Tareas del estudiante autenticado |
| GET | `/v1/assignment/user/me/task/<id>` | Detalle de una tarea específica |
| GET | `/v1/assignment/task/<id>/deliver` | Entregar tarea |
| GET | `/v1/assignment/task/<id>/attachment` | Adjuntos de la tarea |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Listar todas mis tareas
breathecode_api_json GET "/v1/assignment/user/me/task"

# Ver tarea específica
breathecode_api_json GET "/v1/assignment/user/me/task/123"
```

## Filtros de estado

| Estado | Significado |
|---|---|
| `PENDING` | No entregada, dentro del plazo |
| `DELIVERED` | Entregada, pendiente de revisión |
| `APPROVED` | Aprobada |
| `REJECTED` | Rechazada, requiere corrección |
| `EXPIRED` | No entregada, fuera del plazo |

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api_json GET "/v1/assignment/user/me/task"
```

**Resultado:** ✅ Pendiente de prueba final