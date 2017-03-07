define(["ace"],
function (AceEditor) {
  let TemplateEditor = { provider: "Ace" };
  let defaults = {
    mode: "html"
  };

  /**
  * Sets global options
  */
  TemplateEditor.setOptions = function(options) {
  };

  /**
  * Creates an instance of TemplateEditor
  */
  TemplateEditor.createInstance = function(placeHolderId) {
    let editor = ace.edit(placeHolderId);
    editor.getSession().setMode(defaults.mode);
    let HTMLEditor = {
      getEditor: function() {
        return editor;
      },
      insertContent: function(content, reset) {
        if (reset) {
					editor.setValue(content);
				} else {
					editor.insert(content);
				}
      },
      getContent: function() {
				return editor.getValue() || "";
      },
      execCommand: function (command) {
        editor.execCommand(command);
      }
    };

    return HTMLEditor;
  };

  return TemplateEditor;
});
