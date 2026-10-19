# Servidor Linux asegurado

Instalé un servidor **Ubuntu Server** en una máquina virtual y lo protegí paso a paso, como se hace en una empresa. Medí la seguridad con **Lynis**, una herramienta de auditoría: el puntaje pasó de **61 a 81**.

| Antes | Después |
| :---: | :---: |
| <img src="laboratorio-seguridad/capturas/04-lynis-inicial.png" width="400"> | <img src="laboratorio-seguridad/capturas/23-lynis-final.png" width="400"> |
| **61 / 100**: sin firewall, sin detección de intrusos, sin antimalware | **81 / 100**: todo activo y sin advertencias |

**Herramientas:** Ubuntu Server · SSH · ufw · fail2ban · nginx · TLS · GPG · cron · Lynis · rkhunter · auditd · AIDE · VirtualBox

---

## 1. Acceso seguro por SSH

Para entrar al servidor hacen falta dos cosas: una **llave** guardada en mi notebook y un **código de 6 dígitos** del celular (2FA). Las contraseñas y el usuario root quedaron bloqueados.

![Banner legal, llave y código 2FA](laboratorio-seguridad/capturas/22-banner-ssh.png)

Prueba: los intentos con contraseña o como root se rechazan.

![Contraseña y root rechazados](laboratorio-seguridad/capturas/08-ssh-bloqueos.png)

## 2. Firewall y bloqueo de ataques

El firewall (**ufw**) bloquea todo lo que entra, salvo SSH y la web. **fail2ban** bloquea automáticamente a quien falla 3 veces al intentar entrar.

Lo probé simulando un ataque: al tercer intento, la IP quedó bloqueada en el firewall.

![fail2ban bloquea la IP atacante](laboratorio-seguridad/capturas/10-fail2ban-bloqueo.png)

## 3. Servidor web con HTTPS

Instalé **nginx** con HTTPS (TLS 1.3). Además oculté la versión del servidor y agregué cabeceras de seguridad, que protegen contra ataques comunes en sitios web.

![Versión oculta y cabeceras de seguridad](laboratorio-seguridad/capturas/17-cabeceras-despues.png)

## 4. Backups cifrados

Un script hace una copia de seguridad todos los días, cifrada con **GPG**, y guarda los últimos 7 días. Probé recuperar un archivo y salió idéntico al original.

![Restauración comprobada](laboratorio-seguridad/capturas/18-restauracion-ok.png)

## 5. Detección de cambios

**AIDE** guarda una huella de cada archivo del sistema y avisa si alguno cambia. Acá detecta que modifiqué el banner de bienvenida.

![AIDE detecta archivos modificados](laboratorio-seguridad/capturas/24-aide-cambios.png)

También instalé **rkhunter** (busca rootkits) y **auditd** (registra quién modifica archivos importantes), y activé las actualizaciones de seguridad automáticas.

---

## Problemas que resolví

- **La web no cargaba desde la notebook.** Fui probando por partes hasta encontrar que faltaba una regla de reenvío de puertos en VirtualBox.
- **nginx no aplicaba los cambios.** Una opción estaba repetida en dos archivos; la corregí en el archivo original.
- **Casi dejo el servidor sin arrancar.** Al limpiar paquetes, el sistema ofreció borrar archivos de arranque; lo detecté a tiempo y lo cancelé.

## Archivos

Las configuraciones y el script de backup están en [`laboratorio-seguridad/`](laboratorio-seguridad). Este repositorio no contiene contraseñas ni llaves privadas.

## Próximos pasos

Red segmentada con firewall (OPNsense) · detección de ataques (Wazuh) · monitoreo (Zabbix) · automatización (Ansible).

---

**Bruno Marrone** · Estudiante de Analista en Infraestructura Informática, Universidad ORT Uruguay
