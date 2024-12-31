{ config, lib, ... }:
with lib;
let cfg = config.void.server.dns.blocky;
in {
  imports = [ ];

  options.void.server.dns.blocky = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        log = {
          level = "warn";
          format = "json";
          timestamp = "false";
          privacy = "true";
        };
        caching = {
          minTime = "20m";
          prefetching = "true";
        };
        upstreams = {
          groups = {
            default = [
              # CF
              "1.1.1.1"
              "1.0.0.1"
              # google
              "8.8.8.8"
              # quad9
              "9.9.9.9"
            ];
          };
        };
        bootstrapDns = [ "tcp+udp:1.1.1.1" ];
        blocking = {
          denylists.ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
            "https://v.firebog.net/hosts/static/w3kbl.txt"
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/ncheckyAds/hosts"
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
          ];
          allowlists.ads = [
            "clients4.google.com"
            "clients2.google.com"
            "www.googleapis.com"
            "youtubei.googleapis.com"
            "oauthaccountmanager.googleapis.com"
            "s.youtube.com"
            "video-stats.l.google.com"
            "android.clients.google.com"
            "gstaticadssl.l.google.com"
            "googleapis.l.google.com"
            "www.msftncsi.com"
            "www.msftconnecttest.com"
            "outlook.office365.com"
            "products.office.com"
            "c.s-microsoft.com"
            "i.s-microsoft.com"
            "login.live.com"
            "login.microsoftonline.com"
            "g.live.com"
            "dl.delivery.mp.microsoft.com"
            "geo-prod.do.dsp.mp.microsoft.com"
            "displaycatalog.mp.microsoft.com"
            "sls.update.microsoft.com.akadns.net"
            "fe3.delivery.dsp.mp.microsoft.com.nsatc.net"
            "tlu.dl.delivery.mp.microsoft.com"
            "clientconfig.passport.net"
            "v10.events.data.microsoft.com"
            "v20.events.data.microsoft.com"
            "client-s.gateway.messenger.live.com"
            "arc.msn.com"
            "activity.windows.com"
            "xbox.ipv6.microsoft.com"
            "device.auth.xboxlive.com"
            "title.mgt.xboxlive.com"
            "xsts.auth.xboxlive.com"
            "title.auth.xboxlive.com"
            "ctldl.windowsupdate.com"
            "attestation.xboxlive.com"
            "xboxexperiencesprod.experimentation.xboxlive.com"
            "xflight.xboxlive.com"
            "cert.mgt.xboxlive.com"
            "xkms.xboxlive.com"
            "def-vef.xboxlive.com"
            "notify.xboxlive.com"
            "help.ui.xboxlive.com"
            "licensing.xboxlive.com"
            "eds.xboxlive.com"
            "www.xboxlive.com"
            "v10.vortex-win.data.microsoft.com"
            "settings-win.data.microsoft.com"
            "officeclient.microsoft.com"
            "itunes.apple.com"
            "s.mzstatic.com"
            "appleid.apple.com"
            "gsp-ssl.ls.apple.com"
            "gsp-ssl.ls-apple.com.akadns.net"
            "connectivitycheck.android.com"
            "clients3.google.com"
            "connectivitycheck.gstatic.com"
            "msftncsi.com"
            "ipv6.msftncsi.com"
            "captive.apple.com"
            "gsp1.apple.com"
            "www.apple.com"
            "www.appleiphonecell.com"
            "spclient.wg.spotify.com"
            "apresolve.spotify.com"
            "upload.facebook.com"
            "creative.ak.fbcdn.net"
            "external-lhr1-1.xx.fbcdn.net"
            "external-lhr0-1.xx.fbcdn.net"
            "external-lhr10-1.xx.fbcdn.net"
            "external-lhr2-1.xx.fbcdn.net"
            "external-lhr3-1.xx.fbcdn.net"
            "external-lhr4-1.xx.fbcdn.net"
            "external-lhr5-1.xx.fbcdn.net"
            "external-lhr6-1.xx.fbcdn.net"
            "external-lhr7-1.xx.fbcdn.net"
            "external-lhr8-1.xx.fbcdn.net"
            "external-lhr9-1.xx.fbcdn.net"
            "fbcdn-creative-a.akamaihd.net"
            "scontent-lhr3-1.xx.fbcdn.net"
            "scontent.xx.fbcdn.net"
            "scontent.fgdl5-1.fna.fbcdn.net"
            "graph.facebook.com"
            "b-graph.facebook.com"
            "connect.facebook.com"
            "cdn.fbsbx.com"
            "api.facebook.com"
            "edge-mqtt.facebook.com"
            "mqtt.c10r.facebook.com"
            "portal.fb.com"
            "star.c10r.facebook.co"
            "star-mini.c10r.facebook.com"
            "b-api.facebook.com"
            "fb.me"
            "bigzipfiles.facebook.com"
            "l.facebook.com"
            "www.facebook.com"
            "scontent-atl3-1.xx.fbcdn.net"
            "static.xx.fbcdn.net"
            "edge-chat.messenger.com"
            "video.xx.fbcdn.net"
            "external-ort2-1.xx.fbcdn.net"
            "scontent-ort2-1.xx.fbcdn.net"
            "edge-chat.facebook.com"
            "scontent-mia3-1.xx.fbcdn.net"
            "web.facebook.com"
            "rupload.facebook.com"
            "l.messenger.com"
            "gravatar.com"
            "thetvdb.com"
            "themoviedb.com"
            "chtbl.com"
            "services.sonarr.tv"
            "skyhook.sonarr.tv"
            "download.sonarr.tv"
            "apt.sonarr.tv"
            "forums.sonarr.tv"
            "placehold.it"
            "placeholdit.imgix.net"
            "dl.dropboxusercontent.com"
            "ns1.dropbox.com"
            "ns2.dropbox.com"
            "gfwsl.geforce.com"
            "delivery.vidible.tv"
            "img.vidible.tv"
            "videos.vidible.tv"
            "edge.api.brightcove.com"
            "cdn.vidible.tv"
            "tracking.epicgames.com"
            "cloudsync-prod.s3.amazonaws.com"
            "tracking-protection.cdn.mozilla.net"
            "telemetry-console.api.playstation.com"
            "styles.redditmedia.com"
            "www.redditstatic.com"
            "reddit.map.fastly.net"
            "www.redditmedia.com"
            "reddit-uploaded-media.s3-accelerate.amazonaws.com"
            "wa.me"
            "www.wa.me"
            "ud-chat.signal.org"
            "chat.signal.org"
            "storage.signal.org"
            "signal.org"
            "updates2.signal.org"
            "textsecure-service-whispersystems.org"
            "giphy-proxy-production.whispersystems.org"
            "cdn.signal.org"
            "whispersystems-textsecure-attachments.s3-accelerate.amazonaws.com"
            "d83eunklitikj.cloudfront.net"
            "souqcdn.com"
            "cms.souqcdn.com"
            "api.directory.signal.org"
            "contentproxy.signal.org"
            "turn1.whispersystems.org"
            "twitter.com"
            "upload.twitter.com"
            "api.twitter.com"
            "mobile.twitter.com"
          ];
          clientGroupsBlock.default = [ "ads" ];
        };
        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = "true";
          mapping = { "sako.box" = "192.168.1.28"; };
        };
        ports = {
          dns = 53;
          http = 4000;
        };
      };
    };
  };
}
