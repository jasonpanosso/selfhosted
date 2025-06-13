function fetchIndexers(baseUrl, apiKey, tag) {
  const buffer = require("child_process").execSync(
    `curl -fsSL "${baseUrl}/api/v1/tag/detail?apikey=${apiKey}"`,
  );
  const response = JSON.parse(buffer.toString("utf8"));
  const indexerIds =
    response.filter((t) => t.label === tag)[0]?.indexerIds ?? [];
  const indexers = indexerIds.map(
    (i) => `${baseUrl}/${i}/api?apikey=${apiKey}`,
  );
  console.log(`Loaded ${indexers.length} indexers from Prowlarr`);
  return indexers;
}

module.exports = {
  action: "inject",
  apiKey: process.env.CROSS_SEED_API_TOKEN,
  linkCategory: "cross-seed",
  linkDirs: ["/data/downloads/complete/cross-seed"],
  dataDirs: [
    "/data/downloads/complete/tv-sonarr",
    "/data/downloads/complete/radarr",
    "/data/downloads/complete/manual",
  ],
  maxDataDepth: 2,
  linkType: "hardlink",
  matchMode: "partial",
  port: Number(process.env.CROSS_SEED_PORT),
  radarr: [
    `http://radarr.servarr.svc.cluster.local/?apikey=${process.env.RADARR_API_TOKEN}`,
  ],
  sonarr: [
    `http://sonarr.servarr.svc.cluster.local/?apikey=${process.env.SONARR_API_TOKEN}`,
  ],
  torrentClients: ["qbittorrent:http://qbittorrent.servarr.svc.cluster.local"],
  torznab: fetchIndexers(
    "http://prowlarr.servarr.svc.cluster.local",
    process.env.PROWLARR_API_TOKEN,
    "cross-seed",
  ),
  useClientTorrents: true,
};
