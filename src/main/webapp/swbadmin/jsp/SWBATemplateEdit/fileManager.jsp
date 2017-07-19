<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Iterator, org.semanticwb.portal.SWBUtilTag, org.semanticwb.portal.util.SWBIFMethod, java.util.HashMap, java.net.URLEncoder, org.semanticwb.SWBPortal, org.semanticwb.portal.api.*, org.semanticwb.model.*, org.semanticwb.SWBPlatform" %>
<%
	if (null == SWBContext.getAdminUser()) return; //Exit inmediately if not admin user

	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	String templateId = (String) request.getAttribute("templateId");
	String websiteId = (String) request.getAttribute("webSiteId");
	int verNum = (Integer) request.getAttribute("verNum");
	WebSite site = SWBContext.getWebSite(websiteId);
	User user = paramRequest.getUser();

	Template template = site.getTemplate(templateId);
%>
<html>
  <head>
    <meta charset="utf-8">
    <title>Explorador de archivos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=2" />
    <link rel="stylesheet" type="text/css" href="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/css/jquery-ui.css">
    <script src="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/js/jquery.min.js"></script>
    <script src="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/js/jquery-ui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/css/elfinder.min.css">
    <link rel="stylesheet" type="text/css" href="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/css/theme.css">
    <script src="<%= SWBPortal.getContextPath() %>/swbadmin/js/elfinder/js/elfinder.min.js"></script>
    <script type="text/javascript" charset="utf-8">
    	let $fileExplorer_<%= websiteId %>_<%= templateId %>;
    	let  $window = $(window);

      $(document).ready(function() {
        $fileExplorer_<%= websiteId %>_<%= templateId %> = $('#elfinder_<%= websiteId %>_<%= templateId %>').elfinder({
          url : '<%= SWBPlatform.getContextPath() %>/elFinderConnector',  // connector URL (REQUIRED)
          resizable: true,
          height: $window.height(),
          resourceId : '<%= paramRequest.getResourceBase().getId() %>',
          resourcePath : '<%= paramRequest.getResourceBase().getSemanticObject().getWorkPath() %>',
          customData : {site : '<%= site.getId() %>', template:'<%= templateId %>', version: '<%= verNum %>'}
        });
      });

			$window.resize(function() {
     		var win_height = $window.height();
     		if( $("#elfinder_<%= websiteId %>_<%= templateId %>").height() != win_height ){
           $fileExplorer_<%= websiteId %>_<%= templateId %> && $fileExplorer_<%= websiteId %>_<%= templateId %>.resize('auto',win_height);
     		}
 			});

 			window.addEventListener("unload", function() {
 				let win = window.opener;
 				if (win && !win.closed) {
 					win.toggleBrowserButton_<%= websiteId %>_<%= templateId %>(true);
 				}
 			});
    </script>
    <style type="text/css">
    	body {
    		margin: 0px;
    	}

    	#elfinder_<%= websiteId %>_<%= templateId %> {
    		width: 100%;
    		min-width: 100%;
    		height: 100% !important;
    	}

    	.ui-resizable-handle { display:none !important; }

    	.elfinder-navbar-dir, .elfinder-button-search input {
    		outline: 0;
    	}
    </style>
  </head>
  <body>
    <div id="elfinder_<%= websiteId %>_<%= templateId %>"></div>
  </body>
</html>
