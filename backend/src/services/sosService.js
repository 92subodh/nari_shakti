const alertService = require('./alertService');
const User = require('../models/User');

exports.start = async (userId) => {
  const user = await User.findById(userId).select('trustedContacts name');
  if (user?.trustedContacts?.length) {
    await Promise.all(
      user.trustedContacts.map(c =>
        alertService.sendPushNotification(c.phone || c.email, {
          title: 'SOS Started',
          body: `${user.name || 'User'} triggered SOS`,
        })
      )
    );
  }
  return { status: 'started' };
};

exports.stop = async (userId) => {
  const user = await User.findById(userId).select('trustedContacts name');
  if (user?.trustedContacts?.length) {
    await Promise.all(
      user.trustedContacts.map(c =>
        alertService.sendPushNotification(c.phone || c.email, {
          title: 'SOS Ended',
          body: `${user.name || 'User'} ended SOS`,
        })
      )
    );
  }
  return { status: 'ended' };
};

