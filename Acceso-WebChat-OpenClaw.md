# Acceso al WebChat de OpenClaw desde el desktop

## Resultado comprobado

El formulario del WebChat se abrió desde el navegador del desktop y se pudo entrar. OpenClaw corre en la VPS. Los comandos SSH de este procedimiento se ejecutan desde el desktop; Codespaces no interviene en la conexión a la VPS.

Para esta actividad se mantuvieron dos túneles SSH porque atendían flujos distintos y en direcciones opuestas:

- El túnel inverso `-R` del puerto `46633` estaba destinado al flujo separado de Zapier: abre el puerto `46633` en la VPS y reenvía las conexiones a `127.0.0.1:46633` en el desktop. No lleva al Gateway `18789` y no abre el WebChat. El historial confirma el destino del reenvío, pero no que hubiera un servicio respondiendo allí.
- El túnel local `-L` del puerto `18789` conecta el navegador del desktop con el Gateway `127.0.0.1:18789` de la VPS. Este fue el túnel que permitió abrir el WebChat en `http://localhost:18789`.

Se dejaron ambos activos para conservar el flujo de Zapier mientras se abría el WebChat. No están encadenados: cada túnel tiene su propio puerto, destino y propósito. Para el WebChat, el reenvío determinante es `-L` en `18789`.

## Procedimiento

1. En la VPS, abre el `openclaw.json` que está usando el Gateway. No confundas ese archivo con una copia local del desktop. Comprueba que el puerto del Gateway sea `18789` y localiza la clave raíz `gateway`.

    La ruta exacta de la opción es:

    ```text
    gateway.controlUi.allowedOrigins
    ```

    `controlUi` es un objeto dentro de `gateway`; `allowedOrigins` es una lista dentro de `controlUi`. No agregues `allowedOrigins` directamente a `gateway`.

    Esta estructura mínima muestra los niveles correctos, pero no representa el contenido completo de tu archivo ni debe pegarse encima de la configuración existente:

    ```json
    {
       "gateway": {
          "controlUi": {
             "allowedOrigins": [
                "http://localhost:18789"
             ]
          }
       }
    }
    ```

    Integra el origen según el estado real del archivo:

    - Si ya existen `gateway`, `controlUi` y `allowedOrigins`, agrega `"http://localhost:18789"` como elemento de la lista. Conserva los demás orígenes y evita duplicarlo.
    - Si existe `gateway.controlUi`, pero no `allowedOrigins`, agrega la propiedad `allowedOrigins` dentro de `controlUi`. Conserva las demás propiedades que ya tenga ese objeto.
    - Si existe `gateway`, pero no `controlUi`, agrega el objeto `controlUi` dentro de `gateway`, junto a sus otras propiedades. No reemplaces el objeto `gateway`.

   Al editar JSON, separa cada propiedad de la siguiente con una coma, no dejes una coma después del último elemento y no crees dos claves `controlUi` ni dos claves `allowedOrigins` en el mismo objeto. No cambies otras opciones, como `bind`, `auth` o `allowInsecureAuth`, para aplicar este paso.

   Guarda el archivo y valida su sintaxis sin imprimir su contenido. Sustituye `<ruta-real>` por la ruta del `openclaw.json` activo que editaste en la VPS:

   ```sh
   node -e "JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8')); console.log('JSON válido')" <ruta-real>
   ```

   Esta comprobación solo valida la sintaxis JSON; no verifica por sí sola que el Gateway haya cargado la configuración. Si la validación falla, corrige el archivo antes de reiniciar. Si pasa, reinicia el Gateway en la VPS:

    ```sh
    openclaw gateway restart
    ```

2. Conserva abierta la ventana del túnel inverso `-R` para el flujo separado de Zapier. El comando usado fue:

   ```powershell
   ssh -N -T -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o GatewayPorts=yes -R 0.0.0.0:46633:127.0.0.1:46633 root@134.209.211.209
   ```

   Este comando mapea `VPS:46633` hacia `desktop:127.0.0.1:46633`. No lo cambies por el comando del WebChat: su puerto y dirección son diferentes. Su destino local no fue validado como servicio funcional durante la resolución del WebChat.

3. En otra ventana de CMD o PowerShell del desktop, ejecuta el reenvío local `-L` que sí usa el WebChat:

   ```cmd
   ssh -N -L 18789:127.0.0.1:18789 root@134.209.211.209
   ```

   Deja esa ventana abierta mientras uses el WebChat. Que SSH no devuelva un prompt es normal: el reenvío permanece activo.

4. En el navegador del mismo desktop, abre:

   ```text
   http://localhost:18789
   ```

   No abras la IP pública de la VPS para este acceso.

5. En el formulario, autentícate con el token vigente del Gateway. No pegues el token en chats, documentos ni comandos que lo impriman.

6. Confirma que carga la interfaz de OpenClaw. El resultado observado fue la página Chat con el estado “Ready to chat”.

## Qué causó los intentos fallidos

- `allowedOrigins` ubicado directamente en `gateway` quedó fuera del esquema esperado y la reparación lo eliminó. La ubicación correcta es `gateway.controlUi.allowedOrigins`.
- Permitir el origen no hizo segura una página abierta por HTTP usando la IP pública. El Control UI del navegador requiere un origen seguro; `allowInsecureAuth: true` no elimina ese requisito.
- Confundir la dirección de los túneles causó intentos equivocados: `-R` expone un puerto de la VPS hacia el desktop; `-L` expone un puerto local del desktop hacia un servicio de la VPS. Para WebChat se necesitaba `-L` hacia el puerto `18789` del Gateway.

## Si deja de abrir

- Comprueba que sigue abierta la ventana del túnel `-L` de `18789`; es la que transporta el WebChat.
- Comprueba que el Gateway de la VPS escucha en `127.0.0.1:18789` y está activo.
- Usa exactamente `http://localhost:18789` en el mismo desktop donde corre el túnel.
- El túnel `-R` de `46633` es independiente y no repara ni sustituye el acceso al WebChat.

## Seguridad pendiente

El token del Gateway apareció en texto plano en un archivo del workspace y en el contexto de la conversación. Rótalo en la VPS y elimina la copia en texto plano; no se incluye aquí.
