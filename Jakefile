var share = {}, // Shared info between the
                // Jakefile tasks and the launch tasks
  action = require('launch')(share).action; // Get the launch actions,
                                            // passing in the shared var


/*
 * Run with `jake deploylive`. Depends on `setenvlive` and `restart`
 * which are defined in this file, and `launch:installdeps` which is
 * provided by launch. The task itself is empty, the important things
 * are its dependencies being called in order.
 */
desc('Deploy the current branch to the live environment');
task('deploylive', ['setenvlive', 'launch:symlink', 'restart'], function () {
});

/*
 * Sets the optional enviroment on the shared object
 * to `live`, which is used by a launch task when operating
 * with the remote filesystem. This task depends on the
 * launch task `launch:info` to gather the remote info.
 */
desc('Sets the environment to live');
task('setenvlive', ['launch:info'], function () {
  share.env = 'live';
});


/*
 * A custom task of mine to restart the the site/app
 * (I use upstart). This shows how to execute an arbitrary
 * remote command with launch's `action`s.
 */
desc('Restarts the server given an `env`');
task('restart', function () {

  if (!share.env) {
    action.error('`env` is not set.');
    fail();
  }

  action.remote(share.info.remote,
    'sudo stop site.' + share.info.name + '-' + share.env + ' && '
    + 'sudo start site.' + share.info.name + '-' + share.env, function (exitcode) {
      if (exitcode === 0) {
        action.notice('The site service restarted.');
        action.notice('Check manually to verify that the site is running.')
      } else {
        action.error('Failed to restart site');
        fail();
      }
    });

}, true);