CREATE USER {{.Values.radarr.db.user}} WITH PASSWORD '{{.Values.radarr.db.password}}';
CREATE DATABASE {{.Values.radarr.db.mainDB}} OWNER {{.Values.radarr.db.user}};
CREATE DATABASE {{.Values.radarr.db.logDB}} OWNER {{.Values.radarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.radarr.db.mainDB}} TO {{.Values.radarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.radarr.db.logDB}} TO {{.Values.radarr.db.user}};

CREATE USER {{.Values.sonarr.db.user}} WITH PASSWORD '{{.Values.sonarr.db.password}}';
CREATE DATABASE {{.Values.sonarr.db.mainDB}} OWNER {{.Values.sonarr.db.user}};
CREATE DATABASE {{.Values.sonarr.db.logDB}} OWNER {{.Values.sonarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.sonarr.db.mainDB}} TO {{.Values.sonarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.sonarr.db.logDB}} TO {{.Values.sonarr.db.user}};

CREATE USER {{.Values.prowlarr.db.user}} WITH PASSWORD '{{.Values.prowlarr.db.password}}';
CREATE DATABASE {{.Values.prowlarr.db.mainDB}} OWNER {{.Values.prowlarr.db.user}};
CREATE DATABASE {{.Values.prowlarr.db.logDB}} OWNER {{.Values.prowlarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.prowlarr.db.mainDB}} TO {{.Values.prowlarr.db.user}};
GRANT ALL PRIVILEGES ON DATABASE {{.Values.prowlarr.db.logDB}} TO {{.Values.prowlarr.db.user}};
