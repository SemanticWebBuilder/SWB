define(["ace", "ace/mode-html", "ace/theme-chrome"],
function (AceEditor) {
  let TemplateEditor = { provider: "Ace" };
  let HTMLModeDef = ace.require("ace/mode/html").Mode;
  let defaults = {
    showGutters: false,
    theme: "ace/theme/sqlserver"
  };

  /**
  * Sets global options
  */
  TemplateEditor.setOptions = function(options) {
    for (key in options) {
      if (options.hasOwnProperty(key)) {
        defaults[key] = options[key];
      }
    }

    if (defaults.basePath) {
      ace.config.set("basePath", defaults.basePath);
    }
  };

  /**
  * Creates an instance of TemplateEditor
  */
  TemplateEditor.createInstance = function(placeHolderId) {
    let editor = ace.edit(placeHolderId);
    editor.setTheme(defaults.theme);
    editor.getSession().setMode(new HTMLModeDef());
    editor.getSession().setTabSize(2);

    editor.renderer.setShowGutter(defaults.showGutters);

    let HTMLEditor = {
      getEditor: function() {
        return editor;
      },
      insertContent: function(content, reset) {
        if (reset) {
					editor.getSession().setValue(content, -1);
				} else {
					editor.insert(content);
				}
        editor.focus();
      },
      getContent: function() {
				return editor.getValue() || "";
      },
      execCommand: function (command) {
        editor.execCommand(command);
        editor.focus();
      }
    };

    return HTMLEditor;
  };

  return TemplateEditor;
});
