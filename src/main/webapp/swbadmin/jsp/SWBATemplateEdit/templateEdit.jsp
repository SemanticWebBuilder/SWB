<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
//topicmapId - website
//template id
//session
//int version

	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String templateId = (String) request.getAttribute("templateId");
	String websiteId = (String) request.getAttribute("webSiteId");
	int verNum = (Integer) request.getAttribute("verNum");
	
	Template template = SWBContext.getWebSite(websiteId).getTemplate(templateId);
	String templatePath = SWBPortal.getWebWorkPath() + template.getWorkPath() + "/" + verNum + "/" + URLEncoder.encode(template.getFileName(verNum));
	VersionInfo vio = null;
    
%>
<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror/addon/scroll/simplescrollbars.css">
<style type="text/css">
	.CodeMirror {
		height: 90%;
	}
</style>
<div id="container_<%= websiteId %>_<%= templateId %>" data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true, liveSplitters:false">
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
		<div data-dojo-type="dijit/Toolbar" style="padding:0px;">
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconNewPage', showLabel:false">Nuevo</button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitIconFolderOpen', showLabel:false">Abrir de archivo</button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSave', showLabel:false">Guardar</button>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitFolderOpened', showLabel:false">Agregar archivos</button>
			<span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button type="button" data-dojo-type="dijit.form.Button" data-dojo-props="iconClass:'dijitIconConfigure', showLabel:false">Agregar recurso</button>
			<!--span data-dojo-type="dijit/ToolbarSeparator"></span>
			<button id="previewButton_<%= websiteId %>_<%= templateId %>" >&lt;</button-->
		</div>
	</div>
	<div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', splitter:false">
		<span data-dojo-type="dijit/layout/StackController" data-dojo-props="containerId:'stackContainer'"></span>
		<div data-dojo-type="dijit/layout/StackContainer" data-dojo-id="myStackContainer" style="height:100%">
			<div dojoType="dojox.layout.ContentPane" executeScripts="true">
				<div><textarea id="templateEditor_<%= websiteId %>_<%= templateId %>" name="templateContent"></textarea></div>
				<script type="dojo/method">
//data-dojo-props="iconClass:'dijitEditorIcon dijitEditorIconSelectAll', showLabel:false, onClick:function(){myStackContainer.back()}"
				require({
					packages: [{
						name: "codemirror",
						location: "<%= SWBPlatform.getContextPath() %>/swbadmin/js/codemirror",
						main: "lib/codemirror"
					}]
				}, ["codemirror",
					"dojo/request/xhr",
					"dijit/form/ToggleButton",
					"codemirror/mode/xml/xml",
					"codemirror/mode/javascript/javascript",
					"codemirror/mode/css/css",
					"codemirror/mode/htmlmixed/htmlmixed",
					"codemirror/addon/scroll/simplescrollbars"],
					function(CodeMirror, xhr, Button) {
						let editor;
						xhr("<%= templatePath %>", {}).then(function(data) {
							document.getElementById("templateEditor_<%= websiteId %>_<%= templateId %>").value = data;
							editor = CodeMirror.fromTextArea(document.getElementById('templateEditor_<%= websiteId %>_<%= templateId %>'),
 							{
								mode: "text/html",
								//lineNumbers: true,
        						//smartIndent: true,
        						//matchBrackets: true,
        						//autoCloseBrackets: true,
        						//styleActiveLine: true,
        						//continueComments: true,
        						//gutters: ["CodeMirror-lint-markers"],
								scrollbarStyle: "simple",
								fixedGutter: true
        						//lint: true,
							});
						});
					});
					</script>
				</div>
				<div dojoType="dojox.layout.ContentPane">
					<iframe id="preview_<%= websiteId %>_<%= templateId %>" style="width:100%; height:100%"></iframe>
				</div>
			</div>
		</div>
	</div>
