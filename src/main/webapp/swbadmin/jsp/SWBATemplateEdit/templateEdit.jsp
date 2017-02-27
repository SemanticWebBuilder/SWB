<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Iterator, org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
//topicmapId - website
//template id
//session
//int version

	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String templateId = (String) request.getAttribute("templateId");
	String websiteId = (String) request.getAttribute("webSiteId");
	int verNum = (Integer) request.getAttribute("verNum");
	WebSite site = SWBContext.getWebSite(websiteId);
	User user = paramRequest.getUser();
	
	Iterator<ResourceType> rtypes = site.listResourceTypes();
	while(rtypes.hasNext()) {
		ResourceType rtype = rtypes.next();
		if (user.haveAccess(rtype) && rtype.getResourceMode() == ResourceType.MODE_STRATEGY || rtype.getResourceMode() == ResourceType.MODE_SYSTEM) {
			System.out.println(rtype.getTitle());
			Iterator<ResourceSubType> rsubtypes = rtype.listSubTypes();
			while (rsubtypes.hasNext()) {
				ResourceSubType rsubtype = rsubtypes.next();
				if (user.haveAccess(rtype)) {
					System.out.println("  "+rsubtype.getTitle());
				}
			}
		}
	}
	
	Template template = site.getTemplate(templateId);
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
			<button id="newButton_<%= websiteId %>_<%= templateId %>" type="button"></button>
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
						"dijit/form/Button",
						"dijit/form/ToggleButton",
						"codemirror/mode/xml/xml",
						"codemirror/mode/javascript/javascript",
						"codemirror/mode/css/css",
						"codemirror/mode/htmlmixed/htmlmixed",
						"codemirror/addon/scroll/simplescrollbars",
						"codemirror/addon/edit/closetag"],
						function(CodeMirror, xhr, Button, ToggleButton) {
							let editor_<%= websiteId %>_<%= templateId %>;

							acceptNewTemplate = function() {
								editor_<%= websiteId %>_<%= templateId %>.setValue("");
								newTemplateDialog_<%= websiteId %>_<%= templateId %>.hide();
							}

							new Button({
								iconClass: "dijitEditorIcon dijitEditorIconNewPage",
								showLabel: false,
								onClick: function(evt) {
									newTemplateDialog_<%= websiteId %>_<%= templateId %>.show();
								}
							},"newButton_<%= websiteId %>_<%= templateId %>").startup();

							xhr("<%= templatePath %>", {}).then(function(data) {
								document.getElementById("templateEditor_<%= websiteId %>_<%= templateId %>").value = data;
								editor_<%= websiteId %>_<%= templateId %> = CodeMirror.fromTextArea(document.getElementById('templateEditor_<%= websiteId %>_<%= templateId %>'),
 								{
									mode: "text/html",
									autoCloseTags: true,
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
	<div data-dojo-type="dijit/Dialog" data-dojo-id="newTemplateDialog_<%= websiteId %>_<%= templateId %>" title="<%= paramRequest.getLocaleString("lblNewTemplate") %>">
	   	<div class="dijitDialogPaneContentArea">
	       	<p><%= paramRequest.getLocaleString("msgConfirmNew") %></p>
	   	</div>
	   	<div class="dijitDialogPaneActionBar">
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){acceptNewTemplate();}"><%= paramRequest.getLocaleString("lblOk") %></button>
	       	<button data-dojo-type="dijit/form/Button" type="button" data-dojo-props="onClick:function(){newTemplateDialog_<%= websiteId %>_<%= templateId %>.hide();}"><%= paramRequest.getLocaleString("lblCancel") %></button>
	   	</div>
	</div>
</div>
