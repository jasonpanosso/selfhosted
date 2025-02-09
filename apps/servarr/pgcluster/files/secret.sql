CREATE USER {{.Values.radarr.db.user}} WITH PASSWORD '{{.Values.radarr.db.password}}';
CREATE USER {{.Values.sonarr.db.user}} WITH PASSWORD '{{.Values.sonarr.db.password}}';
CREATE USER {{.Values.prowlarr.db.user}} WITH PASSWORD '{{.Values.prowlarr.db.password}}';
