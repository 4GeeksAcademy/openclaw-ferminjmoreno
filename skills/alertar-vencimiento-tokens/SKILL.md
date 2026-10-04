---
name: "alertar-vencimiento-tokens"
description: "Revisar tokens MCP (Zapier) y alertar si están próximos a vencer o ya vencieron, con pasos para renovarlos."
---

# Alertar vencimiento de tokens MCP

Cuando el usuario pida revisar el estado de los tokens, verificar si los MCP
siguen funcionando, o ante sospecha de que Zapier/Calendar/Google dejó de
responder por autenticación.

## ¿Qué hace?

Lee `~/.mcporter/credentials.json` y revisa el campo `expires_at` de cada
servidor MCP registrado. Si falta el archivo o no hay servidores, lo indica.

## Flujo

1. Leer `~/.mcporter/credentials.json`.
2. Por cada servidor con tokens, calcular tiempo restante hasta `expires_at`.
3. Clasificar:
   - 🟢 **Vigente** — quedan más de 30 minutos
   - 🟡 **Próximo a vencer** — quedan entre 5 y 30 minutos
   - 🔴 **Vencido** — ya expiró o no hay token
4. Si hay refresh token disponible, informar que se puede renovar automáticamente.
5. Mostrar resumen al usuario.

## Output

```
🔍 Estado de tokens MCP

zapier (https://mcp.zapier.com/api/v1/connect)
  Estado: 🟢 Vigente | 🟡 Próximo a vencer | 🔴 Vencido
  Expira: 2026-10-04 01:27 UTC
  Quedan: 55 min
  Refresh: ✅ disponible

📋 Para renovar manualmente:
  1. mcporter auth zapier --reset --no-browser
  2. Abrir el URL OAuth en el navegador
  3. Copiar el code= del callback y pasarlo al agente
```

## Cómo renovar

Si el token ya venció, el agente puede ejecutar el flujo de renovación:

1. `mcporter auth <server> --reset --no-browser` (imprime URL)
2. Usuario abre URL en navegador y autoriza
3. Usuario copia el `code=` del callback
4. Agente intercambia el code por tokens nuevo vía API
5. Actualiza `credentials.json`
6. Verifica con `mcporter list <server> --schema`

Si hay refresh token, se puede intentar renovar automáticamente antes de
pedir intervención del usuario.

## Notas

- No almacenar tokens ni credenciales en este archivo.
- El token de Zapier expira cada 3600s (1h), renovable vía refresh token.
- El refresh token está disponible en `~/.mcporter/credentials.json`.
