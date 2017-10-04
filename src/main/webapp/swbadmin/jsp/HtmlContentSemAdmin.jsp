<%@page import="org.semanticwb.portal.api.SWBResourceURLImp"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.portal.resources.sem.HTMLContent"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURLImp url = (SWBResourceURLImp) paramRequest.getRenderUrl();
    url.setCallMethod(SWBResourceURLImp.Call_DIRECT);
    url.setMode("saveContent");
    String action = (request.getParameter("tmpPath") != null) ? "tmp" : "";
    int version = (request.getParameter("numversion") != null && !"".equals(request.getParameter("numversion")))
            ? Integer.parseInt(request.getParameter("numversion"))
            : 1;
    String message = request.getParameter("message");
    String content = (String) request.getAttribute("fileContent");
    String lang = "es";
    if (null != paramRequest.getUser() && null != paramRequest.getUser().getLanguage()) {
        lang = paramRequest.getUser().getLanguage();
    }
    SWBResourceURLImp urlNewVersion = (SWBResourceURLImp) paramRequest.getRenderUrl();
    urlNewVersion.setCallMethod(SWBResourceURLImp.Call_DIRECT);
    urlNewVersion.setMode("selectFileInterface");
    urlNewVersion.setParameter("numversion", Integer.toString(version));
    urlNewVersion.setParameter("type", "image");

    SWBResourceURL uploadURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    uploadURL.setMode(HTMLContent.MOD_UPLOADFILE);
    uploadURL.setAction(HTMLContent.ACT_UPLOADFILE);
    uploadURL.setParameter("numversion", String.valueOf(version));
    uploadURL.setParameter("type", HTMLContent.TYPE_IMAGES);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
        <title>HTML Content Editor</title>
        <script src="<%= SWBPlatform.getContextPath() %>/swbadmin/js/ckeditor/ckeditor.js"></script>
    </head>
    <body>
        <form action="<%=url.toString()%>" method="post">
            <textarea name="EditorDefault" id="EditorDefault"><%= content %></textarea>
            <input type="hidden" name="operation" value="<%=action%>" />
            <input type="hidden" name="numversion" value="<%=version%>" />
            <input type="hidden" name="suri" value="<%=request.getParameter("suri")%>" />
        </form>
        <%
        if (message != null && !"".equals(message)) {
            %>
            <script type="text/javascript">
                alert("<%=message%>");
            </script>
            <%
        }
        %>
        <script>
        (function() {
          var editor = CKEDITOR.replace( 'EditorDefault', {
                language:'<%= lang %>',
                //allowedContent: true,
                extraAllowedContent: 'article[*];aside[*];details[*];figcaption[*];figure[*];footer[*];header[*];main[*];mark[*];nav[*];section[*];summary[*];time',
                skin:'office2013',
                height: 450,
                filebrowserImageBrowseUrl:'<%= urlNewVersion %>',
                filebrowserImageUploadUrl: '<%= uploadURL %>',
                <%
                uploadURL.setParameter("type", HTMLContent.TYPE_FLASH);
                urlNewVersion.setParameter("type", HTMLContent.TYPE_FLASH);
                %>
                filebrowserFlashBrowseUrl:'<%= urlNewVersion %>',
                filebrowserFlashUploadUrl: '<%= uploadURL %>',
                <%
                uploadURL.setParameter("type", HTMLContent.TYPE_ALL);
                urlNewVersion.setParameter("type", HTMLContent.TYPE_ALL);
                %>
                filebrowserLinkBrowseUrl: '<%= urlNewVersion %>',
                filebrowserLinkUploadUrl: '<%= uploadURL %>'
            });
            CKEDITOR.dtd.$removeEmpty.span = 0; //Prevent removing empty span tags
            CKEDITOR.dtd.$removeEmpty.i = 0; //Prevent removing empty i tags
            //Increase dialog width
            CKEDITOR.on( 'dialogDefinition', function( ev ) {
                if ( ev.data.name === 'link' || ev.data.name === 'image')
                    ev.data.definition.width = 550;
            });
            //Override to allow all properties and all tags
            CKEDITOR.config.allowedContent = true;
        })();
        </script>
    </body>
</html>
