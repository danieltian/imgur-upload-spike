var riot = require('riot');

// require every tag file in the tags folder
var context = require.context('./tags');
context.keys().forEach(key => {
  context(key);
});

riot.mount('app');
