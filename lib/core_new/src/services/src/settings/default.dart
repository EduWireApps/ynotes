part of settings_service;

const Map<String, dynamic> _defaultSettings = {
  "global": {
    "lastReadPatchNotes": "",
    // TODO: set this to 0 when system theme is implemented
    "themeId": 1,
    "api": "ecoleDirecte",
    "batterySaver": false,
    "shakeToReport": false
  },
  "pages": {
    "homework": {"forceMonochrome": false, "fontSize": 20, "colorVariant": 0}
  },
  "notifications": {"newEmail": false, "newGrade": false}
};
