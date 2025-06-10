"use strict";

module.exports = {
  public: true,
  host: undefined,
  port: 80,
  bind: undefined,

  // ### `reverseProxy`
  //
  // When set to `true`, The Lounge is marked as served behind a reverse proxy
  // and will honor the `X-Forwarded-For` header.
  //
  // This value is set to `false` by default.
  reverseProxy: false,
  maxHistory: 10000,
  https: {
    enable: false,
    key: "",
    certificate: "",
    ca: "",
  },
  theme: "morning",
  prefetch: false,

  // ### `disableMediaPreview`
  //
  // When set to `true`, The Lounge will not preview media (images, video and
  // audio) hosted on third-party sites. This ensures the client does not
  // make any requests to external sites. If `prefetchStorage` is enabled,
  // images proxied via the The Lounge will be previewed.
  //
  // This has no effect if `prefetch` is set to `false`.
  //
  // This value is set to `false` by default.
  disableMediaPreview: false,
  prefetchStorage: false,
  prefetchMaxImageSize: 2048,
  prefetchMaxSearchSize: 50,
  prefetchTimeout: 5000,
  fileUpload: {
    enable: false,
    maxFileSize: 10240,
    baseUrl: null,
  },
  transports: ["polling", "websocket"],
  leaveMessage: "The Lounge - https://thelounge.chat",

  // ## Default network

  // ### `defaults`
  //
  // Specifies default network information that will be used as placeholder
  // values in the *Connect* window.
  //
  // The available keys for the `defaults` object are:
  //
  // - `name`: Name to display in the channel list of The Lounge. This value is
  //   not forwarded to the IRC network.
  // - `host`: IP address or hostname of the IRC server.
  // - `port`: Usually 6667 for unencrypted connections and 6697 for
  //   connections encrypted with TLS.
  // - `password`: Connection password. If the server supports SASL capability,
  //   then this password will be used in SASL authentication.
  // - `tls`: Enable TLS connections
  // - `rejectUnauthorized`: Whether the server certificate should be verified
  //   against the list of supplied Certificate Authorities (CAs) by your
  //   Node.js installation.
  // - `nick`: Nick name. Percent signs (`%`) will be replaced by random
  //   numbers from 0 to 9. For example, `Guest%%%` may become `Guest123`.
  // - `username`: User name.
  // - `realname`: Real name displayed by some clients. Defaults to the nick if set to ""
  // - `leaveMessage`: Network specific leave message (overrides global leaveMessage)
  // - `join`: Comma-separated list of channels to auto-join once connected.
  //
  // This value is set to connect to the official channel of The Lounge on
  // Libera.Chat by default:
  //
  // ```js
  // defaults: {
  //   name: "Libera.Chat",
  //   host: "irc.libera.chat",
  //   port: 6697,
  //   password: "",
  //   tls: true,
  //   rejectUnauthorized: true,
  //   nick: "thelounge%%",
  //   username: "thelounge",
  //   realname: "The Lounge User",
  //   join: "#thelounge"
  // }
  // ```
  defaults: {
    name: "Libera.Chat",
    host: "irc.libera.chat",
    port: 6697,
    password: "",
    tls: true,
    rejectUnauthorized: true,
    nick: "thelounge%%",
    username: "thelounge",
    realname: "",
    join: "#thelounge",
    leaveMessage: "",
  },
  lockNetwork: false,

  // ## User management

  // ### `messageStorage`

  // The Lounge can log user messages, for example to access them later or to
  // reload messages on server restart.

  // Set this array with one or multiple values to enable logging:
  // - `text`: Messages per network and channel will be stored as text files.
  //   **Messages will not be reloaded on restart.**
  // - `sqlite`: Messages are stored in SQLite database files, one per user.
  //
  // Logging can be disabled globally by setting this value to an empty array
  // `[]`. Logging is also controlled per user individually in the `log` key of
  // their JSON configuration file.
  //
  // This value is set to `["sqlite", "text"]` by default.
  messageStorage: ["sqlite"],

  // ### `storagePolicy`

  // When the sqlite storage is in use, control the maximum storage duration.
  // A background task will periodically clean up messages older than the limit.

  // The available keys for the `storagePolicy` object are:
  //
  // - `enabled`: If this is false, the cleaning task is not running.
  // - `maxAgeDays`: Maximum age of an entry in days.
  // - `deletionPolicy`: Controls what types of messages are being deleted.
  //   Valid options are:
  //   - `statusOnly`: Only delete message types which are status related (e.g. away, back, join, parts, mode, ctcp...)
  //     but keep actual messages from nicks. This keeps the DB size down while retaining "precious" messages.
  //   - `everything`: Delete everything, including messages from irc nicks
  storagePolicy: {
    enabled: false,
    maxAgeDays: 7,
    deletionPolicy: "statusOnly",
  },
  useHexIp: false,
  webirc: null,
  identd: {
    enable: false,
    port: 113,
  },
  oidentd: null,

  // ## LDAP support

  // These settings enable and configure LDAP authentication.
  //
  // They are only being used in private mode. To know more about private mode,
  // see the `public` setting above.

  //
  // The authentication process works as follows:
  //
  // 1. The Lounge connects to the LDAP server with its system credentials.
  // 2. It performs an LDAP search query to find the full DN associated to the
  //    user requesting to log in.
  // 3. The Lounge tries to connect a second time, but this time using the
  //    user's DN and password. Authentication is validated if and only if this
  //    connection is successful.
  //
  // The search query takes a couple of parameters in `searchDN`:
  //
  // - a base DN `searchDN/base`. Only children nodes of this DN will likely
  //   be returned;
  // - a search scope `searchDN/scope` (see LDAP documentation);
  // - the query itself, built as `(&(<primaryKey>=<username>) <filter>)`
  //   where `<username>` is the user name provided in the log in request,
  //   `<primaryKey>` is provided by the config and `<filter>` is a filtering
  //   complement also given in the config, to filter for instance only for
  //   nodes of type `inetOrgPerson`, or whatever LDAP search allows.
  //
  // Alternatively, you can specify the `bindDN` parameter. This will make The
  // Lounge ignore `searchDN` options and assume that the user DN is always
  // `<bindDN>,<primaryKey>=<username>`, where `<username>` is the user name
  // provided in the log in request, and `<bindDN>` and `<primaryKey>` are
  // provided by the configuration.
  //
  // The available keys for the `ldap` object are:
  ldap: {
    // - `enable`: when set to `false`, LDAP support is disabled and all other
    //   values are ignored.
    enable: false,

    // - `url`: A url of the form `ldaps://<ip>:<port>`.
    //   For plain connections, use the `ldap` scheme.
    url: "ldaps://example.com",

    // - `tlsOptions`: LDAP connection TLS options (only used if scheme is
    //   `ldaps://`). It is an object whose values are Node.js' `tls.connect()`
    //   options. It is set to `{}` by default.
    //   For example, this option can be used in order to force the use of IPv6:
    //   ```js
    //   {
    //     host: 'my::ip::v6',
    //     servername: 'example.com'
    //   }
    //   ```
    tlsOptions: {},

    // - `primaryKey`: LDAP primary key. It is set to `"uid"` by default.
    primaryKey: "uid",

    // - `baseDN`: LDAP base DN, alternative to `searchDN`. For example, set it
    //   to `"ou=accounts,dc=example,dc=com"`.
    //   When unset, the LDAP auth logic with use `searchDN` instead to locate users.

    // - `searchDN`: LDAP search DN settings. This defines the procedure by
    //   which The Lounge first looks for the user DN before authenticating them.
    //   It is ignored if `baseDN` is specified. It is an object with the
    //   following keys:
    searchDN: {
      //   - `rootDN`: This bind DN is used to query the server for the DN of
      //     the user. This is supposed to be a system user that has access in
      //     read-only to the DNs of the people that are allowed to log in.
      //     It is set to `"cn=thelounge,ou=system-users,dc=example,dc=com"` by
      //     default.
      rootDN: "cn=thelounge,ou=system-users,dc=example,dc=com",

      //   - `rootPassword`: Password of The Lounge LDAP system user.
      rootPassword: "1234",

      //   - `filter`: it is set to `"(&(objectClass=person)(memberOf=ou=accounts,dc=example,dc=com))"`
      //     by default.
      filter: "(&(objectClass=person)(memberOf=ou=accounts,dc=example,dc=com))",

      //   - `base`: LDAP search base (search only within this node). It is set
      //     to `"dc=example,dc=com"` by default.
      base: "dc=example,dc=com",

      //   - `scope`: LDAP search scope. It is set to `"sub"` by default.
      scope: "sub",
    },
  },

  // ## Debugging settings

  // The `debug` object contains several settings to enable debugging in The
  // Lounge. Use them to learn more about an issue you are noticing but be aware
  // this may produce more logging or may affect connection performance so it is
  // not recommended to use them by default.
  //
  // All values in the `debug` object are set to `false`.
  debug: {
    // ### `debug.ircFramework`
    //
    // When set to true, this enables extra debugging output provided by
    // [`irc-framework`](https://github.com/kiwiirc/irc-framework), the
    // underlying IRC library for Node.js used by The Lounge.
    ircFramework: false,

    // ### `debug.raw`
    //
    // When set to `true`, this enables logging of raw IRC messages into each
    // server window, displayed on the client.
    raw: false,
  },
};
