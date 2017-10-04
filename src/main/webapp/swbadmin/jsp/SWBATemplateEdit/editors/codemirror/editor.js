define(["codemirror",
        "codemirror/mode/xml/xml",
        "codemirror/mode/javascript/javascript",
				"codemirror/mode/css/css",
				"codemirror/mode/htmlmixed/htmlmixed",
				"codemirror/addon/scroll/simplescrollbars",
				"codemirror/addon/selection/active-line",
				"codemirror/addon/edit/closetag",
				"codemirror/addon/edit/matchtags",
				"codemirror/addon/search/searchcursor",
				"codemirror/addon/search/search"],
function (CodeMirror) {
  let TemplateEditor = { provider: "CodeMirror" };
  let defaults = {
    mode: "text/html",
    autoCloseTags: true,
    matchTags: {bothTags: true},
    extraKeys: {"Alt-F": "findPersistent"},
    styleActiveLine: true,
    scrollbarStyle: "simple",
    fixedGutter: true
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
    if (!placeHolderId || placeHolderId === undefined || !placeHolderId.length) return;

    let editor = CodeMirror(document.getElementById(placeHolderId), defaults);
    let HTMLEditor = {
      getEditor: function() {
        return editor;
      },
      insertContent: function(content, reset) {
        if (reset) {
					editor.setValue(content);
				} else {
					let doc = editor.getDoc();
					doc && content && content.length && doc.replaceSelection(content);
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
