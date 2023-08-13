# Hetzner Cloud Terraform Modul zur Erstellung von 4 Servern

Dieses Terraform-Modul erstellt 4 Server (3 Webserver und 1 Load Balancer) in der Hetzner Cloud.

## Überblick

- Servernamen: web1, web2, web3, LB
- Servertyp: CX21
- Interne IP-Adressen: 10.0.0.1, 10.0.0.2, 10.0.0.3, 10.0.0.4
- Externe IP-Adresse: 162.55.153.218 für LB

## Eigenschaften

- **API-Schlüssel Integration**: Mit diesem Modul integriert man sich direkt mit dem Hetzner Cloud API-Schlüssel, um die automatische Servereinrichtung zu erleichtern.
- **Hinzufügen von SSH-Schlüsseln**: Der bereitgestellte SSH-Schlüssel wird automatisch mit Hilfe des `user_data`-Blocks zu allen Servern hinzugefügt, um sicheren Remote-Zugriff zu gewährleisten.
- **Lastenausgleich (Load Balancer)**: Das Modul konfiguriert die angegebene externe IP-Adresse für den Lastenausgleich, um den Datenverkehr gleichmäßig auf die Server zu verteilen.

## Sicherheitshinweise

- **Interne IP-Adressen**: Die im Skript angegebenen internen IP-Adressen können nicht direkt zugewiesen werden. Hetzner weist diese Adressen automatisch zu, was ein potentielles Sicherheitsrisiko darstellen kann, wenn bestimmte IP-Adressen für sichere Kommunikation zwischen den Servern gebunden werden sollen.
- **API-Schlüssel**: Der API-Schlüssel in der `main.tf`-Datei sollte nicht in einem öffentlichen Repository gespeichert werden. Falls jemand mit böswilliger Absicht Zugriff auf diesen Schlüssel erhält, könnte er auf das Hetzner-Konto zugreifen.
Füge bitte eine Datei `secrets.tfvars` mit sensiblen Daten hinzu:
- **Setze bitte deinen SSH-Schlüssel für den Serverzugriff.
ssh_key = "ssh-rsa AAAAB3NzaC1yc2E..."
- **Gib bitte deinen Hetzner Cloud API-Schlüssel für die Authentifizierung ein.
api_token = "9dX...Lm"

## Nützliche Funktionen

- **Automatisierung**: Mit diesem Modul kann man Server automatisch erstellen. Dies ist schneller und fehlerfreier als manuelle Prozesse.
- **Skalierbarkeit**: Wenn man weitere Server hinzufügen oder bestehende ändern möchte, kann man dieses Terraform-Modul einfach anpassen.
- **Dokumentation**: Dieses Dokument enthält alle notwendigen Informationen, um das Terraform-Modul zu verstehen und zu verwenden. Dies erleichtert es anderen Entwicklern oder Systemadministratoren, diesen Code zu nutzen.

## Verwendung

1. Das Terraform-Modul kann man klonen oder herunterladen.
2. Die Datei `main.tf` im Hauptverzeichnis öffnet man.
3. Den `token`-Bereich im Block `provider "hcloud"` ersetzt man durch den eigenen Hetzner Cloud API-Schlüssel.
4. In der Konsole führt man `terraform init` aus, um Terraform zu initialisieren.
5. Mit `terraform apply` erstellt man die Server. Auf die Frage "yes" antwortet man.
6. Man meldet sich in der Hetzner Cloud-Konsole an, um sicherzustellen, dass die Server erstellt wurden.

## Ausgabe

- Die internen IP-Adressen der Server und die externe IP des Lastenausgleichs werden als Ausgaben angezeigt.



