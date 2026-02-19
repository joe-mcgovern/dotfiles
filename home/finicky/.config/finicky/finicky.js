// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

const DefaultBrowser = "Google Chrome";

const Profile = {
  DdWork: "ddhq",
  GovCloud: "ddog-gov.com",
  Personal: "Joe (personal)",
};

const GoogleIdp = {
  Dd: "C0147pk0i",
  DdGov: "C03lf3ewa",
  DdGovVault:
    "887447947818-oeibak5kop4jh95bp61oe2ijem431m07.apps.googleusercontent.com",
};

export default {
  defaultBrowser: DefaultBrowser,
  options: {
    // hide icon from top bar
    hideIcon: true,
  },
  handlers: [
    {
      match: finicky.matchHostnames(["accounts.google.com"]),
      browser: ({ urlString }) =>
        urlString.includes(GoogleIdp.DdGov) ||
        urlString.includes(GoogleIdp.DdGovVault)
          ? {
              name: DefaultBrowser,
              profile: Profile.GovCloud,
            }
          : {
              name: DefaultBrowser,
              profile: Profile.DdWork,
            },
    },
    {
      match: finicky.matchHostnames([
        "github.com",
        "cs.github.com",
        "app.datadoghq.com",
        "ddstaging.datadoghq.com",
        "datadoghq.atlassian.net",
        "sdp.ddbuild.io",
        "datadog.zoom.us",
        "dd.datad0g.com",
        "gitlab.ddbuild.io",
        "dd.slack.com",
        "dd.enterprise.slack.com",
        "datadog.pagerduty.com",
        "cnap-api.sdm.ddbuild.io",
        "cnab-api-sdm1.ddbuild.io",
        "signin.aws.amazon.com",
        "github.com",
        /.*\.prod\.dog/,
        /.*\.ddbuild\.io/,
        /.*\.staging\.dog/,
      ]),
      browser: {
        name: DefaultBrowser,
        profile: Profile.DdWork,
      },
    },
    {
      match: finicky.matchHostnames([
        "app.ddog-gov.com",
        "sdp.us1-build.fed.dog",
        "cnab-api.us1-build.fed.dog",
        "datadog-fed.slack.com",
        "ddog-gov.enterprise.slack.com",
        /.*\.us1.fed.dog/,
        /.*\.us1.fed-build.dog/,
      ]),
      browser: {
        name: DefaultBrowser,
        profile: Profile.GovCloud,
      },
    },
    {
      match: finicky.matchHostnames([
        "account.ui.com",
        "discord.com",
        "discord.gg",
        "feedly.com",
        "store.ui.com",
        "unifi.ui.com",
        "www.youtube.com",
        "youtu.be",
        "youtube.com",
      ]),
      browser: {
        name: DefaultBrowser,
        profile: Profile.Personal,
      },
    },
  ],
};
