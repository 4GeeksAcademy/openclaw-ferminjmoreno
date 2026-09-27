# TOOLS.md - Notas locales

Este archivo registra nombres y decisiones del entorno. Nunca debe contener contraseñas, tokens ni credenciales.

## Google Calendar

- **Servicio:** Google Calendar.
- **Calendario de destino:** calendario principal.
- **Cuenta:** pendiente de configurar fuera del repositorio.
- **Proveedor de videollamada:** no definido; crear enlace solo si Fermin lo solicita.
- **Política:** mostrar una vista previa y solicitar confirmación antes de crear un evento.
- **Verificación:** conservar el identificador o URL y volver a consultar el evento creado.

## Telegram

- **Destino autorizado:** alias `startbot`.
- **Identificador del chat:** pendiente de verificar en la integración; no guardarlo aquí si es sensible.
- **Frecuencia:** máximo un resumen diario.
- **Ventana de envío:** entre 07:00 y 08:00, zona `America/Caracas`.
- **Fuentes:** información autorizada sobre estudiantes de 4Geeks Academy; Fermin las proporcionará más adelante.
- **Política:** el envío diario puede realizarse sin confirmación adicional cuando el destino y las fuentes estén configurados y verificados.
- **Verificación:** conservar el `message_id` y el `chat_id` devueltos por Telegram.

## Entorno

- El workspace se ejecuta en un GitHub Codespace.
- La conexión entre Zapier MCP y OpenClaw se documenta en `openclaw-connection/Configuracion.md`.
- En la revisión del 27 de septiembre de 2026, `openclaw` y `gog` no estaban instalados en este contenedor.
- Antes de ejecutar una skill, comprobar la herramienta real disponible y no asumir que una integración está activa.

## Related

- [Agent workspace](/concepts/agent-workspace)
