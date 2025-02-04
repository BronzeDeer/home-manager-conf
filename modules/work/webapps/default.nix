{config,pkgs,lib,...}:
{
    webappify.apps = [
        rec { url = "https://outlook.office.com/"; name = "Outlook"; icon = (builtins.fetchurl { url = url + "favicon.ico"; sha256="sha256:0ifbq7x8zglm8ddwnliwxy2k9ryzjhns3cgmdylyrmlld2vr8pg3";} ); }
        rec { url = "https://teams.microsoft.com/"; name = "Teams"; icon = (builtins.fetchurl { url = url + "favicon.ico"; sha256="sha256:08m8slwwazf185p0vwgjnqrdi3sxm4yigxdln1bybxqv9vsdszir";} ); }
        rec { url = "https://colenio.vertec-cloud.de/webapp/"; name = "Vertec"; icon = (builtins.fetchurl { url = "https://colenio.vertec-cloud.de/webapp/resource/1db029a439ad000/vertec/images/favicon.ico"; sha256="sha256:07q5pbm3gwpkfnsfnkm6ab0r5207nxlj7kwl7s04zlsw6g96n4ch";} );}
        # https://outlook.office.com/bookings/calendar
        rec { url = "https://outlook.office.com/bookings/calendar/"; name = "Bookings"; icon = (builtins.fetchurl { url = https://res.public.onecdn.static.microsoft/owamail/20240920004.12/resources/images/favicon-bookings.ico; sha256="sha256:1jnxzq5ddbnbjb09y9m818f9lkcd7cza6cbvqa0n9lfl67rac2gv";} ); }
    ];
    webappify.browserCommand="flatpak run org.chromium.Chromium --flag-switches-begin --disable-features=WebRtcAllowInputVolumeAdjustment --flag-switches-end";
    webappify.appIdPrefix="org.chromium.Chromium";
}
