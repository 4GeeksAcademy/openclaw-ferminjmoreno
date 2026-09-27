## Algunos apuntes sobre la instalacion, configuracion y puesta a tono de MCP Zapier, OpenClaw y el Agente

Por Estar en Windows y no en Linux, tuve que recurrir a la decision de crear un tunnel entre el servidor MCP  de Zapier
y OpenClaw Gateway para establecer el puerto 46633 como puerto de escucha y que Zapier lograra ver a mi computador local como un servidor VPS

## Recrear el Codespace

El archivo `.devcontainer/devcontainer.json` fija la imagen base del entorno. Al crear un Codespace nuevo desde este repositorio, GitHub vuelve a obtener los archivos que ya esten subidos a la rama; los cambios sin subir del Codespace anterior no se recuperan automaticamente.

Antes de eliminar el Codespace anterior, comprueba que tus cambios esten subidos a GitHub y anota las herramientas que instalaste manualmente. Esta configuracion no reinstala OpenClaw ni reproduce instalaciones que no esten declaradas en el repositorio. Guarda credenciales y tokens en Codespaces Secrets, nunca en archivos versionados.

El VPS sigue funcionando por separado. Para conectarte por SSH desde VS Code en Windows, usa `Remote-SSH: Connect to Host...` con el host que tengas configurado localmente; esa lista de hosts y la contrasena de root no forman parte del Codespace. El tunel de Windows para Zapier tambien debe iniciarse de nuevo en la maquina donde lo usabas.