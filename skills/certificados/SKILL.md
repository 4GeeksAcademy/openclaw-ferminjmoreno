# Skill: Certificados

**Versión:** 1.0.0  
**Dependencias:** `lib/breathecode.sh`

## Descripción

Consulta los certificados emitidos al estudiante. Muestra especialidad, fecha de emisión, academia, cohorte asociado, URL de preview y URL de descarga del PDF.

## Endpoints utilizados

| Método | Endpoint | Propósito |
|---|---|---|
| GET | `/v1/certificate/me` | Certificados del estudiante autenticado |

## Campos clave

| Campo | Descripción |
|---|---|
| `id` | ID del certificado |
| `status` | Estado del certificado (`PERSISTED`, `GENERATED`, etc.) |
| `status_text` | Descripción legible del estado |
| `specialty.name` | Nombre de la especialidad |
| `specialty.description` | Descripción de la especialidad |
| `specialty.syllabus.name` | Nombre del sílabo asociado |
| `specialty.duration_in_hours` | Duración en horas |
| `academy.name` | Nombre de la academia emisora |
| `cohort.name` | Nombre del cohorte asociado |
| `cohort.kickoff_date` | Fecha de inicio del cohorte |
| `user.first_name` | Nombre del estudiante |
| `user.last_name` | Apellido del estudiante |
| `signed_by` | Instructor que firmó el certificado |
| `signed_by_role` | Rol del firmante |
| `issued_at` | Fecha de emisión |
| `preview_url` | URL de preview del certificado (imagen) |
| `pdf_url` | URL de descarga del certificado en PDF |
| `layout.name` | Layout usado |
| `expires_at` | Fecha de expiración (null = no expira) |

## Modo de uso

```bash
source /root/.openclaw/workspace/lib/breathecode.sh

# Listar certificados
breathecode_api_json GET "/v1/certificate/me"
```

## Ejemplos prácticos

### Resumen de certificados

```bash
source /root/.openclaw/workspace/lib/breathecode.sh
breathecode_api GET "/v1/certificate/me" | python3 -c "
import sys, json

certs = json.load(sys.stdin)
print(f'🏅 Certificados ({len(certs)}):')
for c in certs:
    print(f'  • {c[\"specialty\"][\"name\"]}')
    print(f'    Academia: {c[\"academy\"][\"name\"]}')
    print(f'    Cohorte: {c[\"cohort\"][\"name\"]}')
    print(f'    Estado: {c[\"status\"]} ({c[\"status_text\"]})')
    print(f'    Firmado por: {c[\"signed_by\"]} ({c[\"signed_by_role\"]})')
    print(f'    Emitido: {c[\"issued_at\"][:10]}')
    print(f'    🔍 Preview: {c[\"preview_url\"]}')
    print(f'    📄 PDF: {c[\"pdf_url\"]}')
    print()
"
```

### Descargar certificado PDF

```bash
source /root/.openclaw/workspace/lib/breathecode.sh
TOKEN=$(_breathecode_get_token)

# Obtener URL del PDF
PDF_URL=$(breathecode_api GET "/v1/certificate/me" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d[0]['pdf_url'] if d else '')
")

# Descargar
if [ -n "$PDF_URL" ]; then
    curl -o "certificado-4geeks.pdf" "$PDF_URL"
    echo "✅ Descargado: certificado-4geeks.pdf"
fi
```

## Notas

- El endpoint `/v1/certificate/me` no requiere el header `Academy` — funciona solo con el token de autenticación.
- El endpoint general `/v1/certificate/` requiere permisos `read_certificate` para la academia, que el rol de estudiante no tiene.
- Los certificados con estado `PERSISTED` están en cola para generación de PDF; una vez generados cambian a otro estado.
- `pdf_url` apunta a `certificate.4geeks.com` — dominio público para compartir o descargar.

## Prueba

```bash
$ source /root/.openclaw/workspace/lib/breathecode.sh
$ breathecode_api GET "/v1/certificate/me" | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'{len(d)} certificados encontrados')"
```

**Resultado:** ✅ Pendiente de prueba final