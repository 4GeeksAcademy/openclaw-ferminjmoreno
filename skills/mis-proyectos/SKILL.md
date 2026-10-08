# Skill: Mis Proyectos

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`

## Descripción

Consulta y lista los proyectos finales (*final projects*) del estudiante autenticado en 4Geeks Academy. Muestra título, descripción, estado, fecha de entrega y URL del repositorio.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| GET | `/v1/assignment/user/me/final_project` | Listar proyectos finales del estudiante |
| GET | `/v1/assignment/user/me/final_project/<id>` | Detalle de un proyecto específico |
| GET | `/v1/assignment/user/me/final_project/screenshot` | Capturas del proyecto |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Listar todos mis proyectos finales
breathecode_api_json GET "/v1/assignment/user/me/final_project"

# Ver un proyecto específico
breathecode_api_json GET "/v1/assignment/user/me/final_project/1"
```

## Campos del response

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | int | ID del proyecto |
| `title` | string | Título del proyecto |
| `description` | string | Descripción |
| `status` | string | Estado (DRAFT, IN_REVIEW, APPROVED, etc.) |
| `repository_url` | string | URL del repositorio GitHub |
| `created_at` | datetime | Fecha de creación |
| `updated_at` | datetime | Última actualización |
| `cohort` | object | Cohorte asociado |

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api_json GET "/v1/assignment/user/me/final_project"
```

**Resultado:** ✅ Pendiente de prueba final