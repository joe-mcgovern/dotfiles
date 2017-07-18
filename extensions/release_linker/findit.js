var releaseContainer = $('.tag');
var releaseName = releaseContainer.text().trim();
releaseContainer.empty();
var link = 'https://w-rmconsole.appspot.com/release/name/' + releaseName + '/';
var element = ('<a href="' + link + '" target="_blank" style="cursor:pointer">' +
               releaseName + '</a>');
releaseContainer.append(element);
