# Diseñador de habilidades

Esta guía convierte una idea en una especificación que un agente autónomo puede ejecutar y validar. Se completa una ficha por cada skill.

## Cómo puedo apoyarte

1. Entrevistarte con las preguntas de la ficha y detectar información ambigua o faltante.
2. Comprobar primero si una skill, integración o herramienta existente ya resuelve el caso.
3. Redactar el contrato de entrada, salida, permisos y errores.
4. Crear la estructura y las instrucciones de la skill cuando el contrato esté aprobado.
5. Probarla con un caso normal, uno incompleto y uno que falle.

## Ficha de diseño

### 1. Identidad

- **Nombre:** verbo y objeto, por ejemplo `programar-reunion`.
- **Descripción en una frase:** «Cuando [disparador], la skill [acción] para [resultado]».
- **Disparadores:** frases, eventos o condiciones que deben activarla.
- **Fuera de alcance:** acciones parecidas que no debe realizar.

### 2. Entradas

Describe cada dato explícitamente. No obligues al usuario a repetir información estable que ya exista en la configuración.

| Dato | Obligatorio | Formato | Fuente | Valor por defecto | Ejemplo |
|---|---|---|---|---|---|
|  | Sí/No | texto, fecha ISO, URL, archivo… | usuario, evento o configuración |  |  |

Marca además:

- Qué datos pueden inferirse y qué debe preguntarse siempre.
- Qué información es sensible y nunca debe guardarse en archivos versionados.
- Qué hacer si falta un dato: preguntar, usar un valor seguro o detenerse.

### 3. Contexto que el agente ya conoce

La skill puede consultar estos cinco archivos, pero no debe inventar valores que estén vacíos:

| Archivo | Qué aporta |
|---|---|
| `AGENTS.md` | Reglas operativas, límites, memoria y comportamiento general. |
| `IDENTITY.md` | Nombre, identidad, tono y presentación del agente. |
| `SOUL.md` | Valores, criterio, estilo y límites de actuación. |
| `USER.md` | Nombre, zona horaria, preferencias y contexto del usuario. |
| `TOOLS.md` | Recursos, dispositivos, alias e integraciones específicas del entorno. |

Indica qué campos concretos necesita esta skill y qué hará si aún no están configurados.

### 4. Resultado esperado

- **Contenido:** qué debe producir exactamente.
- **Formato:** Markdown, JSON, texto breve, evento, documento, etc.
- **Destino:** archivo, Google Docs, Calendar, Telegram u otro sistema.
- **Confirmación:** evidencia que devolverá al usuario, como URL, identificador o resumen.
- **Criterio de éxito:** condición observable y verificable.
- **Criterio de fallo:** cómo reconocer un resultado parcial o incorrecto.

Una salida no está completa solo porque el texto fue generado. Si el objetivo es crear un evento, el éxito requiere que Calendar confirme su creación y que la skill devuelva su identificador o enlace.

### 5. Flujo y autonomía

1. Validar las entradas y completar solo los valores que puedan inferirse con seguridad.
2. Mostrar una vista previa cuando la acción sea externa, pública, destructiva o difícil de revertir.
3. Solicitar confirmación antes de ejecutar esas acciones, salvo autorización explícita previa.
4. Ejecutar una sola vez y evitar duplicados mediante un identificador o una comprobación previa.
5. Verificar el resultado en el sistema de destino.
6. Informar qué ocurrió y qué requiere intervención si hubo un fallo.

### 6. Herramientas y dependencias

- **Herramientas necesarias:**
- **Cuentas o permisos:**
- **Integración existente evaluada:**
- **Alternativa si no está disponible:**
- **Datos que se pueden leer:**
- **Acciones que se pueden escribir o enviar:**

### 7. Casos de aceptación

Define al menos estos tres casos antes de implementar:

| Caso | Entrada | Comportamiento esperado | Evidencia |
|---|---|---|---|
| Normal | Datos completos | Ejecuta y verifica | ID, URL o contenido comprobable |
| Incompleto | Falta un dato esencial | Pregunta solo por ese dato | No ejecuta antes de recibirlo |
| Fallo externo | El destino rechaza la acción | No declara éxito y explica el siguiente paso | Error concreto, sin duplicados |

## Cuestionario breve

Copia y responde este bloque para proponer una skill:

```markdown
Nombre tentativo:
Cuando ocurre:
Debe hacer:
Para conseguir:

Datos que le daré:
Datos que puede tomar de la configuración:
Datos que nunca debe asumir:

Resultado esperado:
Formato y destino:
Evidencia de éxito:

¿Puede actuar sin confirmar?:
Acciones que siempre requieren confirmación:
Qué debe hacer si falta información o falla una herramienta:
```

## Ejemplo resumido

### Programar una reunión

- **Descripción:** cuando el usuario proporciona participantes, tema y opciones horarias, crea una reunión en Calendar en la zona horaria configurada.
- **Entradas:** participantes, asunto, duración y rango de fechas; la zona horaria puede provenir de `USER.md` si está definida.
- **No asumir:** participantes, fecha definitiva ni calendario de destino.
- **Salida:** evento confirmado en Calendar y respuesta con título, fecha, asistentes y enlace.
- **Autonomía:** muestra una vista previa y pide confirmación antes de invitar a terceros.
- **Éxito:** Calendar devuelve un identificador y el evento consultado coincide con la vista previa.
- **Fallo:** conserva el contexto, muestra el error y no vuelve a crear el evento automáticamente.

## Lista de preparación

La skill está lista para implementarse cuando:

- [ ] Su propósito cabe en una frase y tiene límites claros.
- [ ] Cada entrada tiene fuente, formato y regla cuando falta.
- [ ] Distingue datos configurados de datos todavía desconocidos.
- [ ] La salida tiene destino y evidencia verificable.
- [ ] Los efectos externos y permisos están identificados.
- [ ] Evita ejecuciones duplicadas.
- [ ] Existen casos de aceptación normal, incompleto y fallido.
