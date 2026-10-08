# Skill: authenticate-4geeks

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`, `.env`, `.env.credentials`

## Descripción

Gestiona la autenticación automática contra la API de BreatheCode (`https://breathecode.herokuapp.com`). Proporciona login con email+password, almacenamiento seguro del token, validación de expiración y refresco automático.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| POST | `/v1/auth/login/` | Obtener token con email + password |
| GET | `/v1/auth/user/me` | Validar que el token está activo |

## Flujo

1. Leer `TOKEN_4GEEKS` de `.env`
2. Consultar `/v1/auth/user/me` → si responde 200, el token es válido
3. Si falla → leer credenciales de `.env.credentials` → `POST /v1/auth/login/` → guardar nuevo token en `.env`
4. Ejecutar la llamada original con el token vigente

## Variables de entorno

| Archivo | Variable | Propósito |
|---|---|---|
| `.env` | `TOKEN_4GEEKS` | Token JWT activo |
| `.env.credentials` | `EMAIL_4GEEKS` | Email del estudiante |
| `.env.credentials` | `PASSWORD_4GEEKS` | Contraseña del estudiante |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Consulta autenticada automática
breathecode_api GET "/v1/auth/user/me"

# Forzar refresh manual (si se necesita)
source /root/.openclaw/workspace/lib/breathecode.sh
_breathecode_refresh_token
```

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api_json GET "/v1/auth/user/me"
{
    "id": 557,
    "email": "ferminjmoreno@gmail.com",
    "first_name": "Fermin",
    ...
    "roles": [...],
    "permissions": [...]
}
```

**Resultado: ✅ Operativo**