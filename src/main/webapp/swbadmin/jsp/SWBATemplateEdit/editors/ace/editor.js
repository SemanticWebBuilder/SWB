define(["ace", "ace/mode-html", "ace/mode-sql", "ace/theme-chrome"],
function (AceEditor) {
  let TemplateEditor = { provider: "Ace" };
  let HTMLModeDef;
  let defaults = {
    showGutters: false,
    theme: "ace/theme/sqlserver",
    mode: "ace/mode/html"
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

    if (defaults.mode) {
       HTMLModeDef = ace.require(defaults.mode).Mode;
    }
  };

  /**
  * Creates an instance of TemplateEditor
  */
  TemplateEditor.createInstance = function(placeHolderId) {
    if (!placeHolderId || placeHolderId === undefined || !placeHolderId.length) return;

    document.getElementById(placeHolderId).className = "AceEditor";

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
        if (!reset || reset == undefined) reset = false;

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
